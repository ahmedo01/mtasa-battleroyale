function isIP(ip)
    if ip == nil or type(ip) ~= "string" then
        return false
    end

    local chunks = {ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")}
    if (#chunks == 4) then
        for _,v in pairs(chunks) do
            if (tonumber(v) < 0 or tonumber(v) > 255) then
                return false
            end
        end
        return true
    else
        return false
    end

	return false
end

function isColor(color)
	if color == nil or type(color) ~= "string" then
        return false
    end
	
	if color:match("#%x%x%x%x%x%x") then 
		return true 
	end 
end

function onPlayerChat(message, messageType)
	if not getElementData(source, "player:uid") then cancelEvent() return end 
	
	if isIP(message) then 
		outputChatBox(">> Podawanie IP na czacie jest niedozwolone.", source, 255, 0, 0)
		return 
	end 
	
	if isColor(message) then 
		outputChatBox(">> Kolorozywanie wiadomości na czacie jest niedozwolone.", source, 255, 0, 0)
		return 
	end 
	
	local now = getTickCount()
	local lastMessageTick = getElementData(source, "player:lastMessage") or 0
	if lastMessageTick > now then
		local time = math.ceil((lastMessageTick-now)/1000)  
		outputChatBox(">> Odczekaj jeszcze "..tostring(time).."s przed wysłaniem następnej wiadomości.", source, 255, 0, 0)
		setElementData(source, "player:lastMessage", lastMessageTick+400)
		cancelEvent()
		return
	end
	
	if messageType == 0 then 
		for k,v in ipairs(getElementsByType("player")) do 
			outputChatBox("#969696["..tostring(getElementData(source, "player:id")).."] #FFFFFF"..getPlayerName(source).."#E0E0E0: "..message, v, 255, 255, 255, true)
			outputServerLog("[GCHAT] ["..tostring(getElementData(source, "player:id")).."] "..getPlayerName(source)..": "..message)
		end
	elseif messageType == 1 then 
	
	elseif messageType == 2 then 
		local group = getElementData(source, "player:group") or false
		if group then 
		
		else 
			exports["fr_ui"]:showNotification(source, "By korzystać z tego czatu, dołącz lub stwórz grupę.", "warning")
		end
	end
	
	cancelEvent()
	setElementData(source, "player:lastMessage", getTickCount()+1200)
end
addEventHandler("onPlayerChat", root, onPlayerChat)


function pw(player, cmd, toPlayer, ...)
	if not getElementData(player, "player:uid") then return end 
	local now = getTickCount()
	local lastMessageTick = getElementData(player, "player:lastMessage") or 0
	if lastMessageTick > now then
		local time = math.ceil((lastMessageTick-now)/1000)  
		outputChatBox("* Odczekaj jeszcze "..tostring(time).."s przed wysłaniem następnej wiadomości.", player, 255, 0, 0)
		setElementData(player, "player:lastMessage", lastMessageTick+400)
		cancelEvent()
		return
	end
	setElementData(player, "player:lastMessage", getTickCount()+2000)
	
	local playerID = getElementData(player, "player:id")
	local target = false 
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:id") == tonumber(toPlayer) then 
			target = v 
		end 
	end 
	
	local message = table.concat({ ... }, " ")
	if isIP(message) then 
		outputChatBox(">> Podawanie IP na czacie jest niedozwolone.", player, 255, 0, 0)
		return 
	end 
	
	if playerID == tonumber(toPlayer) then exports["fr_ui"]:showNotification(player, "Nie możesz wysyłać wiadomości do siebie.", "warning") return end 
	if #message < 1 then exports["fr_ui"]:showNotification(player, "Prawidłowe użycie:<br>/pw/pm/w <b>(id gracza)</b> <b>(wiadomość)</b>", "warning") return end 
	if target and getElementType(target) == "player" then 
		local pwEnabled = getElementData(target, "player:pwEnabled")
		if not pwEnabled then pwEnabled = "tak" end 
		
		if pwEnabled == "nie" then  
			exports["fr_ui"]:showNotification(player, "Ten gracz ma wyłączone prywatne wiadomości.", "warning") 
			return 
		end 
		
		if getElementData(target, "player:afk") then 
			outputChatBox(">> [AFK] ["..toPlayer.."] "..getPlayerName(target)..": "..message, player, 255, 204, 0)
		else 
			outputChatBox(">> ["..toPlayer.."] "..getPlayerName(target)..": "..message, player, 255, 204, 0)
		end 
		
		outputChatBox("<< ["..tostring(playerID).."] "..getPlayerName(player)..": "..message, target, 255, 204, 0)
		triggerClientEvent(root, "onInsertPreview", root, "[PW] ["..tostring(playerID).."]"..getPlayerName(player).." -> ["..tostring(toPlayer).."]"..getPlayerName(target)..": "..message)
		outputServerLog("[PW] ["..tostring(playerID).."]"..getPlayerName(player).." -> ["..tostring(toPlayer).."]"..getPlayerName(target)..": "..message)
	else
		triggerClientEvent(player, "onClientAddNotification", player, "Nie znaleziono takiego gracza.", "error") 
	end
end
addCommandHandler("pm", pw)
addCommandHandler("pw", pw)
addCommandHandler("w", pw)

function pwoff(player, cmd)
	setElementData(player, "player:pwEnabled", "nie")
	exports["fr_ui"]:showNotification(player, "Wyłączyłeś prywatne wiadomości.", "info")
end 
addCommandHandler("pwoff", pwoff)

function pwon(player, cmd)
	setElementData(player, "player:pwEnabled", "tak")
	exports["fr_ui"]:showNotification(player, "Włączyłeś prywatne wiadomości.", "info")
end 
addCommandHandler("pwon", pwon)