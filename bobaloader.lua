local loadver = ({...})[1]
local cloneref = cloneref or function(obj)
    return obj
end
local starterGui = cloneref(game:GetService('StarterGui'))

local version = (loadver and tostring(loadver)) or 'main'
local url = 'https://raw.githubusercontent.com/nolumn/Bobo/refs/heads/main/games/'..tostring(game.PlaceId)..'/'..version..'.lua'

local suc, res = pcall(function()
    return game:HttpGet(url)
end)

if not suc then
    starterGui:SetCore('SendNotification', {
        Title = 'Fetch failed',
        Text = tostring(res),
        Duration = 20
    })
    return
end

if not res or res == '' or res:find('404') then
    starterGui:SetCore('SendNotification', {
        Title = 'File not found',
        Text = url,
        Duration = 20
    })
    return
end

local runsuc, runres = pcall(loadstring(res))
if not runsuc then
    starterGui:SetCore('SendNotification', {
        Title = 'Run failed',
        Text = tostring(runres),
        Duration = 20
    })
end
