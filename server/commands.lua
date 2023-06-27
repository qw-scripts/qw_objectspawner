lib.addCommand('objectspawner', {
    help = 'open the object spawner',
    restricted = 'group.admin'
}, function(source, args, raw)
    TriggerClientEvent('qw_decorator:client:open', source)
end)