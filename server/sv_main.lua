ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('force_snatteriRewardItem')
AddEventHandler('force_snatteriRewardItem', function(itemToGive)
    local player = ESX.GetPlayerFromId(source)

    player.addInventoryItem(itemToGive, math.random(1, Config.RandomItemAmount))
end)