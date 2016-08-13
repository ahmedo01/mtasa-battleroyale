
local me = getLocalPlayer()


function Initialize()
	LoadSettings()
end
Initialize()


local SpeedBuffer = {}
local BufferIndex = 1
function GetVehicleSpeed(vehicle, bufferSize)
	local x, y, z = getElementVelocity(vehicle)
	local speed = math.sqrt(x^2 + y^2 + z^2) * 100 * g_Settings.SpeedMultiplier

	-- average the speed over a few frames	
	SpeedBuffer[BufferIndex] = speed

	BufferIndex = BufferIndex + 1 
	if BufferIndex > bufferSize then
		BufferIndex = 1
	end
	
	local ret = 0
	for k,v in pairs(SpeedBuffer) do
		ret = ret + v
	end
	-- round the result
	return math.floor(ret / #SpeedBuffer + 0.5)
end


function UpdateDisplay()
	local vehicle = getPedOccupiedVehicle(me)
	if not (vehicle and g_Settings.Visible) then
		hideSpeedometer()
		return
	end

	-- get the speed averaged over 7 frames
	local speed = GetVehicleSpeed(vehicle, 7)

	g_GuiLabel.Speed:text(tostring(speed))
end


function showSpeedometer()
	GuiShow()
	if g_Settings.Visible then
		addEventHandler("onClientRender", root, UpdateDisplay)
	end
end
addEventHandler("onClientPlayerVehicleEnter", me, showSpeedometer)


function hideSpeedometer()
	GuiHide()
	removeEventHandler("onClientRender", root, UpdateDisplay)
end
addEventHandler("onClientPlayerVehicleExit", me, hideSpeedometer)


addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		if getPedOccupiedVehicle(getLocalPlayer()) then
			showSpeedometer()
		end
	end
)


addEventHandler("onClientPlayerWasted", me, 
	function()
		if source == me then
			hideSpeedometer()
		end
	end
)