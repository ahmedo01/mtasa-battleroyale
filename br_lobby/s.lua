local timeToStart = 1 -- minuty do rozpoczecia gry po zapelnieniu 

function addLobby(name, players)
	if name and players then 
		local lobbies = getElementData(resourceRoot, "root:lobbies") or {}
		table.insert(lobbies, {name=name, players={}, maxPlayers=players, state="join", toStart=false})
		setElementData(resourceRoot, "root:lobbies", lobbies)
	end 	
end 

function removeLobby(lobbyIndex)

end 

function changeLobbyState(lobbyIndex, state)
	local lobbies = getElementData(resourceRoot, "root:lobbies") or {}
	local lobby = lobbies[lobbyIndex]
	if lobby then 
		if state == "join" then 
			lobby.state = state 
			lobby.players = {} 
		elseif state == "starting" then 
			lobby.state = state 
			lobby.toStart = (timeToStart*60)-1 
			
			setTimer(function(lobbyIndex)
				local lobbies = getElementData(resourceRoot, "root:lobbies") or {}
				local lobby = lobbies[lobbyIndex]
				if lobby then 
					lobby.toStart = lobby.toStart-1
					lobbies[lobbyIndex] = lobby
				end 
				setElementData(resourceRoot, "root:lobbies", lobbies)
			end, 1000, lobby.toStart, lobbyIndex) 
			setTimer(changeLobbyState, timeToStart*60000, 1, lobbyIndex, "playing")
		elseif state == "playing" then
			if #lobby.players > 0 then 
				lobby.state = state 
				triggerEvent("onStartGame", root, lobbyIndex, lobby.players)
			else 
				changeLobbyState(lobbyIndex, "join")
				return 
			end 
		end
		
		lobbies[lobbyIndex] = lobby
		setElementData(resourceRoot, "root:lobbies", lobbies)
	end 
end
addEvent("onLobbyChangeState", true)
addEventHandler("onLobbyChangeState", root, changeLobbyState)

function onResourceStart()
	for k,v in ipairs(getElementsByType("player")) do 
		setElementData(v, "player:selectedLobby", false)
	end
end 
addEventHandler("onResourceStart", resourceRoot, onResourceStart)

addLobby("#1 - mieszane", 1)