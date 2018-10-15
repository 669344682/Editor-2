---------------------
---// Left menu \\---

buttons.left = {{'Save'},{'Controls','Camera','Preview'},selected = {},menu = {}} -- Left menu, first two tables are the left / right part of the top menu.
-- button types, Option and Side Option (More can be added, however requires modifications to GUI)


functions['Save'] = function () -- Return later
	saveMenu.Open = not saveMenu.Open
end


functions['Controls'] = function() -- Controls
	global.Controls = not global.Controls
end


functions['Camera'] = function () -- Camera
	global.Camera = not global.Camera

	callS('removePedFromVehicleS')
	
	local _,_,rotation = getElementRotation(getCamera())
	
	if global.Camera then
		local x,y,z = getElementPosition(localPlayer)
		setFreecamEnabled(x,y,z)
		
		setElementPosition(localPlayer,0,0,1000)
		setElementFrozen(localPlayer,true)	 
		
	timR = setTimer ( function()
		setElementPosition(localPlayer,0,0,1000)
		setElementFrozen(localPlayer,true)	 
	end, 500, 1 )
 
	
	else
		if isTimer(timR) then
			killTimer(timR)
		end
		
		local x,y,z = getCameraMatrix()
		setFreecamDisabled()

			setElementPosition(localPlayer,x,y,z)
			setElementRotation(localPlayer,0,0,rotation)
		setCameraTarget(localPlayer)
		setElementFrozen(localPlayer,false)
		setCameraTarget(localPlayer)
	end
end


functions['Preview'] = function() -- Preview (WIP)

end



table.insert(buttons.left.menu,{'Speed','Option',{'ZFixer','Slow as hell','Slowest','Slower','Slow','Normal','Fast','Faster','Faster Still','Fastest'}}) -- Speed
functions['Speed'] = function (input,index)
	CameraSpeed = math.max((2^(index-1))/200,0.001)
end
functions['Speed'](nil,6)
global.count['Speed'] = 6
global.speedC = #buttons.left.menu[#buttons.left.menu][3]


table.insert(buttons.left.menu,{'Boundries','Option',{'None','Selected','On Screen'}}) 
functions['Boundries'] = function (input,index) -- Boundries
	global['Boundries'] = input
end
global.count['Boundries'] = 2
global['Boundries'] = 'Selected'


table.insert(buttons.left.menu,'blank') -- Short Blank


table.insert(buttons.left.menu,{'Mode','SideOption',{'Movement','Rotation','Scale'}})
functions['Mode'] = function (input,index) -- Mode

	if input == 'Scale' then
		global['Move Type'] = 'Local'
		global.count['Move Type'] = 1
	elseif (input == 'Rotation') and (global['Move Type'] == 'Screen')then
		global['Move Type'] = 'World'
		global.count['Move Type'] = 1
	end
	
	prepMoveTypes(input)
	
	if global['Mode'] == input then
		global['Mode'] = nil
	else
		global['Mode'] = input
	end
end
global['Mode'] = 'Movement' 


function prepMoveTypes(input)
	if input == 'Movement' then
		mTable[3] = {'World','Local','Screen'}
	elseif input == 'Rotation' then
		mTable[3] = {'World','Local'}
	else
		mTable[3] = {'Local'}
	end
end

table.insert(buttons.left.menu,{'Move Type','Option',{'World','Local','Screen'}})
functions['Move Type'] = function (input,index)
	global['Move Type'] = input
end
global['Move Type'] = 'World'
mTable = buttons.left.menu[#buttons.left.menu]


table.insert(buttons.left.menu,{'Magnets','Option',{'Off','Low','Medium','High'}}) -- Magnet Strength
functions['Magnets'] = function (input,index)
	if index == 1 then
		global.Mangets = nil
	else
		global.Mangets = index
	end
end


table.insert(buttons.left.menu,{'Snap','Option',{'off',1,2,3,4,5,6,7,8,9,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180}}) -- What mode
functions['Snap'] = function (input,index)
	global.snap = tonumber(input)
end


table.insert(buttons.left.menu,{'Depth','Option',{10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160,170,180,190,200}}) -- Might move this to a range maybe?
functions['Depth'] = function (input,index)
	selectionDepth = index*10 --// This is the depth of the tool. If set to 10 it'll only scan 10 units in front of you for elements.
end
functions['Depth'](nil,5)
global.count['Depth'] = 5 


---\\ Left menu //---
---------------------
--------------------
--// Misc Menus \\--


centerMenu['main'] = {}

table.insert(centerMenu['main'],{{'Delete Selected'},'delete','Delete slected elements.','Selected'})


table.insert(centerMenu['main'],{{'Mirror','MirrorX'},'MirrorXC','Mirror Selected Elements\non X axis','Selected'})
table.insert(centerMenu['main'],{{'Mirror','MirrorY'},'MirrorYC','Mirror Selected Elements\non Y axis','Selected'})
table.insert(centerMenu['main'],{{'Mirror','MirrorZ'},'MirrorZC','Mirror Selected Elements\non Z axis','Selected'})

functions['Mirror'] = function (input,index) -- Mode
	if input == 'MirrorX' then
		functions.mirrorElements(1,0,0)
	elseif input == 'MirrorY' then
		functions.mirrorElements(0,1,0)
	else
		functions.mirrorElements(0,0,1)
	end
end

table.insert(centerMenu['main'],{{'Quick Save'},'Save','Quickly save your map.'})

functions['Quick Save'] = function () -- Return later
	if global.mapName and global.mapFormat then
		functions.saveR(global.mapFormat,global.mapName)
	else
		saveMenu.Open = not saveMenu.Open
	end
end

table.insert(centerMenu['main'],{{'Deselect All'},'deselect','Deselect slected elements.','Selected'})


functions['Deselect All'] = function () -- Return later
	for i,v in pairs(selectedElements) do
	setElementCollisionsEnabled(i,true)
	setElementFrozen(i,false)
	callS('freezeElement',i,false)
	selectedElements[i] = nil
	end
	selectedElements = {}
	lHover = nil
end


functions['return'] = function () -- Return later
	centerMenuMisc.showing = 'main'
end


functions['Copy\nCoordinates'] = function () -- Return later
	centerMenuMisc.showing = 'Coordinate'
end

table.insert(centerMenu['main'],{{'Copy\nCoordinates'},'coordinateMisc','\nCopy coordianates of\nslected elements.','Selected'})

functions['Paste\nCoordinates'] = function () -- Return later
	if cPosition then
		local x = cPosition[1]
		local y = cPosition[2]
		local z = cPosition[3]

		for i,v in pairs(selectedElements) do
			local xr,yr,zr = getElementPosition(i)
			local x,y,z = (x or xr),(y or yr),(z or zr)
			setElementPosition(i,x,y,z)
		end
	elseif cRotation then
		local x = cRotation[1]
		local y = cRotation[2]
		local z = cRotation[3]
		for i,v in pairs(selectedElements) do
			local xr,yr,zr = getElementRotation(i)
			local x,y,z = (x or xr),(y or yr),(z or zr)
			setElementRotation(i,x,y,z)
		end
	end
end

table.insert(centerMenu['main'],{{'Paste\nCoordinates'},'coordinateMisca','\nPaste coordianate(s).','Selected'})



centerMenu['Coordinate'] = {}

table.insert(centerMenu['Coordinate'],{{'return'},'back','Return to mainmenu.'})



functions['Copy Pos'] = function (input) -- Return later
	local x,y,z = getSelectedElementsCenter()
	cRotation = nil
	if input == 'X Pos' then
		cPosition = {x,nil,nil}
	elseif input == 'Y Pos' then
		cPosition = {nil,y,nil}
	elseif input == 'Z Pos' then
		cPosition = {nil,nil,z}
	else
		cPosition = {x,y,z}
	end
end

table.insert(centerMenu['Coordinate'],{{'Copy Pos','X Pos'},'Move Type','Copy X Position.','Selected'})
table.insert(centerMenu['Coordinate'],{{'Copy Pos','Y Pos'},'Move Type','Copy Y Position.','Selected'})
table.insert(centerMenu['Coordinate'],{{'Copy Pos','Z Pos'},'Move Type','Copy Z Position.','Selected'})
table.insert(centerMenu['Coordinate'],{{'Copy Pos','Position'},'Move Type','Copy Position.','Selected'})

functions['Copy Rot'] = function (input) -- Return later
	local _,object = isThereSelected(true)
	if isElement(object) then
		cPosition = nil
		local xr,yr,zr = getElementRotation(object)
		if input == 'X Rot' then
			cRotation = {xr,nil,nil}
		elseif input == 'Y Rot' then
			cRotation = {nil,yr,nil}
		elseif input == 'Z Rot' then
			cRotation = {nil,nil,zr}
		else
			cRotation = {xr,yr,zr}
		end
	end
end

table.insert(centerMenu['Coordinate'],{{'Copy Rot','X Rot'},'Rotation Type','Copy X Rotation.','One'})
table.insert(centerMenu['Coordinate'],{{'Copy Rot','Y Rot'},'Rotation Type','Copy Y Rotation.','One'})
table.insert(centerMenu['Coordinate'],{{'Copy Rot','Z Rot'},'Rotation Type','Copy Z Rotation.','One'})
table.insert(centerMenu['Coordinate'],{{'Copy Rot','Rotation'},'Rotation Type','Copy Rotation.','One'})

functions.cMenu = function (input)
	centerMenuMisc.current = input or 'main'
end

centerMenuMisc.fade = 0
centerMenuMisc.cFade = 0

functions.drawCentMenuInfo = function (image,title,description,x,y,width)
	centerMenuMisc.im = image or centerMenuMisc.im 
	centerMenuMisc.tit = title or centerMenuMisc.tit
	centerMenuMisc.dec = description or centerMenuMisc.dec
	
	local mFade = centerMenuMisc.fade
	
	if image then
		centerMenuMisc.cFade = math.min(centerMenuMisc.cFade + 16,180)
		else
		centerMenuMisc.cFade = math.max(centerMenuMisc.cFade - 8,0)
		if centerMenuMisc.im then
			dxDrawImage(x,y,width,width,centerMenuMisc.im, 0, 0, 0, tocolor(255, 255, 255, (centerMenuMisc.cFade/2)*mFade), true)	
			dxDrawText ( centerMenuMisc.tit,(xSize/2),(ySize/2)-((120*s)*mFade),(xSize/2),(ySize/2), tocolor ( 255, 255, 255, (centerMenuMisc.cFade*1.4)*mFade ), 1.8*mFade,'default-bold','center','center',false,false,true)
			dxDrawText ( centerMenuMisc.dec,(xSize/2),(ySize/2)-((40*s)*mFade),(xSize/2),(ySize/2)-((40*s)*mFade), tocolor ( 220, 220, 220, centerMenuMisc.cFade*mFade ), 1.1*mFade,'default','center','top',false,false,true)
		end
	end
end



functions.draw.centerMenu = function ()
	if centerMenuMisc.showing or centerMenuMisc.fade > 0.01 then
		if centerMenuMisc.showing then
			centerMenuMisc.fade = math.min(centerMenuMisc.fade + 0.1,1)
		else
			centerMenuMisc.fade = math.max(centerMenuMisc.fade - 0.1,0)
		end
		
		local mFade = centerMenuMisc.fade
		
		if isCursorShowing() then
			local cx,cy = getCursorPosition()
			local image = functions.prepImage('center')
			local button = functions.prepImage('center-exit')
			local icon = functions.prepImage('circle selection')
			local width = (400*s)*mFade
			local x = (xSize-width)/2
			local y = (ySize-width)/2
			dxDrawImage(x,y,width,width,image, 0, 0, 0, tocolor(255, 255, 255, 90*mFade), true)	
			
			
			if toggle then
				toggle = getKeyState('mouse1')
			end
			
			
			if (getDistanceBetweenPoints2D(cx*xSize,cy*ySize,xSize/2,ySize/2) < (width/4.5)) and (cy*ySize > ((ySize/2)+24*s))then
				ignoreGimbal = not (lMovement)
				if getKeyState('mouse1') then
					dxDrawImage(x,y,width,width,button, 0, 0, 0, tocolor(35, 35, 35, 180*mFade), true)	
					if not toggle then
						toggle = true
						centerMenuMisc.showing = false
					end
				else
					dxDrawImage(x,y,width,width,button, 0, 0, 0, tocolor(13, 13, 13, 180*mFade), true)	
				end
				dxDrawText ( 'Close',(xSize/2),(ySize/2)+((120*s)*mFade),(xSize/2),(ySize/2), tocolor ( 240, 240, 240, 130*mFade ), 1.5*mFade,'default-bold','center','center',false,false,true)
			else
				dxDrawImage(x,y,width,width,button, 0, 0, 0, tocolor(0, 0, 0, 180*mFade), true)	
				dxDrawText ( 'Close',(xSize/2),(ySize/2)+((120*s)*mFade),(xSize/2),(ySize/2), tocolor ( 255, 255, 255, 180*mFade ), 1.5*mFade,'default-bold','center','center',false,false,true)
			end
			

			local menu = centerMenuMisc.showing or centerMenuMisc.current or 'main'
			
			centerMenuMisc.current = menu
			
			local countC = ((((amountC or 0)/2)))

			amountC = 0
			for i,v in pairs(centerMenu[menu]) do
				cContinue = true
				if functions.check[v[4]] then
					if functions.check[v[4]]() then
						cContinue = true
					else
						cContinue = false
					end
				end
				if cContinue then
					amountC = amountC + 1
					local i = (amountC - 0.5 - countC)
					if (getDistanceBetweenPoints2D(cx*xSize,cy*ySize,xSize/2,ySize/2) < (width/2)) and (getDistanceBetweenPoints2D(cx*xSize,cy*ySize,xSize/2,ySize/2) > (width/4)) and isPointInTriangle(Vector2(cx*xSize,cy*ySize),Vector2(xSize/2,ySize/2),findPointOnCircle(width,(i*30)-15),findPointOnCircle(width,(i*30)+15)) then
						local width = (410*s)*mFade
						local x = (xSize-width)/2
						local y = (ySize-width)/2

						if getKeyState('mouse1') then
							dxDrawImage(x,y,width,width,icon, ((i)*30), 0, 0, tocolor(70, 70, 70, 255*mFade), true)
						if not toggle then
							toggle = true
							if functions[v[1][1]] then
								functions[v[1][1]](v[1][2])
							end
						end
						else
							dxDrawImage(x,y,width,width,icon, ((i)*30), 0, 0, tocolor(25, 25, 25, 255*mFade), true)
						end
						
						functions.drawCentMenuInfo(image,v[1][2] or v[1][1],v[3],x,y,width*mFade)
						
						local point = findPointOnCircle(width/2.67,(i*30))
						dxDrawImage(point.x-((20*s)*mFade),point.y-((20*s)*mFade),(40*s)*mFade,(40*s)*mFade,functions.prepImage(v[2] or v[1][1]), 0, 0, 0, tocolor(255, 255, 255, 255*mFade), true)
					else
						dxDrawImage(x,y,width,width,icon, ((i)*30), 0, 0, tocolor(0, 0, 0, 255*mFade), true)
						local point = findPointOnCircle(width/2.7,(i*30))
						dxDrawImage(point.x-((20*s)*mFade),point.y-((20*s)*mFade),(40*s)*mFade,(40*s)*mFade,functions.prepImage(v[2] or v[1][1]), 0, 0, 0, tocolor(255, 255, 255, 255*mFade), true)
					end
				end
			end
			functions.drawCentMenuInfo(nil,nil,nil,x,y,width)
		end
	end
end

saveMenu.Types = {'.map','.lua','.JSP'}


functions.saveR = function (format)
	local settingTable = {}
	local mSettings = mapSetting.menuSettings
	for i,v in pairs(mapSetting.settings) do
		if not (v[2] == mSettings[v[1]]) then
			table.insert(settingTable,{i,mSettings[v[1]]})
		end
	end
	local gamemodes = table.concat(mapSetting.gameModes,',')
	
	callS('save',format,mapName,settingTable,mSettings['Map Name'],mSettings['Author'],mSettings['Version'],mSettings['Description'],gamemodes)--// So this is where the client sends the signal to the server to save; meaning we gotta send name, author, description, ect.
end

	

functions['SaveMenu'] = function (input,exta)
	if input == 'Close' then
		saveMenu.Open = nil
	elseif input == 'Type' then
		saveMenu.Type = not saveMenu.Type
	elseif input == 'SetType' then
		saveMenu.SType = exta
		saveMenu.Type = nil
	elseif input == 'Save(OW)' then
		global.mapFormat = (saveMenu.SType or '.map')
		functions.saveR(saveMenu.SType or '.map')
	elseif input == 'Save(N)' then
		functions.saveR(saveMenu.SType or '.map')
	end
end


function functions.draw.SaveMenu()
	if saveMenu.Open then
		local closE = functions.isCursorOnElement(930*s, 410*s, 15*s, 15*s,'SaveMenu','Close')
		local cColor = (closE and 150 or 210)
		
		dxDrawImage(930*s, 410*s, 15*s, 15*s,functions.prepImage('close'), 0, 0, 0, tocolor(cColor, cColor, cColor, cColor), true)
		
		--
		dxDrawRectangle(646*s, 430*s, 309*s, 68*s, tocolor(0, 0, 0, 115), true)
		
		dxDrawRectangle(646*s, 405*s, 309*s, 24*s, tocolor(76, 76, 76, 140), true)
		
		dxDrawText("Save", 646*s, 405*s, 955*s, 431*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "center", "center",false,false,true)
		--
		
		mapName = dxDrawEditBox(651*s, 436*s, 229*s, 26*s,1*s,'default',tocolor(0,0,0,197),'Save','',false,tocolor(166, 166, 166, 197),dc)
		
		local typeE = functions.isCursorOnElement(884*s, 436*s, 61*s, 26*s,'SaveMenu','Type')
		local tColor = (typeE and 150 or 210)
		
		dxDrawRectangle(884*s, 436*s, 61*s, 26*s, tocolor(47, 47, 47, tColor), true)
		dxDrawText(saveMenu.SType, 884, 436, 945, 462, tocolor(254, 254, 254, 140), 1.00, "default-bold", "center", "center",false,false,true)
		
		if saveMenu.Type then 
			for i,v in pairs(saveMenu.Types) do
				local position = 436+(27*i)
				
				local typeE = functions.isCursorOnElement(884*s, position*s, 61*s, 26*s,'SaveMenu','SetType',v)
				local tColor = (typeE and 150 or 210)
		
				dxDrawRectangle(884*s, position*s, 61*s, 26*s, tocolor(17, 17, 17, tColor), true)
				dxDrawText(v, 884*s, position*s, 945*s, (position+26)*s, tocolor(254, 254, 254, 140), 1.00*s, "default-bold", "center", "center",false,false,true)
			end
		end
		
		local saveE = functions.isCursorOnElement(652*s, 467*s, 105*s, 25*s,'SaveMenu','Save(OW)')
		local sColor = (saveE and 120 or 210)
		
		dxDrawRectangle(652*s, 467*s, 105*s, 25*s, tocolor(23, 23, 23, sColor), true)
		dxDrawText("Save", 652*s, 466*s, 757*s, 492*s, tocolor(254, 254, 254, 140), 1.00, "default-bold", "center", "center",false,false,true)
	end
end


--\\ Misc Menus //--
--------------------

--------------------
--// Right menu \\--
buttons.right = {{'Customize','New Element','Ped Editor','Settings','Load'},menu = {}}
-- button types, Option, List, Color, Material, Text, Number, Checkbox,

buttons.right.menu['Customize'] = {menu = {},lists = {},extras = {}}
buttons.right.menu['New Element'] = {menu = {},lists = {},extras = {'Search'}} -- extras / Search means this menu contains a search bar at top in any level. So that you can type in an elements name it'll come up.
buttons.right.menu['Ped Editor'] = {menu = {},lists = {},extras = {}}
buttons.right.menu['Settings'] = {menu = {},lists = {}}
buttons.right.menu['Load'] = {menu = {},lists = {},extras = {'Search'}}


functions['RightMenu'] = function(name)
	if name == 'Load' then
		functions.listMaps()
	end
	buttons.right.selected = name
end

-- Look in client for a lua file with the corresponding name to what you are looking to edit; it's simplified here because there's so much going on in these ones.
--\\ Right menu //--
--------------------


guiTypes['Option'] = function (wStart,hStart,path,iTable,side) --v[1],rStart,start
	local image = functions.prepImage(path)
		
		global.count[path] = global.count[path] or 1 
		
		local hoverA = hover == path and 150 or 255
		if image then
			dxDrawImage((wStart+5)*s, (hStart)*s, 24*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, 255), true)	
		end
		dxDrawText(path,(wStart+(image and 35 or 20))*s, hStart*s, (wStart+219)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		dxDrawText(iTable[global.count[path]],(wStart+120)*s, hStart*s, (wStart+200)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "center", "center", false, false, true, false, false)
		
		mapSetting.menuSettings[path] = iTable[global.count[path]]
		
		local hoverL = functions.isCursorOnElement((wStart+115)*s, (hStart+7.5)*s, 15*s, 10*s,'Option',-1,path,#iTable,iTable) and 150 or 255
		dxDrawImage((wStart+115)*s, (hStart+7.5)*s, 15*s, 10*s,arrow, 0, 0, 0, tocolor(hoverL, hoverL, hoverL, 255), true)	
		local hoverR = functions.isCursorOnElement((wStart+185)*s, (hStart+7.5)*s, 15*s, 10*s,'Option',1,path,#iTable,iTable) and 150 or 255
		dxDrawImage((wStart+185)*s, (hStart+7.5)*s, 15*s, 10*s,arrow, 180, 0, 0, tocolor(hoverR, hoverR, hoverR, 255), true)	


	if functions.isCursorOnElement(wStart*s, hStart*s, 215*s, 10*s,'Option',path,#iTable) then
		global.OptionHover = {path,#iTable}
	end
end

function functions.Option(change,path,tableCount,iTable)
	if tonumber(change) then
		global.count[path] = global.count[path] + change

		if global.count[path] > tableCount then
			global.count[path] = 1
		elseif global.count[path] < 1 then
			global.count[path] = tableCount
		end
	end
	
	if iTable then
		if functions[path] then
			functions[path](iTable[global.count[path]],global.count[path])
		end
	end
end


function functions.OptionS(path,iTable,new)
	for i,v in pairs(iTable) do
		if v == new then
			global.count[path] = i 
		end
	end
end



guiTypes['SideOption'] = function (wStart,hStart,name,iTable,side)--rStart,start,v[3],v // Ignore the mess on this one, it has to be like this.
	if iTable[1] then
		local image = functions.prepImage(iTable[1])
		local color = (global[name] == iTable[1]) and 250
		local b = (functions.isCursorOnElement((wStart+5)*s, (hStart+2)*s, 68*s, 20*s,name,iTable[1]) and 200 or 150)
		local color = color or b
		dxDrawRectangle((wStart+5)*s, (hStart+2)*s, 68*s, 20*s, tocolor(color, color, color, color), true)
		dxDrawImage((wStart+5)*s, (hStart)*s, 68*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end
				
	if iTable[2] then
		local image = functions.prepImage(iTable[2])
		local color = (global[name] == iTable[2]) and 250
		local b = (functions.isCursorOnElement((wStart+75)*s, (hStart+2)*s, 68*s, 20*s,name,iTable[2]) and 200 or 150)
		local color = color or b
		dxDrawRectangle((wStart+75)*s, (hStart+2)*s, 68*s, 20*s, tocolor(color, color, color, color), true)
		dxDrawImage((wStart+75)*s, (hStart)*s, 68*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, 255), true)	
	end
				
	if iTable[3] then
		local image = functions.prepImage(iTable[3])
		local color = (global[name] == iTable[3]) and 250
		local b = (functions.isCursorOnElement((wStart+145)*s, (hStart+2)*s, 68*s, 20*s,name,iTable[3]) and 200 or 150)
		local color = color or b
		dxDrawRectangle((wStart+145)*s, (hStart+2)*s, 68*s, 20*s, tocolor(color, color, color, color), true)
		dxDrawImage((wStart+145)*s, (hStart)*s, 68*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, 255), true)	
	end
	mapSetting.menuSettings[name] = global[name]
end


guiTypes['List'] = function (wStart,hStart,name,iTable,side,subtract,indexing,gTable,spacing)--rStart,start,buttons.right.reverseIndent

	if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
	
	dxDrawImage((wStart+10)*s, (hStart+6)*s, 12*s, 12*s,arrow, 180+(global.open[name] and 90 or 0), 0, 0, tocolor(255, 255, 255, 230), true)	
	dxDrawText(name, (wStart+40)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	
	functions.isCursorOnElement(wStart*s, hStart*s, (259-(subtract or 0))*s, 24*s,'List',name)
	end
	
	if global.open[name] then
		for i,v in pairs(iTable) do

			buttons[side].index = buttons[side].index + 1
			global.scroll = global.scroll + 1
				
			if (not (iTable[i][2] == 'List')) and (not (iTable[i][2] == 'Map')) then
				if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
					dxDrawRectangle((wStart+15)*s, (spacing+24.5*(buttons[side].index-(indexing or 0)))*s, (259-(subtract or 0)-15)*s, 24*s, tocolor(45, 45, 45, 80), true)
					if guiTypes[iTable[i][2]] then
						guiTypes[iTable[i][2]](wStart+15,spacing+(24.5*(buttons[side].index-indexing)),iTable[i][1],iTable[i][3],side,subtract,indexing,gTable,spacing,iTable[i])
					end
				end
			else
				if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
					dxDrawRectangle((wStart+15)*s, (spacing+24.5*(buttons[side].index-(indexing or 0)))*s, (259-(subtract or 0)-15)*s, 24*s, tocolor(35, 35, 35, 120), true)
				end
				guiTypes[iTable[i][2]](wStart+15,spacing+(24.5*(buttons[side].index-indexing)),iTable[i][1],gTable[iTable[i][1]],side,subtract+15,indexing,gTable,spacing,iTable[i])
			end
		end
	end
end

functions['List'] = function (name)
	global.open[name] = not global.open[name]
end


guiTypes['Object'] = function (wStart,hStart,name,iTable,side,subtract,indexing,gTable,spacing,tabl)
	if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
		local image = functions.prepImage('Object')
		dxDrawText(tabl[5], (wStart+25)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
		
		local hover = functions.isCursorOnElement((wStart+2)*s,hStart*s, 150*s, 24*s,'Object',tabl)
		
		if hover then
			oSelect = name
		end
		
		dxDrawImage((wStart+2)*s,(hStart)*s, 20*s,20*s,image, 0, 0, 0, tocolor(255, 255, 255, hover and 150 or 230), true)	
		
		
		if not (SearchText == '') then
			dxDrawText(((tabl[4] or {})[1]) or '', (wStart+120+(60))*s, hStart*s, (wStart+120+(60))*s, (hStart+24)*s, tocolor(180, 180, 180, 180), 0.8*s, "default-bold", "left", "center", false, false, true, false, false)
		end
	end
end



guiTypes['Map'] = function (wStart,hStart,name,iTable,side,subtract,indexing,gTable,spacing,tabl)--rStart,start,buttons.right.reverseIndent

	if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
	
	local hover = functions.isCursorOnElement(wStart*s, hStart*s, (259-(subtract or 0))*s, 24*s,'Map',name)
	
	local image = functions.prepImage('Map')
	dxDrawImage((wStart+5)*s,(hStart+2)*s, 20*s,20*s,image, 180+(global.open[name] and 90 or 0), 0, 0, tocolor(255, 255, 255, hover and 150 or 230), true)	
	dxDrawText(name, (wStart+40)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	
		if (not (SearchText == '')) and tabl[3] then
			dxDrawText(tabl[3], (wStart+120+(60))*s, hStart*s, (wStart+120+(60))*s, (hStart+24)*s, tocolor(180, 180, 180, 180), 0.8*s, "default-bold", "left", "center", false, false, true, false, false)
		end
	end
	
	if global.open[name] then
		for i,v in pairs(iTable or {}) do

			buttons[side].index = buttons[side].index + 1
			global.scroll = global.scroll + 1
				
			if (not (iTable[i][2] == 'List')) and (not (iTable[i][2] == 'Map')) then
				if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
					dxDrawRectangle((wStart+15)*s, (spacing+24.5*(buttons[side].index-(indexing or 0)))*s, (259-(subtract or 0)-15)*s, 24*s, tocolor(45, 45, 45, 80), true)
					if guiTypes[iTable[i][2]] then
						guiTypes[iTable[i][2]](wStart+15,spacing+(24.5*(buttons[side].index-indexing)),iTable[i][1],iTable[i][3],side,subtract,indexing,gTable,spacing,iTable[i])
					end
				end
			else
				if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
					dxDrawRectangle((wStart+15)*s, (spacing+24.5*(buttons[side].index-(indexing or 0)))*s, (259-(subtract or 0)-15)*s, 24*s, tocolor(35, 35, 35, 120), true)
				end
				guiTypes[iTable[i][2]](wStart+15,spacing+(24.5*(buttons[side].index-indexing)),iTable[i][1],gTable[iTable[i][1]],side,subtract+15,indexing,gTable,spacing,iTable[i])
			end
		end
	end
end

guiTypes['File'] = function (wStart,hStart,name,iTable,side,subtract,indexing,gTable,spacing,tabl)
	if (buttons[side].index-indexing) > 0 and (buttons[side].index-indexing) < 15 then
		local hover = functions.isCursorOnElement((wStart+2)*s,hStart*s, 150*s, 24*s,'File',name,tabl[3])
		dxDrawText(name, (wStart+25)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, hover and 150 or 230), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	end
end

functions['File'] = function(file,resource)
	local type = string.lower(split(file,'.')[2])
	local tFile = ':'..resource..'/'..file
	callS('loadMapFile',tFile,type,resource)
end




functions['Map'] = function (name)
	global.open[name] = not global.open[name]
end



functions['Object'] = function (tabl)
	local x,y,z = getWorldFromScreenPosition (xSize/2, ySize/2,(selectionDepth or 40)/2)
	callS('ObjectS',selectedElements,tabl[5],getKeyState('lctrl'),x,y,z)
end


functions['Select'] = function (object)
	selectedElements[object] = true
end


guiTypes['Color'] = function (wStart,hStart,name,iTable,side,subtract,indexing,gTable)

if mapSetting.menuSettings[name] then
	r,g,b = hex2RGB(mapSetting.menuSettings[name])
end

rC,gC,bC = unpack(iTable)

local rC = r or rC
local gC = g or gC
local gC = g or gC

local hover = functions.isCursorOnElement((wStart+120)*s,hStart*s, (85-(subtract or 0))*s, 24*s,'Color',name,rC,gC,bC)
local alpha = hover and 150 or 255

if colorpicker.Open then
rC,gC,bC = unpack(colorpicker.colorbar)
end

dxDrawRectangle((wStart+120)*s,hStart*s, (85-(subtract or 0))*s, 24*s, tocolor(rC,gC,bC, alpha), true)

dxDrawText(name, (wStart+20)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)

mapSetting.menuSettings[name] = rgb2hex(rC,gC,bC)
end

functions['Color'] = function(name,r,g,b)
	local ra,ga,ba,wB,hB = unpack(colorpicker.colorbar)
	colorpicker.colorbar = {r,g,b,wB,hB,rgb2hex(r,g,b)}
	colorpicker.Open = true
	colorpicker.Arrow = true
end


guiTypes['Material'] = function ()


end


guiTypes['Text'] = function (wStart,hStart,name,iTable,side,subtract,indexing)
	local hover = functions.isCursorOnElement((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,'Text',name,Text[name] or iTable)

	local alpha = hover and 50 or 70

	local edit = dxDrawEditBox((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,1*s,'default',tocolor(0,0,0),name,mapSetting.menuSettings[name] or iTable) --// Modified version
	mapSetting.menuSettings[name] = edit

	TextA = TextA + 1
	dxDrawText( name, (wStart+20)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
	return edit
end


functions['Text'] = function(name,iTable)
	Text[name] = iTable
	Text.Selected = name
end


guiTypes['Number'] = function (wStart,hStart,name,iTable,side,subtract,indexing) -- In all reality same as 'Text but with a singular variable change.
	local hover = functions.isCursorOnElement((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,'Text',name,Text[name] or iTable)

	local alpha = hover and 50 or 70

	local edit = dxDrawEditBox((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,1*s,'default',tocolor(15,15,15),name,mapSetting.menuSettings[name] or iTable,2) --// Modified version

	TextA = TextA + 1
	
	mapSetting.menuSettings[name] = edit
	
	dxDrawText( name, (wStart+20)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

guiTypes['Whole Positive Number'] = function (wStart,hStart,name,iTable,side,subtract,indexing)
	local hover = functions.isCursorOnElement((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,'Text',name,Text[name] or mapSetting.menuSettings[name] or iTable)

	local alpha = hover and 50 or 70

	local edit = dxDrawEditBox((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,1*s,'default',tocolor(15,15,15),name,iTable,4)

	TextA = TextA + 1
	
	mapSetting.menuSettings[name] = edit
	
	dxDrawText( name, (wStart+20)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end

guiTypes['integer'] = function (wStart,hStart,name,iTable,side,subtract,indexing)
	local hover = functions.isCursorOnElement((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,'Text',name,Text[name] or mapSetting.menuSettings[name] or iTable)

	local alpha = hover and 50 or 70

	local edit = dxDrawEditBox((wStart+120)*s,hStart*s, (120-(subtract or 0))*s, 24*s,1*s,'default',tocolor(15,15,15),name,iTable,3)

	TextA = TextA + 1
	
	mapSetting.menuSettings[name] = edit
	
	dxDrawText( name, (wStart+20)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end



guiTypes['Check box'] = function (wStart,hStart,name,iTable,side,subtract,indexing) 

	local image = functions.prepImage('Check')

	global.Checked[name] = ((mapSetting.menuSettings[name] == 'true') and 1 or 2)
	
	
	local hover = functions.isCursorOnElement((wStart+120)*s,(hStart+5)*s, 14*s,14*s,'Check box',name)
	local alpha = hover and 200 or 255

	dxDrawRectangle((wStart+120)*s,(hStart+5)*s, 14*s,14*s, tocolor(255,255,255, alpha), true)

	if global.Checked[name] == 1 then
		dxDrawImage((wStart+120)*s,(hStart+5)*s, 14*s,14*s,image, 0, 0, 0, tocolor(255, 255, 255, 230), true)	
	end

	mapSetting.menuSettings[name] = tostring(global.Checked[name] == 1)
	
	TextA = TextA + 1
	dxDrawText( name, (wStart+20)*s, hStart*s, (wStart+239)*s, (hStart+24)*s, tocolor(255, 255, 255, 255), 1.00*s, "default-bold", "left", "center", false, false, true, false, false)
end


functions['Check box'] = function (name)
	global.Checked[name] = (global.Checked[name] == 1) and 2 or 1
end