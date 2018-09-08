
--{'Move Type','Option',{'World','Local','Screen'}})

table.insert(buttons.right.menu['Settings'],{'Meta','List'})
buttons.right.menu['Settings'].lists['Meta'] = {}

table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Map Name','Text',''})
table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Map Name','',''})
table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Author','Text',''})
table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Version','Number',''})
table.insert(buttons.right.menu['Settings'].lists['Meta'],{'Description','Text',''})

table.insert(buttons.right.menu['Settings'],{'Gamemodes','List'})
buttons.right.menu['Settings'].lists['Gamemodes'] = {}

callS('getGamemodes')
setTimer ( callS, 2000, 0, "getGamemodes" )

functions.refreshGamemods = function(list)
	buttons.right.menu['Settings'].lists['Gamemodes'] = {}
	for i,v in pairs(list) do
		global.Checked[v] = nil
		table.insert(buttons.right.menu['Settings'].lists['Gamemodes'],{v,'Check box'})
	end
end