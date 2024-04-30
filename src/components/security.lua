---@class libmek.component.SecurityNS
---@field name fun(self: libmek.class.Peripheral): string
---@field uuid fun(self: libmek.class.Peripheral): string
---@field mode fun(self: libmek.class.Peripheral): libmek.mek.SecurityMode

---@class libmek.component.Security
---@field security libmek.component.SecurityNS

---@type libmek.internal.FactoryComponent
return {
    ["@namespace"] = 'security',
    name = {
        handler = 'getOwnerName',
        cache = { name = 'owner' },
        info = 'name'
    },
    uuid = {
        handler = 'getOwnerUUID',
        cache = { name = 'ownerUUID'},
        info = 'uuid'
    },
    mode = {
        handler = 'getMode',
        info = 'mode'
    }
}