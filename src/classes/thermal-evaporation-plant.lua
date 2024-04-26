local class = require('common.class');

local Multiblock = require('classes.multiblock').class;

local tank = require('mixins.tank');

---Thermal Evaporation Plant
---@class LibmekThermalEvaporationPlant : LibmekMultiblock
---@field __super LibmekMultiblock
---@field inputTank LibmekDedicatedTankSlot
---@field outputTank LibmekDedicatedTankSlot
local ThermalEvaporationPlant = class.create(

    ---Constructor
    ---@param super fun(peripheralName: string):nil
    ---@param self LibmekThermalEvaporationPlant
    ---@param peripheralName string The name of the underlaying peripheral name
    function (super, self, peripheralName)
        super(peripheralName);
        self.__cache.thermalEvaporationPlant = {}
    end,

    Multiblock,

    tank.factory('thermalEvaporationPlant', 'Input', 'inputTank'),
    tank.factory('thermalEvaporationPlant', 'Output', 'outputTank')
);

---Retrieves the number of active solar panels associated with the Thermal
---Evaporation Plant from the instance's cache
function ThermalEvaporationPlant:getActiveSolarPanels(force)
    if (force == true or self.__cache.thermalEvaporationPlant.solarPanels == nil) then
        self.__cache.thermalEvaporationPlant.solarPanels = self:call('getActiveSolars');
    end
    return self.__cache.thermalEvaporationPlant.solarPanels;
end

---Gets the amount of heat lost to the environment
---
---Units: Kelvins
---@return number|nil
function ThermalEvaporationPlant:getEnvironmentalLoss()
    return self:call('getEnvironmentalLoss');
end

---Retrieves information regarding the item currently in the fill-item input slot
---@return unknown|nil
function ThermalEvaporationPlant:getExportItemInputSlot()
    return self:call('getOutputItemInput');
end

---Retrieves information regarding the item currently in the fill-item output slot
---@return unknown|nil
function ThermalEvaporationPlant:getExportItemOutputSlot()
    return self:call('getOutputItemOutput');
end

---Retrieves information regarding the item currently in the drain-item input slot
---@return unknown|nil
function ThermalEvaporationPlant:getImportItemInputSlot()
    return self:call('getInputItemInput');
end

---Retrieves information regarding the item currently in the drain-item output slot
---@return unknown|nil
function ThermalEvaporationPlant:getImportItemOutputSlot()
    return self:call('getInputItemOutput');
end

---Retrieves the current rate at which the input is being converted to the output
---
---Units: Millibuckets/tick
---@return number|nil
function ThermalEvaporationPlant:getProductionRate()
    return self:call('getProductionAmount');
end

---Retrieves the current temperature of the plant
---
---Units: Kelvins
---@return number|nil
function ThermalEvaporationPlant:getTemperature()
    return self:call('getTemperature');
end

---Thermal Evaporation Plant's `:info()` results
---@class LibmekThermalEvaporationPlantInfo : LibmekMultiblockInfo
---@field thermalEvaporationPlant LibmekThermalEvaporationPlantInfoEntry

---Thermal Evaporation Plant's `:info()` entry
---@class LibmekThermalEvaporationPlantInfoEntry
---@field solarPanels number|nil

---Retrieves static information pertaining to the Thermal Evaporation Plant
---from the instance's cache.
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekThermalEvaporationPlantInfo
function ThermalEvaporationPlant:info(force)
    local info = self.__super.info(self, force);

    ---@cast info LibmekThermalEvaporationPlantInfo

    if (info.multiblock.valid) then
        info.thermalEvaporationPlant = { solarPanels = self:getActiveSolarPanels() };
    else
        self.__cache.thermalEvaporationPlant = {};
        info.thermalEvaporationPlant = {};
    end

    return info;
end

---Thermal Evaporation Plant's `:status()` results
---@class LibmekThermalEvaporationPlantStatus : LibmekMultiblockStatus
---@field thermalEvaporationPlant LibmekThermalEvaporationPlantStatusEntry

---Thermal Evaporation Plant's `:status()` entry
---@class LibmekThermalEvaporationPlantStatusEntry
---@field environmentalLoss number|nil
---@field exportItemInputSlot unknown|nil
---@field exportItemOutputSlot unknown|nil
---@field importItemInputSlot unknown|nil
---@field importItemOutputSlot unknown|nil

---Retrieves dynamic information pertaining to the Thermal Evaporation Plant
---
---If the cache does not contain a given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cache is forced to update
---@return LibmekThermalEvaporationPlantStatus
function ThermalEvaporationPlant:status(force)
    local status = self.__super.status(self, force);

    ---@cast status LibmekThermalEvaporationPlantStatus

    if (status.multiblock.valid) then
        status.thermalEvaporationPlant = {
            environmentalLoss = self:getEnvironmentalLoss(),
            exportItemInputSlot = self:getExportItemInputSlot(),
            exportItemOutputSlot = self:getExportItemOutputSlot(),
            importItemInputSlot = self:getImportItemInputSlot(),
            importItemOutputSlot = self:getImportItemOutputSlot(),
            productionRate = self:getProductionRate(),
            temperature = self:getTemperature()
        };
    else
        self.__cache.thermalEvaporationPlant = {};
        status.thermalEvaporationPlant = {};
    end

    return status;
end

return { class = ThermalEvaporationPlant };