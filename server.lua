RegisterServerEvent('talec:money2')
AddEventHandler('talec:money2', function ()
    
-- Tu déclare ta variable source par sécurité : 
    local source = source    
-- Tu get les info du joueur avec cette event : 
    TriggerEvent('GTA:GetInfoJoueurs', source, function(data)
-- Tu fait une condition pour check si le joueur a assez d'argent propre sur lui : 
        if (data.argent_propre >= 150) then 
  --> Tu retire l'argent propre du joueur : 
            TriggerEvent('GTA:RetirerArgentPropre', source, 300)
            TriggerClientEvent('nMenuNotif:showNotification', source, "Paiement accepté !")
        else
            TriggerClientEvent('nMenuNotif:showNotification', source, "Paiement refusé ! Vous n'avez pas assez d'argent")
        end
end)
end)

RegisterNetEvent('removebmx')
AddEventHandler('removebmx', function()
    TriggerClientEvent('bmx:RetirerBmx', source) 
end)

RegisterNetEvent('addbmx')
AddEventHandler('addbmx', function()
    TriggerClientEvent('bmx:RecevoirBmx', source)
end)