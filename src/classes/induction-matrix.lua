local class = require('common.class');

local Multiblock = require('classes.multiblock');

local energyBuffer = require('mixins.energybuffer');

---@class InductionMatrix: Multiblock
---@field __super Multiblock
local InductionMatrix = class.create(

    ---Constructor
    ---@param super fun(peripheralName: string):nil
    ---@param self InductionMatrix
    ---@param name string
    function (super, self, name)
        super(name);
        self.__cache.inductionMatrix = {};
    end,

    -- Super class
    Multiblock,

    -- Mixins
    energyBuffer.factory('inductionMatrix')
);

---Retrieves the number of Induction Cells associated with the induction matrix
---from cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to update
---@return number|nil
function InductionMatrix:getCells(force)
    if (force == true or self.__cache.inductionMatrix.cells == nil) then
        self.__cache.inductionMatrix.cells = self:call('getInstalledCells');
    end
    return self.__cache.inductionMatrix.cells;
end

---Retrieves the number of Induction Providers associated with the induction
---matrix from cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to update
---@return number|nil
function InductionMatrix:getProviders(force)
    if (force == true or self.__cache.inductionMatrix.providers == nil) then
        self.__cache.inductionMatrix.providers = self:call('getInstalledProviders');
    end
    return self.__cache.inductionMatrix.providers;
end

---Retrieves the maximum energy transfer rate of the induction matrix from
---cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---
---Units: joules
---@param force boolean? When true the cached value is forced to update
---@return number|nil
function InductionMatrix:getTransferLimit(force)
    if (force == true or self.__cache.inductionMatrix.transferLimit == nil) then
        self.__cache.inductionMatrix.transferLimit = self:call('getTransferCap');
    end
    return self.__cache.inductionMatrix.transferLimit;
end

---Retrieves the rate of energy input for the induction matrix
---
---Units: joules
---@return number|nil
function InductionMatrix:getInputRate()
    return self:call('getLastInput');
end

---Retrieves the rate of energy output for the induction matrix
---
---Units: joules
---@return number|nil
function InductionMatrix:getOutputRate()
    return self:call('getLastOutput');
end

---Retrieves information regarding the item in the induction matrix's input
---slot
---@return any
function InductionMatrix:getInputSlot()
    return self:call('getInputItem');
end

---Retrieves information regarding the item in the induction matrix's output
---slot
---@return any
function InductionMatrix:getOutputSlot()
    return self:call('getOutputSlot');
end

---Entry in the :info() results table specific to InductionMatrix information
---@class InductionMatrixInfo: MultiblockInfo
---@field inductionMatrix InductionMatrixInfoEntry

---InductionMatrix :info() details
---@class InductionMatrixInfoEntry
---@field cells integer?
---@field providers integer?
---@field transferLimit number?

function InductionMatrix:info(force)
    local info = self.__super.info(self, force);

    ---@cast info InductionMatrixInfo

    if (info.multiblock.valid) then
        info.inductionMatrix = {
            cells = self:getCells(force),
            providers = self:getProviders(force),
            transferLimit = self:getTransferLimit(force)
        };
    else
        info.inductionMatrix = {};
    end

    return info;
end

---Entry in the :status() results table specific to InductionMatrix information
---@class InductionMatrixStatus: MultiblockStatus
---@field inductionMatrix InductionMatrixStatusEntry

---InductionMatrix :status() details
---@class InductionMatrixStatusEntry
---@field inputRate number?
---@field outputRate number?
---@field inputSlot unknown?
---@field outputSlot unknown?

function InductionMatrix:status(force)
    local status = self.__super.status(self, force)

    ---@cast status InductionMatrixStatus

    if (status.multiblock.valid) then
        status.inductionMatrix = {
            inputRate = self:getInputRate(),
            outputRate = self:getOutputRate(),
            inputSlot = self:getInputSlot(),
            outputSlot = self:getOutputSlot()
        }
    else
        status.inductionMatrix = {}
    end
end

return { class = InductionMatrix }