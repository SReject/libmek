local class = require('common.class');

local utilities = require('common.utilities');

local InductionMatrix = require('classes.induction-matrix').class;

---Induction Matrix Port
---@class LibmekInductionMatrixPort: LibmekInductionMatrix
local InductionMatrixPort = class(nil, InductionMatrix);

---Retrieves the port's current mode
---@return LibmekMachinePortDualState mode
function InductionMatrixPort:getPortMode()
    return utilities.portModeToEnum(self:call('getMode'));
end

---Sets the port mode
---@param mode LibmekMachinePortDualState|boolean
function InductionMatrixPort:setPortMode(mode)
    self:call('setMode', utilities.portModeFromEnum(mode));
end

---Induction Matrix Port's :info() result
---@class LibmekInductionMatrixPortInfo : LibmekInductionMatrixInfo

---Retrieves statis information pertaining to the port from the instance's
---cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekInductionMatrixPortInfo
function InductionMatrixPort:info(force)
    ---@type LibmekInductionMatrixPortInfo
    return self.__super.info(self, force);
end

---Induction Matrix Port's :status() result
---@class LibmekInductionMatrixPortStatus : LibmekInductionMatrixStatus
---@field inductionMatrixPort LibmekInductionMatrixPortEntry

---Induction Matrix Port's :status() entry
---@class LibmekInductionMatrixPortEntry
---@field mode LibmekMachinePortDualState

---Retrieves dynamic data pertaining to the Induction Matrix Port
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekInductionMatrixPortStatus status
function InductionMatrixPort:status(force)
    local status = self.__super.status(self, force);

    ---@cast status LibmekInductionMatrixPortStatus
    status.inductionMatrixPort = { mode = self:getPortMode() }

    return status;
end


return { class = InductionMatrixPort };