---@class libmek.component.EnergyConsumerNS: libmek.component.EnergyBufferNS
---@field usage fun(self: libmek.class.Peripheral): number

---@class libmek.component.EnergyConsumer: libmek.component.EnergyBuffer

local copyTable = require('common.helpers').copyTable;
local energyBufferComponenet = require('components.energy-buffer');

---@type libmek.internal.FactoryComponent
local energy = copyTable(energyBufferComponenet);
energy.usage = {
    handler = "getEnergyUsage",
    status = "usage"
}

return energy;