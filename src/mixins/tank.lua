return {
    factory = function (cacheNamespace, realName, propName)
        local capacityFnc = function (self, force)
            local cacheName = propName .. 'Capacity';
            if (force or self.__cache[cacheNamespace][cacheName] == nil) then
                self.__cache[cacheNamespace][cacheName] = self:call('get' .. realName .. 'Capacity');
            end
            return self.__cache[cacheNamespace][cacheName];
        end;

        local contentsFnc = function (self)
            return self:call('get' .. realName);
        end;

        return {
            [propName .. 'Tank'] = {
                capacity = capacityFnc,

                contents = contentsFnc,

                needed = function (self)
                    return self:call('get' .. realName .. 'Needed');
                end,

                percentage = function(self)
                    return self:call('get' .. realName .. 'FilledPercentage');
                end,

                info = function(self)
                    return {
                        capacity = capacityFnc(self)
                    };
                end,

                status = function(self)
                    local capacity = capacityFnc(self);
                    local contents = contentsFnc(self);
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