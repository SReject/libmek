/*TODO:
while statements
repeat statements
goto statements
do ... end block

variable renaming for parameters and local vars
*/

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
        const nameParts = [];
        for (const part of entity.variables) {
            nameParts.push(processEntity(scope, part));
        }

        const valueParts = [];
        for (const part of entity.init) {
            valueParts.push(processEntity(scope, part));
        }

        return `${nameParts.join(',')}=${valueParts.join(',')}`
    },

    'BinaryExpression': (scope, entity) => {
        const left = processEntity(scope, entity.left);
        const right = processEntity(scope, entity.right);
        return `${left}${entity.operator}${right}`;
    },

    'CallExpression': (scope, entity) => {
        const expression = processEntity(scope, entity.base, true);
        const parts = [];
        for (const part of entity.arguments) {
            parts.push(processEntity(scope, part));
        }

        return `${expression}(${parts.join(',')})`;
    },

    'CallStatement': (scope, entity) => {
        return processEntity(scope, entity.expression);
    },

    'ElseClause': (scope, entity) => {

        scope = scope.createChild();

        const parts = [];
        for (const part of entity.body) {
            parts.push(processEntity(scope, part));
        }
        if (parts.length) {
            return `else\n${parts.join('\n')}`;
        }
        return 'else';
    },

    'ElseifClause': (scope, entity) => {
        let condition = processEntity(scope, entity.condition);

        scope = scope.createChild();

        const parts = [];
        for (const part of entity.body) {
            parts.push(processEntity(scope, part));
        }
        if (parts.length) {
            return `elseif ${condition} then\n${parts.join('\n')}`
        }
        return `elseif ${condition} then`
    },

    'ForGenericStatement': (scope, entity) => {
        scope = scope.createChild();

        const varList = [];
        for (const part of entity.variables) {
            varList.push(processEntity(scope, part));
        }

        const iterList = [];
        for (const part of entity.iterators) {
            iterList.push(processEntity(scope, part));
        }

        const body = [];
        for (const part of entity.body) {
            body.push(processEntity(scope, part));
        }

        return `for ${varList.join(',')} in ${iterList.join(',')} do\n${body.join('\n')}\nend`;
    },

    'FunctionDeclaration': (scope, entity, wrap) => {
        const name = entity.identifier ? processEntity(scope, entity.identifier) : '';

        scope = scope.createChild();

        const params = [];
        for (const part of entity.parameters) {
            params.push(processEntity(scope, part));
        }

        const body = []
        for (const part of entity.body) {
            body.push(processEntity(scope, part));
        }

        let res = ""
        if (entity.isLocal) {
            res += "local ";
        }
        res += "function "

        res += `${name}(${params.join(',')})`;

        if (body.length) {
            res += `\n${body.join('\n')}\n`;
        } else {
            res += ' '
        }
        res += 'end';
        if (wrap) {
            return `(${res})`;
        }
        return res;
    },

    'Identifier': (scope, entity) => {
        return entity.name;
    },

    'IfClause': (scope, entity) => {
        let condition = processEntity(scope, entity.condition);

        scope = scope.createChild();

        const parts = [];
        for (const part of entity.body) {
            parts.push(processEntity(scope, part));
        }

        if (parts.length) {
            return `if ${condition} then\n${parts.join('\n')}`
        }

        return `if ${condition} then`
    },

    'IfStatement': (scope, entity) => {
        const parts = [];
        for (const part of entity.clauses) {
            parts.push(processEntity(scope, part));
        }

        return `${parts.join('\n')}\nend`;
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

    'LocalStatement': (scope, entity) => {
        const nameParts = [];
        for (const part of entity.variables) {
            nameParts.push(processEntity(scope, part));
        }

        if (!entity.init || !entity.init.length) {
            return `local ${nameParts.join(',')};`
        }

        const initParts = [];
        for (const part of entity.init) {
            initParts.push(processEntity(scope, part));
        }

        return `local ${nameParts.join(',')}=${initParts.join(',')}`
    },

    'MemberExpression': (scope, entity) => {
        const subject = processEntity(scope, entity.base);
        const member = processEntity(scope, entity.identifier);
        return `${subject}${entity.indexer}${member}`;
    },

    'ReturnStatement': (scope, entity) => {
        const parts = [];
        for (const part of entity.arguments) {
            parts.push(processEntity(scope, part));
        }
        return `return ${parts.join(',')}`;
    },

    'TableConstructorExpression': (scope, entity) => {
        const parts = [];
        for (const part of entity.fields) {
            parts.push(processEntity(scope, part))
        }
        return `{${parts.join(',')}}`;
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
    }
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

module.exports = (content) => {
    const scope = new Scope();
    return luaparse
        .parse(content)
        .body
        .map(entry => processEntity(scope, entry))
        .join('\n');
};