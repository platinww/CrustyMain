-- CrustyButton System with Redz Library
local UIRedz = loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/UISettings/UIRedz.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- Variables
local activeButtons = {}
local started = false
local platformStopped = false
local platform = nil
local platformConn = nil
local torsoConn = nil
local torsoTouchConn = nil
local touchedParts = {}
local originalTransparencies = {}
local isDesyncActive = false

-- Visual Variables
local originalUsername = player.Name
local xrayParts = {}
local originalLightingSettings = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient
}

-- Service Status Variables
local serviceStatusGui = nil
local activeServices = {}

-- Rebirth Data Table
local rebirthData = {
    {rebirth = 1, cash = "$1M", brainrots = {"Trippi Troppi", "Gangster Footerax"}},
    {rebirth = 2, cash = "$3M", brainrots = {"Brr Brr Patapim", "Boneca Ambalabux"}},
    {rebirth = 3, cash = "$12.5M", brainrots = {"Trulimero Trulicina", "Chimpanzini Bananini"}},
    {rebirth = 4, cash = "$35M", brainrots = {"Chef-Crabracadabra", "Glorbo Fruttodrillo"}},
    {rebirth = 5, cash = "$100M", brainrots = {"Frigo Camelo", "Orangutini Ananassini"}},
    {rebirth = 6, cash = "$350M", brainrots = {"Bombardiro Crocodilo"}},
    {rebirth = 7, cash = "$1B", brainrots = {"Bombombini Gusini"}},
    {rebirth = 8, cash = "$5B", brainrots = {"Te Te Te Sahur"}},
    {rebirth = 9, cash = "$25B", brainrots = {"Cocofanto Elefanto"}},
    {rebirth = 10, cash = "$250B", brainrots = {"Girafa Celestre"}},
    {rebirth = 11, cash = "$1T", brainrots = {"Tralalero Tralala"}},
    {rebirth = 12, cash = "$3.5T", brainrots = {"Odin Din Din Dun"}},
    {rebirth = 13, cash = "$14T", brainrots = {"Trenostruzzo Turbo 3000"}},
    {rebirth = 14, cash = "$40T", brainrots = {"Trippi Troppi Troppa Trippa"}},
    {rebirth = 15, cash = "$500T", brainrots = {"Pakrahmatmamat"}},
    {rebirth = 16, cash = "$1Qa", brainrots = {"Los Tralaleritos"}},
}

-- Service Status Display Functions
local function createServiceStatusDisplay()
    if serviceStatusGui then
        serviceStatusGui:Destroy()
    end
    
    serviceStatusGui = Instance.new("ScreenGui")
    serviceStatusGui.Name = "ServiceStatusGui"
    serviceStatusGui.ResetOnSpawn = false
    serviceStatusGui.Parent = playerGui
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 220, 0, 300)
    container.Position = UDim2.new(0, 10, 0, 10)
    container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.Parent = serviceStatusGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 200, 0)
    stroke.Thickness = 2
    stroke.Parent = container
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ Active Services"
    title.TextColor3 = Color3.fromRGB(255, 200, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = container
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = container
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 40)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.Parent = container
    
    return container
end

local function updateServiceStatus(serviceName, isActive)
    if not serviceStatusGui then
        createServiceStatusDisplay()
    end
    
    local container = serviceStatusGui:FindFirstChild("Container")
    if not container then return end
    
    if isActive then
        activeServices[serviceName] = true
        
        local existingLabel = container:FindFirstChild(serviceName)
        if existingLabel then return end
        
        local label = Instance.new("TextLabel")
        label.Name = serviceName
        label.Size = UDim2.new(1, -20, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = "● " .. serviceName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextStrokeTransparency = 0.5
        label.Parent = container
        
        task.spawn(function()
            local t = 0
            while label.Parent and activeServices[serviceName] do
                t += 0.05
                local r = math.sin(t * 2) * 127 + 128
                local g = math.sin(t * 2 + 2) * 127 + 128
                local b = math.sin(t * 2 + 4) * 127 + 128
                label.TextColor3 = Color3.fromRGB(r, g, b)
                task.wait(0.05)
            end
        end)
    else
        activeServices[serviceName] = nil
        local existingLabel = container:FindFirstChild(serviceName)
        if existingLabel then
            existingLabel:Destroy()
        end
        
        if next(activeServices) == nil and serviceStatusGui then
            serviceStatusGui:Destroy()
            serviceStatusGui = nil
        end
    end
end

-- Enhanced CrustyButton System with RGB Effect
local CrustyButton = {}
CrustyButton.__index = CrustyButton

function CrustyButton.new(config)
    local self = setmetatable({}, CrustyButton)
    
    self.text = config.Text or "Button"
    self.callback = config.Callback or function() end
    self.position = config.Position or UDim2.new(0.5, 0, 0.5, 0)
    
    self:CreateButton()
    return self
end

function CrustyButton:CreateButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CrustyButtonGui_" .. self.text
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local button = Instance.new("TextButton")
    button.Name = "CrustyButton"
    button.Size = UDim2.new(0, 120, 0, 40)
    button.Position = self.position
    button.AnchorPoint = Vector2.new(0.5, 0.5)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = self.text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.TextStrokeTransparency = 0.3
    button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    button.BorderSizePixel = 0
    button.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = button
    
    -- RGB Effect
    task.spawn(function()
        local t = 0
        while button.Parent do
            t += 0.05
            local r = math.sin(t * 2) * 127 + 128
            local g = math.sin(t * 2 + 2) * 127 + 128
            local b = math.sin(t * 2 + 4) * 127 + 128
            local color = Color3.fromRGB(r, g, b)
            button.BackgroundColor3 = color
            stroke.Color = color
            task.wait(0.05)
        end
    end)
    
    -- Dragging functionality
    local dragging = false
    local dragInput, mousePos, framePos
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = button.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    button.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            button.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Click functionality
    local isActive = false
    button.MouseButton1Click:Connect(function()
        isActive = not isActive
        
        -- Scale animation
        local scaleTween = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = isActive and UDim2.new(0, 115, 0, 38) or UDim2.new(0, 120, 0, 40)
        })
        scaleTween:Play()
        scaleTween.Completed:Wait()
        
        local scaleTween2 = TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 120, 0, 40)
        })
        scaleTween2:Play()
        
        self.callback(isActive)
    end)
    
    self.gui = screenGui
    self.button = button
    table.insert(activeButtons, self)
end

function CrustyButton:Destroy()
    if self.gui then
        self.gui:Destroy()
    end
    for i, btn in ipairs(activeButtons) do
        if btn == self then
            table.remove(activeButtons, i)
            break
        end
    end
end

-- Visual Functions
local function hideUsername(state)
    if state then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.DisplayName = "CrustyUser"
                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
            
            local head = character:FindFirstChild("Head")
            if head then
                for _, child in pairs(head:GetChildren()) do
                    if child:IsA("BillboardGui") or child:IsA("TextLabel") then
                        child.Enabled = false
                    end
                end
            end
        end
    else
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.DisplayName = originalUsername
                humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            end
            
            local head = character:FindFirstChild("Head")
            if head then
                for _, child in pairs(head:GetChildren()) do
                    if child:IsA("BillboardGui") or child:IsA("TextLabel") then
                        child.Enabled = true
                    end
                end
            end
        end
    end
end

local function xrayMode(state)
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                if obj.Transparency < 1 then
                    xrayParts[obj] = obj.Transparency
                    obj.Transparency = 0.7
                end
            end
        end
        
        workspace.DescendantAdded:Connect(function(obj)
            if obj:IsA("BasePart") and not obj.Parent:FindFirstChild("Humanoid") then
                if obj.Transparency < 1 and state then
                    xrayParts[obj] = obj.Transparency
                    obj.Transparency = 0.7
                end
            end
        end)
    else
        for obj, transparency in pairs(xrayParts) do
            if obj and obj.Parent then
                obj.Transparency = transparency
            end
        end
        xrayParts = {}
    end
end

local function fullBright(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = originalLightingSettings.Brightness
        Lighting.ClockTime = originalLightingSettings.ClockTime
        Lighting.FogEnd = originalLightingSettings.FogEnd
        Lighting.GlobalShadows = originalLightingSettings.GlobalShadows
        Lighting.Ambient = originalLightingSettings.Ambient
        Lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
    end
end

local function nightVision(state)
    if state then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(178, 255, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 255, 178)
        Lighting.FogEnd = 100000
        
        local colorCorrection = Lighting:FindFirstChild("NightVisionCC")
        if not colorCorrection then
            colorCorrection = Instance.new("ColorCorrectionEffect")
            colorCorrection.Name = "NightVisionCC"
            colorCorrection.Brightness = 0.1
            colorCorrection.Contrast = 0.2
            colorCorrection.TintColor = Color3.fromRGB(180, 255, 180)
            colorCorrection.Parent = Lighting
        end
        colorCorrection.Enabled = true
    else
        Lighting.Brightness = originalLightingSettings.Brightness
        Lighting.Ambient = originalLightingSettings.Ambient
        Lighting.OutdoorAmbient = originalLightingSettings.OutdoorAmbient
        Lighting.FogEnd = originalLightingSettings.FogEnd
        
        local colorCorrection = Lighting:FindFirstChild("NightVisionCC")
        if colorCorrection then
            colorCorrection.Enabled = false
        end
    end
end

local function removeBlur(state)
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("SunRaysEffect") then
            effect.Enabled = not state
        end
    end
    
    if state then
        for _, effect in pairs(camera:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
    end
end

-- Create Redz UI Window
local Window = UIRedz:CreateWindow({
    Name = "Crusty Hub",
    Size = UDim2.new(0, 550, 0, 450),
    Theme = "Dark"
})

-- Main Tab
local MainTab = Window:CreateTab("Main", UIRedz.Icons["home"])

MainTab:Button({
    Name = "Discord Server",
    Callback = function()
        setclipboard("discord.gg/crusty-hub-1401564054186758186")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Discord Link Copied!",
            Text = "discord.gg/crusty-hub-1401564054186758186",
            Duration = 3
        })
    end
})

MainTab:Button({
    Name = "Website",
    Callback = function()
        setclipboard("https://crusty.dev.tc/")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Website Link Copied!",
            Text = "https://crusty.dev.tc/",
            Duration = 3
        })
    end
})

-- Helper Tab
local HelperTab = Window:CreateTab("Helper", UIRedz.Icons["award"])

HelperTab:Button({
    Name = "Fly to Best",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/Steal-A-Brainrot/Fly-TO-Best.lua"))()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Fly to Best",
            Text = "Automation script loaded!",
            Duration = 2
        })
    end
})

HelperTab:Toggle({
    Name = "ESP Rebirth Needed Brainrots",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Rebirth ESP", state)
        
        if state then
            local function getPlayerRebirthLevel()
                local leaderstats = player:FindFirstChild("leaderstats")
                if leaderstats then
                    local rebirths = leaderstats:FindFirstChild("Rebirths")
                    if rebirths then
                        return rebirths.Value or 0
                    end
                end
                return 0
            end
            
            local function rainbowColor(t)
                local r = math.sin(t * 2) * 127 + 128
                local g = math.sin(t * 2 + 2) * 127 + 128
                local b = math.sin(t * 2 + 4) * 127 + 128
                return Color3.fromRGB(r, g, b)
            end
            
            local function createRebirthESP(model, brainrotName)
                local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
                if not head then return end
                
                local existingESP = head:FindFirstChild("RebirthESP")
                if existingESP then return end
                
                local bill = Instance.new("BillboardGui")
                bill.Name = "RebirthESP"
                bill.Size = UDim2.new(0, 200, 0, 100)
                bill.StudsOffset = Vector3.new(0, 5, 0)
                bill.AlwaysOnTop = true
                bill.Parent = head
                
                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "⭐ " .. brainrotName .. " ⭐"
                text.TextColor3 = Color3.fromRGB(255, 255, 0)
                text.Font = Enum.Font.SourceSansBold
                text.TextScaled = true
                text.TextStrokeTransparency = 0.3
                text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                text.Parent = bill
                
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local att0 = Instance.new("Attachment", head)
                    local att1 = Instance.new("Attachment", hrp)
                    local beam = Instance.new("Beam")
                    beam.Name = "RebirthESP_Beam"
                    beam.Width0 = 0.4
                    beam.Width1 = 0.4
                    beam.Attachment0 = att0
                    beam.Attachment1 = att1
                    beam.FaceCamera = true
                    beam.Parent = head
                    
                    task.spawn(function()
                        local t = 0
                        while bill.Parent and state do
                            t += 0.05
                            local col = rainbowColor(t)
                            text.TextColor3 = col
                            beam.Color = ColorSequence.new(col)
                            task.wait(0.05)
                        end
                    end)
                end
            end
            
            local function checkAndESPBrainrots()
                local currentRebirth = getPlayerRebirthLevel()
                local nextRebirthData = rebirthData[currentRebirth + 1]
                
                if not nextRebirthData then 
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "Max Rebirth",
                        Text = "You are at max rebirth level!",
                        Duration = 2
                    })
                    return 
                end
                
                local neededBrainrots = nextRebirthData.brainrots
                
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Next Rebirth: " .. nextRebirthData.rebirth,
                    Text = "Need: " .. table.concat(neededBrainrots, ", "),
                    Duration = 4
                })
                
                for _, model in ipairs(workspace:GetChildren()) do
                    if model:IsA("Model") then
                        local overhead = model:FindFirstChild("AnimalOverhead", true)
                        local nameLabel = overhead and overhead:FindFirstChild("Name")
                        
                        if nameLabel and nameLabel:IsA("TextLabel") then
                            local modelName = nameLabel.Text
                            
                            for _, neededBrainrot in ipairs(neededBrainrots) do
                                if modelName == neededBrainrot then
                                    createRebirthESP(model, modelName)
                                end
                            end
                        end
                    end
                end
            end
            
            task.spawn(function()
                while state do
                    checkAndESPBrainrots()
                    task.wait(6)
                end
            end)
        else
            for _, model in ipairs(workspace:GetChildren()) do
                if model:IsA("Model") then
                    for _, child in ipairs(model:GetDescendants()) do
                        if child.Name == "RebirthESP" or child.Name == "RebirthESP_Beam" then
                            child:Destroy()
                        end
                    end
                end
            end
        end
    end
})

-- Player Tab
local PlayerTab = Window:CreateTab("Player", UIRedz.Icons["user"])

PlayerTab:Toggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        updateServiceStatus("ESP Players", state)
        
        if state then
            local function createESP(part, color)
                local box = Instance.new("BoxHandleAdornment")
                box.Size = part.Size
                box.Color3 = color
                box.Transparency = 0.5
                box.ZIndex = 0
                box.AlwaysOnTop = true
                box.Adornee = part
                box.Parent = part
            end
            
            local function addESPToCharacter(character)
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        createESP(part, Color3.new(1, 0, 0))
                    end
                end
                character.ChildAdded:Connect(function(part)
                    if part:IsA("BasePart") then
                        createESP(part, Color3.new(1, 0, 0))
                    end
                end)
            end
            
            local function onPlayerAdded(p)
                p.CharacterAdded:Connect(function(character)
                    character:WaitForChild("HumanoidRootPart")
                    addESPToCharacter(character)
                end)
            end
            
            for _, p in pairs(Players:GetPlayers()) do
                onPlayerAdded(p)
                if p.Character then
                    addESPToCharacter(p.Character)
                end
            end
            Players.PlayerAdded:Connect(onPlayerAdded)
        else
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BoxHandleAdornment") then
                            part:Destroy()
                        end
                    end
                end
            end
        end
    end
})

PlayerTab:Toggle({
    Name = "ESP Remaining Time",
    Default = false,
    Callback = function(state)
        updateServiceStatus("ESP Time", state)
        
        if state then
            local plotsFolder = workspace:WaitForChild("Plots")
            
            local function setupTextLabel(textLabel)
                if textLabel:IsA("TextLabel") then
                    textLabel.TextScaled = true
                    textLabel.TextSize = 40
                    textLabel.RichText = true
                end
            end
            
            local function setupBillboard(billboard)
                if billboard:IsA("BillboardGui") then
                    billboard.AlwaysOnTop = true
                    billboard.MaxDistance = 0
                    billboard.Size = UDim2.new(0, 200, 0, 100)
                    billboard.StudsOffset = Vector3.new(0, 5, 0)
                end
                for _, child in pairs(billboard:GetChildren()) do
                    setupTextLabel(child)
                end
                billboard.ChildAdded:Connect(function(child)
                    setupTextLabel(child)
                end)
            end
            
            local function processPlotBlock(plotBlock)
                local main = plotBlock:FindFirstChild("Main")
                if main then
                    local billboard = main:FindFirstChild("BillboardGui")
                    if billboard then
                        setupBillboard(billboard)
                    end
                end
            end
            
            local function processPlot(plot)
                local purchases = plot:FindFirstChild("Purchases")
                if purchases then
                    for _, plotBlock in pairs(purchases:GetChildren()) do
                        if plotBlock:IsA("Model") or plotBlock:IsA("Folder") then
                            processPlotBlock(plotBlock)
                        end
                    end
                    purchases.ChildAdded:Connect(function(child)
                        processPlotBlock(child)
                    end)
                end
            end
            
            for _, plot in pairs(plotsFolder:GetChildren()) do
                processPlot(plot)
            end
            plotsFolder.ChildAdded:Connect(function(plot)
                processPlot(plot)
            end)
        end
    end
})

PlayerTab:Toggle({
    Name = "ESP Best Brainrot",
    Default = false,
    Callback = function(state)
        updateServiceStatus("ESP Best", state)
        
        if state then
            local Workspace = game:GetService("Workspace")
            local LocalPlayer = Players.LocalPlayer
            
            local function parseGen(genStr)
                if not genStr or genStr == "Stolen" or genStr == "Unknown" then return 0 end
                local num = tonumber(genStr:match("%d+"))
                if not num then return 0 end
                if genStr:find("M") then
                    return num * 1_000_000
                elseif genStr:find("K") then
                    return num * 1_000
                else
                    return num
                end
            end
            
            local function findBestModel()
                local bestModel, bestValue = nil, -1
                for _, model in ipairs(Workspace:GetChildren()) do
                    if model:IsA("Model") then
                        local overhead = model:FindFirstChild("AnimalOverhead", true)
                        local genLabel = overhead and overhead:FindFirstChild("Generation")
                        if genLabel and genLabel:IsA("TextLabel") then
                            local val = parseGen(genLabel.Text)
                            if val > bestValue then
                                bestValue = val
                                bestModel = model
                            end
                        end
                    end
                end
                return bestModel
            end
            
            local function rainbowColor(t)
                local r = math.sin(t) * 127 + 128
                local g = math.sin(t + 2) * 127 + 128
                local b = math.sin(t + 4) * 127 + 128
                return Color3.fromRGB(r, g, b)
            end
            
            local function createESP(model)
                if Workspace:FindFirstChild("BestESP") then
                    Workspace.BestESP:Destroy()
                end
                local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
                if not head then return end
                
                local bill = Instance.new("BillboardGui")
                bill.Name = "BestESP"
                bill.Size = UDim2.new(0, 200, 0, 200)
                bill.StudsOffset = Vector3.new(0, 6, 0)
                bill.AlwaysOnTop = true
                bill.Parent = model
                
                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = "⭐"
                text.TextColor3 = Color3.fromRGB(255, 255, 0)
                text.Font = Enum.Font.SourceSansBold
                text.TextScaled = true
                text.Parent = bill
                
                local att0 = Instance.new("Attachment", head)
                local att1 = Instance.new("Attachment", LocalPlayer.Character:WaitForChild("HumanoidRootPart"))
                local beam = Instance.new("Beam")
                beam.Name = "ESP_Beam"
                beam.Width0 = 0.25
                beam.Width1 = 0.25
                beam.Attachment0 = att0
                beam.Attachment1 = att1
                beam.Parent = head
                
                task.spawn(function()
                    local t = 0
                    while bill.Parent do
                        t += 0.05
                        local col = rainbowColor(t)
                        text.TextColor3 = col
                        beam.Color = ColorSequence.new(col)
                        task.wait(0.05)
                    end
                end)
            end
            
            task.spawn(function()
                while state do
                    local best = findBestModel()
                    if best then
                        createESP(best)
                    end
                    task.wait(8)
                end
            end)
        else
            if workspace:FindFirstChild("BestESP") then
                workspace.BestESP:Destroy()
            end
        end
    end
})

PlayerTab:Toggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Anti-AFK", state)
        
        if state then
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end
            getgenv().AntiAFKConnection = player.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
            game.StarterGui:SetCore("SendNotification", {
                Title = "Anti-AFK Enabled",
                Text = "You won't be kicked for being idle!",
                Duration = 2
            })
        else
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "Anti-AFK Disabled",
                Text = "Anti-AFK protection removed",
                Duration = 2
            })
        end
    end
})

PlayerTab:Button({
    Name = "Generate Private Server (PATCHED)",
    Callback = function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Service Patched",
            Text = "That Service Was Patched",
            Duration = 3
        })
    end
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", UIRedz.Icons["eye"])

VisualTab:Toggle({
    Name = "Hide Username",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Hide Username", state)
        hideUsername(state)
        game.StarterGui:SetCore("SendNotification", {
            Title = state and "Username Hidden" or "Username Visible",
            Text = state and "Your username is now hidden!" or "Your username is now visible!",
            Duration = 2
        })
    end
})

VisualTab:Toggle({
    Name = "Xray Mode",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Xray Mode", state)
        xrayMode(state)
        game.StarterGui:SetCore("SendNotification", {
            Title = state and "Xray Enabled" or "Xray Disabled",
            Text = state and "You can now see through walls!" or "Xray mode disabled",
            Duration = 2
        })
    end
})

VisualTab:Toggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Full Bright", state)
        fullBright(state)
        game.StarterGui:SetCore("SendNotification", {
            Title = state and "Full Bright Enabled" or "Full Bright Disabled",
            Text = state and "Everything is now bright!" or "Lighting restored",
            Duration = 2
        })
    end
})

VisualTab:Toggle({
    Name = "Night Vision",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Night Vision", state)
        nightVision(state)
        game.StarterGui:SetCore("SendNotification", {
            Title = state and "Night Vision Enabled" or "Night Vision Disabled",
            Text = state and "Night vision activated!" or "Night vision deactivated",
            Duration = 2
        })
    end
})

VisualTab:Slider({
    Name = "FOV Slider",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = function(value)
        camera.FieldOfView = value
    end
})

VisualTab:Toggle({
    Name = "Remove Blur",
    Default = false,
    Callback = function(state)
        updateServiceStatus("Remove Blur", state)
        removeBlur(state)
        game.StarterGui:SetCore("SendNotification", {
            Title = state and "Blur Removed" or "Blur Restored",
            Text = state and "All blur effects removed!" or "Blur effects restored",
            Duration = 2
        })
    end
})

-- Stealer Tab
local StealerTab = Window:CreateTab("Stealer", UIRedz.Icons["zap"])

StealerTab:Toggle({
    Name = "DeSync Button",
    Default = false,
    Callback = function(state)
        if state then
            CrustyButton.new({
                Text = "DESYNC",
                Position = UDim2.new(0.5, -70, 0.5, 0),
                Callback = function()
                    if isDesyncActive then
                        return
                    end
                    isDesyncActive = true
                    
                    local ok, err = pcall(function()
                        local backpack = player:WaitForChild("Backpack", 10)
                        local character = player.Character or player.CharacterAdded:Wait()
                        local humanoid = character:WaitForChild("Humanoid", 10)
                        local packages = ReplicatedStorage:WaitForChild("Packages", 5)
                        
                        if not packages then return end
                        local net = packages:WaitForChild("Net", 5)
                        if not net then return end
                        
                        local useItemRemote = net:WaitForChild("RE/UseItem", 5)
                        local onTeleportRemote = net:WaitForChild("RE/QuantumCloner/OnTeleport", 5)
                        local quantumCloner = backpack:FindFirstChild("Quantum Cloner") or character:FindFirstChild("Quantum Cloner")
                        local isEquipped = character:FindFirstChild("Quantum Cloner") ~= nil
                        
                        if not quantumCloner then return end
                        
                        local fenv = getfenv()
                        if fenv.setfflag then
                            fenv.setfflag("WorldStepMax", "-9999999999")
                        end
                        
                        task.wait(0.2)
                        if not isEquipped and humanoid then
                            humanoid:EquipTool(quantumCloner)
                            task.wait(0.3)
                        end
                        
                        task.wait(0.2)
                        if useItemRemote then useItemRemote:FireServer() end
                        task.wait(0.2)
                        if onTeleportRemote then onTeleportRemote:FireServer() end
                        task.wait(2)
                        
                        if fenv.setfflag then
                            fenv.setfflag("WorldStepMax", "-1")
                        end
                        return true
                    end)
                    
                    task.wait(0.3)
                    isDesyncActive = false
                    
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "DeSync",
                        Text = ok and "DeSync executed!" or "DeSync failed!",
                        Duration = 2
                    })
                end
            })
        else
            for _, btn in ipairs(activeButtons) do
                if btn.text == "DESYNC" then
                    btn:Destroy()
                    break
                end
            end
        end
    end
})

StealerTab:Toggle({
    Name = "3RD FLOOR Button",
    Default = false,
    Callback = function(state)
        if state then
            CrustyButton.new({
                Text = "3RD FLOOR",
                Position = UDim2.new(0.5, 70, 0.5, 0),
                Callback = function(btnState)
                    local speed = 8
                    local platformSize = Vector3.new(6, 1, 6)
                    local platformOffset = -3.5
                    local plotsFolder = workspace:WaitForChild("Plots")
                    
                    local function getRefs()
                        local character = player.Character or player.CharacterAdded:Wait()
                        local hrp = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
                        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                        return character, hrp, torso
                    end
                    
                    local function freezePart(part, character)
                        if not part or not part:IsA("BasePart") then return end
                        if touchedParts[part] then return end
                        if part == platform then return end
                        if part:IsDescendantOf(character) then return end
                        touchedParts[part] = {
                            Anchored = part.Anchored,
                            Velocity = part.AssemblyLinearVelocity,
                        }
                        part.Anchored = true
                    end
                    
                    local function restoreParts()
                        for part, props in pairs(touchedParts) do
                            if part and part.Parent then
                                part.Anchored = props.Anchored or false
                            end
                        end
                        touchedParts = {}
                    end
                    
                    local function makePlotsTransparent()
                        for _, model in pairs(plotsFolder:GetChildren()) do
                            if model:IsA("Model") then
                                for _, part in pairs(model:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        if not originalTransparencies[part] then
                                            originalTransparencies[part] = part.Transparency
                                        end
                                        part.Transparency = 0.3
                                    end
                                end
                            end
                        end
                    end
                    
                    local function restorePlotsTransparency()
                        for part, originalTrans in pairs(originalTransparencies) do
                            if part and part.Parent then
                                part.Transparency = originalTrans
                            end
                        end
                        originalTransparencies = {}
                    end
                    
                    local function destroyPlatform()
                        if platformConn then platformConn:Disconnect() platformConn = nil end
                        if torsoConn then torsoConn:Disconnect() torsoConn = nil end
                        if torsoTouchConn then torsoTouchConn:Disconnect() torsoTouchConn = nil end
                        if platform and platform.Parent then platform:Destroy() end
                        platform = nil
                    end
                    
                    if btnState then
                        if started then return end
                        local character, hrp, torso = getRefs()
                        if not hrp then return end
                        
                        platform = Instance.new("Part")
                        platform.Size = platformSize
                        platform.Anchored = true
                        platform.CanCollide = true
                        platform.Name = "UpStairsPlatform"
                        platform.Color = Color3.fromRGB(255, 200, 0)
                        platform.Material = Enum.Material.Neon
                        platform.Parent = workspace
                        
                        local startPos = hrp.Position + Vector3.new(0, platformOffset, 0)
                        platform.CFrame = CFrame.new(startPos)
                        started = true
                        platformStopped = false
                        makePlotsTransparent()
                        
                        if torso then
                            torsoConn = platform.Touched:Connect(function(part)
                                if not started then return end
                                if part == torso then platformStopped = true end
                            end)
                            
                            torsoTouchConn = torso.Touched:Connect(function(part)
                                if not started then return end
                                if part ~= platform then freezePart(part, character) end
                            end)
                        end
                        
                        platformConn = RunService.Heartbeat:Connect(function(dt)
                            if not started or not platform or not platform.Parent then return end
                            local currentCharacter = player.Character
                            if not currentCharacter then
                                destroyPlatform()
                                restoreParts()
                                restorePlotsTransparency()
                                started = false
                                platformStopped = false
                                return
                            end
                            local currentHrp = currentCharacter:FindFirstChild("HumanoidRootPart")
                            if not currentHrp or not currentHrp.Parent then
                                destroyPlatform()
                                restoreParts()
                                restorePlotsTransparency()
                                started = false
                                platformStopped = false
                                return
                            end
                            if platformStopped then return end
                            
                            local targetX = currentHrp.Position.X
                            local targetZ = currentHrp.Position.Z
                            local targetY = currentHrp.Position.Y + platformOffset
                            local currentPos = platform.Position
                            local newY = currentPos.Y + speed * dt
                            if newY < targetY then
                                newY = math.min(newY, targetY)
                            end
                            local lerpX = currentPos.X + (targetX - currentPos.X) * 0.1
                            local lerpZ = currentPos.Z + (targetZ - currentPos.Z) * 0.1
                            platform.CFrame = CFrame.new(lerpX, newY, lerpZ)
                        end)
                    else
                        if not started then return end
                        destroyPlatform()
                        restoreParts()
                        restorePlotsTransparency()
                        started = false
                        platformStopped = false
                    end
                end
            })
        else
            for _, btn in ipairs(activeButtons) do
                if btn.text == "3RD FLOOR" then
                    btn:Destroy()
                    break
                end
            end
        end
    end
})

StealerTab:Button({
    Name = "Destroy All Buttons",
    Callback = function()
        local count = #activeButtons
        for i = #activeButtons, 1, -1 do
            activeButtons[i]:Destroy()
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Buttons Destroyed",
            Text = "Removed " .. count .. " button(s)",
            Duration = 2
        })
    end
})

-- Character respawn cleanup
player.CharacterAdded:Connect(function()
    if started then
        if platformConn then platformConn:Disconnect() end
        if torsoConn then torsoConn:Disconnect() end
        if torsoTouchConn then torsoTouchConn:Disconnect() end
        if platform and platform.Parent then platform:Destroy() end
        for part, props in pairs(touchedParts) do
            if part and part.Parent then
                part.Anchored = props.Anchored or false
            end
        end
        touchedParts = {}
        for part, originalTrans in pairs(originalTransparencies) do
            if part and part.Parent then
                part.Transparency = originalTrans
            end
        end
        originalTransparencies = {}
        started = false
        platformStopped = false
        platform = nil
    end
end)

game.StarterGui:SetCore("SendNotification", {
    Title = "Crusty Hub Loaded!",
    Text = "Welcome to Crusty Hub! 🔥",
    Duration = 3
})
