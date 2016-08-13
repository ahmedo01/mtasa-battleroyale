
g_GuiLabel = { }

function GuiShow()
	if g_Settings.Visible then
		g_GuiLabel.Speed:visible(true)
		g_GuiLabel.Unit:visible(true)
	end
end
addEventHandler("onClientScreenFadedIn", root, GuiShow)


function GuiHide()
	g_GuiLabel.Speed:visible(false)
	g_GuiLabel.Unit:visible(false)
end
addEventHandler("onClientScreenFadedOut", root, GuiHide)


function GuiInitialize()
	local screenWidth, screenHeight = guiGetScreenSize()

	g_GuiLabel.Speed = dxText:create("0", screenWidth-72, screenHeight - 36, false, "pricedown", 2, "right")
	g_GuiLabel.Speed:type("stroke", 3, 0, 0, 0, 255)
	
	g_GuiLabel.Unit = dxText:create("", screenWidth-64, screenHeight - 28, false, "pricedown", 1, "left") 
	g_GuiLabel.Unit:type("stroke", 2, 0, 0, 0, 255)
	
	GuiHide()
end
GuiInitialize()

