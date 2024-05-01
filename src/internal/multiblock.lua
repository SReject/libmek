---@class libmek.class.Multiblock: libmek.class.Peripheral
---@field getPosition fun(self: libmek.class.Multiblock, force: boolean?): {min: libmek.mek.BlockPosition, max: libmek.mek.BlockPosition} Retrieves the block positions of opposing corners forming the multiblock
---@field getSize fun(self: libmek.class.Multiblock, force: boolean?): {length: number, width: number, height: number} Retrieves the size of the multiblock
---@field isValid fun(self: libmek.class.Multiblock):boolean Returns true if the multiblock is formed

local classFactory = require('common.factory').factory;
local Peripheral = require('internal.peripheral').class;

local exports = {};
exports.class = classFactory({
    super = Peripheral,

    name = 'multiblock',

    methods = {
        isValid = {
            ---@param self libmek.class.Multiblock
            handler = function(self)
                return self.super.isValid() and self:call('isFormed') == true;
            end,
            info = "valid",
            status = "valid"
        },
        getPosition = {
            cache = {
                name = "position",
                fields = { "min", "max" },
                copy = true
            },
            ---@param self libmek.class.Multiblock
            handler = function (self)
                return {
                    min = self:call('getMinPos'),
                    max = self:call('getMaxPos')
                }
            end,
            info = "position"
        },
        getSize = {
            cache = {
                name = "size",
                fields = {"length", "width", "height"},
                copy = true
            },
            ---@param self libmek.class.Multiblock
            handler = function (self)
                return {
                    length = self:call('getLength'),
                    width = self:call('getWidth'),
                    height = self:call('getHeight')
                }
            end,
            info = "position"
        }
    },

    ---@param self libmek.class.Multiblock
    validate = function (self, info)
        if (info == nil and peripheral.isPresent(self.peripheralName) ~= true) then
            return false;
        elseif (info.peripheral.valid == false) then
            return false;
        end
        return self:call('isFormed') == true;
    end
}) --[[@as libmek.class.Multiblock ]];

return exports;