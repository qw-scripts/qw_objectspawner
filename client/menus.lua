local obj = require 'client.object'

local lib = lib
local menus = {}

local function newObject(sceneId)
    local input = lib.inputDialog('Synced Object', {
        {
            type = 'input',
            label = 'Object Name',
            required = true,
        },
    })

    local object = tostring(input[1])

    if not IsModelInCdimage(joaat(object)) then
        lib.notify({
            title = 'Object Spawner',
            description = ("The object \"%s\" is not in cd image, are you sure this exists?"):format(object),
            type = 'error'
        })
        return
    end

    obj.previewObject(object, sceneId)
end

local function createNewScene()
    local input = lib.inputDialog('New Scene', {
        {
            type = 'input',
            label = 'Scene Name',
            icon = 'pencil',
            required = true,
        },
    })

    if not input then return lib.showContext('object_menu_main') end

    local name = tostring(input[1])

    local newScene = lib.callback.await('objects:newScene', 100, name)

    if newScene then
        lib.notify({
            title = 'Object Spawner',
            description = ('Scene %s created'):format(name),
            type = 'success'
        })
    end
end

lib.registerContext({
    id = 'object_menu_main',
    title = 'Synced Objects',
    options = {
        {
            title = 'Scenes',
            description = 'view scenes that have been created',
            icon = 'camera',
            onSelect = function()
                menus.viewAllScenes()
            end,
        },
        {
            title = 'Create a New Scene',
            description = 'edit objects that have been placed',
            icon = 'plus',
            onSelect = function()
                createNewScene()
            end,
        },
    },
})

function menus.homeMenu()
    lib.showContext('object_menu_main')
end

function menus.viewAllScenes()
    local allScenes = lib.callback.await('objects:getAllScenes', 100)

    if #allScenes == 0 then
        lib.notify({
            title = 'Object Spawner',
            description = 'No scenes created',
            type = 'error'
        })
        return
    end

    local options = {}

    for i = 1, #allScenes do
        local scene = allScenes[i]
        local count = scene.count
        local name = scene.name
        local id = scene.id

        options[#options+1] = {
            title = name,
            description = ('View Scene: %s (%s Objects)'):format(name, count),
            icon = 'camera',
            onSelect = function()
                menus.viewObjectsInScene(id, name)
            end,
        }
    end

    lib.registerContext({
        id = 'object_menu_scenes',
        title = 'Scenes',
        menu = 'object_menu_main',
        options = options,
    })

    lib.showContext('object_menu_scenes')
end

function menus.editConfirmMenu(insertId)
    local objects = ClientObjects
    local object = objects[insertId]
    if DoesEntityExist(object.handle) then
        SetEntityDrawOutline(object.handle, true)
        SetEntityDrawOutlineColor(255, 0, 0, 255)
    end
    lib.registerContext({
        id = 'object_confirm_edit',
        title = ('Edit: %s'):format(object.model),
        onExit = function()
            if DoesEntityExist(object.handle) then
                SetEntityDrawOutline(object.handle, false)
            end
        end,
        options = {
            {
                title = 'Edit',
                icon = 'check',
                disabled = not DoesEntityExist(object.handle),
                onSelect = function()
                    SetEntityDrawOutline(object.handle, false)
                    obj.editPlaced(insertId)
                end,
            },
            {
                title = 'Delete',
                icon = 'trash',
                disabled = not DoesEntityExist(object.handle),
                onSelect = function()
                    SetEntityDrawOutline(object.handle, false)
                    obj.removeObject(insertId)
                end,
            },
            {
                title = 'TP To Entity',
                icon = 'arrows-to-circle',
                onSelect = function()
                    if DoesEntityExist(object.handle) then
                        SetEntityDrawOutline(object.handle, false)
                    end
                    SetEntityCoords(cache.ped, object.coords.x, object.coords.y, object.coords.z)
                end,
            }
        },
    })

    lib.showContext('object_confirm_edit')
end

local function getAllObjectsByScene(sceneId)
    local sceneObjects = {}
    for k, v in pairs(ClientObjects) do
        if v.sceneid == sceneId then
            sceneObjects[#sceneObjects+1] = v
        end
    end
    return sceneObjects
end

function menus.viewObjectsInScene(sceneId, sceneName)
    local sceneObjects = getAllObjectsByScene(sceneId)

    local options = {}

    options[#options+1] = {
        title = 'Add New Object',
        description = 'add a new object to this scene',
        icon = 'plus',
        onSelect = function()
            newObject(sceneId)
        end,
    }


    for i = 1, #sceneObjects do
        local object = sceneObjects[i]
        local model = object.model
        local fmtCoords = ('coords: %.3f, %.3f, %.3f'):format(object.coords.x, object.coords.y, object.coords.z)
        options[#options+1] = {
            title = model,
            description = fmtCoords,
            icon = 'object-ungroup',
            onSelect = function()
                menus.editConfirmMenu(object.id)
            end,
        }
    end

    lib.registerContext({
        id = 'scene_object_menu',
        title = ('Scene: %s'):format(sceneName),
        menu = 'object_menu_scenes',
        options = options,
    })

    lib.showContext('scene_object_menu')
end

return menus