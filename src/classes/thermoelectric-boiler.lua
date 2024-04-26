local class = require('common.class');

local Multiblock = require('classes.multiblock');

local tank = require('mixins.tank');

---Boiler multiblock structure
---@class LibmekThermoelectricBoiler: LibmekMultiblock
---@field __super LibmekMultiblock
---@field heatedCoolantTank LibmekDedicatedTankSlot
---@field waterTank LibmekDedicatedTankSlot
---@field cooledCoolantTank LibmekDedicatedTankSlot
---@field steamTank LibmekDedicatedTankSlot
local ThermoelectricBoiler = class.create(

    ---Constructor
    ---@param super fun(pipheralName: string):nil
    ---@param self LibmekThermoelectricBoiler
    ---@param name string
    function (super, self, name)
        super(name);
        self.__cache.thermoelectricBoiler = {};
    end,

    -- Super class
    Multiblock,

    -- Mixins
    tank.factory('boiler', 'Steam', 'steamTank'),
    tank.factory('boiler', 'Water', 'waterTank'),
    tank.factory('boiler', 'CooledCoolant', 'cooledCoolantTank'),
    tank.factory('boiler', 'HeatedCoolant', 'heatedCoolantTank')
);

--- Clears the instance's cache
function ThermoelectricBoiler:clearCache()
    self.__super.clearCache(self);
    self.__cache.thermoelectricBoiler = {};
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
    if (force == true or self.__cache.thermoelectricBoiler.maxBoilRate == nil) then
        self.__cache.thermoelectricBoiler.maxBoilRate = self:call('getBoilCapacity');
    end
    return self.__cache.thermoelectricBoiler.maxBoilRate;
end

---Gets the number of Superheaters associated with the boiler from the
---instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function ThermoelectricBoiler:getSuperHeaters(force)
    if (force == true or self.__cache.thermoelectricBoiler.superHeaters == nil) then
        self.__cache.thermoelectricBoiler.superHeaters = self:call('getSuperHeaters');
    end
    return self.__cache.thermoelectricBoiler.superHeaters;
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
---@class LibmekThermoelectricBoilerInfo: LibmekMultiblockInfo
---@field thermoelectricBoiler LibmekThermoelectricBoilerInfoEntry

---Boiler :info() details
---@class LibmekThermoelectricBoilerInfoEntry
---@field superHeaters integer|nil
---@field maxBoilRate integer|nil
---@field steamTank LibmekTankInfo|nil
---@field waterTank LibmekTankInfo|nil
---@field cooledCoolantTank LibmekTankInfo|nil
---@field heatedCoolantTank LibmekTankInfo|nil

---Retrieves static information pertaining to the boiler from the instance's
---cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekThermoelectricBoilerInfo Info
function ThermoelectricBoiler:info(force)
    force = force == true

    local info = self.__super.info(self, force);

    ---@cast info LibmekThermoelectricBoilerInfo

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
        self.__cache.thermoelectricBoiler = {};
        info.thermoelectricBoiler = {};
    end
    return info;
end

---Entry in :status() results table specific to Boiler
---@class LibmekThermoelectricBoilerStatus : LibmekMultiblockStatus
---@field thermoelectricBoiler LibmekThermoelectricBoilerStatusEntry

---Boiler :status() details
---@class LibmekThermoelectricBoilerStatusEntry
---@field boilRate integer|nil
---@field cooledCoolantTank LibmekTankStatus|nil
---@field environmentalLoss integer|nil
---@field heatedCoolantTank LibmekTankStatus|nil
---@field maxSeenBoilRate integer|nil
---@field temperature integer|nil
---@field steamTank LibmekTankStatus|nil
---@field waterTank LibmekTankStatus|nil

---Retrieves dynamic information pertaining to the boiler
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekThermoelectricBoilerStatus Status
function ThermoelectricBoiler:status(force)
    force = force == true;

    local status = self.__super.status(self);

    ---@cast status LibmekThermoelectricBoilerStatus

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
        self.__cache.thermoelectricBoiler = {};
        status.thermoelectricBoiler = {};
    end
    return status;
end

return { class = ThermoelectricBoiler };