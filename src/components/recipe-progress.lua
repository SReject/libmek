---@class libmek.component.RecipeProgressNS
---@field progress fun(self: libmek.class.Peripheral, process: number):number
---@field ticksLeft fun(self: libmek.class.Peripheral, process: number):number

---@class libmek.component.RecipeProgress
---@field recipe libmek.component.RecipeProgressNS

---@type libmek.internal.FactoryComponent
return {
    ["@namespace"] = "recipe",
    progress = {
        handler = "getRecipeProgress",
        status = "progress"
    },
    ticksLeft = {
        handler = "getTicksRequired",
        status = "ticksLeft"
    }
}