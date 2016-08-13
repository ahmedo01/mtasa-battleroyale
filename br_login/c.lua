local sW, sH = guiGetScreenSize()
local sx, sy = (sW/1366), (sH/768)

local selectedLanguage = false 
local dxfont0_roboto = dxCreateFont(":br_font/roboto.ttf", 35, false, "antialiased")

function isCursorOnElement(x,y,w,h)
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end


function moveCamera(x, y, z, x2, y2, z2, time)
	obj1=createObject(1337, x,y,z)
	setElementAlpha(obj1, 0)
	setObjectScale(obj1, 0.01)
	moveObject(obj1, time*1000, x2, y2, z2, 0,0,0, "InOutQuad")
	
	setElementPosition(getCamera(), 0, 0, 0)
	attachElements(getCamera(), obj1)
end 

function fadeMusic()
	if isElement(music) then 
		local vol = getSoundVolume(music)
		if vol <= 0.05 then
			stopSound(music)
		else
			setSoundVolume(music, vol-0.05)
			setTimer(fadeMusic, 100, 1)
		end 
	end 
end 

function handleKeys(key, press)
	if key == "mouse1" then 
		if press then 
			if selectedLanguage then 
				if isCursorOnElement(504*sx, 444*sy, 155*sx, 37*sy) then 
					triggerEvent("onPlayerTryLogin", localPlayer, guiGetText(loginEdit), guiGetText(passEdit))
				elseif isCursorOnElement(701*sx, 444*sy, 155*sx, 37*sy) then 
					triggerEvent("onPlayerTryRegister", localPlayer, guiGetText(loginEdit), guiGetText(passEdit))
				end
			end
		end
	end
end 

function renderLogin()
	local localization = exports["br_localization"]
	
	if not selectedLanguage then 
	    dxDrawRectangle(381*sx, 268*sy, 604*sx, 235*sy, tocolor(0, 0, 0, 202), false)
		if isCursorOnElement(405*sx, 313*sy, 254*sx, 143*sy) then 
			dxDrawImage(405*sx, 313*sy, 254*sx, 143*sy, ":br_login/i/english.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			if getKeyState("mouse1") then 
				selectedLanguage = "english"
				localization:setPlayerLocalization(localPlayer, "english")
				guiSetVisible(loginEdit, true)
				guiSetVisible(passEdit, true)
				guiSetInputEnabled(true)
				guiBringToFront(loginEdit)
			end
		else 
			dxDrawImage(405*sx, 313*sy, 254*sx, 143*sy, ":br_login/i/english.png", 0, 0, 0, tocolor(255, 255, 255, 155), false)
        end 
		
		if isCursorOnElement(705*sx, 313*sy, 254*sx, 143*sy) then 
			dxDrawImage(705*sx, 313*sy, 254*sx, 143*sy, ":br_login/i/polish.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
			if getKeyState("mouse1") then 
				selectedLanguage = "polish"
				localization:setPlayerLocalization(localPlayer, "polish")
				guiSetVisible(loginEdit, true)
				guiSetVisible(passEdit, true)
				guiSetInputEnabled(true)
				guiBringToFront(loginEdit)
			end
		else 
			dxDrawImage(705*sx, 313*sy, 254*sx, 143*sy, ":br_login/i/polish.png", 0, 0, 0, tocolor(255, 255, 255, 155), false)
		end
        dxDrawLine(381*sx, 267*sy, 984*sx, 267*sy, tocolor(137, 0, 0, 214), 4*sx, false)
	else 
		-- login
		dxDrawRectangle(465*sx, 266*sy, 437*sx, 237*sy, tocolor(0, 0, 0, 202), false)
        dxDrawText(localization:getText(localPlayer, "login-title"), (465 + 1)*sx, (218 + 1)*sy, (727 + 1)*sx, (276 + 1)*sy, tocolor(0, 0, 0, 255), 0.7*sx, dxfont0_roboto, "left", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-title"), 465*sx, 218*sy, 727*sx, 276*sy, tocolor(255, 255, 255, 255), 0.7*sx, dxfont0_roboto, "left", "top", false, false, false, false, false)
        if isCursorOnElement(504*sx, 444*sy, 155*sx, 37*sy) then 
			dxDrawRectangle(504*sx, 444*sy, 155*sx, 37*sy, tocolor(137, 0, 0, 220), false)
		else 
			dxDrawRectangle(504*sx, 444*sy, 155*sx, 37*sy, tocolor(23, 23, 23, 220), false)
		end 
		
		if isCursorOnElement(701*sx, 444*sy, 155*sx, 37*sy) then 
			dxDrawRectangle(701*sx, 444*sy, 155*sx, 37*sy, tocolor(137, 0, 0, 220), false)
		else 
			dxDrawRectangle(701*sx, 444*sy, 155*sx, 37*sy, tocolor(23, 23, 23, 220), false)
		end 
		
        dxDrawText(localization:getText(localPlayer, "login-login_btn"), 541*sx, 449*sy, 620*sx, 481*sy, tocolor(255, 255, 255, 255), 0.45*sx, dxfont0_roboto, "center", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-register_btn"), 724*sx, 449*sy, 830*sx, 481*sy, tocolor(255, 255, 255, 255), 0.45*sx, dxfont0_roboto, "center", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-login_info"), 480*sx, 294*sy, 562*sx, 326*sy, tocolor(255, 255, 255, 255), 0.4*sx, dxfont0_roboto, "right", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-pass_info"), 480*sx, 354*sy, 562*sx, 386*sy, tocolor(255, 255, 255, 255), 0.4*sx, dxfont0_roboto, "right", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-remember"), 541*sx, 404*sy, 681*sx, 422*sy, tocolor(255, 255, 255, 255), 0.35*sx, dxfont0_roboto, "center", "top", false, false, false, false, false)
        dxDrawLine(465*sx, 266*sy, 901*sx, 266*sy, tocolor(137, 0, 0, 214), 4*sx, false)
      
		-- changelog
		dxDrawRectangle(1052*sx, 16*sy, 285*sx, 150*sy, tocolor(0, 0, 0, 153), false)
        dxDrawText("Changelog", (1064 + 1)*sx, (23 + 1)*sy, (1325 + 1)*sx, (46 + 1)*sy, tocolor(0, 0, 0, 255), 1.00*sx, "default", "center", "top", false, false, false, false, false)
        dxDrawText("Changelog", 1064*sx, 23*sy, 1325*sx, 46*sy, tocolor(255, 255, 255, 255), 1.00*sx, "default", "center", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-changelog"), (1064 + 1)*sx, (46 + 1)*sy, (1325 + 1)*sx, (103 + 1)*sy, tocolor(0, 0, 0, 255), 1.00*sx, "default", "left", "top", false, false, false, false, false)
        dxDrawText(localization:getText(localPlayer, "login-changelog"), 1064*sx, 46*sy, 1325*sx, 103*sy, tocolor(255, 255, 255, 255), 1.00*sx, "default", "left", "top", false, false, false, false, false)
        dxDrawLine(1052*sx, 16*sy, 1336*sx, 16*sy, tocolor(137, 0, 0, 214), 3*sx, false)
	end
end 

function destroy()
	removeEventHandler("onClientRender", root, renderLogin)
	removeEventHandler("onClientKey", root, handleKeys)
	exports["blur_box"]:destroyBlurBox(blur)
	
	destroyElement(loginEdit)
	destroyElement(passEdit)
	destroyElement(dxfont0_roboto)
	
	detachElements(getCamera(), obj1)
	destroyElement(obj1)
	
	showCursor(false)
	guiSetInputMode("allow_binds")
	
	showChat(true)
	
	fadeMusic()
end 

addEvent("onPlayerTryLogin", true)
addEventHandler("onPlayerTryLogin", root, 
	function(login, password)
		if #login < 3 then 
			exports["br_notifications"]:addNotification("Twój login musi wynosić conajmniej 3 znaki.", "error")
			return 
		end 
		
		if #password < 6 then 
			exports["br_notifications"]:addNotification("Twoje hasło musi mieć conajmniej 6 znaków.", "error")
			return 
		end 
		
		fadeCamera(false, 1.5)
		triggerServerEvent("onPlayerEnterAccount", localPlayer, login, password)
	end 
)

addEvent("onPlayerTryRegister", true)
addEventHandler("onPlayerTryRegister", root, 
	function(login, password)
		if #login < 3 then 
			exports["br_notifications"]:addNotification("Twój login musi wynosić conajmniej 3 znaki.", "error")
			return 
		end 
		
		if #password < 6 then 
			exports["br_notifications"]:addNotification("Twoje hasło musi mieć conajmniej 6 znaków.", "error")
			return 
		end 
		
		fadeCamera(false, 1.5)
		triggerServerEvent("onPlayerCreateAccount", localPlayer, login, password)
	end 
)

addEvent("onPlayerRegisterSuccess", true)
addEventHandler("onPlayerRegisterSuccess", root,
	function()
		destroy()
		setTimer(triggerServerEvent, 1500, 1, "onPlayerEnterGame", localPlayer, localPlayer)
	end 
)

addEvent("onPlayerLoginSuccess", true)
addEventHandler("onPlayerLoginSuccess", root, 
	function()
		destroy()
		setTimer(triggerServerEvent, 1500, 1, "onPlayerEnterGame", localPlayer, localPlayer)
	end 
)
	
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		--if getElementData(localPlayer, "player:uid") then return end -- gracz jest zalogowany 
		loginEdit = guiCreateEdit(572*sx, 289*sy, 284*sx, 37*sy, "", false)
		guiEditSetMaxLength(loginEdit, 40)
		guiSetVisible(loginEdit, false)
		
		passEdit =  guiCreateEdit(572*sx, 349*sy, 284*sx, 37*sy, "", false)
		guiEditSetMasked(passEdit, true)
        guiEditSetMaxLength(passEdit, 30)    
		guiSetVisible(passEdit, false)
		
		exports["blur_box"]:setBlurIntensity(1.3)
		blur = exports["blur_box"]:createBlurBox(0, 0, sW, sH, 255, 255, 255, 255, false)
			
		moveCamera(1936, 1628, 80, 1606.15, -1595.12, 103.31, 150)
		setFarClipDistance(1250)
		
		showChat(false)
			
		fadeCamera(false, 0)
		setTimer(fadeCamera, 1000, 1, true, 1.5)
			
		music = playSound("s/music.mp3")
		setSoundVolume(music, 0.7)
		
		addEventHandler("onClientRender", root, renderLogin)
		addEventHandler("onClientKey", root, handleKeys)
		
		showCursor(true)
		guiSetInputMode("no_binds")
		
		setPlayerHudComponentVisible("all", false)
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		destroy()
	end
)