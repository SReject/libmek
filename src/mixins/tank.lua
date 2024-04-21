return {
    factory = function (cacheNamespace, realName, propName)

        local capacityFnc = function (self, force)
            local cacheName = propName .. 'Capacity';
            if (force or self.__cache[cacheNamespace][cacheName] == nil) then
                self.__cache[cacheNamespace][cacheName] = self:call('get' .. realName .. 'Capacity');
            end
            return self.__cache[cacheNamespace][cacheName];
        end;

        return {
            [propName .. 'Tank'] = {
                capacity = capacityFnc,

                contents = function (self)
                    return self:call('get' .. realName);
                end,

                needed = function (self)
                    return self:call('get' .. realName .. 'Needed');
                end,

                percentage = function(self)
                    return self:call('get' .. realName .. 'FilledPercentage');
                end,

                info = function(self, force)
                    return {
                        capacity = capacityFnc(self, force == true)
                    };
                end,

                status = function(self, force)
                    local capacity = capacityFnc(self, force == true);
                    local contents = self:call('get' .. realName);
                    return {
                        capacity = capacity,
                        contents = contents,
                        needed = capacity - contents['amount'],
                        percentage = contents['amount'] / capacity
                    }
                end
            }
        };
    end
};