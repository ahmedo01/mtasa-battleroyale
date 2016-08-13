addEvent ("onClientPlayerKillMessage",true)
function onClientPlayerKillMessage ( killer,weapon,wr,wg,wb,kr,kg,kb,width,resource )
	if wasEventCancelled() then return end
	outputKillMessage ( source, wr,wg,wb,killer,kr,kg,kb,weapon,width,resource )
end
addEventHandler ("onClientPlayerKillMessage",getRootElement(),onClientPlayerKillMessage)

killStreaks = {}
secondsInterval = 10

function getPlayerKillStreak(player)
	if (not player) then return "" end
	--local player = getPlayerFromName(name)
	if (player) then	
		if (killStreaks[player][1] > 1) then
			return " (x"..killStreaks[player][1]..")"
		else
			return ""
		end
	else
		return ""
	end
end

function increasePlayerKillStreak(player)
	if (player and getElementType(player) == "player") then
		if (not killStreaks[player]) then
			killStreaks[player] = {1, 0}
		end
		if (killStreaks[player][2] >= getTickCount()) then
			killStreaks[player] = {killStreaks[player][1] + 1, getTickCount() + (secondsInterval*1000)}
		else
			killStreaks[player] = {1, getTickCount() + (secondsInterval*1000)}
		end
		return true
	end
end

function onClientPlayerQuit()
	if (killStreaks[source]) then
		killStreaks[source] = nil
	end
end
addEventHandler("onClientPlayerQuit", root, onClientPlayerQuit)
addEventHandler("onClientPlayerWasted", root, onClientPlayerQuit)
function testdevok ()
local msg = getPlayerKillStreak(localPlayer)
exports.NGCtexts:output(msg,255,0,0)

end
addCommandHandler("testdevokill",testdevok)

function testdevoks ()
increasePlayerKillStreak(localPlayer)
exports.NGCtexts:output("so?",255,0,0)

end
addCommandHandler("testdevokills",testdevoks)


function outputKillMessage ( source, wr,wg,wb,killer,kr,kg,kb,weapon,width,resource )
	if not iconWidths[weapon] then 
		if type(weapon) ~= "string" then
			weapon = 999 
		end
	end
	local killerName
	local wastedName
	if not tonumber(wr) then wr = 255 end
	if not tonumber(wg) then wg = 255 end
	if not tonumber(wb) then wb = 255 end
	if not tonumber(kr) then kr = 255 end
	if not tonumber(kg) then kg = 255 end
	if not tonumber(kb) then kb = 255 end
	if ( source ) then
		if isElement ( source ) then
			if getElementType ( source ) == "player" then 
				wastedName = getPlayerName ( source )
			else 
			outputDebugString ( "outputKillMessage - Invalid 'wasted' player specified",0,0,0,100)
			return false end
		elseif type(source) == "string" then
			wastedName = source
		end
	else 
		outputDebugString ( "outputKillMessage - Invalid 'wasted' player specified",0,0,0,100)
	return false end
	if ( killer ) then
		if isElement ( killer ) then
			if getElementType ( killer ) == "player" then
				killerName = getPlayerName ( killer )
				
			else 
				outputDebugString ( "outputKillMessage - Invalid 'killer' player specified",0,0,0,100)
			return false end
		elseif type(killer) == "string" then
			killerName = killer
			--increasePlayerKillStreak(getPlayerFromName(killer))
		else
			killerName = ""
		end
	else killerName = "" end
	--create the new text
	if not killerName then
		killerName = ""
	end
		increasePlayerKillStreak(killer)
	local streakmsg = getPlayerKillStreak(killer)

	return outputMessage ( {{"color",r=255,g=255,b=255}, streakmsg, {"padding",width=3},{"color",r=kr,g=kg,b=kb},killerName, {"padding",width=3}, {"icon",id=weapon},
		{"padding",width=3},{"color",r=wr,g=wg,b=wb}, wastedName},
		kr,kg,kb )
end
