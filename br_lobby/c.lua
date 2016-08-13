local sw, sh = guiGetScreenSize()
local sx, sy = (sw/1366), (sh/768)

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

class "CLobbyManager"
{
	__init__ = function(self)
		self.lobbies = {} 
		self.showing = false 
		
		self.states = {
			["join"] = "#7AAFFFZAPISY",
			["starting"] = "#FF9900STARTUJE",
			["playing"] = "#00CCFFW GRZE",
		}
		
		self.selectedLobby = -1 
		
		self.renderFunc = function() self:onRender() end 
		self.keyFunc = function(a, b) self:onKey(a, b) end 
	end, 
	
	toggle = function(self)
		if self.showing then 
			removeEventHandler("onClientRender", root, self.renderFunc)
			removeEventHandler("onClientKey", root, self.keyFunc)
			self.showing = false
			showCursor(false)
			destroyElement(self.font)
		else 
			if not getElementData(localPlayer, "player:onSpawn") then return end 
			
			self.font = dxCreateFont(":br_font/roboto.ttf", 30*sx)
			addEventHandler("onClientRender", root, self.renderFunc)
			addEventHandler("onClientKey", root, self.keyFunc)
			self.showing = true 
			showCursor(true)
		end
	end, 
	
	joinLobby = function(self, lobby)
		if not self.lobbies[lobby] then return end 
		table.insert(self.lobbies[lobby].players, localPlayer)
		if self.lobbies[lobby].maxPlayers < #self.lobbies[lobby].players then 
			exports["br_notifications"]:addNotification("Ta poczekalnia jest już pełna.", "error")
			return 
		end 
		
		if self.lobbies[lobby].state == "playing" then 
			exports["br_notifications"]:addNotification("Ta poczekalnia jest już w trakcie gry.", "error")
			return 
		end 
		
		local previousLobby = getElementData(localPlayer, "player:selectedLobby")
		if previousLobby then 
			if self.lobbies[previousLobby] then 
				for k,v in ipairs(self.lobbies[previousLobby].players) do 
					if v == localPlayer then 
						table.remove(self.lobbies[previousLobby].players, k)
					end
				end
			end
		end 
		setElementData(resourceRoot, "root:lobbies", self.lobbies)
		
		if #self.lobbies[lobby].players >= self.lobbies[lobby].maxPlayers and self.lobbies[lobby].state == "join" then 
			triggerServerEvent("onLobbyChangeState", root, lobby, "starting")
		end 
		
		setElementData(localPlayer, "player:selectedLobby", lobby)
		exports["br_notifications"]:addNotification("Dołączyłeś do poczekalni pomyślnie.", "success")
	end, 
	
	exitLobby = function(self)
		local previousLobby = getElementData(localPlayer, "player:selectedLobby")
		if previousLobby then 
			if self.lobbies[previousLobby] then 
				for k,v in ipairs(self.lobbies[previousLobby].players) do 
					if v == localPlayer then 
						table.remove(self.lobbies[previousLobby].players, k)
					end
				end
			end
		end 
		setElementData(resourceRoot, "root:lobbies", self.lobbies)
		
		setElementData(localPlayer, "player:selectedLobby", false)
		
		exports["br_notifications"]:addNotification("Opuściłeś poczekalnię pomyślnie.", "success")
	end, 
	
	onKey = function(self, key, press)
		if key == "mouse1" and press then
			if isCursorOnElement(475*sx, 489*sy, 132*sx, 29*sy) then 
				if self.selectedLobby then 
					self:joinLobby(self.selectedLobby)
				else 
					exports["br_notifications"]:addNotification("Musisz wybrać poczekalnie by do niej dołączyć.", "error")
				end 
			end
			
			if isCursorOnElement(760*sx, 489*sy, 132*sx, 29*sy) and getElementData(localPlayer, "player:selectedLobby") then
				self:exitLobby()
			end
			
			if self.selectedLobby then 
				if not isCursorOnElement(492*sx, (256+30*(self.selectedLobby-1))*sy, 400*sx, 25*sy) then 
					self.selectedLobby = false 
				end
			end 
		end
	end, 
	
	onRender = function(self)
		self.lobbies = getElementData(resourceRoot, "root:lobbies") or {}
		
		dxDrawRectangle(466*sx, 220*sy, 435*sx, 314*sy, tocolor(0, 0, 0, 215), false)
        dxDrawText("Poczekalnie", (464 + 1)*sx, (168 + 1)*sy, (699 + 1)*sx, (221 + 1)*sy, tocolor(0, 0, 0, 255), 1.00, self.font, "left", "top", false, false, false, false, false)
        dxDrawText("Poczekalnie", 464*sx, 168*sy, 699*sx, 221*sy, tocolor(255, 255, 255, 255), 1.00, self.font, "left", "top", false, false, false, false, false)
        dxDrawRectangle(466*sx, 220*sy, 435*sx, 5*sy, tocolor(155, 0, 0, 254), false)
        dxDrawRectangle(477*sx, 243*sy, 415*sx, 227*sy, tocolor(30, 30, 30, 142), false)
		for k,v in ipairs(self.lobbies) do
			if k == getElementData(localPlayer, "player:selectedLobby") then 
				dxDrawText(v.name, 492*sx, (256+30*(k-1))*sy, 637*sx, 282*sy, tocolor(51, 153, 255, 255), 0.50, self.font, "left", "top", false, false, false, false, false)
				dxDrawText(self.states[v.state]:gsub( '#%x%x%x%x%x%x', '' ), 573*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(51, 153, 255, 255), 0.50, self.font, "center", "top", false, false, false, true, false)
				dxDrawText(tostring(#v.players).."/"..tostring(v.maxPlayers), 793*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(51, 153, 255, 255), 0.50, self.font, "center", "top", false, false, false, false, false)
			elseif self.selectedLobby == k then 
				dxDrawText(v.name, 492*sx, (256+30*(k-1))*sy, 637*sx, 282*sy, tocolor(0, 160, 0, 255), 0.50, self.font, "left", "top", false, false, false, false, false)
				dxDrawText(self.states[v.state]:gsub( '#%x%x%x%x%x%x', '' ), 573*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(0, 160, 0, 255), 0.50, self.font, "center", "top", false, false, false, true, false)
				dxDrawText(tostring(#v.players).."/"..tostring(v.maxPlayers), 793*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(0, 160, 0, 255), 0.50, self.font, "center", "top", false, false, false, false, false)
			elseif isCursorOnElement(492*sx, (256+30*(k-1))*sy, 400*sx, 25*sy) then 
				dxDrawText(v.name, 492*sx, (256+30*(k-1))*sy, 637*sx, 282*sy, tocolor(160, 0, 0, 255), 0.50, self.font, "left", "top", false, false, false, false, false)
				dxDrawText(self.states[v.state]:gsub( '#%x%x%x%x%x%x', '' ), 573*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(160, 0, 0, 255), 0.50, self.font, "center", "top", false, false, false, true, false)
				dxDrawText(tostring(#v.players).."/"..tostring(v.maxPlayers), 793*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(160, 0, 0, 255), 0.50, self.font, "center", "top", false, false, false, false, false)
				if getKeyState("mouse1") then 
					self.selectedLobby = k
				end
			else 
				dxDrawText(v.name, 492*sx, (256+30*(k-1))*sy, 637*sx, 282*sy, tocolor(255, 255, 255, 255), 0.50, self.font, "left", "top", false, false, false, false, false)
				dxDrawText(self.states[v.state], 573*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(255, 255, 255, 255), 0.50, self.font, "center", "top", false, false, false, true, false)
				dxDrawText(tostring(#v.players).."/"..tostring(v.maxPlayers), 793*sx, (256+30*(k-1))*sy, 868*sx, 282*sy, tocolor(255, 255, 255, 255), 0.50, self.font, "center", "top", false, false, false, false, false)
			end 
        end
		
		if isCursorOnElement(478*sx, 489*sy, 132*sx, 29*sy) then 
			dxDrawRectangle(478*sx, 489*sy, 132*sx, 29*sy, tocolor(150, 0, 0, 211), false)
		else 
			dxDrawRectangle(478*sx, 489*sy, 132*sx, 29*sy, tocolor(60, 60, 60, 211), false)
		end 
		dxDrawRectangle(478*sx, 489*sy, 132*sx, 3*sy, tocolor(155, 0, 0, 254), false)
		dxDrawText("Dołącz", 515*sx, 494*sy, 722*sx, 521*sy, tocolor(255, 255, 255, 255), 0.40, self.font, "left", "top", false, false, false, false, false)
		
		if getElementData(localPlayer, "player:selectedLobby") then 
			if isCursorOnElement(760*sx, 489*sy, 132*sx, 29*sy) then 
				dxDrawRectangle(760*sx, 489*sy, 132*sx, 29*sy, tocolor(150, 0, 0, 211), false)
			else 
				dxDrawRectangle(760*sx, 489*sy, 132*sx, 29*sy, tocolor(60, 60, 60, 211), false)
			end 
			dxDrawRectangle(760*sx, 489*sy, 132*sx, 3*sy, tocolor(155, 0, 0, 254), false)
			dxDrawText("Wypisz", 798*sx, 494*sy, 722*sx, 521*sy, tocolor(255, 255, 255, 255), 0.40, self.font, "left", "top", false, false, false, false, false)
		end
	end,
}
lobbyInstance = CLobbyManager() 

function showLobbies()
	lobbyInstance:toggle()
end 
bindKey("f1", "down", showLobbies)

-- info o graczu jesli jest w poczekalni
local dxfont1_roboto = dxCreateFont(":br_font/roboto.ttf", 21*sx)
addEventHandler("onClientRender", root,
    function()
        local inLobby = getElementData(localPlayer, "player:selectedLobby")
		if inLobby then 
			local lobbies = getElementData(resourceRoot, "root:lobbies") or {}
			local lobby = lobbies[inLobby]
			if lobby then 
				dxDrawRectangle(21*sx, 201*sy, 209*sx, 67*sy, tocolor(0, 0, 0, 175), false)
				dxDrawRectangle(21*sx, 200*sy, 209*sx, 3*sy, tocolor(155, 0, 0, 254), false)
				dxDrawText(lobby.name, 24*sx, 202*sy, 228*sx, 221*sy, tocolor(255, 255, 255, 255), 0.50, dxfont1_roboto, "center", "top", false, false, false, false, false)
				dxDrawText("Graczy: "..tostring(#lobby.players).."/"..tostring(lobby.maxPlayers), 30*sx, 223*sy, 127*sx, 242*sy, tocolor(255, 255, 255, 255), 0.50, dxfont1_roboto, "left", "top", false, false, false, false, false)
				if lobby.state == "join" then 
					dxDrawText("Start: po zapełnieniu", 30*sx, 243*sy, 223*sx, 262*sy, tocolor(255, 255, 255, 255), 0.50, dxfont1_roboto, "left", "top", false, false, false, false, false)
				elseif lobby.state == "starting" then 
					local s = lobby.toStart
					
					dxDrawText("Start: "..tostring(s).. "s", 30*sx, 243*sy, 223*sx, 262*sy, tocolor(255, 255, 255, 255), 0.50, dxfont1_roboto, "left", "top", false, false, false, false, false)
				elseif lobby.state == "playing" then 
					dxDrawText("W grze!", 30*sx, 243*sy, 223*sx, 262*sy, tocolor(255, 255, 255, 255), 0.50, dxfont1_roboto, "left", "top", false, false, false, false, false)
				end 
			else 
				setElementData(localPlayer, "player:selectedLobby", false)
			end
		end 
    end
)