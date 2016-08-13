local font = dxCreateFont("font.ttf", 20)

function checkWindowState()
	if isMainMenuActive() then
		setElementData(localPlayer, "player:mainMenuActive", true)
	else
		setElementData(localPlayer, "player:mainMenuActive", false)
	end
end

function onClientMinimize()
	local h, m = getRealTime().hour, getRealTime().minute 
	if h < 10 then h = "0"..tostring(h) end 
	if m < 10 then m = "0"..tostring(m) end 
	
	setElementData(localPlayer, "player:minimized", {h, m})
end
addEventHandler("onClientMinimize", root, onClientMinimize)

function onClientRestore()
	setElementData(localPlayer, "player:minimized", false)
end
addEventHandler("onClientRestore", root, onClientRestore)

local damageTimer = false
function onPlayerDamage()
	setElementData(localPlayer, "player:gotDamage", true)
	if not isTimer(damageTimer) then 
		damageTimer = setTimer(
			function()
				setElementData(localPlayer, "player:gotDamage", false)
				killTimer(damageTimer)
				damageTimer = false
			end, 1800, 1
		)
	end
end
addEventHandler("onClientPlayerDamage", getLocalPlayer(), onPlayerDamage)

function addToStatusString(str, content)
	if string.len(str) > 0 then 
		return str..", "..content
	elseif string.len(str) < 1 then 
		return "("..content
	end
end

local maxDist = 15
local defaultR, defaultG, defaultB = 220, 220, 220
local screenW, screenH = guiGetScreenSize()
function updateNametags()
	local players = getElementsByType("player")
	for k,v in ipairs(players) do	
		setPlayerNametagShowing ( v, false )
		if getElementData(v, "player:uid") then 
			local dimension = getElementDimension(localPlayer)
			if v ~= localPlayer and dimension == getElementDimension(v) then
				local x1,y1,z1 = getCameraMatrix()
				local x2,y2,z2 = getElementPosition(v)
				local r, g, b = defaultR, defaultG, defaultB
				local visibleto = getDistanceBetweenPoints3D(x1,y1,z1,x2,y2,z2)
				if visibleto >  maxDist then else
					local sx,sy = getScreenFromWorldPosition ( x2,y2,z2+0.9 )
					if not sx and not sy then else
						local pstring = "("..tostring(getElementData(v, "player:id"))..") "..tostring(getPlayerName(v))
						
						local sDist = visibleto/maxDist/4
						if isPedInVehicle(localPlayer) then
							dxDrawText (pstring, sx-1,sy-1,sx,sy, tocolor(0, 0, 0,220-sDist*100), 0.6-sDist, font, "center","top",false,false,false, true )
							dxDrawText (pstring, sx,sy,sx,sy, tocolor(r,g,b,220-sDist*100), 0.6-sDist, font, "center","top",false,false,false, true )
						else
							if isLineOfSightClear(x1, y1, z1+1, x2, y2, z2+1, true, true, false, true) then
								dxDrawText (pstring, sx-1,sy-1,sx,sy, tocolor(0, 0, 0, math.max(0, 220-sDist*1000)), 0.6-sDist, font, "center","top",false,false,false, true )
								dxDrawText (pstring, sx,sy,sx,sy, tocolor(r,g,b, math.max(0, 220-sDist*1000)), 0.6-sDist, font, "center","top",false,false,false, true )
							end
						end
					end
				end
			end
		end
	end
	
	checkWindowState()
end
addEventHandler("onClientRender", root, updateNametags)