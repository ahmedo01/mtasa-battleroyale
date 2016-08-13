gLocalization = 
{
	["english"] = 
	{
		-- panel logowania
		{"login-title", "Authorization"},
		{"login-login_btn", "Login"},
		{"login-register_btn", "Register"},
		{"login-login_info",  "Login:"},
		{"login-pass_info", "Password:"},
		{"login-remember", "Remember me"},
		{"login-changelog", "- zbigniew centipede"},
		
		-- ekwipunek
		{"AK-47 Ammo", "AK-47 Magazine"},
	},
	
	["polish"] = 
	{
		-- panel logowania
		{"login-title", "Autoryzacja"},
		{"login-login_btn", "Zaloguj"},
		{"login-register_btn", "Zarejestruj"},
		{"login-login_info",  "Login:"},
		{"login-pass_info", "Hasło:"},
		{"login-remember", "Zapamiętaj mnie"},
		{"login-changelog", "- zbigniew centipede"},
		
		-- ekwipunek
		{"AK-47 Ammo", "Magazynek do AK-47"},
	},
}

function setPlayerLocalization(player, localization)
	if gLocalization[localization] then 
		setElementData(player, "player:localization", localization)
	end
end

function getText(player, cat)
	local localization = getElementData(player, "player:localization") or "english"
	local t = "false"
	for k,v in ipairs(gLocalization[localization]) do 
		if v[1] == cat then 
			t = v[2]
		end
	end 
	
	return t
end