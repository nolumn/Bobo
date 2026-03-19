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
local virtualInputManager = cloneref(game:GetService('VirtualInputManager'))
local userInputService = cloneref(game:GetService('UserInputService'))
local runService = cloneref(game:GetService('RunService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local serverStorage = cloneref(game:GetService('ServerStorage'))
local lighting = cloneref(game:GetService('Lighting'))
local marketplaceService = cloneref(game:GetService('MarketplaceService'))
local teleportService = cloneref(game:GetService('TeleportService'))
local guiService = cloneref(game:GetService('GuiService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local inputService = cloneref(game:GetService('UserInputService'))
local soundService = cloneref(game:GetService('SoundService'))
local chatService = cloneref(game:GetService('Chat'))
local textChatService = cloneref(game:GetService('TextChatService'))
local groupService = cloneref(game:GetService('GroupService'))
local badgeService = cloneref(game:GetService('BadgeService'))
local dataStoreService = cloneref(game:GetService('DataStoreService'))
local pathfindingService = cloneref(game:GetService('PathfindingService'))
local physicsService = cloneref(game:GetService('PhysicsService'))
local selectionService = cloneref(game:GetService('Selection'))
local starterGui = cloneref(game:GetService('StarterGui'))
local debris = cloneref(game:GetService('Debris'))
local coreGui = cloneref(game:GetService('CoreGui'))
local statsService = cloneref(game:GetService('Stats'))
local keyframeSequenceProvider = cloneref(game:GetService('KeyframeSequenceProvider'))
local animationProvider = cloneref(game:GetService('AnimationClipProvider'))
local localizationService = cloneref(game:GetService('LocalizationService'))
local assetService = cloneref(game:GetService('AssetService'))
local hapticService = cloneref(game:GetService('HapticService'))
local gamepadService = cloneref(game:GetService('GamepadService'))

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

-- maybe glitch?? idk
if not isfolder('boba') then
    makefolder('boba')
end
if not isfolder('boba/'..tostring(game.PlaceId)) then
    makefolder('boba/'..tostring(game.PlaceId))
end

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
  [0] = 'n',
  [1] = 'A',
  [2] = 'b',
  [3] = 'E',
  [4] = 'NVN',
  [5] = '3',
  [6] = '.',
  [7] = 'K99',
  [8] = '2',
  [9] = 'na',
})

local Window = Rayfield:CreateWindow({
    Name = "bobo",
    Icon = 10794036784,
    LoadingTitle = 'bobo',
    LoadingSubtitle = "by inner",
    ShowText = "bobo",
    Theme = 'Default',
    ToggleUIKeybind = "G",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = 'boba',
        FileName = tostring(game.PlaceId)..'/CONFIG_SAVE_'..tostring(new)
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
            Image = ico or 8964489619,
        })
    end
end

local blatant = Window:CreateTab("Blatant", "swords")
local render = Window:CreateTab("Render", "palette")
local tools = Window:CreateTab("Tools", "wrench")
local world = Window:CreateTab("World", "globe")

runFunction(function()
    local Reach = blatant:CreateToggle({
        Name = "Reach",
        CurrentValue = false,
        Flag = "reach",
        Callback = function() end
    })
    local ReachSlider = blatant:CreateSlider({
        Name = "Reach Range",
        Range = {3, 100},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 15,
        Flag = "reach_range",
        Callback = function() end
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
        Name = "NoHammerPull",
        CurrentValue = false,
        Flag = "no_hammer_pull",
        Callback = function() end
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
        Name = "Weightless",
        CurrentValue = false,
        Flag = "weightless",
        Callback = function() end
    })
    local WeightlessSlider = blatant:CreateSlider({
        Name = "Weight Lightness",
        Range = {1, 200},
        Increment = 1,
        Suffix = "",
        CurrentValue = 70,
        Flag = "weightless_lightness",
        Callback = function() end
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
        Name = "HammerOnly",
        CurrentValue = false,
        Flag = "hammer_only",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.ball then
            lplr.ball.Transparency = HammerOnly.CurrentValue and 1 or lplr.ball.Transparency
            lplr.ball.CanCollide = not HammerOnly.CurrentValue
        end
    end))
end)

runFunction(function()
    blatant:CreateDivider()
    local saved = {}
    local initialized = false
    local NoCollision = blatant:CreateToggle({
        Name = "NoCollision",
        CurrentValue = false,
        Flag = "no_collision",
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
        Name = "Slipperiness",
        CurrentValue = false,
        Flag = "slipperiness",
        Callback = function() end
    })

    local DensitySlider = blatant:CreateSlider({
        Name = "Density",
        Range = {0, 100},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.01,
        Flag = "slip_density",
        Callback = function() end
    })
    local FrictionSlider = blatant:CreateSlider({
        Name = "Friction",
        Range = {0, 100},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0,
        Flag = "slip_friction",
        Callback = function() end
    })
    local ElasticitySlider = blatant:CreateSlider({
        Name = "Elasticity",
        Range = {0, 1},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.9999,
        Flag = "slip_elasticity",
        Callback = function() end
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
                        DensitySlider.CurrentValue,
                        FrictionSlider.CurrentValue,
                        ElasticitySlider.CurrentValue,
                        0, 1
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

    local clearTrajectory = function()
        for _, p in ipairs(trajectoryParts) do p:Destroy() end
        trajectoryParts = {}
    end

    local get2DDistance = function()
        if not lplr.ball then return 0 end
        local screenPos, onScreen = lplr.camera:WorldToScreenPoint(lplr.ball.Position)
        if not onScreen then return 0 end
        return (Vector2.new(mouse.X, mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
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
        local target = mouse.Hit.Position
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
        Name = "Show Pogo Projectile",
        CurrentValue = true,
        Flag = "pogo_projectile",
        Callback = function(val)
            if not val then clearTrajectory() end
        end
    })
    local ProjectileModeDropdown = blatant:CreateDropdown({
        Name = "Projectile Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'},
        Flag = "pogo_projectile_mode",
        Callback = function() end
    })
    local ProjectileColorPicker = blatant:CreateColorPicker({
        Name = "Projectile Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "pogo_projectile_color",
        Callback = function() end
    })

    local Pogo = blatant:CreateToggle({
        Name = "Pogo (Space)",
        CurrentValue = false,
        Flag = "pogo",
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
end)

runFunction(function()
    local oldColor = nil
    local oldMaterial = nil

    local BallToggle = render:CreateToggle({
        Name = "Ball Color",
        CurrentValue = false,
        Flag = "rainbow_ball",
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
        Name = "Ball Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'},
        Flag = "ball_color_mode",
        Callback = function() end
    })
    local BallColorPicker = render:CreateColorPicker({
        Name = "Ball Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "ball_color_picker",
        Callback = function() end
    })
    local BallMaterialDropdown = render:CreateDropdown({
        Name = "Ball Material",
        Options = {
            'Plastic', 'SmoothPlastic', 'Neon', 'Metal', 'Wood', 'WoodPlanks',
            'Marble', 'Granite', 'Brick', 'Cobblestone', 'Concrete', 'CorrodedMetal',
            'DiamondPlate', 'Foil', 'Grass', 'Ice', 'Pebble', 'Sand', 'Fabric',
            'Glass', 'ForceField', 'Slate', 'Sandstone', 'Basalt', 'Glacier',
            'Ground', 'LeafyGrass', 'Limestone', 'Mud', 'Pavement', 'Rock',
            'Salt', 'Snow', 'Asphalt', 'CrackedLava'
        },
        CurrentOption = {'Plastic'},
        Flag = "ball_material",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.ball and BallToggle.CurrentValue then
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
        Name = "Axe Color",
        CurrentValue = false,
        Flag = "rainbow_axe",
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
        Name = "Axe Tip Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'},
        Flag = "axe_tip_mode",
        Callback = function() end
    })
    local AxeTipColorPicker = render:CreateColorPicker({
        Name = "Axe Tip Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "axe_tip_color_picker",
        Callback = function() end
    })
    local AxeTipMaterialDropdown = render:CreateDropdown({
        Name = "Axe Tip Material",
        Options = {
            'Plastic', 'SmoothPlastic', 'Neon', 'Metal', 'Wood', 'WoodPlanks',
            'Marble', 'Granite', 'Brick', 'Cobblestone', 'Concrete', 'CorrodedMetal',
            'DiamondPlate', 'Foil', 'Grass', 'Ice', 'Pebble', 'Sand', 'Fabric',
            'Glass', 'ForceField', 'Slate', 'Sandstone', 'Basalt', 'Glacier',
            'Ground', 'LeafyGrass', 'Limestone', 'Mud', 'Pavement', 'Rock',
            'Salt', 'Snow', 'Asphalt', 'CrackedLava'
        },
        CurrentOption = {'Plastic'},
        Flag = "axe_tip_material",
        Callback = function() end
    })
    local AxeHandleModeDropdown = render:CreateDropdown({
        Name = "Axe Handle Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'},
        Flag = "axe_handle_mode",
        Callback = function() end
    })
    local AxeHandleColorPicker = render:CreateColorPicker({
        Name = "Axe Handle Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "axe_handle_color_picker",
        Callback = function() end
    })
    local AxeHandleMaterialDropdown = render:CreateDropdown({
        Name = "Axe Handle Material",
        Options = {
            'Plastic', 'SmoothPlastic', 'Neon', 'Metal', 'Wood', 'WoodPlanks',
            'Marble', 'Granite', 'Brick', 'Cobblestone', 'Concrete', 'CorrodedMetal',
            'DiamondPlate', 'Foil', 'Grass', 'Ice', 'Pebble', 'Sand', 'Fabric',
            'Glass', 'ForceField', 'Slate', 'Sandstone', 'Basalt', 'Glacier',
            'Ground', 'LeafyGrass', 'Limestone', 'Mud', 'Pavement', 'Rock',
            'Salt', 'Snow', 'Asphalt', 'CrackedLava'
        },
        CurrentOption = {'Plastic'},
        Flag = "axe_handle_material",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if lplr.axe and AxeToggle.CurrentValue then
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
        Name = "NoDebris",
        CurrentValue = false,
        Flag = "no_debris",
        Callback = function() end
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
        Name = "NoIndicator",
        CurrentValue = false,
        Flag = "no_indicator",
        Callback = function() end
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
        Name = "IndicatorColor",
        CurrentValue = false,
        Flag = "indicator_color",
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
        Name = "Indicator Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'},
        Flag = "indicator_color_mode",
        Callback = function() end
    })
    local IndicatorColorPicker = render:CreateColorPicker({
        Name = "Indicator Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "indicator_color_picker",
        Callback = function() end
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
        Name = "FOVModifier",
        CurrentValue = false,
        Flag = "fov_modifier",
        Callback = function() end
    })
    local FOVSlider = render:CreateSlider({
        Name = "FOV Value",
        Range = {30, 120},
        Increment = 1,
        Suffix = "%",
        CurrentValue = 90,
        Flag = "fov_value",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        lplr.camera.FieldOfView = FOVModifier.CurrentValue and FOVSlider.CurrentValue or 70
    end))
end)

runFunction(function()
    render:CreateDivider()
    local CameraZoom = render:CreateToggle({
        Name = "CameraZoom",
        CurrentValue = false,
        Flag = "camera_zoom",
        Callback = function() end
    })
    local CameraZoomSlider = render:CreateSlider({
        Name = "Camera Zoom Value",
        Range = {-5, 70},
        Increment = 0.01,
        Suffix = "%",
        CurrentValue = 5,
        Flag = "camera_zoom_value",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        local cf = lplr.camera.shakeCF.Value
        lplr.camera.shakeCF.Value = CFrame.new(cf.Position.X, cf.Position.Y, CameraZoom.CurrentValue and CameraZoomSlider.CurrentValue or 0)
    end))
end)

runFunction(function()
    local velocity = Vector3.new(0, 0, 0)
    local targetVelocity = Vector3.new(0, 0, 0)
    local mobileMove = Vector3.new(0, 0, 0)

    local Fly = tools:CreateToggle({
        Name = "Fly",
        CurrentValue = false,
        Flag = "fly",
        Callback = function(val)
            if lplr.ball then lplr.ball.Anchored = val end
            if not val then
                velocity = Vector3.new(0, 0, 0)
                targetVelocity = Vector3.new(0, 0, 0)
                mobileMove = Vector3.new(0, 0, 0)
            end
        end
    })
    local FlySpeedSlider = tools:CreateSlider({
        Name = "Fly Speed",
        Range = {1, 50},
        Increment = 1,
        Suffix = "",
        CurrentValue = 10,
        Flag = "fly_speed",
        Callback = function() end
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
        Name = "HandleFocus",
        CurrentValue = false,
        Flag = "handle_focus",
        Callback = function() end
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
        Name = "HandleCollide",
        CurrentValue = false,
        Flag = "handle_collide",
        Callback = function() end
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
        Name = "NoHitSound",
        CurrentValue = false,
        Flag = "no_hit_sound",
        Callback = function() end
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
        Name = "GravityModifier",
        CurrentValue = false,
        Flag = "gravity_modifier",
        Callback = function() end
    })
    local GravitySlider = world:CreateSlider({
        Name = "Gravity Value",
        Range = {5, 150},
        Increment = 0.1,
        Suffix = "%",
        CurrentValue = 30,
        Flag = "gravity_value",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        workspace.Gravity = GravityModifier.CurrentValue and GravitySlider.CurrentValue or 50
    end))
end)

runFunction(function()
    world:CreateDivider()
    local TimeChanger = world:CreateToggle({
        Name = "TimeChanger",
        CurrentValue = false,
        Flag = "time_changer",
        Callback = function() end
    })
    local TimeSlider = world:CreateSlider({
        Name = "Clock Time",
        Range = {0, 24},
        Increment = 0.1,
        Suffix = "",
        CurrentValue = 14,
        Flag = "time_changer_value",
        Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        lighting.ClockTime = TimeChanger.CurrentValue and TimeSlider.CurrentValue or 14
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
        Name = "HammerTrail",
        CurrentValue = false,
        Flag = "hammer_trail",
        Callback = function() end
    })
    local TrailModeDropdown = render:CreateDropdown({
        Name = "Trail Color Mode",
        Options = {'Rainbow', 'Color Picker', 'Ball Color'},
        CurrentOption = {'Rainbow'},
        Flag = "trail_color_mode",
        Callback = function() end
    })
    local TrailColorPicker = render:CreateColorPicker({
        Name = "Trail Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "trail_color_picker",
        Callback = function() end
    })
    local TrailShapeDropdown = render:CreateDropdown({
        Name = "Trail Shape",
        Options = {'Triangle', 'Square'},
        CurrentOption = {'Triangle'},
        Flag = "trail_shape",
        Callback = function() end
    })
    local TrailThicknessSlider = render:CreateSlider({
        Name = "Trail Thickness",
        Range = {0, 3},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.5,
        Flag = "trail_thickness",
        Callback = function() end
    })
    local TrailLifetimeSlider = render:CreateSlider({
        Name = "Trail Length",
        Range = {0, 5},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.5,
        Flag = "trail_lifetime",
        Callback = function() end
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
        Name = "DebrisTexture",
        CurrentValue = false,
        Flag = "debris_texture",
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
        Name = "Texture ID",
        PlaceholderText = "rbxassetid://377156649 or file path",
        RemoveTextAfterFocusLost = false,
        Flag = "debris_texture_id",
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
        Name = "Debris Size",
        Range = {0, 5},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.15,
        Flag = "debris_size",
        Callback = function() end
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

    local BacktrackBind = blatant:CreateKeybind({
        Name = "Backtrack",
        CurrentKeybind = "Q",
        HoldToInteract = false,
        Flag = "backtrack_key",
        Callback = function()
            if #history == 0 then return end
            backtracking = true
            task.spawn(function()
                for i = #history, 1, -1 do
                    if not lplr.model then break end
                    lplr.model:PivotTo(history[i].cf)
                    if lplr.ball then
                        local bv = Instance.new('BodyVelocity')
                        bv.Velocity = history[i].vel
                        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                        bv.P = math.huge
                        bv.Parent = lplr.ball
                        task.delay(0.05, function() bv:Destroy() end)
                    end
                    task.wait(0.03)
                end
                backtracking = false
                history = {}
            end)
        end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if backtracking then return end
        if lplr.model and lplr.ball then
            table.insert(history, {
                cf = lplr.model:GetPivot(),
                vel = lplr.ball.AssemblyLinearVelocity
            })
            if #history > maxHistory then
                table.remove(history, 1)
            end
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
        Name = "BallTrail",
        CurrentValue = false,
        Flag = "ball_trail",
        Callback = function() end
    })
    local BallTrailModeDropdown = render:CreateDropdown({
        Name = "Ball Trail Color Mode",
        Options = {'Rainbow', 'Color Picker', 'Ball Color'},
        CurrentOption = {'Rainbow'},
        Flag = "ball_trail_color_mode",
        Callback = function() end
    })
    local BallTrailColorPicker = render:CreateColorPicker({
        Name = "Ball Trail Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "ball_trail_color_picker",
        Callback = function() end
    })
    local BallTrailShapeDropdown = render:CreateDropdown({
        Name = "Ball Trail Shape",
        Options = {'Triangle', 'Square'},
        CurrentOption = {'Triangle'},
        Flag = "ball_trail_shape",
        Callback = function() end
    })
    local BallTrailThicknessSlider = render:CreateSlider({
        Name = "Ball Trail Thickness",
        Range = {0, 3},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.5,
        Flag = "ball_trail_thickness",
        Callback = function() end
    })
    local BallTrailLifetimeSlider = render:CreateSlider({
        Name = "Ball Trail Length",
        Range = {0, 5},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.5,
        Flag = "ball_trail_lifetime",
        Callback = function() end
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
        Name = "SkyboxChanger",
        CurrentValue = false,
        Flag = "skybox_changer",
        Callback = function(val)
            if val then
                sky = Instance.new('Sky')
                sky.Parent = lighting
            else
                if sky then sky:Destroy() sky = nil end
            end
        end
    })

    local faces = {'SkyboxBk', 'SkyboxDn', 'SkyboxFt', 'SkyboxLf', 'SkyboxRt', 'SkyboxUp'}
    local inputs = {}
    for _, face in ipairs(faces) do
        inputs[face] = world:CreateInput({
            Name = face,
            PlaceholderText = "rbxassetid://...",
            RemoveTextAfterFocusLost = false,
            Flag = "skybox_"..face:lower(),
            Callback = function(val)
                if sky and val ~= '' then
                    pcall(function() sky[face] = val end)
                end
            end
        })
    end
end)

runFunction(function()
    tools:CreateDivider()
    local savedTransparencies = {}

    local HideOthers = tools:CreateToggle({
        Name = "HideOthers",
        CurrentValue = false,
        Flag = "hide_others",
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
                    pcall(function()
                        particles.Transparency = NumberSequence.new(1)
                    end)
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
        Name = "CustomTimer",
        CurrentValue = false,
        Flag = "timer_color",
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
        Name = "Timer Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'},
        Flag = "timer_color_mode",
        Callback = function() end
    })

    local TimerColorPicker = render:CreateColorPicker({
        Name = "Timer Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "timer_color_picker",
        Callback = function() end
    })

    local TimerFontDropdown = render:CreateDropdown({
        Name = "Timer Font",
        Options = {
            'Legacy', 'Arial', 'ArialBold', 'SourceSans', 'SourceSansBold',
            'SourceSansSemibold', 'SourceSansItalic', 'SourceSansLight',
            'SourceSansExtraLight', 'Bodoni', 'Highway', 'SciFi', 'Cartoon',
            'Code', 'Fantasy', 'Antique', 'Gotham', 'GothamBold',
            'GothamBlack', 'GothamMedium', 'GothamLight', 'AmaticSC',
            'Bangers', 'Creepster', 'DenkOne', 'Fondamento', 'FredokaOne',
            'GrenzeGotisch', 'IndieFlower', 'JosefinSans', 'Jura',
            'KoHo', 'Kumbhsans', 'Mali', 'NotoSans', 'Nunito',
            'Oswald', 'PatrickHand', 'PermanentMarker', 'Roboto',
            'RobotoCondensed', 'RobotoMono', 'Sarpanch', 'SpecialElite',
            'TitilliumWeb', 'Ubuntu'
        },
        CurrentOption = {'TitilliumWeb'},
        Flag = "timer_font",
        Callback = function() end
    })

    local TimerBGTransparencySlider = render:CreateSlider({
        Name = "Background Transparency",
        Range = {0, 1},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 0.3,
        Flag = "timer_bg_transparency",
        Callback = function() end
    })

    local TimerCornerToggle = render:CreateToggle({
        Name = "Corner Radius",
        CurrentValue = false,
        Flag = "timer_corner",
        Callback = function(val)
            if not val then
                if uiCorner then uiCorner:Destroy() uiCorner = nil end
            end
        end
    })

    local TimerCornerSlider = render:CreateSlider({
        Name = "Corner Radius Value",
        Range = {0, 50},
        Increment = 1,
        Suffix = "",
        CurrentValue = 8,
        Flag = "timer_corner_value",
        Callback = function() end
    })

    local TimerStrokeToggle = render:CreateToggle({
        Name = "Border Stroke",
        CurrentValue = false,
        Flag = "timer_uistroke",
        Callback = function(val)
            if not val then
                if uiStroke then uiStroke:Destroy() uiStroke = nil end
            end
        end
    })

    local TimerStrokeModeDropdown = render:CreateDropdown({
        Name = "Stroke Color Mode",
        Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Color Picker'},
        Flag = "timer_uistroke_mode",
        Callback = function() end
    })

    local TimerStrokeColorPicker = render:CreateColorPicker({
        Name = "Stroke Color",
        Color = Color3.fromRGB(255, 255, 255),
        Flag = "timer_uistroke_color",
        Callback = function() end
    })

    local TimerStrokeThicknessSlider = render:CreateSlider({
        Name = "Stroke Thickness",
        Range = {1, 10},
        Increment = 0.1,
        Suffix = "",
        CurrentValue = 2,
        Flag = "timer_uistroke_thickness",
        Callback = function() end
    })

    local TimerScaleToggle = render:CreateToggle({
        Name = "TimerScale",
        CurrentValue = false,
        Flag = "timer_scale",
        Callback = function(val)
            if not val then
                if uiScale then uiScale:Destroy() uiScale = nil end
            end
        end
    })

    local TimerScaleSlider = render:CreateSlider({
        Name = "Timer Scale",
        Range = {0.1, 5},
        Increment = 0.01,
        Suffix = "",
        CurrentValue = 1,
        Flag = "timer_scale_value",
        Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not TimerToggle.CurrentValue then return end

        local t = getTimer()
        local frame = getTimerFrame()

        if t then
            local color = TimerColorModeDropdown.CurrentOption[1] == 'Rainbow' and returnRainbow() or TimerColorPicker.Color
            t.TextColor3 = color
            t.TextScaled = true
            pcall(function()
                t.FontFace = Font.fromEnum(Enum.Font[TimerFontDropdown.CurrentOption[1]])
            end)
        end

        if frame then
            frame.BackgroundTransparency = TimerBGTransparencySlider.CurrentValue

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
        end
    end))
end)
