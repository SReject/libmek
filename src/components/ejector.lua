---@class libmek.component.EjectorNS
---@field inputColor fun(self: libmek.class.Peripheral, side: libmek.mek.RelativeSide): libmek.mek.EnumColor
---@field setInputColor fun(self: libmek.class.Peripheral, side: libmek.mek.RelativeSide, color: libmek.mek.EnumColor): nil
---@field incrementInputColor fun(self: libmek.class.Peripheral, side: libmek.mek.RelativeSide): nil
---@field decrementInputColor fun(self: libmek.class.Peripheral, side: libmek.mek.RelativeSide): nil
---@field clearInputColor fun(self: libmek.class.Peripheral, side: libmek.mek.RelativeSide): nil
---@field outputColor fun(self: libmek.class.Peripheral): libmek.mek.EnumColor
---@field setOutputColor fun(self: libmek.class.Peripheral, color: libmek.mek.EnumColor): nil
---@field incrementOutputColor fun(self: libmek.class.Peripheral): nil
---@field decrementOutputColor fun(self: libmek.class.Peripheral): nil
---@field clearOutputColor fun(self: libmek.class.Peripheral): nil
---@field strictInput fun(self: libmek.class.Peripheral): boolean
---@field setStrictInput fun(self: libmek.class.Peripheral, mode: boolean): nil

---@class libmek.component.Ejector
---@field ejector libmek.component.EjectorNS

---@type libmek.internal.FactoryComponent
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