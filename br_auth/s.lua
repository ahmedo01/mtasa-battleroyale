local connection = exports["br_db"]:getConnection()

function onPlayerCreateAccount(name, password, email)
	local accounts = dbPoll(dbQuery(connection, "SELECT * FROM `br_accounts`"), -1)
	
	local mk = 0 
	
	for k,v in ipairs(accounts) do 
		if v["name"] == name:gsub("%s+", "") then 
			exports["br_notifications"]:addNotification(client, "Ta nazwa jest już zajęta.", "error")
			return 
		end 
		
		if v["ip"] == getPlayerIP(client) or v["serial"] == getPlayerSerial(client) then 
			mk = mk+1 
		end 
	end 
	
	if mk == 5 then 
		exports["br_notifications"]:addNotification(client, "Możesz posiadać maksymalnie 5 kont.", "error")
		return 
	end 
	
	local accQuery = dbQuery(connection, "INSERT INTO `br_accounts` (name, password, serial, ip) VALUES (?, ?, ?, ?)", name, sha256(md5(password)), getPlayerSerial(client), getPlayerIP(client))
	local result, rows, last_id = dbPoll(accQuery, -1)
	dbFree(dbQuery(connection, "INSERT INTO `br_players` (accountid) VALUES (?)", last_id))
	
	setElementData(client, "player:uid", last_id)
	
	triggerClientEvent(client, "onPlayerRegisterSuccess", client)
end 
addEvent("onPlayerCreateAccount", true)
addEventHandler("onPlayerCreateAccount", root, onPlayerCreateAccount) 

function onPlayerEnterAccount(name, password)
	local accounts = dbPoll(dbQuery(connection, "SELECT * FROM `br_accounts` WHERE `name`=?", name, sha256(md5(password))), -1)
	if #accounts > 0 then 
		local acc = accounts[1] 
		if acc["password"] ~= sha256(md5(password)) then 
			exports["br_notifications"]:addNotification(client, "Nieprawidłowe hasło.", "error")
			return 
		end 
		
		dbFree(dbQuery(connection, "UPDATE `br_accounts` SET `timestamp_last`=NOW() WHERE `id`=?", acc["id"]))

		setElementData(client, "player:uid", acc["id"])
		setElementData(client, "player:rank", acc["rank"])
		
		triggerClientEvent(client, "onPlayerLoginSuccess", client)
	else 
		exports["br_notifications"]:addNotification(client, "Takie konto nie istnieje", "error")
	end 
end 
addEvent("onPlayerEnterAccount", true)
addEventHandler("onPlayerEnterAccount", root, onPlayerEnterAccount)

function enterGame(player)
	local stats = dbPoll(dbQuery(connection, "SELECT * FROM `br_players` WHERE `accountid`=?", getElementData(player, "player:uid")), -1)
	if not stats then kickPlayer(player, "CRITICAL ERROR: Please login again.") return end 
	stats = stats[1] 
	
	local x,y,z = -1812.50, -2104.99, 1132
	spawnPlayer(player, x,y,z)
	fadeCamera(player, true)
	
	setElementData(player, "player:spawned", true)
	setElementData(player, "player:onSpawn", true)
	
	setElementHealth(player, 100)
	setElementModel(player, 0)
	
	setCameraTarget(player, player)
	
	if not getElementData(player, "player:downloaded") then 
	end 
	
	setPlayerHudComponentVisible(player, "all", false)
	setPlayerHudComponentVisible(player, "radar", true)
	
	outputChatBox(">> Życzymy miłej gry! Pomoc znajdziesz pod klawiszem F9.", player, 0, 255, 0)
end 
addEvent("onPlayerEnterGame", true)
addEventHandler("onPlayerEnterGame", root, enterGame)

function savePlayer(player)
	local uid = getElementData(player, "player:uid") or false 
	if uid then 
	end 
end 

function saveData()
	for k,v in ipairs(getElementsByType("player")) do 
		savePlayer(v)
	end
end 
setTimer(saveData, 10000, 0)

addEventHandler("onPlayerQuit", root, function() savePlayer(source) end)