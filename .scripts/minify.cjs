//TODO: variable renaming for parameters and local vars

const luaparse = require('luaparse');

class Scope {
    constructor(parent) {
        if (parent) {
            this.parent = parent;
            this.renamed = new Map(parent.remap);
            this.renameIndex = parent.renameIndex;
        } else {
            this.parent = null;
            this.renamed = new Map();
            this.renameIndex = 0;
        }
    }
    createChild() {
        return new Scope(this);
    }
    getName(name) {
        if (this.renamed.has(name)) {
            return this.renamed.get(name);
        }
        return name;
    }
    getNameOf(entity) {
        if (entity.type !== 'Identifier') {
            return entity.name;
        }
        return this.getName(entity.name);
    }

    // Allows for 2703 vars to be renamed at any given scope
    rename(name) {
        const chars = 'abcdefghiklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        let newName = '';
        if (this.renameIndex < chars.length) {
            newName = chars[this.renameIndex];
        } else {
            const c1 = Math.floor(this.renameIndex / 56);
            const c2 = this.renameIndex - (c1 * 56);
            newName = `${chars[c1 - 1]}${chars[c2]}`;
        }
        this.renamed.set(name, newName);
        this.renameIndex += 1;
        return newName
    }
}

const handlers = {

    // Literal Tokens
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


    // Meta Tokens
    'Identifier': (scope, entity) => {
        return entity.name;
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


    // General Statement Tokens
    'AssignmentStatement': (scope, entity) => {
        const variables = processEntityList(scope, entity.variables);
        const init = processEntityList(scope, entity.init);
        return `${variables.join(',')}=${init.join(',')}`
    },
    'BreakStatement': (scope, entity) => {
        return 'break';
    },
    'CallStatement': (scope, entity) => {
        return processEntity(scope, entity.expression);
    },
    'GotoStatement': (scope, entity) => {
        const label = processEntity(scope, entity.label);
        return `goto ${label}`;
    },
    'LabelStatement': (scope, entity) => {
        const label = processEntity(scope, entity.label);
        return `::${label}::`
    },
    'ReturnStatement': (scope, entity) => {
        const parameters = processEntityList(scope, entity.arguments);
        return `return ${parameters.join(',')}`;
    },

    // Block Statement Tokens
    'IfStatement': (scope, entity) => {
        const clauses = entity.clauses.map(entity => {
            if (entity.type === 'IfClause') {
                const condition = processEntity(scope, entity.condition);
                if (entity.body.length) {
                    const body = processEntityList(scope.createChild(), entity.body);
                    return `if ${condition} then\n${body.join('\n')}`
                }
                return `if ${condition} then`

            } else if (entity.type === 'ElseifClause') {
                const condition = processEntity(scope, entity.condition);
                if (entity.body.length) {
                    const body = processEntityList(scope.createChild(), entity.body);
                    return `elseif ${condition} then\n${body.join('\n')}`
                }
                return `elseif ${condition} then`;

            } else {
                if (entity.body.length) {
                    const body = processEntityList(scope.createChild(), entity.body);
                    return `else\n${body.join('\n')}`;
                }
                return 'else';
            }
        });
        return `${clauses.join('\n')}\nend`;
    },
    'DoStatement': (scope, entity) => {
        if (entity.body) {
            const body = processEntityList(scope.createChild(), entity.body);
            return `do\n${body}\end`;
        }
        return 'do end';
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
    'LocalStatement': (scope, entity) => {
        const variables = processEntityList(scope, entity.variables);
        if (!entity.init || !entity.init.length) {
            return `local ${variables.join(',')}`
        }

        const init = processEntityList(scope, entity.init);
        return `local ${variables.join(',')}=${init.join(',')}`
    },
    'RepeatStatement': (scope, entity) => {
        const condition = processEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(scope.createChild, entity.body);
            return `repeat\n${body}\nuntil ${condition}`;
        }
        return `repeat until ${condition}`;
    },
    'WhileStatement': (scope, entity) => {
        const condition = processEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(scope.createChild(), entity.body);
            return `while ${condition} do\n${body}\nend`
        }
        return `while ${condition} do end`;
    },


    // Expression Tokens
    'BinaryExpression': (scope, entity) => {
        const left = processEntity(scope, entity.left);
        const right = processEntity(scope, entity.right);
        return `${left}${entity.operator}${right}`;
    },
    'CallExpression': (scope, entity) => {
        const expression = processEntity(scope, entity.base, true);
        const parameters = processEntityList(scope, entity.arguments);
        return `${expression}(${parameters.join(',')})`;
    },
    'IndexExpression': (scope, entity) => {
        const name = processEntity(scope, entity.base);
        const value = processEntity(scope, entity.index);
        return `${name}[${value}]`
    },
    'LogicalExpression': (scope, entity) => {
        const left = processEntity(scope, entity.left);
        const right = processEntity(scope, entity.right);
        return `(${left} ${entity.operator} ${right})`;
    },
    'MemberExpression': (scope, entity) => {
        const subject = processEntity(scope, entity.base);
        const member = processEntity(scope, entity.identifier);
        return `${subject}${entity.indexer}${member}`;
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
    'UnaryExpression': (scope, entity) => {
        return `${entity.operator}${processEntity(scope, entity.argument)}`;
    }
};

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