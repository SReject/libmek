---@alias LibmekGasDumpingMode
---| "IDLE"
---| "DUMPING_EXCESS"
---| "DUMPING"

---@class LibmekTankContents
---@field name string The identifying name for the substance in the tank
---@field amount integer the amount of the substance stored in the tank represented in millibuckets

---@class LibmekTankInfo
---@field capacity integer|nil The maximum capacity of the tank

---@class LibmekTankStatus
---@field capacity integer|nil The maximum capacity of the tanke
---@field contents LibmekTankContents|nil The currently stored substance in the anke
---@field needed integer|nil The amount of substance required to finish filling the tank represented in millibuckets
---@field percentage number|nil Ther percentage of the tank's capacity that is filled represented as decimal
