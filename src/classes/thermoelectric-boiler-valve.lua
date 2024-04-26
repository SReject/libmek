local class = require('common.class');

local ThermoelectricBoiler = require('classes.thermoelectric-boiler');

---@class LibmekThermoelectricBoilerValve: LibmekThermoelectricBoiler
---@field __super LibmekThermoelectricBoiler
local ThermoelectricBoilerValve = class.create(nil, ThermoelectricBoiler);

---@alias LibmekThermoelectricBoilerValveMode
---| "INPUT"
---| "OUTPUT_STEAM"
---| "OUTPUT_COOLANT"

---Retrieves the current of the valve
---@return LibmekThermoelectricBoilerValveMode ValveMode
function ThermoelectricBoilerValve:getValveMode()
    return self:call('getMode');
end

---Sets the mode of the valve
---@param mode LibmekThermoelectricBoilerValveMode
function ThermoelectricBoilerValve:setValveMode(mode)
    self:call('setMode', mode);
end

---Decrements the mode of the valve
function ThermoelectricBoilerValve:decrementValveMode()
    self:call('decrementMode');
end

---Increments the mode of the valve
function ThermoelectricBoilerValve:incrementValveMode()
    self:call('incrementMode');
end

---@class LibmekThermoelectricBoilerValveInfo : LibmekThermoelectricBoilerInfo

---Retrieves static information pertaining to the boiler valve from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekThermoelectricBoilerValveInfo Info
function ThermoelectricBoilerValve:info(force)
    ---@type LibmekThermoelectricBoilerValveInfo
    return self.__super.info(self, force)
end

---@class LibmekThermoelectricBoilerValveStatus : LibmekThermoelectricBoilerStatus
---@field thermoelectricBoilerValve LibmekThermoelectricBoilerValveEntry

---@class LibmekThermoelectricBoilerValveEntry
---@field mode LibmekThermoelectricBoilerValveMode

---Retrieves dynamic data associated with the Thermoelectric Boiler Valve
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekThermoelectricBoilerValveStatus status
function ThermoelectricBoilerValve:status(force)
    local status = self.__super.status(self, force);

    ---@cast status LibmekThermoelectricBoilerValveStatus

    status.thermoelectricBoilerValve = {
        mode = self:getValveMode()
    };

    return status;
end
