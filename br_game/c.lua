local sw, sh = guiGetScreenSize()
local sx, sy = (sw/1366), (sh/768)

local message = 1 
addEventHandler("onClientRender", root,
    function()
        setTime(10, 0)
		
		local game = getElementData(localPlayer, "player:game")
		if game then 
			if message == 1 then 
				local currentTimestamp = getRealTime().timestamp 
				local t = game[2]-currentTimestamp
				if t > 0 then 
					local lootTime = getRealTime(t).minute+1
					dxDrawText(tostring(lootTime).." min do wypuszczenia gazu. Zbieraj przedmioty!", (879 - 1)*sx, (8 - 1)*sy, (1338 - 1)*sx, (36 - 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText(tostring(lootTime).." min do wypuszczenia gazu. Zbieraj przedmioty!", (879 + 1)*sx, (8 - 1)*sy, (1338 + 1)*sx, (36 - 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText(tostring(lootTime).." min do wypuszczenia gazu. Zbieraj przedmioty!", (879 - 1)*sx, (8 + 1)*sy, (1338 - 1)*sx, (36 + 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText(tostring(lootTime).." min do wypuszczenia gazu. Zbieraj przedmioty!", (879 + 1)*sx, (8 + 1)*sy, (1338 + 1)*sx, (36 + 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText(tostring(lootTime).." min do wypuszczenia gazu. Zbieraj przedmioty!", 879*sx, 8*sy, 1338*sx, 36*sy, tocolor(255, 255, 255, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
				else 
					dxDrawText("Gaz został wypuszczony! (mapa F11)", (879 - 1)*sx, (8 - 1)*sy, (1338 - 1)*sx, (36 - 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText("Gaz został wypuszczony! (mapa F11)", (879 + 1)*sx, (8 - 1)*sy, (1338 + 1)*sx, (36 - 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText("Gaz został wypuszczony! (mapa F11)", (879 - 1)*sx, (8 + 1)*sy, (1338 - 1)*sx, (36 + 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText("Gaz został wypuszczony! (mapa F11)", (879 + 1)*sx, (8 + 1)*sy, (1338 + 1)*sx, (36 + 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
					dxDrawText("Gaz został wypuszczony! (mapa F11)", 879*sx, 8*sy, 1338*sx, 36*sy, tocolor(255, 255, 255, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
				end
			elseif message == 2 then 
				local players = 0
				for k,v in ipairs(getElementsByType("player")) do 
					local p = getElementData(v, "player:game") or false 
					if p and p[1] == game[1] then 
						players = players+1
					end
				end

				dxDrawText("Pozostali: "..tostring(players), (879 - 1)*sx, (8 - 1)*sy, (1338 - 1)*sx, (36 - 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Pozostali: "..tostring(players), (879 + 1)*sx, (8 - 1)*sy, (1338 + 1)*sx, (36 - 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Pozostali: "..tostring(players), (879 - 1)*sx, (8 + 1)*sy, (1338 - 1)*sx, (36 + 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Pozostali: "..tostring(players), (879 + 1)*sx, (8 + 1)*sy, (1338 + 1)*sx, (36 + 1)*sy, tocolor(0, 0, 0, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
				dxDrawText("Pozostali: "..tostring(players), 879*sx, 8*sy, 1338*sx, 36*sy, tocolor(255, 255, 255, 255), 1.50*sx, "default-bold", "right", "top", false, false, false, false, false)
			end
		end 
    end
)

function changeMessage() 
	local game = getElementData(localPlayer, "player:game")
	if game then 
		if message == 1 then 
			message = 2 
		else 
			message = 1 
		end 
	end
end
setTimer(changeMessage, 10000, 0)