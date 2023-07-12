local QBCore = exports['qb-core']:GetCoreObject()
local DoorsStatus = {}


local Jobs = {}
local LastTime = nil

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM kibra_motels', function(MotelVerileri)
		for k,v in pairs(MotelVerileri) do
			local Mid, Rid = MotelIdFind(v.roomid)
			Config.Motels[Mid].MotelDoors[Rid].Owner = v.owner 
			Config.Motels[Mid].MotelDoors[Rid].KeyData = v.keydata
		end
	end)
end)


function RunAt(h, m, cb)
	table.insert(Jobs, {
		h  = h,
		m  = m,
		cb = cb
	})
end

function GetTime()
	local timestamp = os.time()
	local d = os.date('*t', timestamp).wday
	local h = tonumber(os.date('%H', timestamp))
	local m = tonumber(os.date('%M', timestamp))

	return {d = d, h = h, m = m}
end

function OnTime(d, h, m)

	for i=1, #Jobs, 1 do
		if Jobs[i].h == h and Jobs[i].m == m then
			Jobs[i].cb(d, h, m)
		end
	end
end

function Tick()
	local time = GetTime()

	if time.h ~= LastTime.h or time.m ~= LastTime.m then
		OnTime(time.d, time.h, time.m)
		LastTime = time
	end

	SetTimeout(60000, Tick)
end

LastTime = GetTime()

Tick()

AddEventHandler('Kibra:Motels:Bill', function(h, m, cb)
	RunAt(h, m, cb)
end)


QBCore.Functions.CreateCallback('Kibra:Motels:Server:DoorDataLoad', function(source, cb)
	cb(DoorsStatus)
end)

RegisterServerEvent('Kibra:Motels:Server:ChangeDoorStatus', function(no, durum, kapino)
	DoorsStatus[no] = {durum = durum}
	TriggerClientEvent("Kibra:Motels:Client:ChangeDoorStatusEveryone", -1, no, DoorsStatus[no], kapino)
	if durum == 1 then 
		DoorsStatus[no] = nil
	end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('Kibra:Motels:Client:LoadMotelRooms', source, Config.Motels)
    TriggerClientEvent('Kibra:Motels:Client:LoadMotelRoomOwners', source, Player.PlayerData.citizenid)
end)

RegisterNetEvent('Kibra:Motels:Server:LoadMotelRooms', function()
    TriggerClientEvent('Kibra:Motels:Client:LoadMotelRooms', source, Config.Motels)
end)

RegisterNetEvent('Kibra:Motels:Server:RefreshMotels', function()
    TriggerClientEvent('Kibra:Motels:Client:LoadMotelRooms', -1, Config.Motels)
end)

RegisterNetEvent('Kibra:Motels:Server:LoadMotelRoomOwners', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        TriggerClientEvent('Kibra:Motels:Client:LoadMotelRoomOwners', source, Player.PlayerData.citizenid)
    end
end)

if Config.MetaData then
	QBCore.Functions.CreateUseableItem(Config.MotelKeyItemName , function(source, item)   
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)
		if Player.Functions.GetItemBySlot(item.slot) ~= nil then
			local Motel, NewMotelRoomNo = MotelIdFind(item.info.MotelRoomReal)
			Password = item.info.MotelRoomKeyData
			TriggerClientEvent('Kibra:Motels:Client:UseMotelKeys', source, tonumber(Motel), NewMotelRoomNo, Password)
		--	print("Kullanılan Anahtar Info || Motel No: "..Motel.." || Motel Oda No: "..NewMotelRoomNo.." || KeyData: "..Password)
		end
	end)
end

RegisterNetEvent('Kibra:Motels:Server:StashLock', function(MotelNo, MotelRoomId, State)
    Config.Motels[MotelNo].MotelDoors[MotelRoomId].StashLock = State
    TriggerClientEvent('Kibra:Motels:Client:StashLock', -1, MotelNo, MotelRoomId, State)
    if State == not locked then
        TriggerClientEvent('KibraNotify', source, Lang[Config.Locale]["SuccessLockStash"], 'error')
    else
        TriggerClientEvent('KibraNotify', source, Lang[Config.Locale]["SuccessUnlockStash"], 'success')
    end
end)

RegisterNetEvent('Kibra:Motels:Server:CopyMotelKeyRoom', function(RoomOwner)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local MotelId, RoomId = MotelIdFind(RoomOwner)
	local RandomKeyData = 'KBRA_'..math.random(1111,9999)
	local PlayerMoney = Player.PlayerData.money["cash"]
	if PlayerMoney >= Config.CopyRoomKeyPrice then
		MySQL.Async.fetchAll('UPDATE kibra_motels SET keydata = @keydata WHERE roomid = @roomid', {
			["@keydata"] = RandomKeyData,
			["@roomid"] = RoomOwner
		})
		local info = {
			MotelRoomUnreal = RoomId,
			MotelRoomReal = MotelId..'_'..RoomId,
			MotelName = Config.Motels[MotelId].MotelName,
			MotelRoomKeyData = RandomKeyData
		}
		Player.Functions.AddItem(Config.MotelKeyItemName, 1, false, info)
		Config.Motels[MotelId].MotelDoors[RoomId].KeyData = RandomKeyData 
		TriggerEvent('Kibra:Motels:Server:RefreshMotels')
		TriggerClientEvent('Kibra:Motels:Client:CloseAllUI', src)
		TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["SuccessNewMotelKey"], 'success')
	else
		TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["CopyDontHaventMoney"], 'error')
	end
end)

RegisterNetEvent('Kibra:Motels:Server:BuyMotelRooms', function(Mid, Rid, Price)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local RoomData = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE owner = @owner', {["@owner"] = Player.PlayerData.citizenid})
	local RoomCData = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE roomid = @RoomId', {["@RoomId"] = Mid..'_'..Rid})
	local RandomKeyData = 'KIBRA_'..math.random(111111,999999)
	if Config.MultiMotel then
		if Player.PlayerData.money["cash"] >= Price then
			MySQL.Async.fetchAll('UPDATE kibra_motels SET owner = @owner, keydata = @keydt, bought = @bg WHERE roomid = @roomid', {
				["@owner"] = Player.PlayerData.citizenid,
				["@keydt"] = RandomKeyData,
				["@bg"] = 1,
				["@roomid"] = Mid..'_'..Rid
			})
			Player.Functions.RemoveMoney(Config.MotelRoomRentBuyType, Price)
			if Config.MetaData then
				local info = {
					MotelRoomUnreal = Rid,
					MotelRoomReal = Mid..'_'..Rid,
					MotelName = Config.Motels[Mid].MotelName,
					MotelRoomKeyData = RandomKeyData
				}
				Player.Functions.AddItem(Config.MotelKeyItemName, 1, false, info)
			end
			Config.Motels[Mid].MotelDoors[Rid].Owner = Player.PlayerData.citizenid 
			Config.Motels[Mid].MotelDoors[Rid].KeyData = RandomKeyData 
			TriggerEvent('Kibra:Motels:Server:RefreshMotels')
			TriggerClientEvent('Kibra:Motels:Client:CloseAllUI', src)
			TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YouBuyMotelRoom"], 'success')
		else
			TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YouDontHaveMoney"], 'error')
		end
	else
		if #RoomData > 0 then
			TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YouRentedMotelRoom"], 'error')
		else
			if Player.PlayerData.money["cash"] >= Price then
				MySQL.Async.fetchAll('UPDATE kibra_motels SET owner = @owner, keydata = @keydt, bought = @bg WHERE roomid = @roomid', {
					["@owner"] = Player.PlayerData.citizenid,
					["@keydt"] = RandomKeyData,
					["@bg"] = 1,
					["@roomid"] = Mid..'_'..Rid
				})
				if Config.MetaData then
					local info = {
						MotelRoomUnreal = Rid,
						MotelRoomReal = Mid..'_'..Rid,
						MotelName = Config.Motels[Mid].MotelName,
						MotelRoomKeyData = RandomKeyData
					}
					Player.Functions.AddItem(Config.MotelKeyItemName, 1, false, info)
				end
				Config.Motels[Mid].MotelDoors[Rid].Owner = Player.PlayerData.citizenid 
				Config.Motels[Mid].MotelDoors[Rid].KeyData = RandomKeyData 
				TriggerEvent('Kibra:Motels:Server:RefreshMotels')
				TriggerClientEvent('Kibra:Motels:Client:CloseAllUI', src)
				Player.Functions.RemoveMoney('cash', Price)
				TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YouBuyMotelRoom"], 'success')
			else
				TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YouDontHaveMoney"], 'error')
			end
		end
	end
	TriggerClientEvent('Kibra:Motels:Client:CloseAllUI', src)
end)

QBCore.Functions.CreateCallback('Kibra:Motels:Server:GetBuyMotel', function(source, cb)
	local Player = QBCore.Functions.GetPlayer(source)
	local MotelData = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE owner = @owner', {["@owner"] = Player.PlayerData.citizenid})
	if #MotelData > 0 then
		for k,v in pairs(MotelData) do
			local MotelId, RoomId = MotelIdFind(v.roomid)
			cb(true, MotelData, MotelId, RoomId) 
		end
	else
		cb(false)
	end
end)

function MotelIdFind(keyData)
    local s1 = keyData:find('_')
    local motelNo = keyData:sub(1, (s1 - 1))
    local roomNo = keyData:sub(s1 + 1, keyData:len())
    return tonumber(motelNo), tonumber(roomNo)
end

RegisterNetEvent('Kibra:Motels:Server:LeftMotelRooms', function(MotelId)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local MotelNo, MotelOdaNo = MotelIdFind(MotelId)
	local AyrilacakMotel = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE roomid = @roomid', {["@roomid"] = MotelId})
	if #AyrilacakMotel > 0 then
		MySQL.Async.fetchAll('UPDATE kibra_motels SET owner = @owner, keydata = @keydata, bought = @bg WHERE roomid = @id', {
			["@owner"] = nil,
			["@keydata"] = nil,
			["@bg"] = 0,
			["@id"] = MotelNo..'_'..MotelOdaNo
		})
		local newoda = tonumber(MotelOdaNo)
		local newmotel = tonumber(MotelNo)
		Config.Motels[newmotel].MotelDoors[newoda].Owner = nil
		Config.Motels[newmotel].MotelDoors[newoda].KeyData = nil
		TriggerEvent('Kibra:Motels:Server:RefreshMotels')
		TriggerClientEvent('Kibra:Motels:Client:CloseAllUI', src)
		TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YouLeftMotelRoom"], 'success')
	end
end)



RegisterNetEvent('Kibra:Motels:Server:AddBilling', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local PlayerMotels = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE owner = @owner', {["@owner"] = Player.PlayerData.citizenid})
	for k,v in pairs(Config.Motels) do
		if #PlayerMotels > 0 then
			if v.Payment then
				MySQL.Async.insert('INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (@cid, @amount, @scty, @sndr, @sndrcid)', {
					["@cid"] = Player.PlayerData.citizenid,
					["@amount"] = v.InvoiceAmount,
					["@scty"] = v.MotelSocietyName,
					["@sndr"] = v.MotelName, 
					["@sndrcid"] = nil
				})
				if Config.QBPhone then TriggerClientEvent('qb-phone:RefreshPhone', Player.PlayerData.source) end
				TriggerClientEvent('KibraNotify', src, Lang[Config.Locale]["YoujustgotanewMotelbill"])
			end
		end
	end
end)

QBCore.Commands.Add(Config.NewRoomAddCommand, "NewMotelRoomAdd", {{ name = "Motel No", help = "Enter the Motel Number" }, { name = "Room No", help = "Enter the Room number" }}, false, function(source, args)
	local x = args[1]
	local y = args[2]
	local odano = x..'_'..y
	if x ~= nil then
		if y ~= nil then
			local TumOdalar = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE roomid = @odano', {
				["@odano"] = odano
			})
			if #TumOdalar > 0 then
				TriggerClientEvent('KibraNotify', source, Lang[Config.Locale]["Thereissuchahotelroominthedatabase"], 'error')
			else
				MySQL.Async.insert('INSERT INTO kibra_motels (roomid) VALUES (@roomid)', {
					["@roomid"] = odano
				})
				TriggerClientEvent('KibraNotify', source, Lang[Config.Locale]["SuccessDatabaseAddNewRoom"], 'success')
			end
		end
	end
end, "admin")

QBCore.Functions.CreateCallback('Kibra:Motels:Server:ControlMotel', function(source, cb, cid)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Datax = MySQL.Sync.fetchAll('SELECT * FROM kibra_motels')
	for k,v in pairs(Datax) do
		if v.owner ~= nil then
			if v.owner == Player.PlayerData.citizenid then
				cb(true) 
			else
				cb(false)
			end
		end
	end
end)

DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

RegisterNetEvent('Kibra:Motels:Server:Pay', function()
	local MotelData =  MySQL.Sync.fetchAll('SELECT * FROM kibra_motels WHERE bought = 1')
	if #MotelData >= 1 then
		for k,v in pairs(MotelData) do
			local BillPlayer = QBCore.Functions.GetPlayerByCitizenId(v.owner)
			if BillPlayer then
				local PlyMoney = BillPlayer.PlayerData.money["bank"]
				local Motel, Rid = MotelIdFind(v.roomid)
				if PlyMoney >= Config.Motels[Motel].InvoiceAmount then
					BillPlayer.Functions.RemoveMoney('bank', Config.Motels[Motel].InvoiceAmount)
					TriggerClientEvent('KibraNotify', BillPlayer.PlayerData.source, Lang[Config.Locale]["NewInvoiceAutoMotelRentAmount"])
				else
					MySQL.Async.fetchAll('UPDATE kibra_motels SET owner = @owner, keydata = @keydata, bought = @bought WHERE roomid = @id', {
						["@owner"] = nil,
						["@keydata"] = nil,
						["@bought"] = 0,
						["@id"] = Motel..'_'..Rid
					})
					Config.Motels[Motel].MotelDoors[Rid].Owner = nil
					Config.Motels[Motel].MotelDoors[Rid].KeyData = nil
					TriggerEvent('Kibra:Motels:Server:RefreshMotels')
					TriggerClientEvent('KibraNotify', BillPlayer.PlayerData.source, Lang[Config.Locale]["YourOwnMotelRoomIptal"])
				end
			end
		end
	end
end)