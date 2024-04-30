---@class LibmekClassifyProtoTable
---@field package __isClassifyClass boolean
---@field package constructor fun(self, ...):nil
---@field super any
---@field new fun(...):nil

---@class LibmekClassifyClass : LibmekClassifyProtoTable

local type,getmetatable,rawget,setmetatable = type,getmetatable,rawget,setmetatable;

local IS_CLASSIFY_KEY = "__isClassifyClass"

---Returns true if if the subject is a Classify class or Classify class instance
---@param subject any
---@return boolean
local function isClassed(subject)
    if (type(subject) ~= 'table') then
        return false;
    end

    local meta = getmetatable(subject);
    if (meta == nil) then
        return false
    end

    local proto = rawget(meta, '__index');
    if (type(proto) ~= 'table') then
        return false;
    end

    return (
        rawget(proto, IS_CLASSIFY_KEY) == true and
        type(rawget(proto, 'constructor')) == 'function' and
        type(rawget(proto, 'new')) == 'function'
    );
end

---Exacts a Classify class or Classify class instance's intermediate `__index` metatable value
---@generic T
---@param subject `T`,
---@return boolean,T,(nil|LibmekClassifyProtoTable) # isClassed, class, proto
local function extract(subject)
    if (isClassed(subject)) then
        return true, subject, getmetatable(subject).__index;
    end
    return false, subject
end

---Creates an instancable class
---@param superclass any
---@param constructor nil|fun(super, self, ...):nil
---@return LibmekClassifyClass
local function create(superclass, constructor)
    local superIsClass, _, superProto = isClassed(superclass);

    ---@cast superProto LibmekClassifyProtoTable

    local __constructor;
    if (constructor == nil) then
        if (superIsClass) then
            __constructor = function (self, ...)
                superProto.constructor(self, table.unpack({...}));
            end
        else
            __constructor = function (self, ...) end;
        end

    elseif (superIsClass) then
        __constructor = function (self, ...)
            constructor(
                function (...)
                    superProto.constructor(self, table.unpack({...}));
                end,
                self,
                table.unpack({...})
            );
        end

    else
        __constructor = function (self, ...)
            constructor(
                function () end,
                self,
                table.unpack({...})
            );
        end
    end

    local class = {};
    local proto = setmetatable(
        {
            [IS_CLASSIFY_KEY] = true,
            constructor = __constructor,
            super = superclass,
            new = function(...)
                local instance = setmetatable({}, { __index = class });
                __constructor(instance, table.unpack({...}));
                return instance;
            end
        }, {
            __index = superclass,
            __newindex = function()
                error('attempted update of a read-only metatable', 2);
            end,
            __metatable = { __index = superclass }
        }
    );
    setmetatable(class, { __index = proto });
    return class;
end

return {
    create = create,
    extract = extract,
    isClassed = isClassed
};