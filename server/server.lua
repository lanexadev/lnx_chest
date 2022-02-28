--▌-------------------------------------------------------------------------------------▌--
--▌--                      Script Created by LANEXA Industries                        --▌--
--▌--                This Script is submitted at no copyright and you                 --▌--
--▌--                            Can pick this script                                 --▌--
--▌-------------------------------------------------------------------------------------▌--


local credit =
[[ 
  ^2//   
  ^2||^5      _
  ^2||^5     | |        _     ___   _   ___  __  __    _
  ^2||^5     | |       /_\   |   \ | | | __| \ \/ /   /_\
  ^2||^5     | |___   / _ \  | |\ \| | | __|  >  <   / _ \
  ^2||^5     |_____| /_/ \_\ |_| \___| |___| /_/\_\ /_/ \_\
  ^2||^5     
  ^2||^5     
  ^2||^1               Created by LNX_lucas
  ^2\\^7]]

print( credit )
	
ESX = nil

local AddChest = false
local AddWeapon = false

local AddInv = false
local AddWeap = false

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function( obj ) ESX = obj end)

ESX.RegisterUsableItem('chest', function(source)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('::{korioz#0110}::lnx_chest:SpawnChest', _source)
    xPlayer.removeInventoryItem('chest', 1)
end)

RegisterServerEvent('::{korioz#0110}::lnx_chest:AddCode')
AddEventHandler('::{korioz#0110}::lnx_chest:AddCode', function(x,y,z, h, result)
	local x_source = source

	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

    table.insert(ChestData, {
   	   ['Coords'] = {x = x, y = y, z = z, h = h},
   	   code = result,
   	   inventaire = {},
   	   weapon = {}
    })

    SaveResourceFile(GetCurrentResourceName(), "./data/ChestData.json", json.encode(ChestData, {indent=true}), -1) 

    for i,v in ipairs(ChestData) do
    	if (v.Coords.x ~= nil and v.Coords.y ~= nil and v.Coords.z ~= nil and v.Coords.h ~= nil) then
	    	   x = v.Coords.x
	    	   y = v.Coords.y
	    	   z = v.Coords.z
	    	   h = v.Coords.h

	    	TriggerClientEvent('::{korioz#0110}::lnx_chest:AddChestTable', x_source, x,y,z,h)
	    	TriggerClientEvent('::{korioz#0110}::esx:showNotification', x_source, 'Merci de ~r~deco/reco~w~ pour acceder au coffre !.')
	    end	
    end
end)

RegisterServerEvent('::{korioz#0110}::lnx_chest:CheckCode')
AddEventHandler('::{korioz#0110}::lnx_chest:CheckCode', function(x,y,z, result)
	local x_source = source

    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

    inv = {}
     weap = {}

	for i,v in ipairs(ChestData) do
		if (x == v.Coords.x and y == v.Coords.y and z == v.Coords.z) then
			if result == v.code then 
				if #v.inventaire ~= 0 then 
					for x,k in ipairs(v.inventaire) do
						table.insert(inv, {
							items = k.items,
							label = k.label,
							count = k.count
						})
					end
					invEmpty = false		
				else 
					inventaire = v.inventaire
					invEmpty = true  	
				end	

				if #v.weapon ~= 0 then
				 
				  for i2,v2 in ipairs(v.weapon) do
				   	table.insert(weap, {
				   		weapons = v2.weapon,
				   		count = v2.count,
				   		munition = v2.munition
					   })
				  end 
				  weapEmpty = false 
				else 
				  weaponT = v.weapon	
				  weapEmpty = true  
				end

				if not invEmpty then 
					inv = inv
				else 
				    inv = inventaire 	
				end
				
				if not weapEmpty then 
					weap = weap 
				else 
				    weap = weaponT 	
				end	

				TriggerClientEvent('::{korioz#0110}::lnx_chest:NotifCode', x_source, true, inv, weap, x,y,z)
			else 
				TriggerClientEvent('::{korioz#0110}::lnx_chest:NotifCode', x_source, false, nil, nil, nil)
			end
		end	
	end


end)


RegisterServerEvent('::{korioz#0110}::lnx_chest:LoadChest')
AddEventHandler('::{korioz#0110}::lnx_chest:LoadChest', function()
	local x_source = source

    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

	for i,v in ipairs(ChestData) do
		if (v.Coords.x ~= nil and v.Coords.y ~= nil and v.Coords.z ~= nil and v.Coords.h ~= nil) then		    
    	    x = v.Coords.x
    	    y = v.Coords.y
    	    z = v.Coords.z
    	    h = v.Coords.h
	    	TriggerClientEvent('::{korioz#0110}::lnx_chest:SpawnOwnerChest', x_source, x,y,z,h)
		end 
	end
end)

RegisterServerEvent('::{korioz#0110}::lnx_chest:StockItems')
AddEventHandler('::{korioz#0110}::lnx_chest:StockItems', function(label, items, result, x,y,z)

	local x_source = source
	local xPlayer = ESX.GetPlayerFromId(x_source)

	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

	local found = false 

	if items == 'dirtycash' then 
		if xPlayer.getAccount('dirtycash').money < result then 
            xPlayer.showNotification("Montant invalide")
            return
		end
	elseif item == 'money' then 
	    if xPlayer.getMoney() < result then
	        xPlayer.showNotification("Montant invalide")
            return 
	    end	
	end

    for i,v in ipairs(ChestData) do 
		if (x == v.Coords.x and y == v.Coords.y and z == v.Coords.z) then
			if #v.inventaire == 0 then
				if result >= 1 then 				
					table.insert(v.inventaire, {
						items = items,
						label = label,
						count = result  
					})
					AddChest = true
					found = true
				end	
			else 
				inventaire = v.inventaire
			    insert = true 	
			end
		end	
	end	

	if insert then 
		for x,k in ipairs(inventaire) do
			if result >= 1 then 
				if k.items == items then
					print('found')
			      	local TotalCount = result + k.count 
					k.items  = items
					k.label = label
					k.count  = TotalCount
				    AddChest = true	
				    found = true  				  
				end							  	
			else
			   print('[lnx_chest] Le joueur :'..xPlayer.identifier..' tente d\' ajouter une valeur négative')
			end	
		end
	end

	if not found and #inventaire ~= 0 then
		print('not found')
		table.insert(inventaire, {
			items = items,
			label = label,
			count = result  
		})
		AddChest = true 
	end	



    if AddChest then 
    	if items == 'dirtycash' then 
    		print('remove', items)
    		xPlayer.removeAccountMoney('dirtycash', result)
    	elseif items == 'money' then 
    		print('remove', items)
    	    xPlayer.removeMoney(result)
    	else     	
    	    xPlayer.removeInventoryItem(items, result)
    	end    
    end	

	SaveResourceFile(GetCurrentResourceName(), "./data/ChestData.json", json.encode(ChestData, {indent=true}), -1) 
end)

RegisterServerEvent('::{korioz#0110}::lnx_chest:PickItems')
AddEventHandler('::{korioz#0110}::lnx_chest:PickItems', function(items, result, x,y,z)

	local x_source = source
	local xPlayer = ESX.GetPlayerFromId(x_source)

	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

	if items ~= 'dirtycash' and items ~= 'money' then
		if result > 50 then 
	     	xPlayer.showNotification('Vous portez trop sur vous !')
	     	return
	    end
	end

	for i,v in pairs(ChestData) do
		if (x == v.Coords.x and y == v.Coords.y and z == v.Coords.z) then 
			for m,n in pairs(v.inventaire) do
				if items == n.items then 
				    local TotalCount = n.count - result
					if result <= n.count then
						if n.count <= 1 or TotalCount <= 0 then 
							print('remove total')
							table.remove(v.inventaire, m)
							AddInv = true 
						else 
							n.items = items 
							n.count = TotalCount
							AddInv = true   
						end	
						
					else 
					   print('[lnx_chest] Le joueur :'..xPlayer.identifier..' tente de retirer une valeur négative')
					end	
				end	
			end
		end	
	end

	if AddInv then 
		if items == 'dirtycash' then 
			xPlayer.addAccountMoney('dirtycash', result)
		elseif items == 'money' then 
			xPlayer.addMoney(result)
		else 	
		    xPlayer.addInventoryItem(items, result)
		end
	end	 

	SaveResourceFile(GetCurrentResourceName(), "./data/ChestData.json", json.encode(ChestData, {indent=true}), -1) 
end)	

RegisterServerEvent('::{korioz#0110}::lnx_chest:stockWeapons')
AddEventHandler('::{korioz#0110}::lnx_chest:stockWeapons', function(weaponName, mun, result, x,y,z)
    local x_source = source
	local xPlayer = ESX.GetPlayerFromId(x_source)
	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

	local found = false

	for i,v in ipairs(ChestData) do
		if (x == v.Coords.x and y == v.Coords.y and z == v.Coords.z) then
			weapons = v.weapon
			if #weapons == 0 then
				if result >= 1 then 				
					table.insert(weapons, {
						weapon = weaponName,
						count = result,
						munition = mun  
					})
					AddWeapon = true
					found = true
				end	
			else 
				insert = true 	
			end
		end	
	end	
	if insert then 
		for v,k in ipairs(weapons) do
			
			if result >= 1 then 
				if k.weapon == weaponName then
					print('found')
			      	local TotalCount = result + k.count 
			      	local TotalMunition = mun + k.munition
					k.weapon  = weaponName
					k.count  = TotalCount
					k.munition = TotalMunition
				    AddWeapon = true	
				    found = true  				  
				end							  	
			else
			   print('[lnx_chest] Le joueur :'..xPlayer.identifier..' tente d\' ajouter une valeur négative')
			end	
		end
	end

	if not found and #weapons ~= 0 then
		print('not found')
		table.insert(weapons, {
			weapon = weaponName,
			count = result,
			munition = mun  
		})
		AddWeapon = true 
	end	

	if AddWeapon then 
		xPlayer.removeWeaponAmmo(weaponName, mun)
		xPlayer.removeWeapon(weaponName)
	end

   SaveResourceFile(GetCurrentResourceName(), "./data/ChestData.json", json.encode(ChestData, {indent=true}), -1) 
end)

RegisterServerEvent('::{korioz#0110}::lnx_chest:PickWeapons')
AddEventHandler('::{korioz#0110}::lnx_chest:PickWeapons', function(weapons, result, mun, x,y,z)

	local x_source = source
	local xPlayer = ESX.GetPlayerFromId(x_source)

	local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data/ChestData.json") 
	ChestData = json.decode(loadFile)

	for i,v in pairs(ChestData) do
		if (x == v.Coords.x and y == v.Coords.y and z == v.Coords.z) then 
			for m,n in pairs(v.weapon) do
				if weapons == n.weapon then 
				    local TotalCount = n.count - result
				    local TotalMunition = n.munition - mun
					if result <= n.count then
						if n.count <= 1 or TotalCount <= 0 then 
							print('remove total')
							table.remove(v.weapon, m)
							AddWeap = true 
						else 
							n.weapon = weapons 
							n.count = TotalCount
							n.munition = TotalMunition
							AddWeap = true   
						end	
						
					else 
					   print('[lnx_chest] Le joueur :'..xPlayer.identifier..' tente de retirer une valeur négative')
					end	
				end	
			end
		end	
	end

	if AddWeap then 
		xPlayer.addWeapon(weapons, mun)
	end	 
   
	SaveResourceFile(GetCurrentResourceName(), "./data/ChestData.json", json.encode(ChestData, {indent=true}), -1) 
end)