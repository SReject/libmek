local exports = {};

---Deep copies a table's content
---
---Does not copy metatable related information
---@generic T
---@param subject `T`
---@return T
local function copyTable(subject)
    if (type(subject) ~= 'table') then
        return subject;
    end
    local result = {};
    for index,value in pairs(subject) do
        if (type(value) == 'table') then
            result[index] = copyTable(value);
        else
            result[index] = value;
        end
    end
    return result;
end
exports.copyTable = copyTable;

---Deep copies a table, removing fields that are nil or are empty tables
---
---If the resulting table is empty then nil is returned instead of the table
---@generic T
---@param subject `T`
---@return T|nil
local function sweepTable(subject)
    if (type(subject) ~= 'table') then
        return subject;
    end
    local result = {};
    local hasValue = false;
    for name,value in pairs(subject) do
        value = sweepTable(value);
        if (value ~= nil) then
            result[name] = value;
            hasValue = true;
        end
    end
    if (hasValue) then
        return result;
    end
end
exports.sweepTable = sweepTable;

return exports;