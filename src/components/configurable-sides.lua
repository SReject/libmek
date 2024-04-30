---@class libmek.component.ConfigurableSidesNS
---@field canEject fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType): boolean
---@field isEjecting fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType): boolean
---@field setEjecting fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType, eject): boolean
---@field mode fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType, side: libmek.mek.RelativeSide): libmek.mek.DataType
---@field setMode fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType, side: libmek.mek.RelativeSide, mode: libmek.mek.DataType): nil
---@field incrementMode fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType, side: libmek.mek.RelativeSide): nil
---@field decrementMode fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType, side: libmek.mek.RelativeSide): nil
---@field configurableTypes fun(self: libmek.class.Peripheral): libmek.mek.TransmissionType[]
---@field supportedModes fun(self: libmek.class.Peripheral, transmissionType: libmek.mek.TransmissionType): libmek.mek.DataType[]

---@class libmek.component.ConfigurableSides
---@field sides libmek.component.ConfigurableSidesNS

---@type libmek.internal.FactoryComponent
return {
    ["@namespace"] = 'sides',
    canEject = true,
    isEjecting = true,
    setEjecting = true,
    mode = { handler = 'getMode', returns = true },
    setMode = false,
    decrementMode = false,
    incrementMode = false,
    configurableTypes = {
        handler = 'getConfigurableTypes'
    },
    supportedModes = {
        handler = 'getSupportedModes'
    }
}