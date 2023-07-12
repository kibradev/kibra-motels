local QBCore = exports['qb-core']:GetCoreObject()
local kapiDurumu = nil
local RoomOwner = nil
local inRecepsiyon = false
local Kibroc = 31
local DrawTextON = false

Citizen.CreateThread(function() 
	while QBCore.Functions.GetPlayerData().citizenid == nil do
		Citizen.Wait(10)
	end
    while QBCore.Functions.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
	PlayerData = QBCore.Functions.GetPlayerData()
	while Kibroc == 31 do
        TriggerServerEvent('Kibra:Motels:Server:LoadMotelRooms')
        Citizen.Wait(100)
    end
    while RoomOwner == nil do
        TriggerServerEvent('Kibra:Motels:Server:LoadMotelRoomOwners')
        Citizen.Wait(100)
    end
end)

RegisterNetEvent('Kibra:Motels:Client:LoadMotelRooms', function(MotelData)
    Config.Motels = MotelData
end)

RegisterNetEvent('Kibra:Motels:Client:LoadMotelRoomOwners', function(RoomOwner)
    RoomOwner = RoomOwner
end)

RegisterCommand(Config.RoomNoDrawTextCommand, function()
	if not DrawTextON then
		DrawTextON = true
	else
		DrawTextON = false
	end
end)

Citizen.CreateThread(function()
	while true do
		TriggerServerEvent('Kibra:Motels:Server:Pay')
		Citizen.Wait(Config.BillingTime*1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local Sleep = 2000
		local PlayerPed = PlayerPedId()
		local PlayerCoord = GetEntityCoords(PlayerPed)
		for k,v in pairs(Config.Motels) do
			for oda,kapi in pairs(v.MotelDoors) do
				local Dist = GetDistanceBetweenCoords(PlayerCoord, v.MotelMainCoord)
				if Dist <= v.MotelDistance then
					if DrawTextON then
						Sleep = 5
						DrawText3D(kapi.Coord.x, kapi.Coord.y, kapi.Coord.z, oda)
					end
				end
			end
		end
		Citizen.Wait(Sleep)
	end
end)

Citizen.CreateThread(function()
	QBCore.Functions.TriggerCallback('Kibra:Motels:Server:DoorDataLoad', function(kapiDurumuServer)
		for k,v in pairs(Config.Motels) do
			for no,kapi in pairs(v.MotelDoors) do
				local doorsId = no*1000
				local prodeger = k*1000
				local newdeger = no+prodeger
				if not IsDoorRegisteredWithSystem(0x100+newdeger) then
					AddDoorToSystem(0x100+newdeger, kapi.Model, kapi.Coord, true, true, true)
					if kapiDurumuServer[no] then
						kapiDurum = kapiDurumuServer[no].durum
					else
						kapiDurum = (kapi.AutoLock == true and 1 or 0)
					end
					DoorSystemSetDoorState(0x100+newdeger, kapiDurum, 0 ,1)
					SetStateOfClosestDoorOfType(0x100+newdeger, kapi.Coord, 1, 0.0, true)
				end	
			end
		end
	end)
end)

Citizen.CreateThread(function()
	for k,v in pairs(Config.Motels) do
		if v.MotelBlipOpen then
			local blip = AddBlipForCoord(v.MotelMainCoord)
			SetBlipSprite(blip, v.MotelBlip.Id)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, v.MotelBlip.Scale)
			SetBlipColour(blip, v.MotelBlip.Color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.MotelName)
			EndTextCommandSetBlipName(blip)
		end
	end
end)

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = nil
    while true do
        wait = 5
        local ped = PlayerPedId()
		local PlayerCoord = GetEntityCoords(ped)
        local inZone = false
        for i = 1, #Config.Motels do
			local dist = GetDistanceBetweenCoords(PlayerCoord, Config.Motels[i].ReceptionCoord, true)
			if dist <= 2.0 then
				wait = 5
				inZone  = true
				text = Config.Motels[i].MotelName
 				DrawMarker(21, Config.Motels[i].ReceptionCoord.x, Config.Motels[i].ReceptionCoord.y, Config.Motels[i].ReceptionCoord.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, Config.Motels[i].MarkerColor.r, Config.Motels[i].MarkerColor.g, Config.Motels[i].MarkerColor.b, Config.Motels[i].MarkerColor.a, false, false, false, 1, false, false, false)
				if IsControlJustReleased(0, Config.OpenReceptionControl) then
					MotelReception(i)
				end
				break
			else
				wait = 2000
			end
        end
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
			DrawTextUI(Config.UIControls.OpenReceptionControl, text)
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
			CloseDrawTextUI()
        end
        Citizen.Wait(wait)
    end
end)

RegisterNetEvent('Kibra:Motels:Client:UseMotelKeys', function(Motel, MotelRoom, keydata)
	local PlayerPed = PlayerPedId()
	local PlayerCoord = GetEntityCoords(PlayerPed)
	for k,v in pairs(Config.Motels) do
		for f,g in pairs(v.MotelDoors) do
			local DoorDist = GetDistanceBetweenCoords(PlayerCoord, g.Coord, false)
			local StashDist = GetDistanceBetweenCoords(PlayerCoord, g.StashCoord, true)
			local prodeger = k*1000
			local newdeger = f+prodeger
			if StashDist <= 1.25 then
				if g.KeyData ~= nil then
					if g.KeyData == keydata and f == MotelRoom then 
						MotelDoorLockAnim()
						if g.StashLock then cemal = Lang[Config.Locale]["StashInfoTextMetaData"] else cemal = Lang[Config.Locale]["StashStatusLocked"] end
						if g.StashLock then
							if Config.UIDrawText then DrawTextUI("", cemal) end
							TriggerServerEvent('Kibra:Motels:Server:StashLock', k, f, not g.StashLock)
						else
							if Config.UIDrawText then DrawTextUI("", cemal) end
							TriggerServerEvent('Kibra:Motels:Server:StashLock', k, f, not g.StashLock)
						end
					else
						TriggerEvent('KibraNotify', Lang[Config.Locale]["ThisKeyIsInvalid"], 'error')
					end
				else
					TriggerEvent('KibraNotify', Lang[Config.Locale]["TheInvalidStashLockNotify"], 'error')
				end
			end

			if DoorDist <= 1.25 then
				if g.KeyData ~= nil then
					if g.KeyData == keydata and f == MotelRoom then
						MotelDoorLockAnim()
						kapiDurumu = DoorSystemGetDoorState(0x100+newdeger) == 0 and 1 or 0
						if kapiDurumu == 1 then
							TriggerEvent('KibraNotify', Lang[Config.Locale]["DoorLocked"], "error", 1200)
						else
							TriggerEvent('KibraNotify', Lang[Config.Locale]["DoorUnlocked"], "success", 1200)
						end
						TriggerServerEvent("Kibra:Motels:Server:ChangeDoorStatus", g, kapiDurumu, 0x100+newdeger)
					else
						TriggerEvent('KibraNotify', Lang[Config.Locale]["ThisKeyIsNotDoor"], 'error')
					end
				else
					TriggerEvent('KibraNotify', Lang[Config.Locale]["TheInvalidDoorLockNotify"], 'error')
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
    local alreadyEnteredZone = false
    local text = nil
    while true do
        wait = 5
        local ped = PlayerPedId()
		local PlayerCoord = GetEntityCoords(ped)
        local inZone = false
        for i = 1, #Config.Motels do
			for e = 1, #Config.Motels[i].MotelDoors do
				local dist = GetDistanceBetweenCoords(PlayerCoord, Config.Motels[i].MotelDoors[e].Wardrobe, true)
				if dist <= 1.25 then
					wait = 1
					inZone  = true
					text = Lang[Config.Locale]["Wardrobe"]
					DrawMarker(21, Config.Motels[i].MotelDoors[e].Wardrobe.x, Config.Motels[i].MotelDoors[e].Wardrobe.y, Config.Motels[i].MotelDoors[e].Wardrobe.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, Config.Motels[i].MarkerColor.r, Config.Motels[i].MarkerColor.g, Config.Motels[i].MarkerColor.b, Config.Motels[i].MarkerColor.a, false, false, false, 1, false, false, false)
					if IsControlJustReleased(0, Config.WardrobeOpenControl) then
						if Config.Wardrobe.EventType == "client" then
							TriggerServerEvent("InteractSound_SV:PlayOnSource", "Clothes1", 0.4)
							TriggerEvent(Config.Wardrobe.EventName)
						else
							TriggerServerEvent(Config.Wardrobe.EventName)
						end
					end
					break
				else
					wait = 2
				end
			end
        end
        if inZone and not alreadyEnteredZone then
            alreadyEnteredZone = true
			DrawTextUI(Config.UIControls.OpenReceptionControl, text)
        end

        if not inZone and alreadyEnteredZone then
            alreadyEnteredZone = false
			CloseDrawTextUI()
        end
        Citizen.Wait(wait)
    end
end)

Citizen.CreateThread(function()
	local alreadyEnteredZone = false
    local text = nil
	while Config.MetaData == true do
		local Sleep = 2000
		local inZone = false
		local PlayerPed = PlayerPedId()
		local PlayerCoord = GetEntityCoords(PlayerPed)
		for MNO = 1, #Config.Motels, 1 do
			for ONO = 1, #Config.Motels[MNO].MotelDoors, 1 do
				local Distance = GetDistanceBetweenCoords(PlayerCoord, Config.Motels[MNO].MotelDoors[ONO].StashCoord)
				if Distance <= 2.0 then
					Sleep = 1
					if Config.Motels[MNO].MotelDoors[ONO].StashLock then text = Lang[Config.Locale]["StashInfoTextMetaData"] else text = Lang[Config.Locale]["StashStatusLocked"] end
					if Config.UIDrawText then
						Sleep = 1
						inZone = true
					else
						DrawText3D(Config.Motels[MNO].MotelDoors[ONO].StashCoord.x, Config.Motels[MNO].MotelDoors[ONO].StashCoord.y, Config.Motels[MNO].MotelDoors[ONO].StashCoord.z, text)
					end
					if not Config.Motels[MNO].MotelDoors[ONO].StashLock then
						if IsControlJustReleased(0, Config.StashOpenControl) then
							TriggerServerEvent(Config.InventoryStashEvents.ServerEvent, "stash", Config.SaveInventoryStashName.."_"..MNO..'_'..ONO)
							TriggerEvent(Config.InventoryStashEvents.ClientEvent, Config.SaveInventoryStashName.."_"..MNO..'_'..ONO)
						end
					end
				
				end
			end
		end
		if inZone and not alreadyEnteredZone then
			alreadyEnteredZone = true
			if Config.UIDrawText then DrawTextUI("", text) end
		end

		if not inZone and alreadyEnteredZone then
			alreadyEnteredZone = false
			CloseDrawTextUI()
		end
		Citizen.Wait(Sleep)
	end
end)

RegisterNetEvent('Kibra:Motels:Client:StashLock', function(MotelNo, MotelRoomId, State)
    Config.Motels[MotelNo].MotelDoors[MotelRoomId].StashLock = State
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'kapi', 0.7)
end)

function MotelDoorLockAnim()
    RequestAnimDict("anim@mp_player_intmenu@key_fob@")
    while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
        Citizen.Wait(1)
    end
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
    Citizen.Wait(500)
    ClearPedTasks(PlayerPedId())
end

Citizen.CreateThread(function()
	local alreadyEnteredZone = false
	local NormalText = nil
	while not Config.MetaData do
		local Sleep = 2000
		local inZone = false
		local PlayerPed = PlayerPedId()
		local PlayerCoord = GetEntityCoords(PlayerPed)
		for MNO = 1, #Config.Motels, 1 do
			for ONO = 1, #Config.Motels[MNO].MotelDoors, 1 do
				local RoomStash = GetDistanceBetweenCoords(PlayerCoord, Config.Motels[MNO].MotelDoors[ONO].StashCoord, true)
				if RoomStash <= 1.5 then
					Sleep = 1
					if not Config.Motels[MNO].MotelDoors[ONO].StashLock then
						NormalText = Lang[Config.Locale]["StashStatusLocked"]
					else
						NormalText = Lang[Config.Locale]["StashInfoText"]
					end
					if Config.Motels[MNO].MotelDoors[ONO].StashLock then
						NormalText2 = Lang[Config.Locale]["StashStatusLocked"]
					else
						NormalText2 = Lang[Config.Locale]["StashInfoText"]
					end
					if Config.UIDrawText then
						inZone = true
					else
						Sleep = 1
						DrawText3D(Config.Motels[MNO].MotelDoors[ONO].StashCoord.x, Config.Motels[MNO].MotelDoors[ONO].StashCoord.y, Config.Motels[MNO].MotelDoors[ONO].StashCoord.z, '~g~'..Config.UIControls.StashLockControl..'~w~ '..NormalText2)
					end
					if IsControlJustReleased(0, Config.StashLockControl) then
						if Config.StashAccessEveryone then
							if Config.Motels[MNO].MotelDoors[ONO].Owner == PlayerData.citizenid then
								if Config.Motels[MNO].MotelDoors[ONO].StashLock == true then
									MotelDoorLockAnim()
									TriggerServerEvent('Kibra:Motels:Server:StashLock', MNO, ONO, not Config.Motels[MNO].MotelDoors[ONO].StashLock)
									if Config.UIDrawText then DrawTextUI(Config.UIControls.DoorLockOpenControl, NormalText) end
								else
									MotelDoorLockAnim()
									TriggerServerEvent('Kibra:Motels:Server:StashLock', MNO, ONO, not Config.Motels[MNO].MotelDoors[ONO].StashLock) end
									if Config.UIDrawText then DrawTextUI(Config.UIControls.DoorLockOpenControl, NormalText)
								end
							else
								TriggerEvent('KibraNotify', Lang[Config.Locale]["YourNotOwnThisRoom"], 'error')
							end
						else
							if Config.Motels[MNO].MotelDoors[ONO].StashLock == true then
								MotelDoorLockAnim()
								TriggerServerEvent('Kibra:Motels:Server:StashLock', MNO, ONO, not Config.Motels[MNO].MotelDoors[ONO].StashLock)
								if Config.UIDrawText then DrawTextUI(Config.UIControls.DoorLockOpenControl, NormalText) end
							else
								MotelDoorLockAnim()
								TriggerServerEvent('Kibra:Motels:Server:StashLock', MNO, ONO, not Config.Motels[MNO].MotelDoors[ONO].StashLock)
								if Config.UIDrawText then DrawTextUI(Config.UIControls.DoorLockOpenControl, NormalText) end
							end
						end
					end
					if IsControlJustReleased(0, Config.StashOpenControl) then
						if not Config.Motels[MNO].MotelDoors[ONO].StashLock then
							TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.SaveInventoryStashName.."_"..MNO..'_'..ONO)
							TriggerServerEvent("InteractSound_SV:PlayOnSource", "StashOpen", 0.4)
							TriggerEvent("inventory:client:SetCurrentStash", Config.SaveInventoryStashName.."_"..MNO..'_'..ONO)
						end
					end
				else
					Sleep = 1
				end
			end
		end
		if inZone and not alreadyEnteredZone then
			alreadyEnteredZone = true
			DrawTextUI(Config.UIControls.DoorLockOpenControl, NormalText)
		end
		if not inZone and alreadyEnteredZone then
			alreadyEnteredZone = false
			CloseDrawTextUI()
		end
		Citizen.Wait(Sleep)
	end
end)

Citizen.CreateThread(function()
	local alreadyEnteredZone = false
	local yazi = nil
	while not Config.MetaData do
		local sure = 2000
		local inZone = false
		local PlayerPed = PlayerPedId()
		local PlayerCoord = GetEntityCoords(PlayerPed)
		for k,v in pairs(Config.Motels) do
			for no, kapi in pairs(v.MotelDoors) do
				local Distance = GetDistanceBetweenCoords(PlayerCoord, kapi.Coord, true)
				if Distance <= v.MotelDoorDistance then
					sure = 1
					local prodeger = k*1000
					local newdeger = no+prodeger
					if kapiDurumu == 0 then yazi = Lang[Config.Locale]["DoorLockedText"] else yazi = Lang[Config.Locale]["DoorUnlockedText"] end	
					if kapiDurumu == 0 then yazi2 = Lang[Config.Locale]["DoorUnlockedText"] else yazi2 = Lang[Config.Locale]["DoorLockedText"] end	
					if Config.UIDrawText then inZone = true else DrawText3D(kapi.Coord.x, kapi.Coord.y, kapi.Coord.z, '~g~'..Config.UIControls.DoorLockOpenControl..'~w~ '..yazi..' '..no) end
					kapiDurumu = DoorSystemGetDoorState(0x100+newdeger) == 0 and 1 or 0
					if IsControlJustReleased(0, Config.DoorLockControl) then
						if kapi.Owner == PlayerData.citizenid then
							if kapiDurumu == 1 then
								if Config.UIDrawText then DrawTextUI(Config.UIControls.DoorLockOpenControl, yazi2) end
								TriggerEvent('KibraNotify', Lang[Config.Locale]["DoorLocked"], "error", 1200)
							else
								if Config.UIDrawText then DrawTextUI(Config.UIControls.DoorLockOpenControl, yazi2) end
								TriggerEvent('KibraNotify', Lang[Config.Locale]["DoorUnlocked"], "success", 1200)
							end 
							TriggerServerEvent("Kibra:Motels:Server:ChangeDoorStatus", kapi, kapiDurumu, 0x100+newdeger)
						else
							TriggerEvent('KibraNotify', Lang[Config.Locale]["YourNotOwnThisRoom"], 'error')
						end
					end	
				else
					sure = 1
				end
			end
		end
		if inZone and not alreadyEnteredZone then
			alreadyEnteredZone = true
			DrawTextUI(Config.UIControls.DoorLockOpenControl, yazi)
		end
		if not inZone and alreadyEnteredZone then
			alreadyEnteredZone = false
			CloseDrawTextUI()
		end
		Citizen.Wait(sure)
	end
end)


function MotelReception(MotelId)
	inRecepsiyon = true
	SetNuiFocus(true, true)
	for k,v in pairs(Config.Motels[MotelId].MotelDoors) do
		QBCore.Functions.TriggerCallback('Kibra:Motels:Server:GetBuyMotel', function(motelaldimi, PlayerMotelTable, GuncelMotelId, OdaId)
			if PlayerMotelTable ~= nil then 
				for b,g in pairs(PlayerMotelTable) do
					SendNUIMessage({
						type = "OpenReception",
						MotelId = MotelId,
						MotelName = Config.Motels[MotelId].MotelName,
						data = Config.Motels[MotelId].MotelDoors,
						doorno = k,
						motelsorgu = motelaldimi,
						toplamoda = #Config.Motels[MotelId].MotelDoors,
						PMotelTable = PlayerMotelTable,
						RoomPrice = Config.Motels[MotelId].RoomPrice,
						MotelPNG = Config.Motels[MotelId].Background,
						LeftMotelName = Config.Motels[GuncelMotelId].MotelName
					})
				end
			else
				SendNUIMessage({
					type = "OpenReception",
					MotelId = MotelId,
					MotelName = Config.Motels[MotelId].MotelName,
					data = Config.Motels[MotelId].MotelDoors,
					doorno = k,
					motelsorgu = motelaldimi,
					toplamoda = #Config.Motels[MotelId].MotelDoors,
					PMotelTable = PlayerMotelTable,
					MotelPNG = Config.Motels[MotelId].Background,
					RoomPrice = Config.Motels[MotelId].RoomPrice,
				})
			end
		end)
	end
end

RegisterNetEvent('Kibra:Motels:Client:CloseAllUI', function()
	SendNUIMessage({type = "CloseReception"})	
end)

RegisterNUICallback("BuyMotelRoom", function(Data)
	local Mid = tonumber(Data.MotelId)
	local Rid = tonumber(Data.RoomNo)
	if Config.Motels[Mid].MotelDoors[Rid] == nil or "" then
		TriggerServerEvent('Kibra:Motels:Server:BuyMotelRooms', tonumber(Data.MotelId), tonumber(Data.RoomNo), tonumber(Data.OdaFiyat))
	else
		TriggerEvent('KibraNotify', Lang[Config.Locale]["ThisRoomHasOwner"], 'error')
	end
end)

RegisterNUICallback("CopyMotelKeyRoom", function(Data)
	TriggerServerEvent('Kibra:Motels:Server:CopyMotelKeyRoom', Data.RoomNo)
end)

RegisterNUICallback("LeftMotelRoom", function(Data)
	TriggerServerEvent('Kibra:Motels:Server:LeftMotelRooms', Data.RoomNo, Data.OdaSahip)
end)

RegisterNUICallback("CloseReception", function()
	SetNuiFocus(false, false)
	inRecepsiyon = false
end)

RegisterNUICallback("CloseReception2", function()
	SetNuiFocus(false, false)
	inRecepsiyon = false
end)

RegisterNetEvent("Kibra:Motels:Client:ChangeDoorStatusEveryone", function(kapi, data, no)
	DoorSystemSetDoorState(no, data.durum, 0 ,1)
	SetStateOfClosestDoorOfType(no, kapi.Coord, 1, 0.0, true)
end)

function DrawText3D(x, y, z, text)
    -- Use local function instead
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end