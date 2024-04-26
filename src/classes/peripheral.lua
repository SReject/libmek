--Reference to global peripheral; speeds up calls
local peripheral = peripheral;

local class = require('common.class');

local utils = require('common.utilities');

---Underlaying peripheral connecting a CC:Tweaked computer to a Mekanism structure or block
---@class LibmekPeripheral: LibmekInstantable
---@field peripheralName string
---@field __cache table<string, table<string, any>>
local Peripheral = class.create(

    ---Constructor
    ---@param self LibmekPeripheral
    ---@param name string
    function (super, self, name)
        if type(name) ~= "string" or name == "" then
            error('invalid peripheral name');
        end

        if (self.__cache == nil) then
            self.__cache = {}
        end

        self.__cache.peripheral = {};
        self.peripheralName = name;
    end
);

---Calls the given method for the peripheral
---@param method string The method to call
---@param ... any The arguments to pass to the method
---@return ... Result of the call
function Peripheral:call(method, ...)
    return peripheral.call(method, table.unpack(...));
end

---Clears the instance's cache
function Peripheral:clearCache()
    self.__cache.peripheral = {};
end

---Retrieves the peripheral's available methods from cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to update
---@return string[] # The list of available methods
function Peripheral:getMethods(force)
    if (force == true or self.__cache.peripheral.methods == nil) then
        self.__cache.peripheral.methods = peripheral.getMethods(self.peripheralName) or {};
    end
    return utils.copyArray(self.__cache.peripheral.methods);
end

---Retrieves the peripheral's associated types from cache
---
---If the cache does not contain the given value it is retrieved from the
---connecting peripheral.
---@param force boolean? When true the cached value is forced to update
---@return string[] # The list of associated peripheral types
function Peripheral:getTypes(force)
    if (force == true or self.__cache.peripheral.types == nil) then
        self.__cache.peripheral.types = {peripheral.getType(self.peripheralName)};
    end
    return utils.copyArray(self.__cache.peripheral.types);
end

---Returns true if the peripheral has the specified type associated with it.
---@return boolean
function Peripheral:hasType(peripheralType)
    return peripheral.hasType(self.peripheralName, peripheralType) == true;
end

---Returns true if the peripheral is valid
---@return boolean
function Peripheral:isValid()
    if (type(self.peripheralName) == "string" and self.peripheralName ~= "") then
        return peripheral.isPresent(self.peripheralName);
    end
    return false;
end

---Entry in the :info() result table specific to Peripheral
---@class LibmekPeripheralInfo
---@field peripheral LibmekPeripheralInfoEntry

---Peripheral :info() details
---@class LibmekPeripheralInfoEntry
---@field name string The identifying name of the peripheral
---@field valid boolean True if the peripheral is valid

---Returns information regarding the peripheral instance
---@param force any? Ignored
---@return LibmekPeripheralInfo Info
function Peripheral:info(force)

    local isValid = self:isValid() == true;
    if (isValid == false) then
        self.__cache.peripheral = {};
    end

    return {
        peripheral = {
            name = self.peripheralName,
            valid = isValid
        }
    }
end

---Entry in the :status() result table specific to Peripheral
---@class LibmekPeripheralStatus
---@field peripheral LibmekPeripheralStatusEntry

---Peripheral :status() details
---@class LibmekPeripheralStatusEntry
---@field valid boolean True if the peripheral is valid

---Returns dynamic information pertaining to the peripheral instance
---@param force any? Ignored
---@return LibmekPeripheralStatus Status
function Peripheral:status(force)

    local isValid = self:isValid() == true;
    if (isValid == false) then
        self.__cache.peripheral = {};
    end

    return { peripheral = { valid = isValid } }
end

return { class = Peripheral };