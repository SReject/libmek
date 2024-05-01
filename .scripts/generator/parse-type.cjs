const primitiveMap = {
    "boolean": "boolean",
    "number": "number",
    "number (int)": "libmek.mek.Integer",
    "number (integer)": "libmek.mek.Integer",
    "number (double)": "libmek.mek.Double",
    "number (long)": "libmek.mek.Long",
    "number (float)": "libmek.mek.Float",
    "number (floatinglong)": "libmek.mek.FloatingLong",
    "string": "string",
    "string (enumcolor)": "libmek.mek.Color",
    "table (blockpos)": "libmek.mek.BlockPosition",
    "table (globalpos)": "libmek.mek.Coord4D"
};

// Enum list builder
([
    "BoilerValveMode",
    "ContainerEditMode",
    "DataType",
    "Direction",
    "DiversionControl",
    "DriveStatus",
    // "EnumColor",
    "FilterType",
    "FissionPortMode",
    "FissionReactorLogic",
    "FusionReactorLogic",
    "GasMode",
    "Item",
    "RedstoneControl",
    "RedstoneOutput",
    "RedstoneStatus",
    "RelativeSide",
    "ResourceLocation",
    "SecurityMode",
    "State",
    "TransmissionType",
    "Upgrade"
]).forEach(name => {
    let lName = name.toLowerCase();
    primitiveMap[`string (${lName})`] = `libmek.mek.${name}`
});

// Table/class builder
[
    // "BlockPos",
    "BlockState",
    "ChemicalStack",
    "FluidStack",
    // "GlobalPos",
    "InventoryFrequency",
    "ItemStack",
    "MinerFilter",
    "OredictionificatorItemFilter",
    "QIOFilter",
    "QIOFrequency",
    "SorterFilter",
    "TeleporterFrequency"

].forEach(name => {
    let lName = name.toLowerCase();
    primitiveMap[`table (${lName})`] = `libmek.mek.${name}`;
});

const parse = (type) => {
    if (type == null || type === "Nothing") {
        return;
    }

    let isPrim = primitiveMap[type.toLowerCase()];
    if (isPrim) {
        return isPrim;
    }

    let list = type.match(/^List \((Table \([^()]+\))\)$/i);
    if (list) {
        let isPrim = primitiveMap[list[1].toLowerCase()];
        if (isPrim) {
            return `${isPrim}[]`
        }
    }

    if (type === "Table (Number (int) => Table (BlockState))") {
        return `{[number]: libmek.mek.BlockState}`
    }

    console.log("Unknown Type:", type);
    return type;
};

module.exports = (type) => {
    let types = type.split(" or ");
    if (types.length === 1) {
        return parse(type);
    }
    return types.map(type => `${parse(type)}`).join('|');
}