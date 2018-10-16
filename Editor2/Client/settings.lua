
--{'Move Type','Option',{'World','Local','Screen'}})

-- mapSetting is the per map setting list.
functions.fetchMetaInformation = function (author,name,description,version,gamemodes,settings)

	mapSetting.menuSettings['Author'] = author or ''
	mapSetting.menuSettings['Map Name'] = name or ''
	mapSetting.menuSettings['Version'] = tonumber(version) or 0
	mapSetting.menuSettings['Description'] = description or ''
	
	
	for i,v in pairs(gamemodeList) do
		global.Checked[v] = nil
	end
	
	for i,v in pairs(gamemodes) do
		global.Checked[v] = 1
	end
	
	for i,v in pairs(settings) do
		if v[1] and v[2] then
			mapSetting[v[1]] = v[2]
			mapSetting.menuSettings[v[1]] = v[2]
			mapSetting.AlreadyDefault[v[1]] = nil
		end
	end
end

gamemodeList = gamemodeList or {}

functions.fetchEDFElements = function (edfResources)
	buttons.right.menu['New Element'].lists['EDF'] = {}
	gamemodeList = gamemodeList or {}
	for i,v in pairs(edfResources) do
		table.insert(buttons.right.menu['New Element'].lists['EDF'],{i,'List'})
		buttons.right.menu['New Element'].lists[i] = {}
		for iA,vA in pairs(v) do
			table.insert(buttons.right.menu['New Element'].lists[i],{vA[1],'EDF',nil,vA[2],vA[3]})
		end
	end
	setTimer ( callS, 2500, 1, 'proccessEDF',mapSetting.gameModes or {})
end

callS('proccessEDF',{})



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
	
	mapSetting.settings = {}
	mapSetting.gameModes = {}
	local checky = {}
	functions.resetMetaList()
	gamemodeList = list

	for i,v in pairs(list) do
		global.Checked[v] = global.Checked[v] or nil
		table.insert(buttons.right.menu['Settings'].lists['Gamemodes'],{v,'Check box'})
		if global.Checked[v] == 1 then
		table.insert(mapSetting.gameModes,v)
		end
	end
	
	for i,v in pairs(edf) do
		if (global.Checked[v[1]] == 1) then
			if not checky[v[1]] then
				checky[v[1]] = true
				table.insert(buttons.right.menu['Settings'],{v[1],'List'})
				buttons.right.menu['Settings'].lists[v[1]] = {}
			end
			if v then
				if v[2] == 'setting' then
					local default = (mapSetting[v[3].name]) or v[3].default
					local setting = split ( v[3].type, ':' )
					mapSetting.settings[v[3].name] = {v[3].friendlyname,v[3].default}
					if setting[1] == 'boolean' then
						local value = (default == 'true') and 1 or 2
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Check box',value})
					elseif setting[1] == 'natural' then
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Whole Positive Number',default})
					elseif setting[1] == 'integer' then
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'integer',default})
					elseif setting[1] == 'number' then
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Number',default})
					elseif setting[1] == 'string' then
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Text',default})
					elseif setting[1] == 'color' then
						local r,g,b = hex2rgb(default)
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].friendlyname,'Color',{r,g,b}})
					elseif setting[1] == 'selection' then
						local selections = split(setting[2],',')
						table.insert(buttons.right.menu['Settings'].lists[v[1]],{v[3].name,'Option',selections})
						mapSetting.settings[v[3].name] = {v[3].name,default}
						if not mapSetting.AlreadyDefault[v[3].name] then
							functions.OptionS(v[3].name,selections,default)
						end
						mapSetting.AlreadyDefault[v[3].name] = true
					end
				end
			end
		end
	end
end