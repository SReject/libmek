local class = require('common.class');
local Peripheral = require('classes.peripheral');

local
    ---Creates a new Multiblock instance
    ---@type fun(peripheralName: string): Multiblock
    new,

    ---Multiblock structure
    ---@class Multiblock: Peripheral
    ---@field __super Peripheral
    Multiblock = class.create(

        ---Constructor
        ---@param super fun(name: string):nil
        ---@param self Multiblock
        ---@param name string
        function (super, self, name)
            super(name);
            if (self:call('isFormed') ~= true) then
                error("multiblock is not formed");
            end
            self.__cache.multiblock = {};
        end,

        -- Super class
        Peripheral.class
    );

---Clears the instance's cache
function Multiblock:clearCache()
    self.__super.clearCache(self);
    self.__cache.multiblock = {};
end

---@class MultiblockPositionPoint
---@field x number
---@field y number
---@field z number

---@class MultiblockPosition
---@field min MultiblockPositionPoint?
---@field max MultiblockPositionPoint?

---Retrieves the positions of opposing corners comprising the multiblock
---structure from the instance's cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return MultiblockPosition
function Multiblock:getPosition(force)
    if (
        force == true or
        -- Cache is invalid
        self.__cache.multiblock.position == nil or
        self.__cache.multiblock.position.min == nil or
        self.__cache.multiblock.position.max == nil
    ) then
        self.__cache.multiblock.position = {
            min = self:call('getMinPos'),
            max = self:call('getMaxPos')
        };
    end

    return {
        min = self.__cache.multiblock.position.min,
        max = self.__cache.multiblock.position.max
    };
end

---@class MultiblockSize
---@field width number?
---@field length number?
---@field height number?

---Retrieves the multiblock structure's size from the instance's cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return MultiblockSize
function Multiblock:getSize(force)
    if (
        force == true or
        -- Cache is invalid
        self.__cache.multiblock.size == nil or
        self.__cache.multiblock.size.width == nil or
        self.__cache.multiblock.size.length == nil or
        self.__cache.multiblock.size.height == nil
    ) then
        self.__cache.multiblock.size = {
            width = self:call('getWidth'),
            length = self:call('getLength'),
            height = self:call('getHeight')
        };
    end

    return {
        width = self.__cache.multiblock.size.width,
        length = self.__cache.multiblock.size.length,
        height = self.__cache.multiblock.size.height
    };
end

---Entry in the :info() results table specific to multiblock information
---@class MultiblockInfo: PeripheralInfo
---@field multiblock MultiblockInfoEntry

---Multiblock :info() details
---@class MultiblockInfoEntry
---@field valid boolean
---@field position MultiblockPosition?
---@field size MultiblockSize?

---Retrieves static information pertaining to the multiblock from the
---instance's cache
---comment
---@param force boolean? When true the cache is forced to update
---@return MultiblockInfo
function Multiblock:info(force)
    force = force == true;

    local info = self.__super.info(self, force);

    local multiblockInfo = {
        valid = self:isValid()
    };

    if (multiblockInfo.valid) then
        multiblockInfo.position = self:getPosition(force);
        multiblockInfo.size = self:getSize(force);
    end

    ---@cast info MultiblockInfo
    info.multiblock = multiblockInfo;
    return info;
end

---Returns true if the multiblock is valid
---@return boolean # true if the multiblock is valid
function Multiblock:isValid()
    return self:call("isFormed") == true;
end


---Entry in the :status() results table specific to multiblock information
---@class MultiblockStatus: PeripheralStatus
---@field multiblock MultiblockStatusEntry

---Multiblock :status() details
---@class MultiblockStatusEntry
---@field valid boolean True if the multiblock is valid

---Retrieves dynamic information pertaining to the multiblock from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? ignored
---@return MultiblockStatus
function Multiblock:status(force)

    local status = self.__super.status(self);

    ---@cast status MultiblockStatus
    if (status.peripheral.valid == true) then
        status.multiblock = {
            valid = self:call('isFormed') == true
        }
    else
        status.multiblock = {
            valid = false
        };
    end
    return status;
end

return {
    class = Multiblock,
    create = new
};
