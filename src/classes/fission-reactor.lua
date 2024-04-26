local class = require('common.class');

local Multiblock = require('classes.multiblock');

local tank  = require('mixins.tank');

---Fission Reactor multiblock structure
---@class LibmekFissionReactor: LibmekMultiblock
---@field __super LibmekMultiblock
---@field coolantTank LibmekDedicatedTankSlot
---@field fuelTank LibmekDedicatedTankSlot
---@field heatedCoolantTank LibmekDedicatedTankSlot
---@field wasteTank LibmekDedicatedTankSlot
local FissionReactor = class.create(

    ---Constructor
    ---@param super fun(peripheralName: string):nil
    ---@param self LibmekFissionReactor
    ---@param name string
    function (super, self, name)
        super(name);
        self.__cache.fissionReactor = {};
    end,

    -- Super class
    Multiblock,

    -- Mixins
    tank.factory('fissionReactor', 'Coolant', 'coolantTank'),
    tank.factory('fissionReactor', 'Fuel', 'fuelTank'),
    tank.factory('fissionReactor', 'HeatedCoolant', 'heatedCoolantTank'),
    tank.factory('fissionReactor', 'Waste', 'wasteTank')
);

---Activates the reactor if it is not already running
function FissionReactor:activate()
    return self:call('activate');
end

---Clears the instance's cache
function FissionReactor:clearCache()
    self.__super.clearCache(self);
    self.__cache.fissionReactor = {};
end

---Retrieves the actual burn rate of the reactor
---This differs from the set burn rate in cases where there's not enough fuel to meet the set burn rate
---@return integer|nil
function FissionReactor:getActualBurnRate()
    return self:call('getActualBurnRate');
end

---Retrieves the boil efficency when converting water to steam
---
---@return number|nil
function FissionReactor:getBoilEfficiency()
    return self:call('getBoilEfficiency');
end

---Retrieves the current configured burn rate
---
---Units: millibuckets/tick
---@return integer|nil
function FissionReactor:getBurnRate()
    return self:call('getBurnRate');
end

---Retrieves the current reactor damage percentage as a decimal
---@return number|nil
function FissionReactor:getDamagePercentage()
    return self:call('getDamagePercent');
end

---Retrieves the temperature lost to the environment
---
---Units: kelvins/tick
---@return integer|nil
function FissionReactor:getEnvironmentalLoss()
    return self:call('getEnvironmentalLoss');
end

---Retrieves the number of fuel assemblies associated with the fission reactor
---from cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return integer|nil
function FissionReactor:getFuelRodAssemblies(force)
    if (force == true or self.__cache.fissionReactor.fuelRodAssemblies == nil) then
        self.__cache.fissionReactor.fuelRodAssemblies = self:call('getFuelAssemblies');
    end
    return self.__cache.fissionReactor.fuelRodAssemblies;
end

---Retrieves the fuel rod surface area from the instance's cache.
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to be updated.
---@return number|nil
function FissionReactor:getFuelSurfaceArea(force)
    if (force == true or self.__cache.fissionReactor.fuelSurfaceArea == nil) then
        self.__cache.fissionReactor.fuelSurfaceArea = self:call('getFuelSurfaceArea');
    end
    return self.__cache.fissionReactor.fuelSurfaceArea;
end

---Retrieves the reactor's maximum heat capacity from the instance's cache
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to update
---@return number|nil
function FissionReactor:getHeatCapacity(force)
    if (force == true or self.__cache.fissionReactor.heatCapacity == nil) then
        self.__cache.fissionReactor.heatCapacity = self:call('getHeatCapacity');
    end
    return self.__cache.fissionReactor.heatCapacity;
end

---Retrieves the current rate of heating
---
---TODO: figure out units
---@return number|nil
function FissionReactor:getHeatingRate()
    return self:call('getHeatingRate');
end

---Retrieves the maximum fuel burn rate from the instance's cache.
---
---Units: millibuckets/tick
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to update
---@return integer|nil
function FissionReactor:getMaxBurnRate(force)
    if (force == true or self.__cache.fissionReactor.maxBurnRate == nil) then
        self.__cache.fissionReactor.maxBurnRate = self:call('getMaxBurnRate');
    end
    return self.__cache.fissionReactor.maxBurnRate;
end

---Retrieves the reactor's current activation status
---@return boolean `true` if the reactor is currently active/running
function FissionReactor:isActive()
    return self:call('getStatus') == true;
end

---Retrieves the reactor's current temperature
---@return integer|nil
function FissionReactor:getTemperature()
    return self:call('getTemperature');
end

---Retrieves the forced disable status
---@returns boolean `true` if the reactor was forced disabled
function FissionReactor:isForcedDisable()
    return self:call('isForceDisable') == true;
end

---Deactivates the reactor
function FissionReactor:scram()
    return self:call('scram');
end

---Sets the reactor's fuel burn rate
---@param rate integer
function FissionReactor:setBurnRate(rate)
    return self:call('setBurnRate', rate);
end

---Fission Reactor :info() results
---@class LibmekFissionReactorInfo: LibmekMultiblockInfo
---@field fissionReactor FissionReactorInfoEntry

---Fission Reactor's :info() entry
---@class FissionReactorInfoEntry
---@field fuelTank LibmekTankInfo|nil
---@field wasteTank LibmekTankInfo|nil
---@field coolantTank LibmekTankInfo|nil
---@field heatedCoolantTank LibmekTankInfo|nil
---@field fuelRodAssembles integer|nil
---@field heatCapacity integer|nil
---@field maxBurnRate integer|nil

---Retrieves static information pertaining to the reactor instance
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true cached values are forced to update
---@return LibmekFissionReactorInfo
function FissionReactor:info(force)
    local info = self.__super.info(self, force);

    ---@cast info LibmekFissionReactorInfo

    if (info.multiblock.valid) then
        info.fissionReactor = {
            fuelTank = self.fuelTank.info(self, force),
            wasteTank = self.wasteTank.info(self, force),
            coolantTank = self.coolantTank.info(self, force),
            heatedCoolantTank = self.heatedCoolantTank.info(self, force),
            fuelRodAssemblies = self:getFuelRodAssemblies(force),
            heatCapacity = self:getHeatCapacity(force),
            maxBurnRate = self:getMaxBurnRate(force),
        };
    else
        self.__cache.fissionReactor = {};
        info.fissionReactor = {};
    end
    return info;
end

---Fission Reactor's :status() results
---@class LibmekFissionReactorStatus: LibmekMultiblockStatus
---@field fissionReactor LibmekFissionReactorStatusEntry

---Fission Reactor's :status() entry
---@class LibmekFissionReactorStatusEntry
---@field active boolean|nil
---@field actualBurnRate integer|nil
---@field boilEfficency number|nil
---@field burnRate integer|nil
---@field damage number|nil
---@field environmentalLoss number|nil
---@field heatingRate number|nil
---@field temperature number|nil
---@field forceDisabled boolean|nil
---@field fuelTank LibmekTankStatus|nil
---@field wasteTank LibmekTankStatus|nil
---@field coolantTank LibmekTankStatus|nil
---@field heatedCoolantTank LibmekTankStatus|nil

---Retrieves dynamic information pertaining to the reactor instance
---@param force boolean? Applicable valves that are retrieved from cache are forced to update
---@return LibmekFissionReactorStatus
function FissionReactor:status(force)
    local status = self.__super.status(self, force);

    ---@cast status LibmekFissionReactorStatus
    if (status.multiblock.valid) then
        status.fissionReactor = {
            active = self:isActive(),
            actualBurnRate = self:getActualBurnRate(),
            boilEfficency = self:getBoilEfficiency(),
            burnRate = self:getBurnRate(),
            damage = self:getDamagePercentage(),
            environmentalLoss = self:getEnvironmentalLoss(),
            heatingRate = self:getHeatingRate(),
            temperature = self:getTemperature(),
            forceDisabled = self:isForcedDisable(),

            fuelTank = self.fuelTank.status(self, force),
            wasteTank = self.wasteTank.status(self, force),
            coolantTank = self.coolantTank.status(self, force),
            heatedCoolantTank = self.heatedCoolantTank.status(self, force)
        };
    else
        self.__cache.fissionReactor = {};
        status.fissionReactor = {};
    end
    return status;
end

return { class = FissionReactor };