---@alias libmek.internal.FactoryCacheFields {[number]: string, [string]: libmek.internal.FactoryCacheFields}

---@class (exact) libmek.internal.FactoryMethodCache
---@field name   nil|string
---@field copy   nil|boolean
---@field fields nil|libmek.internal.FactoryCacheFields

---@class (exact) libmek.internal.FactoryMethodDefinition
---@field returns boolean|nil
---@field multi   boolean|nil
---@field handler nil|string|fun(self: any, ...):any
---@field cache   nil|false|libmek.internal.FactoryMethodCache
---@field info    boolean|string|nil
---@field status  boolean|string|nil

---@alias libmek.internal.FactoryMethod boolean|string|libmek.internal.FactoryMethodDefinition|fun(self, ...):any

---@alias libmek.internal.FactoryMethodList {[string]: libmek.internal.FactoryMethod}

---@class (exact) libmek.internal.FactoryComponent: {[string]: libmek.internal.FactoryMethod}
---@field ["@namespace"] nil|false|string

---@alias libmek.internal.FactoryComponentList libmek.internal.FactoryComponent[]

---@class (exact) libmek.internal.FactoryOptions
---@field name string
---@field baseClass nil|table
---@field constructor nil|fun(super: (fun(...):nil), self, ...):nil
---@field components nil|libmek.internal.FactoryComponentList
---@field methods nil|libmek.internal.FactoryMethodList
---@field validate nil|fun(self: any,info: table):boolean

---@class libmek.internal.FactoryClass : libmek.internal.ClassifyClass
---@field info fun(self: libmek.internal.FactoryClass, force: boolean):table
---@field status fun(self: libmek.internal.FactoryClass, force: boolean):table

local next,type,error = next,type,error;

--#region Imports
local classify = require('common.classify');
local create = classify.create;
local extractProto = classify.extract;
local isClassed = classify.isClassed;

local helpers = require('common.helpers');
local copyTable = helpers.copyTable;
local sweepTable = helpers.sweepTable;
--#endregion

--#region Helper functions

---Ensures that the instance has a cache state store
---@param self unknown
---@param name string
---@param space string|nil
---@return table<string, any> Cache
local function ensureCache(self, name, space)
    local cache = self.__cache;
    if (self.__cache == nil) then
        self.__cache = {};
        cache = self.__cache;
    end
    if (cache[name] == nil) then
        cache[name] = {};
        cache = cache[name];
    end
    if (space) then
        if (cache[space] == nil) then
            cache[space] = {};
        end
        return cache[space];
    end
    return cache[name];
end

---Verify's a cache entry's fields
---@param cache table<any,any>
---@param fields libmek.internal.FactoryCacheFields
---@return boolean # true if all fields are present in the cache
local function verifyFields(cache, fields)
    if (cache == nil) then
        return false;
    end
    if (type(fields) == 'table') then
        for index, value in pairs(fields) do
            if (type(value) == 'string') then
                if (cache[value] == nil) then
                    return false;
                end
            elseif (verifyFields(cache[index], value) == false) then
                return false;
            end
        end
    end
    return true;
end

---Deduces functionality of the given method definition and returns the handling function
---@param class table
---@param namespace string|nil
---@param methodName string
---@param options libmek.internal.FactoryMethod
---@return fun(self: any, ...):any
local function deduceMethod(class, namespace, methodName, options)

    --Deduce handling function
    local method;
    local callMethod = methodName;
    local handler = options.handler;
    if (type(handler) == 'string') then
        callMethod = handler;
        handler = nil;
    end

    if (handler == nil) then
        if (options.multi == true) then
            method = function (self, ...)
                return { self:call(callMethod, table.unpack({...})) }
            end
        elseif (options.returns or options.cache or options.info or options.status) then
            method = function(self, ...)
                return self:call(callMethod, table.unpack({...}));
            end
        else
            method = function(self, ...)
                self:call(callMethod, table.unpack({...}));
            end
        end
    elseif (type(handler) ~= 'function') then
        error('invalid `handler` value');
    elseif (options.multi == true) then
        method = function (self, ...)
            return { handler(self, table.unpack({...})) };
        end
    else
        method = handler;
    end

    -- Handler's return value should not be cached
    if (options.cache == nil or options.cache == false) then
        return method;
    end

    local className = class.super.name;

    local cacheOptions = options.cache;
    local cacheName = className;
    local cacheFields;
    local cacheCopy = false;

    if (type(cacheOptions) == 'table') then
        cacheFields = cacheOptions.fields;
        if (cacheOptions.name) then
            cacheName = cacheOptions.name;
        end
        cacheCopy = cacheOptions.copy;
    end

    ---@cast cacheName string

    -- Fields verifier; copying output is inferred
    if (type(cacheFields) == 'table') then
        return function (self, force)
            local cache = ensureCache(self, className, namespace);
            if (force == true or cache[cacheName] == nil or verifyFields(cache[cacheName], cacheFields) ~= true) then
                cache[cacheName] = method(self);
            end
            return copyTable(cache[cacheName]);
        end
    end

    -- Output should be copied
    if (cacheCopy == true) then
        return function (self, force)
            local cache = ensureCache(self, className, namespace);
            if (force == true or cache[cacheName] == nil) then
                cache[cacheName] = method(self);
            end
            return copyTable(cache[cacheName]);
        end
    end

    -- No verifing or copying needed
    return function (self, force, ...)
        local cache = ensureCache(self, className, namespace);
        if (force == true or cache[cacheName] == nil) then
            cache[cacheName] = method(self);
        end
        return cache[cacheName];
    end
end

---Deduces the functionality of a given method definition and appends the resulting function to applicable tables
---@param class table
---@param target table|nil
---@param namespace string|nil
---@param options libmek.internal.FactoryMethod
---@param infoTracker table<string, any>
---@param statusTracker table<string, any>
local function applyMethod(class, target, namespace, name, options, infoTracker, statusTracker)
    if (options == nil) then
        return;
    end

    if (target == nil) then
        target = class;
    end

    -- The peripheral method returns no value
    if (options == false) then
        target[name] = function(self, ...)
            self:call(self, name, table.unpack({...}));
        end;

    --- The peripheral method returns a singular non-cachable value
    elseif (options == true) then
        target[name] = function(self, ...)
            return self:call(self, name, table.unpack({...}));
        end;

    -- A peripheral method name is specified; the call does not return a value
    elseif (type(options) == "string") then
        target[name] = function(self, ...)
            self:call(self, options, table({...}));
        end;

    -- A handling function is specified
    elseif (type(options) == "function") then
        target[name] = options;

    -- Invalid definition
    elseif (type(options) ~= "table") then
        error("invalid definition", 2);

    else

        local handler = deduceMethod(class, namespace, name, options);

        -- When applicable add handler to info tracker
        if (options.info == true) then
            infoTracker[name] = handler;
        elseif (type(options.info) == 'string') then
            infoTracker[options.info] = handler;
        elseif (options.info ~= nil) then
            error('invalid `info` property');
        end

        -- When applicable add handler to status tracker
        if (options.status == true) then
            statusTracker[name] = handler;
        elseif (type(options.status) == 'string') then
            statusTracker[options.status] = handler;
        elseif (options.info ~= nil) then
            error('invalid `status` property');
        end

        target[name] = handler;
    end
end

---@param self any
---@param name string
---@param details table
---@param validator nil|fun(self, ...):boolean
---@param tracker table
---@param force boolean
local function buildDetails(self, name, details, validator, tracker, force)
    if (validator == nil or validator(self, details)) then
        if (details[name] == nil) then
            details[name] = {};
        end
        local bloc = details[name];
        for key,handler in pairs(tracker) do
            if (type(handler) == 'function') then
                bloc[key] = handler(self, force);
            else
                bloc[key] = {};
                local nsBloc = bloc[key];
                for nsKey, nsHandler in pairs(handler) do
                    nsBloc[nsKey] = nsHandler(self, force);
                end
            end
        end
        bloc.valid = true;
    else
        details[name] = { valid = false };
    end
    return details;
end
--#endregion

local exports = {};

---@param options libmek.internal.FactoryOptions
---@return libmek.internal.FactoryClass
function exports.factory(options)

    local baseIsClass,base,baseProto = extractProto(options.baseClass);
    ---@cast baseProto libmek.internal.ClassifyProtoTable

    local _,class,proto = extractProto(create(options.baseClass));
    ---@cast proto libmek.internal.ClassifyProtoTable

    rawset(proto, 'classname', options.name);

    local infoEntriesTracker = {};
    local statusEntriesTracker = {};

    -- Add components to `proto` table
    if (options.components) then
        local components = options.components --[[@as libmek.internal.FactoryComponentList ]];
        for _,component in ipairs(components) do

            ---@type table
            local target = class;
            local nsInfoTracker = infoEntriesTracker;
            local nsStatusTracker = statusEntriesTracker;
            local namespace = component["@namespace"];
            if (namespace) then
                if (type(namespace) ~= 'string' or namespace == '') then
                    error('invalid component namespace; when specified it must be a non-empty string', 1)
                end
                target = class[namespace] or {};
                nsInfoTracker = {};
                nsStatusTracker = {};
            else
                namespace = nil;
            end

            for compMethodName, compMethodOptions in pairs(component) do
                if (compMethodName ~= '@namespace') then
                    applyMethod(class, target, namespace, compMethodName, compMethodOptions, nsInfoTracker, nsStatusTracker);
                end
            end

            if (namespace) then
                class[namespace] = target;
                infoEntriesTracker[namespace] = nsInfoTracker;
                statusEntriesTracker[namespace] = nsStatusTracker;
            end
        end
    end

    -- Add methods to `class` table
    if (options.methods) then
        local methods = options.methods --[[@as {[string]: libmek.internal.FactoryMethod} ]]
        for methodName, methodOptions in pairs(methods) do
            applyMethod(class, class, nil, methodName, methodOptions, infoEntriesTracker, statusEntriesTracker)
        end
    end

    local optsValidate = options.validate;

    -- Deduce :info() handler
    infoEntriesTracker = sweepTable(infoEntriesTracker);
    if (infoEntriesTracker == nil or next(infoEntriesTracker) == nil) then
        if (baseIsClass) then
            class.info = function(self, force)
                return baseProto.super.info(self, force);
            end
        else
            class.info = function(self, force)
                return {};
            end
        end
    elseif (baseIsClass) then
        class.info = function(self, force)
            return buildDetails(self, options.name, baseProto.super.info(self, force), optsValidate, infoEntriesTracker, force);
        end
    else
        class.info = function(self, force)
            return buildDetails(self, options.name, {}, optsValidate, infoEntriesTracker, force);
        end
    end

    -- Deduce :status() handler
    statusEntriesTracker = sweepTable(statusEntriesTracker);
    if (statusEntriesTracker == nil or next(statusEntriesTracker) == nil) then
        if (baseIsClass) then
            class.status = function(self, force)
                return baseProto.super.status(self, force);
            end
        else
            class.status = function(self, force)
                return {};
            end
        end
    elseif (baseIsClass) then
        class.status = function(self, force)
            return buildDetails(self, options.name, baseProto.super.status(self, force), optsValidate, statusEntriesTracker, force);
        end
    else
        class.status = function(self, force)
            return buildDetails(self, options.name, {}, optsValidate, statusEntriesTracker, force);
        end
    end

    return class;
end;

return exports;