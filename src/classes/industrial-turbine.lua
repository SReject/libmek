local class = require('common.class');
local Multiblock = require('classes.multiblock');

local energybuffer = require('mixins.energybuffer');
local tank = require('mixins.tank');

local

    ---Creates a new IndustrialTurbine instance
    ---@type fun(peripheralName: string): IndustrialTurbine
    new,

    ---Turbine multiblock structure
    ---@class IndustrialTurbine: Multiblock
    ---@field __super Multiblock
    ---@field energy EnergyBuffer
    ---@field steamTank Tank
    IndustrialTurbine = class.create(

        ---Constructor
        ---@param super fun(name: string):nil
        ---@param self IndustrialTurbine
        ---@param name string
        function (super, self, name)
            super(name);
            self.__cache.turbine = {};
        end,

        -- Super class
        Multiblock,

        -- Mixins
        energybuffer.factory('turbine'),
        tank.factory('turbine', 'Steam', 'steam')
    );

--- Clears the instance's cache
function IndustrialTurbine:clearCache()
    self.__super.clearCache(self);
    self.__cache.turbine = {};
end

---Gets the number of rotor blades comprising the turbine from the cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function IndustrialTurbine:getBlades(force)
    if (force == true or self.__cache.turbine.blades == nil) then
        self.__cache.turbine.blades = self:call('getBlades');
    end
    return self.__cache.turbine.blades;
end

---Gets the number of electromagnetic coils comprising the turbine from the
---cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function IndustrialTurbine:getCoils(force)
    if (force == true or self.__cache.turbine.coils == nil) then
        self.__cache.turbine.coils = self:call('getCoils');
    end
    return self.__cache.turbine.coils;
end

---Gets the number of saturating condensers comprising the turbine from the
---cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function IndustrialTurbine:getCondensers(force)
    if (force == true or self.__cache.turbine.condensers == nil) then
        self.__cache.turbine.condensers = self:call('getCondensers');
    end
    return self.__cache.turbine.condensers;
end

---Gets the number of pressure dispersers comprising the turbine from the
---cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function IndustrialTurbine:getDispersers(force)
    if (force == true or self.__cache.turbine.dispersers == nil) then
        self.__cache.turbine.dispersers = self:call('getDispersers');
    end
    return self.__cache.turbine.dispersers;
end

---Gets the number of turbine vents comprising the turbine from the cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function IndustrialTurbine:getVents(force)
    if (force == true or self.__cache.turbine.vents == nil) then
        self.__cache.turbine.vents = self:call('getVents');
    end
    return self.__cache.turbine.vents;
end

---Gets the turbine's maximum possible flow rate from the cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---
---Units: millibuckets/tick
---@param force boolean? When true the cache is forced to update
---@return number|nil
function IndustrialTurbine:getMaxFlowRate(force)
    if (force == true or self.__cache.turbine.maxFlowRate == nil) then
        self.__cache.turbine.maxFlowRate = self:call('getMaxFlowRate');
    end
    return self.__cache.turbine.maxFlowRate;
end

---Gets the turbine's maximum possible energy production rate from the cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---
---Units: joules/tick
---@param force boolean? When true the cache is forced to update
---@return number|nil
function IndustrialTurbine:getMaxProduction(force)
    if (force == true or self.__cache.turbine.maxProduction == nil) then
        self.__cache.turbine.maxProduction = self:call('getMaxProduction');
    end
    return self.__cache.turbine.maxProduction;
end

---Gets the turbine's maximum possible water output rate from the cache.
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---
---Units: millibuckets/tick
---@param force boolean? When true the cache is forced to update
---@return number|nil
function IndustrialTurbine:getMaxWaterOutput(force)
    if (force == true or self.__cache.turbine.maxWaterOutput == nil) then
        self.__cache.turbine.maxWaterOutput = self:call('getMaxWaterOutput');
    end
    return self.__cache.turbine.maxWaterOutput;
end

---Gets the turbine's current flow rate
---
---Units: millibuckets/tick
---@return number|nil
function IndustrialTurbine:getFlowRate()
    return self:call('getFlowRate');
end

---Gets the turbine's steam input rate for the last tick
---
---Units: millibuckets/tick
---@return number|nil
function IndustrialTurbine:getLastSeenSteamInputRate()
    return self:call('getLastSteamInputRate');
end

---Gets the turbine's current energy production rate
---
---Units: joules/tick
---@return number|nil
function IndustrialTurbine:getProductionRate()
    return self:call('getProductionRate');
end

---@alias GasDumpingMode
---| "IDLE"
---| "DUMPING_EXCESS"
---| "DUMPING"

---Gets the turbine's current dumping mode
---@return GasDumpingMode
function IndustrialTurbine:getDumpingMode()
    return self:call('getDumpingMode');
end

---Sets the turbine's excess steam dumping mode
---@return GasDumpingMode|nil
function IndustrialTurbine:setDumpingMode(mode)
end

---Decreases the turbine's dumping mode
function IndustrialTurbine:decrementDumpingMode()
    return self:call('decrementDumpingMode');
end

---Increases the turbine's dumping mode
function IndustrialTurbine:incrementDumpingMode()
    return self:call('incrementDumpingMode')
end

---Entry in the :info() result table specific to Turbine
---@class IndustrialTurbineInfo: MultiblockInfo
---@field industrialTurbine IndustrialTurbineInfoEntry

---Turbine :info() details
---@class IndustrialTurbineInfoEntry
---@field blades integer? The number of blades associated with the turbine
---@field coils integer? The number of electromagnet coils associated with the turbine
---@field condensers integer? The number of saturating condensers associated with the turbine
---@field dispersers integer? The number of pressure dispersers associated with the turbine
---@field energy EnergyBufferInfo? Static details pretaining to the turbine's energy buffer
---@field maxFlowRate integer? The maximum possible amount of steam that can be consumed per tick
---@field maxProduction integer? The maximum possible amount of energy that can be produced each tick
---@field maxWaterOutput integer? The maximum amount of water the turbine can output each tick
---@field steamTank TankInfo? Static details pertaining to the turbine's steam tank
---@field vents integer? The number of turbine vents associated with the turbine

---Retrieves static information pretaining to the turbine from the cache.
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return IndustrialTurbineInfo
function IndustrialTurbine:info(force)
    force = force == true;

    local info = self.__super.info(self, force);

    ---@cast info IndustrialTurbineInfo

    if (info.multiblock.valid == true) then
        info.industrialTurbine = {
            blades = self:getBlades(force),
            coils = self:getCoils(force),
            condensers = self:getCondensers(force),
            dispersers = self:getDispersers(force),
            energy = self.energy.info(self, force),
            maxFlowRate = self:getMaxFlowRate(force),
            maxProduction = self:getMaxProduction(force),
            maxWaterOutput = self:getMaxWaterOutput(force),
            steamTank = self.steamTank.info(self, force),
            vents = self:getVents(force)
        };
    else
        info.industrialTurbine = {};
    end
    return info;
end

---Entry in the :status() result table specific to Turbine
---@class IndustrialTurbineStatus: MultiblockStatus
---@field industrialTurbine IndustrialTurbineStatusEntry

---Turbine :status() details
---@class IndustrialTurbineStatusEntry
---@field dumpingMode GasDumpingMode|nil
---@field energy EnergyBufferStatus|nil
---@field flowRate integer|nil
---@field lastSeenSteamInputRate integer|nil
---@field productionRate integer|nil
---@field steam TankStatus|nil

---Retrieves dynamic information pertaining to the turbine instance
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return IndustrialTurbineStatus
function IndustrialTurbine:status(force)
    force = force == true;

    local status = self.__super.status(self, force);

    ---@cast status IndustrialTurbineStatus

    if (status.multiblock.valid ~= true) then
        status.industrialTurbine = {
            dumpingMode = self.getDumpingMode(self),
            energy = self.energy.status(self, force),
            flowRate = self:getFlowRate(),
            lastSeenSteamInputRate = self:getLastSeenSteamInputRate(),
            productionRate = self:getProductionRate(),
            steam = self.steamTank.status(self, force)
        };
    else
        status.industrialTurbine = {};
    end
    return status;
end

return {
    class = IndustrialTurbine,
    create = new
};