---@class libmek.component.QIOFrequencyNS
---@field create fun(self: libmek.class.Peripheral, name: string): nil
---@field isSet fun(self: libmek.class.Peripheral): boolean
---@field frequency fun(self: libmek.class.Peripheral): libmek.mek.QIOFrequency
---@field setFrequency fun(self: libmek.class.Peripheral, frequency: string): nil
---@field color fun(self: libmek.class.Peripheral): libmek.mek.Color
---@field setColor fun(self: libmek.class.Peripheral, color: libmek.mek.Color): nil
---@field decrementColor fun(self: libmek.class.Peripheral): nil
---@field incrementColor fun(self: libmek.class.Peripheral): nil
---@field getFrequencies fun(self: libmek.class.Peripheral): libmek.mek.QIOFrequency[]

---@class libmek.component.QIOFrequency
---@field frequency libmek.component.QIOFrequencyNS

---@type libmek.internal.FactoryComponent
return {
    ["@namespace"] = "frequency",
    create = { handler = "createFrequency" },
    isSet = { handler = 'hasFrequency'},
    frequency = { handler = "getFrequency" },
    setFrequency = false,
    color = { returns = true, handler = "getFrequencyColor" },
    setColor = { handler = "setFrequencyColor" },
    decrementColor = { handler = "decrementFrequencyColor" },
    incrementColor = { handler = "incremenetFrequencyColor" },
    frequencies = { handler = "getFrequencies" }
};