maxDistance = 3

Async:setPriority("low")

function getActiveItemByType(player, itemType)
	local items = getElementData(player, "player:items") or {} 
	for k,v in ipairs(items) do 
		if v.type == itemType and v.using then 
			return k, v
		end
	end
	
	return false
end 

function stackItem(player, item)
	local hasPlayerItem = hasItemToStack(player, item)
	if hasPlayerItem then 
		local itemsTable = getElementData(player, "player:items")
		local canStack = gItems[getElementData(item, "item:name")].maxAmount 
		if canStack then
			local itemEQAmount = itemsTable[hasPlayerItem].amount -- ilość przedmiotu w EQ
			local itemAmount = getElementData(item, "item:amount") -- ilość przedmiotu który chcemy stackować
			if itemEQAmount+itemAmount <= canStack then -- jeśli zsumowana ilość przedmiotu nie przekracza maksymalnej ilości dla wybranego przedmiotu
				local finalAmount = itemEQAmount+itemAmount
				itemsTable[hasPlayerItem].amount = finalAmount 
				setElementData(player, "player:items", itemsTable) -- stackujemy przedmiot i zapisujemy
				
				return true
			end
		end
	end
	
	return false
end

function hasItemToStack(player, item)
	local items = getElementData(player, "player:items") or {}
	if items then
		for k,v in ipairs(items) do
			local name = v.name
			if getElementData(item, "item:name") == v.name and type(gItems[v.name].maxAmount) == "number" and getElementData(item, "item:amount")+v.amount <= gItems[v.name].maxAmount then -- gracz ma taki sam item w ekwipunku
				return k -- id przedmiotu
			end
		end
	end
end

function takeItem(player)
	local item = getElementData(player, "player:canTakeItem")
	if not isElement(item) then return end 
	
	if item ~= false and getElementType(item) == "object" then
		local x,y,z = getElementPosition(player)
		local x2, y2, z2 = getElementPosition(item)
		local distance = getDistanceBetweenPoints3D( x, y, z, x2, y2, z2 )
		if distance >= maxDistance then return end
		setElementData(player, "player:canTakeItem", false)
		
		local stacked = stackItem(player, item)
		local itemTable = {}
		if not stacked then -- jeśli item nie jest do stackowania, wpisujemy go normalnie do EQ
			local items = getElementData(player, "player:items") or {}
			itemTable = {id=#items+1, name=getElementData(item, "item:name"), amount=getElementData(item, "item:amount"), type=getElementData(item, "item:type"), value1=getElementData(item, "item:value1"), value2=getElementData(item, "item:value2"), using=false, slot=false, quickSlot=false}
			table.insert(items, itemTable)
			setElementData(player, "player:items", items)
		end
		
		if itemTable.id then 
			triggerClientEvent(player, "onClientTakeItem", player, itemTable.id)
		end 
		
		setElementData(item, "item:3dinfo", false)
		destroyElement(getElementData(item, "item:col"))
		destroyElement(item)
	end
end

function hasPlayerItem(player, name)
	local items = getElementData(player, "player:items") or {} 
	for k,v in ipairs(items) do 
		if v.name == name then 
			return true
		end 
	end
	
	return false 
end 

function getWeaponAmmo(item)
	for i, v in pairs(gItems) do 
		if gItems[i].type == 2 and gItems[i].value1 == gItems[item.name].value1 then 
			return i 
		end
	end 
end 

function loadWeaponAmmo(player, item)
	local weaponItemIndex, weaponItemTable = getActiveItemByType(player, 1)
	if not weaponItemIndex then 
		exports["br_notifications"]:addNotification(player, "Nie masz żadnej aktywnej broni.", "error")
		return false
	end 
	
	if item.value1 == weaponItemTable.value1 then -- ta sama broń 
		local magazine = item.value2 
		weaponItemTable.value2 = weaponItemTable.value2+magazine 
		
		local am = weaponItemTable.value2
		setTimer(function(player)
			local items = getElementData(player, "player:items") or {} 
			local weaponItemIndex, weaponItemTable = getActiveItemByType(player, 1)
			items[weaponItemIndex].value2 = am
			setElementData(player, "player:items", items)
		end, 50, 1, player)
		
		
		giveWeapon(player, weaponItemTable.value1, magazine, true)
		reloadPedWeapon(player)
		return true
	else 
		exports["br_notifications"]:addNotification(player, "Ten magazynek nie pasuje do aktywnej broni.", "error")
		return false 
	end 
end 

function givePlayerWeapon(player, item)
	if item.using then 
		--disableItemsByType(player, 1)
		
		local items = getElementData(player, "player:items") or {} 
		local weaponID = item.value1
		local ammo = item.value2
		if ammo == 0 then
			return 
		end 
		
		setTimer(giveWeapon, 50, 1, player, weaponID, ammo, true)
	else 
		local weaponID = gItems[item.name].value1
		takeWeapon(player, weaponID)
	end
end 

function useHelmet(player, bool)
	if bool then 
		local x,y,z = getElementPosition(player)
		local helmet = createObject(3092, x, y, z)
		setElementDimension(helmet, getElementDimension(player))
		setElementData(player, "player:helmet", helmet)
		exports.bone_attach:attachElementToBone(helmet, player, 1, 0, 0.04, 0.05, 0, 0, 90)
	else 
		local helmet = getElementData(player, "player:helmet") or false 
		if isElement(helmet) then 
			exports.bone_attach:detachElementFromBone(helmet)
			destroyElement(helmet)
			setElementData(player, "player:helmet", false)
		end
	end
end 
addEventHandler("onPlayerQuit", root, function() local helmet = getElementData(source, "player:helmet") if isElement(helmet) then exports.bone_attach:detachElementFromBone(helmet) destroyElement(helmet) end end)

function onPlayerDestroyHelmet()
	local player = source 
	
	local helmet = getElementData(player, "player:helmet")
	if isElement(helmet) then 
		local items = getElementData(player, "player:items") or {} 
		for k,v in ipairs(items) do 
			if v.type == 5 and v.using then 
				table.remove(items, k)
			end
		end 
		setElementData(player, "player:items", items)
		
		exports.bone_attach:detachElementFromBone(helmet)
		destroyElement(helmet)
		setElementData(player, "player:helmet", false)
	end
end 
addEvent("onPlayerDestroyHelmet", true)
addEventHandler("onPlayerDestroyHelmet", root, onPlayerDestroyHelmet)

-- kurwa jebany spawn. Nie chce mi sie calej tabeli itemow przepisywac. Losowosc kurwa pozdro
-- serverproject procesory 14nm sobie poradzi 
local function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

local function tablegetkey(tbl, key)
	local i = 0 
	for name, v in pairs(tbl) do 
		i = i+1 
		if i == key then 
			return name 
		end 
	end 
end 

function getRandomItem() 
	local rand = math.random(1, tablelength(gItems))
	local itemName = tablegetkey(gItems, rand)
	return itemName
end

function getRandomItemByType(type)
	local name = false 
	repeat 
		local itemName = getRandomItem() 
		if gItems[itemName].type == type and itemName ~= "AK-47" and itemName ~= "Sniper Rifle" then 
			name = itemName
		end 
	until name ~= false 
	
	return name 
end 

function spawnGameItems(game)
	if not game then return end 
	
	local game = game 
	Async:foreach(itemSpawns, function(item)
		for i=1,3 do 
			--[[
			itemName = getRandomItem()
			if itemName == "AK-47" then 
				if math.random(1, 100) >= 85 then -- 15% szans na wypadniecie AK-47 
				else  
					itemName = getRandomItem() -- no jesli 2x jest to niech juz wypada 
				end
			elseif itemName == "Sniper Rifle" then 
				if math.random(1, 100) >= 95 then 
				else 
					itemName= getRandomItem() 
				end 
			end
			-- ]] 
			
			local itemName = false
			local rand = math.random(1, 100)
			-- 77% szans na loot 
			if rand > 95 then -- helm 5%
				itemName = getRandomItemByType(5)
			elseif rand > 85 and rand <= 90 then -- armor 5%
				itemName = getRandomItemByType(4)
			elseif rand > 78 and rand <= 85 then -- leki 7%
				itemName = getRandomItemByType(3)
			elseif rand > 25 and rand <= 60 then -- ammo 30%
				itemName = getRandomItemByType(2)
			elseif rand > 0 and rand <= 30 then -- bronie 30%
				local rand2 = math.random(1, 100) 
				if rand2 >= 97 then -- 3% na Snajperke, 7% na AK-47, 85% na reszte
					itemName = "Sniper Rifle"
				elseif rand2 >= 93 then 
					itemName = "AK-47"
				else 
					itemName = getRandomItemByType(1)
				end
			end 
			
			if itemName then 
				CItem(itemName, 1, item[1]+(math.random(-1,1)/2)*i/2.5, item[2]+(math.random(-1,1)/2)*i/2.5, item[3]-0.85, nil, nil, game)
			end
		end
	end)
	
end 

function deleteGameItems(game)
	if not game then return end
	
	local game = game 
	Async:foreach(getElementsByType("colshape"), function(colshape)
		local colItem = getElementData(colshape, "col:item")
		if colItem and getElementDimension(colshape) == game then 
			if isElement(colItem) then destroyElement(colItem) end 
			destroyElement(colshape)
		end
	end)
end 

function onPlayerUseItem(itemIndex)
	local items = getElementData(source, "player:items") or {} 
	local item = items[itemIndex]
	if item then 
		local removeItem = false 
		if item.type == 1 then  
			item.using = not item.using
			givePlayerWeapon(source, item)
		elseif item.type == 2 then 
			local set = loadWeaponAmmo(source, item)
			if set then 
				if item.amount <= 1 then removeItem = true end 
				item.amount = item.amount-1
			end
		elseif item.type == 3 then 
			local hp = item.value1 
			setElementHealth(source, getElementHealth(source)+hp)
			
			item.amount = item.amount-1 
			if item.amount <= 0 then removeItem = true end
		elseif item.type == 4 then 
			setPedArmor(source, getPedArmor(source)+20)
			
			item.amount = item.amount-1 
			if item.amount <= 0 then removeItem = true end
		elseif item.type == 5 then 
			item.using = not item.using
			useHelmet(source, item.using)
		end
		
		if removeItem then 
			table.remove(items, itemIndex)
		else 
			items[itemIndex] = item
		end 
		
		setElementData(source, "player:items", items)
	end 
end 
addEvent("onPlayerUseItem", true)
addEventHandler("onPlayerUseItem", root, onPlayerUseItem)

function onPlayerDropItem(itemIndex, x, y, z)
	local items = getElementData(source, "player:items") or {} 
	local item = items[itemIndex]
	if item then 
		item.amount = item.amount-1 
		CItem(item.name, 1, x, y, z, item.value1, item.value2, getElementDimension(client))
		
		if item.amount <= 0 then 
			table.remove(items, itemIndex)
		end 
		
		setElementData(source, "player:items", items)
	end
end 
addEvent("onPlayerDropItem", true)
addEventHandler("onPlayerDropItem", root, onPlayerDropItem)

for k,v in ipairs(getElementsByType("player")) do
	if not isKeyBound(v, "k", "down", takeItem) then
		bindKey(v, "k", "down", takeItem)
	end
end
addEventHandler("onPlayerJoin", root,
	function()
		bindKey(source, "k", "down", takeItem)
	end
)

class "CItem"
{
	__init__ = function(self, name, amount, x, y, z, value1, value2, dimension)
		if gItems[name] then
			self.name = name
			self.type = gItems[name].type
			self.amount = amount
			self.weight = gItems[name].weight
			self.objectID = gItems[name].objectID
			self.itemImage = gItems[name].itemImage
			
			local rx, ry, rz = gItems[name].rx, gItems[name].ry, gItems[name].rz
			self.object = createObject(self.objectID, x, y, z, rx, ry, rz+math.random(0,360), false)
			setObjectScale(self.object, 0.8)
			if not isElement(self.object) then return end 
			
			setElementDimension(self.object, dimension or 0)
			
			setElementData(self.object, "item", true)
			setElementData(self.object, "item:name", self.name)
			setElementData(self.object, "item:type", self.type)
			setElementData(self.object, "item:amount", self.amount)
			setElementData(self.object, "item:weight", self.weight)
			setElementData(self.object, "item:itemImage", self.itemImage)
			setElementData(self.object, "item:3dinfo", true)
			setElementData(self.object, "item:value1", value1 or gItems[self.name].value1 or 0)
			setElementData(self.object, "item:value2", value2 or gItems[self.name].value2 or 0)
			
			self.collision = createColSphere(x, y, z+0.9, 0.675)
			setElementDimension(self.collision, dimension or 0)
			--[[
			addEventHandler("onColShapeHit", self.collision, function(hitElement, matchingDimension)
				if getElementType(hitElement) == "player" and matchingDimension then 
					setElementData(hitElement, "player:canTakeItem", getElementData(source, "col:item"))
				end
			end) 
			
			addEventHandler("onColShapeLeave", self.collision, function(hitElement, matchingDimension)
					if getElementType(hitElement) == "player" and matchingDimension then
						setElementData(hitElement, "player:canTakeItem", false)
				end
			end)
			--]] 
			
			setElementData(self.object, "item:col", self.collision)
			setElementData(self.collision, "col:item", self.object)
		else
			outputDebugString("Nie stworzono itema "..name.." bo nie istnieje", 3)
			return 
		end
	end,
}

--setTimer(collectgarbage, 10000, 0)