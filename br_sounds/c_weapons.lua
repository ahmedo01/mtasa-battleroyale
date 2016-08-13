--setWorldSoundEnabled(5, false)
--setAmbientSoundEnabled( "gunfire", false )

function playWeaponSound(weapon)
	if fileExists("weapons/"..tostring(weapon)..".wav") then 
		local x,y,z = getElementPosition(source)
		
		local snd = playSound3D("weapons/"..tostring(weapon)..".wav", x, y, z, false)
		
		if weapon == 23 then 
			setSoundMaxDistance(snd, 50) -- pistol z tlumikiem
		else 
			setSoundMaxDistance(snd, 200)
		end
	end
end 
addEventHandler("onClientPlayerWeaponFire", root, playWeaponSound)