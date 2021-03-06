
ElementTypes = {'object','vehicle','water','vehicle','pickup','marker','colshape'}
Ignore = {skybox_model = true}

function getMapElements(ignore)
local tab = {}
	for i,v in pairs(ElementTypes) do
		for ia,va in pairs(getElementsByType(v,ignore)) do
			if getElementData(va,'MapEditor') or ignore then
				if not Ignore[getElementID(va)] then -- // Check map has a skybox, this tends to mess it up.
						table.insert(tab,va)
				end
			end
		end
	end
	return tab
end

save = {}
properties = {}
properties.generic = {}

ordering = {}
ordering.generic = {}

function rgb2hex(r,g,b)
	
	local hex_table = {[10] = 'A',[11] = 'B',[12] = 'C',[13] = 'D',[14] = 'E',[15] = 'F'}
	
	local r1 = math.floor(r / 16)
	local r2 = r - (16 * r1)
	local g1 = math.floor(g / 16)
	local g2 = g - (16 * g1)
	local b1 = math.floor(b / 16)
	local b2 = b - (16 * b1)
	
	if r1 > 9 then r1 = hex_table[r1] end
	if r2 > 9 then r2 = hex_table[r2] end
	if g1 > 9 then g1 = hex_table[g1] end
	if g2 > 9 then g2 = hex_table[g2] end
	if b1 > 9 then b1 = hex_table[b1] end
	if b2 > 9 then b2 = hex_table[b2] end
	
	return "#" .. r1 .. r2 .. g1 .. g2 .. b1 .. b2
end

table.insert(ordering.generic,'id')
properties.generic['id'] = function(element)
	local id = getElementID(element)
	return id,'setElementID',nil,'setElementID(element,"'..id..'")'
end

table.insert(ordering.generic,'model')
properties.generic['model'] = function(element) -- Technically this is not generic to everything, however it's represented on enough of them I'll figure out something, maybe don't add it if this returns nil?
	local model = getElementModel(element)
	return model
end

table.insert(ordering.generic,'posX')
properties.generic['posX'] = function(element)
	local x = getElementPosition(element)
	return x
end

table.insert(ordering.generic,'posY')
properties.generic['posY'] = function(element)
	local _,y = getElementPosition(element)
	return y
end

table.insert(ordering.generic,'posZ')
properties.generic['posZ'] = function(element)
	local _,_,z = getElementPosition(element)
	return z
end

table.insert(ordering.generic,'rotX')
properties.generic['rotX'] = function(element)
	local xr = getElementRotation(element)
	return xr
end

table.insert(ordering.generic,'rotY')
properties.generic['rotY'] = function(element)
	local _,yr = getElementRotation(element)
	return yr
end

table.insert(ordering.generic,'rotZ')
properties.generic['rotZ'] = function(element)
	local _,_,zr = getElementRotation(element)
	return zr
end

table.insert(ordering.generic,'interior')
properties.generic['interior'] = function(element)
	local interior = getElementInterior(element)
	if interior > 0 then
		return interior,'setElementInterior'
	else
		return interior
	end
end

table.insert(ordering.generic,'dimension')
properties.generic['dimension'] = function(element)
	local dimension = getElementDimension(element)
	if dimension > 0 then
		return dimension,'setElementDimension'
	else
		return dimension
	end
end

table.insert(ordering.generic,'collisions')
properties.generic['collisions'] = function(element)
	local collisions = getElementCollisionsEnabled(element)
	if collisions == false then
		return collisions,'setElementCollisionsEnabled'
	else
		return collisions
	end
end

table.insert(ordering.generic,'alpha')
properties.generic['alpha'] = function(element)
	local alpha = getElementAlpha(element)
	if alpha < 255 then
		return alpha,'setElementAlpha'
	else
		return alpha
	end
end

table.insert(ordering.generic,'frozen')
properties.generic['frozen'] = function(element)
	local frozen = isElementFrozen(element)
	if frozen == false then
		return frozen,'setElementFrozen'
	else
		return frozen
	end
end

properties.object = {}
ordering.object = {}

table.insert(ordering.object,'scale')
properties.object['scale'] = function(element)
	local x,y,z = getObjectScale(element)
	if not(x == 1) or not(y == 1) or not(y == 1) then
		return {x,y,z},'setObjectScale',true
	else
		return {x,y,z},nil,true
	end
end

table.insert(ordering.object,'breakable')
properties.object['breakable'] = function(element)
	local breakable = isObjectBreakable(element)
	if breakable == false then
		return breakable,'setObjectBreakable'
	else
		return breakable
	end
end

properties.vehicle = {}
ordering.vehicle = {}

table.insert(ordering.vehicle,'color')
properties.vehicle['color'] = function(element)
	local vc = {getVehicleColor(element, true)}
	local colorString = vc[1]..","..vc[2]..","..vc[3]..","..vc[4]..","..vc[5]..","..vc[6]..","..vc[7]..","..vc[8]..","..vc[9]..","..vc[10]..","..vc[11]..","..vc[12]
	return colorString,'setVehicleColor'
end

table.insert(ordering.vehicle,'upgrades')
properties.vehicle['upgrades'] = function(element)
	local upgrades = getVehicleUpgrades ( element)
	
	local colorString = vc[1]..","..vc[2]..","..vc[3]..","..vc[4]..","..vc[5]..","..vc[6]..","..vc[7]..","..vc[8]..","..vc[9]..","..vc[10]..","..vc[11]..","..vc[12]
	return upgrades,'',true,'for i,v in pairs({'..table.concat(upgrades,',')..'}) do\naddVehicleUpgrade ( element, v )\nend'
end

table.insert(ordering.vehicle,'paintjob')
properties.vehicle['paintjob'] = function(element)
	local paintjob = getVehiclePaintjob(element)
	return paintjob,'setVehiclePaintjob'
end

table.insert(ordering.vehicle,'plate')
properties.vehicle['plate'] = function(element)
	local text = getVehiclePlateText(element)
	return text,'setVehiclePlateText'
end

table.insert(ordering.vehicle,'health')
properties.vehicle['health'] = function(element)
	local health = getElementHealth(element)
	return health,'setElementHealth'
end

table.insert(ordering.vehicle,'sirens')
properties.vehicle['sirens'] = function(element)
	local sirens = getVehicleSirensOn (element)
	return sirens,'setVehicleSirensOn'
end

table.insert(ordering.vehicle,'locked')
properties.vehicle['locked'] = function(element)
	local locked = isVehicleLocked (element)
	return locked,'setVehicleLocked'
end

properties.pickup = {}
ordering.pickup = {}

table.insert(ordering.pickup,'eType')
properties.pickup['eType'] = function (element)
	local eType =  getPickupType (element)
	if eType == 0 then
		return 'health'
	elseif eType == 1 then
		return 'armor'
	elseif eType == 2 then
		return getPickupWeapon ( element )
	elseif eType == 3 then
		return getElementModel(element)
	end
end

table.insert(ordering.pickup,'amount')
properties.pickup['amount'] = function (element)
	local eType =  getPickupType (element)
	if eType == 0 or eType == 1 or eType == 3 then
		return getPickupAmount(element)
	elseif eType == 2 then
		return getPickupAmmo ( element )
	end
end

table.insert(ordering.pickup,'respawn')
properties.pickup['respawn'] = function (element)
	return getPickupRespawnInterval(element)
end

properties.marker = {}
ordering.marker = {}

table.insert(ordering.marker,'eType')
properties.marker['eType'] = function (element)
	return getMarkerType ( element )
end

table.insert(ordering.marker,'color')
properties.marker['color'] = function (element)
	local r,g,b = getMarkerColor ( element )
	return rgb2hex(r,g,b)
end

properties.blip = {}
ordering.blip = {}

table.insert(ordering.blip,'color')
properties.blip['color'] = function (element)
	local r,g,b = getBlipColor ( element )
	return rgb2hex(r,g,b)
end

table.insert(ordering.blip,'ordering')
properties.blip['ordering'] = function (element)
	local orderingb = getBlipOrdering ( element )
	return orderingb
end

ignore = {}

ignore['x'] = true
ignore['y'] = true
ignore['z'] = true
ignore['xr'] = true
ignore['yr'] = true
ignore['zr'] = true
ignore['sX'] = true
ignore['sY'] = true
ignore['sZ'] = true

save['.map'] = function (name)
	local file = fileCreate (name..'.map')
	local mTable = {}
	
	mTable[#mTable+1] = '<map'
	
	if #(defintions or {}) > 0 then -- defintions don't exist at this time.
		mTable[#mTable+1] = 'edf:definitions='
	end
	
	for i,v in pairs(defintions or {}) do
		if i>1 then
			mTable[#mTable+1] =  ',"'..v..'"'
		else
			mTable[#mTable+1] =  '"'..v..'"'
		end
	end
	
	mTable[#mTable+1] = '>'
	
	for iA,vA in pairs(getMapElements()) do
		setElementData(vA,'MapEditor',false)
		
		local eType = (getElementData(v,'Edf') and 'EDF') or getElementType(vA)
		mTable[#mTable+1] = '\n <'..eType
		for _,vC in pairs(ordering.generic) do
			local i = vC
			local v = properties.generic[i]
			local a,b,c = v(vA)
			if a then
				if c then
					mTable[#mTable+1] = ' '..i..'="'..table.concat(a,',')..'"'
				else
					mTable[#mTable+1] = ' '..i..'="'..tostring(a)..'"'
				end
			end
		end
		for _,vC in pairs(ordering[eType]) do
			local i = vC
			local v = properties[eType][i]
			local a,b,c = v(vA)
			if c then
				mTable[#mTable+1] = ' '..i..'="'..table.concat(a,',')..'"'
			else
				mTable[#mTable+1] = ' '..i..'="'..tostring(a)..'"'
			end
		end
		for i,v in pairs(getAllElementData(vA)) do
			if (not properties[eType][i]) and (not properties.generic[i]) and (not ignore[i]) then
				mTable[#mTable+1] = ' '..i..'="'..tostring(v)..'"'
			end
		end
		
		mTable[#mTable+1] =  '></'..eType..'>'
		setElementData(vA,'MapEditor',true)
	end
	mTable[#mTable+1] = '\n</map>'
	fileWrite(file,table.concat(mTable,''))
	fileClose(file)
end

create = {}

create.object = function(element)
	local x,y,z = getElementPosition(element)
	local xr,yr,zr = getElementRotation(element)
	local model = getElementModel(element)
	return 'createObject('..model..','..x..','..y..','..z..','..xr..','..yr..','..zr..')'
end

create.vehicle = function(element)
	local x,y,z = getElementPosition(element)
	local xr,yr,zr = getElementRotation(element)
	local model = getElementModel(element)
	return 'createVehicle('..model..','..x..','..y..','..z..','..xr..','..yr..','..zr..')'
end

create.ped = function(element)
	local x,y,z = getElementPosition(element)
	local xr,yr,zr = getElementRotation(element)
	local model = getElementModel(element)
	return 'createPed('..model..','..x..','..y..','..z..','..zr..')'
end

create.pickup = function(element)
	local x,y,z = getElementPosition(element)
	local model = getElementModel(element)
	local eType = getPickupType ( element )       
	local respawn = getPickupRespawnInterval ( element )
	if eType == 0 then
		local amount = getPickupAmount(element)
		return 'createPickup('..x..','..y..','..z..','..eType..','..amount..','..respawn..')'
	elseif eType == 1 then
		local amount = getPickupAmount(element)
		return 'createPickup('..x..','..y..','..z..','..eType..','..amount..','..respawn..')'
	elseif eType == 2 then
		local weapon = getPickupWeapon (element)
		local ammo = getPickupAmmo(element)
		return 'createPickup('..x..','..y..','..z..','..eType..','..weapon..','..respawn..','..ammo..')'
	elseif eType == 3 then
		return 'createPickup('..x..','..y..','..z..','..eType..','..model..','..respawn..')'
	end
end

create.marker = function(element)
	local x,y,z = getElementPosition(element)
	local eType = getMarkerType (element)
	local size = getMarkerSize (element)
	local r,g,b,a = getMarkerColor ( element )
	return 'createMarker('..x..','..y..','..z..','..eType..','..size..','..r..','..g..','..b..','..a..')'
end

create.colshape = function(element)
-- TODO
end

create.blip = function(element)
	local x,y,z = getElementPosition(element)
	local icon = getBlipIcon ( element )
	local size = getBlipSize (element)
	local orderingc = getBlipOrdering (element)
	local visible = getBlipVisibleDistance (element)
	local r,g,b,a = getMarkerColor ( element )
	return 'createBlip('..x..','..y..','..z..','..icon..','..size..','..r..','..g..','..b..','..a..','..orderingc..','..visible..')'
end

create.misc = function (element)
	local x,y,z = getElementPosition(element)
	local xr,yr,zr = getElementRotation(element)
	return 'createElement ('..getElementType(element)..','..getElementID(element)..')\nsetElementPosition(element,'..x..','..y..','..z..')\nsetElementRotation(element,'..xr..','..yr..','..zr..')'
end

save['.lua'] = function (name)
	local file = fileCreate (name..'.lua')
	local mTable = {}
	
	for iA,vA in pairs(getMapElements()) do
		setElementData(vA,'MapEditor',false)
		local eType = (getElementData(v,'Edf') and 'EDF') or getElementType(vA)
		
		if create[eType] then
			mTable[#mTable+1] = '\n	local element = '..create[eType](vA)
		else
			mTable[#mTable+1] = '\n	local element = '..create.misc(vA)
		end
		
		for _,vC in pairs(ordering.generic) do
			local i = vC
			local v = properties.generic[i]
			local a,b,c,d = v(vA)
			if a and b then
				if c then
					mTable[#mTable+1] = '\n	'..(d or b..'(element,'..(table.concat(a,','))..')')
				else
					mTable[#mTable+1] = '\n	'..(d or b..'(element,'..tostring(a)..')')
				end
			end
		end
		for _,vC in pairs(ordering[eType]) do
			local i = vC
			local v = properties[eType][i]
			local a,b,c,d = v(vA)
			if b then
				if c then
					mTable[#mTable+1] = '\n	'..(d or b..'(element,'..(table.concat(a,','))..')')
				else
					mTable[#mTable+1] = '\n	'..(d or b..'(element,'..tostring(a)..')')
				end
			end
		end
		for i,v in pairs(getAllElementData(vA)) do
			if (not properties[eType][i]) and (not properties.generic[i]) and (not ignore[i]) then
				if type(v) == 'string' then
					mTable[#mTable+1] = "\n	setElementData(element,'"..i.."','"..v.."')"
				else
					if v then
						mTable[#mTable+1] = "\n	setElementData(element,'"..i.."',"..v..')'
					end
				end
			end
		end
		setElementData(vA,'MapEditor',true)
	end

	fileWrite(file,table.concat(mTable,''))
	fileClose(file)
end

save['.JSP'] = function (name)
	local file = fileCreate (name..'.JSP')
	mTable = {}
	mTable[#mTable+1] = '0,0,0'
	for i,v in pairs(getElementsByType('object')) do
		if not getElementData(v,'Edf') then
			if getElementData(v,'MapEditor') then
				setElementData(v,'MapEditor',false)
				local x,y,z = getElementPosition(v)
				local xr,yr,zr = getElementRotation(v)
				local model = getElementData(v,'id') or getElementID(v)
				local dimension = getElementDimension(v)
				local interior = getElementInterior(v)
				mTable[#mTable+1] = '\n'..model..','..interior..','..dimension..','..x..','..y..','..z..','..xr..','..yr..','..zr
				setElementData(v,'MapEditor',true)
			end
		end
	end
	fileWrite(file,table.concat(mTable,''))
	fileClose(file)
end

function functions.save(format,name,settingTable,mName,author,version,description,gamemodes)
	local map = getResourceFromName ( name ) or createResource ( name )
	if map then
		if save[format] then
			save[format](':'..name..'/gta3')
		end
		functions.proccessMeta(name,'gta3'..format,settingTable,mName,author,version,description,gamemodes)
	end
end

functions.proccessMeta = function (name,mapfile,settings,mName,author,version,description,gamemodes) --- Need to send settings over from client side, aswell as regenerate the files.
	local xml = fileExists(':'..name..'/meta.xml')
	if xml then
		local meta = xmlLoadFile (':'..name..'/meta.xml')
		metachildren = {}
		if meta then
			local children = xmlNodeGetChildren(meta)
			local metatable = {addmap = true}
			for ia,va in pairs(children or {}) do
				local type = xmlNodeGetName (va)
				if not (type == 'info') then -- We wanna get rid of the old information, meta will be populated with the new information instead.
					local information = xmlNodeGetAttributes(va)
					if information.src == mapfile then
						metatable.addmap = nil --// If the map file already exists in the meta there's no reason to add it again.
					else
						table.insert(metachildren,{type,information.src})
					end
				end
			end		
			xmlUnloadFile(meta)
		end
	end
	functions.generateMeta(metachildren,settings,mName,author,version,description,mapfile,gamemodes,name)--(stuff) // Need to send information from client. // Pretty much generates the 'Meta' from scratch resulting in fixed formatting.
end

functions.generateMeta = function (children,settings,name,author,version,description,mapfile,gamemodes,mName)
	local list = {}
	local meta = fileCreate (':'..mName..'/meta.xml')
	fileWrite(meta,'<meta>')
	fileWrite(meta,'\n<info type="map" gamemodes="'..gamemodes..'" name="'..name..'" author="'..author..'" description="'..description..'" version="'..version..'" />')
	fileWrite(meta,'\n  <map src="'..mapfile..'" />') 
	if #settings > 0 then
		fileWrite(meta,'\n	<settings>')
		for i,v in pairs(settings) do
			if v then
				if v[1] and v[2] then
					fileWrite(meta,'\n		<setting name="#'..v[1]..'" value="'..v[2]..'" />')
				end
			end
		end
		fileWrite(meta,'\n	</settings>')
	end
	for i,v in pairs(children or {}) do
		if v[1] and v[2] then
			fileWrite(meta,'\n  <'..v[1]..' src="'..v[2]..'" />') 
		end
	end
	fileWrite(meta,'\n</meta>')
	
    fileClose(meta) 
end




