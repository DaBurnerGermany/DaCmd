ESX = nil
while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
end


if Config.Enabled.deleteVehicle then 
    ESX.RegisterCommand("dv-complete", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:fireVehicleDeleteEvent")
        
    end, false, {help = "dv-complete", validate = true, arguments = {
    }})
end 

if Config.Enabled.addVehicle then 
    ESX.RegisterCommand("vehicle-add", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:fireVehicleAddEvent")
    end, false, {help = "vehicle-add", validate = true, arguments = {
    }})
end 

if Config.Enabled.fixVehicle then 
    ESX.RegisterCommand("vehicle-fix", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:FixVehicle")
    end, false, {help = "vehicle-fix", validate = true, arguments = {
    }})
end 

if Config.Enabled.changePlate then 
    ESX.RegisterCommand("change-plate", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:fireChangePlateEvent")
    end, false, {help = "change-plate", validate = true, arguments = {
    }})
end 

if Config.Enabled.toggleCoords then 
    ESX.RegisterCommand("toggleCoords", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:toggleCoodsVisibillity")
    end, false, {help = "toggleCoords", validate = true, arguments = {
    }})
end 

if Config.Enabled.copyCoords then 
    ESX.RegisterCommand("copyCoords", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:CopyCoords")
    end, false, {help = "copyCoords", validate = true, arguments = {
    }})
end 
if Config.Enabled.toggleGodmode then 
    ESX.RegisterCommand("toggleGodmode", "admin", function(xPlayer, args, showError)
        xPlayer.triggerEvent("DaCMD:toggleGodmode")
    end, false, {help = "toggleGodmode", validate = true, arguments = {
    }})
end 











RegisterServerEvent("DaCMD:VehicleAdd")
AddEventHandler('DaCMD:VehicleAdd', function(plate, target, props, garage_type)
    plate = Trim(tostring(plate))
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local perms = xPlayer.getGroup()
    if perms == 'admin' then
        if GetPlayerName(target) then
            local identifier = xPlayer.identifier
            local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE plate="'..plate..'"')
            if result[1] == nil then
                MySQL.Sync.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (@owner, @plate, @vehicle, @stored)',
                {
                    ['@owner'] = identifier,
                    ['@plate'] = plate,
                    ['@vehicle'] = json.encode(props),
                    ['@stored'] = 0,
                })
                TriggerClientEvent('notifications', _source,"#07b95e", 'DaCMD:',  "Fahrzeug " .. plate .. " zum Spieler hinzugefügt" )
            else
                TriggerClientEvent('notifications', _source,"#07b95e", 'DaCMD:',  "Fahrzeug " .. plate .. " existiert bereits in der DB" )
            end
        else
            TriggerClientEvent('notifications', _source,"#07b95e", 'DaCMD:',  "ID ist nicht online" )
        end
    end 
end)

RegisterServerEvent("DaCMD:VehicleDelete")
AddEventHandler('DaCMD:VehicleDelete', function(vehicle, plate)
    plate = Trim(tostring(plate))
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local perms = xPlayer.getGroup()
    if perms == 'admin' then
        local identifier = xPlayer.identifier
        local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE plate="'..plate..'"')
        if result[1] ~= nil then
            MySQL.Sync.execute('DELETE FROM owned_vehicles WHERE plate="'..plate..'"')
            TriggerClientEvent("DaCMD:DeleteVehicle",_source, vehicle)
            TriggerClientEvent('notifications', _source,"#07b95e", 'DaCMD:',  "Fahrzeug " .. plate .. " gelöscht" )
        else
            TriggerClientEvent('notifications', _source,"#07b95e", 'DaCMD:',  "Fahrzeug " .. plate .. " ist bereits gelöscht" )
        end
        
    end 
end)

RegisterServerEvent("DaCMD:ChangePlate")
AddEventHandler('DaCMD:ChangePlate', function(oldplate, plate)
    oldplate = Trim(tostring(oldplate))
    plate = Trim(tostring(plate))
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local perms = xPlayer.getGroup()
    
    if perms == 'admin' then
        local identifier = xPlayer.identifier
        local result = MySQL.Sync.fetchAll('SELECT plate FROM owned_vehicles WHERE plate="'..oldplate..'"')
        if result[1] ~= nil then
            MySQL.Sync.execute('UPDATE owned_vehicles SET plate = @plate WHERE plate = @old_plate',
                {
                    ['@plate'] = plate,
                    ['@old_plate'] = oldplate
                })
				
			print("Plate should now be "..plate)	
        else
			print("This vehicle does not exist")
        end
	else
		print("no admin")
    end 
end)


function Trim(text)
    return text:gsub("^%s(.-)%s$", "%1")
end