---@module 'classes.peripheral'

---@class TankContents
---@field name string The identifying name for the substance in the tank
---@field amount integer the amount of the substance stored in the tank represented in millibuckets

---@class TankInfo
---@field capacity integer|nil The maximum capacity of the tank

---@class TankStatus
---@field capacity integer|nil The maximum capacity of the tanke
---@field current TankContents|nil The currently stored substance in the anke
---@field needed integer|nil The amount of substance required to finish filling the tank represented in millibuckets
---@field percentage number|nil Ther percentage of the tank's capacity that is filled represented as decimal

return {
    factory = function (cacheNamespace, realName, propName)

        ---@class Tank
        local tank = {}

        ---@param self Peripheral
        ---@return integer|nil
        function tank.capacity(self, force)
            local cache = self.__cache[cacheNamespace]
            local cacheName = propName .. 'Capacity';
            if (force or cache[cacheName] == nil) then
                cache[cacheName] = self:call('get' .. realName .. 'Capacity');
            end
            return cache[cacheName];
        end

        ---Returns the current contents stored in the tank
        ---@param self Peripheral
        ---@return TankContents|nil
        function tank.contents(self)
            return self:call('get' .. realName);
        end

        ---Retrieves the amount of the tank's contents required to finish filling the tank
        ---
        ---Units: millibuckets
        ---@param self Peripheral
        ---@return integer|nil
        function tank.needed(self)
            return self:call('get' .. realName .. 'Needed');
        end

        ---Retrieves the current fill percentage of the tank represented as a decimal
        ---@param self Peripheral
        ---@return number|nil
        function tank.percentage(self)
            return self:call('get' .. realName .. 'FilledPercentage');
        end

        ---Retrieves static information pertaining to the tank from the
        ---instance's cache
        ---
        ---If the cache does not contain a given value it is retrieved from the
        ---connecting peripheral.
        ---@param self Peripheral
        ---@param force boolean? When true the cache is forced to update
        ---@return TankInfo
        function tank.info(self, force)
            return {
                capacity = tank.capacity(self, force)
            };
        end

        ---Retrieves dynamic informtion pertaining to the tank
        ---
        ---If the cache does not contain a given value it is retrieved from the
        ---connecting peripheral.
        ---@param self Peripheral
        ---@return TankStatus
        function tank.status(self, force)
            local capacity = tank.capacity(self, force);
            local contents = self:call('get' .. realName);
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
            [propName .. 'Tank'] = tank
        };
    end
};