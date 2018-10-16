
--[[
table.insert(buttons.right.menu['Customize'].lists['Commonly Used'],{'Edit Box','Text','Heres some text'})
table.insert(buttons.right.menu['Customize'].lists['Commonly Used'],{'Color Edit','Color',{255,0,0}})
table.insert(buttons.right.menu['Customize'].lists['Commonly Used'],{'Settings','Option',{'A','B','C'}})
table.insert(buttons.right.menu['Customize'].lists['Commonly Used'],{'Test','List',true})
]]--
--table.insert(buttons.right.menu['Customize'].lists['Test'],{'Check box','Check box',true})

edfStockPile = {}
functions.prepEDFSettingStockPile = function (EDFSettings)
	edfStockPile = EDFSettings 
end



functions.prepCustomizationMenu = function()
	cuElement = ((not isCursorShowing()) and getHighLightedElement()) or cuElement -- cuElement is globally defined and will be used for applying the 'Edits'
	
	buttons.right.menu['Customize'] = {}
	buttons.right.menu['Customize'].lists = {}
	if isElement(cuElement) then
		local uSlots = {}
		table.insert(buttons.right.menu['Customize'],{'Generic','List'})
		buttons.right.menu['Customize'].lists['Generic'] = {}
			
			
		local cuElementType = getElementData(cuElement,'Edf') or getElementType(cuElement)
		table.insert(buttons.right.menu['Customize'].lists['Generic'],{'Interior','Number',getElementInterior(cuElement)})--
		table.insert(buttons.right.menu['Customize'].lists['Generic'],{'Dimension','Number',getElementDimension(cuElement)})--
		table.insert(buttons.right.menu['Customize'].lists['Generic'],{'Frozen','Check box',isElementFrozen(cuElement)})--
		table.insert(buttons.right.menu['Customize'].lists['Generic'],{'Collidable','Check box',getElementCollisionsEnabled(cuElement)})--
		table.insert(buttons.right.menu['Customize'].lists['Generic'],{'Transparency','Number',getElementAlpha(cuElement)})--
		
		refreshString(getElementInterior(cuElement),'Interior',true)
		refreshString(getElementDimension(cuElement),'Dimension',true)
		refreshString(getElementAlpha(cuElement),'Transparency',true)

		global.Checked['Frozen'] = ((isElementFrozen(cuElement)) and 1 or 2)
		mapSetting.menuSettings['Frozen'] = tostring((isElementFrozen(cuElement)))
			
		global.Checked['Collidable'] = ((getElementCollisionsEnabled(cuElement)) and 1 or 2)
		mapSetting.menuSettings['Collidable'] = tostring((getElementCollisionsEnabled(cuElement)))
		
		if cuElementType == 'object' then
			table.insert(buttons.right.menu['Customize'],{'Object','List'})
			buttons.right.menu['Customize'].lists['Object'] = {}
			table.insert(buttons.right.menu['Customize'].lists['Object'],{'Breakable','Check box',isObjectBreakable(cuElement)})--
			
			global.Checked['Breakable'] = ((isObjectBreakable(cuElement)) and 1 or 2)
			mapSetting.menuSettings['Breakable'] = tostring((isObjectBreakable(cuElement)))
		elseif cuElementType == 'vehicle' then
			table.insert(buttons.right.menu['Customize'],{'Vehicle','List'})
			buttons.right.menu['Customize'].lists['Vehicle'] = {}
			
			
			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Locked','Check box',isVehicleLocked(cuElement)})--
			global.Checked['Locked'] = ((isVehicleLocked(cuElement)) and 1 or 2)
			mapSetting.menuSettings['Locked'] = tostring((isVehicleLocked(cuElement)))
			
			
			local r,g,b,r1,g1,b1,r2,g2,b2,r3,g3,b3 = getVehicleColor ( cuElement,true )   
			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Color 1','Color',{r,g,b}})--
			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Color 2','Color',{r1,g1,b1}})--
			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Color 3','Color',{r2,g2,b2}})--
			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Color 4','Color',{r3,g3,b3}})--
			
			
			if not (oldEntity == cuElement) then
				-- Ensures that colors update, long ugly proccess.
				local _,_,_,wB,hB = unpack(((colorpicker['Color 1'] or {}).colorbar or {}))
				colorpicker['Color 1'] = colorpicker['Color 1'] or {Arrow = true}
				colorpicker['Color 1'].colorbar = {r,g,b,wB,hB,rgb2hex(r,g,b)}
				colorpicker['Color 1'].color = {r,g,b}
				
				local _,_,_,wB,hB = unpack(((colorpicker['Color 2'] or {}).colorbar or {}))
				colorpicker['Color 2'] = colorpicker['Color 2'] or {Arrow = true}
				colorpicker['Color 2'].colorbar = {r1,g1,b1,wB,hB,rgb2hex(r1,g1,b1)}
				colorpicker['Color 2'].color = {r1,g1,b1}
				
				local _,_,_,wB,hB = unpack(((colorpicker['Color 3'] or {}).colorbar or {}))
				colorpicker['Color 3'] = colorpicker['Color 3'] or {Arrow = true}
				colorpicker['Color 3'].colorbar = {r2,g2,b2,wB,hB,rgb2hex(r2,g2,b2)}
				colorpicker['Color 3'].color = {r2,g2,b2}
				
				local _,_,_,wB,hB = unpack(((colorpicker['Color 4'] or {}).colorbar or {}))
				colorpicker['Color 4'] = colorpicker['Color 4'] or {Arrow = true}
				colorpicker['Color 4'].colorbar = {r,g,b,wB,hB,rgb2hex(r3,g3,b3)}
				colorpicker['Color 4'].color = {r3,g3,b3}
			end
			
			oldEntity = cuElement
	
	
			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Damage Proof','Check box',isVehicleDamageProof(cuElement)})--
			global.Checked['Damage Proof'] = ((isVehicleDamageProof(cuElement)) and 1 or 2)
			mapSetting.menuSettings['Damage Proof'] = tostring((isVehicleDamageProof(cuElement)))

			table.insert(buttons.right.menu['Customize'].lists['Vehicle'],{'Upgrades','List'})
			buttons.right.menu['Customize'].lists['Upgrades'] = {}

			for i,v in pairs(getVehicleCompatibleUpgrades (	cuElement )) do -- cuElement
				if not uSlots[getVehicleUpgradeSlotName (v)] then
					uSlots[getVehicleUpgradeSlotName (v)] = true
					table.insert(buttons.right.menu['Customize'].lists['Upgrades'],{getVehicleUpgradeSlotName (v),'List'})
					buttons.right.menu['Customize'].lists[getVehicleUpgradeSlotName (v)] = {}
				end
				
				local slotID = upgradeSlots[getVehicleUpgradeSlotName (v)]
				local slot = getVehicleUpgradeOnSlot ( cuElement,slotID )
				table.insert(buttons.right.menu['Customize'].lists[getVehicleUpgradeSlotName (v)],{v,'Check box',(v == slot)})
			end
			refreshUpgrades()
		elseif cuElementType == 'ped' then
		
		elseif getElementData(cuElement,'Edf') then
			local settings = edfStockPile[cuElementType]
		end
	end
end



upgradeSlots = {}
upgradeSlots['Hood'] = 0
upgradeSlots['Vent'] = 1
upgradeSlots['Spoiler'] = 2
upgradeSlots['Sideskirt'] = 3
upgradeSlots['Front Bullbars'] = 4
upgradeSlots['Rear Bullbars'] = 5
upgradeSlots['Headlights'] = 6
upgradeSlots['Roof'] = 7
upgradeSlots['Nitro'] = 8
upgradeSlots['Hydraulics'] = 9
upgradeSlots['Stereo'] = 10
upgradeSlots['Unknown'] = 11
upgradeSlots['Wheels'] = 12
upgradeSlots['Exhaust'] = 13
upgradeSlots['Front Bumper'] = 14
upgradeSlots['Rear Bumper'] = 15
upgradeSlots['Misc'] = 16




function refreshUpgrades()
	for ia=0,16 do
		local namea = getVehicleUpgradeSlotName (ia)
		for i,v in pairs(buttons.right.menu['Customize'].lists[namea] or {}) do
			local name = v[1]
			local slot = getVehicleUpgradeOnSlot ( cuElement,ia )
			global.Checked[name] = ((name == slot) and 1 or 2)
			
			mapSetting.menuSettings[name] = tostring((name == slot))
		end
	end
end

setTimer(functions.prepCustomizationMenu,1000,0)

function cVColor ( name,color )
	local r,g,b,r1,g1,b1,r2,g2,b2,r3,g3,b3 = getVehicleColor ( cuElement,true )
	local ra,ga,ba = unpack(color)
	if name == 'Color 1' then
		setVehicleColor ( cuElement, ra,ga,ba,r1,g1,b1,r2,g2,b2,r3,g3,b3 )   
	elseif name == 'Color 2' then
		setVehicleColor ( cuElement, r,g,b,ra,ga,ba,r2,g2,b2,r3,g3,b3 )   
	elseif name == 'Color 3' then
		setVehicleColor ( cuElement, r,g,b,r1,g1,b1,ra,ga,ba,r3,g3,b3 )   
	elseif name == 'Color 4' then
		setVehicleColor ( cuElement, r,g,b,r1,g1,b1,r2,g2,b2,ra,ga,ba )   
	end
end

addEventHandler ( "Color", resourceRoot, cVColor )

		
function cCheckBox ( name,checked )
	local checked = (checked == 1)
	if name == 'Frozen' then
		setElementFrozen(cuElement,checked)
	elseif name == 'Collidable' then
		setElementCollisionsEnabled(cuElement,checked)
	elseif name == 'Damage Proof' then
		setVehicleDamageProof(cuElement,checked)
	elseif name == 'Locked' then
		setVehicleLocked(cuElement,checked)
	elseif name == 'Breakable' then
		setObjectBreakable(name,checked)
	elseif tonumber(name) then	
		if checked then
			addVehicleUpgrade( cuElement, tonumber(name) )
		else
			removeVehicleUpgrade( cuElement, tonumber(name) )
		end
		refreshUpgrades()
	end
end

addEventHandler ( "Check box", resourceRoot, cCheckBox )

function cText ( name,text )
	if name == 'Interior' then
		setElementInterior(cuElement,tonumber(text))
	elseif name == 'Dimension' then
		setElementDimension(cuElement,tonumber(text))
	elseif name == 'Transparency' then
		setElementAlpha(cuElement,tonumber(text))
	end
end

addEventHandler ( "onDxEdit", resourceRoot, cText )

-- Restrucutre / optmize a bit it's a mess at the moment.
-- Make 'Customizations' sync server side.
-- Add EDFSettings












