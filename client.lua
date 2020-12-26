print('Script start')
-- ped 

Config = {}

Config.pPos2     = {
    { "u_m_y_chip", vector4(-503.8, -670.92, 32.08, 359.5)},

}

config = {
	shops = {
		{pos = vector3(-503.8, -670.92, 32.08)}
    }
}
Citizen.CreateThread(function()
    for _,k in pairs(Config.pPos2) do

        local hash = GetHashKey(k[1])
        while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
        end
        pPed = CreatePed("PED_TYPE_CIVFEMALE", k[1], k[2], true, true)
        SetBlockingOfNonTemporaryEvents(pPed, true)
        FreezeEntityPosition(pPed, true)
        SetEntityInvincible(pPed, true)
    end
end)

-- fonctions

function ShowHelpNotification(msg, thisFrame)
	AddTextEntry('HelpNotification', msg)--ADEMO
	DisplayHelpTextThisFrame('HelpNotification', false)
end
function drawCenterText(msg, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end
--[[function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
  end--]]
-----------------------------------------------------------Positions-----------------------------------------------------------
local posachatbmx = {
	{x = -503.84,  y = -671.28, z = 33.08},
	{x = 1760.51, y = 3293.06, z = 41.138}
}


RegisterNetEvent('bmx:RecevoirBmx') --> Recoit l'item BMX dans son inventaire.
AddEventHandler('bmx:RecevoirBmx', function()
    TriggerEvent("player:receiveItem", 'BMX', 1)
end)

RegisterNetEvent('bmx:RetirerBmx') --> Retirer l'item BMX de son inventaire.
AddEventHandler('bmx:RetirerBmx', function()
    TriggerEvent('player:looseItem','BMX', 1)
end)

--[[Citizen.CreateThread(function()
    local attente = 150
    while true do
        Wait(attente)
        for k in pairs(posachatbmx) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, posachatbmx[k].x, posachatbmx[k].y, posachatbmx[k].z)

            if dist <= 2.0 then
                attente = 0
                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour commencer à acheter vos articles")
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent('addbmx')
                    TriggerEvent("nMenuNotif:showNotification", 'BMX ajouté à votre inventaire')
                    Citizen.Wait(5000)
                end
            else
                attente = 0
            end
        end
    end
end)--]]

Citizen.CreateThread(function()
    while true do
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
		local shops = false
		local dst = GetDistanceBetweenCoords(pCoords, true)
        for k,v in pairs(config.shops) do
			if #(pCoords - v.pos) < 1.5 then
				
                shops = true
                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour parler au conseiller")
                if IsControlJustReleased(0, 38) then
                    drawCenterText('~b~[Frank]~b~ ~s~Bonjour et bienvenue à vous, je suis Frank, des renseignements ça vous dit ?', 3000)
                    Wait(3000)
                    drawCenterText('~b~[Vous]~b~ ~s~Oui pourquoi pas.', 3000)
                    Wait(3000)
					OpenMenuTuto()
				end
            end
        end

        if shops then
            Wait(1)
        else
            Wait(2000)
        	end
		end
end)


Citizen.CreateThread(function()

    for k in pairs(posachatbmx) do

	local blip = AddBlipForCoord(posachatbmx[k].x, posachatbmx[k].y, posachatbmx[k].z)

	SetBlipSprite(blip, 88)
	SetBlipColour(blip, 47)
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Agence de tourisme")
    EndTextCommandSetBlipName(blip)
    end
end)

-------------------------------------------------------------Blips-------------------------------------------------------------

function locabmxpos()
	x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
	playerX = tonumber(string.format("%.2f", x))
    playerY = tonumber(string.format("%.2f", y))
    playerZ = tonumber(string.format("%.2f", z))
end

function RangerVeh()
    local vehicle = nil
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
    else
        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
    end
    local plaque = GetVehicleNumberPlateText(vehicle)
    if plaque == "LOCATION" then
        --Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( GetVehiclePedIsIn(GetPlayerPed(-1), false)))
        SetEntityAsMissionEntity(vehicle, false, true)
        DeleteVehicle(vehicle)
        TriggerServerEvent('addbmx')
        PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
    else
        TriggerEvent("nMenuNotif:showNotification", "Ce n'est pas un bmx")
    end
end

RegisterNetEvent('bmx:usebmx')
AddEventHandler('bmx:usebmx', function()
    locabmxpos()
    TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor', 8.0, 1.0, 1000, 16, 0.0, false, false, false)
    --Citizen.Wait(800)
    spawnCar("bmx")
    TriggerServerEvent('removebmx')
end)

Citizen.CreateThread(function()
    local attente = 150
    local count = 0
    while true do
        Wait(attente)
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        --for k,v in pairs(vehicle) do 
            local oCoords = GetEntityCoords(v)
            local dst = GetDistanceBetweenCoords(pCoords, oCoords, true)
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), 1)
            --local plaque = GetVehicleNumberPlateText(vehicle)
            if dst <= 1.8 then 
                    attente = 1
                    ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour ranger votre bmx")
                    if IsControlJustReleased(1, 38) then 
                        TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
                        while IsPedInVehicle(PlayerPedId(), vehicle, true) do
                            Citizen.Wait(0)
                        end
                        TaskPlayAnim(GetPlayerPed(-1), 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor', 8.0, 1.0, 1000, 16, 0.0, false, false, false)
                        Citizen.Wait(1200)
                        RangerVeh()
                    end
                    break
            else
                attente = 150
            end
        --end
    end
end)

function OpenMenuTuto()
    local conseille = RMenu.Add('conseil', 'main', RageUI.CreateMenu("Agence de tourisme", "~p~Renseignez vous sur la ville"), true)
    --local armes = RMenu.Add('showcase', 'submenu', RageUI.CreateSubMenu(RMenu:Get('showcase', 'main'), "Armes", "armes"))
    RageUI.Visible(conseille, not RageUI.Visible(conseille))

    conseille:SetRectangleBanner(0, 0, 0, 255)

    while conseille do
        Citizen.Wait(5)
        RageUI.IsVisible(conseille, function()
                local source = source
                RageUI.Item.Separator("↓↓↓ ~b~Renseignements ~s~↓↓↓", nil, {}, true, function(_, _, _)
                end)                
                RageUI.Item.Button("Comment gagner de l'argent en ville ?", nil, { RightLabel = ''}, true , {
                    onSelected = function()
                        drawCenterText("~b~[Frank]~b~ ~s~Alors d'abord tu pourras te diriger vers le pole emploi", 3000)
                        Wait(3000)
                        drawCenterText("~b~[Frank]~b~ ~s~puis ensuite postuler à des métiers plus stables", 3000)
                    end
                })
                RageUI.Item.Button("Ou peut-on bien manger ?", nil, { RightLabel = ''}, true , {
                    onSelected = function()
                        drawCenterText("~b~[Frank]~b~~s~ Il y a différentes superettes un peu de partout en ville.", 3000)

                    end
                })
                RageUI.Item.Button("A propos des habitations ?", nil, { RightLabel = ''}, true , {
                    onSelected = function()
                        drawCenterText("~b~[Frank]~b~~s~ Vous pouvez aller à l'agence immobilière.", 3000)   
                    end
                })
                RageUI.Item.Button("Discord de la ville ?", nil, { RightLabel = ''}, true , {
                    onSelected = function()
                        drawCenterText("~b~[Frank]~b~~s~ Connectez vous à cette addresse: ~b~discord.gg/.", 3000)   
                    end
                })
                RageUI.Item.Separator("↓↓↓ ~b~Location ~s~↓↓↓", nil, {}, true, function(_, _, _)
                end)      
                RageUI.Item.Button("Louer un bmx de poche", nil, { RightLabel = '~g~300$'}, true , {
                    onSelected = function()
                        drawCenterText("~b~[Frank]~b~~s~ Et voici, prenez en soin !", 3000)
                        Wait(2000)
                        TriggerServerEvent('talec:money2')   
                        TriggerServerEvent('addbmx')
                        TriggerEvent("nMenuNotif:showNotification", 'BMX ajouté à votre inventaire')
                        Citizen.Wait(5000)
                    end
                })
        end)
        if not RageUI.Visible(conseille) then
            conseille = RMenu:DeleteType("conseil", true)
        end
    end
end