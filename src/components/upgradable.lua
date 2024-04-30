---@class libmek.component.UpgradeableNS
---@field supported fun(self: libmek.class.Peripheral): libmek.mek.Upgrade[]
---@field installed fun(self: libmek.class.Peripheral): {[libmek.mek.Upgrade]: number}

---@class libmek.component.Upgradeable
---@field upgrades libmek.component.UpgradeableNS

---@type libmek.internal.FactoryComponent
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