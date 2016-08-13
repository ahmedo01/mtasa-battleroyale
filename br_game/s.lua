local id = 0
local game = {} 

-- spawny 
local spawns = 
{
	{60.66, -79}, -- red county
	{1641.54, -1503}, -- LS
	{-1897, -2165}, -- zadupie kolo mount chilliad,
	{-766, -1218}, -- zadupie kolo LS
	{-2264, 518}, -- SF
	{1825, 1575}, -- LV
	{-77, 1033}, -- Fort Carson
	{143, 1915}, -- Strefa 69,
	{216, 2503}, -- Opuszczone lotnisko, 
	{2376, 12}, -- miasteczko przed lv
	{1227, 306}, -- miasteczko przed lv 2 
	{2340, 2365}, -- LV 2 
	{2248, -2036}, -- ls 2 
	{-2209, -455}, -- sf 2 
	{612, 904}, -- lv kopalnia
}
local startHeight = 850 -- na jakiej wysokosci zaczynamy gre 
local spawnOffset = 100 -- maks. losowe oddalenie od spawnu 

-- pozycje kurczenia się gazu 
local gas = 
{
	{1779.83, -2532.77, 13},
	{217, 1408, 11},
	{2609, 2738, 15},
	{-1048, -665, 33},
	{621, 860, 10},
}

local vehicleSpawns = 
{
	{2192.703125,-720.572265625,94.100173950195,0,0,326.71914672852,75},
	{-544.0078125,-101.365234375,63.61283493042,0,0,193.56283569336,75},
	{-2461.505859375,2402.681640625,15.823610305786,0,0,219.501953125,75},
	{-671.1630859375,2420.1728515625,134.39416503906,0,0,112.04302978516,75},
	{602.326171875,891.1943359375,-44.148097991943,0,0,223.4076385498,75},
	{2877.9716796875,1261.36328125,10.8984375,0,0,353.8063659668,75},
	{-412.19140625,-2700.5341796875,160.31304931641,0,0,77.325714111328,75},
	{376.140625,-2068.6318359375,7.8359375,0,0,270.88577270508,75},
	{1735.8720703125,1429.0693359375,10.797702789307,0,0,0,10},
	{2797.1318359375,-1868.8359375,9.8603811264038,0,0,0,10},
	{1941.900390625,1975.1904296875,7.59375,0,0,0,10},
	{194.685546875,-120.2333984375,1.5497757196426,0,0,0,75},
	{173.0146484375,-95.0634765625,1.5516006946564,0,0,0,75},
	{2369.9599609375,29.712890625,28.0416431427,0,0,0,75},
	{710.87109375,-566.7548828125,16.3359375,0,0,0,75},
	{1109.6025390625,-1667.6689453125,13.615442276001,0,0,0,75},
	{2014.6689453125,-1113.4013671875,26.203125,0,0,0,75},
	{2447.41015625,-1967.1845703125,13.546875,0,0,0,75},
	{2633.7236328125,1835.291015625,11.0234375,0,0,0,75},
	{1489.3974609375,2681.54296875,10.8203125,0,0,0,75},
	{-2428.5654296875,2280.875,4.984375,0,0,0,75},
	{-2142.8515625,-2457.84765625,30.625,0,0,0,75},
	{-2456.078125,-141.115234375,26.112222671509,0,0,0,75},
	{-1881.4453125,954.3837890625,35.171875,0,0,0,75},
	{2505.7841796875,-1685.708984375,13.556800842285,0,0,357.11331176758,10},
	{-2689.451171875,-2059.4912109375,35.298820495605,0,0,32.665588378906,10},
	{86.486328125,1950.9013671875,17.846803665161,0,0,0,10},
	{440.185546875,1464.173828125,6.3338670730591,0,0,0,10},
	{-812.470703125,-2629.912109375,90.105056762695,0,0,0,75},
	{-1729.8525390625,-1940.3154296875,99.840209960938,0,0,0,75},
	{-2130.90234375,178.4375,35.257678985596,0,0,0,75},
	{-2656.7333984375,1352.4873046875,7.0596733093262,0,0,0,75},
	{-92.9951171875,2823.0908203125,76.721649169922,0,0,0,35},
	{-2448.99609375,-1335.8662109375,310.97662353516,0,0,0,35},
	{-173.2470703125,-2635.5341796875,26.608192443848,0,0,0,35},
	{1658.9716796875,-1069.0224609375,23.906229019165,0,0,0,10},
	{-1598.302734375,2694.947265625,55.07092666626,0,0,0,10},
	{1190.41015625,-2109.0341796875,64.738548278809,0,0,0,10},
	{2108.447265625,-1600.916015625,13.552597045898,0,0,0,10},
	{2452.7392578125,1607.9833984375,10.8203125,0,0,0,10},
	{-1800.8984375,-1950.9736328125,93.561332702637,0,0,0,10},
	{505.732421875,-291.8681640625,20.00952911377,0,0,0,10},
	{-428.8828125,-694.8310546875,19.14847946167,0,0,0,10},
	{-1889.4580078125,-1571.412109375,21.75,0,0,295.13299560547,75},
	{-1146.005859375,-918.8154296875,129.21875,0,0,109.12612915039,75},
	{1455.109375,-528.5146484375,70.800422668457,0,0,322.7585144043,75},
	{1822.9833984375,2870.3935546875,10.8359375,0,0,159.05426025391,75},
	{-1473.5791015625,320.2294921875,7.1875,0,0,0,10},
	{-1373.998046875,460.62109375,7.1875,0,0,0,10},
	{419.150390625,2186.087890625,39.499450683594,0,0,0,10},
	{2821.1796875,793.4658203125,10.8984375,0,0,0,10},
	{-809.96484375,2430.037109375,156.97012329102,0,0,0,10},
	{2920.38671875,2486.0087890625,10.8203125,0,0,0,10},
	{2834.732,-233.140,11.70703,0,0,0,10},
	{2318.416,569.6004,7.78021,0,0,0,10},
	{-127.4453125,-779.6923828125,-0.55000001192093,0,0,0,10},
	{-1681.48, -525.8, 14.14, 0, 0, 0, 0},
	{-2542.9931640625, 592.935546875, 14.453125, 0, 0, 0, 267.27673339844},
	{-575.7509765625, -1499.6455078125, 9.6851673126221, 0, 0, 0, 303.91668701172},
	{596.3466796875, -1243.5205078125, 18.132371902466, 0, 0, 0, 202.75302124023},
	{1951.53515625, -2196.583984375, 13.55418586731, 0, 0, 0, 89.592102050781},
	{1297.8974609375, 286.3525390625, 19.546890258789, 0, 0, 0, 337.8649597168},
	{1470.970703125, 973.404296875, 10.8203125, 0, 0, 0, 181.26344299316},
	{1510.142578125, 2104.4873046875, 10.8203125, 0, 0, 0, 272.69305419922},
	{-748.197265625, 1582.1025390625, 26.9609375, 0, 0, 0, 62.625762939453},
}

local vehicles = {468, 471, 598, 422, 542, 404}

-- ustawienia gier
local lootTime = 8 -- czas na lootowanie przed wypuszczeniem gazu  
local startGasRadius = 4500 -- początkowy promień gazu 
local endGasRadius = 100  -- końcowy promień gazu 
local gasTime = 7 -- ile czasu gaz się kurczy 
local maxVehicles = 45 -- ilosc zespawnowanych pojazdow na mapie 

math.randomseed( getRealTime().timestamp )
math.random() math.random() math.random()
	
function createGameVehicles(game)
	local spawned = {} 
	for i=1,maxVehicles do 
		local rand = math.random(1, #vehicleSpawns)
		local x,y,z = vehicleSpawns[rand][1], vehicleSpawns[rand][2], vehicleSpawns[rand][3]
		local rx,ry,rz = vehicleSpawns[rand][5], vehicleSpawns[rand][6], vehicleSpawns[rand][7]
		local model = vehicles[math.random(1, #vehicles)]
		local veh = createVehicle(model, x, y, z+0.25)
		setElementRotation(veh, 0, 0, rz)
		setElementDimension(veh, game)
		--setElementDimension(createBlip(x,y,z, 0), game)
		table.insert(spawned, veh)
	end 
	
	return spawned
end 

function startGame(lobby, players)
	id = id+1
	local gameID = id 
	game[gameID]= {} 
	game[gameID].players = players 
	game[gameID].lobby = lobby 
	game[gameID].vehicles = createGameVehicles(gameID)
	
	exports["br_inventory"]:spawnGameItems(gameID)

	for k,v in ipairs(players) do 
		fadeCamera(v, false, 2)
			
		local timestamp = getRealTime().timestamp 
			
		setTimer(function(player)	
			if isElement(player) then 
			
				fadeCamera(player, true)
					
				setElementData(player, "player:game", {gameID, timestamp+lootTime*60}) -- id gry i czas do wypuszczenia gazu (info do notifikacji :E)
				setElementData(player, "player:items", {})
				setElementData(player, "player:selectedLobby", false)
				setElementData(player, "player:onSpawn", false)
				setElementData(player, "player:helmet", false)
					
				setElementHealth(player, 100)
				setPedArmor(player, 0)
				setElementDimension(player, gameID)
					
				-- spadochron
				giveWeapon(player, 46, 1, true)
					
				-- i tera losowy spawn 
				local spawn = spawns[math.random(1, #spawns)]
				local x,y,z = 0,0,0
				if math.random(1, 2) == 1 then 
					x,y,z = spawn[1]-math.random(math.floor(spawnOffset/4),spawnOffset), spawn[2]-math.random(math.floor(spawnOffset/4),spawnOffset), startHeight
				else 
					x,y,z = spawn[1]+math.random(math.floor(spawnOffset/4),spawnOffset), spawn[2]+math.random(math.floor(spawnOffset/4),spawnOffset), startHeight
				end 
				setElementPosition(player, x, y, z)
					
				-- i lecimy
			end
		end, 2000, 1, v)
	end
	
	setTimer(enableGas, lootTime*60000, 1, gameID)
end 
addEvent("onStartGame", true)
addEventHandler("onStartGame", root, startGame)

function enableGas(id)
	if game[id] then 
		local gGas = gas[math.random(1, #gas)]
		local x,y,z = gGas[1], gGas[2], gGas[3]
		for k,v in ipairs(game[id].players) do 
			if isElement(v) then 
				triggerClientEvent(v, "onClientCreateGas", v, x, y, z, startGasRadius, endGasRadius, gasTime)
			end 
		end
	end
end 

function endGame(id, winner)
	for k,v in ipairs(game[id].vehicles) do 
		destroyElement(v)
	end 
	
	exports["br_inventory"]:deleteGameItems(id)
	triggerEvent("onLobbyChangeState", root, game[id].lobby, "join")
	id = id-1 
	
	if isElement(winner) then 
		
		local points = math.random(5, 10)
		
		outputChatBox(" ", winner)
		outputChatBox(" ", winner)
		outputChatBox(" ", winner)
		outputChatBox(" ", winner)
		outputChatBox("***********************************", winner, 0, 255, 0)
		outputChatBox("Wygrałeś!", winner, 0, 255, 0)
		outputChatBox("Otrzymane punkty: "..tostring(points), winner, 0, 255, 0)
		outputChatBox("***********************************", winner, 0, 255, 0)
	
		local x,y,z = -1812.50, -2104.99, 1132
		fadeCamera(winner, false, 1)
		setTimer(function(player)
			triggerClientEvent(player, "onClientDestroyGas", player)
			fadeCamera(player, true)
			spawnPlayer(player, x,y,z)
			setElementData(player, "player:items", {})
			setElementData(player, "player:onSpawn", true)
			setElementData(player, "player:game", false)
			setElementData(player, "player:helmet", false)
		end, 1000, 1, winner)
	end 
end 

-- rozgrywka 
function onPlayerDamage(attacker, weapon, bodypart, loss) 
	if attacker then 
		if bodypart == 9 then 
			local helmet = getElementData(source, "player:helmet") or false 
			if not helmet then 
				killPed(source)
				setPedHeadless(source, true)
				destroyElement(getElementData(source, "player:helmet"))
				setElementData(source, "player:helmet", false)
			else 
				triggerEvent("onPlayerDestroyHelmet", source)
			end
		end
	end
end 
addEventHandler("onPlayerDamage", root, onPlayerDamage)

function onPlayerWasted(totalAmmo, killer, killerWeapon)
	local playerGame = getElementData(source, "player:game") or false 
	if playerGame and playerGame[1] then 
		local gameID = playerGame[1]
		for k,v in ipairs(game[gameID].players) do 
			if v == source then 
				table.remove(game[gameID].players, k)
			end
		end
		
		if #game[gameID].players <= 1 then 
			endGame(gameID, game[gameID].players[1])
		end 
		
		triggerClientEvent(source, "onClientDestroyGas", source)
	end 
	
	if killer then 
	
	end
	
	local x,y,z = -1812.50, -2104.99, 1132
	fadeCamera(source, false, 1)
	setTimer(function(player)
		fadeCamera(player, true)
		spawnPlayer(player, x,y,z)
		setElementData(player, "player:items", {})
		setElementData(player, "player:onSpawn", true)
		setElementData(player, "player:game", false)
		setPedHeadless(player, false)
	end, 1000, 1, source)
end 
addEventHandler("onPlayerWasted", root, onPlayerWasted)

function onPlayerQuit()
	local playerGame = getElementData(source, "player:game") or false 
	if playerGame and playerGame[1] then 
		local gameID = playerGame[1]
		for k,v in ipairs(game[gameID].players) do 
			if v == source then 
				table.remove(game[gameID].players, k)
			end
		end
		
		if #game[gameID].players <= 1 then 
			endGame(gameID, game[gameID].players[1])
		end 
		
		triggerClientEvent(source, "onClientDestroyGas", source)
	end 
end 
addEventHandler("onPlayerQuit", root, onPlayerQuit)