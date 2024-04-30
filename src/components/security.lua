---@class LibmekComponentNSSecurity
---@field name fun(self: LibmekPeripheral): string
---@field uuid fun(self: LibmekPeripheral): string
---@field mode fun(self: LibmekPeripheral): LibmekSecurityMode

---@class LibmekComponentSecurity
---@field security LibmekComponentNSSecurity

---@type LibmekClassFactoryComponent
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