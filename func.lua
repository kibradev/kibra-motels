local QBCore = exports['qb-core']:GetCoreObject()

DrawTextUI = function(ControlKey, Text)
    exports["kibra-uidrawtext"]:SendUI(ControlKey, Text)
end

CloseDrawTextUI = function()
    exports["kibra-uidrawtext"]:CloseUI()
end

RegisterNetEvent('KibraNotify', function(Text, Type)
    QBCore.Functions.Notify(Text, Type)
end)