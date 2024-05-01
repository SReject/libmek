/**
 * @typedef Component
 * @prop {string} name
 * @prop {string} libname
 * @prop {string} file
 * @prop {string[]} has
 * @prop {string[]} [doesntHave]
 */

/**@type {Component[]}*/
const componentsMap = [
    {
        name: 'ConfigurableSides',
        file: 'configurable-sides',
        has: [
            'canEject',
            'isEjecting',
            'setEjecting',
            'getMode',
            'setMode',
            'incrementMode',
            'decrementMode',
            'getConfigurableTypes',
            'getSupportedModes'
        ]
    }, {
        name: 'Directional',
        file: 'directional',
        has: [ 'getDirection' ]
    }, {
        name: 'Ejector',
        file: 'ejector',
        has: [
            'getInputColor',
            'setInputColor',
            'decrementInputColor',
            'incrementInputColor',
            'clearInputColor',
            'getOutputColor',
            'setOutputColor',
            'decrementOutputColor',
            'incrementOutputColor',
            'clearOutputColor',
            'hasStrictInput',
            'setStrictInput'
        ]
    }, {
        name: 'EnergyBuffer',
        file: 'energy-buffer',
        has: [
            'getMaxEnergy',
            'getEnergy',
            'getEnergyNeeded',
            'getEnergyFilledPercentage'
        ],
        doesntHave: [ 'getEnergyUsage' ]
    }, {
        name: 'EnergyConsumer',
        file: 'energy-consumer',
        has: [
            'getMaxEnergy',
            'getEnergy',
            'getEnergyNeeded',
            'getEnergyFilledPercentage',
            'getEnergyUsage'
        ]
    }, {
        name: 'QIOFrequency',
        file: 'qio-frequency',
        has: [
            'createFrequency',
            'decrementFrequencyColor',
            'getFrequencies',
            'getFrequency',
            'getFrequencyColor',
            'hasFrequency',
            'incrementFrequencyColor',
            'setFrequency',
            'setFrequencyColor'
        ]
    }, {
        name: 'QIOFilter',
        file: 'qio-filter',
        has: [
            'getFilters',
            'addFilter',
            'removeFilter'
        ]
    }, {
        name: 'RecipeProgress',
        file: 'recipe-progress',
        has: [ 'getRecipeProgress', 'getTicksRequired' ]
    }, {
        name: 'RedstoneComparator',
        file: 'redstone-comparator',
        has: [ 'getComparactorLevel' ]
    }, {
        name: 'RedstoneControl',
        file: 'redstone-control',
        has: [ 'getRedstoneMode', 'setRedstoneMode' ]
    }, {
        name: 'Security',
        file: 'security',
        has: [
            'getOwnerName',
            'getOwnerUUID',
            'getSecurityMode'
        ]
    }, {
        name: 'Upgradable',
        file: 'upgradable',
        has: [
            'getSupportedUpgrades',
            'getInstalledUpgrades'
        ]
    }
];
componentsMap.forEach(component => {
    component.type = `libmek.component.${component.name}`;
    component.file = `components.${component.file}`;
    component.name = `${component.name}Component`;
});

module.exports = (subject) => {

    // Converts the subject into a map for ease when searching potential
    // component methods
    //
    // data.name is used for keys as the property names in `subject` are
    // formatted as `name(...args)` which isn't condusive for matching
    /**@type {Map<string,any>} */
    const methods = Object
        .entries(subject)
        .reduce((map, [_, data]) => {
            if (data.name !== 'help') {
                map.set(data.name, data)
            }
            return map
        },new Map());

    // Filter out all non-applicable components, leaving only the components that
    // apply to the subject
    //
    // When a component is applicable, remove its methods from `methodsMap`
    const components = componentsMap
        .filter(component => {
            if (component.doesntHave) {
                let some = component.doesntHave.some(method => methods.has(method));
                if (some) {
                    return false;
                }
            }
            let hasAll = component.has.every(method => methods.has(method));
            if (hasAll) {
                component.has.forEach(method => methods.delete(method));
                return true;
            }
        });

    return { components, methods }
}