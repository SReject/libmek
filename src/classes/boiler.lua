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
    tank.factory('boiler', 'Steam', 'steam'),
    tank.factory('boiler', 'Water', 'water'),
    tank.factory('boiler', 'CooledCoolant', 'cooledCoolant'),
    tank.factory('boiler', 'HeatedCoolant', 'heatedCoolant')
);

function Boiler:clearCache()
    self.__super.clearCache(self);
    self.__cache.boiler = {};
end

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

function Boiler:info(force)
    force = force == true

    local info = self.__super.info(self, force);
    if (info.multiblock.valid ~= true) then
        info.boiler = {}
    else
        info.boiler = {
            superHeaters = self:getSuperHeaters(force),
            maxBoilRate = self:getMaxBoilRate(force),
            steamTank = self.steamTank.info(self, force),
            waterTank = self.waterTank.info(self, force),
            cooledCoolantTank = self.cooledCoolantTank.info(self, force),
            heatedCoolantTank = self.heatedCoolantTank.info(self, force)
        }
    end
    return info;
end

function Boiler:status(force)
    force = force == true;

    local status = self.__super.status(self);
    if (status.multiblock ~= true) then
        status.boiler = {};
    else
        status.boiler = {
            boilRate = self:getBoilRate(),
            cooledCoolantTank = self.cooledCoolantTank.status(self, force),
            environmentalLoss = self:getEnvironmentalLoss(),
            heatedCoolantTank = self.heatedCoolantTank.status(self, force),
            maxSeenBoilRate = self:getMaxSeenBoilRate(),
            steamTank = self.steamTank.status(self, force),
            temperature = self:getTemperature(),
            valveMode = self:getValveMode(),
            waterTank = self.waterTank.status(self, force)
        }
    end
    return status;
end

return {
    class = Boiler,
    create = new
};