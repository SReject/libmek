---@class libmek.component.QIOFilter
---@field filters fun(self: libmek.class.Peripheral): libmek.mek.QIOFilter[]
---@field addFilter fun(self: libmek.class.Peripheral, filter: libmek.mek.QIOFilter): boolean
---@field removeFilter fun(self: libmek.class.Peripheral, filter: libmek.mek.QIOFilter): boolean

---@type libmek.internal.FactoryComponent
return {
    {
        filters = { returns = true, handler = "getFilters"},
        addFilter = false,
        removeFilter = true
    }
}