local class = require('common.class');
local Multiblock = require('classes.multiblock');

local energybuffer = require('mixins.energybuffer');
local tank = require('mixins.tank');

local new, Turbine = class.create(

    -- constructor
    function (super, self, name)
        super(self);
        self.__cache.turbine = {};
    end,

    -- super class
    Multiblock,

    -- Mixins
    energybuffer.factory('turbine'),
    tank.factory('turbine', 'Steam', 'steam')
);

function Turbine:clearCache()
    self.__super.clearCache(self);
    self.__cache.turbine = {};
end

function Turbine:getBlades(force)
    if (force == true or self.__cache.turbine.blades == nil) then
        self.__cache.turbine.blades = self:call('getBlades');
    end
    return self.__cache.turbine.blades;
end

function Turbine:getCoils(force)
    if (force == true or self.__cache.turbine.coils == nil) then
        self.__cache.turbine.coils = self:call('getCoils');
    end
    return self.__cache.turbine.coils;
end

function Turbine:getCondensers(force)
    if (force == true or self.__cache.turbine.condensers == nil) then
        self.__cache.turbine.condensers = self:call('getCondensers');
    end
    return self.__cache.turbine.condensers;
end

function Turbine:getDispersers(force)
    if (force == true or self.__cache.turbine.dispersers == nil) then
        self.__cache.turbine.dispersers = self:call('getDispersers');
    end
    return self.__cache.turbine.dispersers;
end

function Turbine:getVents(force)
    if (force == true or self.__cache.turbine.vents == nil) then
        self.__cache.turbine.vents = self:call('getVents');
    end
    return self.__cache.turbine.vents;
end

function Turbine:getMaxFlowRate(force)
    if (force == true or self.__cache.turbine.maxFlowRate == nil) then
        self.__cache.turbine.maxFlowRate = self:call('getMaxFlowRate');
    end
    return self.__cache.turbine.maxFlowRate;
end

function Turbine:getMaxProduction(force)
    if (force == true or self.__cache.turbine.maxProduction == nil) then
        self.__cache.turbine.maxProduction = self:call('getMaxProduction');
    end
    return self.__cache.turbine.maxProduction;
end

function Turbine:getMaxWaterOutput(force)
    if (force == true or self.__cache.turbine.maxWaterOutput == nil) then
        self.__cache.turbine.maxWaterOutput = self:call('getMaxWaterOutput');
    end
    return self.__cache.turbine.maxWaterOutput;
end

function Turbine:getFlowRate()
    return self:call('getFlowRate');
end

function Turbine:getLastSeenSteamInputRate()
    return self:call('getLastSteamInputRate');
end

function Turbine:getProductionRate()
    return self:call('getProductionRate');
end

function Turbine:getDumpingMode()
    return self:call('getDumpingMode');
end

function Turbine:decrementDumpingMode()
    return self:call('decrementDumpingMode');
end

function Turbine:incrementDumpingMode()
    return self:call('incrementDumpingMode')
end

function Turbine:info(force)
    force = force == true;

    local info = self.__super.info(self, force);

    if (info.multiblock.valid ~= true) then
        info.turbine = {};
    else
        info.turbine = {
            blade = self:getBlades(force),
            coils = self:getCoils(force),
            condensers = self:getCondensers(force),
            despersers = self:getDispersers(force),
            energy = self.energy.info(self, force),
            maxFlowRate = self:getMaxFlowRate(force),
            maxProduction = self:getMaxProduction(force),
            maxWaterOutput = self:getMaxWaterOutput(force),
            steamTank = self.steamTank.info(self, force),
            vents = self:getVents(force),

        };
    end
    return info;
end

function Turbine:status(force)
    force = force == true;

    local status = self.__super.status(self, force);
    if (status.multiblock.valid ~= true) then
        status.turbine = {};
    else
        status.turbine = {
            energy = self.energy.status(self, force),
            flowRate = self:getFlowRate(),
            lastSeenSteamInputRate = self:getLastSeenSteamInputRate(),
            productionRate = self:getProductionRate(),
            steam = self.steamTank.status(self, force)
        };
    end
    return status;
end

return {
    class = Turbine,
    create = new
};