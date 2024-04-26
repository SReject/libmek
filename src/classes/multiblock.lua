local class = require('common.class');

local Peripheral = require('classes.peripheral');

---Multiblock structure
---@class LibmekMultiblock: LibmekPeripheral
---@field __super LibmekPeripheral
local Multiblock = class.create(

    ---Constructor
    ---@param super fun(name: string):nil
    ---@param self LibmekMultiblock
    ---@param name string
    function (super, self, name)
        super(name);
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

---@class LibmekMultiblockPositionPoint
---@field x number
---@field y number
---@field z number

---@class LibmekMultiblockPosition
---@field min LibmekMultiblockPositionPoint?
---@field max LibmekMultiblockPositionPoint?

---Retrieves the positions of opposing corners comprising the multiblock
---structure from the instance's cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekMultiblockPosition Position
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

---@class LibmekMultiblockSize
---@field width number?
---@field length number?
---@field height number?

---Retrieves the multiblock structure's size from the instance's cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekMultiblockSize Size
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

---Multiblock's :info() results
---@class LibmekMultiblockInfo: LibmekPeripheralInfo
---@field multiblock LibmekMultiblockInfoEntry

---Multiblock's :info() entry
---@class LibmekMultiblockInfoEntry
---@field valid boolean
---@field position LibmekMultiblockPosition?
---@field size LibmekMultiblockSize?

---Retrieves static information pertaining to the multiblock from the
---instance's cache
---comment
---@param force boolean? When true the cache is forced to update
---@return LibmekMultiblockInfo Info
function Multiblock:info(force)
    local info = self.__super.info(self, force);

    ---@cast info LibmekMultiblockInfo

    if (info.peripheral.valid and self:isValid()) then
        info.multiblock = {
            position = self:getPosition(force),
            size = self:getSize(force),
            valid = true
        };
    else
        self.__cache.multiblock = {};
        info.multiblock = { valid = false };
    end

    return info;
end

---Returns true if the multiblock is valid
---@return boolean # true if the multiblock is valid
function Multiblock:isValid()
    return self:call("isFormed") == true;
end

---Multiblock's :status() results
---@class LibmekMultiblockStatus: LibmekPeripheralStatus
---@field multiblock LibmekMultiblockStatusEntry

---Multiblock's :status() entry
---@class LibmekMultiblockStatusEntry
---@field valid boolean True if the multiblock is valid

---Retrieves dynamic information pertaining to the multiblock from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? ignored
---@return LibmekMultiblockStatus Status
function Multiblock:status(force)

    local status = self.__super.status(self, force);

    ---@cast status LibmekMultiblockStatus
    if (status.peripheral.valid == true and self:isValid() == true) then
        status.multiblock = { valid = true }
    else
        self.__cache.multiblock = {};
        status.multiblock = { valid = false };
    end
    return status;
end

return { class = Multiblock };
