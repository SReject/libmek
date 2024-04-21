return {
    factory = function (cacheNamespace)

        local capacity = function (self, force)
            if (self.__cache[cacheNamespace].energy == nil) then
                self.__cache[cacheNamespace].energy = {};
            end
            local cache = self.__cache[cacheNamespace].energy;

            if (force or cache.max == nil) then
                cache.max = self:call('getMaxEnergy');
            end
            return cache.max;
        end;

        return {
            energy = {
                capacity = capacity,

                stored = function (self)
                    return self:call('getEnergy')
                end,

                needed = function(self)
                    return self:call('getEnergyNeeded')
                end,

                percentage = function(self)
                    return self:call('getEnergyFilledPercentage')
                end,

                info = function(self, force)
                    return {
                        capacity = capacity(self, force == true)
                    }
                end,

                status = function(self, force)
                    local maxEnergy = capacity(self, force == true);
                    local curEnergy = self:call('getEnergy');
                    return {
                        capacity = maxEnergy,
                        current = curEnergy,
                        needed = maxEnergy - curEnergy,
                        percentage = curEnergy / maxEnergy
                    }
                end
            }
        }
    end
}