local db = require 'server.db'

local objects = {}
ServerObjects = {}

function objects.spawnNewObject(data)
    local insertId = db.insertNewSyncedObject(data.model, data.x, data.y, data.z, data.rx, data.ry, data.rz, data.heading, data.sceneid)

    local coords = vector3(tonumber(data.x), tonumber(data.y), tonumber(data.z))
    local rotation = vector3(tonumber(data.rx), tonumber(data.ry), tonumber(data.rz))

    if insertId == 0 then return end

    ServerObjects[insertId] = {
        coords = coords,
        rotation = rotation,
        model = data.model,
        sceneid = data.sceneid,
        id = insertId,
    }

    TriggerClientEvent('objects:client:addObject', -1, ServerObjects[insertId])
end

--- removes an object from the database and the world
---@param insertId number
function objects.removeObject(insertId)
    local deletedObjectId = db.deleteSyncedObject(insertId)
    
    if deletedObjectId == 0 then return end

    ServerObjects[deletedObjectId] = nil
    TriggerClientEvent('objects:client:removeObject', -1, insertId)
end

--- update an object in the database and the world
---@param data table
function objects.updateObject(data)
    local insertId = data.insertId
    local model = data.model
    local x, y, z = data.x, data.y, data.z
    local rx, ry, rz = data.rx, data.ry, data.rz
    local updatedObject = db.updateSyncedObject(model, x, y, z, rx, ry, rz, insertId)
    
    if updatedObject == 0 then return end
    
    local coords = vec3(tonumber(x), tonumber(y), tonumber(z))
    local rotation = vec3(tonumber(rx), tonumber(ry), tonumber(rz))
    
    local spawnedObject = ServerObjects[insertId]
    spawnedObject.coords = coords
    spawnedObject.rotation = rotation
    TriggerClientEvent('objects:client:updateObject', -1, { coords = coords, rotation = rotation, insertId = insertId })
end


AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        local savedObjects = db.selectAllSyncedObjects()

        if #savedObjects == 0 then return end

        for _, v in pairs(savedObjects) do
            local coords = vector3(tonumber(v.x), tonumber(v.y), tonumber(v.z))
            local rotation = vector3(tonumber(v.rx), tonumber(v.ry), tonumber(v.rz))
            local model = v.model
            local insertId = v.id

            ServerObjects[insertId] = {
                coords = coords,
                rotation = rotation,
                model = model,
                sceneid = v.sceneid,
                id = insertId,
            }
        end
        

        TriggerClientEvent('objects:client:loadObjects', -1, ServerObjects)
    end
end)

return objects
