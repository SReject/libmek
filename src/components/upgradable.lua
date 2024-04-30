---@class LibmekComponentNSUpgradeable
---@field supported fun(self: LibmekPeripheral): LibmekUpgrade[]
---@field installed fun(self: LibmekPeripheral): {[LibmekUpgrade]: number}

---@class LibmekComponentUpgradeable
---@field upgrades LibmekComponentNSUpgradeable

---@type LibmekClassFactoryComponent
return {
    ['@namespace'] = "upgrades",
    supported = {
        handler = 'getSupportedUpgrades',
        cache = { name = 'supported' },
        info = 'supported'
    },
    installed = {
        handler = 'getInstalledUpgrades',
        status = 'installed'
    }
}