local class = {};

---Creates a classing instance
---@param constructor nil|fun(super: (fun(...: any):nil), self: any, ...: ...):nil The function to call to initialize new instances
---@param BaseClass nil|unknown The class the result will inherit from
---@param ... any The mixins to copy into the class
function class.create(constructor, BaseClass, ...)

    local mixins = {...};

    ---Class definition
    ---@class Class
    ---@field private __index Class
    local Class = {};
    Class.__index = Class;

    if (BaseClass) then
        local baseMetatable = setmetatable({__index = BaseClass}, BaseClass);
        setmetatable(Class, baseMetatable);
    end

    ---Initializes a given instance against the class
    ---@protected
    ---@param self any The instance being initialized
    ---@param ... any Arguments to pass to the constructor function
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

    ---Creates a new instance of the class
    ---@param ... any Arguments to be passed to the class' constructor
    local function new(...)
        local instance = setmetatable({}, BaseClass);
        if #mixins then
            for _,mixin in ipairs(mixins) do
                for key,property in pairs(mixin) do
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

---Adds mixins to the given class
---@param BaseClass any The targeted class
---@param ... table<string,any> Mixins to apply to to the targeted class
function class.mixin(BaseClass, ...)
    local mixins = {...};
    for _,mixin in ipairs(mixins) do
        for key,value in pairs(mixin) do
            BaseClass[key] = value;
        end
    end
    return BaseClass;
end

return class;