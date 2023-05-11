ESX = nil

local coodsVisible = false
local godmodeActive = false

Citizen.CreateThread(function()
	while ESX == nil do
		ESX = exports["es_extended"]:getSharedObject()
		Citizen.Wait(1)
	end
end)



--[[
   █████████     ███████       ███████    ███████████   ██████████    █████████ 
  ███░░░░░███  ███░░░░░███   ███░░░░░███ ░░███░░░░░███ ░░███░░░░███  ███░░░░░███
 ███     ░░░  ███     ░░███ ███     ░░███ ░███    ░███  ░███   ░░███░███    ░░░ 
░███         ░███      ░███░███      ░███ ░██████████   ░███    ░███░░█████████ 
░███         ░███      ░███░███      ░███ ░███░░░░░███  ░███    ░███ ░░░░░░░░███
░░███     ███░░███     ███ ░░███     ███  ░███    ░███  ░███    ███  ███    ░███
 ░░█████████  ░░░███████░   ░░░███████░   █████   █████ ██████████  ░░█████████ 
  ░░░░░░░░░     ░░░░░░░       ░░░░░░░    ░░░░░   ░░░░░ ░░░░░░░░░░    ░░░░░░░░░  
]]--

Citizen.CreateThread(function()
    Wait(50)
    while true do
		if coodsVisible then 
			Text(getCoodsString(true))
			Citizen.Wait(1)
		else
			Citizen.Wait(200)
		end 
		
        
    end
end)

RegisterNetEvent("DaCMD:toggleCoodsVisibillity")
AddEventHandler("DaCMD:toggleCoodsVisibillity", function()
    if coodsVisible then
        coodsVisible = false
    else
        coodsVisible = true
    end 	
end)

RegisterNetEvent("DaCMD:CopyCoords")
AddEventHandler("DaCMD:CopyCoords", function()
    copy(getCoodsString(false))
end)


--[[
 █████   █████ ██████████ █████   █████ █████   █████████  █████       ██████████
░░███   ░░███ ░░███░░░░░█░░███   ░░███ ░░███   ███░░░░░███░░███       ░░███░░░░░█
 ░███    ░███  ░███  █ ░  ░███    ░███  ░███  ███     ░░░  ░███        ░███  █ ░ 
 ░███    ░███  ░██████    ░███████████  ░███ ░███          ░███        ░██████   
 ░░███   ███   ░███░░█    ░███░░░░░███  ░███ ░███          ░███        ░███░░█   
  ░░░█████░    ░███ ░   █ ░███    ░███  ░███ ░░███     ███ ░███      █ ░███ ░   █
    ░░███      ██████████ █████   █████ █████ ░░█████████  ███████████ ██████████
     ░░░      ░░░░░░░░░░ ░░░░░   ░░░░░ ░░░░░   ░░░░░░░░░  ░░░░░░░░░░░ ░░░░░░░░░░ 
]]--

RegisterNetEvent("DaCMD:fireVehicleAddEvent")
AddEventHandler('DaCMD:fireVehicleAddEvent', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if IsPedInAnyVehicle(ped) then
        local plate = tostring(GetVehicleNumberPlateText(vehicle))
        local target = GetPlayerServerId(PlayerId())
        local props = GetVehicleProperties(vehicle)
        local garage_type = GetGarageType(vehicle)
		
		print("hello")
		
        TriggerServerEvent('DaCMD:VehicleAdd', plate, target, props, garage_type)
    else
        TriggerEvent('notifications',"#07b95e", 'DaCMD:',  "Du bist in keinem Fahrzeug!" )
    end
end)

RegisterNetEvent("DaCMD:fireVehicleDeleteEvent")
AddEventHandler('DaCMD:fireVehicleDeleteEvent', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if IsPedInAnyVehicle(ped) then
        local plate = tostring(GetVehicleNumberPlateText(vehicle))
        TriggerServerEvent('DaCMD:VehicleDelete', vehicle, plate)
    else
        TriggerEvent('notifications',"#07b95e", 'DaCMD:',  "Du bist in keinem Fahrzeug!" )
    end
end)


RegisterNetEvent("DaCMD:fireChangePlateEvent")
AddEventHandler('DaCMD:fireChangePlateEvent', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if IsPedInAnyVehicle(ped) then
        local newplate = CreateDialog("Kennz anpassen")

        newplate = Trim(tostring(newplate))
        oldplate = tostring(GetVehicleNumberPlateText(vehicle))

        if newplate ~= "" and string.len(newplate)<=8 then 
			TriggerServerEvent("DaCMD:ChangePlate",oldplate,newplate)
            exports["AdvancedParking"]:UpdatePlate(vehicle, newplate)
        else
			if string.len(newplate) > 8 then 
				TriggerEvent('notifications',"#07b95e", 'DaCMD:',  "Neues Kennzeichen darf länger als 8 Zeichen sein!" )    
			else
				TriggerEvent('notifications',"#07b95e", 'DaCMD:',  "Neues Kennzeichen darf nicht leer sein!" )    
			end 
        end 
    else
        TriggerEvent('notifications',"#07b95e", 'DaCMD:',  "Du bist in keinem Fahrzeug!" )
    end
end)

RegisterNetEvent('DaCMD:DeleteVehicle')
AddEventHandler('DaCMD:DeleteVehicle', function(vehicle)
    ESX.Game.DeleteVehicle(vehicle)
end)

RegisterNetEvent('DaCMD:FixVehicle')
AddEventHandler('DaCMD:FixVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if IsPedInAnyVehicle(ped) then
        SetVehicleCanDeformWheels(vehicle, true)
		Wait(100)
        exports['AdvancedParking']:FixVehicleDeformation(vehicle)		
        SetVehicleFixed(vehicle)
		SetVehicleBodyHealth(vehicle, 1000.0)
		
		exports["LegacyFuel"]:SetFuel(vehicle,100)
		
    else
        TriggerEvent('notifications',"#07b95e", 'DaCMD:',  "Du bist in keinem Fahrzeug!" )
    end 
    
end)



--[[
   █████████     ███████    ██████████   ██████   ██████    ███████    ██████████   ██████████
  ███░░░░░███  ███░░░░░███ ░░███░░░░███ ░░██████ ██████   ███░░░░░███ ░░███░░░░███ ░░███░░░░░█
 ███     ░░░  ███     ░░███ ░███   ░░███ ░███░█████░███  ███     ░░███ ░███   ░░███ ░███  █ ░ 
░███         ░███      ░███ ░███    ░███ ░███░░███ ░███ ░███      ░███ ░███    ░███ ░██████   
░███    █████░███      ░███ ░███    ░███ ░███ ░░░  ░███ ░███      ░███ ░███    ░███ ░███░░█   
░░███  ░░███ ░░███     ███  ░███    ███  ░███      ░███ ░░███     ███  ░███    ███  ░███ ░   █
 ░░█████████  ░░░███████░   ██████████   █████     █████ ░░░███████░   ██████████   ██████████
  ░░░░░░░░░     ░░░░░░░    ░░░░░░░░░░   ░░░░░     ░░░░░    ░░░░░░░    ░░░░░░░░░░   ░░░░░░░░░░ 
]]--
Citizen.CreateThread(function()
	while true do
		if godmodeActive then 
			TriggerEvent('esx_status:set', 'hunger', 1000000)
			TriggerEvent('esx_status:set', 'thirst', 1000000)
			Citizen.Wait(60*1000)
		else
			Citizen.Wait(15*1000)
		end 
	end 
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if godmodeActive then 
			--SetPlayerInvincible(PlayerPedId(), true)
			--SetPedArmour(PlayerPedId(-1), 100)
			
			SetEntityInvincible(GetPlayerPed(-1), godmodeActive)
			
		else
			--SetPlayerInvincible(PlayerPedId(), false)
			
			SetEntityInvincible(GetPlayerPed(-1), godmodeActive)
			
		end 

		
	end 
end)

RegisterNetEvent("DaCMD:toggleGodmode")
AddEventHandler("DaCMD:toggleGodmode", function()
    if godmodeActive then
        godmodeActive = false
		
        doNotify("Godmode deaktiviert!")
    else
        godmodeActive = true
        doNotify("Godmode aktiviert!")
    end 

	
end)


--[[
    ███████    ███████████ █████   █████ ██████████ ███████████    █████████ 
  ███░░░░░███ ░█░░░███░░░█░░███   ░░███ ░░███░░░░░█░░███░░░░░███  ███░░░░░███
 ███     ░░███░   ░███  ░  ░███    ░███  ░███  █ ░  ░███    ░███ ░███    ░░░ 
░███      ░███    ░███     ░███████████  ░██████    ░██████████  ░░█████████ 
░███      ░███    ░███     ░███░░░░░███  ░███░░█    ░███░░░░░███  ░░░░░░░░███
░░███     ███     ░███     ░███    ░███  ░███ ░   █ ░███    ░███  ███    ░███
 ░░░███████░      █████    █████   █████ ██████████ █████   █████░░█████████ 
   ░░░░░░░       ░░░░░    ░░░░░   ░░░░░ ░░░░░░░░░░ ░░░░░   ░░░░░  ░░░░░░░░░  
                                                                             
]]--

RegisterNetEvent('sendToClipBoard')
AddEventHandler('sendToClipBoard', function(text)
    copy(tostring(text))
end)

function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(0.378, 0.378)
	SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.017, 0.977)
end

function copy(text)
    SendNUIMessage({
        payload = text
    })
    doNotify("In Zwischenablage kopiert!")
end

function getCoodsString(inclDescription)
    local plyCoords = GetEntityCoords(PlayerPedId(), false)

    local x = doround(plyCoords.x,4)
    local y = doround(plyCoords.y,4)
    local z = doround(plyCoords.z,4)
    local heading = doround(GetEntityHeading(PlayerPedId(), 4))

    if inclDescription then 
        return '~r~X: ~w~' .. x .. ' ~b~Y: ~w~' .. y .. ' ~g~Z: ~w~' .. z .. ' ~y~Angle: ~w~' .. heading
    else
        return x .. ' ,' .. y .. ' ,' .. z .. ' ,' .. heading
    end 
end 


function doround(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end


function doNotify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end 


function CreateDialog(window_title)
	AddTextEntry(window_title, window_title)
	DisplayOnscreenKeyboard(1, window_title, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end

function GetVehicleProperties(vehicle)
    if DoesEntityExist(vehicle) then
        local props
        
            props = ESX.Game.GetVehicleProperties(vehicle)
        
        if not Config.SaveCarHealth then
            return props
        end
        props.tyres = {}
        props.doors = {}
        for t = 1, 7 do
            local tyre1 = IsVehicleTyreBurst(vehicle, t, true)
            local tyre2 = IsVehicleTyreBurst(vehicle, t, false)
            if tyre1 or tyre2 then
                props.tyres[t] = true
            else
                props.tyres[t] = false
            end
        end
        Wait(100)
        for t = 0, 5 do
            local door = IsVehicleDoorDamaged(vehicle, t)
            if door then
                props.doors[#props.doors+1] = door
            else
                props.doors[#props.doors+1] = false
            end
        end
        Wait(500)
        return props
    end
end



function GetGarageType(vehicle)
    local hash = GetEntityModel(vehicle)
    local garage_type = 'car'
    if IsThisModelAHeli(hash) or IsThisModelAPlane(hash) then
        garage_type = 'air'
    elseif IsThisModelABoat(hash) or IsThisModelAJetski(hash) or hash == GetHashKey('submersible') or hash == GetHashKey('submersible2') then
        garage_type = 'boat'
    end
    return garage_type
end

function Trim(text)
    return text:gsub("^%s(.-)%s$", "%1")
end





RegisterNetEvent('notifications')
AddEventHandler('notifications', function(color, title, message)
	TriggerEvent("ESX:Notify", "info",3000, message)
end)
