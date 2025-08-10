local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
if getgenv().AntiAFKConnection then
    getgenv().AntiAFKConnection:Disconnect()
    getgenv().AntiAFKConnection = nil
else
    getgenv().AntiAFKConnection = player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end
