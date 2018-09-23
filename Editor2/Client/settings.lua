
--{'Move Type','Option',{'World','Local','Screen'}})



functions.resetMetaList = function ()
	buttons.right.menu['Settings'] = {menu = {},lists = {}}
	
	table.insert(buttons.right.menu['Settings'],{'Meta','List'})
	buttons.right.menu['Settings'].lists['Meta'] = {}

	table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Map Name','Text',''})
	table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Map Name','',''})
	table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Author','Text',''})
	table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Version','Number',''})
	table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Description','Text',''})

	table.insert(buttons.right.menu['Settings'],{'Gamemodes','List'})
	buttons.right.menu['Settings'].lists['Gamemodes'] = {}
end
callS('getGamemodes')
setTimer ( callS, 2500, 0, "getGamemodes" )



functions.refreshGamemods = function(list,edf)
	local checky = {}
	functions.resetMetaList()
	for i,v in pairs(list) do
		global.Checked[v] = global.Checked[v] or nil
		table.insert(buttons.right.menu['Settings'].lists['Gamemodes'],{v,'Check box'})
	end
	
	for i,v in pairs(edf) do
		if (global.Checked[v[1]] == 1) then
			if not checky[v[1]] then
				checky[v[1]] = true
				table.insert(buttons.right.menu['Settings'],{v[1],'List'})
				buttons.right.menu['Settings'].lists[v[1]] = {}
			end
			if v[2] == 'setting' then
				local setting = split ( v[3].type, ':' )
				if setting[1] == 'boolean' then
					local value = (v[3].default == 'true')
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Check box',value})
				elseif setting[1] == 'natural' then
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Whole Positive Number',v[3].default})
				elseif setting[1] == 'integer' then
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'integer',v[3].default})
				elseif setting[1] == 'number' then
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Number',v[3].default})
				elseif setting[1] == 'string' then
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Text',v[3].default})
				elseif setting[1] == 'color' then
					local r,g,b = hex2rgb(v[3].default)
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Color',{r,g,b}})
				elseif setting[1] == 'selection' then
					local selections = split(setting[2],',')
					table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].name,'Option',selections})
				end
			end
		end
	end
end