local class = require('common.class');

local FissionReactor = require('classes.fission-reactor').class;

---Fission Reactor Port
---@class LibmekFissionReactorPort : LibmekFissionReactor
---@field __super LibmekFissionReactor
local FissionReactorPort = class(nil, FissionReactor);

---Valid Port modes
---@alias LibmekFissionReactorPortMode
---| "INPUT"
---| "OUTPUT_WASTE"
---| "OUTPUT_COOLANT"

---Retrieves the port's mode
---@return LibmekFissionReactorPortMode mode
function FissionReactorPort:getPortMode()
    return self:call('getMode');
end

---Sets the port's mode
---@param mode LibmekFissionReactorPortMode
function FissionReactorPort:setPortMode(mode)
    self:call('setMode', mode);
end

---Decrements the port's mode
function FissionReactorPort:decrementPortMode()
    self:call('decrementMode');
end

---Increments the port's mode
function FissionReactorPort:incrementPortMode()
    self:call('incrementMode');
end

---Fission Reactor Port's :info() results
---@class LibmekFissionReactorPortInfo : LibmekFissionReactorInfo

---Retrieves static information pertaining to the fission reactor port from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekFissionReactorPortInfo info
function FissionReactorPort:info(force)
    ---@type LibmekFissionReactorPortInfo
    return self.__super.info(self, force);
end

---Fission Reactor Port's :status() results
---@class LibmekFissionReactorPortStatus : LibmekFissionReactorStatus
---@field fissionReactorPort LibmekFissionReactorStatusEntry

---Fission Reactor Port's :status() entry
---@class LibmekFissionReactorStatusEntry
---@field mode LibmekFissionReactorPortMode The port's current mode

---Retrieves dynamic data associated with the Fission Reactor Port from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekFissionReactorPortStatus status
function FissionReactorPort:status(force)
    local status = self.__super.status(self, force);

    ---@cast status LibmekFissionReactorPortStatus

    status.fissionReactorPort = { mode = self:getPortMode() };

    return status;
end

return { class = FissionReactorPort };