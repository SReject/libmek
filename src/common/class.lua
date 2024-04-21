local class = {};

function class.create(constructor, BaseClass, ...)

    local mixins = {...};

    local Class = {};
    Class.__index = Class;

    if (BaseClass) then
        local baseMetatable = setmetatable({__index = BaseClass}, BaseClass);
        setmetatable(Class, baseMetatable);
    end

    function Class.__construct(self, ...)
        if (constructor) then
            if (BaseClass and BaseClass.__construct) then
                constructor(
                    function (...)
                        BaseClass.__construct(self, table.unpack(...));
                    end,
                    self,
                    table.unpack(...)
                );
            else
                constructor(
                    function () end,
                    self,
                    table.unpack(...)
                );
            end
        elseif (BaseClass and BaseClass.__construct) then
            BaseClass.__construct(self, table.unpack(...));
        end
    end

    local function new(...)
        local instance = setmetatable({}, BaseClass);
        if #mixins then
            for _,mixin in ipairs(mixins) do
                for key,property in pairs(mixins) do
                    instance[key] = property;
                end
            end
        end
        Class.__construct(instance, table.unpack(...));
        instance.__super = BaseClass;
        return instance;
    end

    return new,Class;
end

function class.extend(BaseClass, ...)
    local mixins = {...};
    for _,mixin in ipairs(mixins) do
        for key,value in pairs(mixin) do
            BaseClass[key] = value;
        end
    end
    return BaseClass;
end

return class;