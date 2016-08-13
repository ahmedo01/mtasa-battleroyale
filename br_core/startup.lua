local project = "Battle Royale"
local version = "0.1"

local resourceList = 
{
	"brmap_spawn",
	
	"br_auth",
	"br_chat",
	"br_font",
	"br_stats",
	"blur_box",
	"br_localization",
	"br_login",
	"br_hud",
	"br_inventory",
	"br_lobby",
	"br_game",
	"br_gas",
	"br_notifications",
	"bone_attach",
}
local unloadedResources = 0 

function init()
	outputServerLog("")
	outputServerLog("*********************")
	outputServerLog(project)
	outputServerLog("Wersja "..tostring(version))
	outputServerLog("Autor: Brzysiek <brzysiekdev@gmail.com>")
	outputServerLog("*********************")
	outputServerLog("")
	
	startResource(getResourceFromName("br_db"))
	
	if exports["br_db"]:getConnection() then 
		outputServerLog("-- Polaczono z baza MySQL.")
	else
		outputServerLog("*- Nie mozna polaczyc z baza MySQL! Zatrzymywanie startu skryptu.")
		cancelEvent()
		return false
	end
	
	outputServerLog("-- Wczytywanie zasobow serwera")
	for k,v in ipairs(resourceList) do
		local curResource = getResourceFromName(v) 
		local check
		if curResource then 
			if getResourceState(curResource) == "running" then
				check = restartResource(curResource)
			else
				check = startResource(curResource)
			end
		else
			check = false
		end
		
		if check == false then
			if curResource == false then
				outputServerLog("*- Zasob "..v.." nie zostal wczytany, bo taki zasob nie istnieje.")
				unloadedResources = unloadedResources+1
			else
				outputServerLog("*- Zasob "..v.." nie zostal wczytany. ("..getResourceLoadFailureReason(curResource)..")")
			end
		end
	end 
	
	if unloadedResources > 0 then 
		outputServerLog("*- Zasoby zostaly zaladowane ("..tostring(unloadedResources).." niepomyslnie)")
	else
		outputServerLog("-- Zasoby zostaly zaladowane pomyslnie")
	end
	
	setFPSLimit(60)
	setGameType(project.." "..tostring(version))
	setMapName("San Andreas")
	setElementData(root, "project", project)
	setElementData(root, "version", version)
	
	outputServerLog("-- Tryb gry "..project.." zostal uruchomiony.")
	return true
end
addEventHandler("onResourceStart", resourceRoot, init)

function stop()
	outputServerLog("-- Wylaczanie trybu "..tostring(project))
	
	for k,v in ipairs(resourceList) do 
		local curResource = getResourceFromName(v) 
		if curResource then 
			if getResourceState(curResource) == "running" then
				stopResource(curResource)
			end
		end
	end
	
	stopResource(getResourceFromName("br_db"))
	
	outputServerLog("-- Wylaczono pomyslnie.")
end
addEventHandler("onResourceStop", resourceRoot, stop)