
------------------------
--// Screen Scaling \\--

xSize, ySize = guiGetScreenSize()

if xSize > 2000 then
	cursor = true
	s = 1.5
else
	s = (1/math.max(math.min(xSize,1920),1600))*1600
end

--\\ Screen Scaling //--
------------------------

----------------
--// Tables \\--

--#Keyboard Indexing
keyStuff = {}
keyStuff['mouse1'] = ''
keyStuff['mouse2'] = ''
keyStuff['mouse3'] = ''
keyStuff['mouse4'] = ''
keyStuff['mouse5'] = ''
keyStuff['mouse_wheel_up'] = ''
keyStuff['mouse_wheel_down'] = ''
keyStuff['arrow_u'] = ''
keyStuff['arrow_d'] = ''
keyStuff['num_0'] = 0
keyStuff['num_1'] = 1
keyStuff['num_2'] = 2
keyStuff['num_3'] = 3
keyStuff['num_4'] = 4
keyStuff['num_5'] = 5
keyStuff['num_6'] = 6
keyStuff['num_7'] = 7
keyStuff['num_8'] = 8
keyStuff['num_9'] = 9
keyStuff['num_mul'] = '*'
keyStuff['num_add'] = '+'
keyStuff['num_sep'] = ''
keyStuff['num_sub'] = '-'
keyStuff['num_div'] = '/'
keyStuff['num_dec'] = '.'
keyStuff['num_enter'] = ''
keyStuff['escape'] = ''
keyStuff['tab'] = ''
keyStuff['lalt'] = ''
keyStuff['ralt'] = ''
keyStuff['enter'] = ''
keyStuff['space'] = ' '
keyStuff['pgup'] = ''
keyStuff['pgdn'] = ''
keyStuff['end'] = ''
keyStuff['home'] = ''
keyStuff['insert'] = ''
keyStuff['delete'] = ''
keyStuff['lctrl'] = ''
keyStuff['rctrl'] = ''
keyStuff['pause'] = ''
keyStuff['capslock'] = ''
keyStuff['scroll'] = ''
keyStuff['F1'] = ''
keyStuff['F2'] = ''
keyStuff['F3'] = ''
keyStuff['F4'] = ''
keyStuff['F5'] = ''
keyStuff['F6'] = ''
keyStuff['F7'] = ''
keyStuff['F8'] = ''
keyStuff['F9'] = ''
keyStuff['F10'] = ''
keyStuff['F11'] = ''
keyStuff['F12'] = ''
keyStuff['lshift'] = ''
keyStuff['rshift'] = ''

upperCase = {}
upperCase['/'] = '?'
upperCase['.'] = '>'
upperCase[','] = '<'
upperCase[';'] = ':'
upperCase['['] = '{'
upperCase[']'] = '}'
upperCase['-'] = '_'
upperCase['='] = '+'
upperCase['1'] = '!'
upperCase['2'] = '@'
upperCase['3'] = '#'
upperCase['4'] = '$'
upperCase['5'] = '%'
upperCase['6'] = '^'
upperCase['7'] = '&'
upperCase['8'] = '*'
upperCase['9'] = '('
upperCase['0'] = ')'
upperCase['`'] = '~'
upperCase['#'] = "'"
upperCase["'"] = '"'

rebind = {}

rebind['num_sub'] = '-'
rebind['num_add'] = '='
--#Keyboard Indexing

--#Misc
Text = {}
binds = {static = {},dynamic = {},layout = {},check = {}}
buttons = {left = {},right = {}}
functions = {draw = {}}
global = {count = {},open = {},scroll = 0,scrollRight = 0,scrollT = nil,countaddition = 0,Checked = {}}
mapSetting = {menuSettings = {},AlreadyDefault = {}}
magnets = {}
mClose = {}
cSides = {xr=1,yr=2,zr=3}
selectedElements = {}
objects = {}
guiTypes = {}
centerMenu = {}
centerMenuMisc = {}
saveMenu = {Types = {},SType = '.map'}
--#Misc

--\\ Tables //--
----------------

------------------
--// Keyboard \\--

function functions.playerPressedKey(button, press)
	if (press) then 
		if colorpicker.text then
			editBoxC(colorpicker.text,button)
		elseif EditSelected then
			if getKeyState('lshift') then
				dxEdit((upperCase[keyStuff[button] or button] or upperCase[' '..(keyStuff[button] or button)..' '] or string.upper(keyStuff[button] or button)),getKeyState('lshift') and (upperCase[button] or upperCase[' '..button..' '] or string.upper(button)) or button)
			else
				dxEdit(keyStuff[button] or button,button)
			end
		end
		if selectedScroll then
			if button == 'mouse_wheel_up' then
				global[selectedScroll] = global[selectedScroll] - ((15/global.scroll)*10)
			elseif button == 'mouse_wheel_down' then
				global[selectedScroll] = global[selectedScroll] + ((15/global.scroll)*10)
			end
		end
	end
end
addEventHandler("onClientKey", root, functions.playerPressedKey)
addEvent ( "onDxEdit", true )

---- Letter functions (Feel free to ignore) ----
rewrite = {}
rewrite[' . '] = 'dot'
rewrite[' \ '] = 'backslash'
rewrite[' / '] = 'slash' -- Have to use spaces because 'Slash' doesn't like this.
	
	
--\\ Keyboard //--
------------------

-------------------------
--// Image Functions \\--
images = {}

function functions.prepImage(path,mip,edf)
	if path then
		local path = edf and 'EDFImages/'..path..'.png' or 'images/'..path..'.png'


		
		if (not images[path]) and fileExists(path) then
			images[path] = {}
			local img = fileOpen(path)
			local pixels = fileRead(img, fileGetSize(img))
			fileClose(img)
			local x,y = dxGetPixelsSize(pixels)
			images[path].scale = {x,y}
			images[path].image = images[path].image or dxCreateTexture(path,'dxt5',not mip,'clamp')--not mip
		end
		if fileExists(path) then
			return images[path].image,images[path].scale
		else
			return nil
		end
	end
end

preload = {"mouse","controls","save","camera","Speed","arrow",'Rectangle',"Boundries","Magnets","Snap","Move Type","Check","Movement","Rotation","Scale","Customize","New Element","Settings","Ped Editor","sv","h","cursor","cursor2","close"}

for i,v in pairs(preload) do 
functions.prepImage(v)
end

local rectangle = functions.prepImage('Rectangle')

function dxDrawRectangle(x,y,w,h,c,p) -- // Dx draw rectangle is broken.
dxDrawImage(x,y,w,h,rectangle, 0, 0, 0,c, p)
end


function dxDrawImage3D( x, y, z, width, height, material, color, rotation, ... ) -- Should exist
	return dxDrawMaterialLine3D( x, y, z, x + width, y + height, z + tonumber( rotation or 0 ), material, height, color or 0xFFFFFFFF, ... )
end

mouse = {}
mouse['mouse1'] = true
mouse['mouse2'] = true
mouse['mouse3'] = true
mouse['mouse_wheel_up'] = true
mouse['mouse_wheel_down'] = true

function functions.getLetter(input)
	local path = '/letters/'..(rewrite[' '..input..' '] or input)
	if mouse[input] then
	local image,scale = functions.prepImage(path)
	return image,scale
	else
	local image,scale = functions.prepImage(path)
	return image,scale
	end
end


--\\ Image Functions //--
-------------------------

-------------------------
--// Misc Functions \\---
function callS(...)
		triggerServerEvent ( "functionS", resourceRoot, ... )
end

function callC(name,...)
		if functions[name] then
		functions[name](...)
	end
end

addEvent( "functionC", true )
addEventHandler( "functionC", localPlayer, callC )

functions.onDxEdit = function (id,text)
	if id == 'x' then
		setElementPositions(tonumber(text)-tonumber(X),0,0)
	elseif id == 'y' then
		setElementPositions(0,tonumber(text)-tonumber(Y),0)
	elseif id == 'z' then
		setElementPositions(0,0,tonumber(text)-tonumber(Z))
	elseif id == 'xr' then
		setElementRotations(tonumber(text)-tonumber(Xr),0,0,nil,nil,true,true)
	elseif id == 'yr' then
		setElementRotations(0,tonumber(text)-tonumber(Yr),0,nil,nil,true,true)
	elseif id == 'zr' then
		setElementRotations(0,0,tonumber(text)-tonumber(Zr),nil,nil,true,true)
	end
	functions.refreshMovements()
end

addEventHandler ( "onDxEdit", root,	functions.onDxEdit )


dff = engineLoadDFF ( "misc/test.dff" )
engineReplaceModel ( dff, 3356 )

col = engineLoadCOL( "misc/test.col" )
engineReplaceCOL( col, 3356 )

circles = {}
circles[1] = createObject(3356,0,0,0)
circles[2] = createObject(3356,0,0,0) 
circles[3] = createObject(3356,0,0,0) 


function functions.resetCircles()
	for i=1,3 do
		setElementPosition(circles[i],10000,10000,10000)
		setElementAlpha(circles[i],0)
		setElementData(circles[i],'MapEditor',true)
	end
end
functions.resetCircles()

--\\ Misc Functions //---
-------------------------


----------------------------
--// Element Functions \\---


ElementTypes = {'object','vehicle','water','vehicle','pickup','marker','colshape'}
Ignore = {skybox_model = true}

function getAllElements(synced,onScreen)
local tab = {}
	for i,v in pairs(ElementTypes) do
		for ia,va in pairs(getElementsByType(v,root,synced)) do
			if getElementData(va,'MapEditor') then
				if not Ignore[getElementID(va)] then -- // Check map has a skybox, this tends to mess it up.
					if onScreen then
						if isElementOnScreen(va) then
							table.insert(tab,va)
						end
					else
						table.insert(tab,va)
					end
				end
			end
		end
	end
	return tab
end


function getIntersectingElement(xa,ya,za,xb,yb,zb)
	rMinimal = (global.SelectionDepth or 5)
	rElement = nil
	for i,v in pairs(getAllElements(true,true)) do
	local x,y,z = getElementPosition(v)
		if getDistanceBetweenPoints3D(x,y,z,xa,ya,za) <= (global.SelectionDepth or 5) then
			local scale = 1
			if getElementType(v) == 'object' then
			local sX,sY,sZ = getObjectScale(v)
			scale = (sX+sY+sZ)/3
			end
			
			if (rMinimal > getDistanceBetweenPointAndSegment3D(x,y,z,xa,ya,za,xb,yb,zb)) and (((getElementRadius (v) or 2) * scale) >= getDistanceBetweenPointAndSegment3D(x,y,z,xa,ya,za,xb,yb,zb)) then
			rMinimal = getDistanceBetweenPointAndSegment3D(x,y,z,xa,ya,za,xb,yb,zb)
			rElement = v
			end
		end
	end
	return rElement,rMinimal
end

function getHighLightedElement()
	if isFreecamEnabled() then 
		local x,y = (xSize/2),(ySize/2)
		if isCursorShowing() then
			local xa,ya = getCursorPosition()
			local xa,ya = xa*xSize,ya*ySize
			x,y = xa,ya
		end
		local xA,yA,zA = getCameraMatrix()
		local xW,yW,zW = getWorldFromScreenPosition (x,y, (global.SelectionDepth or 5) )
		if getKeyState('lctrl') then
			return getIntersectingElement(xA,yA,zA,xW,yW,zW)
		else
			local hit, x, y, z, element,_,_,_,material,_,_,world,_,_,_,_,_,_,LOD = processLineOfSight (	xA,yA,zA, xW,yW,zW,true,true,false,true,false,false,false,false)
			if hit then
				if element and getElementData(element,'MapEditor') then
					return element,x, y, z
				else
					--// World object removal will be added here.
				end
			end
		end
	else
		return nil
	end
end


function getSelectedElementsCenter()
local maxV = nil
local minV = nil
	for i,v in pairs(selectedElements) do
		sElement = i
		local x,y,z = getElementPosition(i)
		maxV = maxV or {x,y,z}
		minV = minV or {x,y,z}
		local minx,miny,minz = unpack(minV)
		local maxx,maxy,maxz = unpack(maxV)
		maxV = {math.max(maxx,x),math.max(maxy,y),math.max(maxz,z)}
		minV = {math.min(minx,x),math.min(miny,y),math.min(minz,z)}
	end
		local minx,miny,minz = unpack(minV or {})
		local maxx,maxy,maxz = unpack(maxV or {})
	
	if minx then
		return ((minx+maxx)/2),((miny+maxy)/2),((minz+maxz)/2)
		else
		return 0,0,0
	end
end

function getSelectedElementsCenterI()
	if not(global['Move Type'] == 'World') then
		return 0,0,0 
	else
		local x,y,z = getSelectedElementsCenter()
		return x,y,z
	end
end

function getSelectedElementsRotations()
	if global['Move Type'] == 'Local' then
		return 0,0,0
	end

	if (isThereSelected(true) or 0) > 1 then
		return 0,0,0 
	else
		for i,v in pairs(selectedElements) do
			local xr,yr,zr = getElementRotation(i, 'ZYX')
			return xr,yr,zr
		end
	end
	return 0,0,0 
end

function isThereSelected(count)
	sCount = nil
	sObject = nil
	for i,v in pairs(selectedElements) do
		if not count then
			return true,i
		end
		sCount = (sCount or 0) + 1
		sObject = i
	end
	return sCount,sObject
end

function functions.mirrorElements(mx,my,mz)
	local xa,ya,za = getSelectedElementsCenter()
	for i,v in pairs(selectedElements) do
		local x,y,z = getElementPosition(i)
		local xb,yb,zb = x-xa,y-ya,z-za
		local xr,yr,zr = getElementRotation(i)
		
		

		setElementPosition(i,x-(xb*my)*2,y-(yb*mx)*2,z-(zb*mz)*2)
		
		if mx == 1 then 
			setElementRotation(i,-xr,yr,zr)
		elseif my == 1 then  
			setElementRotation(i,xr,-yr,zr)--ApplyElementRotation(i,0,ya*2,0,true)
		else
			ApplyElementRotation(i,0,180,0,true)
		end
		local element = getLowLODElement(i)
		if element then
			element.position = i.position
			element.rotation = i.rotation
		end
	end
	functions.updatePositions()
end



function setElementPositions(x,y,z,_,ignore)
	if x and y and z then
		if isTimer(TIMER) then
			killTimer(TIMER)
		end
		
		GXa,GYa,GZa = ((tonumber(GXa) or 0) + x),((tonumber(GYa) or 0) + y),((tonumber(GZa) or 0) + z)
		
		minDistance = global.Mangets
		minODistance = 1000
		mClose = {}
		mClose.connection = nil
		for i,v in pairs(selectedElements) do
			functions.prepMagnets(i)
			functions.checkMagnets(i)
			local xA,yA,zA = getElementPosition(i)
			if (global['Move Type'] == 'World') or ignore then
				setElementPosition(i,xA+x,yA+y,zA+z)
			elseif global['Move Type'] == 'Local' then
				local newPosition = i.matrix:transformPosition(Vector3(x,y,z))
				i.position = i.matrix:transformPosition(Vector3(x,y,z))
			elseif global['Move Type'] == 'Screen' then
				local oX,oY,oZ = getWorldFromScreenPosition (0,0,20)
				local nX,nY,nZ = getWorldFromScreenPosition (xSize,y,20)
				
				local fix = ((nX+nY+nZ)-(oX+oY+oZ))
				
				local fix = (fix > 0) and 1 or -1
		
				local cX,cY,cZ = getCameraMatrix()
				local newMatrix = (getCamera().matrix:transformPosition(Vector3(-x,y,-z)))
				local nX,nY,nZ = newMatrix.x,newMatrix.y,newMatrix.z
				local fX,fY,fZ = cX-nX,cY-nY,cZ-nZ
				
				local fX,fY,fZ = getXYZOrdering(fX,fY,fZ)
				
				setElementPosition(i,xA+(fX),yA+(fY),zA+fZ)
			end
			local element = getLowLODElement(i)
			if element then
				element.position = i.position
				element.rotation = i.rotation
			end
		end
		TIMER = setTimer ( functions.updatePositions, 300, 1)
	end
end

function setElementScales(x,y,z)
	if x and y and z then
		if isTimer(TIMER) then
			killTimer(TIMER)
		end
		for i,v in pairs(selectedElements) do
			if getElementType(i) == 'object' then
				local sX,sY,sZ = getObjectScale(i)
				local sX = (sX == 1) and 1.01 or sX
				local sY = (sY == 1) and 1.01 or sY
				local sZ = (sZ == 1) and 1.01 or sZ
				setObjectScale(i,sX+x,sY+y,sZ+z)
			end
			local element = getLowLODElement(i)
			if element then
				local xs,ys,zs = getObjectScale(i)
				setElementScale(element,xs,ys,zs)
			end
		end
		TIMER = setTimer ( functions.updatePositions, 300, 1)
	end
end

prepX,prepY,prepZ = 0,0,0



function setElementRotations(x,y,z,slowupdate,ignore,onRender,nonQuaterion)
	if global.snap and (not onRender) then
		prepX = prepX + x
		prepY = prepY + y 
		prepZ = prepZ + z
		rChange = math.max(getPositive((prepX+prepY+prepZ)/10),0.1)
	else
		setElementRotationsA(x,y,z,slowupdate,ignore,nonQuaterion)
	end
end

function setElementRotationsA(x,y,z,slowupdate,ignore,nonQuaterion)
	if x and y and z then
		if isTimer(TIMER) then
			killTimer(TIMER)
		end
		
		GXa,GYa,GZa,GXra,GYra,GZra = 0,0,0,(GXra + x),(GYra + y),(GZra + z)
		
		minDistance = global.Mangets
		
		mClose = {}
		mClose.connection = nil
		local xa,ya,za = getSelectedElementsCenter()
		for i,v in pairs(selectedElements) do
			local xA,yA,zA = getElementPosition(i)
			if (global['Move Type'] == 'World') or ignore then
				globalRotation(i,x,y,z,xa,ya,za,(nonQuaterion and isThereSelected(true) > 1))
			elseif global['Move Type'] == 'Local' then
				ApplyElementRotation(i, x,y,z)
			end
			local element = getLowLODElement(i)
			if element then
				element.position = i.position
				element.rotation = i.rotation
			end
		end
		TIMER = setTimer ( functions.updatePositions, 300, 1)
	end
end


function functions.updatePositions()
	for i,v in pairs(selectedElements) do
		local xA,yA,zA = getElementPosition(i)
		local xB,yB,zB = getElementRotation(i)
		setElementData(i,'xr',xB)
		setElementData(i,'yr',yB)
		setElementData(i,'zr',zB)
		setElementData(i,'x',xA)
		setElementData(i,'y',yA)
		setElementData(i,'z',zA)
		if getElementType(i) == 'object' then
			local sX,sY,sZ = getObjectScale(i)
			setElementData(i,'sX',sX)
			setElementData(i,'sY',sY)
			setElementData(i,'sZ',sZ)
		end
	end
	callS('updatePositions',selectedElements)
end


function isCursorOnWorldElement(element)
	if isCursorShowing() then
		local x,y = getCursorPosition()
		local xa,ya = x*xSize,y*ySize
		local xA,yA,zA = getWorldFromScreenPosition (xa,ya, 0 )
		local xB,yB,zB = getWorldFromScreenPosition (xa,ya, (global.SelectionDepth or 5) )
		
		if xA then
			local hit, x, y, z, elementA = processLineOfSight (xA,yA,zA,xB,yB,zB,true,true,false,true,false,false,false,false)
			if hit and getElementData(elementA,'MapEditor') then
				return (element == elementA),x, y, z
			end
		end
	end
end

--\\ Element Functions //---
----------------------------

--------------------------
--// Math Functions \\---


function getAlignment(element,x,y,z)

	local xa,ya,za,xb,yb,zb = getElementBoundingBox ( element )
	if xa then

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
		
		--
		local A = m1 -- Top Front left
		local B = m7 -- Bottom Rear Left
		local disXf = getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m3 -- Top rear left
		local B = m5 -- Bottom front left
		local disXf = (disXf+getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		---
		local A = m2 -- Top Front right
		local B = m8 -- Bottom Rear right
		local disXr = getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m4 -- Top rear right
		local B = m6 -- Bottom front right
		local disXr = (disXr+getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		--
		
		--
		local A = m1 -- Top Front left
		local B = m6 -- Bottom Front Right
		local disYf = getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m2 -- Top Front right
		local B = m5 -- Bottom front left
		local disYf = (disYf+getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		---
		local A = m3 -- Top Rear left
		local B = m8 -- Bottom Rear Right
		local disYr = getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m4 -- Top Rear right
		local B = m7 -- Bottom Rear left
		local disYr = (disYr+getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		--
		
		--
		local A = m1 -- Top Front left
		local B = m4 -- Top Rear Right
		local disZf = getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m3 -- Top Rear Left
		local B = m2 -- Top Front Right
		local disZf = (disZf+getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		---
		local A = m5 -- Bottom Front left
		local B = m8 -- Bottom Rear Right
		local disZr = getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z)
		
		local A = m7 -- Bottom Rear Left
		local B = m6 -- Bottom Front Right
		local disZr = (disZr+getDistanceBetweenPointAndSegment3D(x,y,z,A.x,A.y,A.z,B.x,B.y,B.z))/2
		--
		
		local minDis = math.min(disXf,disXr,disYf,disYr,disZf,disZr)
		
		if minDis == disXr then
			return (matrix:transformPosition(Vector3(xb-xa,0,0)))
		elseif minDis == disXf then
			return (matrix:transformPosition(Vector3(xa-xb,0,0)))
		elseif minDis == disYr then
			return (matrix:transformPosition(Vector3(0,yb-ya,0)))
		elseif minDis == disYf then
			return (matrix:transformPosition(Vector3(0,ya-yb,0)))
		elseif minDis == disZr then
			return (matrix:transformPosition(Vector3(0,0,zb-za)))
		elseif minDis == disZf then
			return (matrix:transformPosition(Vector3(0,0,za-zb)))
		end
	end
end

local sqrt = math.sqrt
function getDistanceBetweenPoints3D(x,y,z,x1,y1,z1)
    local distX = x1-x
    local distY = y1-y
    local distZ = z1-z
    return sqrt(distX*distX+distY*distY+distZ*distZ)
end


function getDistanceBetweenPointAndSegment2D(pointX, pointY, x1, y1, x2, y2)
	if tonumber(x1) and tonumber(y1) and tonumber(x2) and tonumber(y2) then
	local A = pointX - x1
	local B = pointY - y1
	local C = x2 - x1
	local D = y2 - y1

	local point = A * C + B * D
	local lenSquare = C * C + D * D
	local parameter = point / lenSquare

	local shortestX
	local shortestY

	if parameter < 0 then
		shortestX = x1
				shortestY = y1
	elseif parameter > 1 then
		shortestX = x2
		shortestY = y2
	else
		shortestX = x1 + parameter * C
		shortestY = y1 + parameter * D
	end

	local distance = getDistanceBetweenPoints2D(pointX, pointY, shortestX, shortestY)

	return distance
	end
end

function getDistanceBetweenPointAndSegment3D (pointX, pointY, pointZ, x1, y1, z1, x2, y2, z2) --// Credit to IIYAMA // --

	local A = pointX - x1 
	local B = pointY - y1
	local C = pointZ - z1

	local D = x2 - x1
	local E = y2 - y1
	local F = z2 - z1

	local point = A * D + B * E + C * F
	local lenSquare = D * D + E * E + F * F
	local parameter = point / lenSquare
 
	local shortestX
	local shortestY
	local shortestZ
 
	if parameter < 0 then
		shortestX = x1
    	shortestY = y1
		shortestZ = z1
	elseif parameter > 1 then
		shortestX = x2
		shortestY = y2
		shortestZ = z2

	else
		shortestX = x1 + parameter * D
		shortestY = y1 + parameter * E
		shortestZ = z1 + parameter * F
	end

	local distance = getDistanceBetweenPoints3D(pointX, pointY,pointZ, shortestX, shortestY,shortestZ)
 
	return distance
end


function getBiggestChange(a,b)
	local ac = math.max(a,-a)
	local bc = math.max(b,-b)

	if ac>bc then
		return a
	else
		return b
	end
end


function getXYZOrdering(sx,sy,sz)
	local _,_,z = getElementRotation(getCamera())
	if global['Mode'] == 'Movement' then
		if (z < (90+45)) and (z > (90-45)) then
			return sy,sx,sz
		elseif (z < (180+45)) and (z > (180-45)) then
			return -sx,sy,sz
		elseif (z < (270+45)) and (z > (270-45)) then
			return -sy,-sx,sz
		elseif (z < (45)) and (z > (-45)) then
			return sx,-sy,sz
		else
			return sx,sy,sz
		end
	elseif global['Mode'] == 'Rotation' then
		local xa,ya,za,xb,yb,zb = getCameraMatrix()
		local oX,oY,oZ = getWorldFromScreenPosition (0,0,20)
		local nX,nY,nZ = getWorldFromScreenPosition (xSize,ySize,20)
		_,_,Z = getSelectedElementsCenter()

		local fix = ((nX+nY+nZ)-(oX+oY+oZ))
		
		local A = ((zb > za+50) or (zb < za-50))

		if not A then
		value = ((nX+nY+nZ)>(oX+oY+oZ)) and 1 or -1
		else
		value = (Z > za) and 1 or -1
		end
	

		if lRotationalAxis == 'X' then
			return -sx*value,0,0
		elseif lRotationalAxis == 'Y' then
			return 0,sx*value,0
		else
			return 0,0,sx*value
		end
	end
end

function isNegative(value)
	if value < 0 then
		return -1
	else
		return 1
	end
end

function getPositive(value)
	if value < 0 then
		return -value
	else
		return value
	end
end


function findRotation3D( x1, y1, z1, x2, y2, z2 ) 
	local rotx = math.atan2 ( z2 - z1, getDistanceBetweenPoints2D ( x2,y2, x1,y1 ) )
	rotx = math.deg(rotx)
	local rotz = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	rotz = rotz < 0 and rotz + 360 or rotz
	return rotx, 0,rotz
end

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end


function globalRotation(element,xr,yr,zr,x,y,z,nonQuaterion) --// Function orignally by MyOnLake
	local vec = Vector3(x,y,z)
	local vec2 = Vector3(xr,yr,zr)

	local matrix = Matrix(vec, vec2)
	local matrix2 = Matrix(matrix:transformPosition(element.position-vec), matrix:getRotation()+element.matrix:getRotation())

        element:setPosition(matrix2:getPosition())

	if nonQuaterion then
		local rotation = element.rotation+vec2
		element.rotation = rotation
	else
		ApplyElementRotation(element, xr,yr,zr, true)
	end
end


function functions.getPosition(x,y,z) -- Helper for Gimbals
	if (global['Move Type'] == 'World') or ((global['Move Type'] == 'Local') and (not (isThereSelected(true) == 1))) then
		local xA,yA,zA = getSelectedElementsCenter()
		local x,y,z = x+xA,y+yA,z+zA
		return x,y,z
	elseif global['Move Type'] == 'Local' then
		local _,element = isThereSelected()
		local newMatrix = (element.matrix:transformPosition(Vector3(x,y,z)))
		return newMatrix.x,newMatrix.y,newMatrix.z
	elseif global['Move Type'] == 'Screen' then 
		local xA,yA,zA = getSelectedElementsCenter()
		local xB,yB,zB = getCameraMatrix()
		local xC,yC,zC = xA-xB,yA-yB,zA-zB
		local newMatrix = (getCamera().matrix:transformPosition(Vector3(x,y,z)))
		local xD,yD,zD = newMatrix.x,newMatrix.y,newMatrix.z
		return xD+xC,yD+yC,zD+zC
	end
end

function findPointOnCircle(radius,rotation)
	local rotation = math.rad(rotation-90)
	return Vector2(radius*math.cos(rotation) + (xSize/2), radius*math.sin(rotation) + (ySize/2))
end


function sign ( p1,  p2,  p3)
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
end

function isPointInTriangle ( pt,  v1,  v2,  v3)
    local b1 = sign(pt, v1, v2) < 0.0;
    local b2 = sign(pt, v2, v3) < 0.0;
    local b3 = sign(pt, v3, v1) < 0.0;

    return ((b1 == b2) and (b2 == b3));
end

--\\ Math Functions //---
--------------------------
