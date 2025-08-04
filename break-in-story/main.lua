local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "CRUSTY | BREAK IN STORY",
    LoadingTitle = "Loading CRUSTY GUI...",
    LoadingSubtitle = "Made by Crusty",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CrustyGUI",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main", 4483362458)

local CopyWebsite = MainTab:CreateButton({
    Name = "Copy Website Link",
    Description = "Copies website to clipboard",
    Callback = function()
        setclipboard("https://crusty.dev.tc/")
    end,
})

local CopyDiscord = MainTab:CreateButton({
    Name = "Copy Discord Link",
    Description = "Copies Discord invite to clipboard",
    Callback = function()
        setclipboard("https://discord.com/invite/d8effZXfzJ")
    end,
})

-- PLAYER TAB
local PlayerTab = Window:CreateTab("Player", 6073392579)

local SpeedToggle = false
local speedValue = 16

local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "WalkSpeed",
    CurrentValue = 16,
    Flag = "SpeedValue",
    Callback = function(value)
        speedValue = value
        if SpeedToggle then
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedValue
            end
        end
    end,
})

local SpeedToggleBtn = PlayerTab:CreateToggle({
    Name = "Toggle Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(state)
        SpeedToggle = state
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and speedValue or 16
        end
    end,
})

local NoclipToggle = false
PlayerTab:CreateToggle({
    Name = "Toggle Noclip",
    CurrentValue = false,
    Callback = function(state)
        NoclipToggle = state
    end,
})

game:GetService("RunService").Stepped:Connect(function()
    if NoclipToggle and game.Players.LocalPlayer.Character then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local InfiniteJumpToggle = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(state)
        InfiniteJumpToggle = state
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpToggle then
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

PlayerTab:CreateInput({
    Name = "Teleport To Player",
    PlaceholderText = "Enter player name",
    RemoveTextAfterFocusLost = true,
    Callback = function(value)
        local target = game.Players:FindFirstChild(value)
        if target and target.Character then
            game.Players.LocalPlayer.Character:PivotTo(target.Character:GetPivot())
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found!",
                Duration = 3,
                Image = 4483362458,
                Actions = { -- Notification Actions
                    Ignore = {
                        Name = "Okay",
                        Callback = function() end
                    }
                }
            })
        end
    end
})

-- ENERGY TAB
local EnergyTab = Window:CreateTab("Energy", 1327968554)

EnergyTab:CreateButton({
    Name = "Give Energy (+10)",
    Callback = function()
        local args = {10}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Energy"):FireServer(unpack(args))
    end,
})

EnergyTab:CreateButton({
    Name = "Remove Energy (-10)",
    Callback = function()
        local args = {-10}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Energy"):FireServer(unpack(args))
    end,
})

EnergyTab:CreateButton({
    Name = "Kill Self (-100 Energy)",
    Callback = function()
        local args = {-100}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Energy"):FireServer(unpack(args))
    end,
})

-- GET ITEM TAB
local GetItemTab = Window:CreateTab("Get Item", 6034286801)

local itemList = {
    "Pizza1", "Apple", "Cookie", "BloxyCola", "Plank", "MedKit"
}

local SelectedItem = "Pizza1"

local Dropdown = GetItemTab:CreateDropdown({
    Name = "Select Item",
    Options = itemList,
    CurrentOption = SelectedItem,
    Flag = "ItemDropdown",
    Callback = function(option)
        SelectedItem = option
    end,
})

GetItemTab:CreateButton({
    Name = "Get Selected Item",
    Callback = function()
        local args = {SelectedItem}
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("GiveTool"):FireServer(unpack(args))
    end,
})

-- SETTINGS TAB
local SettingsTab = Window:CreateTab("Settings", 6031094677)

SettingsTab:CreateDropdown({
    Name = "Select Theme",
    Options = {"Dark", "Light", "Ocean", "Midnight"},
    CurrentOption = "Dark",
    Callback = function(theme)
        Window:SetTheme(theme)
    end,
})

SettingsTab:CreateToggle({
    Name = "Toggle Acrylic Blur",
    CurrentValue = true,
    Callback = function(state)
        Window:SetBlur(state)
    end,
})

SettingsTab:CreateSlider({
    Name = "Transparency",
    Range = {0.5, 1},
    Increment = 0.05,
    CurrentValue = 1,
    Suffix = "",
    Callback = function(value)
        Window:SetTransparency(value)
    end,
})

-- Notify loading complete
Rayfield:Notify({
    Title = "CRUSTY GUI",
    Content = "Loaded Successfully!",
    Duration = 4,
    Image = 4483362458,
})

