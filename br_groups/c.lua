local screenW, screenH = guiGetScreenSize() 

function renderGroupInfo() 
	local playerGroup = getElementData(localPlayer, "player:group") or false 
	if playerGroup then 
		local inGame = getElementData(localPlayer, "player:game") or false 
		local i = 0 
		for k,v in ipairs(playerGroup) do 
			if inGame and isElement(v) and getElementData(v, "player:game") then 
				i = i+1 
				dxDrawText(getPlayerName(v), 21, 1+ screenH/2.75 + 20*(i-1), 0, 0, tocolor(0, 0, 0, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
				dxDrawText(getPlayerName(v), 20, screenH/2.75 + 20*(i-1), 0, 0, tocolor(53, 224, 30, 199), 1.00, "default-bold", "left", "top", false, false, false, false, false)
			else 
				if isElement(v) and getElementData(v, "player:onSpawn") and getElementData(localPlayer, "player:onSpawn") then 
					i = i+1
					dxDrawText(getPlayerName(v), 21, 1+ screenH/2.75 + 20*(i-1), 0, 0, tocolor(0, 0, 0, 255), 1.00, "default-bold", "left", "top", false, false, false, false, false)
					dxDrawText(getPlayerName(v), 20, screenH/2.75 + 20*(i-1), 0, 0, tocolor(53, 224, 30, 199), 1.00, "default-bold", "left", "top", false, false, false, false, false)
				end
			end
		end
	end
end 
addEventHandler("onClientRender", root, renderGroupInfo)