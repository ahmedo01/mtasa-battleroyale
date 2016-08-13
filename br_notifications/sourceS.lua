function addNotification(player, text, type)
	if (player and text and type) then
		triggerClientEvent(player, 'addNotification', player, text, type);
	end
end