local sw, sh = guiGetScreenSize()
Async:setPriority("medium")

local gasEffect = true 
class "CGas"
{
	__init__ = function(self, x, y, z, startRadius, endRadius, time)
		self.x, self.y, self.z = x, y, z
		
		self.startRadius = startRadius
		local dist = getDistanceBetweenPoints2D(x, y, 0, 0)
		self.startRadius = self.startRadius+dist
		
		self.radius = self.startRadius
		self.endRadius = endRadius
	
		self.data = {} 
		
		self.texture = dxCreateTexture("white.png")
		
		for i = 0, 360 do
			local startX = math.cos( math.rad( i ) ) * ( self.radius )
			local startY = math.sin( math.rad( i ) ) * ( self.radius )
	 
			local materialSize = 2 * math.max(5, self.radius/20)
			local mat = CMat3D:create(self.texture, Vector3(x+startX, y+startY, z+100), Vector3(0, 90, i), Vector2( 2500, materialSize))
			mat:setColor(0, 200, 0, 100)
			mat:setClipDistance(1200)
			
			startX = math.cos( math.rad( i ) ) * ( self.endRadius )
			startY = math.sin( math.rad( i ) ) * ( self.endRadius )
			radarAreaSize = 5 * math.max(3, self.endRadius/200), 5 * math.max(3, self.endRadius/200)
			radarEnd = createRadarArea(x+startX, y+startY, radarAreaSize, radarAreaSize, 255, 0, 0, 40)
			setElementDimension(radarEnd, getElementDimension(localPlayer))
			
			startX = math.cos( math.rad( i ) ) * ( self.radius )
			startY = math.sin( math.rad( i ) ) * ( self.radius )
			local radarAreaSize =  5 * math.max(3, self.radius/200), 5 * math.max(3, self.radius/200)
			local radar = createRadarArea(x+startX, y+startY, radarAreaSize, radarAreaSize, 0, 200, 0, 100)
			setElementDimension(radar, getElementDimension(localPlayer))
			
			table.insert(self.data, {mat, radar, radarEnd})
		end
		
		self.hpTick = 0 
		
		self.startTime = getTickCount()
		self.time = getTickCount()+(time*60000)
		self.radarAreaRefresh = getTickCount()+1000
		self.updateTick = getTickCount()+1000 
		self.endResize = false 
		
		self.renderFunc = function() self:onRender() end 
		addEventHandler("onClientPreRender", root, self.renderFunc, true, "low-5")
	
		setTimer(function() exports["br_notifications"]:addNotification("Możesz wyłączyć efekt gazu klawiszem F5 pozastawiając samą strefę radarową.", "info") end, 5000, 1)
	end,
	
	destroy = function(self)
		for k,v in ipairs(self.data) do 
			v[1]:destroy()
			v[2]:destroy()
			v[3]:destroy()
		end
		
		self.data = {} 
		removeEventHandler("onClientPreRender", root, self.renderFunc)
	end, 
	
	resizeToRadius = function(self, radius)
		if not radius then return end 
		local now = getTickCount() 
		
		self.radius = radius 
		
		local k = 0 
		Async:setPriority("low")
		Async:foreach(self.data, function(v)
			k = k+1 
			local startX = math.cos( math.rad( k ) ) * ( self.radius )
			local startY = math.sin( math.rad( k ) ) * ( self.radius )
	 
			local materialSize = 2.75 * math.max(5, self.radius/20)
			self.data[k][1]:setSize(Vector2(2500, materialSize))
			self.data[k][1]:setPosition(Vector3(self.x+startX, self.y+startY, self.z))
			
			if now >= self.radarAreaRefresh then 
				destroyElement(self.data[k][2])
				local radarAreaSize =  5 * math.max(3, self.radius/200), 5 * math.max(3, self.radius/200)
				local radar = createRadarArea(self.x+startX, self.y+startY, radarAreaSize, radarAreaSize, 0, 200, 0, 100)
				setElementDimension(radar, getElementDimension(localPlayer))
			
				self.data[k][2] = radar

				if k == 360 then self.radarAreaRefresh = getTickCount()+1000  end 
			end 
		end) 
		
	end, 
	
	onRender = function(self)				
		local now = getTickCount()
		
		local x,y,z = getElementPosition(localPlayer)
		local dist = getDistanceBetweenPoints2D(x, y, self.x, self.y)
		if dist > self.radius then 
			dxDrawRectangle(0, 0, sw, sh, tocolor(0, 200, 0, 150))
			
			if now >= self.hpTick then 
				setElementHealth(localPlayer, getElementHealth(localPlayer)-0.4)
				self.hpTick = now+50
			end 
		end 
		
		if now >= self.updateTick and not self.endResize then
			self.updateTick = getTickCount()+300
			
			local progress =  (now-self.startTime)/(self.time-self.startTime)
			if progress < 1 then 
				self:resizeToRadius(self.startRadius-(self.startRadius-self.endRadius)*progress)
			else 
				self.endResize = true 
				self:resizeToRadius(self.endRadius)
			end
		end
		
		if gasEffect then 
			for k,v in ipairs(self.data) do 
				v[1]:draw()
			end
		end 
	end,
}

function onClientCreateGas(x, y, z, startRadius, endRadius, time)
	gas = CGas(x, y, z, startRadius, endRadius, time)
end
addEvent("onClientCreateGas", true)
addEventHandler("onClientCreateGas", root, onClientCreateGas)

function onClientDestroyGas()
	if gas then 
		gas:destroy()
	end 
end 
addEvent("onClientDestroyGas", true)
addEventHandler("onClientDestroyGas", root, onClientDestroyGas)

function enableGasEffect()
	if gasEffect then 
		gasEffect = false
		exports["br_notifications"]:addNotification("Efekt gazu wyłączony.", "info")
	else 
		gasEffect = true
		exports["br_notifications"]:addNotification("Efekt gazu włączony.", "info")
	end
end 
bindKey("F5", "down", enableGasEffect)

setTimer(collectgarbage, 1000, 0)