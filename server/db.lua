local MySQL = MySQL
local db = {}


local SELECT_ALL_SYNCED_OBJECTS = 'SELECT * FROM `synced_objects`'
---Select all synced objects
---@return table
function db.selectAllSyncedObjects()
    return MySQL.query.await(SELECT_ALL_SYNCED_OBJECTS) or {}
end

local INSERT_NEW_SYNCED_OBJECT = 'INSERT INTO `synced_objects` (`model`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `heading`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
---Insert a new synced object
---@param model string
---@param x string
---@param y string
---@param z string
---@param rx string
---@param ry string
---@param rz string
---@param heading number
---@return table
function db.insertNewSyncedObject(model, x, y, z, rx, ry, rz, heading)
    return MySQL.prepare.await(INSERT_NEW_SYNCED_OBJECT, { model, x, y, z, rx, ry, rz, heading })
end

local DELETE_SYNCED_OBJECT = 'DELETE FROM `synced_objects` WHERE `id` = ?'
---Delete a synced object
---@param id number
---@return table
function db.deleteSyncedObject(id)
    return MySQL.prepare.await(DELETE_SYNCED_OBJECT, { id })
end

local UPDATE_SYNCED_OBJECT = 'UPDATE `synced_objects` SET `model` = ?, `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `heading` = ? WHERE `id` = ?'
---Update a synced object
---@param model string
---@param x string
---@param y string
---@param z string
---@param rx string
---@param ry string
---@param rz string
---@param heading number
---@param id number
---@return table
function db.updateSyncedObject(model, x, y, z, rx, ry, rz, heading, id)
    return MySQL.prepare.await(UPDATE_SYNCED_OBJECT, { model, x, y, z, rx, ry, rz, heading, id })
end

return db