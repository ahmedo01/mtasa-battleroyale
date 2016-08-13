local connection = exports["br_db"]:getConnection()

function addStat(player, stat, amount)
	if not player or not stat or not amount then return end 
	
	local uid = getElementData(player, "player:uid")
	if not uid then return end 
	
	-- zapis w bazie danych 
	local query = dbQuery(connection, "SELECT * FROM `br_players` WHERE `accountid`=?", uid)
	local result = dbPoll(query, -1)
	if not result then return end 
	if not result[1][stat] then return end 
	
	local value = result[1][stat]+amount 
	
	dbFree(dbQuery(connection, "UPDATE `br_players` SET `"..tostring(stat).."`=? WHERE `accountid`=?", value, uid))
	
	-- zapis w element dacie 
	local data = getElementData(player, "player:"..tostring(stat)) or 0 
	data = data+amount 
	setElementData(player, "player:"..tostring(stat), data)
	return true 
end 