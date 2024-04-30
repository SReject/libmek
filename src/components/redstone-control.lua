---@class LibmekComponentRedstoneControl
---@field getRedstoneMode fun(self: LibmekPeripheral): LibmekRedstoneControl
---@field setRedstoneMode fun(self: LibmekPeripheral, mode: LibmekRedstoneControl): nil

---@type LibmekClassFactoryComponent
return {
    getRedstoneMode = {
        info = 'redstoneControlMode'
    },
    setRedstoneMode = false
}