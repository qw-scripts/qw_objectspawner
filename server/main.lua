local db = require 'server.db'
local objects = require 'server.objects'

RegisterNetEvent('objects:server:newObject', function(data)
    objects.spawnNewObject(data)
end)

RegisterNetEvent('objects:server:updateObject', function(data)
    objects.updateObject(data)
end)

RegisterNetEvent("objects:server:removeObject", function(insertId)
    objects.removeObject(insertId)
end)

lib.callback.register('objects:getAllObjects', function(source)
    local allScenes = db.selectAllSyncedObjects()
    return ServerObjects
end)

lib.callback.register('objects:getAllScenes', function(source)
    local allScenes = db.selectAllScenesWithCountOfSceneObjects()
    return allScenes
end)

lib.callback.register('objects:newScene', function(source, sceneName)
    local newScene = db.insertNewScene(sceneName)

    if newScene ~= 0 then
        return true
    end

    return false
end)

lib.addCommand('objectspawner', {
    help = 'open the object spawner',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent('objects:client:menu', source)
end)
