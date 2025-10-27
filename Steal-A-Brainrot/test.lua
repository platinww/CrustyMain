local UIRedz = loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/UISettings/UIRedz.lua"))()

-- Create Window
local Window = UIRedz:CreateWindow({
    Name = "My Hub",
    Size = UDim2.new(0, 550, 0, 450),
    Theme = "Dark"
})

-- Create Main Tab
local MainTab = Window:CreateTab("Main", UIRedz.Icons["home"])

MainTab:Button({
    Name = "Discord Server",
    Callback = function()
        setclipboard("discord.gg/example")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Copied!",
            Text = "Discord link copied to clipboard",
            Duration = 2
        })
    end
})

-- Create Player Tab
local PlayerTab = Window:CreateTab("Player", UIRedz.Icons["user"])

PlayerTab:Toggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        if state then
            print("ESP Enabled")
            -- Add ESP code
        else
            print("ESP Disabled")
            -- Remove ESP code
        end
    end
})

PlayerTab:Toggle({
    Name = "Anti-AFK",
    Default = false,
    Callback = function(state)
        if state then
            game:GetService("Players").LocalPlayer.Idled:Connect(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton2(Vector2.new())
            end)
        end
    end
})

-- Create Visual Tab
local VisualTab = Window:CreateTab("Visual", UIRedz.Icons["eye"])

VisualTab:Slider({
    Name = "FOV Slider",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

VisualTab:Toggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")
        if state then
            Lighting.Brightness = 2
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
        end
    end
})

-- Show completion notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Hub Loaded!",
    Text = "Welcome to My Hub! 🔥",
    Duration = 3
})
