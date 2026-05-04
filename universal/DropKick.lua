local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local ButtonCorner = Instance.new("UICorner")

if getgenv().DropkickNoticeLoaded then return end
getgenv().DropkickNoticeLoaded = true

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

Frame.BorderSizePixel = 0
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Size = UDim2.new(0, 288, 0, 230)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundTransparency = 0.5
Frame.Parent = ScreenGui

UICorner.CornerRadius = UDim.new(0, 20)
UICorner.Parent = Frame

TextLabel.TextWrapped = true
TextLabel.BorderSizePixel = 0
TextLabel.TextSize = 19
TextLabel.BackgroundTransparency = 1
TextLabel.FontFace = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Size = UDim2.new(0, 242, 0, 216)
TextLabel.Position = UDim2.new(0, 24, 0, -38)
TextLabel.Text = "DROPKICK SCRIPT HAS BEEN DOWN FOR A FEW HOURS FOR UPDATES PLEASE JOIN OUR DISCORD SERVER:"
TextLabel.Parent = Frame

TextButton.BorderSizePixel = 0
TextButton.TextSize = 19
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BackgroundColor3 = Color3.fromRGB(11, 174, 255)
TextButton.FontFace = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
TextButton.BackgroundTransparency = 0.2
TextButton.Size = UDim2.new(0, 162, 0, 70)
TextButton.Position = UDim2.new(0, 62, 0, 132)
TextButton.Text = "COPY LINK"
TextButton.Parent = Frame

ButtonCorner.CornerRadius = UDim.new(0, 20)
ButtonCorner.Parent = TextButton

TextButton.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/crustyhub")
	TextButton.Text = "COPIED!"
	task.wait(1.5)
	TextButton.Text = "COPY LINK"
end)
