---@class LibmekComponentNSConfigurableSides
---@field canEject fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType): boolean
---@field isEjecting fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType): boolean
---@field setEjecting fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType, eject): boolean
---@field mode fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType, side: LibmekRelativeSide): LibmekDataType
---@field setMode fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType, side: LibmekRelativeSide, mode: LibmekDataType): nil
---@field incrementMode fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType, side: LibmekRelativeSide): nil
---@field decrementMode fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType, side: LibmekRelativeSide): nil
---@field configurableTypes fun(self: LibmekPeripheral): LibmekTransmissionType[]
---@field supportedModes fun(self: LibmekPeripheral, transmissionType: LibmekTransmissionType): LibmekDataType[]

---@class LibmekComponentConfigurableSides
---@field sides LibmekComponentNSConfigurableSides

---@type LibmekClassFactoryComponent
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