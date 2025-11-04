-- CRUSTY DATA COPIER
-- Hatasız, hızlı, güvenli

local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI Oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CrustyDataCopier"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
	screenGui.Parent = playerGui
end)

if not screenGui.Parent then
	screenGui.Parent = game:GetService("CoreGui")
end

-- Ana Frame
local mainFrame = Instance.new("Frame")
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
progressLabel.Size = UDim2.new(1, -40, 0, 30)
progressLabel.Position = UDim2.new(0, 20, 0, 80)
progressLabel.BackgroundTransparency = 1
progressLabel.Text = "Hazırlanıyor..."
progressLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
progressLabel.TextSize = 18
progressLabel.Font = Enum.Font.Gotham
progressLabel.TextXAlignment = Enum.TextXAlignment.Left
progressLabel.Parent = mainFrame

-- Progress Bar BG
local progressBg = Instance.new("Frame")
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
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBg

local progressBarCorner = Instance.new("UICorner")
progressBarCorner.CornerRadius = UDim.new(0, 8)
progressBarCorner.Parent = progressBar

-- Percent Label
local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 1, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.TextSize = 16
percentLabel.Font = Enum.Font.GothamBold
percentLabel.Parent = progressBg

-- Stats Label
local statsLabel = Instance.new("TextLabel")
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
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "✅ Hazır!"
statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextWrapped = true
statusLabel.Parent = mainFrame

-- Fonksiyonlar
local function updateProgress(current, total)
	local percent = math.floor((current / total) * 100)
	progressBar.Size = UDim2.new(percent / 100, 0, 1, 0)
	percentLabel.Text = percent .. "%"
end

local function updateStats(copied, total, elapsedTime, currentItem)
	statsLabel.Text = string.format("📦 Kopyalanan: %d\n📂 Toplam: %d\n⏱️ Süre: %.1fs", copied, total, elapsedTime)
	statusLabel.Text = "🔍 " .. currentItem
end

local function safeToString(value)
	local success, result = pcall(function()
		return tostring(value)
	end)
	return success and result or "ERR"
end

local function serializeInstance(instance)
	local success, result = pcall(function()
		local data = ""
		local className = safeToString(instance.ClassName)
		local name = safeToString(instance.Name)
		
		data = data .. "📦 " .. className .. ' "' .. name .. '"\n'
		
		-- Sadece temel bilgiler
		local props = {}
		pcall(function() props.Size = instance.Size end)
		pcall(function() props.Position = instance.Position end)
		pcall(function() props.Color = instance.Color end)
		pcall(function() props.Material = instance.Material end)
		pcall(function() props.Transparency = instance.Transparency end)
		pcall(function() props.Anchored = instance.Anchored end)
		
		if next(props) then
			data = data .. "⚙️  "
			for k, v in pairs(props) do
				data = data .. k .. "=" .. safeToString(v) .. " | "
			end
			data = data .. "\n"
		end
		
		-- Script (kısa)
		if className == "Script" or className == "LocalScript" or className == "ModuleScript" then
			local sourceOk, source = pcall(function() return instance.Source end)
			if sourceOk and source then
				local shortSrc = string.sub(source, 1, 100)
				data = data .. "📜 " .. shortSrc .. "...\n"
			end
		end
		
		data = data .. "\n"
		return data
	end)
	
	return success and result or ""
end

-- TARAMA
local function startScan()
	local startTime = tick()
	local fullData = "🔥 CRUSTY DATA COPIER 🔥\n" .. string.rep("=", 50) .. "\n\n"

	-- Hedefler
	local targets = {
		game:GetService("Workspace"):FindFirstChild("Events"),
		game:GetService("Workspace"):FindFirstChild("RenderedMovingAnimals"),
		game:GetService("ReplicatedStorage"):FindFirstChild("Animations") and game:GetService("ReplicatedStorage").Animations:FindFirstChild("Animals"),
		game:GetService("ReplicatedStorage"):FindFirstChild("Animations") and game:GetService("ReplicatedStorage").Animations:FindFirstChild("Events"),
		game:GetService("ReplicatedStorage"):FindFirstChild("Sounds") and game:GetService("ReplicatedStorage").Sounds:FindFirstChild("Animals"),
		game:GetService("ReplicatedStorage"):FindFirstChild("Sounds") and game:GetService("ReplicatedStorage").Sounds:FindFirstChild("Events")
	}

	-- Geçerli olanları filtrele
	local validTargets = {}
	for _, t in pairs(targets) do
		if t then
			table.insert(validTargets, t)
		end
	end

	-- Toplam hesapla
	local totalObjects = 0
	for _, target in pairs(validTargets) do
		local suc, descs = pcall(function() return target:GetDescendants() end)
		if suc and descs then
			totalObjects = totalObjects + #descs
		end
	end

	local copiedObjects = 0
	local errorCount = 0
	local lastUpdate = 0

	-- Tara
	for _, target in pairs(validTargets) do
		fullData = fullData .. "\n🗂️  " .. target:GetFullName() .. "\n" .. string.rep("-", 30) .. "\n"

		local suc, descs = pcall(function() return target:GetDescendants() end)
		if suc and descs then
			for i, desc in pairs(descs) do
				local data = serializeInstance(desc)
				if data == "" then
					errorCount = errorCount + 1
				else
					fullData = fullData .. data
				end

				copiedObjects = copiedObjects + 1

				local now = tick()
				if now - lastUpdate >= 0.15 then
					local elapsed = now - startTime
					local itemName = "..."
					pcall(function()
						itemName = desc.ClassName .. " " .. desc.Name
					end)

					progressLabel.Text = "Taranıyor: " .. target.Name
					updateProgress(copiedObjects, totalObjects)
					updateStats(copiedObjects, totalObjects, elapsed, itemName)
					lastUpdate = now
				end

				if i % 150 == 0 then
					task.wait()
				end
			end
		else
			errorCount = errorCount + 1
		end
	end

	-- Özet
	local totalTime = tick() - startTime
	fullData = fullData .. "\n" .. string.rep("=", 50) .. "\n"
	fullData = fullData .. "✅ TAMAMLANDI!\n"
	fullData = fullData .. "📦 Kopyalanan: " .. copiedObjects .. "\n"
	fullData = fullData .. "❌ Hatalar: " .. errorCount .. "\n"
	fullData = fullData .. "⏱️ Süre: " .. string.format("%.2f", totalTime) .. "s\n"
	fullData = fullData .. string.rep("=", 50) .. "\n"

	-- Kaydet
	local saved = false

	if setclipboard then
		pcall(function()
			setclipboard(fullData)
			statusLabel.Text = "✅ PANOYA KOPYALANDI! CTRL+V YAP!"
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			saved = true
		end)
	end

	if not saved and writefile then
		pcall(function()
			writefile("crusty_game_copy.txt", fullData)
			statusLabel.Text = "✅ DOSYAYA KAYDEDİLDİ! crusty_game_copy.txt"
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			saved = true
		end)
	end

	if not saved then
		statusLabel.Text = "⚠️ OUTPUT'A YAZILDI! KONSOLA BAK!"
		statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
		print(fullData)
	end

	updateProgress(totalObjects, totalObjects)
	progressLabel.Text = "✅ BİTTİ!"

	print("✅ CRUSTY DATA COPIER BİTTİ!")
	print("📦 " .. copiedObjects .. " obje kopyalandı")
	print("❌ " .. errorCount .. " hata atlandı")

	task.wait(5)
	pcall(function()
		screenGui:Destroy()
	end)
end

-- BAŞLAT
task.spawn(function()
	task.wait(0.5)
	pcall(startScan)
end)
