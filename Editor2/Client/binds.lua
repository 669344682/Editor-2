-----------------------
--// Dynamic Binds \\--
--// These are buttons that you can push and hold (Constantly execute while you hold)
functions['Camera Movement'] = function ()
	if EditSelected then return end
end
table.insert(binds.dynamic,{'Camera Movement',{'w','a','s','d'},'FreeCam'}) -- Name first, then binds (For multiple binds)

countb = 0

functions['Element Movement'] = function (key,keyID)
	if not EditSelected then
		local divison = getKeyState('lalt') and 0.5 or (getKeyState('lshift') and 2 or 1)
		countb = countb + 1
		if countb >= 20 or (not global.snap) then
			countb = 0
			if keyID == 1 then
				local x,y,z = getXYZOrdering(0,-(tonumber(global.snap) or (CameraSpeed/50))*divison,0)
				functions.tranformElements(x,y,z)
			elseif keyID == 2 then
				local x,y,z = getXYZOrdering(-(tonumber(global.snap) or (CameraSpeed/50))*divison,0,0)
				functions.tranformElements(x,y,z,1)
			elseif keyID == 3 then
				local x,y,z = getXYZOrdering(0,(tonumber(global.snap) or (CameraSpeed/50))*divison,0)
				functions.tranformElements(x,y,z)
			else
				local x,y,z = getXYZOrdering((tonumber(global.snap) or (CameraSpeed/50))*divison,0,0)
				functions.tranformElements(x,y,z,-1)
			end
		end
	end
end

table.insert(binds.dynamic,{'Element Movement',{'arrow_u','arrow_l','arrow_d','arrow_r'},'Selected'}) -- Name first, then binds (For multiple binds) --'=','-'


functions['Element Height'] = function (key,keyID)
	if not EditSelected then
		local divison = getKeyState('lalt') and 0.5 or (getKeyState('lshift') and 2 or 1)
		countb = countb + 1
		if countb >= 20 or (not global.snap) then
			countb = 0
			if keyID == 1 then
				functions.tranformElements(0,0,(tonumber(global.snap) or (CameraSpeed/50))*divison)
			elseif keyID == 2 then
				functions.tranformElements(0,0,-(tonumber(global.snap) or (CameraSpeed/50))*divison)
			end
		end
	end
end


functions.tranformElements = function (x,y,z,Alternative)
	if global['Mode'] == 'Movement' then
		setElementPositions(x,y,z)
	elseif global['Mode'] == 'Rotation' then
		local m = global.snap and 1 or 100
		setElementRotations(x*m,y*m,z*m)
	end	
end

table.insert(binds.dynamic,{'Element Height',{'num_add','num_sub'},'Selected'}) -- Name first, then binds (For multiple binds)


functions['Speed Modifiers'] = function ()--// Need to be able to send lshift and lalt alt so that other components can read this.
	if EditSelected then return end
end
table.insert(binds.dynamic,{'Speed Modifiers',{'lshift','lalt'},'Mix'}) -- Name first, then binds (For multiple binds)

functions['Replace Elements'] = function () --// Only show this when an element is selected and you are 
end
table.insert(binds.dynamic,{'Replace Element(s)',{'mouse1','rctrl'},'Selected'})

functions['Select By Bounding'] = function ()
end
table.insert(binds.dynamic,{'Select By Bounding',{'lctrl'}}) --// Need to send out ralt

--\\ Dynamic Binds //--
-----------------------

----------------------
--// Static Binds \\--
--// These are buttons that you push once and it executes (Holding does nothing)
functions['Menu Controls'] = function (key)
	if EditSelected then return end
	if global.OptionHover then
		local a,b = unpack(global.OptionHover)
		if binds.layout['Menu Controls'][1] == key then
			functions['Option'](1,a,b)
		else
			functions['Option'](-1,a,b)
		end
	end
end

table.insert(binds.static,{'Menu Controls',{'arrow_l','arrow_r'}})


functions['Select Element(s)'] = function ()
	if EditSelected then return end
end
table.insert(binds.static,{'Select Element(s)',{'mouse1'}}) -- Name first, then binds (For multiple binds)


functions['Open Menu'] = function ()
	if EditSelected then return end
	centerMenuMisc.showing = not centerMenuMisc.showing
	if centerMenuMisc.showing then
		centerMenuMisc.showing = 'main'
	end
end
table.insert(binds.static,{'Open Menu',{'mouse2'}})

functions['Show Cusor'] = function ()
	if EditSelected then return end
	showCursor(not isCursorShowing())
end
table.insert(binds.static,{'Show Cusor',{'Q'}}) 


functions['Toggle Freecam'] = function ()
	if EditSelected then return end
	functions.Camera()
end
table.insert(binds.static,{'Toggle Freecam',{'E'}}) -- Name first, then binds (For multiple binds)


functions['Change Movement Speed'] = function ()
	if EditSelected then return end
	global.count['Speed'] = global.count['Speed'] + 1
	if global.count['Speed'] > global.speedC then
		global.count['Speed'] = 1
	end

functions['Speed'](nil,global.count['Speed'])
end
table.insert(binds.static,{'Change Movement Speed',{'F'},'FreeCam'})

functions['Change Magnet Selection'] = function ()
	if EditSelected then return end
	global.count['Magnets'] = (global.count['Magnets'] or 0) + 1
	if global.count['Magnets'] > 4 then
		global.count['Magnets'] = 1
	end

functions['Magnets'](nil,global.count['Magnets'])
end
table.insert(binds.static,{'Change Magnet Selection',{'M'},'FreeMove'})

functions['Copy / Stack Element(s)'] = function ()
	if isFreecamEnabled() then
		if getKeyState(binds.layout['Copy / Stack Element(s)'][2]) then
			if getKeyState(binds.layout['Copy / Stack Element(s)'][1]) then
				local element,x,y,z = getHighLightedElement()
				if element then
					local vector = getAlignment(element,x,y,z)
					--local vector = matrix:getPosition()
					callS('CloneS',element,vector.x,vector.y,vector.z)
				end
			else
				callS('CloneG',selectedElements)
			end
		end
	end
end
table.insert(binds.static,{'Copy / Stack Element(s)',{'lshift','c'},'FreeMove'})

functions['Delete Selected'] = function ()
	if isFreecamEnabled() then
		callS('DeleteElements',selectedElements)	
	end
	selectedElements = {}
end
table.insert(binds.static,{'Delete Selected',{'delete'},'Selected'})


functions['Toggle Move'] = function ()
	if isFreecamEnabled() and not isCursorShowing() then
		freeMove = not freeMove
		if not freemove then
			if isThereSelected() and global.Mangets and mClose.connection then --// Only do this if these all are true.
				functions.magnetMovement()
				mClose.connection = nil
			end
		else
			for i,v in pairs(selectedElements()) do
				functions.prepMagnets(i)
			end
		end
	end
end
table.insert(binds.static,{'Toggle Move',{'space'}})


for i,v in pairs(binds.static) do
	for iA,vA in pairs(v[2]) do
		bindKey ( vA, "down", functions[v[1]] )
	end
	
	binds.layout[v[1]] = v[2]
end



--\\ Static Binds //--
----------------------


-------------------
--// Binds Check \\--

functions.check = {}

functions.check.FreeCam = function ()
	return isFreecamEnabled()
end

functions.check.Mix = function ()
	return isFreecamEnabled() or isThereSelected()
end

functions.check.Selected = function ()
	return (isThereSelected() and isFreecamEnabled())
end


functions.check.FreeMove = function ()
	return (isThereSelected() and freeMove)
end

functions.check.One = function ()
	return isThereSelected(true) == 1 
end


--\\ Binds Check //--
---------------------