---@class LibmekComponentNSEjector
---@field inputColor fun(self: LibmekPeripheral, side: LibmekRelativeSide): LibmekEnumColor
---@field setInputColor fun(self: LibmekPeripheral, side: LibmekRelativeSide, color: LibmekEnumColor): nil
---@field incrementInputColor fun(self: LibmekPeripheral, side: LibmekRelativeSide): nil
---@field decrementInputColor fun(self: LibmekPeripheral, side: LibmekRelativeSide): nil
---@field clearInputColor fun(self: LibmekPeripheral, side: LibmekRelativeSide): nil
---@field outputColor fun(self: LibmekPeripheral): LibmekEnumColor
---@field setOutputColor fun(self: LibmekPeripheral, color: LibmekEnumColor): nil
---@field incrementOutputColor fun(self: LibmekPeripheral): nil
---@field decrementOutputColor fun(self: LibmekPeripheral): nil
---@field clearOutputColor fun(self: LibmekPeripheral): nil
---@field strictInput fun(self: LibmekPeripheral): boolean
---@field setStrictInput fun(self: LibmekPeripheral, mode: boolean): nil

---@class LibmekComponentEjector
---@field ejector LibmekComponentNSEjector

---@type LibmekClassFactoryComponent
return {
    ["@namespace"] = 'ejector',
    inputColor = { handler = 'getInputColor', returns = true},
    setInputColor = false,
    decrementInputColor = false,
    incrementInputColor = false,
    clearInputColor = false,
    outputColor = { handler = 'getOutputColor', returns = true },
    setOutputColor = false,
    decrementOutputColor = false,
    incrementOutputColor = false,
    clearOutputColor = false,
    strictInput = { handler = 'hasStrictInput', returns = true },
    setStrictInput = false
}