-- This is the lite version for 1242235469.
-- The difference between lite and the main script is that lite only has LEGIT features (features that don't intercept with how you play the game.)
-- For E.G: Fly, Pogo, Walking, ETC.

if shared.garbage then
    for _, obj in ipairs(shared.garbage) do
        pcall(function() obj:Disconnect() end)
        pcall(function() obj:Destroy() end)
        obj = nil
    end
end
shared.garbage = {}
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

local Window = Rayfield:CreateWindow({
    Name = "bobo lite",
    Icon = libstuff.ico[math.random(1, #libstuff.ico)] or 16547078391,
    LoadingTitle = 'bobo lite',
    LoadingSubtitle = "by "..table.concat(libstuff['developers'], ', ') or 'inner',
    ShowText = "bobo lite",
    Theme = 'Light',
    ToggleUIKeybind = libstuff['toggle'],
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = 'boba',
        FileName = tostring(game.PlaceId)..'_lite'
    }
})

local returnRainbow = function()
    return Color3.fromHSV(tick() % 5 / 5, 0.7, 1)
end
local notif = function(title, desc, dur, ico)
    if dur then
        Rayfield:Notify({
            Title = title or 'bobo lite',
            Content = desc,
            Duration = dur or 3,
            Image = ico or libstuff.ico[math.random(1, #libstuff.ico)] or 16547078391,
        })
    end
end
local sharedState = {
    spectating = false
}

local render = Window:CreateTab("Render", "palette")
local tools = Window:CreateTab("Tools", "wrench")
local world = Window:CreateTab("World", "globe")

runFunction(function()
    local oldColor = nil
    local oldMaterial = nil

    local BallToggle = render:CreateToggle({
        Name = "Ball Color", CurrentValue = false, Flag = "lite_rainbow_ball",
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
        CurrentOption = {'Rainbow'}, Flag = "lite_ball_color_mode", Callback = function() end
    })
    local BallColorPicker = render:CreateColorPicker({
        Name = "Ball Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_ball_color_picker", Callback = function() end
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
        CurrentOption = {'Plastic'}, Flag = "lite_ball_material", Callback = function() end
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
        Name = "Axe Color", CurrentValue = false, Flag = "lite_rainbow_axe",
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
        CurrentOption = {'Rainbow'}, Flag = "lite_axe_tip_mode", Callback = function() end
    })
    local AxeTipColorPicker = render:CreateColorPicker({
        Name = "Axe Tip Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_axe_tip_color_picker", Callback = function() end
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
        CurrentOption = {'Plastic'}, Flag = "lite_axe_tip_material", Callback = function() end
    })
    local AxeHandleModeDropdown = render:CreateDropdown({
        Name = "Axe Handle Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "lite_axe_handle_mode", Callback = function() end
    })
    local AxeHandleColorPicker = render:CreateColorPicker({
        Name = "Axe Handle Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_axe_handle_color_picker", Callback = function() end
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
        CurrentOption = {'Plastic'}, Flag = "lite_axe_handle_material", Callback = function() end
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
        Name = "NoDebris", CurrentValue = false, Flag = "lite_no_debris",
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
        Name = "NoIndicator", CurrentValue = false, Flag = "lite_no_indicator",
        Callback = function(val)
            local ind = workspace:FindFirstChild('ind')
            if ind then ind.Transparency = val and 1 or 0 end
        end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        local ind = workspace:FindFirstChild('ind')
        if ind then ind.Transparency = NoIndicator.CurrentValue and 1 or 0 end
    end))
end)

runFunction(function()
    render:CreateDivider()
    local IndicatorToggle = render:CreateToggle({
        Name = "IndicatorColor", CurrentValue = false, Flag = "lite_indicator_color",
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
        CurrentOption = {'Rainbow'}, Flag = "lite_indicator_color_mode", Callback = function() end
    })
    local IndicatorColorPicker = render:CreateColorPicker({
        Name = "Indicator Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_indicator_color_picker", Callback = function() end
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
        Name = "FOVModifier", CurrentValue = false, Flag = "lite_fov_modifier",
        Callback = function(val)
            if not val then lplr.camera.FieldOfView = 70 end
        end
    })
    local FOVSlider = render:CreateSlider({
        Name = "FOV Value", Range = {30, 120}, Increment = 1, Suffix = "%",
        CurrentValue = 90, Flag = "lite_fov_value", Callback = function() end
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
        Name = "CameraZoom", CurrentValue = false, Flag = "lite_camera_zoom",
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
        CurrentValue = 5.1, Flag = "lite_camera_zoom_value", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if not CameraZoom.CurrentValue then return end
        local shakeCF = workspace.CurrentCamera:FindFirstChild('shakeCF')
        if not shakeCF then return end
        shakeCF.Value = CFrame.new(shakeCF.Value.Position.X, shakeCF.Value.Position.Y, CameraZoomSlider.CurrentValue)
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
        Name = "HammerTrail", CurrentValue = false, Flag = "lite_hammer_trail",
        Callback = function(val) if not val then removeTrail() end end
    })
    local TrailModeDropdown = render:CreateDropdown({
        Name = "Trail Color Mode", Options = {'Rainbow', 'Color Picker', 'Ball Color'},
        CurrentOption = {'Rainbow'}, Flag = "lite_trail_color_mode", Callback = function() end
    })
    local TrailColorPicker = render:CreateColorPicker({
        Name = "Trail Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_trail_color_picker", Callback = function() end
    })
    local TrailShapeDropdown = render:CreateDropdown({
        Name = "Trail Shape", Options = {'Triangle', 'Square'},
        CurrentOption = {'Triangle'}, Flag = "lite_trail_shape", Callback = function() end
    })
    local TrailThicknessSlider = render:CreateSlider({
        Name = "Trail Thickness", Range = {0, 3}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "lite_trail_thickness", Callback = function() end
    })
    local TrailLifetimeSlider = render:CreateSlider({
        Name = "Trail Length", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "lite_trail_lifetime", Callback = function() end
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
    local trail = nil
    local attach0 = nil
    local attach1 = nil

    local removeTrail = function()
        if trail then trail:Destroy() trail = nil end
        if attach0 then attach0:Destroy() attach0 = nil end
        if attach1 then attach1:Destroy() attach1 = nil end
    end

    local BallTrail = render:CreateToggle({
        Name = "BallTrail", CurrentValue = false, Flag = "lite_ball_trail",
        Callback = function(val) if not val then removeTrail() end end
    })
    local BallTrailModeDropdown = render:CreateDropdown({
        Name = "Ball Trail Color Mode", Options = {'Rainbow', 'Color Picker', 'Ball Color'},
        CurrentOption = {'Rainbow'}, Flag = "lite_ball_trail_color_mode", Callback = function() end
    })
    local BallTrailColorPicker = render:CreateColorPicker({
        Name = "Ball Trail Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_ball_trail_color_picker", Callback = function() end
    })
    local BallTrailShapeDropdown = render:CreateDropdown({
        Name = "Ball Trail Shape", Options = {'Triangle', 'Square'},
        CurrentOption = {'Triangle'}, Flag = "lite_ball_trail_shape", Callback = function() end
    })
    local BallTrailThicknessSlider = render:CreateSlider({
        Name = "Ball Trail Thickness", Range = {0, 3}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "lite_ball_trail_thickness", Callback = function() end
    })
    local BallTrailLifetimeSlider = render:CreateSlider({
        Name = "Ball Trail Length", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "lite_ball_trail_lifetime", Callback = function() end
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
        Name = "CustomTimer", CurrentValue = false, Flag = "lite_timer_color",
        Callback = function(val)
            if not val then
                local t = getTimer()
                if t then
                    t.TextColor3 = Color3.fromRGB(255, 255, 255)
                    t.TextScaled = true
                    t.FontFace = defaultFont
                end
                local frame = getTimerFrame()
                if frame then frame.BackgroundTransparency = 0.30000001192092896 end
                if uiScale then uiScale:Destroy() uiScale = nil end
                if uiCorner then uiCorner:Destroy() uiCorner = nil end
                if uiStroke then uiStroke:Destroy() uiStroke = nil end
            end
        end
    })
    local TimerColorModeDropdown = render:CreateDropdown({
        Name = "Timer Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Rainbow'}, Flag = "lite_timer_color_mode", Callback = function() end
    })
    local TimerColorPicker = render:CreateColorPicker({
        Name = "Timer Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_timer_color_picker", Callback = function() end
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
        CurrentOption = {'TitilliumWeb'}, Flag = "lite_timer_font", Callback = function() end
    })
    local TimerBGTransparencySlider = render:CreateSlider({
        Name = "Background Transparency", Range = {0, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.3, Flag = "lite_timer_bg_transparency", Callback = function() end
    })
    local TimerCornerToggle = render:CreateToggle({
        Name = "Corner Radius", CurrentValue = false, Flag = "lite_timer_corner",
        Callback = function(val)
            if not val then if uiCorner then uiCorner:Destroy() uiCorner = nil end end
        end
    })
    local TimerCornerSlider = render:CreateSlider({
        Name = "Corner Radius Value", Range = {0, 50}, Increment = 1, Suffix = "",
        CurrentValue = 8, Flag = "lite_timer_corner_value", Callback = function() end
    })
    local TimerStrokeToggle = render:CreateToggle({
        Name = "Border Stroke", CurrentValue = false, Flag = "lite_timer_uistroke",
        Callback = function(val)
            if not val then if uiStroke then uiStroke:Destroy() uiStroke = nil end end
        end
    })
    local TimerStrokeModeDropdown = render:CreateDropdown({
        Name = "Stroke Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Color Picker'}, Flag = "lite_timer_uistroke_mode", Callback = function() end
    })
    local TimerStrokeColorPicker = render:CreateColorPicker({
        Name = "Stroke Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_timer_uistroke_color", Callback = function() end
    })
    local TimerStrokeThicknessSlider = render:CreateSlider({
        Name = "Stroke Thickness", Range = {1, 10}, Increment = 0.1, Suffix = "",
        CurrentValue = 2, Flag = "lite_timer_uistroke_thickness", Callback = function() end
    })
    local TimerScaleToggle = render:CreateToggle({
        Name = "TimerScale", CurrentValue = false, Flag = "lite_timer_scale",
        Callback = function(val)
            if not val then if uiScale then uiScale:Destroy() uiScale = nil end end
        end
    })
    local TimerScaleSlider = render:CreateSlider({
        Name = "Timer Scale", Range = {0.1, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "lite_timer_scale_value", Callback = function() end
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

    local posFile = 'boba/' .. tostring(game.PlaceId) .. '/speedometer_pos_lite.json'

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
        Name = "Speedometer", CurrentValue = false, Flag = "lite_speedometer",
        Callback = function(val) if val then makeGui() else removeGui() end end
    })
    local SpeedPositionDropdown = render:CreateDropdown({
        Name = "Position", Options = {'Draggable', 'Above Timer'},
        CurrentOption = {'Draggable'}, Flag = "lite_speedometer_position", Callback = function() end
    })
    local SpeedColorLowPicker = render:CreateColorPicker({
        Name = "Low Speed Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_speedometer_color_low", Callback = function() end
    })
    local SpeedColorMidPicker = render:CreateColorPicker({
        Name = "Mid Speed Color", Color = Color3.fromRGB(255, 200, 0),
        Flag = "lite_speedometer_color_mid", Callback = function() end
    })
    local SpeedColorHighPicker = render:CreateColorPicker({
        Name = "High Speed Color", Color = Color3.fromRGB(255, 50, 50),
        Flag = "lite_speedometer_color_high", Callback = function() end
    })
    local SpeedColorMaxSlider = render:CreateSlider({
        Name = "Max Speed (for color)", Range = {10, 200}, Increment = 1, Suffix = "",
        CurrentValue = 80, Flag = "lite_speedometer_max", Callback = function() end
    })
    local SpeedBGTransparencySlider = render:CreateSlider({
        Name = "Background Transparency", Range = {0, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.3, Flag = "lite_speedometer_bg_transparency", Callback = function() end
    })
    local SpeedWidthSlider = render:CreateSlider({
        Name = "Width", Range = {50, 600}, Increment = 1, Suffix = "",
        CurrentValue = 160, Flag = "lite_speedometer_width", Callback = function() end
    })
    local SpeedHeightSlider = render:CreateSlider({
        Name = "Height", Range = {20, 300}, Increment = 1, Suffix = "",
        CurrentValue = 50, Flag = "lite_speedometer_height", Callback = function() end
    })
    local SpeedTextSizeSlider = render:CreateSlider({
        Name = "Text Size", Range = {8, 100}, Increment = 1, Suffix = "",
        CurrentValue = 36, Flag = "lite_speedometer_text_size", Callback = function() end
    })
    local SpeedScaleToggle = render:CreateToggle({
        Name = "UIScale", CurrentValue = false, Flag = "lite_speedometer_scale",
        Callback = function(val) if not val then if uiScale then uiScale.Scale = 1 end end end
    })
    local SpeedScaleSlider = render:CreateSlider({
        Name = "Scale", Range = {0.1, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 1, Flag = "lite_speedometer_scale_value", Callback = function() end
    })
    local SpeedCornerToggle = render:CreateToggle({
        Name = "Corner Radius", CurrentValue = true, Flag = "lite_speedometer_corner",
        Callback = function(val) if not val then if uiCorner then uiCorner:Destroy() uiCorner = nil end end end
    })
    local SpeedCornerSlider = render:CreateSlider({
        Name = "Corner Radius Value", Range = {0, 50}, Increment = 1, Suffix = "",
        CurrentValue = 8, Flag = "lite_speedometer_corner_value", Callback = function() end
    })
    local SpeedStrokeToggle = render:CreateToggle({
        Name = "Border Stroke", CurrentValue = false, Flag = "lite_speedometer_stroke",
        Callback = function(val) if not val then if uiStroke then uiStroke:Destroy() uiStroke = nil end end end
    })
    local SpeedStrokeModeDropdown = render:CreateDropdown({
        Name = "Stroke Color Mode", Options = {'Rainbow', 'Color Picker'},
        CurrentOption = {'Color Picker'}, Flag = "lite_speedometer_stroke_mode", Callback = function() end
    })
    local SpeedStrokeColorPicker = render:CreateColorPicker({
        Name = "Stroke Color", Color = Color3.fromRGB(255, 255, 255),
        Flag = "lite_speedometer_stroke_color", Callback = function() end
    })
    local SpeedStrokeThicknessSlider = render:CreateSlider({
        Name = "Stroke Thickness", Range = {1, 10}, Increment = 0.1, Suffix = "",
        CurrentValue = 2, Flag = "lite_speedometer_stroke_thickness", Callback = function() end
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
        CurrentOption = {'TitilliumWeb'}, Flag = "lite_speedometer_font", Callback = function() end
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
    tools:CreateDivider()
    local NoHitSound = tools:CreateToggle({
        Name = "NoHitSound", CurrentValue = false, Flag = "lite_no_hit_sound",
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
    tools:CreateDivider()
    local savedTransparencies = {}

    local HideOthers = tools:CreateToggle({
        Name = "HideOthers", CurrentValue = false, Flag = "lite_hide_others",
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
        CurrentOption = {getPlayerOptions()[1]}, Flag = "lite_spectate_target", Callback = function() end
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
        CurrentValue = 0.06, Flag = "lite_spectate_smooth", Callback = function() end
    })
    local SpectateOffsetXSlider = tools:CreateSlider({
        Name = "Camera Offset X", Range = {-20, 20}, Increment = 0.1, Suffix = "",
        CurrentValue = 4, Flag = "lite_spectate_offset_x", Callback = function() end
    })
    local SpectateOffsetYSlider = tools:CreateSlider({
        Name = "Camera Offset Y", Range = {-20, 20}, Increment = 0.1, Suffix = "",
        CurrentValue = 3, Flag = "lite_spectate_offset_y", Callback = function() end
    })
    local SpectateOffsetZSlider = tools:CreateSlider({
        Name = "Camera Distance", Range = {-60, -5}, Increment = 0.1, Suffix = "",
        CurrentValue = -20, Flag = "lite_spectate_offset_z", Callback = function() end
    })
    local SpectateFOVSlider = tools:CreateSlider({
        Name = "Spectate FOV", Range = {30, 120}, Increment = 1, Suffix = "",
        CurrentValue = 60, Flag = "lite_spectate_fov", Callback = function() end
    })
    local SpectateVelocityFOVToggle = tools:CreateToggle({
        Name = "Velocity FOV", CurrentValue = false, Flag = "lite_spectate_velocity_fov", Callback = function() end
    })
    local SpectateHammerInfluenceToggle = tools:CreateToggle({
        Name = "Hammer Influence on Camera", CurrentValue = true, Flag = "lite_spectate_hammer_influence", Callback = function() end
    })
    local SpectateHammerStrengthSlider = tools:CreateSlider({
        Name = "Hammer Influence Strength", Range = {0.01, 1}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.15, Flag = "lite_spectate_hammer_strength", Callback = function() end
    })
    local SpectateHammerRotToggle = tools:CreateToggle({
        Name = "Velocity Camera Drift", CurrentValue = false, Flag = "lite_spectate_hammer_rot", Callback = function() end
    })
    local SpectateHammerRotStrengthSlider = tools:CreateSlider({
        Name = "Drift Strength", Range = {0.01, 0.5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.08, Flag = "lite_spectate_hammer_rot_strength", Callback = function() end
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
        Name = "Wall Check", CurrentValue = false, Flag = "lite_spectate_wall_check",
        Callback = function(val) if not val then revertWallParts() end end
    })

    local SpectateToggle = tools:CreateToggle({
        Name = "Spectate", CurrentValue = false, Flag = "lite_spectate_toggle",
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
    local TimeChanger = world:CreateToggle({
        Name = "TimeChanger", CurrentValue = false, Flag = "lite_time_changer",
        Callback = function(val)
            if not val then lighting.ClockTime = 14 end
        end
    })
    local TimeSlider = world:CreateSlider({
        Name = "Clock Time", Range = {0, 24}, Increment = 0.1, Suffix = "",
        CurrentValue = 14, Flag = "lite_time_changer_value", Callback = function() end
    })
    cleanup.add(runService.RenderStepped:Connect(function()
        if TimeChanger.CurrentValue then lighting.ClockTime = TimeSlider.CurrentValue end
    end))
end)

runFunction(function()
    world:CreateDivider()
    local sky = nil

    local SkyboxChanger = world:CreateToggle({
        Name = "SkyboxChanger", CurrentValue = false, Flag = "lite_skybox_changer",
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
            RemoveTextAfterFocusLost = false, Flag = "lite_skybox_"..face:lower(),
            Callback = function(val)
                if sky and val ~= '' then pcall(function() sky[face] = val end) end
            end
        })
    end
end)


runFunction(function()
    local defaultId = 'rbxassetid://3581383408'

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

    local HitSound = tools:CreateToggle({
        Name = "HitSound", CurrentValue = false, Flag = "hit_sound",
        Callback = function(val)
            if not val and lplr.axe then
                local hitSounds = lplr.axe:FindFirstChild('hitSounds')
                if hitSounds then
                    local highStone = hitSounds:FindFirstChild('highStone')
                    if highStone then
                        highStone.SoundId = defaultId
                        highStone.Volume = 0.5
                    end
                end
            end
        end
    })

    local HitSoundSourceDropdown = tools:CreateDropdown({
        Name = "Sound Source",
        Options = {'Asset ID', 'Library'},
        CurrentOption = {'Asset ID'},
        Flag = "hit_sound_source",
        Callback = function() end
    })

    local HitSoundInput = tools:CreateInput({
        Name = "Sound ID",
        PlaceholderText = "rbxassetid://...",
        RemoveTextAfterFocusLost = false,
        Flag = "hit_sound_id",
        Callback = function(val)
            if not HitSound.CurrentValue then return end
            if HitSoundSourceDropdown.CurrentOption[1] ~= 'Asset ID' then return end
            if not lplr.axe then return end
            local hitSounds = lplr.axe:FindFirstChild('hitSounds')
            if hitSounds then
                local highStone = hitSounds:FindFirstChild('highStone')
                if highStone and val ~= '' then
                    highStone.SoundId = val:find('rbxassetid://') and val or 'rbxassetid://'..val
                end
            end
        end
    })

    local libOpts = getSoundFiles()
    local HitSoundLibDropdown = tools:CreateDropdown({
        Name = "Library Sound",
        Options = libOpts,
        CurrentOption = {libOpts[1]},
        Flag = "hit_sound_lib_file",
        Callback = function() end
    })

    tools:CreateButton({
        Name = "Refresh Library Sounds",
        Callback = function()
            local opts = getSoundFiles()
            HitSoundLibDropdown:Refresh(opts, {opts[1]})
        end
    })

    local HitSoundVolumeSlider = tools:CreateSlider({
        Name = "Volume", Range = {0, 5}, Increment = 0.01, Suffix = "",
        CurrentValue = 0.5, Flag = "hit_sound_volume", Callback = function() end
    })

    cleanup.add(runService.RenderStepped:Connect(function()
        if not lplr.axe then return end
        local hitSounds = lplr.axe:FindFirstChild('hitSounds')
        if not hitSounds then return end
        local highStone = hitSounds:FindFirstChild('highStone')
        local lowStone = hitSounds:FindFirstChild('lowStoneVariable')
        if lowStone then lowStone.Volume = 0 end
        if not HitSound.CurrentValue then return end
        if not highStone then return end
        highStone.Volume = HitSoundVolumeSlider.CurrentValue
        if HitSoundSourceDropdown.CurrentOption[1] == 'Library' then
            local selected = HitSoundLibDropdown.CurrentOption[1]
            if selected and selected ~= 'No sounds' then
                local path = 'boba/library/sounds/'..selected
                if isfile(path) then
                    local suc, asset = pcall(getcustomasset, path)
                    if suc and asset and highStone.SoundId ~= asset then
                        highStone.SoundId = asset
                    end
                end
            end
        end
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

Rayfield:LoadConfiguration()
