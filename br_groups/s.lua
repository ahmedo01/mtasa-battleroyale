function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

function group(player, cmd, arg1, arg2)
	if player and cmd then 
		if arg1 == "create" then 
			if getElementData(player, "player:group") then 
				exports["br_notifications"]:addNotification(player, "Już jesteś w grupie.", "error")
				return 
			end 
			
			setElementData(player, "player:group", {player})
			setElementData(player, "player:groupLeader", true)
			exports["br_notifications"]:addNotification(player, "Stworzyłeś grupę pomyślnie.", "success")
		elseif arg1 == "add" then 
			local group = getElementData(player, "player:group")
			if group then 
				local isLeader = getElementData(player, "player:groupLeader")
				if isLeader then 
					local name = arg2 -- table.concat zb륮e: nazwy gracza nie maj٠spacji
					if not name then 
						exports["br_notifications"]:addNotification(player, "/group add <szczątkowa nazwa gracza>.", "error")
						return 
					end 
					
					local targetPlayer = getPlayerFromPartialName(name)
					if targetPlayer then 
						for k,v in ipairs(group) do 
							if v == targetPlayer then 
								exports["br_notifications"]:addNotification(player, "Ten gracz jest już w twojej grupie.", "error")
								return 
							end
						end 
						
						table.insert(group, targetPlayer)
						setElementData(targetPlayer, "player:group", group)
						
						for k,v in ipairs(group) do 
							if isElement(v) then 
								setElementData(v, "player:group", group)
							end
						end

						exports["br_notifications"]:addNotification(player, "Gracz dodany pomyślnie.", "success")
					else 
						exports["br_notifications"]:addNotification(player, "/group add <szczątkowa nazwa gracza>.", "error")
						return 
					end 
				else 
					exports["br_notifications"]:addNotification(player, "Musisz być właścicielem grupy by to zrobić", "error")
				end 
			end 
		elseif arg1 == "remove" then 
			local group = getElementData(player, "player:group")
			if group then 
				local isLeader = getElementData(player, "player:groupLeader")
				if isLeader then 
					local name = arg2
					if not name then 
						exports["br_notifications"]:addNotification(player, "/group remove <szczątkowa nazwa gracza>.", "error")
						return 
					end 
					
					local targetPlayer = getPlayerFromPartialName(name)
					if targetPlayer then 
						setElementData(targetPlayer, "player:group", false)
						for k,v in ipairs(group) do 
							if targetPlayer == v then 
								table.remove(group, k)
							end
						end 
						
						for k,v in ipairs(group) do 
							if isElement(v) then 
								setElementData(v, "player:group", group)
							end
						end 
						
						exports["br_notifications"]:addNotification(player, "Gracz usunięty pomyślnie.", "success")
					else 
						exports["br_notifications"]:addNotification(player, "/group remove <szczڴkowa nazwa gracza>.", "error")
						return 
					end
				else 
					exports["br_notifications"]:addNotification(player, "Musisz być właścicielem grupy by to zrobić.", "error")
				end 
			end
		elseif arg1 == "delete" then 
			local group = getElementData(player, "player:group")
			if group then 
				local isLeader = getElementData(player, "player:groupLeader")
				if isLeader then
					for k,v in ipairs(group) do 
						setElementData(v, "player:group", false)
						setElementData(v, "player:groupLeader", false)
					end
					
					exports["br_notifications"]:addNotification(player, "Grupa została usunięta pomyślnie.", "success")
				end 
			end
		else 
			exports["br_notifications"]:addNotification(player, "/group create/add/remove/delete", "error")
		end 
	end
end 
addCommandHandler("group", group)

function groupexit(player, cmd)
	if player then 
		local group = getElementData(player, "player:group") or false 
		if group then 
			setElementData(player, "player:group", false)
			setElementData(player, "player:groupLeader", false)
			exports["br_notifications"]:addNotification(player, "Opuściłeś grupę pomyślnie.", "success")
		else 
			exports["br_notifications"]:addNotification(player, "Nie jesteś w żadnej grupie.", "error")
		end
	end
end 
addCommandHandler("groupexit", groupexit)

function onPlayerQuit() 
	local group = getElementData(player, "player:group")
	if group then 
	
	end
end 
addEventHnadler("onPlayerQuit", root, onPlayerQuit)