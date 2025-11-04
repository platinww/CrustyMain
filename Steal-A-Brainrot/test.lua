-- Crusty Data Copier - Full Game Scanner
-- Tüm oyunu tarar ve kopyalar

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrustyDataCopier"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Ana Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 15)
mainCorner.Parent = mainFrame

-- Header
local header = Instance.new("TextLabel")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
header.BorderSizePixel = 0
header.Text = "🔥 Crusty Data Copier 🔥"
header.TextColor3 = Color3.fromRGB(255, 100, 100)
header.TextSize = 24
header.Font = Enum.Font.GothamBold
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

-- Progress Label
local progressLabel = Instance.new("TextLabel")
progressLabel.Name = "ProgressLabel"
progressLabel.Size = UDim2.new(1, -40, 0, 30)
progressLabel.Position = UDim2.new(0, 20, 0, 80)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "Hazırlanıyor..."
progressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
progressLabel.TextSize = 18
progressLabel.Font = Enum.Font.Gotham
progressLabel.TextXAlignment = Enum.TextXAlignment.Left
progressLabel.Parent = mainFrame

-- Progress Bar Arka Plan
local progressBg = Instance.new("Frame")
progressBg.Name = "ProgressBg"
progressBg.Size = UDim2.new(1, -40, 0, 30)
progressBg.Position = UDim2.new(0, 20, 0, 120)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
progressBg.BorderSizePixel = 0
progressBg.Parent = mainFrame

local progressBgCorner = Instance.new("UICorner")
progressBgCorner.CornerRadius = UDim.new(0, 8)
progressBgCorner.Parent = progressBg

-- Progress Bar
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 8)
progressBarCorner.Parent = progressBar

-- Percent Label
local percentLabel = Instance.new("TextLabel")
percentLabel.Name = "PercentLabel"
percentLabel.Size = UDim2.new(1, 0, 1, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.TextSize = 16
percentLabel.Font = Enum.Font.GothamBold
percentLabel.Parent = progressBg

-- Stats Label
local statsLabel = Instance.new("TextLabel")
statsLabel.Name = "StatsLabel"
statsLabel.Size = UDim2.new(1, -40, 0, 80)
statsLabel.Position = UDim2.new(0, 20, 0, 160)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "📦 Kopyalanan: 0\n📂 Toplam: 0\n⏱️ Süre: 0s"
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statsLabel.TextSize = 16
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.TextYAlignment = Enum.TextYAlignment.Top
statsLabel.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 255)
statusLabel.BackgroundTransparency = 1
statsLabel.TextWrapped = true
statusLabel.Text = "✅ Hazır!"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Fonksiyonlar
local function updateProgress(current, total, status)
	local percent = math.floor((current / total) * 100)
	progressBar:TweenSize(UDim2.new(percent / 100, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
	percentLabel.Text = percent .. "%"
	progressLabel.Text = status
end

local function updateStats(copied, total, elapsedTime, currentItem)
	statsLabel.Text = string.format("📦 Kopyalanan: %d\n📂 Toplam: %d\n⏱️ Süre: %.1fs", copied, total, elapsedTime)
	statusLabel.Text = "🔍 " .. currentItem
end

local function getFullPath(instance)
	local path = instance.Name
	local parent = instance.Parent
	while parent and parent ~= game do
		path = parent.Name .. "/" .. path
		parent = parent.Parent
	end
	return path
end

local function serializeValue(value)
	local valueType = typeof(value)
	
	if valueType == "Vector3" then
		return string.format("Vector3.new(%.3f, %.3f, %.3f)", value.X, value.Y, value.Z)
	elseif valueType == "Color3" then
		return string.format("Color3.fromRGB(%d, %d, %d)", math.floor(value.R * 255), math.floor(value.G * 255), math.floor(value.B * 255))
	elseif valueType == "CFrame" then
		local x, y, z = value.Position.X, value.Position.Y, value.Position.Z
		return string.format("CFrame.new(%.3f, %.3f, %.3f)", x, y, z)
	elseif valueType == "string" then
		return '"' .. value .. '"'
	else
		return tostring(value)
	end
end

local function getAllProperties(instance)
	local props = {}
	local basicProps = {
		"Name", "ClassName",
		"Anchored", "CanCollide", "Transparency", "Material", "Color", "Size", "Position", "CFrame",
		"Texture", "TextureId", "MeshId", "Scale",
		"Volume", "Pitch", "SoundId", "Looped", "PlaybackSpeed",
		"AnimationId", "Velocity", "MaxForce", "P",
		"Text", "TextColor3", "TextSize", "Font", "BackgroundColor3",
		"Value", "Enabled", "Brightness", "Range"
	}
	
	for _, propName in pairs(basicProps) do
		local success, value = pcall(function()
			return instance[propName]
		end)
		if success and value ~= nil then
			props[propName] = value
		end
	end
	
	return props
end

local function serializeInstance(instance)
	local result = ""
	local separator = "─────────────────────────────────────────────\n"
	
	result = result .. separator
	result = result .. "📦 " .. instance.ClassName .. ' "' .. instance.Name .. '"\n'
	result = result .. "📍 Path: " .. getFullPath(instance) .. "\n"
	
	local props = getAllProperties(instance)
	if next(props) then
		result = result .. "⚙️  Properties:\n"
		for propName, value in pairs(props) do
			if typeof(value) == "Instance" then
				result = result .. "  • " .. propName .. ": [" .. value.ClassName .. "] " .. value.Name .. "\n"
			else
				result = result .. "  • " .. propName .. ": " .. serializeValue(value) .. "\n"
			end
		end
	end
	
	if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
		result = result .. "📜 Source:\n```lua\n" .. instance.Source .. "\n```\n"
	end
	
	local children = instance:GetChildren()
	if #children > 0 then
		result = result .. "👶 Children: " .. #children .. "\n"
	end
	
	result = result .. "\n"
	return result
end

-- TARAMA BAŞLAT
local function startScan()
	local startTime = tick()
	local fullData = [[
╔═══════════════════════════════════════════════════════════════╗
║           🔥 CRUSTY DATA COPIER - FULL GAME SCAN 🔥          ║
╚═══════════════════════════════════════════════════════════════╝

]]
	
	-- Tüm servisleri topla
	local services = {
		game.Workspace,
		game.ReplicatedStorage,
		game.ServerStorage,
		game.ReplicatedFirst,
		game.Lighting,
		game.SoundService,
		game.StarterGui,
		game.StarterPack,
		game.StarterPlayer,
		game.Teams
	}
	
	-- Toplam obje sayısını hesapla
	local totalObjects = 0
	for _, service in pairs(services) do
		for _, descendant in pairs(service:GetDescendants()) do
			totalObjects = totalObjects + 1
		end
	end
	
	local copiedObjects = 0
	
	-- Her servisi tara
	for _, service in pairs(services) do
		fullData = fullData .. "\n\n" .. string.rep("═", 63) .. "\n"
		fullData = fullData .. "🗂️  SERVICE: " .. service.Name .. "\n"
		fullData = fullData .. string.rep("═", 63) .. "\n\n"
		
		local descendants = service:GetDescendants()
		
		for i, descendant in pairs(descendants) do
			-- UI Güncelle
			copiedObjects = copiedObjects + 1
			local elapsed = tick() - startTime
			updateProgress(copiedObjects, totalObjects, "Taranıyor: " .. service.Name)
			updateStats(copiedObjects, totalObjects, elapsed, descendant.ClassName .. ' "' .. descendant.Name .. '"')
			
			-- Veriyi ekle
			fullData = fullData .. serializeInstance(descendant)
			
			-- Her 50 objede bir bekle (lag olmasın)
			if i % 50 == 0 then
				task.wait()
			end
		end
	end
	
	-- Özet
	local totalTime = tick() - startTime
	fullData = fullData .. "\n" .. string.rep("═", 63) .. "\n"
	fullData = fullData .. "✅ TARAMA TAMAMLANDI!\n"
	fullData = fullData .. "📦 Toplam Obje: " .. totalObjects .. "\n"
	fullData = fullData .. "⏱️ Toplam Süre: " .. string.format("%.2f", totalTime) .. " saniye\n"
	fullData = fullData .. "📅 Tarih: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
	fullData = fullData .. string.rep("═", 63) .. "\n"
	
	-- Kaydet
	if setclipboard then
		setclipboard(fullData)
		statusLabel.Text = "✅ Panoya kopyalandı! CTRL+V ile yapıştır!"
		statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	elseif writefile then
		writefile("crusty_game_copy.txt", fullData)
		statusLabel.Text = "✅ Dosyaya kaydedildi! (crusty_game_copy.txt)"
		statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	else
		statusLabel.Text = "⚠️ setclipboard/writefile yok! Output'a yazdırılıyor..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
		print(fullData)
	end
	
	updateProgress(totalObjects, totalObjects, "✅ Tamamlandı!")
	updateStats(copiedObjects, totalObjects, totalTime, "Bitti!")
	
	print("✅✅✅ CRUSTY DATA COPIER TAMAMLANDI!")
	print("📦 " .. totalObjects .. " obje kopyalandı!")
	print("⏱️ " .. string.format("%.2f", totalTime) .. " saniye sürdü!")
	
	-- 3 saniye sonra UI'yi kapat
	task.wait(3)
	screenGui:Destroy()
end

-- Başlat
task.wait(0.5)
startScan()
