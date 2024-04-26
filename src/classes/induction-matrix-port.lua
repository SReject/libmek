local class = require('common.class');

local InductionMatrix = require('classes.induction-matrix');

---Induction Matrix Port
---@class LibmekInductionMatrixPort: LibmekInductionMatrix
local InductionMatrixPort = class(nil, InductionMatrix);

---@alias LibmekInductionMatrixPortMode
---| "INPUT"
---| "OUTPUT"

---Converts the input port mode into the equivulant string value
---Its planned for mekanism to use an enum for port mode; This is planning for that future
---@param mode LibmekInductionMatrixPortMode|boolean
---@return LibmekInductionMatrixPortMode mode
local function portToEnum(mode)
    if (mode == true or mode == 'OUTPUT') then
        return 'OUTPUT';
    end
    return 'INPUT';
end

---Converts the input port mode into the equivulant boolean value
---Its planned for mekanism to use an enum for port mode; This is planning for that future
---@param mode LibmekInductionMatrixPortMode|boolean
---@return boolean mode
local function portFromEnum(mode)
    if (mode == true or mode == 'OUTPUT') then
        return true;
    end
    return false;
end

---Retrieves the port's current mode
---@return LibmekInductionMatrixPortMode
function InductionMatrixPort:getPortMode()
    return portToEnum(self:call('getMode'));
end

---Sets the port mode
---@param mode LibmekInductionMatrixPortMode|boolean
function InductionMatrix:setPortMode(mode)
    self:call('setMode', portFromEnum(mode));
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
---@field mode LibmekInductionMatrixPortMode

---Retrieves dynamic data pertaining to the Induction Matrix Port
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekInductionMatrixPortStatus status
function InductionMatrixPort:status(force);
    local status = self.__super.status(self, force);

    ---@cast status LibmekInductionMatrixPortStatus
    status.inductionMatrixPort = { mode = self:getPortMode() }

    return status;
end


return { class = InductionMatrixPort };