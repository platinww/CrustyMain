local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Locked = false
local Target = nil
local Connection = nil
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PersistentAimlockUI"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
local LockButton = Instance.new("TextButton")
LockButton.Name = "AimLockButton"
LockButton.Text = "AIMLOCK"
LockButton.Size = UDim2.new(0, 120, 0, 40)
LockButton.Position = UDim2.new(0.85, 0, 0.05, 0)
LockButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
LockButton.BackgroundTransparency = 0.3
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.TextSize = 14
LockButton.Font = Enum.Font.GothamBold
LockButton.BorderSizePixel = 0
LockButton.AutoButtonColor = false
LockButton.ZIndex = 10
local ButtonEffect = Instance.new("Frame")
ButtonEffect.Name = "Effect"
ButtonEffect.Size = UDim2.new(1, 0, 1, 0)
ButtonEffect.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
ButtonEffect.BackgroundTransparency = 0.9
ButtonEffect.BorderSizePixel = 0
ButtonEffect.ZIndex = 9
ButtonEffect.Parent = LockButton
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 6)
Corner.Parent = LockButton
LockButton.Parent = ScreenGui
local function GetNearestPlayerInView()
    local ClosestPlayer = nil
    local ShortestAngle = math.huge
    local CameraDirection = Camera.CFrame.LookVector
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character then
            local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")
            local Head = Player.Character:FindFirstChild("Head")
            local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
            if HumanoidRootPart and Head and Humanoid and Humanoid.Health > 0 then
                local DirectionToPlayer = (Head.Position - Camera.CFrame.Position).Unit
                local Angle = math.deg(math.acos(CameraDirection:Dot(DirectionToPlayer)))
                if Angle < 30 and Angle < ShortestAngle then
                    ShortestAngle = Angle
                    ClosestPlayer = Player
                end
            end
        end
    end
    
    return ClosestPlayer
end
local function ResetLock()
    if Locked then
        Locked = false
        Target = nil
        LockButton.Text = "AIMLOCK"
        LockButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        ButtonEffect.BackgroundTransparency = 0.9
        
        if Connection then
            Connection:Disconnect()
            Connection = nil
        end
    end
end
local function ToggleAimlock()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
        Locked = not Locked
        if Locked then
            Target = GetNearestPlayerInView()
            if Target then
                LockButton.Text = "LOCKED"
                LockButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
                ButtonEffect.BackgroundTransparency = 0.7
                Connection = RunService.RenderStepped:Connect(function()
                    if Locked and Target and Target.Character and Target.Character:FindFirstChildOfClass("Humanoid") and Target.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                        local Head = Target.Character:FindFirstChild("Head")
                        if Head then
                            local Recoil = Vector3.new(
                                math.random(-10, 10)/100,
                                math.random(-10, 10)/100,
                                math.random(-10, 10)/100
                            )
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Head.Position + Recoil)
                        end
                    else
                        ResetLock()
                    end
                end)
            else
                ResetLock()
            end
        else
            ResetLock()
        end
    else
        ResetLock()
    end
end
LockButton.MouseButton1Click:Connect(ToggleAimlock)
local function OnCharacterAdded(character)
    local humanoid = character:WaitForChildOfClass("Humanoid")
    humanoid.Died:Connect(function()
        ResetLock()
    end)
end
if LocalPlayer.Character then
    OnCharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
UserInputService.WindowFocusReleased:Connect(function()
    if Connection then
        Connection:Disconnect()
    end
end)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Q then
        ToggleAimlock()
    end
end)
