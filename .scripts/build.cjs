const { mkdirSync, readFileSync, writeFileSync } = require('fs');
const { join, resolve } = require('path');

const minify = require('./minify.cjs');

const processedModules = new Map();
const processModule = (name, nowrap) => {
    name = name.toLowerCase();

    const file = name.replace(/\./g, '/') + ".lua";
    const filepath = resolve(join(__dirname, `../src/${file}`));

    let content = readFileSync(filepath, 'utf-8');

    const deps = [];
    processedModules.set(name, {
        processing: true,
        name,
        deps,
        content: ''
    });

    // Normalize EoL characters
    content = content.replace(/\r\n?/g, '\n');

    // Remove trailing spaces and tabs from lines
    content = content.replace(/[ \t]+(?=$|[\n])/g, '');

    // remove leading and trailing EoL from content
    content = content
        .replace(/^\n+/g, '')
        .replace(/\n+$/, '');

    // Remove unnessicary blank lines
    content = content.replace(/\n\n\n+/g, '\n\n');

    // replace "= require(name);" calls with '= modules[name];'
    content = content.replace(/=\s*require\((["'])([a-z\d-. ]+)\1\) *([;,]?(?:$|\n))/g, (ignore, ignore2, id, eos) => {
        id = id.toLowerCase();
        deps.push(id);
        if (!processedModules.has(id)) {
            processModule(id);
        }
        return `= libmek["${id}"]${eos}`
    });

    if (nowrap !== true) {
        // increase indent
        content = content.replace(/(^|(?:\n(?!\n)))/g, '$1    ');
        if (!content.endsWith(';')) {
            content += ';'
        }

        // wrap with IIFE
        content = `libmek['${name}'] = (function()\n${content}\nend)();\n`;
    }

    processedModules.get(name).content = content;
};

processModule('main', true);

const modulesAdded = new Set();
let addModule = (name, output) => {
    if (modulesAdded.has(name)) {
        return output;
    }
    modulesAdded.add(name);

    const { content, deps } = processedModules.get(name);
    for (const name of deps) {
        output = addModule(name, output);
    }
    return output + content;
}

let output = addModule('main', "");
output = `local libmek = {};\n${output}`;

mkdirSync(resolve(join( __dirname, '../.dist/')), { recursive: true });
writeFileSync(resolve(join(__dirname, '../.dist/libmek.lua')), output, 'utf-8');
writeFileSync(resolve(join(__dirname, '../.dist/libmek.min.lua')), minify(output), 'utf-8');