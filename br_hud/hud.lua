local dxfont0_roboto = dxCreateFont(":br_font/roboto.ttf", 33, false, "antialiased")
local sW, sH = guiGetScreenSize()
local sx, sy = (sW/1280), (sH/720)

addEventHandler("onClientRender", root,
    function()
		if not getElementData(localPlayer, "player:spawned") then return end 
		if isPlayerMapVisible() then return end 
		
		local health = getElementHealth(localPlayer)
		health = math.max(health, 0)/100
		p = -510*(health^2)
		r,g = math.max(math.min(p + 240*health + 240, 240), 0), math.max(math.min(p + 765*health, 240), 0)      
		
		local armor = getPedArmor(localPlayer)
		armor = math.max(armor, 0)/100
		local armorOffset = 0
		if armor > 0 then 
			armorOffset = 50
		end 
		
		local weapon = getPedWeapon(localPlayer)
		local ammo = tostring(getPedAmmoInClip(localPlayer)).." / "..tostring(getPedTotalAmmo(localPlayer)-getPedAmmoInClip(localPlayer))
		
		dxDrawRectangle(1027*sx, 41*sy, 228*sx, 20*sy, tocolor(0, 0, 0, 200), false)
        --dxDrawRectangle(978*sx, 32*sy, 41*sx, 35*sy, tocolor(0, 0, 0, 200), false)
        dxDrawRectangle(1030*sx, 44*sy, (222*health)*sx, 14*sy, tocolor(r, g, 35, 220), false)
        dxDrawImage(989*sx, 36*sy, 30*sx, 30*sy, ":br_hud/images/hp.png", 0, 0, 0, tocolor(0, 0, 0, 255), false)
		dxDrawImage(988*sx, 35*sy, 30*sx, 30*sy, ":br_hud/images/hp.png", 0, 0, 0, tocolor(r, g, 35, 255), false)
		
		if armor > 0 then 
			dxDrawRectangle(1027*sx, 41+armorOffset*sy, 228*sx, 20*sy, tocolor(0, 0, 0, 200), false)
			--dxDrawRectangle(978*sx, 32+armorOffset*sy, 41*sx, 35*sy, tocolor(0, 0, 0, 200), false)
			dxDrawRectangle(1030*sx, 45+armorOffset*sy, (222*armor)*sx, 14*sy, tocolor(255, 153, 0, 220), false)
			dxDrawImage(991*sx, 37+armorOffset*sy, 26*sx, 26*sy, ":br_hud/images/armor.png", 0, 0, 0, tocolor(0, 0, 0, 255), false)
			dxDrawImage(990*sx, 36+armorOffset*sy, 26*sx, 26*sy, ":br_hud/images/armor.png", 0, 0, 0, tocolor(255, 153, 0, 255), false)
		end
		
        if weapon ~= 0 then 
			dxDrawRectangle(990*sx, (74+armorOffset/1.5)*sy, (10+#ammo*13)*sx, 39*sy, tocolor(0, 0, 0, 175), false)
			dxDrawRectangle(990*sx, (74+armorOffset/1.5)*sy, (10+#ammo*13)*sx, 3*sy, tocolor(200, 0, 0, 175), false)
			dxDrawText(ammo, 995*sx, (78+armorOffset/1.5)*sy, 1093*sx, 107*sy, tocolor(255, 255, 255, 255), 0.60*sx, dxfont0_roboto, "left", "top", false, false, false, false, false)
		end
    end
)
