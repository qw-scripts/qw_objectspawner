local objects = {}
local spawnedInObjects = {}

function objects.spawnNewObject(coords, rotation, object, dbId)
    local obj = CreateObjectNoOffset(object, coords.x, coords.y, coords.z, true, false, false)

    Entity(obj).state.object = {
        model = object,
        coords = coords,
        rotation = rotation,
        dbId = dbId,
    }

    local netId = NetworkGetNetworkIdFromEntity(obj)

    spawnedInObjects[#spawnedInObjects+1] = netId
end

function objects.despawnByNetId(netId)
    for i = 1, #spawnedInObjects do
        if spawnedInObjects[i] == netId then
            local obj = NetworkGetEntityFromNetworkId(spawnedInObjects[i])
            DeleteEntity(obj)
            table.remove(spawnedInObjects, i)
            break
        end
    end
end

function objects.updateObjectState(netId, coords, rotation)
    local obj = NetworkGetEntityFromNetworkId(netId)
    local objectState = Entity(obj).state?.object

    if not objectState then return end

    local model = objectState.model
    local dbId = objectState.dbId

    Entity(obj).state.object = {
        model = model,
        coords = coords,
        rotation = rotation,
        dbId = dbId,
    }
end

function objects.despawnAllObjects()
    for i = 1, #spawnedInObjects do
        local obj = NetworkGetEntityFromNetworkId(spawnedInObjects[i])
        DeleteEntity(obj)
    end

    spawnedInObjects = {}
end

function objects.getObjects()
    return spawnedInObjects
end

return objects