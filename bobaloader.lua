local loadver = ...
local cloneref = cloneref or function(obj)
    return obj
end
local starterGui = cloneref(game:GetService('StarterGui'))

local version = (loadver and tostring(loadver)) or 'main'

local suc, res = pcall(function()
    return game:HttpGet('https://raw.githubusercontent.com/nolumn/Bobo/refs/heads/main/games/'..tostring(game.PlaceId)..'/'..version..'.lua')
end)

if suc and res and res ~= '' then
    local runsuc, runres = pcall(function()
        loadstring(res)()
    end)
    if not runsuc then
        starterGui:SetCore('SendNotification', {
            Title = 'Failed to load!',
            Text = 'Error: '..tostring(runres),
            Duration = 20
        })
    end
else
    starterGui:SetCore('SendNotification', {
        Title = 'Failed to fetch!',
        Text = 'Could not reach: '..tostring(game.PlaceId)..'/'..version,
        Duration = 20
    })
end
