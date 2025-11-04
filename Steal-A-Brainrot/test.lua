-- Hedef servisler
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Hedef klasörler
local targets = {
	Workspace:FindFirstChild("Events"),
	Workspace:FindFirstChild("RenderedMovingAnimals"),
	ReplicatedStorage:FindFirstChild("Animations") and ReplicatedStorage.Animations:FindFirstChild("Animals"),
	ReplicatedStorage:FindFirstChild("Animations") and ReplicatedStorage.Animations:FindFirstChild("Events"),
	ReplicatedStorage:FindFirstChild("Sounds") and ReplicatedStorage.Sounds:FindFirstChild("Animals"),
	ReplicatedStorage:FindFirstChild("Sounds") and ReplicatedStorage.Sounds:FindFirstChild("Events")
}

-- Workspace içi Explot klasörü
local explotFolder = Workspace:FindFirstChild("Explot") or Instance.new("Folder")
explotFolder.Name = "Explot"
explotFolder.Parent = Workspace

-- Fonksiyon: Objeyi Explot klasörüne kopyala
local function cloneToExplot(obj, parent)
	local newObj
	local success, err = pcall(function()
		newObj = Instance.new(obj.ClassName)
		newObj.Name = obj.Name
		-- Temel özellikler
		pcall(function() newObj.Position = obj.Position end)
		pcall(function() newObj.Size = obj.Size end)
		pcall(function() newObj.Color = obj.Color end)
		pcall(function() newObj.Material = obj.Material end)
		pcall(function() newObj.Transparency = obj.Transparency end)
		pcall(function() newObj.Anchored = obj.Anchored end)
		newObj.Parent = parent
	end)
	if not success then
		warn("Kopyalanamadı: " .. obj:GetFullName())
		return nil
	end
	-- Rekürsif alt objeler
	for _, child in pairs(obj:GetChildren()) do
		cloneToExplot(child, newObj)
	end
	return newObj
end

-- Tarama ve kopyalama
for _, target in pairs(targets) do
	if target then
		local targetCopyFolder = Instance.new("Folder")
		targetCopyFolder.Name = target.Name
		targetCopyFolder.Parent = explotFolder
		for _, desc in pairs(target:GetChildren()) do
			cloneToExplot(desc, targetCopyFolder)
		end
	end
end

print("✅ Tüm objeler Workspace/Explot klasörüne kopyalandı!")
