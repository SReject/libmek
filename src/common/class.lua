local class = {};

local classedIndicator = tostring({});
local function isClassed(subject)
    if (type(subject) ~= 'table') then
        return false;
    end

    local meta = getmetatable(subject);
    if (meta == nil) then
        return false;
    end

    local superTable = rawget(meta, '__index');
    if (
        superTable == nil or
        rawget(superTable, '__classed') ~= classedIndicator or
        type(rawget(superTable, '__construct')) ~= 'function'
    ) then
        return false
    end

    return true;
end

---Creates a classing instance
---@param constructor nil|fun(super: (fun(...: any):nil), self: any, ...: ...):nil The function to call to initialize new instances
---@param BaseClass nil|unknown The class the result will inherit from
---@param ... any The mixins to copy into the class
function class.create(constructor, BaseClass, ...)

    local mixins = {...};

    ---'meta' table for the class containing Classed specific properties
    ---@class Super
    ---@field protected __super any
    ---@field private __classed string
    local super = {
        __super = BaseClass,
        __classed = classedIndicator
    };
    if (#mixins) then
        for _,mixin in ipairs(mixins) do
            for name,value in pairs(mixin) do
                if (name ~= '__metatable' and name ~= '__super' and name ~= '__classed' and name ~= '__construct' and name ~= 'new') then
                    super[name] = value;
                end
            end
        end
    end
    setmetatable(super, { __index = BaseClass });

    ---Initializes a given instance against the class
    ---@protected
    ---@param self any The instance being initialized
    ---@param ... any Arguments to pass to the constructor function
    function super.__construct(self, ...)
        if (constructor) then
            if (BaseClass and BaseClass.__construct) then
                constructor(
                    function (...)
                        BaseClass.__construct(self, table.unpack({...}));
                    end,
                    self,
                    table.unpack({...})
                );
            else
                constructor(
                    function () end,
                    self,
                    table.unpack({...})
                );
            end
        elseif (BaseClass and BaseClass.__construct) then
            BaseClass.__construct(self, table.unpack({...}));
        end
    end

    ---Class definition
    ---@class Class: Super
    local Class = {};
    setmetatable(Class, { __index = super });


    ---Creates a new instance of the class
    ---@param ... any Arguments to be passed to the class' constructor
    function super.new(...)
        local instance = setmetatable({}, { __index = Class });
        super.__construct(instance, table.unpack({...}));
        return instance;
    end

    return Class;
end

---Adds mixins to the given class
---
---Quietly ignores mixin properties named `__metatable`, `__super`, `__classed`, `__construct` or `new`
---@param subject table<any,any> The subject to target. If the subject is a class properties are added to the class' super metatable otherwise properties are added directly to the subject
---@param ... table<string,any> Mixins to apply to to the targeted class.
function class.mixin(subject, ...)
    if (type(subject) ~= 'table') then
        error('subject must be a table', 2);
    end

    local mixinsList = {...};
    if (#mixinsList == 0) then
        return subject;
    end

    --If subject is a class, target the class' super table otherwise target the subject
    local target;
    if (isClassed(subject)) then
        target = getmetatable(subject).__index;
    else
        target = subject;
    end

    --Apply mixins to target
    for _,mixins in ipairs(mixinsList) do
        for name,value in pairs(mixins) do
            if (
                name ~= '__metatable' and
                name ~= '__super' and
                name ~= '__classed' and
                name ~= '__construct' and
                name ~= 'new'
            ) then
                target[name] = value;
            end
        end
    end

    return subject;
end

return class;