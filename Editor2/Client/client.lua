fadeCamera(true)
setPlayerHudComponentVisible('all',false)
setCameraTarget(localPlayer)

----

height = 0
width = 0
arrow = functions.prepImage('arrow')


function functions.drawM()



	countb = countb + 0.5

	if not(prepX == 0) or not(prepY == 0) or not(prepZ == 0) then

		local x = math.min(rChange,prepX * isNegative(prepX)) * isNegative(prepX)
		local y = math.min(rChange,prepY * isNegative(prepY)) * isNegative(prepY)
		local z = math.min(rChange,prepZ * isNegative(prepZ)) * isNegative(prepZ)
		setElementRotations(x,y,z,true,nil,true)
		prepX = prepX-x
		prepY = prepY-y
		prepZ = prepZ-z
	end


	ignoreGimbal = nil
	
	for i,v in pairs(functions.draw) do
		v()
	end

	if colorpicker.Open then
		colorpicker.cfunction()
	end

	if TextA == 0 then
		Text.Selected = nil
		toggleAllControls ( true, true, true	)
	end

	if Option == 0 then
		global.OptionHover = nil
	end

	Option = 0
	TextA = 0

	yChange = 0

	--- Left menu ---
	local rStart = 16
	local rEnd = (rStart+218)
	dxDrawRectangle(rStart*s, 31*s, 219*s, 24*s, tocolor(62, 62, 62, 130), true)

	for i,v in pairs(buttons.left[1]) do
		local image = functions.prepImage(v)
		local color = global[v] and 150 or 255
		local color = (functions.isCursorOnElement(rStart-25+(30*(i))*s,31*s, 24*s, 24*s,v) and 80 or color)
		dxDrawImage((rStart-25+(30*(i)))*s,31*s, 24*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, color), true)
	end

	for i,v in pairs(buttons.left[2]) do
		local image = functions.prepImage(v)
		local color = global[v] and 150 or 255
		local color = (functions.isCursorOnElement((rEnd-(30*i))*s,31*s, 24*s, 24*s,v) and 80 or color)
		dxDrawImage((rEnd-(30*i))*s,31*s, 24*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, color), true)
	end

	buttons.left.subtract = 0
	buttons.left.endT = 0
	buttons.left.index = 0

	for i,v in pairs(buttons.left.menu) do
		continue = false
		if functions.check[v[4]] then
			if functions.check[v[4]]() then
				continue = true
			else
				continue = false
			end
		else
			continue = true
		end
			
		if continue then
			if (v == 'blank') then
				buttons.left.subtract = -20
				buttons.left.index = buttons.left.index + 1
			else
				buttons.left.index = buttons.left.index + 1
				local start = (buttons.left.subtract+30+(24.5*buttons.left.index))
				dxDrawRectangle(rStart*s, start*s, 219*s, 24*s, tocolor(5, 5, 5, 130), true)
				buttons.left.endT = math.max(buttons.left.endT,(start+24))
				guiTypes[v[2]](rStart,start,v[1],v[3],'left') -- Moved to function based drawing so that we can use the same type of draws on left, or right.
			end
		end
	end

	---24
	if not global.Controls then
		local start = buttons.left.endT+(15)

		dxDrawRectangle ( 15*s, (start-5)*s, 280*s, height*s, tocolor ( 0, 0, 0, 130 ),true )

		for i,v in pairs(binds.dynamic) do -- This allows us to order the index.
			continue = true
			if functions.check[v[3] or v[1]] then
				if functions.check[v[3] or v[1]]() then
					continue = true
				else
					continue = false
				end
			end
			if continue then
				size = 0
				local ya = 0

				for ia,va in pairs(v[2]) do
					local image,scale = functions.getLetter(va)
					local x,y = unpack(scale)
					local x,y = (x*0.16),(y*0.16)
					local color = getKeyState(va) and 150 or 255
					dxDrawImage((size+20)*s, (yChange+start)*s, x*s, y*s,image, 0, 0, 0, tocolor(220, 220, 220, color), true)

					size = size+(x+2)
					ya = math.max(ya,y+2)
				end
				dxDrawText(v[1], (width+30)*s, (yChange+start)*s, width*s, (yChange+(30)+start)*s, tocolor(255, 255, 255, 255), 0.9*s, "default-bold", "left", "center", false, false, true, false, false)
				yChange = yChange+ya
				width = math.max(width,size)
			end
		end

		yChange = yChange

		for i,v in pairs(binds.static) do -- This allows us to order the index.
			continue = true
			if functions.check[v[3] or v[1]] then
				if functions.check[v[3] or v[1]]() then
					continue = true
				else
					continue = false
				end
			end
			if continue then
				size = 0
				local ya = 0

				for ia,va in pairs(v[2]) do
					local image,scale = functions.getLetter(va)
					local x,y = unpack(scale)
					local x,y = (x*0.16),(y*0.16)

					local color = getKeyState(va) and 150 or 255
					dxDrawImage((size+20)*s, (yChange+start)*s, x*s, y*s,image, 0, 0, 0, tocolor(220, 220, 220, color), true)

					size = size+(x+2)
					ya = math.max(ya,y+2)
				end
				dxDrawText(v[1], (width+30)*s, (yChange+start)*s, width*s, (yChange+(30)+start)*s, tocolor(255, 255, 255, 255), 0.9*s, "default-bold", "left", "center", false, false, true, false, false)
				yChange = yChange+ya
				width = math.max(width,size)
			end
		end

		height = yChange+10
	end



	local rStart = (xSize - (275*s))
	local rEnd = (rStart+(259*s))
	dxDrawRectangle(rStart, 31*s, 259*s, 24*s, tocolor(62, 62, 62, 130), true)


	for i,v in pairs(buttons.right[1]) do
		local image = functions.prepImage(v)

		local color = (buttons.right.selected == v) and 100 or 255
		local color = functions.isCursorOnElement((rStart+(45*i)-22.5)*s, 31*s, 24*s, 24*s,'RightMenu',v) and 80 or color


		dxDrawImage((rStart+(45*i)-22.5)*s, 31*s, 24*s, 24*s,image, 0, 0, 0, tocolor(255, 255, 255, color), true)
	end

	local iTable = (buttons.right.menu[buttons.right.selected or 'New Element'])
	local count = #iTable

	additionalSpacing = 30
	if iTable.extras then
		if iTable.extras[1] then
			additionalSpacing = 55
			local start = (30+(24.5))
			SearchText = dxDrawEditBox(rStart,start*s, (259-(buttons.right.reverseIndent or 0))*s, 24*s,1*s,'default',tocolor(0,0,0),'Search Bar','',false,tocolor(250,250,250,200)) --// Modified version
			if SearchText and (not (SearchText == '')) then
				local result = Search(SearchText)
				count = #result
				iTable = result
			end
		else
			additionalSpacing = 30
		end
	end

	buttons.right.reverseIndent = 0
	buttons.right.index =	0

	if (global.scroll or 0) > 15 then
		local fix = (15/global.scroll)*342

		global.old = global.old or global.scroll

		if not (global.scroll-global.old == 0) then
			global.scrollRight = ((global.countadditionUF/(global.scroll-14))*(342-fix))
		end

		global.scrollRight = math.max(math.min(global.scrollRight,(342-fix)),0)

		global.countadditionUF = (global.scrollRight/(342-fix)*(global.scroll-14))
		global.countaddition = math.floor(global.countadditionUF)

		dxDrawRectangle(rEnd-(15*s), 55.5*s, 15*s, 342*s, tocolor(45, 45, 45, 100), true)
		dxDrawRectangle(rEnd-(15*s), (global.scrollRight+55.5)*s, 15*s, fix*s, tocolor(200, 200, 200, 90), true) -- Actual Scroll, math for this is going to be hell. Send help
		buttons.right.reverseIndent = 16 --
		functions.isCursorOnElementAlt(rEnd-(15*s), (global.scrollRight+55.5)*s, 15*s, fix*s,'scroll','scrollRight')


		if functions.isCursorOnElement(rStart+1, 56.5*s, 260*s, 343*s) then
			selectedScroll = 'scrollRight'
		else
			selectedScroll = nil
		end


		global.old = global.scroll
	else
		global.countaddition = 0
	end

	global.scroll = count

	for i=1,count do

		buttons.right.index = buttons.right.index + 1


		if (buttons.right.index-global.countaddition) > 0 and (buttons.right.index-global.countaddition) < 15 then
			local start = (additionalSpacing+(24.5*(buttons.right.index-global.countaddition)))
			dxDrawRectangle(rStart, start*s, (259-(buttons.right.reverseIndent or 0))*s, 24*s, tocolor(0, 0, 0, 130), true)
		end

		if iTable[i][2] then
			if iTable.lists then
				local start = (additionalSpacing+(24.5*(buttons.right.index-global.countaddition)))
				if guiTypes[iTable[i][2]] then
					guiTypes[iTable[i][2]](rStart/s,start,iTable[i][1],iTable.lists[iTable[i][1]],'right',buttons.right.reverseIndent,global.countaddition,iTable.lists,additionalSpacing) -- Moved to GUI types so that we can use it on left / right plus we will be drawing children, meaning it'd make no sense to repeat the function a million times.
				end
			else
				if (buttons.right.index-global.countaddition) > 0 and (buttons.right.index-global.countaddition) < 15 then
					local start = (additionalSpacing+(24.5*(buttons.right.index-global.countaddition)))
					guiTypes[iTable[i][2]](rStart/s,start,iTable[i][1],iTable[i][3],'right',buttons.right.reverseIndent,global.countaddition,iTable[i][3],additionalSpacing,iTable[i]) -- Moved to GUI types so that we can use it on left / right plus we will be drawing children, meaning it'd make no sense to repeat the function a million times.
				end
			end
		end
	end

	--//local start = (additionalSpacing+(24.5*math.min(count+1,15)+5))

	if isFreecamEnabled() then

		if isThereSelected() and freeMove then
			local xA,yA,zA,xAb,yAb,zAb = getCameraMatrix()
			local xB,yB,zB = getSelectedElementsCenter()
			local hit, xC,yC,zC,element = processLineOfSight ( xA,yA,zA,xAb,yAb,zAb )

			if selectedElements[element] then
				xB,yB,zB = (xC or xB),(yC or yB),(zC or zB)
			else
				xB,yB,zB = xB,yB,zB
			end


			distanceP = distanceP or getDistanceBetweenPoints3D(xA,yA,zA,xB,yB,zB)

			local xA,yA,zA = getWorldFromScreenPosition ( xSize/2, ySize/2,distanceP )


			if not ((xA == oldMx) and (yA == oldMy) and (yA == oldMy)) then
				if isFreecamEnabled() then
					if oldMx then
						setElementPositions(xA-oldMx,yA-oldMy,zA-oldMz,true,true)
					else
						distanceP = nil
					end
				end
			end

			oldMx,oldMy,oldMz = xA,yA,zA
		else
			oldMx,oldMy,oldMz = nil,nil,nil
			distanceP = nil
		end



		local size = 50*s

		local sizea = (((getKeyState('mouse1') and 40 or 50) - getFreecamSpeed()/80) - (hElement and 5 or 0))*s
		local x = (xSize-size)/2
		local y = (ySize-size)/2

		local xa = (xSize-sizea)/2
		local ya = (ySize-sizea)/2

		local image = functions.prepImage('crosshair')
		local center = functions.prepImage('crosshair_c')

		if not isCursorShowing() then
			local bColor = freeMove and 0 or 255
			dxDrawImage(xa,ya,sizea,sizea,image, 0, 0, 0, tocolor(255,bColor,bColor,150),true)
			dxDrawImage(x,y,size,size,center, 0, 0, 0, tocolor(0, 0, 0, 150), true)
		end


		if isFreecamEnabled() and (not isCursorShowing()) then
			hElement = getHighLightedElement()
		else
			hElement = nil
		end

		if (not (global['Boundries'] == 'On Screen')) and (not (global['Boundries'] == 'None')) then
			if not isCursorShowing() then

				if hElement then
					functions.boundingBox(hElement,true)
				end
			end
		elseif (global['Boundries'] == 'On Screen') then
			for i,v in pairs(getAllElements(true,true)) do
				functions.boundingBox(v,(hElement == v),true)
			end
		end

	end

	if isFreecamEnabled() then
		if getKeyState('mouse1') then
			if not toggleb then
				functions.selectElement()
			end
		end
	end
	toggleb = getKeyState('mouse1')


	if cursor then
		mouseA = functions.prepImage('mouse')
		local xM,yM = getCursorPosition ( )
		dxDrawImage(xM*xSize,yM*ySize,25*s,(25*1.5)*s,mouseA, 0, 0, 0, tocolor(255, 255, 255, 255), true)
	end

	if (not (global['Boundries'] == 'On Screen')) and (not (global['Boundries'] == 'None')) then
		for i,v in pairs(selectedElements) do
			if not (hElement == i) then
				if isElementOnScreen(i) then
					functions.boundingBox(i)
				end
			end
		end
	end

	functions.DrawGimbal()

		for i,v in pairs(selectedElements) do
			setElementFrozen(i,true)
			callS('freezeElement',i,true)
		end

		for i,v in pairs(binds.dynamic) do
			for ia,va in pairs(v[2]) do
				if getKeyState(va) or (rebind[va] and getKeyState(rebind[va])) then
					if functions[v[1]] then
						functions[v[1]](va,ia,v[2]) --// Bind Name, Bind ID and Bind Table. Table is for funcitons that require multiple binds to be held.
					end
				end
			end
		end
	functions.drawMagnets()
end

addEventHandler("onClientRender", root,functions.drawM)

-- // Please excuse the 300 line function // --