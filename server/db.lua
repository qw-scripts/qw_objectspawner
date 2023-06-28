local MySQL = MySQL
local db = {}


local SELECT_ALL_SYNCED_OBJECTS_FROM_SCENE = 'SELECT * FROM `synced_objects` WHERE `sceneid` = ?'
---Select all synced objects from a scene
---@param sceneid number
---@return table
function db.selectAllSyncedObjectsFromScene(sceneid)
    return  MySQL.query.await(SELECT_ALL_SYNCED_OBJECTS_FROM_SCENE, { sceneid }) or {}
end

local SELECT_ALL_SYNCED_OBJECTS= 'SELECT * FROM `synced_objects`'
---Select all synced objects from a scene
---@return table
function db.selectAllSyncedObjects()
    return  MySQL.query.await(SELECT_ALL_SYNCED_OBJECTS) or {}
end

local SELECT_ALL_SCENES_WITH_COUNT_OF_SCENE_OBJECTS = 'SELECT `synced_objects_scenes`.`id`, `synced_objects_scenes`.`name`, COUNT(`synced_objects`.`id`) AS `count` FROM `synced_objects_scenes` LEFT JOIN `synced_objects` ON `synced_objects_scenes`.`id` = `synced_objects`.`sceneid` GROUP BY `synced_objects_scenes`.`id`'
---Select all scenes with count of scene objects
---@return table
function db.selectAllScenesWithCountOfSceneObjects()
    return MySQL.query.await(SELECT_ALL_SCENES_WITH_COUNT_OF_SCENE_OBJECTS) or {}
end

local INSERT_NEW_SYNCED_OBJECT = 'INSERT INTO `synced_objects` (`model`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `heading`, `sceneid`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
---Insert a new synced object
---@param model string
---@param x string
---@param y string
---@param z string
---@param rx string
---@param ry string
---@param rz string
---@param heading number
---@param sceneid number
---@return table
function db.insertNewSyncedObject(model, x, y, z, rx, ry, rz, heading, sceneid)
    return MySQL.prepare.await(INSERT_NEW_SYNCED_OBJECT, { model, x, y, z, rx, ry, rz, heading, sceneid })
end

local DELETE_SCENE_BY_ID = 'DELETE FROM `synced_objects_scenes` WHERE `id` = ?'
---Delete a scene by id
---@param id number
---@return table
function db.deleteSceneById(id)
    return MySQL.prepare.await(DELETE_SCENE_BY_ID, { id })
end

local DELETE_SYNCED_OBJECT = 'DELETE FROM `synced_objects` WHERE `id` = ?'
---Delete a synced object
---@param id number
---@return table
function db.deleteSyncedObject(id)
    return MySQL.prepare.await(DELETE_SYNCED_OBJECT, { id })
end

local UPDATE_SYNCED_OBJECT = 'UPDATE `synced_objects` SET `model` = ?, `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ? WHERE `id` = ?'
---Update a synced object
---@param model string
---@param x string
---@param y string
---@param z string
---@param rx string
---@param ry string
---@param rz string
---@param id number
---@return table
function db.updateSyncedObject(model, x, y, z, rx, ry, rz, id)
    return MySQL.prepare.await(UPDATE_SYNCED_OBJECT, { model, x, y, z, rx, ry, rz, id })
end

local INSERT_NEW_SCENE = 'INSERT INTO `synced_objects_scenes` (`name`) VALUES (?)'
---Insert a new scene
---@param name string
---@return table
function db.insertNewScene(name)
    return MySQL.prepare.await(INSERT_NEW_SCENE, { name })
end

return db