local class = require('common.class');
local Multiblock = require('classes.multiblock');

local tank = require('mixins.tank');

local

    ---Creates an new Boiler instance
    ---@type fun(peripheralName: string): ThermoelectricBoiler
    new,

    ---Boiler multiblock structure
    ---@class ThermoelectricBoiler: Multiblock
    ---@field __super Multiblock
    ---@field heatedCoolantTank Tank
    ---@field waterTank Tank
    ---@field cooledCoolantTank Tank
    ---@field steamTank Tank
    ThermoelectricBoiler = class.create(

        ---Constructor
        ---@param super fun(pipheralName: string):nil
        ---@param self ThermoelectricBoiler
        ---@param name string
        function (super, self, name)
            super(name);
            self.__cache.boiler = {};
        end,

        -- Super class
        Multiblock,

        -- Mixins
        tank.factory('boiler', 'Steam', 'steam'),
        tank.factory('boiler', 'Water', 'water'),
        tank.factory('boiler', 'CooledCoolant', 'cooledCoolant'),
        tank.factory('boiler', 'HeatedCoolant', 'heatedCoolant')
    );

--- Clears the instance's cache
function ThermoelectricBoiler:clearCache()
    self.__super.clearCache(self);
    self.__cache.boiler = {};
end

---Gets the max rate at which water is converted to steam the instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---
---Units: millibuckets/tick
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function ThermoelectricBoiler:getMaxBoilRate(force)
    if (force == true or self.__cache.boiler.maxBoilRate == nil) then
        self.__cache.boiler.maxBoilRate = self:call('getBoilCapacity');
    end
    return self.__cache.boiler.maxBoilRate;
end

---Gets the number of Superheaters associated with the boiler from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function ThermoelectricBoiler:getSuperHeaters(force)
    if (force == true or self.__cache.boiler.superHeaters == nil) then
        self.__cache.boiler.superHeaters = self:call('getSuperHeaters');
    end
    return self.__cache.boiler.superHeaters;
end

---Gets the current rate at which water is converted to steam
---
---Units: millibuckets/tick
---@return integer|nil
function ThermoelectricBoiler:getBoilRate()
    return self:call('getBoilRate');
end

---Gets the temperature lost to the environment
---
---Units: kelvins/tick
---@return integer|nil
function ThermoelectricBoiler:getEnvironmentalLoss()
    return self:call('getEnvironmentalLoss');
end

---Gets the max seen boil rate
---
---Units: millibuckets/tick
---@return integer|nil
function ThermoelectricBoiler:getMaxSeenBoilRate()
    return self:call('getMaxBoilRate');
end

---Gets the current temperature of the boilers
---
---Units: kelvins
---@return integer|nil
function ThermoelectricBoiler:getTemperature()
    return self:call('getTemperature');
end

---Entry in :info() results table specific to Boiler
---@class ThermoelectricBoilerInfo: MultiblockInfo
---@field thermoelectricBoiler ThermoelectricBoilerInfoEntry

---Boiler :info() details
---@class ThermoelectricBoilerInfoEntry
---@field superHeaters integer|nil
---@field maxBoilRate integer|nil
---@field steamTank TankInfo|nil
---@field waterTank TankInfo|nil
---@field cooledCoolantTank TankInfo|nil
---@field heatedCoolantTank TankInfo|nil

---Retrieves static information pertaining to the boiler from the instance's
---cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return ThermoelectricBoilerInfo
function ThermoelectricBoiler:info(force)
    force = force == true

    local info = self.__super.info(self, force);

    ---@cast info ThermoelectricBoilerInfo

    if (info.multiblock.valid == true) then
        info.thermoelectricBoiler = {
            superHeaters = self:getSuperHeaters(force),
            maxBoilRate = self:getMaxBoilRate(force),
            steamTank = self.steamTank.info(self, force),
            waterTank = self.waterTank.info(self, force),
            cooledCoolantTank = self.cooledCoolantTank.info(self, force),
            heatedCoolantTank = self.heatedCoolantTank.info(self, force)
        };
    else
        info.thermoelectricBoiler = {};
    end
    return info;
end

---Entry in :status() results table specific to Boiler
---@class ThermoelectricBoilerStatus : MultiblockStatus
---@field thermoelectricBoiler ThermoelectricBoilerStatusEntry

---Boiler :status() details
---@class ThermoelectricBoilerStatusEntry
---@field boilRate integer|nil
---@field cooledCoolantTank TankStatus|nil
---@field environmentalLoss integer|nil
---@field heatedCoolantTank TankStatus|nil
---@field maxSeenBoilRate integer|nil
---@field temperature integer|nil
---@field steamTank TankStatus|nil
---@field waterTank TankStatus|nil

---Retrieves dynamic information pertaining to the boiler
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return ThermoelectricBoilerStatus
function ThermoelectricBoiler:status(force)
    force = force == true;

    local status = self.__super.status(self);

    ---@cast status ThermoelectricBoilerStatus

    if (status.multiblock == true) then
        status.thermoelectricBoiler = {
            boilRate = self:getBoilRate(),
            cooledCoolantTank = self.cooledCoolantTank.status(self, force),
            environmentalLoss = self:getEnvironmentalLoss(),
            heatedCoolantTank = self.heatedCoolantTank.status(self, force),
            maxSeenBoilRate = self:getMaxSeenBoilRate(),
            steamTank = self.steamTank.status(self, force),
            temperature = self:getTemperature(),
            waterTank = self.waterTank.status(self, force)
        };
    else
        status.thermoelectricBoiler = {};
    end
    return status;
end

return {
    class = ThermoelectricBoiler,
    create = new
};