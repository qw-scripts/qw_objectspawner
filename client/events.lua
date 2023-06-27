local utils = require 'client.utils'

utils.entityStateHandler('object', function(entity, _, value)
    if not value then return end

    if NetworkGetEntityOwner(entity) ~= cache.playerId then return end

    -- set entity rotation
    SetEntityRotation(entity, value.rotation.x, value.rotation.y, value.rotation.z, 2, true)
    -- set entity coords
    SetEntityCoords(entity, value.coords.x, value.coords.y, value.coords.z, false, false, false, false)
    -- Freeze entity position
    FreezeEntityPosition(entity, true)
end)