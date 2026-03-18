-- OPENSOURCE
-- discord.gg/crustyhub

task.wait(1)
local StarterGui = game:GetService("StarterGui")
local foundLuckyBlock = false
local function notify(text)
    StarterGui:SetCore("SendNotification", {
        Title = "CrustyHub",
        Text = text .. " | discord.gg/crustyhub",
        Duration = 5
    })
end
local function forceOGGradient(label)
    local gradient = label:FindFirstChildOfClass("UIGradient")
    if gradient then
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,221,85)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,170,0))
        }
    end
end
local function applyOGStyle(label)
    label.TextColor3 = Color3.fromRGB(255,221,85)
    if not label:FindFirstChildOfClass("UIStroke") then
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0,0,0)
        stroke.Thickness = 2
        stroke.Parent = label
    end
    forceOGGradient(label)
end
local function changeText(v)
    if v:IsA("TextLabel") then
        local parent = v.Parent
        local display = parent:FindFirstChild("DisplayName")
        if display and display:IsA("TextLabel") and display.Text == "Lucky Block" then
            foundLuckyBlock = true
            if v.Text == "Secret" then
                v.Text = "OG"
                applyOGStyle(v)
            end
            if v.Text == "$750M" then
                v.Text = "$750B"
            end
        end
        if string.find(v.Text, "Do you want to sell Secret Lucky Block") then
            v.Text = "Do you want to sell OG Lucky Block"
        end
        if string.find(v.Text, "Secret") then
            v.Text = string.gsub(v.Text, "Secret", "OG")
            forceOGGradient(v)
        end

    end
end
for _, v in pairs(game:GetDescendants()) do
    changeText(v)
end
game.DescendantAdded:Connect(function(v)
    changeText(v)
end)
task.wait(1)
if foundLuckyBlock then
    notify("Successfully Injected Secret Lucky Blocks")
else
    notify("There Are No Secret Lucky Blocks In The Server")
end
