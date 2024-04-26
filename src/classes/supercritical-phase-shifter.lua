local class = require('common.class');

local Multiblock = require('classes.multiblock').class;

local energyBuffer = require('mixins.energy-buffer');
local tank = require('mixins.tank');

---Supercritical Phase Shifter multiblock structure
---@class LibmekSupercriticalPhaseShifter: LibmekMultiblock
---@field __super LibmekMultiblock
---@field energy LibmekEnergyBuffer
---@field inputTank LibmekDedicatedTankSlot
---@field outputTank LibmekDedicatedTankSlot
local Sps = class(
    function (super, self, name)
        super(name);
        self.__cache.supercriticalPhaseShifter = {};
    end,
    Multiblock,

    energyBuffer.factory('supercriticalPhaseShifter'),
    tank.factory('supercriticalPhaseShifter', 'Input', 'inputTank'),
    tank.factory('supercriticalPhaseShifter', 'Output', 'outputTank')
);

---Retrieves the number of coils associated with the Supercritical Phase
---Shifter from the instance's cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return number
function Sps:getCoils(force)
    if (force == true or self.__cache.supercriticalPhaseShifter.coils == nil) then
        self.__cache.supercriticalPhaseShifter.coils = self:call('getCoils');
    end
    return self.__cache.supercriticalPhaseShifter.coils
end

---Retrieves the current processing rate
---
---Units: millibuckets/tick
---@return number
function Sps:getProcessingRate()
    return self:call('getProcessRate');
end

---Supercritical Phase Shifter's `:status()` results
---@class LibmekSupercriticalPhaseShifterInfo: LibmekMultiblockInfo
---@field supercriticalPhaseShifter LibmekSupercriticalPhaseShifterInfoEntry

---Supercritical Phase Shifter's `:status()` entry
---@class LibmekSupercriticalPhaseShifterInfoEntry
---@field coils number?

---Retrieves static information regarding the Supercritical Phase Shifter from
---the instance's cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekSupercriticalPhaseShifterInfo status
function Sps:info(force)
    local info = self.__super.info(self, force);

    ---@cast info LibmekSupercriticalPhaseShifterInfo

    if (info.multiblock.valid) then
        info.supercriticalPhaseShifter = {
            coils = self:getCoils(force)
        };
    else
        self.__cache.supercriticalPhaseShifter = {};
        info.supercriticalPhaseShifter = {};
    end
    return info;
end

---Supercritical Phase Shifter's `:status()` results
---@class LibmekSupercriticalPhaseShifterStatus: LibmekMultiblockStatus
---@field supercriticalPhaseShifter LibmekSupercriticalPhaseShifterStatusEntry

---Supercritical Phase Shifter's `:status()` entry
---@class LibmekSupercriticalPhaseShifterStatusEntry
---@field processingRate number?

---Retrieves dynamic information regarding the Supercritical Phase Shifter
---
---Where applicable, if the cache does not contain the given value it is
---retrieved from the connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekSupercriticalPhaseShifterStatus status
function Sps:status(force)

    local status = self.__super.status(self, force);

    ---@cast status LibmekSupercriticalPhaseShifterStatus

    if (status.multiblock.valid) then
        status.supercriticalPhaseShifter = {
            processingRate = self:getProcessingRate()
        };
    else
        self.__cache.supercriticalPhaseShifter = {};
        status.supercriticalPhaseShifter = {};
    end

    return status;
end

return { class = Sps };