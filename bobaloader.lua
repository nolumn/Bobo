local cloneref = cloneref or function(obj)
    return obj
end
local starterGui = cloneref(game:GetService('StarterGui'))

local suc, res = pcall(function()
    return game:HttpGet('https://raw.githubusercontent.com/nolumn/Bobo/refs/heads/main/games/'..tostring(game.PlaceId)..'.lua')
end)

if suc and (res and res ~= '') then
    local runsuc, runres = pcall(function()
        loadstring(res)()
    end)
    if not runsuc then
        starterGui:SetCore('SendNotification', {
            Title = 'Failed to load!',
            Text = 'Error : '..runres,
            Duration = 20
        })
    end
end
