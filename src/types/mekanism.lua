--[[
General types used by Mekanism's CC interfaces

These types were compiled by hand referencing https://mekanism.github.io/computer_data/10.4.0.html
If you notice a mistake please open an issue
--]]

---@alias libmek.mek.BoilerValveMode
---| "INPUT"
---| "OUTPUT_COOLANT"
---| "OUTPUT_STEAM"

---@alias libmek.mek.ContainerEditMode
---| "BOTH"
---| "EMPTY"
---| "FILL"

---@alias libmek.mek.DataType
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

---@alias libmek.mek.Direction
---| "DOWN"
---| "EAST"
---| "NORTH"
---| "SOUTH"
---| "UP"
---| "WEST"

---@alias libmek.mek.DiversionControl
---| "DISABLED"
---| "HIGH"
---| "LOW"

---@alias libmek.mek.DriveStatus
---| "FULL"
---| "NEAR_FULL"
---| "NONE"
---| "OFFLINE"
---| "READY"

---@alias libmek.mek.EnumColor
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

---@alias libmek.mek.FilterType
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

---@alias libmek.mek.FissionPortMode
---| "INPUT"
---| "OUTPUT_COOLANT"
---| "OUTPUT_WASTE"

---@alias libmek.mek.FissionReactorLogic
---| "ACTIVATION"
---| "DAMAGED"
---| "DEPLETED"
---| "DISABLED"
---| "EXCESS_WASTE"
---| "TEMPERATURE"

---@alias libmek.mek.FusionReactorLogic
---| "CAPACITY"
---| "DEPLETED"
---| "DISABLED"
---| "READY"

---@alias libmek.mek.GasMode
---| "DUMPING"
---| "DUMPING_EXCESS"
---| "IDLE"

---@alias libmek.mek.RedstoneControl
---| "DISABLED"
---| "HIGH"
---| "LOW"
---| "PULSE"

---@alias libmek.mek.RedstoneOutput
---| "ENERGY_CONTENTS"
---| "ENTITY_DETECTION"
---| "OFF"

---@alias libmek.mek.RedstoneStatus
---| "IDLE"
---| "OUTPUTTING"
---| "POWERED"

---@alias libmek.mek.RelativeSide
---| "BACK"
---| "BOTTOM"
---| "FRONT"
---| "LEFT"
---| "RIGHT"
---| "TOP"

---@alias libmek.mek.SecurityMode
---| "PRIVATE"
---| "PUBLIC"
---| "TRUSTED"

---@alias libmek.mek.State
---| "FINISHED"
---| "IDLE"
---| "PAUSED"
---| "SEARCHING"

---@alias libmek.mek.TransmissionType
---| "ENERGY"
---| "FLUID"
---| "GAS"
---| "HEAT"
---| "INFUSION"
---| "ITEM"
---| "PIGMENT"
---| "SLURRY"

---@alias libmek.mek.Upgrade
---| "ANCHOR"
---| "ENERGY"
---| "FILTER"
---| "GAS"
---| "MUFFLING"
---| "SPEED"
---| "STONE_GENERATOR"

---X,Y,Z positional information
---@class libmek.mek.BlockPosition
---@field x integer
---@field y integer
---@field z integer

---Positional information with a dimensional component
---@class libmek.mek.Coord4D: libmek.mek.BlockPosition
---@field dimension string The dimension component

---A block's state
---@class libmek.mek.BlockState
---@field block string The block's registered name, e.g. `minecraft:sand`
---@field state table<string, any> State informtion regarding the block

---A chemical and amount information
---@class libmek.mek.ChemicalStack
---@field name string The substance's registered name, e.g. `mincraft:stone`, `minecraft:water`, `mekanism:oxygen`
---@field amount integer The amount of the chemical given in millibuckets

---A fluid and amount information
---@class libmek.mek.FluidStack
---@field name string The fluid's registered name `minecraft:water`
---@field amount integer The amount of the given substance given in millibuckets
---@field nbt string? NBT information regarding the fluid in JSON format

---An item and amount information
---@class libmek.mek.ItemStack
---@field name string The item's registered name
---@field count integer The amount of items in the stack
---@field nbt string? NBT information regarding the item in JSON format

---A frequency's identity
---@class libmek.mek.Frequency
---@field key string The identifier of the frequency
---@field ["public"] boolean Whether the frequency is public or not

---Base for various mekanism filters
---@class libmek.mek.IFilter
---@field type libmek.mek.FilterType The filter type
---@field enabled boolean Whether the filter is enabled when added to a devide

---Internal class for filters that have a item-stack component
---@class libmek.mek.IItemStackFilter
---@field item string The filtered item's registered name
---@field itemNBT string? The NBT data of the filtered item in JSON format

---Internal class for filters that have a Fuzzy component to their ItemStack component
---@class libmek.mek.IFuzzyItemStackFilter: libmek.mek.IItemStackFilter
---@field fuzzy boolean Whether to check only the item name and/or type

---Internal class for filters that have a mod-id component
---@class libmek.mek.IModIdFilter
---@field modid string The mod id to filter. e.g. `mekanism`

---Internal class for filters that have a tag component
---@class libmek.mek.ITagFilter
---@field tag string The tag to filter. e.g. `forge:ores`

---A Digital Miner Filter
---@class libmek.mek.MinerFilter: libmek.mek.IFilter
---@field replaceTarget string the registered name of the item block to replace mined blocks with
---@field requiresReplacement boolean Whether the filter requires a replacement to be done before it will allow mining

---A digital miner filter with item-related filter properties
---@class libmek.mek.MinerItemStackFilter: libmek.mek.MinerFilter, libmek.mek.IItemStackFilter

---A digital miner filter with mod-related filter properties
---@class libmek.mek.MinerModIdFilter: libmek.mek.MinerFilter, libmek.mek.IModIdFilter

---A digital miner filter with tag-related filter properties
---@class libmek.mek.MinerTagFilter: libmek.mek.MinerFilter, libmek.mek.ITagFilter

---An Oredictionificator filter
---@class libmek.mek.OredictionificatorItemFilter : libmek.mek.IFilter
---@field selected string? The select output item's registered name. e.g. `minecraft:stone`
---@field target string The input's target tag to match. e.g. `forge:stone`

---A Quantum Item Orchestration filter
---@class libmek.mek.QIOFilter: libmek.mek.IFilter

---A QIO filter with item filter properties
---@class libmek.mek.QIOItemStackFilter: libmek.mek.QIOFilter, libmek.mek.IFuzzyItemStackFilter

---A QIO filter with mod-related filter properties
---@class libmek.mek.QIOModIdFilter: libmek.mek.QIOFilter, libmek.mek.IModIdFilter

---A QIO filter with tag-related filter properties
---@class libmek.mek.QIOTagFilter: libmek.mek.QIOFilter, libmek.mek.ITagFilter

---A logistical sorter filter
---@class libmek.mek.SorterFilter: libmek.mek.IFilter
---@field allowDefault boolean Allows the filtered item to travel to the default color destination
---@field color libmek.mek.EnumColor? The color configured
---@field max integer In "Size Mode" the maximum to send
---@field min integer In "Size Mode" the minimum that can be sent
---@field size boolean Whether size mode is enabled

---A logistical sorter filter with item-related filter properties
---@class libmek.mek.SorterItemStackFilter: libmek.mek.SorterFilter, libmek.mek.IItemStackFilter

---A logistical sorter filter with mod-related properties
---@class libmek.mek.SorterModIdFilter: libmek.mek.SorterFilter, libmek.mek.IModIdFilter

---A logistical sorter filter with tag-related properties
---@class libmek.mek.SorterTagFilter: libmek.mek.SorterFilter, libmek.mek.ITagFilter