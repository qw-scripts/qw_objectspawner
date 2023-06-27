local obj = {}

local inObjectPreview = false
local handle = nil

---get all placed objects
---@return table
function obj.getPlaced()
    local placed = lib.callback.await('objects:getAllObjects', 100)
    return placed
end

---removed an object from the database and the world
---@param id number
---@param netId number
function obj.removeObject(id, netId)
    local deleted = lib.callback.await('objects:deleteObject', 100, id, netId)
    if deleted then
        QBCore.Functions.Notify('Object deleted', 'success')
    end
end

---edit an object in the database and the world
---@param id number
---@param netId number
function obj.editPlaced(id, netId)
    local entity = NetworkGetEntityFromNetworkId(netId)
    local name = Entity(entity).state?.object.model or 'Unknown'

    local data = exports.object_gizmo:useGizmo(entity)

    if data then
        local coords = data.position
        local rotation = data.rotation
        lib.callback.await('objects:updateObject', 100, {
            model = name,
            x = ('%.3f'):format(coords.x),
            y = ('%.3f'):format(coords.y),
            z = ('%.3f'):format(coords.z),
            rx = ('%.3f'):format(rotation.x),
            ry = ('%.3f'):format(rotation.y),
            rz = ('%.3f'):format(rotation.z),
            heading = GetEntityHeading(entity),
            id = id,
            netId = netId
        })
    end
end

---spawn an object in the world
---@param model number
---@param modelName string
function obj.previewObject(model, modelName)
    inObjectPreview = true

    lib.requestModel(model, 1000)

    handle = CreateObject(model, GetEntityCoords(cache.ped), false, false, false)

    SetEntityAlpha(handle, 200, false)
    SetEntityCollision(handle, false, false)
    FreezeEntityPosition(handle, true)

    lib.hideTextUI()
    lib.showTextUI(
        '[E] Place Object  \n [G] Rotate 90  \n [L/R Arrow] Rotate Left/Right  \n [Q] Cancel', {
            position = "left-center",
        })

    CreateThread(function()
        while inObjectPreview do
            local hit, _, coords, _, _ = lib.raycast.cam(1, 4)
            if hit then
                SetEntityCoords(handle, coords.x, coords.y, coords.z)
                PlaceObjectOnGroundProperly(handle)

                -- Left
                if IsControlPressed(0, 174) then
                    SetEntityHeading(handle, GetEntityHeading(handle) - 1.0)
                end

                -- Right
                if IsControlPressed(0, 175) then
                    SetEntityHeading(handle, GetEntityHeading(handle) + 1.0)
                end

                -- G
                if IsControlJustPressed(0, 47) then
                    SetEntityHeading(handle, GetEntityHeading(handle) + 90.0)
                end

                -- Q
                if IsControlJustPressed(0, 44) then
                    lib.hideTextUI()
                    DeleteEntity(handle)
                    inObjectPreview = false
                end

                -- E
                if IsControlJustPressed(0, 38) then
                    local rotation = GetEntityRotation(handle, 2)
                    local wasPlaced = lib.callback.await('objects:newObject', 100, {
                        model = modelName,
                        x = ('%.3f'):format(coords.x),
                        y = ('%.3f'):format(coords.y),
                        z = ('%.3f'):format(coords.z),
                        rx = ('%.3f'):format(rotation.x),
                        ry = ('%.3f'):format(rotation.y),
                        rz = ('%.3f'):format(rotation.z),
                        heading = GetEntityHeading(handle),
                    })

                    if wasPlaced then
                        lib.hideTextUI()
                        DeleteEntity(handle)
                        inObjectPreview = false
                        handle = nil
                    end
                end
            end
        end
    end)
end

return obj
