---@class LibmekComponentNSRecipeProgress
---@field progress fun(self: LibmekPeripheral, process: number):number
---@field ticksLeft fun(self: LibmekPeripheral, process: number):number

---@class LibmekComponentRecipeProgress
---@field recipe LibmekComponentNSRecipeProgress

---@type LibmekClassFactoryComponent
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