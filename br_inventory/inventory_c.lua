local screenW, screenH = guiGetScreenSize() 
local sx, sy = (screenW/1366), (screenH/768)

function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function translate(text)
	if not text then return "nil" end 
	
	local translated = exports["br_localization"]:getText(localPlayer, "eq-"..text)
	if translated == "false" then 
		return text 
	else
		return translated 
	end 
end 

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

class "CInventory"
{
	__init__ = function(self)
		self.font = dxCreateFont(":br_font/roboto.ttf", 45*sx, false, "antialiased")
		self.font2 = dxCreateFont(":br_font/roboto.ttf", 20*sx, false, "antialiased")
		
		-- sloty dla itemów w ekwipunku
		self:makeSlots(20)
		
		-- szybki wybór
		self.quickSlots = {}
		self.quickSlotW, self.quickSlotH = 60, 60
		
		local offset = 5 
		local sx,sy = 392, 688+offset
		for i=1,9 do
			sx = 392 + (self.quickSlotW+offset)*(i-1)
			sx = sx+offset
			
			local t = {x=sx, y=sy, w=self.quickSlotW, h=self.quickSlotH, item=false}
			table.insert(self.quickSlots, t)
		end
		
		self.showing = false 
		
		-- przenoszenie itemów 
		self.movingItem = false 
		self.movingItemType = false -- skąd przenosimy przedmiot (szybki wybór / eq)
		self.mouseOnSlot = false -- na jakim slocie jest myszka 
		self.mouseOnQuickSlot = false 
		
		-- menu kontekstowe 
		self.contextMenu = false 
		self.contextMenuOptions = 
		{
			translate("Użyj"),
			translate("Wyrzuć"),
		}
		
		self.renderFunc = function() self:onRender() end 
		self.renderQuickFunc = function() self:onRenderQuickSlots() end 
		addEventHandler("onClientRender", root, self.renderQuickFunc)
		
		self.keyFunc = function(a, b) self:onKey(a, b) end 
		addEventHandler("onClientKey", root, self.keyFunc)
		
		self.moveItemDelay = 0 
		self.doubleClickFunc = function(a, b, c) self:onDoubleClick(a, b, c) end 
		addEventHandler("onClientDoubleClick", root, self.doubleClickFunc)
	end,
	
	toggle = function(self)
		if self.showing then 
			self:destroy() 
		else 
			self:show()
		end 
	end,
	
	show = function(self)
		self.showing = true 
		addEventHandler("onClientRender", root, self.renderFunc)
		removeEventHandler("onClientRender", root, self.renderQuickFunc)
		showCursor(true)
		setSoundVolume(playSound("sounds/inv_open.ogg"), 0.8)
	end, 
	
	destroy = function(self)
		self.showing = false 
		removeEventHandler("onClientRender", root, self.renderFunc)
		addEventHandler("onClientRender", root, self.renderQuickFunc)
		showCursor(false)
		setSoundVolume(playSound("sounds/inv_close.ogg"), 0.8)
	end,
	
	makeSlots = function(self, slots)
		if not slots then return end 
		
		self.slots = {}
		self.slotW,self.slotH = 80, 80
		self.maxSlots = slots
		self.slotsPerColumn = 4
		self.slotColumns = 0

		local sx,sy = 985, 220
		local slotColumn = 0
		local parsedSlots = 0
		local offset = 5 
		for i=1,self.maxSlots do
			parsedSlots = parsedSlots+1

			if i == 1 then
				self.slotColumns = 1
				-- local t = {pozycjaX, pozycjaY, długość, szerokość, item w slocie, kolumna(rząd? Jeden chuj), czy slot jest ostatni w kolumnie(albo rzędzie? Jeden chuj), czy item na slocie jest używany
				local t = {x=sx, y=sy, w=self.slotW, h=self.slotH, item=false, column=self.slotColumns, lastItem=false, used=false}
				table.insert(self.slots, t)
			elseif i > 1 then
				self.slots[i-1].x = sx+offset
				self.slots[i-1].y = sy+offset
				sx = sx + self.slotW + offset
				if parsedSlots > self.slotsPerColumn then
					parsedSlots = 1

					sx = 985
					sy = sy + self.slotH + offset
					self.slotColumns = self.slotColumns + 1
					self.slots[i-1].lastItem = true
				end

				if i == self.maxSlots then 
					sx = sx+offset 
					sy = sy+offset
				end 
				
				local t = {x=sx, y=sy, w=self.slotW, h=self.slotH, item=false, column=self.slotColumns, lastItem=false}
				table.insert(self.slots, t)
			end
		end 
	end, 
	
	resetSlots = function(self, quickSlotsOnly)
		if not quickSlotsOnly then 
			for k,v in ipairs(self.slots) do 
				self.slots[k].item = false
			end 
		end
		
		for k,v in ipairs(self.quickSlots) do 
			self.quickSlots[k].item = false
		end
	end, 
	
	useItem = function(self, item)
		local items = getElementData(localPlayer, "player:items") or {} 
		local itemTable = items[item]
		if not itemTable or self.timer then return end 
		
		disableItemsByType(item, itemTable.type)
		
		local time = gItems[itemTable.name].usingTime 
		if time == 0 or itemTable.using == true then 
			triggerServerEvent("onPlayerUseItem", localPlayer, item)
		else 
			self.timer = getTickCount()+time*1000 
			self.timerItem = itemTable.name
			self.timerTime = time*1000
			setTimer(triggerServerEvent, time*1000, 1, "onPlayerUseItem", localPlayer, item)
		end
	end, 
	
	dropItem = function(self, item)
		local items = getElementData(localPlayer, "player:items") or {} 
		local itemTable = items[item]
		if not itemTable or self.timer then return end 
		
		local x,y,z = getPositionFromElementOffset(localPlayer, 0, 1, 0)
		z = getGroundPosition(x, y, z)+0.05
		
		if itemTable.slot then self.slots[itemTable.slot].item = false end
		if itemTable.quickSlot then self.quickSlots[itemTable.quickSlot].item = false end
		if itemTable.using then triggerServerEvent("onPlayerUseItem", localPlayer, item) end 
		
		setTimer(triggerServerEvent, 50, 1, "onPlayerDropItem", localPlayer, item, x, y, z)
		
		setSoundVolume(playSound("sounds/inv_drop.ogg"), 0.8)
	end,
	
	takeItem = function(self, item)
		local items = getElementData(localPlayer, "player:items") or {} 
		if not items[item] then return end 
		
		if #items > self.maxSlots then 
			exports["br_notifications"]:addNotification("Nie masz więcej miejsca w ekwipunku!", "error")
			self:dropItem(item)
			return 
		end
		
		for k,v in ipairs(self.slots) do 
			if not v.item then 
				self.slots[k].item = item
				items[item].slot = k 
				setElementData(localPlayer, "player:items", items)
				setSoundVolume(playSound("sounds/inv_get.ogg"), 0.8)
				return 
			end
		end
	end, 
	
	onDoubleClick = function(self, key, x, y)
		if key == "left" then 
			if self.mouseOnSlot then
				local slot = self.slots[self.mouseOnSlot]
				if isCursorOnElement(slot.x*sx, slot.y*sy, slot.w*sx, slot.h*sy) then 
					self:useItem(slot.item)
				end
			elseif self.mouseOnQuickSlot then 
				local slot = self.quickSlots[self.mouseOnQuickSlot]
				if isCursorOnElement(slot.x*sx, slot.y*sy, slot.w*sx, slot.h*sy) then 
					self:useItem(slot.item)
				end
			end
		end
	end, 
	
	onKey = function(self, key, press)
		if isChatBoxInputActive() then return end 
		
		if key == "1" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "2" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "3" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "4" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "5" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "6" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "7" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "8" and press then 
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "9" and press then
			self:useItem(self.quickSlots[tonumber(key)].item)
		elseif key == "mouse1" and press then 
			self.moveItemDelay = getTickCount()+100
		end 
	end, 
	
	onRenderQuickSlots = function(self) -- renderuje quick sloty nie w trybie edycji 
		if not getElementData(localPlayer, "player:spawned") then return end 
		if isPlayerMapVisible() then return end 
		
		local items = getElementData(localPlayer, "player:items") or {} 

		dxDrawRectangle(392*sx, 686*sy, 590*sx, 73*sy, tocolor(0, 0, 0, 175), false)
		dxDrawLine(392*sx, 687*sy, 981*sx, 687*sy, tocolor(137, 0, 0, 235), 2*sx, false)
		self:resetSlots(true)
		for k,v in ipairs(items) do -- update slotów
			if v.quickSlot then 
				self.quickSlots[v.quickSlot].item = k
			end
		end 
		
		for k,v in ipairs(self.quickSlots) do 
			local item = items[v.item]
			if item and item.using then 
				dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(100, 0, 0, 200), false)
			else 
				dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(68, 68, 68, 165), false)
			end 
			
			if item then 
				local img = gItems[item.name].itemImage
				dxDrawImage(v.x*sx, v.y*sy, v.w*sx, v.h*sy, img)
					
				if item.type == 1 then -- broń
					local amount = item.value2
					dxDrawText(tostring(amount), v.x*sx, (v.y+self.quickSlotH-16)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 255), 0.5, self.font2, "left", "top", false, false, false, false, false)
				else 
					local amount = item.amount
					if amount ~= 1 then dxDrawText(tostring(amount).."x", v.x*sx, (v.y+self.quickSlotH-16)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 255), 0.5, self.font2, "left", "top", false, false, false, false, false) end 
				end 
			else 
				v.item = false 
			end
			
			dxDrawText(tostring(k), (v.x+self.quickSlotW-11)*sx, (v.y+self.quickSlotH-18)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 125), 0.5, self.font2, "left", "top", false, false, false, false, false)
		end 
		
		-- timer
		if self.timer then 
			local now = getTickCount()
			local spent = round((self.timer-now)/1000, 1)
			
			dxDrawRectangle(493*sx, 630*sy, 381*sx, 42*sy, tocolor(0, 0, 0, 175), false)
			dxDrawRectangle(501*sx, 636*sy, (365 * ((self.timer-now)/self.timerTime))*sx, 30*sy, tocolor(137, 0, 0, 199), false)
			dxDrawText("Używanie "..self.timerItem.." ("..tostring(spent).."s)", 502*sx, 637*sy, 865*sx, 661*sy, tocolor(255, 255, 255, 255), 0.3, self.font, "center", "center", false, false, false, false, false)
			
			if now > self.timer then 
				self.timer = false 
				self.timerItem = false
				self.timerTime = false
			end
		end 
	end, 
	
	onRender = function(self)
		local now = getTickCount()
		
		dxDrawRectangle(983*sx, 214*sy, 350*sx, (self.slotColumns*90)*sy, tocolor(0, 0, 0, 175), false)
        dxDrawText("Ekwipunek", (983 + 1)*sx, (170 + 1)*sy, (608 + 1)*sx, (238 + 1)*sy, tocolor(0, 0, 0, 255), 0.55, self.font, "left", "top", false, false, false, false, false)
        dxDrawText("Ekwipunek", 983*sx, 170*sy, 608*sx, 238*sy, tocolor(255, 255, 255, 255), 0.55, self.font, "left", "top", false, false, false, false, false)
        dxDrawLine(983*sx, 214*sy, 1333*sx, 214*sy, tocolor(137, 0, 0, 235), 4*sx, false)
        
		local items = getElementData(localPlayer, "player:items") or {} 
		self:resetSlots()
		for k,v in ipairs(items) do -- update slotów
			if v.slot then 
				self.slots[v.slot].item = k
			end
			
			if v.quickSlot then 
				self.quickSlots[v.quickSlot].item = k
			end
		end 
		
		self.mouseOnSlot = false 
		for k,v in ipairs(self.slots) do
			local item = items[v.item]
			if isCursorOnElement(v.x*sx, v.y*sy, v.w*sx, v.h*sy) and not self.contextMenu then 
				if not self.movingItem and item and (not self.contextMenu or self.contextMenu ~= k) then -- nazwa przedmiotu
					local cX, cY = getCursorPosition()
					cX, cY = cX*screenW, cY*screenH
					
					local width = dxGetTextWidth(translate(item.name), 1, "default-bold")
					dxDrawRectangle(cX, cY+12, width, 17, tocolor(0, 0, 0, 150), true)
					dxDrawText(translate(item.name), cX, cY+12, cX, cY, tocolor(200, 200, 200, 255), 1, "default-bold", "left", "top", false, false, true)
				end 
				
				dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(137, 0, 0, 200), false)
				self.mouseOnSlot = k 
				if item and getKeyState("mouse1") and not self.movingItem and now >= self.moveItemDelay then 
					self.movingItem = v.item
					self.movingItemType = "eq"
				end
			else 
				if item and item.quickSlot then 
					dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(0, 100, 0, 200), false)
				elseif item and item.using then 
					dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(100, 0, 0, 200), false)
				else 
					dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(68, 68, 68, 165), false)
				end
			end
			
			if item then 
				if item.quickSlot ~= false then 
					dxDrawText(tostring(item.quickSlot), (v.x+self.slotW-11)*sx, (v.y+self.slotH-18)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 125), 0.5, self.font2, "left", "top", false, false, false, false, false)
				end 
				
				local img = gItems[item.name].itemImage
				dxDrawImage(v.x*sx, v.y*sy, v.w*sx, v.h*sy, img)
					
				if item.type == 1 then -- broń i ammo
					local amount = item.value2
					dxDrawText(tostring(amount), v.x*sx, (v.y+self.slotH-20)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 255), 0.275, self.font, "left", "top", false, false, false, false, false)
				else 
					local amount = item.amount
					if amount ~= 1 then dxDrawText(tostring(amount).."x", v.x*sx, (v.y+self.slotH-20)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 255), 0.275, self.font, "left", "top", false, false, false, false, false) end 
				end 
			else 
				v.item = false 
			end 
		end
		
		dxDrawRectangle(392*sx, 686*sy, 590*sx, 73*sy, tocolor(0, 0, 0, 175), false)
		dxDrawLine(392*sx, 687*sy, 981*sx, 687*sy, tocolor(137, 0, 0, 235), 2*sx, false)
		
		self.mouseOnQuickSlot = false
		for k,v in ipairs(self.quickSlots) do 
			local item = items[v.item]
			if isCursorOnElement(v.x*sx, v.y*sy, v.w*sx, v.h*sy) then 
				dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(137, 0, 0, 200), false)
				self.mouseOnQuickSlot = k
				if item and getKeyState("mouse1") and not self.movingItem and now >= self.moveItemDelay then 
					self.movingItem = v.item
					self.movingItemType = "quick"
				end
			else 
				if item and item.using then 
					dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(100, 0, 0, 200), false)
				else 
					dxDrawRectangle(v.x*sx, v.y*sy, v.w*sx, v.h*sy, tocolor(68, 68, 68, 165), false)
				end
			end 
			
			if item then 
				local img = gItems[item.name].itemImage
				dxDrawImage(v.x*sx, v.y*sy, v.w*sx, v.h*sy, img)
					
				if item.type == 1 then -- broń
					local amount = item.value2
					dxDrawText(tostring(amount), v.x*sx, (v.y+self.quickSlotH-16)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 255), 0.5, self.font2, "left", "top", false, false, false, false, false)
				else 
					local amount = item.amount
					if amount ~= 1 then dxDrawText(tostring(amount).."x", v.x*sx, (v.y+self.quickSlotH-16)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 255), 0.5, self.font2, "left", "top", false, false, false, false, false) end 
				end 
			else 
				v.item = false 
			end
			
			dxDrawText(tostring(k), (v.x+self.quickSlotW-11)*sx, (v.y+self.quickSlotH-18)*sy, v.w*sx, v.h*sy, tocolor(255, 255, 255, 125), 0.5, self.font2, "left", "top", false, false, false, false, false)
		end 
		
		-- gracz porusza itemem
		if self.movingItem then 
			-- rysujemy graficzke
			local cX, cY = getCursorPosition()
			cX, cY = cX*screenW, cY*screenH
			
			local item = items[self.movingItem]
			if not item then self.movingItem = false return end
			
			local img = gItems[item.name].itemImage
			dxDrawImage(cX, cY-40*sy, self.slotW*sx, self.slotH*sy, img)
			if not getKeyState("mouse1") then -- upuszczanie itema 
				if self.mouseOnSlot then 
					if (self.movingItem == self.slots[self.mouseOnSlot].item) or (self.slots[self.mouseOnSlot].item == false) then -- slot jest wolny 
						if item.quickSlot and self.movingItemType == "quick" then 
							self.quickSlots[item.quickSlot].item = false 
							items[self.movingItem].quickSlot = false
						end 
						
						self.slots[item.slot].item = false 
						self.slots[self.mouseOnSlot].item = self.movingItem
						items[self.movingItem].slot = self.mouseOnSlot
						setElementData(localPlayer, "player:items", items)
						setSoundVolume(playSound("sounds/inv_slot.ogg"), 0.8)
					end  
				elseif self.mouseOnQuickSlot then 
					if self.quickSlots[self.mouseOnQuickSlot].item == false then 
						self.quickSlots[self.mouseOnQuickSlot].item = self.movingItem
						items[self.movingItem].quickSlot = self.mouseOnQuickSlot
						--items[self.movingItem].slot = false 
						setElementData(localPlayer, "player:items", items)
						setSoundVolume(playSound("sounds/inv_slot.ogg"), 0.8)
					end
				else 
					-- gracz chce wyrzucić item
					if not isCursorOnElement(983*sx, 214*sy, 350*sx, (self.slotColumns*90)*sy) and not isCursorOnElement(392*sx, 686*sy, 590*sx, 73*sy) then 
						self:dropItem(self.movingItem)
					end
				end 
				
				self.movingItem = false 
				self.movingItemType = false 
			end 
		end 
		
		
		-- tekst o wyrzucaniu
		if self.movingItem and not isCursorOnElement(983*sx, 214*sy, 350*sx, (self.slotColumns*90)*sy) and not isCursorOnElement(392*sx, 686*sy, 590*sx, 73*sy) then 
			local cX, cY = getCursorPosition()
			cX, cY = cX*screenW, cY*screenH
			
			dxDrawText("WYRZUĆ", cX+13*sx, cY+76*sy, cX, cY, tocolor(0, 0, 0, 255), 0.5, self.font2, "left", "top", false, false, true)
			dxDrawText("WYRZUĆ", cX+12*sx, cY+75*sy, cX, cY, tocolor(200, 200, 200, 255), 0.5, self.font2, "left", "top", false, false, true)
		end
		
		-- menu kontekstowe 
		if getKeyState("mouse2") and self.mouseOnSlot then 
			if self.slots[self.mouseOnSlot].item then 
				self.contextMenu = self.mouseOnSlot
			end
		end 
		
		if self.contextMenu then 
			local selectedOption = 1 
			local slot = self.slots[self.contextMenu]
			dxDrawRectangle((slot.x+30)*sx, ((slot.y+slot.h/2.05))*sy, 75*sx, ((40*(#self.contextMenuOptions-1)))*sy, tocolor(0, 0, 0, 200))
			dxDrawRectangle((slot.x+30)*sx, (slot.y+slot.h/2.15)*sy, 75*sx, 2*sy, tocolor(150, 0, 0, 200))
			for k,v in ipairs(self.contextMenuOptions) do 
				if isCursorOnElement((slot.x+50)*sx, ((slot.y+slot.h/2)+(20*(k-1)))*sy, 40*sx, 15*sy) then 
					dxDrawText(v, (slot.x+50)*sx, ((slot.y+slot.h/2)+(20*(k-1)))*sy, (5+slot.x+slot.w)*sx, slot.h*sy, tocolor(180, 0, 0, 255), 0.5, self.font2, "center")
					if getKeyState("mouse1") then 
						if k == 1 then 
							self:useItem(slot.item)
						elseif k == 2 then 
							self:dropItem(slot.item)
						end
					end 
				else 
					dxDrawText(v, (slot.x+50)*sx, ((slot.y+slot.h/2)+(20*(k-1)))*sy, (5+slot.x+slot.w)*sx, slot.h*sy, tocolor(255, 255, 255, 255), 0.5, self.font2, "center")
				end
			end 
			
			if getKeyState("mouse1") then 
				self.contextMenu = false 
			end 
		end 
		
		-- timer
		if self.timer then 
			local spent = round((self.timer-now)/1000, 1)
			
			dxDrawRectangle(493*sx, 630*sy, 381*sx, 42*sy, tocolor(0, 0, 0, 175), false)
			dxDrawRectangle(501*sx, 636*sy, 365*sx * ((self.timer-now)/self.timerTime), 30*sx, tocolor(137, 0, 0, 199), false)
			dxDrawText("Używanie "..self.timerItem.." ("..tostring(spent).."s)", 502*sx, 637*sy, 865*sx, 661*sy, tocolor(255, 255, 255, 255), 0.3, self.font, "center", "center", false, false, false, false, false)
			
			if now > self.timer then 
				self.timer = false 
				self.timerItem = false
				self.timerTime = false
			end
		end 
	end,
}

inventoryInstance = CInventory()
bindKey("i", "down", function() inventoryInstance:toggle() end)

addEvent("onClientTakeItem", true)
addEventHandler("onClientTakeItem", root, 
	function(item)
		inventoryInstance:takeItem(item)
	end 
)

local items = getElementData(localPlayer, "player:items") or {} 
for k,v in ipairs(items) do 
	-- na quicksloty jeszcze ustawic 
	inventoryInstance:takeItem(k)
end

-- strzelanie z broni 
function getActiveItemByType(player, itemType)
	local items = getElementData(player, "player:items") or {} 
	for k,v in ipairs(items) do 
		if v.type == itemType and v.using then 
			return k, v
		end
	end
	
	return false
end 

function disableItemsByType(itemIndex, itemType)
	local items = getElementData(localPlayer, "player:items") or {} 
	for k,v in ipairs(items) do 
		if itemIndex ~= k and v.type == itemType and v.using then
			triggerServerEvent("onPlayerUseItem", localPlayer, k)
		end
	end
end 


function onClientPedWeaponFire(weapon, ammo, ammoInClip)
	local weaponIndex, weaponItem = getActiveItemByType(localPlayer, 1)
	if not weaponItem then return end 
	
	if weaponItem.value1 == weapon then 
		weaponItem.value2 = weaponItem.value2-1 
	end
	
	local items = getElementData(localPlayer, "player:items") or {}
	items[weaponIndex] = weaponItem
	setElementData(localPlayer, "player:items", items)
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, onClientPedWeaponFire)
