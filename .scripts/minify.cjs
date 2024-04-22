const luaparse = require('luaparse');


const handlers = {
    'BooleanLiteral': (entity) => {
        return entity.raw;
    },
    'NilLiteral': (entity) => {
        return 'nil';
    },
    'NumericalLiteral': (entity) => {
        return value.raw;
    },
    'StringLiteral': (entity) => {
        return entity.raw;
    },
    'VarargLiteral': (entity) => {
        return entity.value;
    },

    'AssignmentStatement': (entity) => {
        const nameParts = [];
        for (const part of entity.variables) {
            nameParts.push(processEntity(part));
        }

        const valueParts = [];
        for (const part of entity.init) {
            valueParts.push(processEntity(part));
        }

        return `${nameParts.join(',')}=${valueParts.join(',')}`
    },

    'BinaryExpression': (entity) => {
        const left = processEntity(entity.left);
        const right = processEntity(entity.right);
        return `${left}${entity.operator}${right}`;
    },
    'CallExpression': (entity) => {
        const expression = processEntity(entity.base, true);
        const parts = [];
        for (const part of entity.arguments) {
            parts.push(processEntity(part));
        }

        return `${expression}(${parts.join(',')})`;
    },

    'CallStatement': (entity) => {
        return processEntity(entity.expression);
    },

    'ElseClause': (entity) => {
        const parts = [];
        for (const part of entity.body) {
            parts.push(processEntity(part));
        }
        if (parts.length) {
            return `else\n${parts.join('\n')}`;
        }
        return 'else';
    },

    'ElseifClause': (entity) => {
        let condition = processEntity(entity.condition);

        const parts = [];
        for (const part of entity.body) {
            parts.push(processEntity(part));
        }
        if (parts.length) {
            return `elseif ${condition} then\n${parts.join('\n')}`
        }
        return `elseif ${condition} then`
    },

    'ForGenericStatement': (entity) => {
        const varList = [];
        for (const part of entity.variables) {
            varList.push(processEntity(part));
        }

        const iterList = [];
        for (const part of entity.iterators) {
            iterList.push(processEntity(part));
        }

        const body = [];
        for (const part of entity.body) {
            body.push(processEntity(part));
        }

        return `for ${varList.join(',')} in ${iterList.join(',')} do\n${body.join('\n')}\nend`;
    },

    'FunctionDeclaration': (entity, wrap) => {
        const isLocal = entity.isLocal ? 'local' : '';
        const name = entity.identifier ? processEntity(entity.identifier) : '';

        const params = [];
        for (const part of entity.parameters) {
            params.push(processEntity(part));
        }

        const body = []
        for (const part of entity.body) {
            body.push(processEntity(part));
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

    'Identifier': (entity) => {
        return entity.name;
    },

    'IfClause': (entity) => {
        let condition = processEntity(entity.condition);

        const parts = [];
        for (const part of entity.body) {
            parts.push(processEntity(part));
        }

        if (parts.length) {
            return `if ${condition} then\n${parts.join('\n')}`
        }

        return `if ${condition} then`
    },

    'IfStatement': (entity) => {
        const parts = [];
        for (const part of entity.clauses) {
            parts.push(processEntity(part));
        }

        return `${parts.join('\n')}\nend`;
    },

    'IndexExpression': (entity) => {
        const name = processEntity(entity.base);
        const value = processEntity(entity.index);
        return `${name}[${value}]`
    },

    'LogicalExpression': (entity) => {
        const left = processEntity(entity.left);
        const right = processEntity(entity.right);

        return `(${left} ${entity.operator} ${right})`;
    },

    'LocalStatement': (entity) => {
        const nameParts = [];
        for (const part of entity.variables) {
            nameParts.push(processEntity(part));
        }

        if (!entity.init || !entity.init.length) {
            return `local ${nameParts.join(',')};`
        }

        const initParts = [];
        for (const part of entity.init) {
            initParts.push(processEntity(part));
        }

        return `local ${nameParts.join(',')}=${initParts.join(',')}`
    },

    'MemberExpression': (entity) => {
        const subject = processEntity(entity.base);
        const member = processEntity(entity.identifier);
        return `${subject}${entity.indexer}${member}`;
    },

    'ReturnStatement': (entity) => {
        const parts = [];
        for (const part of entity.arguments) {
            parts.push(processEntity(part));
        }
        return `return ${parts.join(',')}`;
    },

    'TableConstructorExpression': (entity) => {
        const parts = [];
        for (const part of entity.fields) {
            parts.push(processEntity(part))
        }
        return `{${parts.join(',')}}`;
    },

    'TableKey': (entity) => {
        const key = processEntity(entity.key);
        const table = processEntity(entity.value);
        return `${table}[${key}]`;
    },

    'TableKeyString': (entity) => {
        const value = processEntity(entity.value);
        return `${entity.key.name}=${value}`;
    },

    'TableValue': (entity) => {
        return processEntity(entity.value);
    },
    'UnaryExpression': (entity) => {
        return `${entity.operator}${processEntity(entity.argument)}`;
    }
}

const processEntity = (entity, ...args) => {
    let result = "";
    if (handlers[entity.type]) {
        result = handlers[entity.type](entity, ...args)

    } else {
        throw new Error('unknown entity:', entity.type);
    }
    return result;
};

module.exports = (content) => {
    let ast = luaparse.parse(content);
    const output = [];

    for (const entity of ast.body) {
        output.push(processEntity(entity));
    }
    return output.join('\n');
};