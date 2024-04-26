---@module 'classes.peripheral'

---@class LibmekEnergyBufferInfo
---@field capacity integer? The maximum amount of energy that can be stored

---@class LibmekEnergyBufferStatus
---@field capacity integer? The maximum amount of energy that can be stored
---@field current integer? The current amount of energy stored
---@field needed integer? The amount of energy needed to finish filling the buffer
---@field percentage number? The percentage of the buffer that is filled (as a decimal)

return {
    factory = function (cacheNamespace)

        ---@class LibmekEnergyBuffer
        local energy = {}

        ---Retrieves the maximum amount of energy the energy buffer can store
        ---from the instance's cache
        ---
        ---Units: joules
        ---@param self LibmekPeripheral
        ---@param force boolean? When true the cached value is forced to update
        ---@return number|nil
        function energy.capacity(self, force)
            if (self.__cache[cacheNamespace].energy == nil) then
                self.__cache[cacheNamespace].energy = {};
            end
            local cache = self.__cache[cacheNamespace].energy;

            if (force == true or cache.max == nil) then
                cache.max = self:call('getMaxEnergy');
            end
            return cache.max;
        end

        ---Retrieves the current amount of energy stored in the buffer
        ---
        ---Units: joules
        ---@param self LibmekPeripheral
        ---@return number|nil
        function energy.stored(self)
            return self:call('getEnergy')
        end

        ---Retrieves the amount of energy required to finish filling the buffer
        ---
        ---Units: joules
        ---@param self LibmekPeripheral
        ---@return number|nil
        function energy.needed(self)
            return self:call('getEnergyNeeded');
        end

        ---Retrieves the percentage that the buffer is filled represented as a decimal
        ---
        ---Units: joules
        ---@param self LibmekPeripheral
        ---@return number|nil
        function energy.percentage(self)
            return self:call('getEnergyFilledPercentage');
        end

        ---Retrieves static information pertaining to the energy buffer from cache
        ---
        ---If the cache does not contain a given value it is retrieved from the
        ---connecting peripheral.
        ---@param self LibmekPeripheral
        ---@param force boolean? When true the cache is forced to update
        ---@return LibmekEnergyBufferInfo EnergyBufferInfo
        function energy.info(self, force)
            return {
                capacity = energy.capacity(self, force)
            }
        end

        ---Retrieves dynamic information pertaining to the energy buffer
        ---
        ---If the cache does not contain a given value it is retrieved from the
        ---connecting peripheral.
        ---@param self LibmekPeripheral
        ---@param force boolean? When true the cache is forced to update
        ---@return LibmekEnergyBufferStatus EnergyBufferStatus
        function energy.status(self, force)
            local maxEnergy = energy.capacity(self, force);
            local curEnergy = self:call('getEnergy');
            if (maxEnergy == nil or curEnergy == nil) then
                return {
                    capacity = maxEnergy,
                    current = curEnergy
                }
            end

            return {
                capacity = maxEnergy,
                current = curEnergy,
                needed = maxEnergy - curEnergy,
                percentage = curEnergy / maxEnergy
            }
        end

        return {
            energy = energy
        }
    end
}