Config = {}

-- items must exist in rsg-core shared items
Config.CommonItems = { 'bread', 'water' }
Config.RareItems   = { 'bread', 'water' }

Config.RareChance  = 5            -- % chance of rare loot
Config.CommonCash  = { 1, 5 }     -- min / max cash with common loot
Config.RareCash    = { 5, 10 }    -- min / max cash with rare loot

Config.LootKey      = 0x41AC83D1  -- INPUT_LOOT (1101824977)
Config.LootHoldTime = 250         -- ms the loot key must be held
Config.LootDistance = 3.0         -- max distance to the body (server checked)
Config.LootCooldown = 3           -- seconds between loot rewards per player
Config.LawAlert     = true        -- alert lawmen when a body is looted

-- robbing players
Config.RobDistance  = 2.5
Config.RobCooldown  = 60          -- seconds before the same victim can be robbed again
Config.TakeCash       = true
Config.TakeBloodMoney = true

-- outlaw status added on success (0 = disabled)
Config.OutlawLoot = 10
Config.OutlawRob  = 50
