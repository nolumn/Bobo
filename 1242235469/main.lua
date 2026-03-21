if shared.garbage then
    for _, obj in ipairs(shared.garbage) do
        pcall(function() obj:Disconnect() end)
        pcall(function() obj:Destroy() end)
        obj = nil
    end
end
shared.garbage = {}
local garbage = shared.garbage
local cleanup = {
    add = function(obj)
        table.insert(shared.garbage, obj)
        return obj
    end
}

local runFunction = function(func)
    task.spawn(func)
end
local cloneref = cloneref or function(obj)
    return obj
end
local playersService = cloneref(game:GetService('Players'))
local userInputService = cloneref(game:GetService('UserInputService'))
local runService = cloneref(game:GetService('RunService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local lighting = cloneref(game:GetService('Lighting'))
local coreGui = cloneref(game:GetService('CoreGui'))

local libraryStuffUrl = 'https://github.com/nolumn/Bobo/raw/refs/heads/main/library_stuff.json'
local libStuffGet = game:HttpGet(libraryStuffUrl)
local libStuffData = httpService:JSONDecode(libStuffGet)
local libstuff = libStuffData

local lplrObject = playersService.LocalPlayer
local lplr = {}
lplr.char = lplrObject.Character
lplr.humanoid = lplr.char.Humanoid
lplr.rootPart = lplr.char.HumanoidRootPart
lplr.model = workspace.playerModels:FindFirstChild(tostring(lplrObject.Name))
lplr.visuals = lplr.model.visualFolder
lplr.hat = lplr.visuals:FindFirstChild('Hat')
lplr.axe = lplr.model.axe
lplr.ball = lplr.model.ball
lplr.camera = workspace.CurrentCamera
lplr.gui = lplrObject.PlayerGui

lplrObject.CharacterAdded:Connect(function(newChar)
    lplr.char = newChar
    lplr.humanoid = newChar:WaitForChild('Humanoid')
    lplr.rootPart = newChar:WaitForChild('HumanoidRootPart')
    lplr.model = nil
    lplr.axe = nil
    lplr.ball = nil
    lplr.visuals = nil
    lplr.hat = nil
    task.spawn(function()
        while not workspace.playerModels:FindFirstChild(tostring(lplrObject.Name)) do
            task.wait(0.05)
        end
        lplr.model = workspace.playerModels:FindFirstChild(tostring(lplrObject.Name))
        lplr.visuals = lplr.model:FindFirstChild('visualFolder')
        lplr.hat = lplr.visuals and lplr.visuals:FindFirstChild('Hat') or nil
        lplr.axe = lplr.model:FindFirstChild('axe')
        lplr.ball = lplr.model:FindFirstChild('ball')
    end)
end)

local map = workspace.map
local splits = map:FindFirstChild('splits')
local events = replicatedStorage:FindFirstChild('events')

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not isfolder('boba') then makefolder('boba') end
if not isfolder('boba/'..tostring(game.PlaceId)) then makefolder('boba/'..tostring(game.PlaceId)) end

local restructure = function(str, tbl)
    if str and tbl then
        local newStr = str
        for i, v in ipairs(tbl) do
            newStr = string.reverse(newStr):gsub(i, v)
        end
        return newStr
    end
end

local new = restructure(game.PlaceId, {
    [0]='n',[1]='A',[2]='b',[3]='E',[4]='NVN',[5]='3',[6]='.',[7]='K99',[8]='2',[9]='na',
})

local Window = Rayfield:CreateWindow({
    Name = "bobo",
    Icon = libstuff.ico[math.random(1, #libstuff.ico)] or 16547078391,
    LoadingTitle = 'bobo',
    LoadingSubtitle = "by "..table.concat(libstuff['developers'], ', ') or 'inner',
    ShowText = "bobo",
    Theme = libstuff['theme'] or 'Default',
    ToggleUIKeybind = libstuff['toggle'],
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = 'boba',
        FileName = game.PlaceId
    }
})

local returnRainbow = function()
    return Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
end
local notif = function(title, desc, dur, ico)
    if dur then
        Rayfield:Notify({
            Title = title or 'Iredescent',
            Content = desc,
            Duration = dur or 3,
            Image = ico or libstuff.ico[math.random(1, #libstuff.ico)] or 16547078391,
        })
    end
end
local chance = function(percent, func)
    if math.random(1, 100) <= percent then func() end
end
local sharedState = {
    spectating = false
}

local blatant = Window:CreateTab("Blatant", "flame")
local render = Window:CreateTab("Render", "palette")
local tools = Window:CreateTab("Tools", "wrench")
local world = Window:CreateTab("World", "globe")
local library = Window:CreateTab("Library", "download")

chance(3, function()
    local bobotab = Window:CreateTab(({'bob','boba','bobo','blob','obob','boo'})[math.random(1,math.random(2,6))], libstuff.ico[math.random(1,#libstuff.ico)] or 16547078391)
    local canspeaktobobo = true
    local speaktobobo = function(message)
        if not canspeaktobobo then return end
        canspeaktobobo = false
        task.delay(math.random(0.1, 0.5), function()
            notif('Bobo responded to you.', (libstuff.messages or {"Bobo","hey there","bob","hey man","I see you","cool address","what color is your hair?","you have a pretty smile :)","why do you do this?","when are you answering","im scared","you are %s, right?","leave","i hacked you lol","hello %s","you're on doxbin now!"})[math.random(1,#libstuff.messages)], math.random(3,6)):gsub('%s', (tostring(lplrObject.DisplayName) or tostring(lplrObject.Name)))
            task.delay(0.6, function() canspeaktobobo = true end)
        end)
    end
    local boboInput = bobotab:CreateInput({
        Name = "???", CurrentValue = "", PlaceholderText = "...",
        RemoveTextAfterFocusLost = false, Flag = "bobo_input", Callback = function() end,
    })
    bobotab:CreateButton({
        Name = "Send",
        Callback = function() speaktobobo(boboInput.CurrentValue or '???') end,
    })
end)

runFunction(function()
    local Reach = blatant:CreateToggle({
        Name = "Reach", CurrentValue = false, Flag = "reach", Callback = function() end
    })
    local ReachSlider = blatant:CreateSlider({
        Name = "Reach Range", Range = {3, 100}, Increment = 1, Suffix = "%",
        CurrentValue = 15, Flag = "reach_range", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.ball then
            local spinner = lplr.ball:FindFirstChild('spinner')
            if spinner then
                spinner.UpperLimit = Reach.CurrentValue and ReachSlider.CurrentValue or 6.400000095367432
            end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local NoHammerPull = blatant:CreateToggle({
        Name = "NoHammerPull", CurrentValue = false, Flag = "no_hammer_pull", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.ball then
            local spinner = lplr.ball:FindFirstChild('spinner')
            if spinner then
                spinner.LowerLimit = NoHammerPull.CurrentValue and spinner.UpperLimit or 0.6
            end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local Weightless = blatant:CreateToggle({
        Name = "Weightless", CurrentValue = false, Flag = "weightless", Callback = function() end
    })
    local WeightlessSlider = blatant:CreateSlider({
        Name = "Weight Lightness", Range = {1, 200}, Increment = 1, Suffix = "",
        CurrentValue = 70, Flag = "weightless_lightness", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.ball then
            local spinner = lplr.ball:FindFirstChild('spinner')
            if spinner then
                spinner.Speed = Weightless.CurrentValue and WeightlessSlider.CurrentValue or 20
            end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local HammerOnly = blatant:CreateToggle({
        Name = "HammerOnly", CurrentValue = false, Flag = "hammer_only",
        Callback = function(val)
            if not val and lplr.ball then
                lplr.ball.Transparency = 0
                lplr.ball.CanCollide = true
            end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if not HammerOnly.CurrentValue then return end
        if lplr.ball then
            lplr.ball.Transparency = 1
            lplr.ball.CanCollide = false
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local saved = {}
    local initialized = false
    local NoCollision = blatant:CreateToggle({
        Name = "NoCollision", CurrentValue = false, Flag = "no_collision",
        Callback = function(val)
            if not initialized then
                initialized = true
                if not val then return end
            end
            local special = workspace:FindFirstChild('map') and workspace.map:FindFirstChild('special')
            if special then
                if val then
                    saved = {}
                    for _, obj in ipairs(special:GetDescendants()) do
                        if obj.Name:lower():find('collision') then
                            pcall(function()
                                saved[obj] = { transparency = obj.Transparency, canCollide = obj.CanCollide }
                                obj.Transparency = 1
                                obj.CanCollide = false
                            end)
                        end
                    end
                else
                    for obj, data in pairs(saved) do
                        pcall(function()
                            obj.Transparency = data.transparency
                            obj.CanCollide = data.canCollide
                        end)
                    end
                    saved = {}
                end
            end
        end
    })
end)

runFunction(function()
    blatant:CreateDivider()
    local savedProps = {}

    local getDefaultProps = function()
        local parts = {}
        if lplr.ball then table.insert(parts, lplr.ball) end
        if lplr.axe then
            table.insert(parts, lplr.axe)
            local handle = lplr.axe:FindFirstChild('handle')
            if handle then table.insert(parts, handle) end
        end
        for _, part in ipairs(parts) do
            pcall(function()
                if not savedProps[part] then
                    savedProps[part] = part.CurrentPhysicalProperties
                end
            end)
        end
    end

    local Slipperiness = blatant:CreateToggle({
        Name = "Slipperiness", CurrentValue = false, Flag = "slipperiness", Callback = function() end
    })
    local DensitySlider = blatant:CreateSlider({
        Name = "Density", Range = {0, 100}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.01, Flag = "slip_density", Callback = function() end
    })
    local FrictionSlider = blatant:CreateSlider({
        Name = "Friction", Range = {0, 100}, Increment = 0.01, Suffix = "",
        CurrentValue = 0, Flag = "slip_friction", Callback = function() end
    })
    local ElasticitySlider = blatant:CreateSlider({
        Name = "Elasticity", Range = {0, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.9999, Flag = "slip_elasticity", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        local parts = {}
        if lplr.ball then table.insert(parts, lplr.ball) end
        if lplr.axe then
            table.insert(parts, lplr.axe)
            local handle = lplr.axe:FindFirstChild('handle')
            if handle then table.insert(parts, handle) end
        end
        if Slipperiness.CurrentValue then
            getDefaultProps()
            for _, part in ipairs(parts) do
                pcall(function()
                    part.CustomPhysicalProperties = PhysicalProperties.new(
                        DensitySlider.CurrentValue, FrictionSlider.CurrentValue,
                        ElasticitySlider.CurrentValue, 0, 1
                    )
                end)
            end
        else
            for _, part in ipairs(parts) do
                pcall(function()
                    local s = savedProps[part]
                    if s then
                        part.CustomPhysicalProperties = PhysicalProperties.new(
                            s.Density, s.Friction, s.Elasticity, s.FrictionWeight, s.ElasticityWeight
                        )
                    end
                end)
            end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local mouse = lplrObject:GetMouse()
    local transparencyLoop = nil
    local trajectoryParts = {}
    local lastTapPos = nil
    local isMobile = userInputService.TouchEnabled

    local clearTrajectory = function()
        for _, p in ipairs(trajectoryParts) do p:Destroy() end
        trajectoryParts = {}
    end

    local get2DDistance = function()
        if not lplr.ball then return 0 end
        local screenPos, onScreen = lplr.camera:WorldToScreenPoint(lplr.ball.Position)
        if not onScreen then return 0 end
        if isMobile and lastTapPos then
            return (lastTapPos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
        end
        return (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
    end

    local getTapTarget = function()
        if isMobile and lastTapPos then
            local unitRay = lplr.camera:ScreenPointToRay(lastTapPos.X, lastTapPos.Y)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            local ignored = {}
            for _, plr in ipairs(playersService:GetPlayers()) do
                if plr.Character then table.insert(ignored, plr.Character) end
                local model = workspace.playerModels:FindFirstChild(plr.Name)
                if model then table.insert(ignored, model) end
            end
            params.FilterDescendantsInstances = ignored
            local ray = workspace:Raycast(unitRay.Origin, unitRay.Direction * 500, params)
            if ray then return ray.Position end
            return unitRay.Origin + unitRay.Direction * 50
        end
        return mouse.Hit.Position
    end

    local makeRaycastParams = function()
        local params = RaycastParams.new()
        local ignored = {}
        for _, plr in ipairs(playersService:GetPlayers()) do
            local model = workspace.playerModels:FindFirstChild(plr.Name)
            if model then table.insert(ignored, model) end
            if plr.Character then table.insert(ignored, plr.Character) end
        end
        if lplr.model then table.insert(ignored, lplr.model) end
        params.FilterDescendantsInstances = ignored
        params.FilterType = Enum.RaycastFilterType.Exclude
        return params
    end

    local updateTrajectory = function(color)
        if not lplr.ball then clearTrajectory() return end
        local dist2D = get2DDistance()
        local speed = math.clamp(dist2D / 20, 3, 25)
        local target = getTapTarget()
        local direction = (target - lplr.ball.Position).Unit
        local velocity = direction * speed + Vector3.new(0, speed * 0.6, 0)
        local pos = lplr.ball.Position
        local vel = velocity
        local gravity = Vector3.new(0, -workspace.Gravity, 0)
        local dt = 0.06
        local params = makeRaycastParams()
        local points = {}
        for _ = 1, 40 do
            vel = vel + gravity * dt
            pos = pos + vel * dt
            table.insert(points, pos)
            local ray = workspace:Raycast(pos, vel * dt * 2, params)
            if ray then table.insert(points, ray.Position) break end
        end
        local needed = #points - 1
        while #trajectoryParts < needed do
            local p = Instance.new('Part')
            p.Anchored = true
            p.CanCollide = false
            p.CastShadow = false
            p.Material = Enum.Material.Neon
            p.Parent = workspace
            table.insert(trajectoryParts, p)
        end
        while #trajectoryParts > needed do
            trajectoryParts[#trajectoryParts]:Destroy()
            table.remove(trajectoryParts, #trajectoryParts)
        end
        for i = 1, needed do
            local a = points[i]
            local b = points[i + 1]
            local mid = (a + b) / 2
            local len = (b - a).Magnitude
            local t = i / needed
            local p = trajectoryParts[i]
            p.Size = Vector3.new(0.08, 0.08, len)
            p.CFrame = CFrame.lookAt(mid, b)
            p.Color = color
            p.Transparency = t * 0.6
        end
    end

    local isOnGround = function()
        if lplr.ball then
            local touching = lplr.ball:GetTouchingParts()
            for _, part in ipairs(touching) do
                local isAxe = lplr.axe and (part == lplr.axe or part == lplr.axe:FindFirstChild('handle'))
                local isInd = workspace:FindFirstChild('ind') and part == workspace.ind
                local isBall = part == lplr.ball
                local isTransparent = part.Transparency == 1
                local isPlayer = false
                for _, plr in ipairs(playersService:GetPlayers()) do
                    if part:IsDescendantOf(plr.Character or Instance.new('Folder')) then isPlayer = true break end
                    if workspace.playerModels:FindFirstChild(plr.Name) and part:IsDescendantOf(workspace.playerModels:FindFirstChild(plr.Name)) then isPlayer = true break end
                end
                if not isAxe and not isInd and not isBall and not isTransparent and not isPlayer then
                    return true
                end
            end
        end
        return false
    end

    local ShowProjectile = blatant:CreateToggle({
        Name = "Show Pogo Projectile", CurrentValue = true, Flag = "pogo_projectile",
        Callback = function(val) if not val then clearTrajectory() end end
    })
    local ProjectileModeDropdown = blatant:CreateDropdown({
        Name = "Projectile Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "pogo_projectile_mode", Callback = function() end
    })
    local ProjectileColorPicker = blatant:CreateColorPicker({
        Name = "Projectile Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "pogo_projectile_color", Callback = function() end
    })

    local Pogo = blatant:CreateToggle({
        Name = "Pogo (Space)", CurrentValue = false, Flag = "pogo",
        Callback = function(val)
            if val then
                transparencyLoop = cleanup.add(runService.RenderStepped:Connect(function()
                    if lplr.axe and lplr.axe.Parent ~= coreGui then lplr.axe.Parent = coreGui end
                    if lplr.model then
                        local strayAxe = lplr.model:FindFirstChild('axe')
                        if strayAxe then strayAxe.Parent = coreGui end
                    end
                    if lplr.ball then lplr.ball.Transparency = 0 end
                    if lplr.visuals then
                        local hat = lplr.visuals:FindFirstChild('Hat')
                        if hat then
                            local hatHandle = hat:FindFirstChild('Handle')
                            if hatHandle then hatHandle.Transparency = 0 end
                        end
                    end
                    if ShowProjectile.CurrentValue then
                        local color = ProjectileModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or ProjectileColorPicker.Color
                        updateTrajectory(color)
                    else
                        clearTrajectory()
                    end
                end))
            else
                clearTrajectory()
                if transparencyLoop then transparencyLoop:Disconnect() transparencyLoop = nil end
                if lplr.axe and lplr.model then lplr.axe.Parent = lplr.model end
                for _, obj in ipairs(coreGui:GetChildren()) do
                    if obj.Name == 'axe' then obj.Parent = lplr.model or nil end
                end
                if lplr.visuals then
                    local hat = lplr.visuals:FindFirstChild('Hat')
                    if hat then
                        local hatHandle = hat:FindFirstChild('Handle')
                        if hatHandle then hatHandle.Transparency = 0 end
                    end
                end
            end
        end
    })

    if isMobile then
        cleanup.add(userInputService.TouchTap:Connect(function(touches, gpe)
            if gpe or not Pogo.CurrentValue then return end
            if touches[1] then lastTapPos = touches[1].Position end
        end))
        cleanup.add(userInputService.TouchStarted:Connect(function(touch, gpe)
            if gpe or not Pogo.CurrentValue then return end
            lastTapPos = touch.Position
            if isOnGround() and lplr.ball then
                local dist2D = get2DDistance()
                local speed = math.clamp(dist2D / 20, 3, 25)
                local target = getTapTarget()
                local direction = (target - lplr.ball.Position).Unit
                local bv = Instance.new('BodyVelocity')
                bv.Velocity = direction * speed + Vector3.new(0, speed * 0.6, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = math.huge
                bv.Parent = lplr.ball
                task.delay(0.15, function() bv:Destroy() end)
            end
        end))
    else
        cleanup.add(userInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode.Space and Pogo.CurrentValue and isOnGround() and lplr.ball then
                local dist2D = get2DDistance()
                local speed = math.clamp(dist2D / 20, 3, 25)
                local target = mouse.Hit.Position
                local direction = (target - lplr.ball.Position).Unit
                local bv = Instance.new('BodyVelocity')
                bv.Velocity = direction * speed + Vector3.new(0, speed * 0.6, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = math.huge
                bv.Parent = lplr.ball
                task.delay(0.15, function() bv:Destroy() end)
            end
        end))
    end
end)

runFunction(function()
    local oldColor = nil
    local oldMaterial = nil

    local BallToggle = render:CreateToggle({
        Name = "Ball Color", CurrentValue = false, Flag = "rainbow_ball",
        Callback = function(val)
            if not val and lplr.ball then
                if oldColor then lplr.ball.Color = oldColor end
                if oldMaterial then lplr.ball.Material = oldMaterial end
                oldColor = nil
                oldMaterial = nil
            end
        end
    })
    local BallModeDropdown = render:CreateDropdown({
        Name = "Ball Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "ball_color_mode", Callback = function() end
    })
    local BallColorPicker = render:CreateColorPicker({
        Name = "Ball Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "ball_color_picker", Callback = function() end
    })
    local BallMaterialDropdown = render:CreateDropdown({
        Name = "Ball Material",
        Options = {
            'Plastic','SmoothPlastic','Neon','Metal','Wood','WoodPlanks','Marble','Granite',
            'Brick','Cobblestone','Concrete','CorrodedMetal','DiamondPlate','Foil','Grass',
            'Ice','Pebble','Sand','Fabric','Glass','ForceField','Slate','Sandstone','Basalt',
            'Glacier','Ground','LeafyGrass','Limestone','Mud','Pavement','Rock','Salt',
            'Snow','Asphalt','CrackedLava'
        },
        CurrentOption = {'Plastic'}, Flag = "ball_material", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if not lplr.ball then return end
        if BallToggle.CurrentValue then
            if not oldColor then
                oldColor = lplr.ball.Color
                oldMaterial = lplr.ball.Material
            end
            lplr.ball.Color = BallModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or BallColorPicker.Color
            lplr.ball.Material = Enum.Material[BallMaterialDropdown.CurrentOption[1]]
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local oldTipColor = nil
    local oldHandleColor = nil
    local oldTipMaterial = nil
    local oldHandleMaterial = nil

    local AxeToggle = render:CreateToggle({
        Name = "Axe Color", CurrentValue = false, Flag = "rainbow_axe",
        Callback = function(val)
            if not val and lplr.axe then
                if oldTipColor then lplr.axe.Color = oldTipColor end
                if oldTipMaterial then lplr.axe.Material = oldTipMaterial end
                local handle = lplr.axe:FindFirstChild('handle')
                if handle then
                    if oldHandleColor then handle.Color = oldHandleColor end
                    if oldHandleMaterial then handle.Material = oldHandleMaterial end
                end
                oldTipColor = nil
                oldHandleColor = nil
                oldTipMaterial = nil
                oldHandleMaterial = nil
            end
        end
    })
    local AxeTipModeDropdown = render:CreateDropdown({
        Name = "Axe Tip Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "axe_tip_mode", Callback = function() end
    })
    local AxeTipColorPicker = render:CreateColorPicker({
        Name = "Axe Tip Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "axe_tip_color_picker", Callback = function() end
    })
    local AxeTipMaterialDropdown = render:CreateDropdown({
        Name = "Axe Tip Material",
        Options = {
            'Plastic','SmoothPlastic','Neon','Metal','Wood','WoodPlanks','Marble','Granite',
            'Brick','Cobblestone','Concrete','CorrodedMetal','DiamondPlate','Foil','Grass',
            'Ice','Pebble','Sand','Fabric','Glass','ForceField','Slate','Sandstone','Basalt',
            'Glacier','Ground','LeafyGrass','Limestone','Mud','Pavement','Rock','Salt',
            'Snow','Asphalt','CrackedLava'
        },
        CurrentOption = {'Plastic'}, Flag = "axe_tip_material", Callback = function() end
    })
    local AxeHandleModeDropdown = render:CreateDropdown({
        Name = "Axe Handle Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "axe_handle_mode", Callback = function() end
    })
    local AxeHandleColorPicker = render:CreateColorPicker({
        Name = "Axe Handle Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "axe_handle_color_picker", Callback = function() end
    })
    local AxeHandleMaterialDropdown = render:CreateDropdown({
        Name = "Axe Handle Material",
        Options = {
            'Plastic','SmoothPlastic','Neon','Metal','Wood','WoodPlanks','Marble','Granite',
            'Brick','Cobblestone','Concrete','CorrodedMetal','DiamondPlate','Foil','Grass',
            'Ice','Pebble','Sand','Fabric','Glass','ForceField','Slate','Sandstone','Basalt',
            'Glacier','Ground','LeafyGrass','Limestone','Mud','Pavement','Rock','Salt',
            'Snow','Asphalt','CrackedLava'
        },
        CurrentOption = {'Plastic'}, Flag = "axe_handle_material", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if not lplr.axe then return end
        if AxeToggle.CurrentValue then
            if not oldTipColor then
                oldTipColor = lplr.axe.Color
                oldTipMaterial = lplr.axe.Material
                local handle = lplr.axe:FindFirstChild('handle')
                if handle then
                    oldHandleColor = handle.Color
                    oldHandleMaterial = handle.Material
                end
            end
            lplr.axe.Color = AxeTipModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or AxeTipColorPicker.Color
            lplr.axe.Material = Enum.Material[AxeTipMaterialDropdown.CurrentOption[1]]
            local handle = lplr.axe:FindFirstChild('handle')
            if handle then
                handle.Color = AxeHandleModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or AxeHandleColorPicker.Color
                handle.Material = Enum.Material[AxeHandleMaterialDropdown.CurrentOption[1]]
            end
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local defaultTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0)
    })
    local invisibleTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 1)
    })
    local NoDebris = render:CreateToggle({
        Name = "NoDebris", CurrentValue = false, Flag = "no_debris",
        Callback = function(val)
            if lplr.axe then
                local particles = lplr.axe:FindFirstChild('Particles')
                if particles then
                    particles.Transparency = val and invisibleTransparency or defaultTransparency
                end
            end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.axe then
            local particles = lplr.axe:FindFirstChild('Particles')
            if particles then
                particles.Transparency = NoDebris.CurrentValue and invisibleTransparency or defaultTransparency
            end
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local NoIndicator = render:CreateToggle({
        Name = "NoIndicator", CurrentValue = false, Flag = "no_indicator",
        Callback = function(val)
            local ind = workspace:FindFirstChild('ind')
            if ind then ind.Transparency = val and 1 or 0 end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        local ind = workspace:FindFirstChild('ind')
        if ind then
            ind.Transparency = NoIndicator.CurrentValue and 1 or 0
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local IndicatorToggle = render:CreateToggle({
        Name = "IndicatorColor", CurrentValue = false, Flag = "indicator_color",
        Callback = function(val)
            if not val then
                local ind = workspace:FindFirstChild('ind')
                if ind then
                    ind.Color = Color3.fromRGB(255, 0, 255)
                    local highlight = ind:FindFirstChild('Highlight')
                    if highlight then highlight.FillColor = Color3.fromRGB(255, 0, 255) end
                end
            end
        end
    })
    local IndicatorModeDropdown = render:CreateDropdown({
        Name = "Indicator Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "indicator_color_mode", Callback = function() end
    })
    local IndicatorColorPicker = render:CreateColorPicker({
        Name = "Indicator Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "indicator_color_picker", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        local ind = workspace:FindFirstChild('ind')
        if ind and IndicatorToggle.CurrentValue then
            local color = IndicatorModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or IndicatorColorPicker.Color
            ind.Color = color
            local highlight = ind:FindFirstChild('Highlight')
            if highlight then highlight.FillColor = color end
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local FOVModifier = render:CreateToggle({
        Name = "FOVModifier", CurrentValue = false, Flag = "fov_modifier",
        Callback = function(val)
            if not val then lplr.camera.FieldOfView = 70 end
        end
    })
    local FOVSlider = render:CreateSlider({
        Name = "FOV Value", Range = {30, 120}, Increment = 1, Suffix = "%",
        CurrentValue = 90, Flag = "fov_value", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if sharedState.spectating then return end
        if FOVModifier.CurrentValue then
            lplr.camera.FieldOfView = FOVSlider.CurrentValue
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local CameraZoom = render:CreateToggle({
        Name = "CameraZoom", CurrentValue = false, Flag = "camera_zoom",
        Callback = function(val)
            if not val then
                local shakeCF = workspace.CurrentCamera:FindFirstChild('shakeCF')
                if shakeCF then
                    shakeCF.Value = CFrame.new(shakeCF.Value.Position.X, shakeCF.Value.Position.Y, 0)
                end
            end
        end
    })
    local CameraZoomSlider = render:CreateSlider({
        Name = "Camera Zoom Value", Range = {0, 100}, Increment = 0.01, Suffix = "",
        CurrentValue = 5.1, Flag = "camera_zoom_value", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if not CameraZoom.CurrentValue then return end
        local shakeCF = workspace.CurrentCamera:FindFirstChild('shakeCF')
        if not shakeCF then return end
        shakeCF.Value = CFrame.new(shakeCF.Value.Position.X, shakeCF.Value.Position.Y, CameraZoomSlider.CurrentValue)
    end))
end)

runFunction(function()
    local velocity = Vector3.new(0, 0, 0)
    local targetVelocity = Vector3.new(0, 0, 0)
    local mobileMove = Vector3.new(0, 0, 0)

    local Fly = tools:CreateToggle({
        Name = "Fly", CurrentValue = false, Flag = "fly",
        Callback = function(val)
            if lplr.ball then lplr.ball.Anchored = val end
            if not val then
                velocity = Vector3.new(0, 0, 0)
                targetVelocity = Vector3.new(0, 0, 0)
                mobileMove = Vector3.new(0, 0, 0)
                if lplr.ball then lplr.ball.Anchored = false end
            end
        end
    })
    local FlySpeedSlider = tools:CreateSlider({
        Name = "Fly Speed", Range = {1, 50}, Increment = 1, Suffix = "",
        CurrentValue = 10, Flag = "fly_speed", Callback = function() end
    })

    if userInputService.TouchEnabled then
        cleanup.add(userInputService.TouchMoved:Connect(function(touch, gpe)
            if not Fly.CurrentValue then return end
            local delta = touch.Delta
            mobileMove = Vector3.new(delta.X, -delta.Y, 0).Unit * (delta.Magnitude > 1 and 1 or 0)
        end))
        cleanup.add(userInputService.TouchEnded:Connect(function()
            mobileMove = Vector3.new(0, 0, 0)
        end))
    end

    cleanup.add(runService.RenderStepped:Connect(function(dt)
        if not Fly.CurrentValue then return end
        if not lplr.model or not lplr.ball then return end
        lplr.ball.Anchored = true
        local speed = FlySpeedSlider.CurrentValue
        local moveX = 0
        local moveY = 0
        if userInputService.TouchEnabled then
            moveX = mobileMove.X * speed
            moveY = mobileMove.Y * speed
        else
            local up = userInputService:IsKeyDown(Enum.KeyCode.W) or userInputService:IsKeyDown(Enum.KeyCode.Up)
            local down = userInputService:IsKeyDown(Enum.KeyCode.S) or userInputService:IsKeyDown(Enum.KeyCode.Down)
            local left = userInputService:IsKeyDown(Enum.KeyCode.A) or userInputService:IsKeyDown(Enum.KeyCode.Left)
            local right = userInputService:IsKeyDown(Enum.KeyCode.D) or userInputService:IsKeyDown(Enum.KeyCode.Right)
            if up then moveY = speed end
            if down then moveY = -speed end
            if left then moveX = -speed end
            if right then moveX = speed end
        end
        targetVelocity = Vector3.new(moveX, moveY, 0)
        velocity = velocity:Lerp(targetVelocity, dt * 8)
        if velocity.Magnitude > 0.01 then
            lplr.model:PivotTo(lplr.model:GetPivot() + velocity * dt)
        end
    end))
end)

runFunction(function()
    tools:CreateDivider()
    local check = false
    local HandleFocus = tools:CreateToggle({
        Name = "HandleFocus", CurrentValue = false, Flag = "handle_focus",
        Callback = function(val)
            if not val then
                lplr.camera.CameraSubject = lplr.ball
                check = false
            end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if HandleFocus.CurrentValue and lplr.axe then
            lplr.camera.CameraSubject = lplr.axe
            check = true
        else
            if check then
                lplr.camera.CameraSubject = lplr.ball
                check = false
            end
        end
    end))
end)

runFunction(function()
    tools:CreateDivider()
    local HandleCollide = tools:CreateToggle({
        Name = "HandleCollide", CurrentValue = false, Flag = "handle_collide",
        Callback = function(val)
            if lplr.axe then
                local handle = lplr.axe:FindFirstChild('handle')
                if handle then handle.CanCollide = val end
            end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.axe then
            local handle = lplr.axe:FindFirstChild('handle')
            if handle then handle.CanCollide = HandleCollide.CurrentValue end
        end
    end))
end)

runFunction(function()
    tools:CreateDivider()
    local NoHitSound = tools:CreateToggle({
        Name = "NoHitSound", CurrentValue = false, Flag = "no_hit_sound",
        Callback = function(val)
            if lplr.axe then
                local hitSounds = lplr.axe:FindFirstChild('hitSounds')
                if hitSounds then
                    local highStone = hitSounds:FindFirstChild('highStone')
                    local lowStone = hitSounds:FindFirstChild('lowStoneVariable')
                    if highStone then highStone.Volume = val and 0 or 0.5 end
                    if lowStone then lowStone.Volume = val and 0 or 2 end
                end
            end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.axe then
            local hitSounds = lplr.axe:FindFirstChild('hitSounds')
            if hitSounds then
                local highStone = hitSounds:FindFirstChild('highStone')
                local lowStone = hitSounds:FindFirstChild('lowStoneVariable')
                if highStone then highStone.Volume = NoHitSound.CurrentValue and 0 or 0.5 end
                if lowStone then lowStone.Volume = NoHitSound.CurrentValue and 0 or 2 end
            end
        end
    end))
end)

runFunction(function()
    local GravityModifier = world:CreateToggle({
        Name = "GravityModifier", CurrentValue = false, Flag = "gravity_modifier",
        Callback = function(val)
            if not val then workspace.Gravity = 50 end
        end
    })
    local GravitySlider = world:CreateSlider({
        Name = "Gravity Value", Range = {5, 150}, Increment = 0.1, Suffix = "%",
        CurrentValue = 30, Flag = "gravity_value", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if GravityModifier.CurrentValue then
            workspace.Gravity = GravitySlider.CurrentValue
        end
    end))
end)

runFunction(function()
    world:CreateDivider()
    local TimeChanger = world:CreateToggle({
        Name = "TimeChanger", CurrentValue = false, Flag = "time_changer",
        Callback = function(val)
            if not val then lighting.ClockTime = 14 end
        end
    })
    local TimeSlider = world:CreateSlider({
        Name = "Clock Time", Range = {0, 24}, Increment = 0.1, Suffix = "",
        CurrentValue = 14, Flag = "time_changer_value", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if TimeChanger.CurrentValue then
            lighting.ClockTime = TimeSlider.CurrentValue
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local trail = nil
    local attach0 = nil
    local attach1 = nil

    local removeTrail = function()
        if trail then trail:Destroy() trail = nil end
        if attach0 then attach0:Destroy() attach0 = nil end
        if attach1 then attach1:Destroy() attach1 = nil end
    end

    local HammerTrail = render:CreateToggle({
        Name = "HammerTrail", CurrentValue = false, Flag = "hammer_trail",
        Callback = function(val)
            if not val then removeTrail() end
        end
    })
    local TrailModeDropdown = render:CreateDropdown({
        Name = "Trail Color Mode", Options = {'Rainbow', 'Color Picker', 'Ball Color'},
        CurrentOption = {'Rainbow'}, Flag = "trail_color_mode", Callback = function() end
    })
    local TrailColorPicker = render:CreateColorPicker({
        Name = "Trail Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "trail_color_picker", Callback = function() end
    })
    local TrailShapeDropdown = render:CreateDropdown({
        Name = "Trail Shape", Options = {'Triangle', 'Square'},
        CurrentOption = {'Triangle'}, Flag = "trail_shape", Callback = function() end
    })
    local TrailThicknessSlider = render:CreateSlider({
        Name = "Trail Thickness", Range = {0, 3}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "trail_thickness", Callback = function() end
    })
    local TrailLifetimeSlider = render:CreateSlider({
        Name = "Trail Length", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "trail_lifetime", Callback = function() end
    })

    local makeTrail = function()
        if not lplr.axe then return end
        removeTrail()
        attach0 = Instance.new('Attachment')
        attach0.Position = Vector3.new(0, TrailThicknessSlider.CurrentValue / 2, 0)
        attach0.Parent = lplr.axe
        attach1 = Instance.new('Attachment')
        attach1.Position = Vector3.new(0, -TrailThicknessSlider.CurrentValue / 2, 0)
        attach1.Parent = lplr.axe
        trail = Instance.new('Trail')
        trail.Attachment0 = attach0
        trail.Attachment1 = attach1
        trail.Lifetime = TrailLifetimeSlider.CurrentValue
        trail.MinLength = 0
        trail.FaceCamera = true
        trail.LightEmission = 1
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        trail.Parent = lplr.axe
    end

    cleanup.add(runService.RenderStepped:Connect(function()
        if not HammerTrail.CurrentValue then return end
        if not lplr.axe then removeTrail() return end
        if not trail then makeTrail() return end
        local mode = TrailModeDropdown.CurrentOption[1]
        local color = mode == 'Rainbow' and returnRainbow()
            or mode == 'Ball Color' and (lplr.ball and lplr.ball.Color or Color3.new(1,1,1))
            or TrailColorPicker.Color
        trail.Color = ColorSequence.new(color)
        trail.Lifetime = TrailLifetimeSlider.CurrentValue
        trail.WidthScale = TrailShapeDropdown.CurrentOption[1] == 'Triangle'
            and NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
            or NumberSequence.new(1)
        if attach0 then attach0.Position = Vector3.new(0, TrailThicknessSlider.CurrentValue / 2, 0) end
        if attach1 then attach1.Position = Vector3.new(0, -TrailThicknessSlider.CurrentValue / 2, 0) end
    end))
end)

runFunction(function()
    render:CreateDivider()

    local defaultTexture = 'rbxassetid://377156649'
    local defaultSize = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15, 0.15),
        NumberSequenceKeypoint.new(0.904, 0.07, 0.07),
        NumberSequenceKeypoint.new(1, 0, 0)
    })
    local defaultTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    local visibleTransparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(1, 0)
    })

    local DebrisTexture = render:CreateToggle({
        Name = "DebrisTexture", CurrentValue = false, Flag = "debris_texture",
        Callback = function(val)
            if lplr.axe then
                local particles = lplr.axe:FindFirstChild('Particles')
                if particles then
                    if val then
                        particles.Transparency = visibleTransparency
                        particles.Brightness = 5
                        particles.LightEmission = 0.20000000298023224
                    else
                        particles.Texture = defaultTexture
                        particles.Transparency = defaultTransparency
                        particles.Size = defaultSize
                        particles.Brightness = 1
                        particles.LightEmission = 0.4
                    end
                end
            end
        end
    })

    local TextureInput = render:CreateInput({
        Name = "Texture ID", PlaceholderText = "rbxassetid://377156649 or file path",
        RemoveTextAfterFocusLost = false, Flag = "debris_texture_id",
        Callback = function(val)
            if not DebrisTexture.CurrentValue then return end
            if lplr.axe then
                local particles = lplr.axe:FindFirstChild('Particles')
                if particles then
                    local suc, asset = pcall(function()
                        return val:find('rbxassetid://') and val or getcustomasset(val)
                    end)
                    if suc then particles.Texture = asset end
                end
            end
        end
    })

    local SizeSlider = render:CreateSlider({
        Name = "Debris Size", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.15, Flag = "debris_size", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not DebrisTexture.CurrentValue then return end
        if lplr.axe then
            local particles = lplr.axe:FindFirstChild('Particles')
            if particles then
                local s = SizeSlider.CurrentValue
                particles.Transparency = visibleTransparency
                particles.Brightness = 5
                particles.LightEmission = 0.20000000298023224
                particles.Size = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, s, s),
                    NumberSequenceKeypoint.new(0.904, s * 0.467, s * 0.467),
                    NumberSequenceKeypoint.new(1, 0, 0)
                })
            end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local history = {}
    local maxHistory = 300
    local backtracking = false

    local getLastGroundedEntry = function()
        for i = #history, 1, -1 do
            if history[i].grounded then return history[i] end
        end
        return nil
    end

    local Backtrack = blatant:CreateToggle({
        Name = "Backtrack", CurrentValue = false, Flag = "backtrack_toggle",
        Callback = function(val)
            if not val then
                history = {}
                backtracking = false
            end
        end
    })

    local BacktrackThreshold = blatant:CreateSlider({
        Name = "Fall Threshold", Range = {-100, -5}, Increment = 1, Suffix = "",
        CurrentValue = -20, Flag = "backtrack_threshold", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not Backtrack.CurrentValue then return end
        if backtracking then return end
        if not lplr.ball then return end

        local vel = lplr.ball.AssemblyLinearVelocity
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignored = {}
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr.Character then table.insert(ignored, plr.Character) end
            local model = workspace.playerModels:FindFirstChild(plr.Name)
            if model then table.insert(ignored, model) end
        end
        params.FilterDescendantsInstances = ignored

        local ballRay = workspace:Raycast(lplr.ball.Position, Vector3.new(0, -2, 0), params)
        local isGrounded = ballRay ~= nil

        table.insert(history, {
            ballPos = lplr.ball.Position,
            axePos = lplr.axe and lplr.axe.Position or nil,
            grounded = isGrounded
        })
        if #history > maxHistory then table.remove(history, 1) end

        if vel.Y < BacktrackThreshold.CurrentValue then
            local entry = getLastGroundedEntry()
            if not entry then return end
            backtracking = true
            task.spawn(function()
                lplr.ball.CFrame = CFrame.new(entry.ballPos)
                if lplr.axe and entry.axePos then
                    lplr.axe.CFrame = CFrame.new(entry.axePos)
                end
                local bv = Instance.new('BodyVelocity')
                bv.Velocity = Vector3.new(0, 0, 0)
                bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bv.P = math.huge
                bv.Parent = lplr.ball
                task.delay(0.1, function() bv:Destroy() end)
                task.wait(0.5)
                backtracking = false
                history = {}
            end)
        end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local trail = nil
    local attach0 = nil
    local attach1 = nil

    local removeTrail = function()
        if trail then trail:Destroy() trail = nil end
        if attach0 then attach0:Destroy() attach0 = nil end
        if attach1 then attach1:Destroy() attach1 = nil end
    end

    local BallTrail = render:CreateToggle({
        Name = "BallTrail", CurrentValue = false, Flag = "ball_trail",
        Callback = function(val)
            if not val then removeTrail() end
        end
    })
    local BallTrailModeDropdown = render:CreateDropdown({
        Name = "Ball Trail Color Mode", Options = {'Rainbow', 'Color Picker', 'Ball Color'},
        CurrentOption = {'Rainbow'}, Flag = "ball_trail_color_mode", Callback = function() end
    })
    local BallTrailColorPicker = render:CreateColorPicker({
        Name = "Ball Trail Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "ball_trail_color_picker", Callback = function() end
    })
    local BallTrailShapeDropdown = render:CreateDropdown({
        Name = "Ball Trail Shape", Options = {'Triangle', 'Square'},
        CurrentOption = {'Triangle'}, Flag = "ball_trail_shape", Callback = function() end
    })
    local BallTrailThicknessSlider = render:CreateSlider({
        Name = "Ball Trail Thickness", Range = {0, 3}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "ball_trail_thickness", Callback = function() end
    })
    local BallTrailLifetimeSlider = render:CreateSlider({
        Name = "Ball Trail Length", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "ball_trail_lifetime", Callback = function() end
    })

    local makeTrail = function()
        if not lplr.ball then return end
        removeTrail()
        attach0 = Instance.new('Attachment')
        attach0.Position = Vector3.new(0, BallTrailThicknessSlider.CurrentValue / 2, 0)
        attach0.Parent = lplr.ball
        attach1 = Instance.new('Attachment')
        attach1.Position = Vector3.new(0, -BallTrailThicknessSlider.CurrentValue / 2, 0)
        attach1.Parent = lplr.ball
        trail = Instance.new('Trail')
        trail.Attachment0 = attach0
        trail.Attachment1 = attach1
        trail.Lifetime = BallTrailLifetimeSlider.CurrentValue
        trail.MinLength = 0
        trail.FaceCamera = true
        trail.LightEmission = 1
        trail.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        trail.Parent = lplr.ball
    end

    cleanup.add(runService.RenderStepped:Connect(function()
        if not BallTrail.CurrentValue then removeTrail() return end
        if not lplr.ball then removeTrail() return end
        if not trail then makeTrail() return end
        local mode = BallTrailModeDropdown.CurrentOption[1]
        local color = mode == 'Rainbow' and returnRainbow()
            or mode == 'Ball Color' and (lplr.ball and lplr.ball.Color or Color3.new(1,1,1))
            or BallTrailColorPicker.Color
        trail.Color = ColorSequence.new(color)
        trail.Lifetime = BallTrailLifetimeSlider.CurrentValue
        trail.WidthScale = BallTrailShapeDropdown.CurrentOption[1] == 'Triangle'
            and NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
            or NumberSequence.new(1)
        if attach0 then attach0.Position = Vector3.new(0, BallTrailThicknessSlider.CurrentValue / 2, 0) end
        if attach1 then attach1.Position = Vector3.new(0, -BallTrailThicknessSlider.CurrentValue / 2, 0) end
    end))
end)

runFunction(function()
    world:CreateDivider()
    local sky = nil

    local SkyboxChanger = world:CreateToggle({
        Name = "SkyboxChanger", CurrentValue = false, Flag = "skybox_changer",
        Callback = function(val)
            if val then
                sky = Instance.new('Sky')
                sky.Parent = lighting
            else
                if sky then sky:Destroy() sky = nil end
            end
        end
    })

    local faces = {'SkyboxBk','SkyboxDn','SkyboxFt','SkyboxLf','SkyboxRt','SkyboxUp'}
    for _, face in ipairs(faces) do
        world:CreateInput({
            Name = face, PlaceholderText = "rbxassetid://...",
            RemoveTextAfterFocusLost = false, Flag = "skybox_"..face:lower(),
            Callback = function(val)
                if sky and val ~= '' then pcall(function() sky[face] = val end) end
            end
        })
    end
end)

runFunction(function()
    tools:CreateDivider()
    local savedTransparencies = {}

    local HideOthers = tools:CreateToggle({
        Name = "HideOthers", CurrentValue = false, Flag = "hide_others",
        Callback = function(val)
            if not val then
                for obj, t in pairs(savedTransparencies) do
                    pcall(function() obj.Transparency = t end)
                end
                savedTransparencies = {}
            end
        end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not HideOthers.CurrentValue then return end
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr == lplrObject then continue end
            local model = workspace.playerModels:FindFirstChild(plr.Name)
            if not model then continue end
            local ball = model:FindFirstChild('ball')
            local axe = model:FindFirstChild('axe')
            if ball then
                if not savedTransparencies[ball] then savedTransparencies[ball] = ball.Transparency end
                ball.Transparency = 1
            end
            if axe then
                local particles = axe:FindFirstChild('Particles')
                if particles then
                    if not savedTransparencies[particles] then savedTransparencies[particles] = particles.Transparency end
                    pcall(function() particles.Transparency = NumberSequence.new(1) end)
                end
                if not savedTransparencies[axe] then savedTransparencies[axe] = axe.Transparency end
                axe.Transparency = 1
                local handle = axe:FindFirstChild('handle')
                if handle then
                    if not savedTransparencies[handle] then savedTransparencies[handle] = handle.Transparency end
                    handle.Transparency = 1
                end
            end
        end
    end))
end)

runFunction(function()
    render:CreateDivider()

    local defaultFont = Font.new('rbxasset://fonts/families/TitilliumWeb.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)

    local getTimer = function()
        local gui = lplrObject.PlayerGui:FindFirstChild('Timer')
        if not gui then return nil end
        local frame = gui:FindFirstChild('timer')
        if not frame then return nil end
        return frame:FindFirstChild('time')
    end

    local getTimerFrame = function()
        local gui = lplrObject.PlayerGui:FindFirstChild('Timer')
        if not gui then return nil end
        return gui:FindFirstChild('timer')
    end

    local uiScale = nil
    local uiCorner = nil
    local uiStroke = nil

    local TimerToggle = render:CreateToggle({
        Name = "CustomTimer", CurrentValue = false, Flag = "timer_color",
        Callback = function(val)
            if not val then
                local t = getTimer()
                if t then
                    t.TextColor3 = Color3.fromRGB(255, 255, 255)
                    t.TextScaled = true
                    t.FontFace = defaultFont
                end
                local frame = getTimerFrame()
                if frame then
                    frame.BackgroundTransparency = 0.30000001192092896
                end
                if uiScale then uiScale:Destroy() uiScale = nil end
                if uiCorner then uiCorner:Destroy() uiCorner = nil end
                if uiStroke then uiStroke:Destroy() uiStroke = nil end
            end
        end
    })
    local TimerColorModeDropdown = render:CreateDropdown({
        Name = "Timer Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "timer_color_mode", Callback = function() end
    })
    local TimerColorPicker = render:CreateColorPicker({
        Name = "Timer Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "timer_color_picker", Callback = function() end
    })
    local TimerFontDropdown = render:CreateDropdown({
        Name = "Timer Font",
        Options = {
            'Legacy','Arial','ArialBold','SourceSans','SourceSansBold','SourceSansSemibold',
            'SourceSansItalic','SourceSansLight','SourceSansExtraLight','Bodoni','Highway',
            'SciFi','Cartoon','Code','Fantasy','Antique','Gotham','GothamBold','GothamBlack',
            'GothamMedium','GothamLight','AmaticSC','Bangers','Creepster','DenkOne','Fondamento',
            'FredokaOne','GrenzeGotisch','IndieFlower','JosefinSans','Jura','KoHo','Kumbhsans',
            'Mali','NotoSans','Nunito','Oswald','PatrickHand','PermanentMarker','Roboto',
            'RobotoCondensed','RobotoMono','Sarpanch','SpecialElite','TitilliumWeb','Ubuntu'
        },
        CurrentOption = {'TitilliumWeb'}, Flag = "timer_font", Callback = function() end
    })
    local TimerBGTransparencySlider = render:CreateSlider({
        Name = "Background Transparency", Range = {0, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.3, Flag = "timer_bg_transparency", Callback = function() end
    })
    local TimerCornerToggle = render:CreateToggle({
        Name = "Corner Radius", CurrentValue = false, Flag = "timer_corner",
        Callback = function(val)
            if not val then if uiCorner then uiCorner:Destroy() uiCorner = nil end end
        end
    })
    local TimerCornerSlider = render:CreateSlider({
        Name = "Corner Radius Value", Range = {0, 50}, Increment = 1, Suffix = "",
        CurrentValue = 8, Flag = "timer_corner_value", Callback = function() end
    })
    local TimerStrokeToggle = render:CreateToggle({
        Name = "Border Stroke", CurrentValue = false, Flag = "timer_uistroke",
        Callback = function(val)
            if not val then if uiStroke then uiStroke:Destroy() uiStroke = nil end end
        end
    })
    local TimerStrokeModeDropdown = render:CreateDropdown({
        Name = "Stroke Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Color Picker'}, Flag = "timer_uistroke_mode", Callback = function() end
    })
    local TimerStrokeColorPicker = render:CreateColorPicker({
        Name = "Stroke Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "timer_uistroke_color", Callback = function() end
    })
    local TimerStrokeThicknessSlider = render:CreateSlider({
        Name = "Stroke Thickness", Range = {1, 10}, Increment = 0.1, Suffix = "",
        CurrentValue = 2, Flag = "timer_uistroke_thickness", Callback = function() end
    })
    local TimerScaleToggle = render:CreateToggle({
        Name = "TimerScale", CurrentValue = false, Flag = "timer_scale",
        Callback = function(val)
            if not val then if uiScale then uiScale:Destroy() uiScale = nil end end
        end
    })
    local TimerScaleSlider = render:CreateSlider({
        Name = "Timer Scale", Range = {0.1, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "timer_scale_value", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not TimerToggle.CurrentValue then return end
        local t = getTimer()
        local frame = getTimerFrame()
        if not frame then return end

        if t then
            local color = TimerColorModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or TimerColorPicker.Color
            t.TextColor3 = color
            t.TextScaled = true
            pcall(function()
                t.FontFace = Font.fromEnum(Enum.Font[TimerFontDropdown.CurrentOption[1]])
            end)
        end

        frame.BackgroundTransparency = TimerBGTransparencySlider.CurrentValue

        if uiCorner and not uiCorner.Parent then uiCorner = nil end
        if uiStroke and not uiStroke.Parent then uiStroke = nil end
        if uiScale and not uiScale.Parent then uiScale = nil end

        if TimerCornerToggle.CurrentValue then
            if not uiCorner then
                uiCorner = frame:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
                uiCorner.Parent = frame
            end
            uiCorner.CornerRadius = UDim.new(0, TimerCornerSlider.CurrentValue)
        else
            if uiCorner then uiCorner:Destroy() uiCorner = nil end
        end

        if TimerStrokeToggle.CurrentValue then
            if not uiStroke then
                uiStroke = Instance.new('UIStroke')
                uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                uiStroke.Parent = frame
            end
            uiStroke.Color = TimerStrokeModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or TimerStrokeColorPicker.Color
            uiStroke.Thickness = TimerStrokeThicknessSlider.CurrentValue
        else
            if uiStroke then uiStroke:Destroy() uiStroke = nil end
        end

        if TimerScaleToggle.CurrentValue then
            if not uiScale then
                uiScale = Instance.new('UIScale')
                uiScale.Parent = frame
            end
            uiScale.Scale = TimerScaleSlider.CurrentValue
        else
            if uiScale then uiScale:Destroy() uiScale = nil end
        end
    end))
end)

runFunction(function()
    tools:CreateDivider()
    local walking = false
    local jumpDebounce = false

    local Walk = tools:CreateToggle({
        Name = "Walking", CurrentValue = false, Flag = "walking",
        Callback = function(val)
            walking = val
            if not val and lplr.ball then
                lplr.ball.Anchored = false
            end
        end
    })
    local WalkSpeedSlider = tools:CreateSlider({
        Name = "Walk Speed", Range = {1, 50}, Increment = 1, Suffix = "",
        CurrentValue = 10, Flag = "walk_speed", Callback = function() end
    })
    local JumpPowerSlider = tools:CreateSlider({
        Name = "Jump Power", Range = {10, 100}, Increment = 1, Suffix = "",
        CurrentValue = 40, Flag = "walk_jump_power", Callback = function() end
    })

    local isOnGround = function()
        if not lplr.ball then return false end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignored = {}
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr.Character then table.insert(ignored, plr.Character) end
            local model = workspace.playerModels:FindFirstChild(plr.Name)
            if model then table.insert(ignored, model) end
        end
        params.FilterDescendantsInstances = ignored
        local ray = workspace:Raycast(lplr.ball.Position, Vector3.new(0, -2, 0), params)
        return ray ~= nil
    end

    cleanup.add(runService.RenderStepped:Connect(function(dt)
        if not Walk.CurrentValue then return end
        if not lplr.ball then return end
        local speed = WalkSpeedSlider.CurrentValue
        local moveX = 0
        local left = userInputService:IsKeyDown(Enum.KeyCode.A) or userInputService:IsKeyDown(Enum.KeyCode.Left)
        local right = userInputService:IsKeyDown(Enum.KeyCode.D) or userInputService:IsKeyDown(Enum.KeyCode.Right)
        if left then moveX = -speed end
        if right then moveX = speed end
        if moveX ~= 0 then
            local vel = lplr.ball.AssemblyLinearVelocity
            lplr.ball.AssemblyLinearVelocity = Vector3.new(moveX, vel.Y, vel.Z)
        end
    end))

    cleanup.add(userInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if not Walk.CurrentValue then return end
        if not lplr.ball then return end
        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Up or input.KeyCode == Enum.KeyCode.Space then
            if isOnGround() and not jumpDebounce then
                jumpDebounce = true
                local vel = lplr.ball.AssemblyLinearVelocity
                lplr.ball.AssemblyLinearVelocity = Vector3.new(vel.X, JumpPowerSlider.CurrentValue, vel.Z)
                task.delay(0.3, function() jumpDebounce = false end)
            end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()

    local AutoBounce = blatant:CreateToggle({
        Name = "AutoBounce", CurrentValue = false, Flag = "autobounce", Callback = function() end
    })
    local BounceStrengthSlider = blatant:CreateSlider({
        Name = "Bounce Strength", Range = {5, 100}, Increment = 1, Suffix = "",
        CurrentValue = 40, Flag = "autobounce_strength", Callback = function() end
    })
    local BounceUpBiasSlider = blatant:CreateSlider({
        Name = "Upward Bias", Range = {0, 2}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.6, Flag = "autobounce_upbias", Callback = function() end
    })

    local debounce = false

    cleanup.add(runService.RenderStepped:Connect(function()
        if not AutoBounce.CurrentValue then return end
        if not lplr.ball then return end
        if debounce then return end

        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignored = {}
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr.Character then table.insert(ignored, plr.Character) end
            local model = workspace.playerModels:FindFirstChild(plr.Name)
            if model then table.insert(ignored, model) end
        end
        if lplr.model then table.insert(ignored, lplr.model) end
        params.FilterDescendantsInstances = ignored

        local ballRadius = lplr.ball.Size.X / 2
        local castDist = ballRadius + 0.5
        local hitSide = nil
        local hitUp = false

        for _, dir in ipairs({ Vector3.new(1, 0, 0), Vector3.new(-1, 0, 0) }) do
            local ray = workspace:Raycast(lplr.ball.Position, dir * castDist, params)
            if ray and ray.Instance and ray.Instance.Transparency < 1 and ray.Instance.CanCollide then
                hitSide = dir.X > 0 and 'right' or 'left'
                break
            end
        end

        local upRay = workspace:Raycast(lplr.ball.Position, Vector3.new(0, -castDist, 0), params)
        if upRay and upRay.Instance and upRay.Instance.Transparency < 1 and upRay.Instance.CanCollide then
            hitUp = true
        end

        if hitSide or hitUp then
            debounce = true
            local strength = BounceStrengthSlider.CurrentValue
            local bias = BounceUpBiasSlider.CurrentValue
            local vel = lplr.ball.AssemblyLinearVelocity
            local newX = vel.X
            local newY = vel.Y
            if hitSide then newX = hitSide == 'right' and -strength or strength end
            if hitUp then newY = strength * bias end
            lplr.ball.AssemblyLinearVelocity = Vector3.new(newX, newY, vel.Z)
            if lplr.axe then
                local axeOffset = lplr.axe.Position - lplr.ball.Position
                lplr.axe.CFrame = CFrame.new(lplr.ball.Position + Vector3.new(
                    hitSide and (newX * 0.1) or axeOffset.X,
                    axeOffset.Y, axeOffset.Z
                ))
            end
            task.delay(0.2, function() debounce = false end)
        end
    end))
end)

runFunction(function()
    render:CreateDivider()

    local screenGui = nil
    local frame = nil
    local label = nil
    local uiCorner = nil
    local uiStroke = nil
    local uiScale = nil
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local posFile = 'boba/' .. tostring(game.PlaceId) .. '/speedometer_pos.json'

    local savePos = function()
        if not frame then return end
        pcall(function()
            writefile(posFile, httpService:JSONEncode({
                x = frame.Position.X.Offset,
                y = frame.Position.Y.Offset,
                xs = frame.Position.X.Scale,
                ys = frame.Position.Y.Scale,
            }))
        end)
    end

    local loadPos = function()
        pcall(function()
            if isfile(posFile) then
                local data = httpService:JSONDecode(readfile(posFile))
                frame.Position = UDim2.new(data.xs or 0.5, data.x or -80, data.ys or 0, data.y or 120)
            end
        end)
    end

    local getTimerFrame = function()
        local gui = lplrObject.PlayerGui:FindFirstChild('Timer')
        if not gui then return nil end
        return gui:FindFirstChild('timer')
    end

    local makeGui = function()
        if screenGui then screenGui:Destroy() end
        screenGui = Instance.new('ScreenGui')
        screenGui.Name = 'SpeedometerGui'
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = lplrObject.PlayerGui

        frame = Instance.new('Frame')
        frame.Size = UDim2.new(0, 160, 0, 50)
        frame.Position = UDim2.new(0.5, -80, 0, 120)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        uiCorner = Instance.new('UICorner')
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = frame

        uiStroke = Instance.new('UIStroke')
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Thickness = 1.5
        uiStroke.Color = Color3.fromRGB(255, 255, 255)
        uiStroke.Parent = frame

        uiScale = Instance.new('UIScale')
        uiScale.Scale = 1
        uiScale.Parent = frame

        label = Instance.new('TextLabel')
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextScaled = false
        label.TextSize = 36
        label.FontFace = Font.new('rbxasset://fonts/families/TitilliumWeb.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        label.Parent = frame

        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
            end
        end)
        frame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                savePos()
            end
        end)
        userInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)

        loadPos()
    end

    local removeGui = function()
        if screenGui then screenGui:Destroy() screenGui = nil end
        frame = nil label = nil uiCorner = nil uiStroke = nil uiScale = nil
    end

    local positionAboveTimer = function()
        if not frame then return end
        local timerFrame = getTimerFrame()
        if not timerFrame then return end
        local timerPos = timerFrame.AbsolutePosition
        local timerSize = timerFrame.AbsoluteSize
        local w = frame.AbsoluteSize.X
        frame.Position = UDim2.new(0, timerPos.X + (timerSize.X / 2) - (w / 2), 0, timerPos.Y - frame.AbsoluteSize.Y - 6)
    end

    local SpeedometerToggle = render:CreateToggle({
        Name = "Speedometer", CurrentValue = false, Flag = "speedometer",
        Callback = function(val) if val then makeGui() else removeGui() end end
    })
    local SpeedPositionDropdown = render:CreateDropdown({
        Name = "Position", Options = {'Draggable', 'Above Timer'},
        CurrentOption = {'Draggable'}, Flag = "speedometer_position", Callback = function() end
    })
    local SpeedColorLowPicker = render:CreateColorPicker({
        Name = "Low Speed Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "speedometer_color_low", Callback = function() end
    })
    local SpeedColorMidPicker = render:CreateColorPicker({
        Name = "Mid Speed Color", Color = Color3.fromRGB(255, 200, 0),
        Flag = "speedometer_color_mid", Callback = function() end
    })
    local SpeedColorHighPicker = render:CreateColorPicker({
        Name = "High Speed Color", Color = Color3.fromRGB(255, 50, 50),
        Flag = "speedometer_color_high", Callback = function() end
    })
    local SpeedColorMaxSlider = render:CreateSlider({
        Name = "Max Speed (for color)", Range = {10, 200}, Increment = 1, Suffix = "",
        CurrentValue = 80, Flag = "speedometer_max", Callback = function() end
    })
    local SpeedBGTransparencySlider = render:CreateSlider({
        Name = "Background Transparency", Range = {0, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.3, Flag = "speedometer_bg_transparency", Callback = function() end
    })
    local SpeedWidthSlider = render:CreateSlider({
        Name = "Width", Range = {50, 600}, Increment = 1, Suffix = "",
        CurrentValue = 160, Flag = "speedometer_width", Callback = function() end
    })
    local SpeedHeightSlider = render:CreateSlider({
        Name = "Height", Range = {20, 300}, Increment = 1, Suffix = "",
        CurrentValue = 50, Flag = "speedometer_height", Callback = function() end
    })
    local SpeedTextSizeSlider = render:CreateSlider({
        Name = "Text Size", Range = {8, 100}, Increment = 1, Suffix = "",
        CurrentValue = 36, Flag = "speedometer_text_size", Callback = function() end
    })
    local SpeedScaleToggle = render:CreateToggle({
        Name = "UIScale", CurrentValue = false, Flag = "speedometer_scale",
        Callback = function(val) if not val then if uiScale then uiScale.Scale = 1 end end end
    })
    local SpeedScaleSlider = render:CreateSlider({
        Name = "Scale", Range = {0.1, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "speedometer_scale_value", Callback = function() end
    })
    local SpeedCornerToggle = render:CreateToggle({
        Name = "Corner Radius", CurrentValue = true, Flag = "speedometer_corner",
        Callback = function(val) if not val then if uiCorner then uiCorner:Destroy() uiCorner = nil end end end
    })
    local SpeedCornerSlider = render:CreateSlider({
        Name = "Corner Radius Value", Range = {0, 50}, Increment = 1, Suffix = "",
        CurrentValue = 8, Flag = "speedometer_corner_value", Callback = function() end
    })
    local SpeedStrokeToggle = render:CreateToggle({
        Name = "Border Stroke", CurrentValue = false, Flag = "speedometer_stroke",
        Callback = function(val) if not val then if uiStroke then uiStroke:Destroy() uiStroke = nil end end end
    })
    local SpeedStrokeModeDropdown = render:CreateDropdown({
        Name = "Stroke Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Color Picker'}, Flag = "speedometer_stroke_mode", Callback = function() end
    })
    local SpeedStrokeColorPicker = render:CreateColorPicker({
        Name = "Stroke Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "speedometer_stroke_color", Callback = function() end
    })
    local SpeedStrokeThicknessSlider = render:CreateSlider({
        Name = "Stroke Thickness", Range = {1, 10}, Increment = 0.1, Suffix = "",
        CurrentValue = 2, Flag = "speedometer_stroke_thickness", Callback = function() end
    })
    local SpeedFontDropdown = render:CreateDropdown({
        Name = "Font",
        Options = {
            'Legacy','Arial','ArialBold','SourceSans','SourceSansBold','SourceSansSemibold',
            'SourceSansItalic','SourceSansLight','SourceSansExtraLight','Bodoni','Highway',
            'SciFi','Cartoon','Code','Fantasy','Antique','Gotham','GothamBold','GothamBlack',
            'GothamMedium','GothamLight','AmaticSC','Bangers','Creepster','DenkOne','Fondamento',
            'FredokaOne','GrenzeGotisch','IndieFlower','JosefinSans','Jura','KoHo','Kumbhsans',
            'Mali','NotoSans','Nunito','Oswald','PatrickHand','PermanentMarker','Roboto',
            'RobotoCondensed','RobotoMono','Sarpanch','SpecialElite','TitilliumWeb','Ubuntu'
        },
        CurrentOption = {'TitilliumWeb'}, Flag = "speedometer_font", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not SpeedometerToggle.CurrentValue then return end
        if not label or not frame then return end

        local speed = 0
        if lplr.ball then
            local vel = lplr.ball.AssemblyLinearVelocity
            speed = Vector2.new(vel.X, vel.Y).Magnitude
        end

        local maxSpeed = SpeedColorMaxSlider.CurrentValue
        local t = math.clamp(speed / maxSpeed, 0, 1)
        local color
        if t < 0.5 then
            color = SpeedColorLowPicker.Color:Lerp(SpeedColorMidPicker.Color, t * 2)
        else
            color = SpeedColorMidPicker.Color:Lerp(SpeedColorHighPicker.Color, (t - 0.5) * 2)
        end

        label.TextColor3 = color
        label.Text = string.format('%.2f', speed)
        label.TextSize = SpeedTextSizeSlider.CurrentValue
        pcall(function()
            label.FontFace = Font.fromEnum(Enum.Font[SpeedFontDropdown.CurrentOption[1]])
        end)

        frame.BackgroundTransparency = SpeedBGTransparencySlider.CurrentValue
        frame.Size = UDim2.new(0, SpeedWidthSlider.CurrentValue, 0, SpeedHeightSlider.CurrentValue)

        if SpeedPositionDropdown.CurrentOption[1] == 'Above Timer' then
            positionAboveTimer()
        end

        if SpeedCornerToggle.CurrentValue then
            if not uiCorner then
                uiCorner = frame:FindFirstChildOfClass('UICorner') or Instance.new('UICorner')
                uiCorner.Parent = frame
            end
            uiCorner.CornerRadius = UDim.new(0, SpeedCornerSlider.CurrentValue)
        else
            if uiCorner then uiCorner:Destroy() uiCorner = nil end
        end

        if SpeedStrokeToggle.CurrentValue then
            if not uiStroke then
                uiStroke = Instance.new('UIStroke')
                uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                uiStroke.Parent = frame
            end
            uiStroke.Color = SpeedStrokeModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or SpeedStrokeColorPicker.Color
            uiStroke.Thickness = SpeedStrokeThicknessSlider.CurrentValue
        else
            if uiStroke then uiStroke:Destroy() uiStroke = nil end
        end

        if SpeedScaleToggle.CurrentValue then
            if not uiScale then
                uiScale = Instance.new('UIScale')
                uiScale.Parent = frame
            end
            uiScale.Scale = SpeedScaleSlider.CurrentValue
        else
            if uiScale then uiScale:Destroy() uiScale = nil end
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()

    local resolvedTarget = nil
    local autoRefreshEnabled = true

    local getPlayerOptions = function()
        local options = {}
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr ~= lplrObject then table.insert(options, plr.Name) end
        end
        if #options == 0 then table.insert(options, 'No players') end
        return options
    end

    local findPlayer = function(query)
        if not query or query == '' then return nil end
        query = query:lower()
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr ~= lplrObject and plr.Name:lower() == query then return plr end
        end
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr ~= lplrObject and plr.Name:lower():find(query, 1, true) then return plr end
        end
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr ~= lplrObject then
                local initials = plr.Name:gsub('(%a)%l*', '%1'):lower()
                if initials == query then return plr end
            end
        end
        return nil
    end

    local PlayerTPDropdown = blatant:CreateDropdown({
        Name = "PlayerTP Target", Options = getPlayerOptions(),
        CurrentOption = {getPlayerOptions()[1]}, Flag = "playertp_target",
        Callback = function(val)
            resolvedTarget = val[1] ~= 'No players' and val[1] or nil
        end
    })

    local refreshDropdown = function()
        local options = getPlayerOptions()
        local newCurrent = nil
        for _, o in ipairs(options) do
            if o == resolvedTarget then newCurrent = o break end
        end
        if not newCurrent then newCurrent = options[1] end
        PlayerTPDropdown:Refresh(options, {newCurrent})
        resolvedTarget = newCurrent ~= 'No players' and newCurrent or nil
    end

    blatant:CreateToggle({
        Name = "Auto Refresh Players", CurrentValue = true, Flag = "playertp_autorefresh",
        Callback = function(val) autoRefreshEnabled = val end
    })
    blatant:CreateButton({
        Name = "Refresh Players", Callback = function() refreshDropdown() end
    })
    blatant:CreateInput({
        Name = "Search Player", PlaceholderText = "name, partial, or initials...",
        RemoveTextAfterFocusLost = false, Flag = "playertp_search",
        Callback = function(val)
            local plr = findPlayer(val)
            if plr then
                resolvedTarget = plr.Name
                PlayerTPDropdown:Refresh(getPlayerOptions(), {plr.Name})
            else
                resolvedTarget = nil
            end
        end
    })

    local doTP = function()
        if not resolvedTarget then return end
        local targetModel = workspace.playerModels:FindFirstChild(resolvedTarget)
        if not targetModel then return end
        local targetBall = targetModel:FindFirstChild('ball')
        if not targetBall then return end
        if lplr.ball then lplr.ball.CFrame = targetBall.CFrame + Vector3.new(0, 3, 0) end
        if lplr.axe then lplr.axe.CFrame = targetBall.CFrame + Vector3.new(2, 3, 0) end
    end

    blatant:CreateButton({ Name = "Teleport", Callback = doTP })

    local PlayerTPToggle = blatant:CreateToggle({
        Name = "Stay on Player", CurrentValue = false, Flag = "playertp_stay", Callback = function() end
    })

    cleanup.add(playersService.PlayerAdded:Connect(function()
        if autoRefreshEnabled then refreshDropdown() end
    end))
    cleanup.add(playersService.PlayerRemoving:Connect(function()
        if autoRefreshEnabled then task.wait(0.1) refreshDropdown() end
    end))
    cleanup.add(runService.RenderStepped:Connect(function()
        if not PlayerTPToggle.CurrentValue then return end
        doTP()
    end))
end)

runFunction(function()
    tools:CreateDivider()

    local currentCF = nil
    local currentFOV = 60
    local currentOffsetX = 4
    local smoothAxeVelX = 0
    local wallCheckParts = {}

    local getPlayerOptions = function()
        local options = {}
        for _, plr in ipairs(playersService:GetPlayers()) do
            if plr ~= lplrObject then table.insert(options, plr.Name) end
        end
        if #options == 0 then table.insert(options, 'No players') end
        return options
    end

    local SpectateDropdown = tools:CreateDropdown({
        Name = "Spectate Target", Options = getPlayerOptions(),
        CurrentOption = {getPlayerOptions()[1]}, Flag = "spectate_target", Callback = function() end
    })
    tools:CreateButton({
        Name = "Refresh Players",
        Callback = function()
            local options = getPlayerOptions()
            SpectateDropdown:Refresh(options, {options[1]})
        end
    })
    local SpectateSmoothSlider = tools:CreateSlider({
        Name = "Camera Smoothness", Range = {0.01, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.06, Flag = "spectate_smooth", Callback = function() end
    })
    local SpectateOffsetXSlider = tools:CreateSlider({
        Name = "Camera Offset X", Range = {-20, 20}, Increment = 0.1, Suffix = "",
        CurrentValue = 4, Flag = "spectate_offset_x", Callback = function() end
    })
    local SpectateOffsetYSlider = tools:CreateSlider({
        Name = "Camera Offset Y", Range = {-20, 20}, Increment = 0.1, Suffix = "",
        CurrentValue = 3, Flag = "spectate_offset_y", Callback = function() end
    })
    local SpectateOffsetZSlider = tools:CreateSlider({
        Name = "Camera Distance", Range = {-60, -5}, Increment = 0.1, Suffix = "",
        CurrentValue = -20, Flag = "spectate_offset_z", Callback = function() end
    })
    local SpectateFOVSlider = tools:CreateSlider({
        Name = "Spectate FOV", Range = {30, 120}, Increment = 1, Suffix = "",
        CurrentValue = 60, Flag = "spectate_fov", Callback = function() end
    })
    local SpectateVelocityFOVToggle = tools:CreateToggle({
        Name = "Velocity FOV", CurrentValue = false, Flag = "spectate_velocity_fov", Callback = function() end
    })
    local SpectateHammerInfluenceToggle = tools:CreateToggle({
        Name = "Hammer Influence on Camera", CurrentValue = true, Flag = "spectate_hammer_influence", Callback = function() end
    })
    local SpectateHammerStrengthSlider = tools:CreateSlider({
        Name = "Hammer Influence Strength", Range = {0.01, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.15, Flag = "spectate_hammer_strength", Callback = function() end
    })
    local SpectateHammerRotToggle = tools:CreateToggle({
        Name = "Velocity Camera Drift", CurrentValue = false, Flag = "spectate_hammer_rot", Callback = function() end
    })
    local SpectateHammerRotStrengthSlider = tools:CreateSlider({
        Name = "Drift Strength", Range = {0.01, 0.5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.08, Flag = "spectate_hammer_rot_strength", Callback = function() end
    })

    local revertWallParts = function()
        for part, data in pairs(wallCheckParts) do
            pcall(function()
                tweenService:Create(part, TweenInfo.new(0.4), {Transparency = data.transparency}):Play()
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA('Texture') or child:IsA('Decal') then
                        tweenService:Create(child, TweenInfo.new(0.4), {Transparency = data.childTransparencies[child] or 0}):Play()
                    end
                end
            end)
        end
        wallCheckParts = {}
    end

    local SpectateWallCheckToggle = tools:CreateToggle({
        Name = "Wall Check", CurrentValue = false, Flag = "spectate_wall_check",
        Callback = function(val) if not val then revertWallParts() end end
    })

    local SpectateToggle = tools:CreateToggle({
        Name = "Spectate", CurrentValue = false, Flag = "spectate_toggle",
        Callback = function(val)
            sharedState.spectating = val
            if val then
                lplr.camera.CameraType = Enum.CameraType.Scriptable
                currentCF = lplr.camera.CFrame
            else
                lplr.camera.CameraType = Enum.CameraType.Custom
                lplr.camera.CameraSubject = lplr.ball
                lplr.camera.FieldOfView = 70
                currentCF = nil
                currentFOV = 60
                currentOffsetX = SpectateOffsetXSlider.CurrentValue
                smoothAxeVelX = 0
                revertWallParts()
                if lplr.ball then lplr.ball.Transparency = 0 end
                if lplr.axe then
                    lplr.axe.Transparency = 0
                    local handle = lplr.axe:FindFirstChild('handle')
                    if handle then handle.Transparency = 0 end
                end
                local lastTargetName = SpectateDropdown.CurrentOption[1]
                local lastModel = lastTargetName ~= 'No players' and workspace.playerModels:FindFirstChild(lastTargetName) or nil
                if lastModel then
                    local b = lastModel:FindFirstChild('ball')
                    local a = lastModel:FindFirstChild('axe')
                    if b then b.Transparency = 0.6 end
                    if a then
                        a.Transparency = 0.6
                        local h = a:FindFirstChild('handle')
                        if h then h.Transparency = 0.6 end
                    end
                end
            end
        end
    })

    cleanup.add(playersService.PlayerAdded:Connect(function()
        local options = getPlayerOptions()
        SpectateDropdown:Refresh(options, {options[1]})
    end))
    cleanup.add(playersService.PlayerRemoving:Connect(function()
        task.wait(0.1)
        local options = getPlayerOptions()
        SpectateDropdown:Refresh(options, {options[1]})
    end))

    cleanup.add(runService.RenderStepped:Connect(function(dt)
        if not sharedState.spectating then return end

        local targetName = SpectateDropdown.CurrentOption[1]
        if targetName == 'No players' then return end
        local targetModel = workspace.playerModels:FindFirstChild(targetName)
        if not targetModel then return end
        local targetBall = targetModel:FindFirstChild('ball')
        local targetAxe = targetModel:FindFirstChild('axe')
        if not targetBall then return end

        if lplr.ball then lplr.ball.Transparency = 0.6 end
        if lplr.axe then
            lplr.axe.Transparency = 0.6
            local handle = lplr.axe:FindFirstChild('handle')
            if handle then handle.Transparency = 0.6 end
        end

        targetBall.Transparency = 0
        if targetAxe then
            targetAxe.Transparency = 0
            local targetHandle = targetAxe:FindFirstChild('handle')
            if targetHandle then targetHandle.Transparency = 0 end
        end

        if SpectateWallCheckToggle.CurrentValue then
            local rayOrigin = lplr.camera.CFrame.Position
            local rayTarget = targetBall.Position - rayOrigin
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            local ignored = {}
            for _, plr in ipairs(playersService:GetPlayers()) do
                if plr.Character then table.insert(ignored, plr.Character) end
                local model = workspace.playerModels:FindFirstChild(plr.Name)
                if model then table.insert(ignored, model) end
            end
            params.FilterDescendantsInstances = ignored

            local newHit = {}
            local ray = workspace:Raycast(rayOrigin, rayTarget, params)
            if ray and ray.Instance then
                local part = ray.Instance
                if not wallCheckParts[part] then
                    local childTransparencies = {}
                    for _, child in ipairs(part:GetChildren()) do
                        if child:IsA('Texture') or child:IsA('Decal') then
                            childTransparencies[child] = child.Transparency
                        end
                    end
                    wallCheckParts[part] = { transparency = part.Transparency, childTransparencies = childTransparencies }
                end
                newHit[part] = true
                tweenService:Create(part, TweenInfo.new(0.3), {Transparency = 0.7}):Play()
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA('Texture') or child:IsA('Decal') then
                        tweenService:Create(child, TweenInfo.new(0.3), {Transparency = 0.7}):Play()
                    end
                end
            end

            for part, data in pairs(wallCheckParts) do
                if not newHit[part] then
                    pcall(function()
                        tweenService:Create(part, TweenInfo.new(0.4), {Transparency = data.transparency}):Play()
                        for _, child in ipairs(part:GetChildren()) do
                            if child:IsA('Texture') or child:IsA('Decal') then
                                tweenService:Create(child, TweenInfo.new(0.4), {Transparency = data.childTransparencies[child] or 0}):Play()
                            end
                        end
                    end)
                    wallCheckParts[part] = nil
                end
            end
        end

        local focusPos = targetBall.Position
        if targetAxe then focusPos = targetBall.Position:Lerp(targetAxe.Position, 0.35) end

        local offsetX = SpectateOffsetXSlider.CurrentValue
        local offsetY = SpectateOffsetYSlider.CurrentValue

        if SpectateHammerInfluenceToggle.CurrentValue and targetAxe then
            local axeOffset = targetAxe.Position - targetBall.Position
            local strength = SpectateHammerStrengthSlider.CurrentValue
            offsetX = offsetX + axeOffset.X * strength
            offsetY = offsetY + axeOffset.Y * strength
        end

        if SpectateHammerRotToggle.CurrentValue then
            local vel = targetBall.AssemblyLinearVelocity
            local rotStrength = SpectateHammerRotStrengthSlider.CurrentValue
            smoothAxeVelX = smoothAxeVelX + (vel.X - smoothAxeVelX) * math.clamp(0.1 * (dt * 60), 0, 1)
            currentOffsetX = currentOffsetX + (offsetX + smoothAxeVelX * rotStrength - currentOffsetX) * math.clamp(0.05 * (dt * 60), 0, 1)
            offsetX = currentOffsetX
        else
            currentOffsetX = offsetX
        end

        local targetCF = CFrame.new(
            focusPos + Vector3.new(offsetX, offsetY, SpectateOffsetZSlider.CurrentValue),
            focusPos
        )

        if not currentCF then currentCF = targetCF end
        local smooth = math.clamp(SpectateSmoothSlider.CurrentValue * (dt * 60), 0, 1)
        currentCF = currentCF:Lerp(targetCF, smooth)
        lplr.camera.CFrame = currentCF

        local targetFOV
        if SpectateVelocityFOVToggle.CurrentValue then
            local vel = targetBall.AssemblyLinearVelocity
            local speed = Vector2.new(vel.X, vel.Y).Magnitude
            local t = math.clamp(speed / 50, 0, 1)
            targetFOV = 70 + (120 - 70) * t
        else
            targetFOV = SpectateFOVSlider.CurrentValue
        end

        currentFOV = currentFOV + (targetFOV - currentFOV) * math.clamp(0.08 * (dt * 60), 0, 1)
        lplr.camera.FieldOfView = currentFOV
    end))
end)

runFunction(function()
    if not isfolder('boba/library') then makefolder('boba/library') end
    if not isfolder('boba/library/sounds') then makefolder('boba/library/sounds') end

    local function getDownloadedFiles()
        local files = {}
        if isfolder('boba/library') then
            for _, f in ipairs(listfiles('boba/library')) do
                local name = f:match('([^/\\]+)$')
                if name and not name:find('sounds') then table.insert(files, name) end
            end
        end
        return #files > 0 and files or {'No files'}
    end

    library:CreateSection("Download")

    local fileNameInput = library:CreateInput({
        Name = "File Name",
        PlaceholderText = "e.g. mysound.mp3 or script.lua",
        RemoveTextAfterFocusLost = false,
        Flag = "library_filename",
        Callback = function() end
    })

    local fileUrlInput = library:CreateInput({
        Name = "File URL",
        PlaceholderText = "https://...",
        RemoveTextAfterFocusLost = false,
        Flag = "library_url",
        Callback = function() end
    })

    local isSoundToggle = library:CreateToggle({
        Name = "Is Sound File",
        CurrentValue = false,
        Flag = "library_issound",
        Callback = function() end
    })

    library:CreateButton({
        Name = "Download",
        Callback = function()
            local name = fileNameInput.CurrentValue
            local url = fileUrlInput.CurrentValue
            if not name or name == '' then notif('Library', 'Enter a file name.', 3) return end
            if not url or url == '' then notif('Library', 'Enter a URL.', 3) return end
            local suc, res = pcall(function() return game:HttpGet(url) end)
            if not suc or not res or res == '' then
                notif('Library', 'Failed to fetch: '..tostring(res), 5)
                return
            end
            local path = isSoundToggle.CurrentValue
                and 'boba/library/sounds/'..name
                or 'boba/library/'..name
            pcall(function() writefile(path, res) end)
            notif('Library', 'Saved: '..name, 3)
        end
    })

    library:CreateDivider()
    library:CreateSection("Files")

    local filesOptions = getDownloadedFiles()
    local FilesDropdown = library:CreateDropdown({
        Name = "Downloaded Files",
        Options = filesOptions,
        CurrentOption = {filesOptions[1]},
        Flag = "library_files_dropdown",
        Callback = function() end
    })

    library:CreateButton({
        Name = "Refresh Files",
        Callback = function()
            local opts = getDownloadedFiles()
            FilesDropdown:Refresh(opts, {opts[1]})
        end
    })

    library:CreateButton({
        Name = "Delete Selected",
        Callback = function()
            local selected = FilesDropdown.CurrentOption[1]
            if not selected or selected == 'No files' then return end
            pcall(function() delfile('boba/library/'..selected) end)
            notif('Library', 'Deleted: '..selected, 3)
            local opts = getDownloadedFiles()
            FilesDropdown:Refresh(opts, {opts[1]})
        end
    })

    library:CreateButton({
        Name = "Execute Selected",
        Callback = function()
            local selected = FilesDropdown.CurrentOption[1]
            if not selected or selected == 'No files' then return end
            local path = 'boba/library/'..selected
            if not isfile(path) then notif('Library', 'File not found.', 3) return end
            local suc, err = pcall(function() loadstring(readfile(path))() end)
            if not suc then
                notif('Library', 'Error: '..tostring(err), 6)
            else
                notif('Library', 'Executed: '..selected, 3)
            end
        end
    })
end)

runFunction(function()
    local function getSoundFiles()
        local files = {}
        if isfolder('boba/library/sounds') then
            for _, f in ipairs(listfiles('boba/library/sounds')) do
                local name = f:match('([^/\\]+)$')
                if name then table.insert(files, name) end
            end
        end
        return #files > 0 and files or {'No sounds'}
    end

    local musicSound = Instance.new('Sound')
    musicSound.Parent = workspace
    musicSound.Volume = 0.5
    musicSound.Looped = true

    local sfxSound = Instance.new('Sound')
    sfxSound.Parent = workspace

    local lastBeatTime = 0
    local fovBeatCurrent = 70
    local fovBeatTarget = 70

    library:CreateDivider()
    library:CreateSection("Music Player")

    local MusicSourceDropdown = library:CreateDropdown({
        Name = "Source",
        Options = {'Library', 'Asset ID'},
        CurrentOption = {'Library'},
        Flag = "library_music_source",
        Callback = function() end
    })

    local MusicAssetInput = library:CreateInput({
        Name = "Asset ID",
        PlaceholderText = "rbxassetid://...",
        RemoveTextAfterFocusLost = false,
        Flag = "library_music_assetid",
        Callback = function() end
    })

    local soundOpts = getSoundFiles()
    local MusicDropdown = library:CreateDropdown({
        Name = "Sound File",
        Options = soundOpts,
        CurrentOption = {soundOpts[1]},
        Flag = "library_music_file",
        Callback = function() end
    })

    library:CreateButton({
        Name = "Refresh Sounds",
        Callback = function()
            local opts = getSoundFiles()
            MusicDropdown:Refresh(opts, {opts[1]})
        end
    })

    local MusicVolumeSlider = library:CreateSlider({
        Name = "Volume", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "library_music_volume", Callback = function() end
    })

    local MusicSpeedSlider = library:CreateSlider({
        Name = "Speed", Range = {0.1, 4}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "library_music_speed", Callback = function() end
    })

    local MusicStartAtSlider = library:CreateSlider({
        Name = "Start At (seconds)", Range = {0, 600}, Increment = 0.1, Suffix = "",
        CurrentValue = 0, Flag = "library_music_startat", Callback = function() end
    })

    library:CreateButton({
        Name = "Play",
        Callback = function()
            if MusicSourceDropdown.CurrentOption[1] == 'Asset ID' then
                local id = MusicAssetInput.CurrentValue
                if not id or id == '' then notif('Library', 'Enter an asset ID.', 3) return end
                musicSound.SoundId = id:find('rbxassetid://') and id or 'rbxassetid://'..id
            else
                local selected = MusicDropdown.CurrentOption[1]
                if not selected or selected == 'No sounds' then notif('Library', 'No sound selected.', 3) return end
                local path = 'boba/library/sounds/'..selected
                if not isfile(path) then notif('Library', 'File not found.', 3) return end
                local suc, asset = pcall(getcustomasset, path)
                if not suc then notif('Library', 'Failed to load asset.', 3) return end
                musicSound.SoundId = asset
            end
            musicSound.Volume = MusicVolumeSlider.CurrentValue
            musicSound.PlaybackSpeed = MusicSpeedSlider.CurrentValue
            musicSound:Play()
            musicSound.TimePosition = MusicStartAtSlider.CurrentValue
        end
    })

    library:CreateButton({
        Name = "Stop",
        Callback = function() musicSound:Stop() end
    })

    library:CreateButton({
        Name = "Pause / Resume",
        Callback = function()
            if musicSound.IsPlaying then musicSound:Pause() else musicSound:Resume() end
        end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if musicSound.IsPlaying then
            musicSound.Volume = MusicVolumeSlider.CurrentValue
            musicSound.PlaybackSpeed = MusicSpeedSlider.CurrentValue
        end
    end))

    library:CreateDivider()
    library:CreateSection("Beat FOV")

    local BeatFOVToggle = library:CreateToggle({
        Name = "Beat FOV",
        CurrentValue = false,
        Flag = "library_beat_fov",
        Callback = function(val)
            if not val then
                lplr.camera.FieldOfView = 70
                fovBeatCurrent = 70
            end
        end
    })

    local BPMSlider = library:CreateSlider({
        Name = "BPM", Range = {40, 300}, Increment = 1, Suffix = "",
        CurrentValue = 120, Flag = "library_bpm", Callback = function() end
    })

    local BeatFOVPeakSlider = library:CreateSlider({
        Name = "FOV on Beat", Range = {30, 150}, Increment = 1, Suffix = "",
        CurrentValue = 90, Flag = "library_beat_fov_peak", Callback = function() end
    })

    local BeatFOVBaseSlider = library:CreateSlider({
        Name = "FOV Base", Range = {30, 120}, Increment = 1, Suffix = "",
        CurrentValue = 70, Flag = "library_beat_fov_base", Callback = function() end
    })

    local BeatFOVSmoothSlider = library:CreateSlider({
        Name = "Return Smoothness", Range = {0.01, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.15, Flag = "library_beat_fov_smooth", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function(dt)
        if not BeatFOVToggle.CurrentValue then return end
        if sharedState.spectating then return end
        if not musicSound.IsPlaying then return end
        local now = tick()
        local beatInterval = 60 / BPMSlider.CurrentValue
        if now - lastBeatTime >= beatInterval then
            lastBeatTime = now
            fovBeatTarget = BeatFOVPeakSlider.CurrentValue
        else
            fovBeatTarget = BeatFOVBaseSlider.CurrentValue
        end
        fovBeatCurrent = fovBeatCurrent + (fovBeatTarget - fovBeatCurrent) * math.clamp(BeatFOVSmoothSlider.CurrentValue * (dt * 60), 0, 1)
        lplr.camera.FieldOfView = fovBeatCurrent
    end))

    library:CreateDivider()
    library:CreateSection("Sound Effects")

    local SFXSourceDropdown = library:CreateDropdown({
        Name = "SFX Source",
        Options = {'Library', 'Asset ID'},
        CurrentOption = {'Library'},
        Flag = "library_sfx_source",
        Callback = function() end
    })

    local SFXAssetInput = library:CreateInput({
        Name = "SFX Asset ID",
        PlaceholderText = "rbxassetid://...",
        RemoveTextAfterFocusLost = false,
        Flag = "library_sfx_assetid",
        Callback = function() end
    })

    local sfxOpts = getSoundFiles()
    local SFXDropdown = library:CreateDropdown({
        Name = "Sound Effect File",
        Options = sfxOpts,
        CurrentOption = {sfxOpts[1]},
        Flag = "library_sfx_file",
        Callback = function() end
    })

    library:CreateButton({
        Name = "Refresh SFX",
        Callback = function()
            local opts = getSoundFiles()
            SFXDropdown:Refresh(opts, {opts[1]})
        end
    })

    local SFXVolumeSlider = library:CreateSlider({
        Name = "SFX Volume", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "library_sfx_volume", Callback = function() end
    })

    local SFXSpeedSlider = library:CreateSlider({
        Name = "SFX Speed", Range = {0.1, 4}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "library_sfx_speed", Callback = function() end
    })

    library:CreateButton({
        Name = "Play SFX",
        Callback = function()
            if SFXSourceDropdown.CurrentOption[1] == 'Asset ID' then
                local id = SFXAssetInput.CurrentValue
                if not id or id == '' then notif('Library', 'Enter an asset ID.', 3) return end
                sfxSound.SoundId = id:find('rbxassetid://') and id or 'rbxassetid://'..id
            else
                local selected = SFXDropdown.CurrentOption[1]
                if not selected or selected == 'No sounds' then notif('Library', 'No sound selected.', 3) return end
                local path = 'boba/library/sounds/'..selected
                if not isfile(path) then notif('Library', 'File not found.', 3) return end
                local suc, asset = pcall(getcustomasset, path)
                if not suc then notif('Library', 'Failed to load.', 3) return end
                sfxSound.SoundId = asset
            end
            sfxSound.Volume = SFXVolumeSlider.CurrentValue
            sfxSound.PlaybackSpeed = SFXSpeedSlider.CurrentValue
            sfxSound:Play()
        end
    })
end)

runFunction(function()
    local function getSoundFiles()
        local files = {}
        if isfolder('boba/library/sounds') then
            for _, f in ipairs(listfiles('boba/library/sounds')) do
                local name = f:match('([^/\\]+)$')
                if name then table.insert(files, name) end
            end
        end
        return #files > 0 and files or {'No sounds'}
    end

    local playlist = {}
    local currentIndex = 1
    local playlistSound = Instance.new('Sound')
    playlistSound.Parent = workspace
    playlistSound.Volume = 0.5

    local playlistActive = false

    local function getPlaylistNames()
        local names = {}
        for _, entry in ipairs(playlist) do
            table.insert(names, entry.name)
        end
        return #names > 0 and names or {'Empty'}
    end

    library:CreateDivider()
    library:CreateSection("Playlist")

    local PlaylistSourceDropdown = library:CreateDropdown({
        Name = "Add Source",
        Options = {'Library', 'Asset ID'},
        CurrentOption = {'Library'},
        Flag = "playlist_add_source",
        Callback = function() end
    })

    local PlaylistAssetInput = library:CreateInput({
        Name = "Asset ID to Add",
        PlaceholderText = "rbxassetid://... and a name",
        RemoveTextAfterFocusLost = false,
        Flag = "playlist_asset_input",
        Callback = function() end
    })

    local PlaylistAssetNameInput = library:CreateInput({
        Name = "Display Name",
        PlaceholderText = "e.g. Song 1",
        RemoveTextAfterFocusLost = false,
        Flag = "playlist_asset_name",
        Callback = function() end
    })

    local soundOpts = getSoundFiles()
    local PlaylistFileDropdown = library:CreateDropdown({
        Name = "Library File to Add",
        Options = soundOpts,
        CurrentOption = {soundOpts[1]},
        Flag = "playlist_file_dropdown",
        Callback = function() end
    })

    library:CreateButton({
        Name = "Refresh Library",
        Callback = function()
            local opts = getSoundFiles()
            PlaylistFileDropdown:Refresh(opts, {opts[1]})
        end
    })

    library:CreateButton({
        Name = "Add to Playlist",
        Callback = function()
            if PlaylistSourceDropdown.CurrentOption[1] == 'Asset ID' then
                local id = PlaylistAssetInput.CurrentValue
                local name = PlaylistAssetNameInput.CurrentValue
                if not id or id == '' then notif('Playlist', 'Enter an asset ID.', 3) return end
                if not name or name == '' then name = id end
                table.insert(playlist, {
                    name = name,
                    source = 'asset',
                    id = id:find('rbxassetid://') and id or 'rbxassetid://'..id
                })
            else
                local selected = PlaylistFileDropdown.CurrentOption[1]
                if not selected or selected == 'No sounds' then notif('Playlist', 'No file selected.', 3) return end
                table.insert(playlist, {
                    name = selected,
                    source = 'library',
                    path = 'boba/library/sounds/'..selected
                })
            end
            notif('Playlist', 'Added: '..(playlist[#playlist].name), 3)
        end
    })

    local PlaylistVolumeSlider = library:CreateSlider({
        Name = "Playlist Volume", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "playlist_volume", Callback = function() end
    })

    local PlaylistSpeedSlider = library:CreateSlider({
        Name = "Playlist Speed", Range = {0.1, 4}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "playlist_speed", Callback = function() end
    })

    local PlaylistQueueDropdown = library:CreateDropdown({
        Name = "Current Playlist",
        Options = {'Empty'},
        CurrentOption = {'Empty'},
        Flag = "playlist_queue",
        Callback = function() end
    })

    local function refreshQueueDropdown()
        local names = getPlaylistNames()
        PlaylistQueueDropdown:Refresh(names, {names[1]})
    end

    library:CreateButton({
        Name = "Refresh Queue View",
        Callback = function() refreshQueueDropdown() end
    })

    library:CreateButton({
        Name = "Remove Selected from Playlist",
        Callback = function()
            local selected = PlaylistQueueDropdown.CurrentOption[1]
            if not selected or selected == 'Empty' then return end
            for i, entry in ipairs(playlist) do
                if entry.name == selected then
                    table.remove(playlist, i)
                    break
                end
            end
            if currentIndex > #playlist then currentIndex = 1 end
            refreshQueueDropdown()
            notif('Playlist', 'Removed: '..selected, 3)
        end
    })

    library:CreateButton({
        Name = "Clear Playlist",
        Callback = function()
            playlist = {}
            currentIndex = 1
            playlistSound:Stop()
            playlistActive = false
            refreshQueueDropdown()
            notif('Playlist', 'Cleared.', 3)
        end
    })

    local function loadAndPlay(index)
        if #playlist == 0 then return end
        local entry = playlist[index]
        if not entry then return end
        if entry.source == 'asset' then
            playlistSound.SoundId = entry.id
        else
            if not isfile(entry.path) then
                notif('Playlist', 'File missing: '..entry.name, 3)
                currentIndex = currentIndex % #playlist + 1
                loadAndPlay(currentIndex)
                return
            end
            local suc, asset = pcall(getcustomasset, entry.path)
            if not suc then
                notif('Playlist', 'Failed to load: '..entry.name, 3)
                currentIndex = currentIndex % #playlist + 1
                loadAndPlay(currentIndex)
                return
            end
            playlistSound.SoundId = asset
        end
        playlistSound.Volume = PlaylistVolumeSlider.CurrentValue
        playlistSound.PlaybackSpeed = PlaylistSpeedSlider.CurrentValue
        playlistSound.Looped = false
        playlistSound:Play()
        notif('Playlist', 'Now playing: '..entry.name, 3)
    end

    library:CreateButton({
        Name = "Play Playlist",
        Callback = function()
            if #playlist == 0 then notif('Playlist', 'Playlist is empty.', 3) return end
            playlistActive = true
            currentIndex = 1
            loadAndPlay(currentIndex)
        end
    })

    library:CreateButton({
        Name = "Stop Playlist",
        Callback = function()
            playlistActive = false
            playlistSound:Stop()
        end
    })

    library:CreateButton({
        Name = "Skip",
        Callback = function()
            if #playlist == 0 then return end
            currentIndex = currentIndex % #playlist + 1
            loadAndPlay(currentIndex)
        end
    })

    library:CreateButton({
        Name = "Previous",
        Callback = function()
            if #playlist == 0 then return end
            currentIndex = ((currentIndex - 2) % #playlist) + 1
            loadAndPlay(currentIndex)
        end
    })

    cleanup.add(runService.Heartbeat:Connect(function()
        if not playlistActive then return end
        if #playlist == 0 then return end
        if playlistSound.IsLoaded and not playlistSound.IsPlaying and not playlistSound.IsPaused then
            currentIndex = currentIndex % #playlist + 1
            loadAndPlay(currentIndex)
        end
        playlistSound.Volume = PlaylistVolumeSlider.CurrentValue
        playlistSound.PlaybackSpeed = PlaylistSpeedSlider.CurrentValue
    end))
end)

runFunction(function()
    render:CreateDivider()

    local premadeFaces = {
        {name = 'Custom', id = ''},
        {name = 'Default Face', id = 'rbxassetid://111858682543206'},
        {name = 'White Default Face', id = 'rbxassetid://10184799258'},
        {name = 'Sideways Default Face', id = 'rbxassetid://16000563171'},
        {name = ':D', id = 'rbxassetid://17244838360'},
        {name = '^_^', id = 'rbxassetid://99957094999801'},
        {name = 'Happy Blush', id = 'rbxassetid://6287342834'},
        {name = 'Cute Chill Face', id = 'rbxassetid://7235470435'},
        {name = 'Wow!', id = 'rbxassetid://6113785880'},
        {name = 'Straight face', id = 'rbxassetid://96522502090962'},
        {name = 'normal face', id = 'rbxassetid://9208983473'},
        {name = 'even more normal face', id = 'rbxassetid://6602241122'},
        {name = 'Serious Face!!', id = 'rbxassetid://5303681402'},
        {name = 'Man Face', id = 'rbxassetid://5799739939'},
        {name = 'Sad Face.', id = 'rbxassetid://102000079834063'},
        {name = 'AHHHH', id = 'rbxassetid://85037001118055'},
        {name = 'What..?', id = 'rbxassetid://7485602656'},
        {name = 'EVIL', id = 'rbxassetid://6508288104'},
        {name = 'Suspicous', id = 'rbxassetid://18636752982'},
        {name = 'More Suspicous', id = 'rbxassetid://5937011121'},
        {name = 'Purple Man', id = 'rbxassetid://5113872729'},
        {name = 'Epic Face', id = 'rbxassetid://14301710584'},
        {name = 'Troll Face', id = 'rbxassetid://5294554965'},
        {name = 'Baller', id = 'rbxassetid://110402942731812'},
        {name = 'obama', id = 'rbxassetid://4968764407'},
        {name = 'YOUR FACE HERE', id = 'rbxassetid://91130451314773'},
        {name = 'gift card', id = 'rbxassetid://18364602345'},
        {name = 'Cat Face', id = 'rbxassetid://15477500214'},
        {name = 'Cat Face 1', id = 'rbxassetid://6821165844'},
        {name = 'White Cat Face', id = 'rbxassetid://17186419549'},
        {name = 'Zombie', id = 'rbxassetid://7157327144'},
        {name = 'Vampire Face', id = 'rbxassetid://6304604718'},
        {name = 'Dead.', id = 'rbxassetid://130187161010472'},
        {name = 'Dream', id = 'rbxassetid://11151151227'},
        {name = 'zzz...', id = 'rbxassetid://11698917622'},
        {name = 'sans', id = 'rbxassetid://6671698461'},
        {name = 'Drakobloxxer', id = 'rbxassetid://97491265149516'},
        {name = 'bobo', id = 'rbxassetid://10794036784'},
        {name = 'teardrop bobo', id = 'rbxassetid://85614090385889'},
        {name = 'god bobo', id = 'rbxassetid://98321179209767'},
        {name = 'kind of sus bobo', id = 'rbxassetid://13503246365'},
        {name = 'Tear Bobo™️', id = 'rbxassetid://119604162050079'},
        {name = 'Python', id = 'rbxassetid://18689314031'},
        {name = 'Java', id = 'rbxassetid://18689390644'},
        {name = 'Haskell', id = 'rbxassetid://18689351942'},
        {name = 'JavaScript', id = 'rbxassetid://18689397624'},
    }

    local premadeOptions = {}
    local premadeLookup = {}
    for _, entry in ipairs(premadeFaces) do
        table.insert(premadeOptions, entry.name)
        premadeLookup[entry.name] = entry.id
    end

    local Face = render:CreateToggle({
        Name = 'Face',
        CurrentValue = false,
        Flag = 'face',
        Callback = function() end
    })
    local FacePremade = render:CreateDropdown({
        Name = 'Premade Face',
        Options = premadeOptions,
        CurrentOption = {'Custom'},
        Flag = 'face_premade',
        Callback = function() end
    })
    local FaceTexture = render:CreateInput({
        Name = 'Face Texture',
        Flag = 'face_texture',
        PlaceholderText = 'rbxassetid://111858682543206',
        CurrentValue = 'rbxassetid://111858682543206',
        Callback = function() end
    })

    local billboard = Instance.new('BillboardGui')
    billboard.Name = 'face'
    billboard.Size = UDim2.new(2.4000001, 0, 1.90000045, 0)
    billboard.StudsOffset = Vector3.new(0, -0.10000000149011612, 0.6100000143051147)
    billboard.AlwaysOnTop = true
    billboard.ResetOnSpawn = false

    local image = Instance.new('ImageLabel')
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundTransparency = 1
    image.Parent = billboard

    cleanup.add(runService.RenderStepped:Connect(function()
        pcall(function()
            if not lplr.ball then
                billboard.Parent = nil
                return
            end
            if Face.CurrentValue then
                local selected = FacePremade.CurrentOption[1]
                local tex = (selected ~= 'Custom' and premadeLookup[selected] ~= '')
                    and premadeLookup[selected]
                    or FaceTexture.CurrentValue
                image.Image = tex
                image.ImageTransparency = lplr.ball.Transparency
                if billboard.Parent ~= lplr.ball then
                    billboard.Parent = lplr.ball
                end
            else
                billboard.Parent = nil
            end
        end)
    end))
end)

runFunction(function()
    render:CreateDivider()

    local snowballs = {}
    local active = false

    local SnowToggle = render:CreateToggle({
        Name = 'Snowflakes',
        CurrentValue = false,
        Flag = 'snow_toggle',
        Callback = function(val)
            active = val
            if not val then
                for _, b in ipairs(snowballs) do
                    pcall(function() b:Destroy() end)
                end
                snowballs = {}
            end
        end
    })
    local SnowAmount = render:CreateSlider({
        Name = 'Amount', Range = {1, 200}, Increment = 1, Suffix = '',
        CurrentValue = 80, Flag = 'snow_amount', Callback = function() end
    })
    local SnowSize = render:CreateSlider({
        Name = 'Size', Range = {1, 20}, Increment = 0.1, Suffix = '',
        CurrentValue = 1, Flag = 'snow_size', Callback = function() end
    })
    local SnowSpeed = render:CreateSlider({
        Name = 'Speed', Range = {1, 50}, Increment = 0.1, Suffix = '',
        CurrentValue = 6, Flag = 'snow_speed', Callback = function() end
    })
    local SnowDrift = render:CreateSlider({
        Name = 'Drift Strength', Range = {0, 5}, Increment = 0.01, Suffix = '',
        CurrentValue = 0.3, Flag = 'snow_drift', Callback = function() end
    })
    local SnowTransparency = render:CreateSlider({
        Name = 'Transparency', Range = {0, 1}, Increment = 0.01, Suffix = '',
        CurrentValue = 0, Flag = 'snow_transparency', Callback = function() end
    })
    local SnowSpread = render:CreateSlider({
        Name = 'Spread', Range = {10, 500}, Increment = 1, Suffix = '',
        CurrentValue = 150, Flag = 'snow_spread', Callback = function() end
    })
    local SnowHeight = render:CreateSlider({
        Name = 'Spawn Height', Range = {10, 300}, Increment = 1, Suffix = '',
        CurrentValue = 100, Flag = 'snow_height', Callback = function() end
    })
    local SnowColorMode = render:CreateDropdown({
        Name = 'Color Mode', Options = {'White', 'Rainbow', 'Color Picker'},
        CurrentOption = {'White'}, Flag = 'snow_color_mode', Callback = function() end
    })
    local SnowColorPicker = render:CreateColorPicker({
        Name = 'Snow Color', Color = Color3.fromRGB(255, 255, 255),
        Flag = 'snow_color_picker', Callback = function() end
    })
    local SnowMaterial = render:CreateDropdown({
        Name = 'Material', Options = {'SmoothPlastic', 'Neon', 'Glass', 'Ice', 'ForceField'},
        CurrentOption = {'SmoothPlastic'}, Flag = 'snow_material', Callback = function() end
    })

    local function getOrigin()
        if lplr.rootPart then return lplr.rootPart.Position end
        return Vector3.new(0, 0, 0)
    end

    local function spawnBall()
        local origin = getOrigin()
        local spread = SnowSpread.CurrentValue
        local height = SnowHeight.CurrentValue
        local ball = Instance.new('Part')
        ball.Shape = Enum.PartType.Ball
        local s = SnowSize.CurrentValue * (0.5 + math.random() * 1.0)
        ball.Size = Vector3.new(s, s, s)
        ball.Anchored = true
        ball.CanCollide = false
        ball.CastShadow = false
        ball.Transparency = SnowTransparency.CurrentValue
        pcall(function() ball.Material = Enum.Material[SnowMaterial.CurrentOption[1]] end)
        ball.Color = Color3.fromRGB(255, 255, 255)
        ball.Position = Vector3.new(
            origin.X + math.random(-spread, spread),
            origin.Y + height + math.random(0, 40),
            origin.Z + math.random(-spread, spread)
        )
        ball.Parent = workspace
        return ball
    end

    local function syncCount()
        local target = SnowAmount.CurrentValue
        while #snowballs < target do
            table.insert(snowballs, spawnBall())
        end
        while #snowballs > target do
            local b = table.remove(snowballs)
            pcall(function() b:Destroy() end)
        end
    end

    cleanup.add(runService.Heartbeat:Connect(function(dt)
        if not active then return end
        syncCount()
        local origin = getOrigin()
        local mode = SnowColorMode.CurrentOption[1]
        local spread = SnowSpread.CurrentValue
        local height = SnowHeight.CurrentValue
        for _, b in ipairs(snowballs) do
            pcall(function()
                local speed = SnowSpeed.CurrentValue * (0.8 + b.Size.X * 0.2)
                local drift = math.sin(tick() + b.Position.X * 0.5) * SnowDrift.CurrentValue
                b.Position = Vector3.new(
                    b.Position.X + drift * dt,
                    b.Position.Y - speed * dt,
                    b.Position.Z
                )
                b.Transparency = SnowTransparency.CurrentValue
                pcall(function() b.Material = Enum.Material[SnowMaterial.CurrentOption[1]] end)
                if mode == 'Rainbow' then
                    b.Color = returnRainbow()
                elseif mode == 'Color Picker' then
                    b.Color = SnowColorPicker.Color
                else
                    b.Color = Color3.fromRGB(255, 255, 255)
                end
                if b.Position.Y < origin.Y - 20 then
                    local s = SnowSize.CurrentValue * (0.5 + math.random() * 1.0)
                    b.Size = Vector3.new(s, s, s)
                    b.Position = Vector3.new(
                        origin.X + math.random(-spread, spread),
                        origin.Y + height + math.random(0, 40),
                        origin.Z + math.random(-spread, spread)
                    )
                end
            end)
        end
    end))
end)

runFunction(function()
    render:CreateDivider()

    local axeClone = nil
    local ballClone = nil
    local partData = {}
    local cloneParts = {}

    local getAllParts = function(root)
        local t = {}
        if root:IsA('BasePart') then t[#t+1] = root end
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA('BasePart') then t[#t+1] = d end
        end
        return t
    end

    local setHatTransparency = function(val)
        local hat = lplr.visuals and lplr.visuals:FindFirstChild('Hat')
        if not hat then return end
        for _, part in ipairs(getAllParts(hat)) do
            pcall(function() part.Transparency = val end)
        end
    end

    local buildClones = function()
        if not lplr.model or not lplr.axe or not lplr.ball then return end
        local axeSource = lplr.axe
        local handleSource = axeSource:FindFirstChild('handle')
        if not handleSource then return end

        partData = {}
        cloneParts = {}

        for _, part in ipairs(getAllParts(axeSource)) do
            partData[#partData+1] = {
                name   = part.Name,
                relPos = handleSource.CFrame:PointToObjectSpace(part.Position),
                relRot = handleSource.CFrame:ToObjectSpace(part.CFrame) - handleSource.CFrame:ToObjectSpace(part.CFrame).Position,
            }
        end

        if axeClone then axeClone:Destroy() end
        axeClone = axeSource:Clone()
        axeClone.Parent = workspace
        for _, part in ipairs(getAllParts(axeClone)) do
            part.Anchored = true
            part.CanCollide = false
            part.CastShadow = false
            if part.Name == 'handle' then
                part.Color = Color3.fromRGB(159, 137, 103)
            else
                part.Color = Color3.fromRGB(163, 162, 165)
            end
        end
        for _, d in ipairs(axeClone:GetDescendants()) do
            if d:IsA('Trail') or d:IsA('ParticleEmitter') or d:IsA('Decal') or d:IsA('Texture') or d:IsA('SpecialMesh') then
                d:Destroy()
            end
        end
        local hitHitbox = axeClone:FindFirstChild('hitHitbox', true)
        if hitHitbox then hitHitbox:Destroy() end
        for _, part in ipairs(getAllParts(axeClone)) do
            cloneParts[part.Name] = part
        end

        if ballClone then ballClone:Destroy() end
        ballClone = lplr.ball:Clone()
        for _, child in ipairs(ballClone:GetChildren()) do child:Destroy() end
        for _, d in ipairs(ballClone:GetDescendants()) do
            if d:IsA('Decal') or d:IsA('Texture') or d:IsA('SpecialMesh') then
                d:Destroy()
            end
        end
        ballClone.Anchored = true
        ballClone.CanCollide = false
        ballClone.CastShadow = false
        ballClone.Material = Enum.Material.Plastic
        ballClone.Color = Color3.fromRGB(255, 124, 119)
        ballClone.Parent = workspace
    end

    local destroyClones = function()
        if axeClone then axeClone:Destroy() axeClone = nil end
        if ballClone then ballClone:Destroy() ballClone = nil end
        partData = {}
        cloneParts = {}
        setHatTransparency(0)
    end

    local BallAndAxe = render:CreateToggle({
        Name = "Ball and Axe",
        CurrentValue = false,
        Flag = "ball_and_axe",
        Callback = function(val)
            if val then buildClones() else destroyClones() end
        end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not BallAndAxe.CurrentValue then return end

        if not axeClone or not axeClone.Parent or not ballClone or not ballClone.Parent then
            buildClones()
            return
        end

        if not lplr.ball then return end

        local ballTransparency = lplr.ball.Transparency

        setHatTransparency(1)

        local base = lplr.ball.Size
        ballClone.Size = Vector3.new(base.X - 1.6338, base.Y - 1.35, base.Z - 1.6338)
        ballClone.CFrame = CFrame.new(lplr.ball.Position + Vector3.new(0.2, 1.6, 0))
            * CFrame.Angles(0, 0, math.rad(-11.1549))
        ballClone.Transparency = ballTransparency

        local rootCFrame = CFrame.new(lplr.ball.Position + Vector3.new(-0.6, 2.3, 0))
            * CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-51.7183))

        for _, data in ipairs(partData) do
            local clonePart = cloneParts[data.name]
            if clonePart then
                clonePart.Transparency = ballTransparency
                if data.name == 'handle' then
                    clonePart.Size = Vector3.new(0.10999999940395355, 1.899999976158142, 0.18999959528446198)
                else
                    clonePart.Size = Vector3.new(0.6000000238418579, 0.30000001192092896, 0.18999962508678436)
                end
                local extraOffset = data.name == 'handle' and Vector3.new(0, 0.77, 0) or Vector3.zero
                clonePart.CFrame = rootCFrame
                    * CFrame.new(data.relPos + extraOffset)
                    * CFrame.fromMatrix(Vector3.zero, data.relRot.XVector, data.relRot.YVector, data.relRot.ZVector)
            end
        end
    end))

    cleanup.add({ Destroy = function() destroyClones() end })
end)

Rayfield:LoadConfiguration()
