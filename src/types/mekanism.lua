--[[
General types used by Mekanism's CC interfaces

These types were compiled by hand referencing https://mekanism.github.io/computer_data/10.4.0.html
If you notice a mistake please open an  issue
--]]

---@alias LibmekBoilerValveMode
---| "INPUT"
---| "OUTPUT_COOLANT"
---| "OUTPUT_STEAM"

---@alias LibmekContainerEditMode
---| "BOTH"
---| "EMPTY"
---| "FILL"

---@alias LibmekDataType
---| "ENERGY"
---| "EXTRA"
---| "INPUT"
---| "INPUT_1"
---| "INPUT_2"
---| "INPUT_OUTPUT"
---| "NONE"
---| "OUTPUT"
---| "OUTPUT_1"
---| "OUTPUT_2"

---@alias LibmekDirection
---| "DOWN"
---| "EAST"
---| "NORTH"
---| "SOUTH"
---| "UP"
---| "WEST"

---@alias LibmekDiversionControl
---| "DISABLED"
---| "HIGH"
---| "LOW"

---@alias LibmekDriveStatus
---| "FULL"
---| "NEAR_FULL"
---| "NONE"
---| "OFFLINE"
---| "READY"

---@alias LibmekEnumColor
---| "AQUA"
---| "BLACK"
---| "BRIGHT_GREEN"
---| "BRIGHT_PINK"
---| "BROWN"
---| "DARK_AQUA"
---| "DARK_BLUE"
---| "DARK_GRAY"
---| "DARK_GREEN"
---| "DARK_RED"
---| "GRAY"
---| "INDIGO"
---| "ORANGE"
---| "PINK"
---| "PURPLE"
---| "RED"
---| "WHITE"
---| "YELLOW"

---@alias LibmekFilterType
---| "MINER_ITEMSTACK_FILTER"
---| "MINER_MODID_FILTER"
---| "MINER_TAG_FILTER"
---| "OREDICTIONIFICATOR_ITEM_FILTER"
---| "QIO_ITEMSTACK_FILTER"
---| "QIO_MODID_FILTER"
---| "QIO_TAG_FILTER"
---| "SORTER_ITEMSTACK_FILTER"
---| "SORTER_MODID_FILTER"
---| "SORTER_TAG_FILTER"

---@alias LibmekFissionPortMode
---| "INPUT"
---| "OUTPUT_COOLANT"
---| "OUTPUT_WASTE"

---@alias LibmekFissionReactorLogic
---| "ACTIVATION"
---| "DAMAGED"
---| "DEPLETED"
---| "DISABLED"
---| "EXCESS_WASTE"
---| "TEMPERATURE"

---@alias LibmekFusionReactorLogic
---| "CAPACITY"
---| "DEPLETED"
---| "DISABLED"
---| "READY"

---@alias LibmekGasMode
---| "DUMPING"
---| "DUMPING_EXCESS"
---| "IDLE"

---@alias LibmekRedstoneControl
---| "DISABLED"
---| "HIGH"
---| "LOW"
---| "PULSE"

---@alias LibmekRedstoneOutput
---| "ENERGY_CONTENTS"
---| "ENTITY_DETECTION"
---| "OFF"

---@alias LibmekRedstoneStatus
---| "IDLE"
---| "OUTPUTTING"
---| "POWERED"

---@alias LibmekRelativeSide
---| "BACK"
---| "BOTTOM"
---| "FRONT"
---| "LEFT"
---| "RIGHT"
---| "TOP"

---@alias LibmekSecurityMode
---| "PRIVATE"
---| "PUBLIC"
---| "TRUSTED"

---@alias LibmekState
---| "FINISHED"
---| "IDLE"
---| "PAUSED"
---| "SEARCHING"

---@alias LibmekTransmissionType
---| "ENERGY"
---| "FLUID"
---| "GAS"
---| "HEAT"
---| "INFUSION"
---| "ITEM"
---| "PIGMENT"
---| "SLURRY"

---@alias LibmekUpgrade
---| "ANCHOR"
---| "ENERGY"
---| "FILTER"
---| "GAS"
---| "MUFFLING"
---| "SPEED"
---| "STONE_GENERATOR"

---X,Y,Z positional information
---@class LibmekBlockPosition
---@field x integer
---@field y integer
---@field z integer

---Positional information with a dimensional component
---@class LibmekCoord4D: LibmekBlockPosition
---@field dimension string The dimension component

---A block's state
---@class LibmekBlockState
---@field block string The block's registered name, e.g. `minecraft:sand`
---@field state table<string, any> State informtion regarding the block

---A chemical and amount information
---@class LibmekChemicalStack
---@field name string The substance's registered name, e.g. `mincraft:stone`, `minecraft:water`, `mekanism:oxygen`
---@field amount integer The amount of the chemical given in millibuckets

---A fluid and amount information
---@class LibmekFluidStack
---@field name string The fluid's registered name `minecraft:water`
---@field amount integer The amount of the given substance given in millibuckets
---@field nbt string? NBT information regarding the fluid in JSON format

---An item and amount information
---@class LibmekItemStack
---@field name string The item's registered name
---@field count integer The amount of items in the stack
---@field nbt string? NBT information regarding the item in JSON format

---A frequency's identity
---@class LibmekFrequency
---@field key string The identifier of the frequency
---@field ["public"] boolean Whether the frequency is public or not

---Base for various mekanism filters
---@class LibmekIFilter
---@field type LibmekFilterType The filter type
---@field enabled boolean Whether the filter is enabled when added to a devide

---Internal class for filters that have a item-stack component
---@class LibmekIItemStackFilter
---@field item string The filtered item's registered name
---@field itemNBT string? The NBT data of the filtered item in JSON format

---Internal class for filters that have a Fuzzy component to their ItemStack component
---@class LibmekIFuzzyItemStackFilter: LibmekIItemStackFilter
---@field fuzzy boolean Whether to check only the item name and/or type

---Internal class for filters that have a mod-id component
---@class LibmekIModIdFilter
---@field modid string The mod id to filter. e.g. `mekanism`

---Internal class for filters that have a tag component
---@class LibmekITagFilter
---@field tag string The tag to filter. e.g. `forge:ores`

---A Digital Miner Filter
---@class LibmekMinerFilter: LibmekIFilter
---@field replaceTarget string the registered name of the item block to replace mined blocks with
---@field requiresReplacement boolean Whether the filter requires a replacement to be done before it will allow mining

---A digital miner filter with item-related filter properties
---@class LibmekMinerItemStackFilter: LibmekMinerFilter, LibmekIItemStackFilter

---A digital miner filter with mod-related filter properties
---@class LibmekMinerModIdFilter: LibmekMinerFilter, LibmekIModIdFilter

---A digital miner filter with tag-related filter properties
---@class LibmekMinerTagFilter: LibmekMinerFilter, LibmekITagFilter

---An Oredictionificator filter
---@class LibmekOredictionificatorItemFilter : LibmekIFilter
---@field selected string? The select output item's registered name. e.g. `minecraft:stone`
---@field target string The input's target tag to match. e.g. `forge:stone`

---A Quantum Item Orchestration filter
---@class LibmekQIOFilter: LibmekIFilter

---A QIO filter with item filter properties
---@class LibmekQIOItemStackFilter: LibmekQIOFilter, LibmekIFuzzyItemStackFilter

---A QIO filter with mod-related filter properties
---@class LibmekQIOModIdFilter: LibmekQIOFilter, LibmekIModIdFilter

---A QIO filter with tag-related filter properties
---@class LibmekQIOTagFilter: LibmekQIOFilter, LibmekITagFilter

---A logistical sorter filter
---@class LibmekSorterFilter: LibmekIFilter
---@field allowDefault boolean Allows the filtered item to travel to the default color destination
---@field color LibmekEnumColor? The color configured
---@field max integer In "Size Mode" the maximum to send
---@field min integer In "Size Mode" the minimum that can be sent
---@field size boolean Whether size mode is enabled

---A logistical sorter filter with item-related filter properties
---@class LibmekSorterItemStackFilter: LibmekSorterFilter, LibmekIItemStackFilter

---A logistical sorter filter with mod-related properties
---@class LibmekSorterModIdFilter: LibmekSorterFilter, LibmekIModIdFilter

---A logistical sorter filter with tag-related properties
---@class LibmekSorterTagFilter: LibmekSorterFilter, LibmekITagFilter