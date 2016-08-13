local sx, sy = guiGetScreenSize()
local size = 64
local cursorX, cursorY = 0, 0
local clicked = false
local crosshair = ""
local isFiring = 0

showPlayerHudComponent("crosshair", false)

function drawHitMarker()
	if screenX1 then 
		dxDrawImage(screenX1-((32)/2), screenY1-((32)/2), 32, 32, "crosshair/hitmarker.png")
	end
end

function setCrossHairSize(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if isFiring < 48 then
		isFiring = isFiring+2.4
	end
	
	if hitElement then
		if getElementType(hitElement)=="player" or getElementType(hitElement)=="ped" then
			screenX, screenY = getScreenFromWorldPosition(hitX, hitY, hitZ)
			if not screenX then return end 
			if isDrawing then return end 
			isDrawing = true
			
			local sound = playSound("crosshair/hitmarker-sound.wav")
			setSoundVolume(sound , 0.8)
		
		
			addEventHandler("onClientRender", root, drawHitMarker) 
			if drawTimer and isTimer(drawTimer) then
				killTimer(drawTimer)
			end
			
			
			drawTimer = setTimer(function() 
				isDrawing = false
				removeEventHandler("onClientRender", root, drawHitMarker) 
			end, 500, 1)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire",localPlayer,setCrossHairSize)

function drawCrosshair() 
  local task = getPedTask ( getLocalPlayer(), "secondary", 0 )
  if getPedWeapon(localPlayer) == 0 or task ~= "TASK_SIMPLE_USE_GUN" or not getControlState("aim_weapon") then 
	isFiring = 0
	return
  end 
  
  local hX,hY,hZ = getPedTargetEnd ( getLocalPlayer() )
    screenX1, screenY1 = getScreenFromWorldPosition ( hX,hY,hZ )
	if screenX1 then
		if not getControlState("fire") then
			isFiring = isFiring-1.2
			if isFiring < 0 then
				isFiring = 0
			end
		end
		if getPedWeapon(localPlayer) == 34 then
			showPlayerHudComponent("crosshair", true)
		else
			showPlayerHudComponent("crosshair", false)
		end
		if getPedWeapon(localPlayer) == 22 and getElementData(localPlayer,"currentweapon_2") == "Flashlight" then
			crosshair = "none"
		end
		dxDrawImage(screenX1-((size+isFiring)/2)+1, screenY1-((size+isFiring)/2)-1, size+isFiring, size+isFiring, "crosshair/hunting.png", 0,0,0, tocolor(0,0,0,255))
		dxDrawImage(screenX1-((size+isFiring)/2)-1, screenY1-((size+isFiring)/2)+1, size+isFiring, size+isFiring, "crosshair/hunting.png", 0,0,0, tocolor(0,0,0,255))
		dxDrawImage(screenX1-((size+isFiring)/2)-1, screenY1-((size+isFiring)/2)-1, size+isFiring, size+isFiring, "crosshair/hunting.png", 0,0,0, tocolor(0,0,0,255))
		dxDrawImage(screenX1-((size+isFiring)/2)+1, screenY1-((size+isFiring)/2)+1, size+isFiring, size+isFiring, "crosshair/hunting.png", 0,0,0, tocolor(0,0,0,255))
		dxDrawImage(screenX1-((size+isFiring)/2), screenY1-((size+isFiring)/2), size+isFiring, size+isFiring, "crosshair/hunting.png", 0,0,0, tocolor(200,0,0,255))
	end
end 
 addEventHandler("onClientRender", root, drawCrosshair)
 
bindKey("aim_weapon", "both", function(key, state)       
    local weapon = getPedWeapon(getLocalPlayer())
    if weapon ~= 0 and weapon ~=1 then
        if state == "down" then 
        else
			isFiring = 0
        end 
    end
end)