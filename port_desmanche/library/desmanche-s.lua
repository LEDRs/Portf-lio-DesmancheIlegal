-----------------/ Resource /-----------------
addEventHandler("onResourceStart", resourceRoot, function()
    outputDebugString("[Leo Developer - Portfólio] O Resource "..getResourceName(resource).." Foi Iniciado Com Sucesso!")
end)

-----------------/ Marker /-----------------
local desmanche = {}

for _, v in ipairs(CONFIG.MARKERS) do
    local marker_ = createMarker(v.x, v.y, v.z -1, v.type, v.size, v.color[1], v.color[2], v.color[3])
    desmanche["marker"] = marker_
end

addEventHandler("onMarkerHit", desmanche["marker"], function(player)
    local accName = getAccountName(getPlayerAccount(player))
    if (isObjectInACLGroup("user."..accName, aclGetGroup(CONFIG.ACL_PERMISSION))) then
        exports["port_infobox"]:addNotification(player, "Digite /iniciar Para Desmanchar Um Veiculo!", "info")
    end
end)

-----------------/ Comandos Uteis /-----------------
addCommandHandler("pos", function(player)
    local posX, posY, posZ = getElementPosition(player)
    outputChatBox("x = "..posX..", y = "..posY..", z = "..posZ)
end)

-----------------/ Comando /-----------------
addCommandHandler(CONFIG.COMMAND_START, function(player)
    local accName = getAccountName(getPlayerAccount(player))
    if (isObjectInACLGroup("user."..accName, aclGetGroup(CONFIG.ACL_PERMISSION))) then
        for _, vehicle in ipairs(getElementsByType("vehicle")) do
            if (isPedInVehicle(player)) then
                if (isElementWithinMarker(vehicle, desmanche["marker"])) then

                    for _, v in ipairs(CONFIG.VEHICLES) do
                        if (getElementModel(vehicle) == v.id) then
                            exports["port_infobox"]:addNotification(player, "Desmanche Iniciado, Aguarde...", "info")
                            setTimer(
                                function()
                                    givePlayerMoney(player, v.price)
                                    exports["port_infobox"]:addNotification(player, "Veiculo Do Modelo "..v.name.." Foi Desmanchado Com Sucesso!", "success")
                                    destroyElement(vehicle)
                                end,
                                v.timer,
                                1
                            )
                        end
                    end
                end
            else
                exports["port_infobox"]:addNotification(player, "Você Precisa Estar Em Um Veiculo", "error")
            end
        end
    end
end)