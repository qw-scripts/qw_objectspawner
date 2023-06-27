local db = require 'server.db'
local objects = require 'server.objects'


lib.callback.register('objects:getAllObjects', function(source)
    local spawnedInObjects = objects.getObjects()

    return spawnedInObjects
end)

lib.callback.register('objects:newObject', function(_, data)
    local newObject = db.insertNewSyncedObject(data.model, data.x, data.y, data.z, data.rx, data.ry, data.rz, data.heading)

    local coords = vector3(tonumber(data.x), tonumber(data.y), tonumber(data.z))
    local rotation = vector3(tonumber(data.rx), tonumber(data.ry), tonumber(data.rz))

    print(newObject)
    if newObject ~= 0 then
       objects.spawnNewObject(coords, rotation, data.model, newObject)
       return true
    end

    return false
end)

lib.callback.register('objects:deleteObject', function(source, id, netId)
    local deletedObject = db.deleteSyncedObject(id)

    if deletedObject then
        objects.despawnByNetId(netId)
        return true
    end

    return false
end)

lib.callback.register('objects:updateObject', function(source, data)
    local updatedObject = db.updateSyncedObject(data.model, data.x, data.y, data.z, data.rx, data.ry, data.rz, data.heading, data.id)

    local coords = vector3(tonumber(data.x), tonumber(data.y), tonumber(data.z))
    local rotation = vector3(tonumber(data.rx), tonumber(data.ry), tonumber(data.rz))

    if updatedObject ~= 0 then
        objects.updateObjectState(data.netId, coords, rotation)
        return true
    end

    return false
end)

lib.callback.register('objects:deleteAllObjects', function(source)
    local deletedObjects = db.removeAllSyncedObjects()

    if deletedObjects then
        objects.despawnAllObjects()
        return true
    end

    return false
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
        objects.despawnAllObjects()
   end
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
        local savedObjects = db.selectAllSyncedObjects()

        if #savedObjects == 0 then return end

        for k, v in pairs(savedObjects) do
            local coords = vector3(tonumber(v.x), tonumber(v.y), tonumber(v.z))
            local rotation = vector3(tonumber(v.rx), tonumber(v.ry), tonumber(v.rz))
            local model = v.model
            local dbId = v.id

            objects.spawnNewObject(coords, rotation, model, dbId)
        end
   end
end)