maxDistance = 4
local itemData = {} 
addEventHandler( "onClientRender", root,
function( )
	if inventoryInstance and inventoryInstance.showing then return end 
	for k, item in ipairs(itemData) do 
		if isElement(item) then 
			local ix, iy, iz = getElementPosition(item)
			local x, y = getScreenFromWorldPosition( ix, iy, iz+0.2 )
			if x and y then
				local text = getElementData(item, "item:name") or ""
				local width = dxGetTextWidth(text, 1, "default-bold")
				dxDrawRectangle(x-33, y-2, width+40, 2, tocolor(180, 0, 0, 150))
				dxDrawRectangle(x-33, y, width+40, 25, tocolor(0, 0, 0, 150))
				dxDrawText(text, x+1, y+5, _, _, tocolor( 0, 0, 0, 200 ), 1, "default-bold", "left", "top", false, false, false, true )
				dxDrawText(text, x, y+4, _, _, tocolor( 200, 200, 200, 200 ), 1, "default-bold", "left", "top", false, false, false, true )
				dxDrawImage(x-28, y+2, 20, 20, "img/k.png", 0, 0, 0, tocolor(255, 255, 255, 220))
			end
		end
	end
end)

Async:setPriority("high")
function updateItemData()
	itemData = {} 
	Async:foreach(getElementsByType("colshape"), function(v)
		if getElementDimension(v) == getElementDimension(localPlayer) then 
			local item = getElementData(v, "col:item")
			if isElement(item) then 
				local px,py,pz = getElementPosition(localPlayer)
				local ix,iy,iz = getElementPosition(item)
				local dist = getDistanceBetweenPoints3D(px,py,pz,ix,iy,iz)
				if dist <= maxDistance then 
					table.insert(itemData, item)
					if isElementWithinColShape(localPlayer, v) then 
						setElementData(localPlayer, "player:canTakeItem", item)
					end
				end 
			end
		end 
	end) 
end 
setTimer(updateItemData, 300, 0)

txd = engineLoadTXD ( "img/MatClothes.txd" )
engineImportTXD ( txd, 3092 )
col = engineLoadCOL ( "img/MotorcycleHelmet2.col" )
engineReplaceCOL ( col, 3092 )
dff = engineLoadDFF ( "img/MotorcycleHelmet2.dff" )
engineReplaceModel ( dff, 3092 )
