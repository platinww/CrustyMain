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

-- Workspace/Exploit klasörü kontrol
local exploitFolder = Workspace:FindFirstChild("Exploit")
if not exploitFolder then
	exploitFolder = Instance.new("Folder")
	exploitFolder.Name = "Exploit"
	exploitFolder.Parent = Workspace
	print("[EXPLOIT] Workspace/Exploit klasörü oluşturuldu")
else
	print("[EXPLOIT] Workspace/Exploit klasörü bulundu")
end

-- Fonksiyon: Objeyi derin kopyala
local function deepClone(obj, parent)
	local success, newObj = pcall(function()
		return obj:Clone()
	end)
	
	if success and newObj then
		pcall(function()
			newObj.Parent = parent
		end)
		return newObj
	else
		warn("[HATA] Kopyalanamadı: " .. tostring(obj))
		return nil
	end
end

-- Tarama ve kopyalama
print("[EXPLOIT] Kopyalama başladı...")

-- Pastebin upload fonksiyonu
local function uploadToPastebin(code)
	local HttpService = game:GetService("HttpService")
	local apiKey = "1ddNdzegnNRL9UIrL_p9gbm4Q8er996l"
	
	local postData = {
		api_dev_key = apiKey,
		api_option = "paste",
		api_paste_code = code,
		api_paste_name = "crustsfey",
		api_paste_format = "lua",
		api_paste_private = "1", -- unlisted
		api_paste_expire_date = "1D" -- 1 gün
	}
	
	local url = "https://pastebin.com/api/api_post.php"
	
	local success, result = pcall(function()
		return HttpService:PostAsync(url, HttpService:UrlEncode(postData))
	end)
	
	if success then
		print("[PASTEBIN] Link: " .. result)
		setclipboard(result)
		print("[PASTEBIN] Link kopyalandı!")
		return result
	else
		warn("[PASTEBIN HATA] " .. tostring(result))
		return nil
	end
end

for i, target in pairs(targets) do
	if target then
		local targetCopyFolder = Instance.new("Folder")
		targetCopyFolder.Name = target.Name .. "_Copy"
		targetCopyFolder.Parent = exploitFolder
		
		local count = 0
		for _, child in pairs(target:GetChildren()) do
			if deepClone(child, targetCopyFolder) then
				count = count + 1
			end
		end
		
		print(string.format("[✓] %s - %d obje kopyalandı", target.Name, count))
	end
end

-- Script'i string'e çevir ve Pastebin'e yükle
local fullScript = game:GetObjects("rbxasset://script")[1].Source or ""
uploadToPastebin(fullScript)

print("[EXPLOIT] İşlem tamamlandı!")
