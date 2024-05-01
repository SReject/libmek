---@class libmek.component.RedstoneControl
---@field getRedstoneMode fun(self: libmek.class.Peripheral): libmek.mek.RedstoneControl
---@field setRedstoneMode fun(self: libmek.class.Peripheral, mode: libmek.mek.RedstoneControl): nil

---@type libmek.internal.FactoryComponent
return {
    getRedstoneMode = {
        info = 'redstoneControlMode'
    },
    setRedstoneMode = false
}