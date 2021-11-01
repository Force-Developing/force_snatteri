ESX              = nil
local PlayerData = {}
local coolDown = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

Citizen.CreateThread(function()
	while true do
		local sleepThread = 750
		local player = PlayerPedId(-1)
		local pCoords = GetEntityCoords(player)

		for _,p in pairs(Config.Positions) do
			local dist1 = GetDistanceBetweenCoords(pCoords, p.x, p.y, p.z)
			if dist1 < 1 then
				sleepThread = 5;
				if p.coolDown == 0 then
					Draw3DText(p.x, p.y, p.z, '[~g~E~w~] Snatta')
					if IsControlJustPressed(1, 38) then
						FreezeEntityPosition(player, true)
						exports["sjrp_progressbar"]:StartDelayedFunction({
							["text"] = "Plockar upp varor!",
							["delay"] = 5000
						})
						ESX.LoadAnimDict("mini@repair")
						TaskPlayAnim(player, 'mini@repair', 'fixing_a_ped', 1.0, -1.0, 5000, 69, 0, 0, 0, 0)
						Wait(5000)
						p.coolDown = Config.CoolDownTimer
						FreezeEntityPosition(player, false)
						itemToGive = Config.RewardItems[math.random(1, #Config.RewardItems)]
						TriggerServerEvent('force_snatteriRewardItem', itemToGive.item)
						ESX.ShowNotification('Du snattade ' .. itemToGive.label .. '!')
					end
				else
					Draw3DText(p.x, p.y, p.z, '[~r~E~w~] Snatta')
					if IsControlJustPressed(1, 38) then
						ESX.ShowNotification('Du har precis rånat denna hyla vänta ' .. p.coolDown .. ' sekunder innan du kan råna denna hyla igen!')
					end
				end
			end
		end
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1000)
		for _,p in pairs(Config.Positions) do
			if p.coolDown > 0 then
				p.coolDown = p.coolDown - 1
				print(p.coolDown)
			end
		end
	end
end)