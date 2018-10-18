functions.applyCustomization = function (selected,customization,...) -- KEEP THE SERVER SIDE EXACTLY LIKE THIS.
	for i,v in pairs(selected) do
		if customization == 'Color 1' then
			if getElementType(i) == 'vehicle' then
				local ra,ga,ba = unpack{...}
				local r,g,b,r1,g1,b1,r2,g2,b2,r3,g3,b3 = getVehicleColor ( i,true )
				setVehicleColor(i, ra,ga,ba,r1,g1,b1,r2,g2,b2,r3,g3,b3)
			end
		elseif customization == 'Color 2' then
			if getElementType(i) == 'vehicle' then
				local ra,ga,ba = unpack{...}
				local r,g,b,r1,g1,b1,r2,g2,b2,r3,g3,b3 = getVehicleColor ( i,true )
				setVehicleColor(i, r,g,b,ra,ga,ba,r2,g2,b2,r3,g3,b3 )  
			end
		elseif customization == 'Color 3' then
			if getElementType(i) == 'vehicle' then
				local ra,ga,ba = unpack{...}
				local r,g,b,r1,g1,b1,r2,g2,b2,r3,g3,b3 = getVehicleColor ( i,true )
				setVehicleColor(i, r,g,b,r1,g1,b1,ra,ga,ba,r3,g3,b3 ) 
			end
		elseif customization == 'Color 4' then
			if getElementType(i) == 'vehicle' then
				local ra,ga,ba = unpack{...}
				local r,g,b,r1,g1,b1,r2,g2,b2,r3,g3,b3 = getVehicleColor ( i,true )
				setVehicleColor(i, r,g,b,r1,g1,b1,r2,g2,b2,ra,ga,ba )   
			end
		elseif customization == 'Frozen' then
			setElementFrozen(i,...)
		elseif customization == 'Collidable' then
			setElementCollisionsEnabled(i,...)
		elseif customization == 'Damage Proof' then
			if getElementType(i) == 'vehicle' then
				setVehicleDamageProof(i,...)
			end
		elseif customization == 'Locked' then
			if getElementType(i) == 'vehicle' then
				setVehicleLocked(i,...)
			end
		elseif customization == 'Breakable' then
			if getElementType(i) == 'element' then
				setObjectBreakable(i,...)
			end
		elseif customization == 'VehicleUpgrade' then
			if getElementType(i) == 'vehicle' then
				local ta = {...}
				if ta[2] then
					addVehicleUpgrade(i,...)
				else
					removeVehicleUpgrade(i,...)
				end
			end
		elseif customization == 'Interior' then
			setElementInterior(i,...)
		elseif customization == 'Dimension' then
			setElementDimension(i,...)
		elseif customization == 'Transparency' then
			setElementAlpha(i,...)
		end
	end
end