---@class LibmekComponentNSEnergyBuffer
---@field capacity fun(self: LibmekPeripheral): number
---@field amount fun(self: LibmekPeripheral): number
---@field needed fun(self: LibmekPeripheral): number
---@field percentage fun(self: LibmekPeripheral): number

---@class LibmekComponentEnergyBuffer
---@field energy LibmekComponentNSEnergyBuffer

---@type LibmekClassFactoryComponent
local energyBufferComponenet = {
    ["@namespace"] = "energy",
    capacity = {
        handler = "getMaxEnergy",
        cache = { name = "capacity" },
        info = "capacity",
        status = "capacity"
    },
    amount = {
        handler = "getEnergy",
        status = "amount"
    },
    needed = {
        handler = "getEnergyNeeded",
        status = "needed"
    },
    percentage = {
        handler = "getEnergyFilledPercentage",
        status = "percentage"
    }
}

return energyBufferComponenet;