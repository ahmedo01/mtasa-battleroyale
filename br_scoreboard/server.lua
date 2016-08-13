function onResourceStart()
	exports["scoreboard"]:scoreboardAddColumn("player:country", root, 20, "", 1)

    for k, v in ipairs(getElementsByType("player")) do
		local countryCode = exports["admin"]:getPlayerCountry(v)
		
		if countryCode then
			local sFlagImagePath = ':'..getResourceName(getThisResource())..'/flags/'..string.lower(countryCode)..'.png'
			if fileExists(sFlagImagePath) then
				setElementData(v, "player:country", {type="image", src=sFlagImagePath, width=13, height=10})
			else
				setElementData(v, "player:country", "??" )
			end
		end
	end
	
	exports["scoreboard"]:scoreboardAddColumn("player:kills", root, 50, "Kills", 3)
	exports["scoreboard"]:scoreboardAddColumn("player:deaths", root, 50, "Deaths", 4)
	exports["scoreboard"]:scoreboardAddColumn("player:points", root, 50, "Points", 5)
end
addEventHandler("onResourceStart", resourceRoot, onResourceStart)
 
function onPlayerJoin ()
	local countryCode = exports["admin"]:getPlayerCountry(source)
	if countryCode then
		local sFlagImagePath = ':'..getResourceName( getThisResource() )..'/flags/'..string.lower(countryCode)..'.png'
		if fileExists(sFlagImagePath) then
			setElementData(source, "player:country", {type="image", src=sFlagImagePath, width=13, height=10})
		else
			setElementData(source, "player:country", "??" )
		end
	end
	
	setElementData(source, "player:kills", 0)
	setElementData(source, "player:deaths", 0)
	setElementData(source, "player:points", 0)
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)
