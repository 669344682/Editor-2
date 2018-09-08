objects = {}
functions = {}


functions.removePedFromVehicleS = function ()
	removePedFromVehicle(client)
end

functions['ObjectS'] = function (selectedElements,id,replaceE,x,y,z)
	if replaceE then
		for i,v in pairs(selectedElements) do
			exports.ObjS:JsetElementModel(i,id)
		end
	else
		local obj = exports.ObjS:JcreateObject(id,x,y,z)
		setElementData(obj,'MapEditor',true)
		setElementData(obj,'mID',generateElementSerial())
		table.insert(objects,obj)
		callC(client,'Select',obj)
	end
end

used = {}

function generateElementSerial()
	local numbers = {math.random(0,100),math.random(0,100),math.random(0,100),math.random(0,100),math.random(0,100)}
	if not used[table.concat(numbers,'')] then
		used[table.concat(numbers,'')] = true
		return table.concat(numbers,'')
	else
		return generateElementSerial()
	end
end


function cloneElement ( element, x, y, z, children )
	local xA,yA,zA = getElementPosition(element)
	local x,y,z = x or xA,y or yA,z or zA
	local xr,yr,zr = getElementRotation(element)
	local type = getElementType ( element)  
	local data = getAllElementData ( element )
	local id = getElementID(element)
	if type == 'object' then
		local model = getElementModel(element)
		local xs,ys,zs = getObjectScale(element)
		newElement = createObject(model,0,0,0)
		setObjectScale(newElement,xs,ys,zs)
	elseif type == 'ped' then
		local model = getElementModel(element)
		newElement = createPed ( model, 0,0,0)
	elseif type == 'vehicle' then
		local model = getElementModel(element)
		newElement = createVehicle(model,0,0,0)
		local handling = getVehicleHandling (element)
		local color = {getVehicleColor (element, true )}
		local upgrades = getVehicleUpgrades ( element )
		for i,v in pairs(handling) do 
			setVehicleHandling (newElement,i,v) 
		end
		for i,v in pairs(upgrades) do
			addVehicleUpgrade ( newElement,v)
		end
		setVehicleColor(newElement,unpack(color))
	elseif type == 'pickup' then
		local model = getElementModel(element)
		local pType = getPickupType ( element )  
		if pType == 0 then
		local amount = getPickupAmount (element)    
		local respawn = getPickupRespawnInterval (element )
		newElement = createPickup ( 0,0,0, pType,amount,respawn )    
		elseif pType == 1 then
		local amount = getPickupAmount (element)    
		local respawn = getPickupRespawnInterval (element )
		newElement = createPickup ( 0,0,0, pType,amount,respawn )    
		elseif pType == 2 then
		local amount = getPickupAmmo ( element )     
		local respawn = getPickupRespawnInterval (element )
		local weapon = getPickupWeapon (element )     
		newElement = createPickup ( 0,0,0, pType,weapon,respawn,amount )    
		elseif pType == 3 then 
		local respawn = getPickupRespawnInterval (element ) 
		newElement = createPickup ( 0,0,0, pType,model,respawn )    
		end
	end
	setElementID(newElement,id)
	setElementData(newElement,'mID',generateElementSerial())
	setElementPosition(newElement,x,y,z)
	setElementRotation(newElement,xr,yr,zr)
	setElementData(newElement,'MapEditor',true)
	for i,v in pairs(data) do
		setElementData(newElement,i,v)
	end
end

functions['DeleteElements'] = function (selectedElements)
	for i,v in pairs(selectedElements) do
		local element = getLowLODElement(i)
		destroyElement(i)
		if element then
			destroyElement(element)
		end
	end
end


functions['CloneG'] = function (selectedElements)
	for i,v in pairs(selectedElements) do
		cloneElement (i)  
	end
end

functions['CloneS'] = function (element,x,y,z)
	cloneElement (element,x,y,z)  
end


functions['freezeElement'] = function (element,boolen)
	setElementFrozen(element,boolen)
	local elementA = getLowLODElement(element)
	if elementA then
		setElementFrozen(elementA,boolen)
	end
end

functions['setElementPositions'] = function (selectedElements,x,y,z,useElementData,mType,caX,caY,caZ)
	for i,v in pairs(selectedElements) do
		if useElementData then
			setElementPosition ( i, getElementData(i,'x'),getElementData(i,'y'),getElementData(i,'z'))
		else
			local xA,yA,zA = getElementPosition(i)
			if (mType == 'World' or not mType) then
				setElementPosition ( i, x+xA,y+yA,z+zA )
			elseif mType == 'Local' then
				local newPosition = i.matrix:transformPosition(Vector3(x,y,z))
				i.position = i.matrix:transformPosition(Vector3(x,y,z))
			elseif mType == 'Screen' then
				local cX,cY,cZ = getCameraMatrix(client)
				local fX,fY,fZ = cX-caX,cY-caY,cZ-caZ
				setElementPosition(i,xA-fX,yA-fY,zA+fZ)
			end
		end
		local elementA = getLowLODElement(i)
		if elementA then
			elementA.position = i.position
			elementA.rotation = i.rotation
		end
	end
end

functions['setElementScales'] = function (selectedElements)
	for i,v in pairs(selectedElements) do
		if getElementType(i) == 'object' then
			setObjectScale(i,getElementData(i,'sX'),getElementData(i,'sY'),getElementData(i,'sZ')) -- WILL BE EXPANDED LATER
		end
	end
end


functions['setElementRotations'] = function (selectedElements,x,y,z,useElementData,mType,cx,cy,xz) --// Identical to setElementPositions, however uses matrix for the camera stuff.

	for i,v in pairs(selectedElements) do
		if useElementData then
			setElementRotation (i,getElementData(i,'xr'),getElementData(i,'yr'),getElementData(i,'zr'))
			setElementPosition (i,getElementData(i,'x'),getElementData(i,'y'),getElementData(i,'z'))
		else
			local xA,yA,zA = getElementRotation(i)
			if (mType == 'World' or not mType) then
				globalRotation(i,x,y,z,cx,cy,xz)
			elseif mType == 'Local' then
				ApplyElementRotation(i, x,y,z)
			end
		end
		local elementA = getLowLODElement(i)
		if elementA then
			elementA.position = i.position
			elementA.rotation = i.rotation
		end
	end
end


functions['updatePositions'] = function (selectedElements)
	for i,v in pairs(selectedElements) do
		if getElementData(i,'xr') then
			setElementRotation (i,getElementData(i,'xr'),getElementData(i,'yr'),getElementData(i,'zr'))
		end
		setElementPosition (i,getElementData(i,'x'),getElementData(i,'y'),getElementData(i,'z'))
		if getElementType(i) == 'object' then
			setObjectScale(i,getElementData(i,'sX'),getElementData(i,'sY'),getElementData(i,'sZ')) -- WILL BE EXPANDED LATER
		end
		local element = getLowLODElement(i)
		if element then
			element.position = i.position
			element.rotation = i.rotation
			setObjectScale(element,getElementData(i,'sX'),getElementData(i,'sY'),getElementData(i,'sZ'))
		end
	end
end



--- Helpers
function callC(player,...)
	if player then
		triggerClientEvent ( player,"functionC", player, ... )
	end
end

function triggerFunction(name,...)
	if functions[name] then
		functions[name](...)
	end
end

addEvent( "functionS", true )
addEventHandler( "functionS", resourceRoot, triggerFunction )

function globalRotation(element,xr,yr,zr,x,y,z) --// Function orignally by MyOnLake
	local vec = Vector3(x,y,z)
	local vec2 = Vector3(xr,yr,zr)

	local matrix = Matrix(vec, vec2)
	local matrix2 = Matrix(matrix:transformPosition(element.position-vec), matrix:getRotation()+element.matrix:getRotation())

	element:setPosition(matrix2:getPosition())

	ApplyElementRotation(element, xr,yr,zr, true)
end


addEventHandler( "onResourceStop", resourceRoot,
function ( )
	for i,v in pairs(objects) do
		if isElement(v) then
			destroyElement(v)
		end
	end
end
)


functions['getGamemodes'] = function ()
local ta = {}
	for i,v in pairs(getResources ()) do
		local type = getResourceInfo (v,'type') 
		if type == 'gamemode' then
			local edf = getResourceInfo(v,'edf:definition')
			if edf then
				local file = xmlLoadFile (getResourceName(v)..'/'..edf)
				if file then
					local children = xmlNodeGetChildren(file)
					print(xmlNodeGetAttributes (children))
				end
			end
			table.insert(ta,getResourceName(v))
		end
	end
	callC(client,'refreshGamemods',ta)
end

