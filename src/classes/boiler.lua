local class = require('common.class');
local Multiblock = require('classes.multiblock');

local tank = require('mixins.tank');

local new, Boiler = class.create(

    -- constructor
    function (super, self, name)
        super(name);
        self.__cache.boiler = {};
    end,

    -- super class
    Multiblock,

    -- Mixins
    tank.factory('Steam', 'steam'),
    tank.factory('Water', 'water'),
    tank.factory('CooledCoolant', 'cooledCoolant'),
    tank.factory('HeatedCoolant', 'heatedCoolant')
);

function Boiler:getMaxBoilRate(force)
    if (force == true or self.__cache.boiler.maxBoilRate == nil) then
        self.__cache.boiler.maxBoilRate = self:call('getBoilCapacity');
    end
    return self._cache.boiler.maxBoilRate;
end

function Boiler:getSuperHeaters(force)
    if (force == true or self.__cache.boiler.superHeaters == nil) then
        self.__cache.boiler.superHeaters = self:call('getSuperHeaters');
    end
end

function Boiler:getBoilRate()
    return self:call('getBoilRate');
end

function Boiler:getEnvironmentalLoss()
    return self:call('getEnvironmentalLoss');
end

function Boiler:getMaxSeenBoilRate()
    return self:call('getMaxBoilRate');
end

function Boiler:getTemperature()
    return self:call('getTemperature');
end

function Boiler:getValveMode()
    return self:call('getMode');
end

function Boiler:setValveMode(mode)
    return self:call('setMode', mode);
end

function Boiler:decrementValveMode()
    return self:call('decrementValveMode');
end

function Boiler:incrementValveMode()
    return self:call('incrementValveMode');
end

function Boiler:info()
    local info = self.__super.info(self);
    if (info.multiblock.valid ~= true) then
        info.boiler = {}
    else
        info.boiler = {
            superHeaters = self:getSuperHeaters(),
            maxBoilRate = self:getMaxBoilRate(),
            steamTank = self.steamTank.info(self),
            waterTank = self.waterTank.info(self),
            cooledCoolantTank = self.cooledCoolantTank.info(self),
            heatedCoolantTank = self.heatedCoolantTank.info(self)
        }
    end
    return info;
end

function Boiler:status()
    local status = self.__super.status(self);
    if (status.multiblock ~= true) then
        status.boiler = {};
    else
        status.boiler = {
            boilRate = self:getBoilRate(),
            cooledCoolantTank = self.cooledCoolantTank.status(self),
            environmentalLoss = self:getEnvironmentalLoss(),
            heatedCoolantTank = self.heatedCoolantTank.status(self),
            maxSeenBoilRate = self:getMaxSeenBoilRate(),
            steamTank = self.steamTank.status(self),
            temperature = self:getTemperature(),
            valveMode = self:getValveMode(),
            waterTank = self.waterTank.status(self)
        }
    end
    return status;
end

return {
    class = Boiler,
    create = new
};