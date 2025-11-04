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
		"Anchored", "CanCollide", "Transparency", "Material", "Color", "Size", "Position",
		"TextureId", "MeshId", "SoundId", "AnimationId", "Value"
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
	local success, result = pcall(function()
		local data = ""
		
		data = data .. "📦 " .. instance.ClassName .. ' "' .. instance.Name .. '"\n'
		data = data .. "📍 " .. getFullPath(instance) .. "\n"
		
		-- Properties (sadece önemli olanlar)
		local props = getAllProperties(instance)
		if next(props) then
			data = data .. "⚙️  "
			for propName, value in pairs(props) do
				if typeof(value) ~= "Instance" then
					data = data .. propName .. "=" .. serializeValue(value) .. " | "
				end
			end
			data = data .. "\n"
		end
		
		-- Script source (ilk 200 karakter)
		if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
			local source = instance.Source
			if #source > 200 then
				source = string.sub(source, 1, 200) .. "... [TRUNCATED]"
			end
			data = data .. "📜 " .. source .. "\n"
		end
		
		data = data .. "\n"
		return data
	end)
	
	if success then
		return result
	else
		return "❌ ERROR: " .. instance.ClassName .. " '" .. instance.Name .. "' - " .. tostring(result) .. "\n\n"
	end
end

-- TARAMA BAŞLAT
local function startScan()
	local startTime = tick()
	local fullData = "🔥 CRUSTY DATA COPIER - FULL GAME SCAN 🔥\n" .. string.rep("═", 63) .. "\n\n"
	
	-- Tüm servisleri topla (sadece LocalScript'in erişebildikleri)
	local services = {
		{game.Workspace, "Workspace"},
		{game.ReplicatedStorage, "ReplicatedStorage"},
		{game.Lighting, "Lighting"},
		{game.StarterGui, "StarterGui"},
		{game.StarterPlayer, "StarterPlayer"},
		{game.Players, "Players"}
	}
	
	-- Opsiyonel servisler (hata verirse atla)
	local optionalServices = {
		"ReplicatedFirst",
		"SoundService",
		"Teams",
		"Chat"
	}
	
	for _, serviceName in pairs(optionalServices) do
		local success, service = pcall(function()
			return game:GetService(serviceName)
		end)
		if success and service then
			table.insert(services, {service, serviceName})
		end
	end
	
	-- Toplam obje sayısını hızlıca hesapla
	local totalObjects = 0
	for _, serviceData in pairs(services) do
		local success, count = pcall(function()
			return #serviceData[1]:GetDescendants()
		end)
		if success then
			totalObjects = totalObjects + count
		end
	end
	
	local copiedObjects = 0
	local errorCount = 0
	local lastUpdate = tick()
	
	-- Her servisi tara
	for _, serviceData in pairs(services) do
		local service = serviceData[1]
		local serviceName = serviceData[2]
		
		fullData = fullData .. "\n🗂️  " .. serviceName .. "\n" .. string.rep("─", 40) .. "\n"
		
		local success, descendants = pcall(function()
			return service:GetDescendants()
		end)
		
		if success then
			for i, descendant in pairs(descendants) do
				-- Hata yönetimi ile veriyi ekle
				local data = serializeInstance(descendant)
				if string.find(data, "❌ ERROR") then
					errorCount = errorCount + 1
				end
				fullData = fullData .. data
				
				copiedObjects = copiedObjects + 1
				
				-- UI'yi her 0.1 saniyede bir güncelle (performans için)
				local now = tick()
				if now - lastUpdate >= 0.1 then
					local elapsed = now - startTime
					updateProgress(copiedObjects, totalObjects, "Taranıyor: " .. serviceName)
					updateStats(copiedObjects, totalObjects, elapsed, descendant.ClassName .. ' "' .. descendant.Name .. '"')
					lastUpdate = now
				end
				
				-- Her 100 objede bir bekle (daha az lag)
				if i % 100 == 0 then
					task.wait()
				end
			end
		else
			fullData = fullData .. "❌ SERVICE ERROR: " .. serviceName .. " - " .. tostring(descendants) .. "\n\n"
			errorCount = errorCount + 1
		end
	end
	
	-- Özet
	local totalTime = tick() - startTime
	fullData = fullData .. "\n" .. string.rep("═", 63) .. "\n"
	fullData = fullData .. "✅ TARAMA TAMAMLANDI!\n"
	fullData = fullData .. "📦 Kopyalanan: " .. copiedObjects .. " / " .. totalObjects .. "\n"
	fullData = fullData .. "❌ Hatalar: " .. errorCount .. "\n"
	fullData = fullData .. "⏱️ Süre: " .. string.format("%.2f", totalTime) .. "s\n"
	fullData = fullData .. "📅 " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
	fullData = fullData .. string.rep("═", 63) .. "\n"
	
	-- Kaydet
	local saveSuccess = false
	if setclipboard then
		local success = pcall(function()
			setclipboard(fullData)
		end)
		if success then
			statusLabel.Text = "✅ Panoya kopyalandı! CTRL+V"
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			saveSuccess = true
		end
	end
	
	if not saveSuccess and writefile then
		local success = pcall(function()
			writefile("crusty_game_copy.txt", fullData)
		end)
		if success then
			statusLabel.Text = "✅ crusty_game_copy.txt kaydedildi!"
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			saveSuccess = true
		end
	end
	
	if not saveSuccess then
		statusLabel.Text = "⚠️ Output'a yazdırılıyor..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
		print(fullData)
	end
	
	updateProgress(totalObjects, totalObjects, "✅ Tamamlandı!")
	updateStats(copiedObjects, totalObjects, totalTime, "Bitti! " .. errorCount .. " hata atlandı.")
	
	print("✅ CRUSTY DATA COPIER TAMAMLANDI!")
	print("📦 " .. copiedObjects .. " / " .. totalObjects .. " obje kopyalandı")
	print("❌ " .. errorCount .. " hata atlandı")
	print("⏱️ " .. string.format("%.2f", totalTime) .. " saniye")
	
	-- 5 saniye sonra UI'yi kapat
	task.wait(5)
	screenGui:Destroy()
end

-- Başlat
task.wait(0.5)
startScan()
