------------------------------------
--// Magnets and Bounding Boxes \\--

functions.drawMagnets = function ()
	if isThereSelected() and global.Mangets and freeMove then
		local xb,yb,zb = getCameraMatrix()
		for i,v in pairs(getAllElements(true,true)) do
			local m = magnets[v]
			local xa,ya,za = getElementPosition(v)
			if (getDistanceBetweenPoints3D (xa,ya,za,xb,yb,zb) < 50) and m then
				for iA = 1,8 do
				
					if mClose[v] and mClose[v][iA] then
						dxDrawLine3D ( m[iA].x+0.05,m[iA].y+0.05,m[iA].z+0.05,m[iA].x-0.05,m[iA].y-0.05,m[iA].z-0.05,tocolor(255,50,50), 10*s,true)
					else
						dxDrawLine3D ( m[iA].x+0.05,m[iA].y+0.05,m[iA].z+0.05,m[iA].x-0.05,m[iA].y-0.05,m[iA].z-0.05,tocolor(50,50,255), 10*s)
					end
				end
			end
		end
	end
end

functions.magnetMovement = function ()
	local element = unpack(mClose.connection)
	
	minDistance = global.Mangets
	
	functions.magnetTimer()
	functions.checkMagnets(element)
	
	local _,vector = unpack(mClose.connection)
	setElementPositions(vector.x,vector.y,vector.z,true,true)
end


functions.prepMagnets = function (element)
	if freeMove and global.Mangets and (not (getElementID(element) == 'skybox_model')) then
		local xa,ya,za,xb,yb,zb = getElementBoundingBox (element)
		if xa then
			local matrix = element.matrix
				
			if getElementType(element) == 'object' then
				local sX,sY,sZ = getObjectScale(element)	
				xa,ya,za,xb,yb,zb = xa*sX,ya*sY,za*sZ,xb*sX,yb*sY,zb*sZ
			end
		
			local tFL = matrix:transformPosition(Vector3(xa,ya,za)) -- Top front left
			local tFR = matrix:transformPosition(Vector3(-xa,ya,za)) -- Top front right
			local tRL = matrix:transformPosition(Vector3(xa,-ya,za)) -- Top rear left
			local tRR = matrix:transformPosition(Vector3(-xa,-ya,za)) -- Top rear right
			local bFL = matrix:transformPosition(Vector3(-xb,-yb,zb)) -- Bottom front left
			local bFR = matrix:transformPosition(Vector3(xb,-yb,zb)) -- Bottom front right
			local bRL = matrix:transformPosition(Vector3(-xb,yb,zb)) -- Bottom rear left
			local bRR = matrix:transformPosition(Vector3(xb,yb,zb)) -- Bottom rear right

			magnets[element] = {tFL,tFR,tRL,tRR,bFL,bFR,bRL,bRR}
		end
	end
end

local positions = {}

functions.magnetTimer = function ()
	if freeMove and isThereSelected() and global.Mangets then
		for i,element in pairs(getAllElements(true,true)) do -- // Only prep magnets of streamed in crap on screen
			local x,y,z = getElementPosition(element)
			positions[element] = positions[element] or {}
			if (not(x == positions[element][1]) or not(y == positions[element][2]) or not(z == positions[element][3])) then
				functions.prepMagnets(element)
				positions[element] = {x,y,z}
			end
		end
	end
end

minDistance = global.Mangets or 500

functions.checkMagnets = function (element)
    if global.Mangets and magnets[element] and isElementOnScreen ( element ) and freeMove then
        local x,y,z = getElementPosition(element)
        local cx,cy,cz = getCameraMatrix()
        local sqrt = math.sqrt
        if getDistanceBetweenPoints3D(x,y,z,cx,cy,cz) < (selectionDepth*2) then
            for mElement,mMagnets in pairs(magnets) do
                if (not selectedElements[mElement]) and isElement(mElement) and isElementOnScreen(mElement) then
                    local ex,ey,ez = getElementPosition(mElement)
					local dist = (getDistanceBetweenPoints3D(x,y,z,ex,ey,ez) + getElementRadius(mElement))
					if dist < minODistance then
						minODistance = (math.max(dist,(getElementRadius(mElement)-1)))
						if (getDistanceBetweenPoints3D(cx,cy,cz,ex,ey,ez) < (selectionDepth*2)) then
							for i,v in pairs(mMagnets) do
								for ia,va in pairs(magnets[element]) do
									local distance = getDistanceBetweenPoints3D(va.x,va.y,va.z,v.x,v.y,v.z)
									if (distance < minDistance) then
										minDistance = distance
										mClose[element] = {}
										mClose[element][ia] = true
										mClose[mElement] = {}
										mClose[mElement][i] = true
										mClose.connection = {element,Vector3(v.x-va.x,v.y-va.y,v.z-va.z)}
									end
								end
							end
						end
					end
                end
            end
        end
    end
end

setTimer ( functions.magnetTimer, 1000, 0 )


functions.boundingBox = function (element,hover,global)
	local xa,ya,za,xb,yb,zb = getElementBoundingBox ( element )
	
	local xa = (xa or -0.5)
	local ya = (ya or -0.5)
	local za = (za or -0.5)
	local xb = (xb or 0.5)
	local yb = (yb or 0.5)
	local zb = (zb or 0.5)
	
	local xa = math.min(xa,-xa)
	local ya = math.min(ya,-ya)
	local za = math.min(za,-za)
	local xb = math.max(xb,-xb)
	local yb = math.max(yb,-yb)
	local zb = math.max(zb,-zb)
	
	if xa then
	--	local xb,yb,zb = -xa,-ya,-za --// Removed the last part because we need perfect squares.
		
		local matrix = element.matrix
		
		if getElementType(element) == 'object' then
			local sX,sY,sZ = getObjectScale(element)	
			xa,ya,za,xb,yb,zb = xa*sX,ya*sY,za*sZ,xb*sX,yb*sY,zb*sZ
		end
		


		local m1 = matrix:transformPosition(Vector3(xa,ya,za)) 		-- Top front left
		local m2 = matrix:transformPosition(Vector3(-xa,ya,za))		-- Top front right
		local m3 = matrix:transformPosition(Vector3(xa,-ya,za)) 	-- Top rear left
		local m4 = matrix:transformPosition(Vector3(-xa,-ya,za)) 	-- Top rear right
		
		local m5 = matrix:transformPosition(Vector3(-xb,-yb,zb))    -- Bottom front left
		local m6 = matrix:transformPosition(Vector3(xb,-yb,zb)) 	-- Bottom front right
		local m7 = matrix:transformPosition(Vector3(-xb,yb,zb)) 	-- Bottom rear left
		local m8 = matrix:transformPosition(Vector3(xb,yb,zb)) 	 	-- Bottom rear right
		
		local x1,y1,z1 = m1.x,m1.y,m1.z
		local x2,y2,z2 = m2.x,m2.y,m2.z
		local x3,y3,z3 = m3.x,m3.y,m3.z
		local x4,y4,z4 = m4.x,m4.y,m4.z
		
		local x5,y5,z5 = m5.x,m5.y,m5.z
		local x6,y6,z6 = m6.x,m6.y,m6.z
		local x7,y7,z7 = m7.x,m7.y,m7.z
		local x8,y8,z8 = m8.x,m8.y,m8.z
		
		
		local cColor = nil

		if global then
			cColor =	tocolor ( 255, 50, 0, 230 )
		end

		if selectedElements[element] then
			cColor =	tocolor ( 255, 0, 0, 230 )
		end

		if hover then
			cColor =	tocolor ( 255, 180, 0, 230 )
		end

		if hover and selectedElements[element] then
			cColor =	tocolor ( 0, 0, 255, 230 )
		end


		
		dxDrawLine3D ( x1,y1,z1,x2,y2,z2,cColor, 3) -- TFL -> TFR
		dxDrawLine3D ( x1,y1,z1,x5,y5,z5,cColor, 3) -- TFL -> BFL
		dxDrawLine3D ( x1,y1,z1,x3,y3,z3,cColor, 3) -- TFL -> TRL

		dxDrawLine3D ( x2,y2,z2,x4,y4,z4,cColor, 3) -- TFR -> TRR
		dxDrawLine3D ( x2,y2,z2,x6,y6,z6,cColor, 3) -- TFR -> BFR

		dxDrawLine3D ( x4,y4,z4,x3,y3,z3,cColor, 3) -- TRR -> TRL
		dxDrawLine3D ( x4,y4,z4,x8,y8,z8,cColor, 3) -- TRR -> BRR

		dxDrawLine3D ( x7,y7,z7,x3,y3,z3,cColor, 3) -- BRL -> TRL
		dxDrawLine3D ( x7,y7,z7,x5,y5,z5,cColor, 3) -- BRL -> BFL
		dxDrawLine3D ( x7,y7,z7,x8,y8,z8,cColor, 3) -- BRL -> BRR

		dxDrawLine3D ( x6,y6,z6,x8,y8,z8,cColor, 3) -- BFR -> BRR
		dxDrawLine3D ( x6,y6,z6,x5,y5,z5,cColor, 3) -- BFR -> BRR
	end
end

--\\ Magnets and Bounding Boxes //--
------------------------------------
------------------------------------
---// Setting Saving functions \\---


addEventHandler( "onClientResourceStop", resourceRoot,
    function ( )
		local info = toJSON(global)
		local newFile = fileCreate("Cache/settings.JSON")   
		if (newFile) then          
			fileWrite(newFile,info)
			fileClose(newFile)     
		end
    end
);


if fileExists('Cache/settings.JSON') then
	local file = fileOpen ('Cache/settings.JSON')
	local content = fileRead(file, fileGetSize(file))
	global = fromJSON(content)
	fileClose(file)
end

---\\ Setting Saving functions //---
------------------------------------
