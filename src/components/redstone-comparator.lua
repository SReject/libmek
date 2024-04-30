---@class libmek.component.RedstoneComparator
---@field getComparatorLevel fun(self: libmek.class.Peripheral): number

---@type libmek.internal.FactoryComponent
return {
    getComparatorLevel = {
        status = 'comparatorLevel'
    }
}