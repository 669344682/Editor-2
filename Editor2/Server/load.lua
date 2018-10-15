

ObjectList = {}



functions.proccessMetac = function (resource) --- Need to send settings over from client side, aswell as regenerate the files.
	local xml = fileExists(':'..resource..'/meta.xml')
	if xml then
		local meta = xmlLoadFile (':'..resource..'/meta.xml')
		local metachildren = {}
		if meta then
			local settings = xmlFindChild ( meta, "settings",0 )
			local children = xmlNodeGetChildren(settings)
				
			for ia,va in pairs(children) do
				local information = xmlNodeGetAttributes(va)
				local name = information.name
				local name = string.gsub (name, '#', '')
				local setting = information.value
				table.insert(metachildren,{name,setting})
			end	
			
			
			xmlUnloadFile(meta)
			return metachildren
		end
	end
end




function functions.loadMapFile(file,extension,resource)
	local settings = functions.proccessMetac(resource) or {}
	print('Loading',file)
	print('Type','.'..extension)
	if extension == 'lua' then
		local loaded = fileOpen(file)
		local content = fileRead ( loaded,fileGetSize(loaded) )
		fileClose(loaded)
		pcall(content)
	elseif extension == 'map' then
		local loaded = xmlLoadFile (file)
		loadMapData (loaded,resourceRoot)  
		xmlUnloadFile (loaded)  
	elseif extension == 'jsp' then
		local resourceC = getResourceFromName(resource)
		if not (getResourceState (resourceC) == 'running') then
			print('Launching',resource)
			startResource(resourceC)
		end
		
		local tabl = {}
		local objects = exports.Objs:getResourceElements(resourceC)
		for i,v in pairs(objects) do
			if not isElementLowLOD ( i ) then
				setElementData(i,'MapEditor',true)
			end
		end
		print('Hooked',resource)
	end
	for i,v in pairs(getMapElements(resourceRoot)) do
		if not isElementLowLOD ( v ) then
			setElementData(v,'MapEditor',true)
		end
	end
	print('Loaded',file)
	
	local fileName = resource
	local author = getResourceInfo ( getResourceFromName(resource),'author')
	local name = getResourceInfo ( getResourceFromName(resource),'name')
	local description = getResourceInfo ( getResourceFromName(resource),'description')
	local version =  getResourceInfo ( getResourceFromName(resource),'version')
	local gamemodes = split(getResourceInfo ( getResourceFromName(resource),'gamemodes'),',')
	callC(root,'fetchMediaInformation',author,name,description,version,gamemodes,settings)
end



addEventHandler ( "onResourceStop", resourceRoot,
function (	)
	for iA,vA in pairs(ObjectList) do
		if isElement(vA) then
			destroyElement(vA)
		end
	end
end
)

function functions.mapList()
	local list = {}
	for i,v in pairs(getResources ()) do
		local name = getResourceName(v)
		local type = getResourceInfo (v,'type') 
		local gamemode = getResourceInfo (v,'gamemodes') 
		if type == 'map' then
			if gamemode then
				if not list[gamemode] then
					list[gamemode] = {}
				end
				local files = getFiles(name)
				table.insert(list[gamemode],{name,files})
			else
				local files = getFiles(name)
				table.insert(list,{name,files})
			end
		end
	end
	callC(client,'mapList',list)
end


function string.count (text, search)
	if ( not text or not search ) then return false end
	
	return select ( 2, text:gsub ( search, "" ) );
end


function getFiles(name)
	local meta = xmlLoadFile (':'..name..'/meta.xml')
	local children = xmlNodeGetChildren ( meta )  
	local fileList = {}
	for i,v in pairs(children) do
		local file = xmlNodeGetAttribute (v,'src')
		if file then
			local type = string.lower(split(file,'.')[2])
			if (type == 'map') or (type == 'lua') then
				if type == 'lua' then
					if (string.count(file,'Loader') == 0) and (string.count(file,'Extension') == 0) then
						local loaded = fileOpen(':'..name..'/'..file)
						local content = fileRead ( loaded,fileGetSize(loaded) )
						fileClose(loaded)
						if string.count(content,'create') > 0 then
							table.insert(fileList,file)
						end
					end
				else
					table.insert(fileList,file)
				end
			end
		end
	end
	if fileExists(':'..name..'/gta3.JSP') then
		table.insert(fileList,'gta3.JSP')
	end
	xmlUnloadFile (meta)
	return fileList
end



functions.mapList()



















