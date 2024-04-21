local class = require('common.class');
local utils = require('common.utilities');

local new, Peripheral = class.create(

    -- constructor
    function (super, self, name)
        if type(name) ~= "string" or name == "" then
            error('invalid peripheral name');
        end

        if (self.__cache == nil) then
            self.__cache = {}
        end

        self.__cache.peripheral = {};
        self.peripheralName = name;

        self.__detechWatcher = coroutine.create(function ()
            while (1) do
                local event, side = os.pullEvent('peripheral_detach');
                if (side == self.peripheralName) then
                    self.__cache.peripheral = {};
                    break;
                end
            end
        end)
    end
);

function Peripheral:call(method, ...)
    return peripheral.call(method, table.unpack(...));
end

function Peripheral:clearCache()
    self.__cache.peripheral = {};
end

function Peripheral:getMethods(force)
    if (force == true or self.__cache.peripheral.methods == nil) then
        self.__cache.peripheral.methods = peripheral.getMethods(self.peripheralName) or {};
    end

    return utils.copyArray(self.__cache.peripheral.methods);
end

function Peripheral:getTypes(force)
    if (force == true or self.__cache.peripheral.types == nil) then
        self.__cache.peripheral.types = {peripheral.getType(self.peripheralName)};
    end

    return utils.copyArray(self.__cache.peripheral.types);
end

function Peripheral:hasType(peripheralType)
    return peripheral.hasType(self.peripheralName, peripheralType) or false;
end

function Peripheral:isValid()
    if (type(self.peripheralName) == "string" and self.peripheralName ~= "") then
        return peripheral.isPresent(self.peripheralName);
    end

    return false;
end

function Peripheral:info()
    return {
        peripheral = {
            name = self.peripheralName,
            valid = self:isValid()
        }
    };
end

function Peripheral:status()
    return {
        peripheral = {
            valid = self:isValid();
        }
    };
end

return {
    class = Peripheral,
    create = new
};