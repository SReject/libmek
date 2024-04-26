---@module 'classes.peripheral'

return {

    ---Creates a new dedicated-tank mixin
    ---@param cacheNamespace string The key in the instance's cache object to store associated cached values
    ---@param tankName string The name used to reference the tank: `peripheral.call('get' .. tankName)`
    ---@param propName string The key to use to house the mixin and associated data
    ---@return LibmekDedicatedTankSlot
    factory = function (cacheNamespace, tankName, propName)

        ---@class LibmekDedicatedTankSlot
        local tank = {}

        ---Retrieves the capacity of the tank slot
        ---@param self LibmekPeripheral
        ---@return integer|nil
        function tank.capacity(self, force)
            local cache = self.__cache[cacheNamespace]
            local cacheName = propName .. 'Capacity';
            if (force or cache[cacheName] == nil) then
                cache[cacheName] = self:call('get' .. tankName .. 'Capacity');
            end
            return cache[cacheName];
        end

        ---Retrieves the current contents stored in the tank
        ---@param self LibmekPeripheral
        ---@return LibmekTankContents|nil TankContents
        function tank.contents(self)
            return self:call('get' .. tankName);
        end

        ---Retrieves the amount of the tank's contents required to finish filling the tank
        ---
        ---Units: millibuckets
        ---@param self LibmekPeripheral
        ---@return integer|nil
        function tank.needed(self)
            return self:call('get' .. tankName .. 'Needed');
        end

        ---Retrieves the current fill percentage of the tank represented as a decimal
        ---@param self LibmekPeripheral
        ---@return number|nil
        function tank.percentage(self)
            return self:call('get' .. tankName .. 'FilledPercentage');
        end

        ---Retrieves static information pertaining to the tank from the
        ---instance's cache
        ---
        ---If the cache does not contain a given value it is retrieved from the
        ---connecting peripheral.
        ---@param self LibmekPeripheral
        ---@param force boolean? When true the cache is forced to update
        ---@return LibmekTankInfo TankInfo
        function tank.info(self, force)
            return {
                capacity = tank.capacity(self, force)
            };
        end

        ---Retrieves dynamic informtion pertaining to the tank
        ---
        ---If the cache does not contain a given value it is retrieved from the
        ---connecting peripheral.
        ---@param self LibmekPeripheral
        ---@return LibmekTankStatus TankStatus
        function tank.status(self, force)
            local capacity = tank.capacity(self, force);
            local contents = tank.contents(self);
            if (capacity == nil or contents == nil) then
                return {
                    capacity = capacity,
                    contents = contents
                }
            end
            return {
                capacity = capacity,
                contents = contents,
                needed = capacity - contents['amount'],
                percentage = contents['amount'] / capacity
            }
        end

        return {
            [propName] = tank
        };
    end
};