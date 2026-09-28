lib.locale()

local ROB_DICT = 'script_rc@cldn@ig@rsc2_ig1_questionshopkeeper'
local ROB_ANIM = 'inspectfloor_player'
local HANDSUP_DICT = 'script_proc@robberies@homestead@lonnies_shack@deception'
local HANDSUP_ANIM = 'hands_up_loop'

---------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------
local function isLooted(ped)
    return Citizen.InvokeNative(0x8DE41E9902E85756, ped) -- _IS_ENTITY_FULLY_LOOTED
end

-- closest dead, networked, non-player ped that has not been looted yet
local function getLootablePed(coords)
    local closest, closestDist
    for _, ped in ipairs(GetGamePool('CPed')) do
        if not IsPedAPlayer(ped) and IsEntityDead(ped) and NetworkGetEntityIsNetworked(ped) and not isLooted(ped) then
            local dist = #(coords - GetEntityCoords(ped))
            if dist <= Config.LootDistance and (not closestDist or dist < closestDist) then
                closest, closestDist = ped, dist
            end
        end
    end
    return closest
end

---------------------------------------------------------------------
-- NPC looting
---------------------------------------------------------------------
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, Config.LootKey) then
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, true) then
                local target = getLootablePed(GetEntityCoords(ped))
                if target then
                    local pressed = GetGameTimer()
                    while IsControlPressed(0, Config.LootKey) do Wait(0) end
                    if GetGameTimer() - pressed > Config.LootHoldTime then
                        Wait(500)
                        if DoesEntityExist(target) and isLooted(target) then
                            local ok = lib.callback.await('rsg-looting:server:lootReward', false, NetworkGetNetworkIdFromEntity(target))
                            if ok and Config.LawAlert then
                                TriggerServerEvent('rsg-lawman:server:lawmanAlert', locale('law_alert'))
                            end
                        end
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------------------
-- rob other player
---------------------------------------------------------------------
-- asked by the server on the VICTIM's client, so the robber can't fake it
lib.callback.register('rsg-looting:client:isHandsUp', function()
    return IsEntityPlayingAnim(PlayerPedId(), HANDSUP_DICT, HANDSUP_ANIM, 3)
end)

local function notify(key, nType)
    lib.notify({ title = locale('rob_title'), description = locale(key), type = nType or 'error', duration = 5000 })
end

RegisterNetEvent('rsg-looting:client:RobPlayer', function()
    local player = lib.getClosestPlayer(GetEntityCoords(PlayerPedId()), Config.RobDistance)
    if not player then
        return notify('rob_not_nearby')
    end

    local targetId = GetPlayerServerId(player)
    if not lib.callback.await('rsg-looting:server:canRob', false, targetId) then
        return notify('rob_not_valid')
    end

    local done = lib.progressBar({
        duration = math.random(5000, 7000),
        label = locale('rob_progress'),
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = ROB_DICT, clip = ROB_ANIM, flag = 16 },
    })

    if not done then return notify('rob_cancelled') end
    TriggerServerEvent('rsg-looting:server:robPlayer', targetId)
end)
