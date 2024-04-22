//TODO: variable renaming for parameters and local vars

const luaparse = require('luaparse');

class Scope {
    constructor(parent) {
        if (parent) {
            this.parent = parent;
        } else {
            this.parent = null;
        }
    }
    createChild() {
        return new Scope(this);
    }
}

const handlers = {
    'NilLiteral': (scope, entity) => {
        return 'nil';
    },

    'BooleanLiteral': (scope, entity) => {
        return entity.raw;
    },

    'NumericalLiteral': (scope, entity) => {
        return value.raw;
    },

    'StringLiteral': (scope, entity) => {
        return entity.raw;
    },

    'VarargLiteral': (scope, entity) => {
        return entity.value;
    },

    'AssignmentStatement': (scope, entity) => {
        const variables = processEntityList(scope, entity.variables);
        const init = processEntityList(scope, entity.init);
        return `${variables.join(',')}=${init.join(',')}`
    },

    'BinaryExpression': (scope, entity) => {
        const left = processEntity(scope, entity.left);
        const right = processEntity(scope, entity.right);
        return `${left}${entity.operator}${right}`;
    },

    'BreakStatement': (scope, entity) => {
        return 'break';
    },

    'CallExpression': (scope, entity) => {
        const expression = processEntity(scope, entity.base, true);
        const parameters = processEntityList(scope, entity.arguments);
        return `${expression}(${parameters.join(',')})`;
    },

    'CallStatement': (scope, entity) => {
        return processEntity(scope, entity.expression);
    },

    'DoStatement': (scope, entity) => {
        if (entity.body) {
            const body = processEntityList(scope, entity.body);
            return `do\n${body}\end`;
        }
        return 'do end';
    },

    'ElseClause': (scope, entity) => {
        if (entity.body.length) {
            const body = processEntityList(scope.createChild(), entity.body);
            return `else\n${body.join('\n')}`;
        }
        return 'else';
    },

    'ElseifClause': (scope, entity) => {
        const condition = processEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(scope.createChild(), entity.body);
            return `elseif ${condition} then\n${body.join('\n')}`
        }
        return `elseif ${condition} then`
    },

    'ForGenericStatement': (scope, entity) => {
        scope = scope.createChild();
        const variables = processEntityList(scope, entity.variables);
        const iterators = processEntityList(scope, entity.iterators);
        const body = processEntityList(scope, entity.body);
        return `for ${variables.join(',')} in ${iterators.join(',')} do\n${body.join('\n')}\nend`;
    },

    'FunctionDeclaration': (scope, entity, wrap) => {
        const name = entity.identifier ? processEntity(scope, entity.identifier) : '';

        scope = scope.createChild();
        const params = processEntityList(scope, entity.parameters);
        const body = processEntityList(scope, entity.body);

        let res = `${entity.isLocal ? 'local ' : ''}function ${name}(${params.join(',')})`;
        if (body.length) {
            res += `\n${body.join('\n')}\nend`;
        } else {
            res += ' end'
        }
        if (wrap) {
            return `(${res})`;
        }
        return res;
    },

    'GotoStatement': (scope, entity) => {
        const label = processEntity(scope, entity.label);
        return `goto ${label}`;
    },

    'Identifier': (scope, entity) => {
        return entity.name;
    },

    'IfClause': (scope, entity) => {
        const condition = processEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(scope.createChild(), entity.body);
            return `if ${condition} then\n${body.join('\n')}`
        }
        return `if ${condition} then`
    },

    'IfStatement': (scope, entity) => {
        const clauses = processEntityList(scope, entity.clauses);
        return `${clauses.join('\n')}\nend`;
    },

    'IndexExpression': (scope, entity) => {
        const name = processEntity(scope, entity.base);
        const value = processEntity(scope, entity.index);
        return `${name}[${value}]`
    },

    'LabelStatement': (scope, entity) => {
        const label = processEntity(scope, entity.label);
        return `::${label}::`
    },

    'LogicalExpression': (scope, entity) => {
        const left = processEntity(scope, entity.left);
        const right = processEntity(scope, entity.right);
        return `(${left} ${entity.operator} ${right})`;
    },

    'LocalStatement': (scope, entity) => {
        const variables = processEntityList(scope, entity.variables);
        if (!entity.init || !entity.init.length) {
            return `local ${variables.join(',')}`
        }

        const init = processEntityList(scope, entity.init);
        return `local ${variables.join(',')}=${init.join(',')}`
    },

    'MemberExpression': (scope, entity) => {
        const subject = processEntity(scope, entity.base);
        const member = processEntity(scope, entity.identifier);
        return `${subject}${entity.indexer}${member}`;
    },

    'RepeatStatement': (scope, entity) => {
        const condition = processEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(scope.createChild, entity.body);
            return `repeat\n${body}\nuntil ${condition}`;
        }
        return `repeat until ${condition}`;
    },

    'ReturnStatement': (scope, entity) => {
        const parameters = processEntityList(scope, entity.arguments);
        return `return ${parameters.join(',')}`;
    },

    'StringCallExpression': (scope, entity) => {
        const base = processEntity(scope, entity.base);
        const arg = processEntity(scope, entity.argument);
        return `${base} ${arg}`;
    },

    'TableConstructorExpression': (scope, entity) => {
        const fields = processEntityList(scope, entity.fields);
        return `{${fields.join(',')}}`;
    },

    'TableKey': (scope, entity) => {
        const key = processEntity(scope, entity.key);
        const table = processEntity(scope, entity.value);
        return `${table}[${key}]`;
    },

    'TableKeyString': (scope, entity) => {
        const value = processEntity(scope, entity.value);
        return `${entity.key.name}=${value}`;
    },

    'TableValue': (scope, entity) => {
        return processEntity(scope, entity.value);
    },

    'UnaryExpression': (scope, entity) => {
        return `${entity.operator}${processEntity(scope, entity.argument)}`;
    },

    'WhileStatement': (scope, entity) => {
        const condition = processEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(scope.createChild(), entity.body);
            return `while ${condition} do\n${body}\nend`
        }
        return `while ${condition} do end`;
    },
}

const processEntity = (scope, entity, ...args) => {
    let result = "";
    if (handlers[entity.type]) {
        result = handlers[entity.type](scope, entity, ...args)

    } else {
        throw new Error('unknown entity:', entity.type);
    }
    return result;
};

const processEntityList = (scope, entities, cb, ...args) => {
    if (cb == null) {
        cb = (scope, entity, ...args) => processEntity(scope, entity, ...args);
    }
    return entities.map(entity => cb(scope, entity, ...args));
}

module.exports = (content) => processEntityList(new Scope(), luaparse.parse(content).body).join('\n');