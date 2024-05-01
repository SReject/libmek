const { join, resolve } = require('path');
const { mkdirSync, readFileSync, writeFileSync } = require('fs');
const luaparse = require('luaparse');
const astToLua = require('./ast-to-lua.cjs');

let requires = [];

const files = ['libmek'];

// Override 'require()'
let orgCallExpression = luaparse.ast.callExpression;
luaparse.ast.callExpression = (...args) => {
    let node = orgCallExpression(...args);
    if (
        node.base &&
        node.base.type === 'Identifier' &&
        node.base.name === 'require' &&
        node.arguments &&
        node.arguments.length == 1 &&
        node.arguments[0].type === 'StringLiteral'
    ) {
        let moduleName = node.arguments[0].raw.replace(/["']/g, '');
        files.unshift(moduleName);
        requires.push(moduleName);
        return {
            ...node,
            type: 'CustomRequireTransform',
            module: moduleName
        };
    }
    return node;
};

// Create a list of files, their ast and their require()'s
const fileMap = [];
while (files.length) {
    const file = files.pop();
    if (-1 < fileMap.findIndex(f => f.name === file)) {
        continue;
    }
    const filePath = resolve(join(__dirname, `../../src/${file.replace(/\./g, '/')}.lua`));
    let fileContent = readFileSync(filePath, 'utf8');
    if (file != 'libmek') {
        fileContent = `_['${file}'] = (function()\n${fileContent}\nend)();`
    }
    let self = { name: file };
    fileMap.push(self);
    requires = [];
    self.ast = luaparse.parse(fileContent);
    self.requires = requires;
}

// Sorts the list so items that have dependencies come after the dependencies they need
let orderedFileMap = [];
while (fileMap.length) {
    const fileObj = fileMap.shift();
    if (fileObj.requires.every(reqFile => orderedFileMap.some(ordFile => ordFile.name === reqFile))) {
        orderedFileMap.push(fileObj);
        continue;
    }
    fileMap.push(fileObj);
}

mkdirSync(resolve(join(__dirname, '../../.dist/')), { recursive: true });
writeFileSync(
    resolve(join(__dirname, '../../.dist/libmek.lua')),
    'return (function(_) ' + orderedFileMap.map((file, index) => astToLua(file.ast.body, orderedFileMap, index)).join('\n') + '\nend)({})',
    'utf8'
);