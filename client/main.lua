local menus = require 'client.menus'

RegisterNetEvent("objects:client:menu", function()
    if GetInvokingResource() then return end -- only allow this to be called from the server
    menus.homeMenu()
end)
