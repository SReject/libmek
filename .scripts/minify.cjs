//TODO: Rename local singleton functions

const luaparse = require('luaparse');

class Scope {
    constructor(parent) {
        if (parent) {
            this.parent = parent;
            this.renamed = new Map(parent.renamed);
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

    getEntity(entity, ...args) {
        if (entity.type === 'Identifier') {
            return this.getName(entity.name);
        }
        return processEntity(this, entity, ...args);
    }

    // Allows for 2703 vars to be renamed at any given scope
    rename(name) {
        if (name === 'self' || name === '...') {
            return name;
        }

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
        const table = scope.getEntity(entity.value);
        const key = scope.getEntity(entity.key);
        return `${table}[${key}]`;
    },
    'TableKeyString': (scope, entity) => {
        const key = scope.getEntity(entity.key);
        const value = scope.getEntity(entity.value);
        return `${entity.key.name}=${value}`;
    },
    'TableValue': (scope, entity) => {
        return scope.getEntity(entity.value);
    },


    // General Statement Tokens
    'AssignmentStatement': (scope, entity) => {
        const variables = processEntityList(scope, entity.variables, (scope, entity) => scope.getEntity(entity));
        const init = processEntityList(scope, entity.init, (scope, entity) => scope.getEntity(entity));
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
    'LocalStatement': (scope, entity) => {
        const variables = processEntityList(scope, entity.variables, (scope, entity) => scope.rename(entity.name));
        if (!entity.init || !entity.init.length) {
            return `local ${variables.join(',')}`
        }
        const init = processEntityList(scope, entity.init, (scope, entity) => scope.getEntity(entity));
        return `local ${variables.join(',')}=${init.join(',')}`
    },
    'ReturnStatement': (scope, entity) => {
        const parameters = processEntityList(scope, entity.arguments, (scope, entity) => scope.getEntity(entity));
        return `return ${parameters.join(',')}`;
    },

    // Block Statement Tokens
    'IfStatement': (scope, entity) => {
        const clauses = entity.clauses.map(entity => {

            if (entity.type === 'IfClause') {
                const condition = scope.getEntity(entity.condition);
                if (entity.body.length) {
                    const body = processEntityList(
                        scope.createChild(),
                        entity.body,
                        (scope, entity) => scope.getEntity(entity)
                    );
                    return `if ${condition} then\n${body.join('\n')}`
                }
                return `if ${condition} then`

            } else if (entity.type === 'ElseifClause') {
                const condition = scope.getEntity(entity.condition);
                if (entity.body.length) {
                    const body = processEntityList(
                        scope.createChild(),
                        entity.body,
                        (scope, entity) => scope.getEntity(entity)
                    );
                    return `elseif ${condition} then\n${body.join('\n')}`
                }
                return `elseif ${condition} then`;

            } else {
                if (entity.body.length) {
                    const body = processEntityList(
                        scope.createChild(),
                        entity.body,
                        (scope, entity) => scope.getEntity(entity)
                    );
                    return `else\n${body.join('\n')}`;
                }
                return 'else';
            }
        });
        return `${clauses.join('\n')}\nend`;
    },
    'DoStatement': (scope, entity) => {
        if (entity.body) {
            const body = processEntityList(
                scope.createChild(),
                entity.body,
                (scope, entity) => scope.getEntity(entity)
            );
            return `do\n${body}\end`;
        }
        return 'do end';
    },
    'ForGenericStatement': (scope, entity) => {
        scope = scope.createChild();
        const variables = processEntityList(
            scope,
            entity.variables,
            (scope, entity) => {
                if (entity.type === 'Identifier') {
                    return scope.rename(entity.name);
                }
                return processEntity(scope, entity)
            }
        );
        const iterators = processEntityList(
            scope,
            entity.iterators,
            (scope, entity) => scope.getEntity(entity)
        );
        const body = processEntityList(scope, entity.body);
        return `for ${variables.join(',')} in ${iterators.join(',')} do\n${body.join('\n')}\nend`;
    },
    'FunctionDeclaration': (scope, entity, wrap) => {
        let name = '';
        if (entity.identifier) {
            name = scope.getEntity(entity.identifier);
        }
        scope = scope.createChild();
        const params = processEntityList(
            scope,
            entity.parameters,
            (scope, entity) => {
                if (entity.type === 'Identifier') {
                    return scope.rename(entity.name)
                }
                return processEntity(scope, entity)
            }
        );
        const body = processEntityList(
            scope,
            entity.body,
            (scope, entity) => scope.getEntity(entity)
        );

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
    'RepeatStatement': (scope, entity) => {
        const condition = scope.getEntity(scope, entity.condition);
        if (entity.body.length) {
            const body = processEntityList(
                scope.createChild(),
                entity.body,
                (scope, entity) => scope.getEntity(entity)
            );
            return `repeat\n${body}\nuntil ${condition}`;
        }
        return `repeat until ${condition}`;
    },
    'WhileStatement': (scope, entity) => {
        const condition = scope.getEntity(entity.condition);
        if (entity.body.length) {
            const body = processEntityList(
                scope.createChild(),
                entity.body,
                (scope, entity) => scope.getEntity(entity)
            );
            return `while ${condition} do\n${body}\nend`
        }
        return `while ${condition} do end`;
    },


    // Expression Tokens
    'BinaryExpression': (scope, entity) => {
        const left = scope.getEntity(entity.left);
        const right = scope.getEntity(entity.right);
        return `${left}${entity.operator}${right}`;
    },
    'CallExpression': (scope, entity) => {
        const expression = scope.getEntity(entity.base, true);
        const parameters = processEntityList(
            scope,
            entity.arguments,
            (scope, entity) => scope.getEntity(entity)
        );
        return `${expression}(${parameters.join(',')})`;
    },
    'IndexExpression': (scope, entity) => {
        const name = scope.getEntity(entity.base);
        const value = scope.getEntity(entity.index);
        return `${name}[${value}]`
    },
    'LogicalExpression': (scope, entity) => {
        const left = scope.getEntity(entity.left);
        const right = scope.getEntity(entity.right);
        return `(${left} ${entity.operator} ${right})`;
    },
    'MemberExpression': (scope, entity) => {
        const subject = scope.getEntity(entity.base);
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
        return `${entity.operator}${scope.getEntity(entity.argument)}`;
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