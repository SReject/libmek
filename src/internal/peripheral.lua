---Peripheral class
---@class LibmekPeripheral : LibmekFactoryClass
---@field call fun(self: LibmekPeripheral, method, ...):unknown Calls the method on the underlaying peripheral
---@field getMethods fun(self: LibmekPeripheral, force: boolean):table Returns a list of available methods on the peripheral
---@field getTypes fun(self: LibmekPeripheral, force: boolean):table Returns a list of peripheral types associated with the peripheral
---@field hasType fun(self: LibmekPeripheral, type: string):boolean Returns true if the peripheral has the given type
---@field help fun(self: LibmekPeripheral, method:string?):{[string]:any} Class the underlaying peripheral's 'help()' method and returns the result
---@field isValid fun(self: LibmekPeripheral):boolean Returns true if the peripheral is present
---@field peripheralName string The underlaying peripheral name

local table, peripheral = table, peripheral;

local classFactory = require('common.factory').factory;

local exports = {};

local activePeripherals = setmetatable({}, { __mode = 'k' });

---@class EventData
---@field [1] string The event that occured
---@field [number] any Other information associated with the event

---Processes events passed to it from os.pullEvent/os.pullEventRaw
---@param event EventData Event information
function exports.processEvent(event)
    if (event[1] == "peripheral_detach") then
        local name = event[2];
        for _,instance in activePeripherals do
            if (name == instance.peripheralName) then
                instance:clearCache();
            end
        end
    end
end


exports.class = classFactory({
    name = 'peripheral',

    constructor = function (super, self, name)
        if type(name) ~= "string" or name == "" then
            error('invalid peripheral name');
        end
        super(self);
        self.peripheralName = name;
        activePeripherals[self] = true;
    end,

    methods = {
        call = function (self, method, ...)
            return peripheral.call(self.peripheralName, method, table.unpack({...}));
        end,
        getMethods = { multi = true, cache = { name = "methods", copy = true }, info = "methods" },
        getTypes = { multi = true, cache = { name = "types", copy = true }, info = "types" },
        hasType = true,
        help = true,
        isValid = {
            handler = function (self)
                return peripheral.isPresent(self.peripheralName) or false;
            end,
            info = "valid",
            status = "valid"
        }
    },

    validate = function (self)
        return peripheral.isPresent(self.peripheralName) or false
    end
}) --[[@as LibmekPeripheral ]];

return exports;