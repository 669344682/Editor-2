---------------------
-----// Misc \\------


addEventHandler( "onClientResourceStop", resourceRoot,
function (	)
	if global.Camera then
		functions.Camera()
	end
end
)

function functions.DrawGimbal()
	if isThereSelected() then
		local center = xSize/2
		local cposition = center-((100*s)/2)
		local lposition = cposition-(105*s)
		local rposition = cposition+(105*s)
		
		local yposition = ySize-(82*s)
		dxDrawText ( 'Position',lposition-(60*s), yposition, lposition, yposition+(30*s), tocolor ( 255, 255, 255, 150	), 1.02, "arial",'center','center'	 )
		X,Y,Z = getSelectedElementsCenterI()
		dxDrawEditBox(lposition,yposition, 100*s, 30*s,1.3*s,'arial',tocolor(255, 100, 100, 255),'x',math.floor(X*100)/100,true,tocolor(0, 0, 0, 200),{255, 100, 100},true) 
		dxDrawEditBox(cposition,yposition, 100*s, 30*s,1.3*s,'arial',tocolor(100, 255, 100, 150),'y',math.floor(Y*100)/100,true,tocolor(0, 0, 0, 200),{100, 255, 100},true)	
		dxDrawEditBox(rposition,yposition, 100*s, 30*s,1.3*s,'arial',tocolor(100, 100, 255, 150),'z',math.floor(Z*100)/100,true,tocolor(0, 0, 0, 200),{100, 100, 255},true) ---// Possibly figure out how to floor to a spefic value and replace.
		Xr,Yr,Zr = getSelectedElementsRotations()
		local yposition = ySize-(50*s)
		
		if Xr and Yr and Zr then
			dxDrawText ( 'Rotation',lposition-(60*s), yposition, lposition, yposition+(30*s), tocolor ( 255, 255, 255, 150 ), 1.02, "arial",'center','center'	)
			dxDrawEditBox(lposition,yposition, 100*s, 30*s,1.3*s,'arial',tocolor(255, 100, 100, 255),'xr',math.floor(Xr*100)/100,true,tocolor(0, 0, 0, 200),{255, 100, 100},true) 
			dxDrawEditBox(cposition,yposition, 100*s, 30*s,1.3*s,'arial',tocolor(100, 255, 100, 150),'yr',math.floor(Yr*100)/100,true,tocolor(0, 0, 0, 200),{100, 255, 100},true)	
			dxDrawEditBox(rposition,yposition, 100*s, 30*s,1.3*s,'arial',tocolor(100, 100, 255, 150),'zr',math.floor(Zr*100)/100,true,tocolor(0, 0, 0, 200),{100, 100, 255},true) 
		end
		
		if freeMove then
			dxDrawText ( 'Free Move Enabled',lposition, yposition-(60*s), rposition+(100*s), yposition-(30*s), tocolor ( 255, 0, 0, 150	), 1.02, "arial",'center','center'	 )
		end
	end
	
		
		
	if global['Mode'] then
		if isThereSelected() then
			if global['Mode'] == 'Movement' then
					local x,y,z = getSelectedElementsCenter()
					
					sL = {x,y,z}
				
				
				local xA,yA,zA = functions['getPosition'](8,0,0)
				if lHover == 'x' then
					dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(255,0,0,255), 10,true)
				else
					dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(255,0,0,255), 5,true)
				end
				
				local xA,yA,zA = functions['getPosition'](0,8,0)
				if lHover == 'y' then
					dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,255,0,255), 10,true)
				else
					dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,255,0,255), 5,true)
				end
				
				local xA,yA,zA = functions['getPosition'](0,0,8)
				if lHover == 'z' then
					dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,0,255,255), 10,true)
				else
					dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,0,255,255), 5,true)
				end
					
				elseif global['Mode'] == 'Rotation' then
					local x,y,z = getSelectedElementsCenter()
					local cX,xY,cZ,cX1,xY1,cZ1 = getCameraMatrix()

					
					if isCursorShowing() then
						setElementPosition(circles[1],x,y,z)
						setElementPosition(circles[2],x,y,z)
						setElementPosition(circles[3],x,y,z)
					else
						functions.resetCircles()
					end
					
					local xA,yA,zA = functions['getPosition'](5,0,0)
					local xB,yB,zB = functions['getPosition'](-5,0,0)
					local xC,yC,zC = functions['getPosition'](0,0,100)
					local xD,yD,zD = functions['getPosition'](0,0,-100)
					local xr,yr,zr = findRotation3D(x,y,z,xC,yC,zC) 

					setElementRotation(circles[3],xr-90,yr,zr)

					if lHover == 'zr' then
						dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, functions.prepImage('CircleSelected',true), 10,tocolor(0,0,255,255),false,xC,yC,zC)
					else
						dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, functions.prepImage('circle',true), 10,tocolor(0,0,255,255),false,xC,yC,zC)
					end
					
					local disZ = (getDistanceBetweenPointAndSegment3D(cX,xY,cZ, xC,yC,zC,xD,yD,zD) + getDistanceBetweenPointAndSegment3D(cX1,xY1,cZ1, xC,yC,zC,xD,yD,zD))/2

					local xC,yC,zC = functions['getPosition'](0,100,0)
					local xD,yD,zD = functions['getPosition'](0,-100,0)
					local xr,yr,zr = findRotation3D(x,y,z,xC,yC,zC) 
					setElementRotation(circles[2],xr-90,yr,zr)
					
					
					if lHover == 'yr' then
						dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, functions.prepImage('CircleSelected',true), 10,tocolor(0,255,0,255),false,xC,yC,zC)
					else
						dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, functions.prepImage('circle',true), 10,tocolor(0,255,0,255),false,xC,yC,zC)
					end
					
					local disY = (getDistanceBetweenPointAndSegment3D(cX,xY,cZ, xC,yC,zC,xD,yD,zD) + getDistanceBetweenPointAndSegment3D(cX1,xY1,cZ1, xC,yC,zC,xD,yD,zD))/2
					
					local xA,yA,zA = functions['getPosition'](0,5,0)
					local xB,yB,zB = functions['getPosition'](0,-5,0)
					local xC,yC,zC = functions['getPosition'](100,0,0)
					local xD,yD,zD = functions['getPosition'](-100,0,0)
					local xr,yr,zr = findRotation3D(x,y,z,xC,yC,zC) 
					setElementRotation(circles[1],xr-90,yr,zr)
 
					if lHover == 'xr' then
						dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, functions.prepImage('CircleSelected',true), 10,tocolor(255,0,0,255),false,xC,yC,zC)
					else
						dxDrawMaterialLine3D(xB,yB,zB,xA,yA,zA, functions.prepImage('circle',true), 10,tocolor(255,0,0,255),false,xC,yC,zC)
					end
					
					local disX = (getDistanceBetweenPointAndSegment3D(cX,xY,cZ, xC,yC,zC,xD,yD,zD) + getDistanceBetweenPointAndSegment3D(cX1,xY1,cZ1, xC,yC,zC,xD,yD,zD))/2
					
					local minDis = math.min(disX,disY,disZ) 
					
					if minDis == disX then
						lRotationalAxis = 'X'
					elseif minDis == disY then
						lRotationalAxis = 'Y'
					else 
						lRotationalAxis = 'Z'
					end
					
				else
					local x,y,z = getSelectedElementsCenter()
					local xA,yA,zA = functions['getPosition'](8,0,0)
					if lHover == 'sx' then
						dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(255,0,0,255), 10,true)
					else
						dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(255,0,0,255), 5,true)
					end
					
					local xA,yA,zA = functions['getPosition'](0,8,0)
					if lHover == 'sy' then
						dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,255,0,255), 10,true)
					else
						dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,255,0,255), 5,true)
					end
					
					local xA,yA,zA = functions['getPosition'](0,0,8)
					if lHover == 'sz' then
						dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,0,255,255), 10,true)
					else
						dxDrawLine3D (x,y,z,xA,yA,zA,tocolor(0,0,255,255), 5,true)
					end
				end
			if not ignoreGimbal then
				functions.isOnMovementGamble()
				else
				lHover = nil
			end
		end
	end
end


function functions.getCircleSide (input)
	local xa,ya = getCursorPosition()
	local xa,ya = xa*xSize,ya*ySize
	local xb,yb,zb = getCameraMatrix()
	local xc,yc,zc = getElementPosition(circles[cSides[input]])
	local x,y,z = getWorldFromScreenPosition (xa,ya, getDistanceBetweenPoints3D(xb,yb,zb,xc,yc,zc ))
	local matrix = circles[cSides[input]].matrix
	local Left = matrix:transformPosition(Vector3(0,10,0))
	local Right = matrix:transformPosition(Vector3(0,-10,0))
	
	local L = {Left.x,Left.y,Left.z}
	local left = getDistanceBetweenPoints3D(L[1],L[2],L[3],x,y,z)
	local R = {Right.x,Right.y,Right.z}
	local right = getDistanceBetweenPoints3D(R[1],R[2],R[3],x,y,z)
	if (left > right) then
		reverseD = -1
	else
		reverseD = 1
	end
	return reverseD
end


function functions.isOnMovementGamble()
	if not isCursorShowing() then
		functions.resetCircles()
	end
	
	if global['Mode'] == 'Movement' then
		if sL and sL[1] and isCursorShowing() and not getKeyState('mouse1') then
			
			local cx,cy = getCursorPosition()
			local cx,cy = cx*xSize,cy*ySize
				
			local x,y,z = getSelectedElementsCenter()
			
			local xA,yA,zA = functions['getPosition'](8,0,0)
			local xX,xY = getScreenFromWorldPosition(xA,yA,zA,1000)
			
			local xA,yA,zA = functions['getPosition'](0,8,0)
			local yX,yY = getScreenFromWorldPosition(xA,yA,zA,1000)
			
			local xA,yA,zA = functions['getPosition'](0,0,8)
			local zX,zY = getScreenFromWorldPosition(xA,yA,zA,1000)
				
			local x,y = getScreenFromWorldPosition(x,y,z,1000)
			
			if xX then
				if (getDistanceBetweenPointAndSegment2D(cx, cy,x, y, xX,xY) or 6) < 5 then
					lHover = 'x'
					return
				end
			end
			if yX then
				if (getDistanceBetweenPointAndSegment2D(cx, cy,x, y, yX,yY) or 6) < 5 then
					lHover = 'y'
					return
				end
			end
			if yX then
				if (getDistanceBetweenPointAndSegment2D(cx, cy,x, y, zX,zY) or 6) < 5 then
					lHover = 'z'
					return
				end
			end
				lHover = nil
		end
	elseif global['Mode'] == 'Rotation' then
		if isCursorShowing() and (not getKeyState('mouse1')) then
			local xa,ya,za = getSelectedElementsCenter()
			local hit,x,y,z = isCursorOnWorldElement(circles[1])
			if hit then
				functions['getCircleSide']('xr')
	
				lHover = 'xr'
				return
			end
			
			local hit,x,y,z = isCursorOnWorldElement(circles[2])
			
			if hit then
				functions['getCircleSide']('yr')
				lHover = 'yr'
				return
			end
			
			local hit,x,y,z = isCursorOnWorldElement(circles[3])
			
			if hit then
				functions['getCircleSide']('zr')
				lHover = 'zr'
				return
			end
			reverseD = nil
			lHover = nil
		end
	else
		if isCursorShowing() and not getKeyState('mouse1') then
			
			local cx,cy = getCursorPosition()
			local cx,cy = cx*xSize,cy*ySize
				
			local x,y,z = getSelectedElementsCenter()
			
			local xA,yA,zA = functions['getPosition'](8,0,0)
			local xX,xY = getScreenFromWorldPosition(xA,yA,zA,1000)
			
			local xA,yA,zA = functions['getPosition'](0,8,0)
			local yX,yY = getScreenFromWorldPosition(xA,yA,zA,1000)
			
			local xA,yA,zA = functions['getPosition'](0,0,8)
			local zX,zY = getScreenFromWorldPosition(xA,yA,zA,1000)
				
			local x,y = getScreenFromWorldPosition(x,y,z,1000)
			
			if xX then
				if (getDistanceBetweenPointAndSegment2D(cx, cy,x, y, xX,xY) or 6) < 5 then
					lHover = 'sx'
					return
				end
			end
			if yX then
				if (getDistanceBetweenPointAndSegment2D(cx, cy,x, y, yX,yY) or 6) < 5 then
					lHover = 'sy'
					return
				end
			end
			if yX then
				if (getDistanceBetweenPointAndSegment2D(cx, cy,x, y, zX,zY) or 6) < 5 then
					lHover = 'sz'
					return
				end
			end
			lHover = nil
		end
	end
	if not getKeyState('mouse1') then
		reverseD = nil
		lHover = nil
	end
end


function functions.refreshMovements (Xa,Ya,Za,Xra,Yra,Zra)
	X,Y,Z = getSelectedElementsCenterI()
	Xr,Yr,Zr = getSelectedElementsRotations()
	if X and Y and Z then
		refreshString((math.floor((Xa or X)*100)/100),'x',true)
		refreshString((math.floor((Ya or Y)*100)/100),'y',true)
		refreshString((math.floor((Za or Z)*100)/100),'z',true)
	end
	if Xr and Yr and Zr then
		refreshString((math.floor((Xra or Xr)*100)/100),'xr',true)
		refreshString((math.floor((Yra or Yr)*100)/100),'yr',true)
		refreshString((math.floor((Zra or Zr)*100)/100),'zr',true)
	end
end


toggle = false

function functions.isCursorOnElement( posX, posY, width, height,inputA,inputB,inputC,inputD,inputE ) -- Gonna change this later to simplify it.
	if isCursorShowing( ) then
		if global.scrollT	then return false end
		local mouseX, mouseY = getCursorPosition( )
		local clientW, clientH = guiGetScreenSize( )
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			if inputA then
					ignoreGimbal = not (lMovement) -- Pretty much adds priority to the menu
				if lHover then return false end 
			
				if inputA == 'Option' then
					Option = math.max(Option,1)
				end	
						
					if getKeyState('mouse1') then
						if not toggle then
							if functions[inputA] then
								functions[inputA](inputB,inputC,inputD,inputE) -- When you click a 'Button' then it'll trigger this.
							end
						end
					end
				toggle = getKeyState('mouse1')
			end
			return true
		end
	end
end

holdname = false -- Don't question it.

function functions.isCursorOnElementAlt( posX, posY, width, height,optionA,optionB,optionC,optionD )
	if not getKeyState('mouse1') then
		return functions[optionA]()
	end
	if isCursorShowing( ) then
		local mouseX, mouseY = getCursorPosition( )
		local clientW, clientH = guiGetScreenSize( )
		local mouseX, mouseY = mouseX * clientW, mouseY * clientH
		if ( mouseX > posX and mouseX < ( posX + width ) and mouseY > posY and mouseY < ( posY + height ) ) then
			if getKeyState('mouse1') then
				return functions[optionA](optionB,optionC,optionD)
			else
				return functions[optionA]()
			end
			return true
		end
	end
end


function functions.scroll (name)
	global.scrollT = name
	return true
end

oldx = 0
oldy = 0

countc = 20

function functions.onCursorMove ( _, _, x, y )

	if (lHoverO == lHover) and ((global['Move Type'] == 'Local') or (isThereSelected(true) or 0) > 1) then
		if (lHover == 'x') or (lHover == 'y') or (lHover == 'z') then
			functions.refreshMovements(GXa,GYa,GZa)
		else
			functions.refreshMovements(nil,nil,nil,GXra,GYra,GZra)
		end
	else
		GXa,GYa,GZa,GXra,GYra,GZra = 0,0,0,0,0,0
		functions.refreshMovements()
	end
	lHoverO = lHover
	
	
	if lHover then
		if x > (xSize-5) then
			oldx = 10
			oldy = y
			setCursorPosition ( oldx, oldy )
			return
		elseif y > (ySize-5) then
			oldx = x
			oldy = 10
			setCursorPosition ( oldx, oldy )
			return
		elseif x < 5 then
			oldx = xSize-10
			oldy = y
			setCursorPosition ( oldx, oldy )
			return
		elseif y < 5 then
			oldx = x
			oldy = ySize-10
			setCursorPosition ( oldx, oldy )
			return
		end
	end
			
		local movex = x-oldx
		local movey = y-oldy

		local oX,oY,oZ = getWorldFromScreenPosition (oldx,oldy,20)
		local nX,nY,nZ = getWorldFromScreenPosition (x,y,20)
		
		local fix = ((nX+nY+nZ)-(oX+oY+oZ))
		
		
		local multiplier = getKeyState('lshift') and 2 or (getKeyState('lalt') and 0.1 or 1)

		
		local distance = getDistanceBetweenPoints3D(oX,oY,oZ,nX,nY,nZ)*multiplier
		
		oldy = y
		oldx = x
		
	if global.scrollT then
		global[global.scrollT] = global[global.scrollT] + movey
	end
	
	countc = countc + 1
	if countc == math.max((global.snap or 0)/2,20) or (not global.snap) then
		countc = 0
		
		local distance = ((global.snap or distance)*(reverseD or 1))
		
		lMovement = nil
		if getKeyState('mouse1') and lHover then
			lMovement = true
			if lHover == 'x' then
				local distance = (oX>nX) and (-distance) or distance
				setElementPositions(distance/2,0,0)
			elseif lHover == 'y' then
				local distance = (oY>nY) and (-distance) or distance
				setElementPositions(0,distance/2,0)
			elseif lHover == 'z' then
				local distance = (oZ>nZ) and (-distance) or distance
				setElementPositions(0,0,distance/2)
			elseif lHover == 'xr' then
				local distance = (fix > 0) and (-distance) or distance
				setElementRotations(-distance,0,0)
			elseif lHover == 'yr' then
				local distance = (fix > 0) and (-distance) or distance
				setElementRotations(0,distance,0)
			elseif lHover == 'zr' then
				local distance = (fix > 0) and (-distance) or distance
				setElementRotations(0,0,distance)
			elseif lHover == 'sx' then
				local distance = (oX>nX) and (-distance) or distance
				setElementScales(distance/2,0,0)
			elseif lHover == 'sy' then
				local distance = (oY>nY) and (-distance) or distance
				setElementScales(0,distance/2,0)
			elseif lHover == 'sz' then
				local distance = (oZ>nZ) and (-distance) or distance
				setElementScales(0,0,distance/2)
			end
		end
	end
end

addEventHandler( "onClientCursorMove", getRootElement( ),functions.onCursorMove)


function functions.selectElement ()
	functions.updatePositions()
	if getHighLightedElement() and (not lHover) and not getKeyState('space') then
			if (not isCursorShowing()) then
			selectedElements[getHighLightedElement()] = not selectedElements[getHighLightedElement()]
			if not selectedElements[getHighLightedElement()] then
				setElementCollisionsEnabled(getHighLightedElement(),true)
				setElementFrozen(getHighLightedElement(),false)
				callS('freezeElement',getHighLightedElement(),false)
				selectedElements[getHighLightedElement()] = nil
			end
		end
	end
end


-----\\ Misc //-----
--------------------