local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ClickInfoGui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0, 30, 0, 30)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -35, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "Tıklanan Parça Bilgisi"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = mainFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, -40)
infoLabel.Position = UDim2.new(0, 10, 0, 35)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Bir parçaya tıkla..."
infoLabel.Font = Enum.Font.Code
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.TextSize = 16
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Parent = mainFrame
local function getFullPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent do
        path = parent.Name .. "/" .. path
        parent = parent.Parent
    end
    return path
end
mouse.Button1Down:Connect(function()
    if mouse.Target then
        local part = mouse.Target
        local path = getFullPath(part)
        local modelParent = part:FindFirstAncestorOfClass("Model")
        local modelName = modelParent and modelParent.Name or "Yok"
        infoLabel.Text = string.format(
            "Ad: %s\nClass: %s\nModel: %s\nPozisyon: (%.2f, %.2f, %.2f)\nYol:\n%s",
            part.Name,
            part.ClassName,
            modelName,
            part.Position.X,
            part.Position.Y,
            part.Position.Z,
            path
        )
    else
        infoLabel.Text = "Hiçbir şey tıklanmadı!"
    end
end)
