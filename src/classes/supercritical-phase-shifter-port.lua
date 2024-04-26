local class = require('common.class');
local utilities = require('common.utilities');

local SPS = require('classes.supercritical-phase-shifter').class;

---Supercritical Phase Shifter Port
---@class LibmekSupercriticalPhaseShifterPort: LibmekSupercriticalPhaseShifter
---@field __super LibmekSupercriticalPhaseShifter
local SpsPort = class(nil, SPS);

---Retrieves the port's current mode
---@return LibmekMachinePortDualState mode
function SpsPort:getPortMode()
    return utilities.portModeToEnum(self:call('getMode'));
end

---Sets the port's mode
---@param mode LibmekMachinePortDualState|boolean
function SpsPort:setPortMode(mode)
    self:call('setMode', utilities.portModeFromEnum(mode));
end

---Supercritical Phase Shifter Port's `:info()` result
---@class LibmekSupercriticalPhaseShifterPortInfo : LibmekSupercriticalPhaseShifterInfo
---@field supercriticalPhaseShifterPort LibmekSupercriticalPhaseShifterPortInfoEntry

---Supercritical Phase Shifter Port's `:info()` entry
---@class LibmekSupercriticalPhaseShifterPortInfoEntry
---@field coils number?

---Retrieves static information pertaining to the port from the instance's
---cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekSupercriticalPhaseShifterPortInfo info
function SpsPort:info(force)
    local info = self.__super.info(self, force);

    ---@cast info LibmekSupercriticalPhaseShifterPortInfo
    info.supercriticalPhaseShifterPort = {
        coils = self:getCoils(force)
    }

    return info;
end

---Supercritical Phase Shifter Port's `:status()` result
---@class LibmekSupercriticalPhaseShifterPortStatus : LibmekSupercriticalPhaseShifterStatus
---@field supercriticalPhaseShifterPort LibmekSupercriticalPhaseShifterPortStatusEntry

---Supercritical Phase Shifter Port's `:status()` entry
---@class LibmekSupercriticalPhaseShifterPortStatusEntry
---@field processingRate number?

---Retrieves static information pertaining to the port from the instance's
---cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekSupercriticalPhaseShifterPortStatus Status
function SpsPort:status(force)
    local status = self.__super.status(self, force);

    ---@cast status LibmekSupercriticalPhaseShifterPortStatus
    status.supercriticalPhaseShifterPort = {
        processingRate = self:getProcessingRate()
    }

    return status;
end

return { class = SpsPort }