--
-- file: c_material3D.lua
-- version: v1.5
-- author: Ren712
--
    
CMat3D = { }
CMat3D.__index = CMat3D

-- texture or renderTarget, worldPosition Vector3(), rotation Vector3(deg) , size Vector2(0-n,0-n)   
function CMat3D: create( texture, pos, rot, siz )
	local cShader = {
		shader = dxCreateShader( "fx/material3D.fx", 0, 700, false, "other"),
		texture = texture,
		color = tocolor(255, 255, 255, 255),
		texCoord = {Vector2(1, 1),Vector2(0, 0)},
		position = pos,
		rotation = rot,
		size = siz,
		billboard = false,
		clip = 700,
		zEnable = true,
		zWriteEnable = false,
		flipVertex = false,
		fogEnable = true,
		cullMode = 1
	}
	if cShader.shader then
		-- pass position and a forward vector to recreate gWorld matrix
		cShader.shader:setValue( "sElementRotation", math.rad( rot.x ), math.rad( rot.y ), math.rad( rot.z ))
		cShader.shader:setValue( "sElementPosition", pos.x, pos.y, pos.z )
		cShader.shader:setValue( "sElementSize", siz.x, siz.y )
		cShader.shader:setValue( "sFlipTexture", false )
		cShader.shader:setValue( "sFlipVertex", cShader.flipVertex )
		cShader.shader:setValue( "sIsBillboard", cShader.billboard )
		
		cShader.shader:setValue( "uvMul", cShader.texCoord[1].x, cShader.texCoord[1].y )
		cShader.shader:setValue( "uvPos", cShader.texCoord[2].x, cShader.texCoord[2].y )
		cShader.shader:setValue( "sFogEnable", cShader.fogEnable )
		cShader.shader:setValue( "fZEnable", cShader.zEnable )
		cShader.shader:setValue( "fZWriteEnable", cShader.zWriteEnable )
		cShader.shader:setValue( "fCullMode", cShader.cullMode )		
		-- set texture
		cShader.shader:setValue( "sTexColor", cShader.texture )
		self.__index = self
		setmetatable( cShader, self )
		return cShader
	else
		return false
	end
end

function CMat3D: setClipDistance( clipDist )
	if self.shader then
		self.clip = clipDist
	end
end

function CMat3D: setTexture( texture )
	if self.shader then
		self.texture = texture
		self.shader:setValue( "sTexColor", self.texture )		
	end
end

function CMat3D: setPosition( pos )
	if self.shader then
		self.position = pos
		self.shader:setValue( "sElementPosition", pos.x, pos.y, pos.z )
	end
end

function CMat3D: setCullMode( cull )
	if self.shader then
		self.cullMode = cull
		self.shader:setValue( "fCullMode", cull )
	end
end

function CMat3D: setZEnable( isEnabled )
	if self.shader then
		self.zEnable = isBill
		self.shader:setValue( "fZEnable", self.zEnable )
	end
end

function CMat3D: setZWriteEnable( isEnabled )
	if self.shader then
		self.zWriteEnable = isBill
		self.shader:setValue( "fZWriteEnable", self.zWriteEnable )
	end
end

function CMat3D: setFogEnable( isEnabled )
	if self.shader then
		self.fogEnable = isBill
		self.shader:setValue( "fFogEnable", self.fogEnable )
	end
end

function CMat3D: setFlipVertex( flip )
	if self.shader then
		self.flipVertex = flip
		self.shader:setValue( "sFlipVertex", flip )
	end
end

-- rotation order "ZXY"
function CMat3D: setRotation( rot )
	if self.shader then
		self.rotation = rot
		self.shader:setValue( "sElementRotation", math.rad( rot.x ), math.rad( rot.y ), math.rad( rot.z ))
	end
end

function CMat3D: setSize( siz )
	if self.shader then
		self.size = siz
		self.shader:setValue( "sElementSize", siz.x, siz.y )
	end
end

function CMat3D: setTexCoord( uvMul, uvPos )
	if self.shader then
		self.texCoord = { uvMul, uvPos }		
		self.shader:setValue( "uvMul", uvMul.x, uvMul.y )
		self.shader:setValue( "uvPos", uvPos.x, uvPos.y )
	end
end

function CMat3D: setBillboard( isBill )
	if self.shader then
		self.billboard = isBill
		self.shader:setValue( "sIsBillboard", self.billboard )
	end
end

function CMat3D: setColor(r, g, b, a)
	if self.shader then
		self.color = tocolor(r, g, b, a)
	end
end

function CMat3D: getObjectToCameraAngle()
	if self.position then
		local camMat = getCamera().matrix
		local camFw = camMat:getForward()
		local elementDir = (self.position - camMat.position):getNormalized()
		return math.acos(elementDir:dot(camFw)/(elementDir.length * camFw.length))
	else
		return false
	end
end


function CMat3D: draw()
	if self.shader then
		if (( self.position - getCamera().matrix.position ).length < self.clip) then
			-- draw the outcome
			dxDrawMaterialLine3D( 0 + self.position.x, 0 + self.position.y, self.position.z + 0.5, 0 + self.position.x, 0 + self.position.y, 
				self.position.z - 0.5, self.shader, 1, self.color, 0 + self.position.x,1 +  self.position.y,0 + self.position.z )
		end
	end
end
        
function CMat3D: destroy()
	if self.shader then
		self.shader:destroy()
	end
	self = nil
end
