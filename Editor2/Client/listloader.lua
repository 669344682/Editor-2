objectLists = {'Alpha and Non Collidable',
'Nighttime Objects',
'Beach and Sea',
'buildings',
'Car parts',
'Weapon Models',
'industrial',
'interior objects',
'land masses',
'miscellaneous',
'nature',
'structures',
'transportation',
'Wires and Cables'
}

vehicleLists = {'Motorbikes',
'Helicopters',
'4-Door',
'Emergency',
'Planes, Jets and Airlines',
'Trains',
'Boats',
'Lowriders',
'Trailers',
'SUVs and Wagons',
'Industrial',
'Other',
'Trucks',
'2-Door',
'Bicycles',
'Vans',
'RC Vehicles',
'Sports Cars'
}


for i,v in pairs(objectLists) do
	local File =  fileOpen('lists/'..v..'.list')   
	local Data =  fileRead(File, fileGetSize(File))
	local Proccessed = split(Data,10)
	fileClose (File)
	table.insert(buttons.right.menu['New Element'].lists['San Andreas Objects'],{v,'List'})
	buttons.right.menu['New Element'].lists[v] = {}
	Parent = nil
	for iA,vA in pairs(Proccessed) do
		if vA:sub( 1, 1 ) == '#' then
				Parent = string.gsub(vA,'#','')
				table.insert(buttons.right.menu['New Element'].lists[v],{Parent,'List'})
				buttons.right.menu['New Element'].lists[Parent] = {}
			else
				local Ssplit = split(vA,',')
			if Parent then
				table.insert(buttons.right.menu['New Element'].lists[Parent],{Ssplit[1],'Object',split(Ssplit[3] or '','#'),nil,Ssplit[2]})
			else

				table.insert(buttons.right.menu['New Element'].lists[v],{Ssplit[1],'Object',split(Ssplit[3] or '','#'),nil,Ssplit[2]})
			end
		end
	end
end

for i,v in pairs(vehicleLists) do
	local File =  fileOpen('lists/vehicleLists/'..v..'.list')   
	local Data =  fileRead(File, fileGetSize(File))
	local Proccessed = split(Data,10)
	fileClose (File)
	table.insert(buttons.right.menu['New Element'].lists['Vehicles'],{v,'List'})
	buttons.right.menu['New Element'].lists[v] = {}
	for iA,vA in pairs(Proccessed) do
		local Ssplit = split(vA,',')
		table.insert(buttons.right.menu['New Element'].lists[v],{Ssplit[2],'Vehicle',nil,Ssplit[1]})
	end
end


