-- Brainrot UI LocalScript
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local workspace = game:GetService("Workspace")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- ScreenGui oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Ana Frame (UI Container)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 180)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Corner için UICorner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Üst Bar (Sürüklemek için)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 10)
topCorner.Parent = topBar

-- TextLabel (Brainrot yazısı)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Brainrot"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Kapat Butonu (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -32, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- TextBox (Brainrot adı için)
local nameTextBox = Instance.new("TextBox")
nameTextBox.Name = "NameTextBox"
nameTextBox.Size = UDim2.new(0, 260, 0, 40)
nameTextBox.Position = UDim2.new(0.5, -130, 0, 50)
nameTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
nameTextBox.Text = "Hayvan Adı Gir"
nameTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
nameTextBox.TextSize = 16
nameTextBox.Font = Enum.Font.Gotham
nameTextBox.ClearTextOnFocus = true
nameTextBox.BorderSizePixel = 0
nameTextBox.Parent = mainFrame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 8)
textBoxCorner.Parent = nameTextBox

-- Spawn Butonu
local spawnButton = Instance.new("TextButton")
spawnButton.Name = "SpawnButton"
spawnButton.Size = UDim2.new(0, 200, 0, 45)
spawnButton.Position = UDim2.new(0.5, -100, 0, 105)
spawnButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
spawnButton.Text = "Spawn"
spawnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
spawnButton.TextSize = 20
spawnButton.Font = Enum.Font.GothamBold
spawnButton.BorderSizePixel = 0
spawnButton.Parent = mainFrame

local spawnCorner = Instance.new("UICorner")
spawnCorner.CornerRadius = UDim.new(0, 8)
spawnCorner.Parent = spawnButton

-- Sürükleme Fonksiyonu
local dragging = false
local dragInput, mousePos, framePos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(
			framePos.X.Scale,
			framePos.X.Offset + delta.X,
			framePos.Y.Scale,
			framePos.Y.Offset + delta.Y
		)
	end
end)

-- Kapat Butonu Fonksiyonu
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Spawn Butonu Fonksiyonu
spawnButton.MouseButton1Click:Connect(function()
	local brainrotName = nameTextBox.Text
	
	-- Boş isim kontrolü
	if brainrotName == "" or brainrotName == "Hayvan Adı Gir" then
		warn("Lütfen bir hayvan adı girin!")
		return
	end
	
	print("Spawn işlemi başlatılıyor: " .. brainrotName)
	
	-- Workspace/RenderedMovingAnimals klasörünü kontrol et
	local renderedFolder = workspace:FindFirstChild("RenderedMovingAnimals")
	if not renderedFolder then
		warn("RenderedMovingAnimals klasörü bulunamadı!")
		return
	end
	
	-- ReplicatedStorage'dan yeni modeli al
	local modelsFolder = replicatedStorage:FindFirstChild("Models")
	if not modelsFolder then
		warn("ReplicatedStorage/Models klasörü bulunamadı!")
		return
	end
	
	local animalsFolder = modelsFolder:FindFirstChild("Animals")
	if not animalsFolder then
		warn("ReplicatedStorage/Models/Animals klasörü bulunamadı!")
		return
	end
	
	local newModel = animalsFolder:FindFirstChild(brainrotName)
	if not newModel then
		warn("ReplicatedStorage/Models/Animals/" .. brainrotName .. " modeli bulunamadı!")
		return
	end
	
	-- Animasyon klasörünü kontrol et
	local animationsFolder = replicatedStorage:FindFirstChild("Animations")
	if not animationsFolder then
		warn("ReplicatedStorage/Animations klasörü bulunamadı!")
		return
	end
	
	local animAnimalsFolder = animationsFolder:FindFirstChild("Animals")
	if not animAnimalsFolder then
		warn("ReplicatedStorage/Animations/Animals klasörü bulunamadı!")
		return
	end
	
	local animalAnimFolder = animAnimalsFolder:FindFirstChild(brainrotName)
	if not animalAnimFolder then
		warn("ReplicatedStorage/Animations/Animals/" .. brainrotName .. " klasörü bulunamadı!")
		return
	end
	
	local walkAnimation = animalAnimFolder:FindFirstChild("Walk")
	if not walkAnimation then
		warn("Walk animasyonu bulunamadı!")
		return
	end
	
	-- RenderedMovingAnimals içindeki modeli değiştir
	-- Yeni oluşan ilk modeli bekle ve değiştir
	local connection
	connection = renderedFolder.ChildAdded:Connect(function(child)
		if child:IsA("Model") then
			print("Yeni model algılandı: " .. child.Name)
			
			-- Modeli klonla ve değiştir
			local clonedModel = newModel:Clone()
			clonedModel.Name = child.Name
			clonedModel.Parent = renderedFolder
			
			-- Eski modelin pozisyonunu kopyala
			if child.PrimaryPart and clonedModel.PrimaryPart then
				clonedModel:SetPrimaryPartCFrame(child.PrimaryPart.CFrame)
			end
			
			-- AnimationController ekle veya bul
			local animController = clonedModel:FindFirstChildOfClass("AnimationController")
			if not animController then
				animController = Instance.new("AnimationController")
				animController.Parent = clonedModel
			end
			
			-- Animator ekle
			local animator = animController:FindFirstChildOfClass("Animator")
			if not animator then
				animator = Instance.new("Animator")
				animator.Parent = animController
			end
			
			-- Walk animasyonunu yükle ve oynat
			local walkTrack = animator:LoadAnimation(walkAnimation)
			walkTrack:Play()
			
			-- Eski modeli sil
			child:Destroy()
			
			print("Model başarıyla değiştirildi: " .. brainrotName)
			connection:Disconnect()
		end
	end)
	
	-- 30 saniye sonra bağlantıyı kes (güvenlik için)
	task.delay(30, function()
		if connection then
			connection:Disconnect()
		end
	end)
end)

-- Buton Hover Efekti
spawnButton.MouseEnter:Connect(function()
	spawnButton.BackgroundColor3 = Color3.fromRGB(70, 200, 85)
end)

spawnButton.MouseLeave:Connect(function()
	spawnButton.BackgroundColor3 = Color3.fromRGB(60, 180, 75)
end)

closeButton.MouseEnter:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
end)

closeButton.MouseLeave:Connect(function()
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)
