local class = require('common.class');
local Peripheral = require('classes.peripheral');

local new, Multiblock = class.create(

    -- constructor
    function (super, self, name)
        super(name);
        if (self:call('isFormed') ~= true) then
            error("multiblock is not formed");
        end
        self.__cache.multiblock = {};
    end,

    -- super class
    Peripheral.class
);

function Multiblock:clearCache()
    self.__super.clearCache(self);
    self.__cache.multiblock = {};
end

function Multiblock:getPosition(force)
    if (
        force == true or
        -- Cache is invalid
        self.__cahce.multiblock.position == nil or
        self.__cahce.multiblock.position.min == nil or
        self.__cahce.multiblock.position.max == nil
    ) then
        self.__cache.multiblock.position = {
            min = self:call('getMinPos'),
            max = self:call('getMaxPos')
        };
    end

    return {
        min = self.__cahce.multiblock.position.min,
        max = self.__cahce.multiblock.position.max
    };
end

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

    info.multiblock = multiblockInfo;
    return info;
end

function Multiblock:isValid()
    return self:call("isFormed") == true;
end

function Multiblock:status()
    local status = self.__super.status(self);
    if (status.peripheral.valid ~= true) then
        status.multiblock = {
            valid = false
        };
    else
        status.multiblock = {
            valid = self:call('isFormed') == true
        }
    end
    return status;
end

return {
    class = Multiblock,
    create = new
};
