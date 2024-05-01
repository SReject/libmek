const { join, resolve } = require('path');
const { mkdirSync, rmSync, readdirSync, readFileSync, writeFileSync } = require('fs');

const deduceComponents = require('./components.cjs');

const parseType = require('./parse-type.cjs');

const relInputDir = './.scripts/generator/cc-api/vendor/mekanism/json/peripherals/';
const relOutputDir = './src/classes/generated/'

const rootdir = resolve(join(__dirname, '../../'));
const inputdir = resolve(join(rootdir, relInputDir));
const outputdir = resolve(join(rootdir, relOutputDir));


rmSync(outputdir, { force: true, recursive: true });
mkdirSync(outputdir, { recursive: true });

let classes = [];
readdirSync(inputdir, { withFileTypes: true }).filter(file => !file.isDirectory()).forEach(file => {
    let { components, methods } = deduceComponents(JSON.parse(readFileSync(resolve(join(inputdir, `./${file.name}`)), 'utf8')));

    let superName = 'Peripheral';
    let superFile = 'internal.peripheral';
    let superType = 'libmek.class.Peripheral';

    const className = file.name.replace(/\.json$/i, '').replace(/(?:^|_)(.)/g, (_, char) => char.toUpperCase());

    classes.push(`${className}`)

    if (methods.has('isFormed')) {
        [
            'isFormed',
            'getLength',
            'getWidth',
            'getHeight',
            'getMinPos',
            'getMaxPos'
        ].forEach(method => methods.delete(method));
        superName = 'Multiblock';
        superFile = 'internal.multiblock';
        superType = 'libmek.class.Multiblock';
        // TODO: Further deduce multiblock structure when appropriate:
        // fission reactor, fusion reactor, SPS, thermal evaporation plant, thermoelectric boiler, turbine
    }

    const inherits = [superType];
    const requires = [{name: superName, file: superFile}];

    components = components.map(component => {
        inherits.push(component.type);
        return `require('${component.file}')`
    });

    const methodDocs = [];
    const methodList = [];
    methods.forEach(method => {
        let { name, returns, params, description } = method;

        //#region Transform and generate annotation
        let doc = `---@field ${method.name} fun(`;
        if (params) {
            let paramList = [];
            params.forEach(param => {
                param.type = parseType(param.type);
                paramList.push(`${param.name}: ${param.type}`);
            });
            doc += paramList.join(', ');
        }
        doc += '): ';

        if (returns) {
            returns.type = parseType(returns.type);
            if (returns.type) {
                doc += returns.type;
            } else {
                doc += 'nil';
            }
        } else {
            doc += 'nil';
        }
        if (description) {
            doc += ` ${description}`
        }
        methodDocs.push(doc);
        //#endregion

        if (returns && returns.type) {
            methodList.push(`${name} = true`);
        } else {
            methodList.push(`${name} = false`);
        }
    });

    const lines = [
        '--License ISC (c) 2024 SReject <https://github.com/SReject/libmek/blob/master/LICENSE>',
        '',
        `---@class ${className}: ${inherits.join(', ')}`,
        ...methodDocs,
        '',
        `local factory = require('common.factory').factory;`,
        ...requires.map(item => `local ${item.name} = require('${item.file}');`),
        '',
        'return factory({',
        `    name = '${className}',`,
    ];
    let lastLine = `    super = ${superName}`;

    if (components.length) {
        lines.push(lastLine + ',');
        lines.push('    components = {');
        lines.push(components.map(component => `        ${component}`).join(',\n'));
        lastLine = '    }'
    }

    if (methodList.length) {
        lines.push(lastLine + ',');
        lines.push('    methods = {');
        lines.push(methodList.map(method => `        ${method}`).join(',\n'));
        lastLine = '    }';
    }

    if (lastLine) {
        lines.push(lastLine);
    }

    lines.push(`}) --[[@as ${className}]];`);

    writeFileSync(
        resolve(join(outputdir, `./${className}.lua`)),
        lines.join('\n'),
        'utf8'
    );
});

const indexContent = `return {\n${
    classes.map(cls => `    ${cls} = require('classes.generated.${cls}')`).join(',\n')
}\n};`;
writeFileSync(
    resolve(join(outputdir, `./index.lua`)),
    indexContent,
    'utf-8'
);