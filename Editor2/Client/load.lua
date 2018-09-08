
--{'Move Type','Option',{'World','Local','Screen'}})

table.insert(buttons.right.menu['Load'],{'Commonly Used','List'})
buttons.right.menu['Load'].lists['Commonly Used'] = {}

table.insert(buttons.right.menu['Load'],{'Recently Used','List'})
buttons.right.menu['Load'].lists['Recently Used'] = {}

table.insert(buttons.right.menu['Load'],{'Favorites','List'})
buttons.right.menu['Load'].lists['Favorites'] = {}



function functions.listMaps()
	callS('mapList')
end
functions.listMaps()

listed = {}
function functions.mapList(list)
	for i,v in pairs(list) do
		if not listed[v] then
			listed[v]  = true
			if tonumber(i) then
				table.insert(buttons.right.menu['Load'],{v[1],'Map',nil})
				buttons.right.menu['Load'].lists[v[1]] = {}
				for ib,vb in pairs(v[2]) do
					table.insert(buttons.right.menu['Load'].lists[v[1]],{vb,'File',v[1]})
				end
			else
				if not buttons.right.menu['Load'].lists[i] then
					table.insert(buttons.right.menu['Load'],{i,'List'})
					buttons.right.menu['Load'].lists[i] = {}
				end
				if not listed[i] then
					listed[i] = true
					for ia,va in pairs(v) do
						if not listed[va] then
							listed[va] = true
							table.insert(buttons.right.menu['Load'].lists[i],{va[1],'Map',i})
							buttons.right.menu['Load'].lists[va[1]] = {}
							for ib,vb in pairs(va[2]) do
								table.insert(buttons.right.menu['Load'].lists[va[1]],{vb,'File',va[1]})
							end
						end
					end
				end
			end
		end
	end
end