---@class LibmekComponentNSEnergyConsumer: LibmekComponentNSEnergyBuffer
---@field usage fun(self: LibmekPeripheral): number

---@class LibmekComponentEnergyConsumer: LibmekComponentEnergyBuffer

local copyTable = require('common.helpers').copyTable;
local energyBufferComponenet = require('components.energy-buffer');

---@type LibmekClassFactoryComponent
local energy = copyTable(energyBufferComponenet);
energy.usage = {
    handler = "getEnergyUsage",
    status = "usage"
}

return energy;