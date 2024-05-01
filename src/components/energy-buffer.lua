---@class libmek.component.EnergyBufferNS
---@field capacity fun(self: libmek.class.Peripheral): number
---@field amount fun(self: libmek.class.Peripheral): number
---@field needed fun(self: libmek.class.Peripheral): number
---@field percentage fun(self: libmek.class.Peripheral): number

---@class libmek.component.EnergyBuffer
---@field energy libmek.component.EnergyBufferNS

---@type libmek.internal.FactoryComponent
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