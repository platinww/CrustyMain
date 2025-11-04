-- ULTRA Workspace Kopyalayıcı LocalScript
-- Tüm detayları kopyalar

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
		return string.format("Color3.fromRGB(%d, %d, %d)", value.R * 255, value.G * 255, value.B * 255)
	elseif valueType == "CFrame" then
		local x, y, z = value.Position.X, value.Position.Y, value.Position.Z
		local rx, ry, rz = value:ToOrientation()
		return string.format("CFrame.new(%.3f, %.3f, %.3f) * CFrame.Angles(%.3f, %.3f, %.3f)", x, y, z, rx, ry, rz)
	elseif valueType == "UDim2" then
		return string.format("UDim2.new(%.3f, %d, %.3f, %d)", value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset)
	elseif valueType == "BrickColor" then
		return "BrickColor.new(\"" .. tostring(value) .. "\")"
	elseif valueType == "EnumItem" then
		return "Enum." .. tostring(value)
	elseif valueType == "string" then
		return "\"" .. value .. "\""
	else
		return tostring(value)
	end
end

local function getAllProperties(instance)
	local props = {}
	local success, properties = pcall(function()
		return game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json"))
	end)
	
	-- Temel property'ler
	local basicProps = {
		"Name", "ClassName", "Parent",
		"Anchored", "CanCollide", "Transparency", "Reflectance", "Material", "BrickColor", "Color",
		"Size", "Position", "Orientation", "CFrame", "Rotation",
		"Texture", "TextureId", "MeshId", "Scale", "Offset", "VertexColor",
		"Volume", "Pitch", "SoundId", "Looped", "PlaybackSpeed", "RollOffMode", "RollOffMaxDistance", "RollOffMinDistance",
		"AnimationId", "TimePosition", "Playing",
		"Velocity", "MaxForce", "P", "D", "MaxVelocity",
		"Text", "TextColor3", "TextSize", "Font", "BackgroundColor3", "BorderColor3", "BackgroundTransparency",
		"Value", "Enabled", "Brightness", "Range", "Shadows", "Face", "Angle",
		"MaxSpeed", "Acceleration", "Friction", "WalkSpeed", "JumpPower", "Health", "MaxHealth",
		"C0", "C1", "Part0", "Part1",
		"Target", "MaxDistance", "Restitution",
		"Image", "ImageColor3", "ImageTransparency", "ScaleType",
		"ZIndex", "Visible", "ClipsDescendants"
	}
	
	for _, propName in pairs(basicProps) do
		local success, value = pcall(function()
			return instance[propName]
		end)
		if success and value ~= nil then
			-- Parent'i atlama (sonsuz döngü olmasın)
			if propName ~= "Parent" or (propName == "Parent" and value) then
				props[propName] = value
			end
		end
	end
	
	return props
end

local function serializeInstance(instance, indent, visitedTables)
	indent = indent or ""
	visitedTables = visitedTables or {}
	
	if visitedTables[instance] then
		return indent .. "⚠️ [ALREADY VISITED: " .. instance.Name .. "]\n"
	end
	visitedTables[instance] = true
	
	local result = ""
	local separator = "═══════════════════════════════════════════════════════════════\n"
	
	-- Header
	result = result .. indent .. separator
	result = result .. indent .. "📦 INSTANCE: " .. instance.ClassName .. "\n"
	result = result .. indent .. "📍 NAME: " .. instance.Name .. "\n"
	result = result .. indent .. "🗂️  FULL PATH: " .. getFullPath(instance) .. "\n"
	result = result .. indent .. separator
	
	-- Properties
	result = result .. indent .. "⚙️  PROPERTIES:\n"
	local props = getAllProperties(instance)
	local sortedProps = {}
	for k in pairs(props) do
		table.insert(sortedProps, k)
	end
	table.sort(sortedProps)
	
	for _, propName in pairs(sortedProps) do
		local value = props[propName]
		if typeof(value) == "Instance" then
			result = result .. indent .. "  • " .. propName .. ": [Instance] " .. value.ClassName .. " '" .. value.Name .. "'\n"
		else
			result = result .. indent .. "  • " .. propName .. ": " .. serializeValue(value) .. "\n"
		end
	end
	
	-- Script Source
	if instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript") then
		result = result .. indent .. "\n"
		result = result .. indent .. "📜 SOURCE CODE:\n"
		result = result .. indent .. "```lua\n"
		local sourceLines = string.split(instance.Source, "\n")
		for i, line in pairs(sourceLines) do
			result = result .. indent .. string.format("%3d | %s\n", i, line)
		end
		result = result .. indent .. "```\n"
	end
	
	-- Tags
	local tags = instance:GetTags()
	if #tags > 0 then
		result = result .. indent .. "\n"
		result = result .. indent .. "🏷️  TAGS: " .. table.concat(tags, ", ") .. "\n"
	end
	
	-- Attributes
	local attributes = instance:GetAttributes()
	if next(attributes) then
		result = result .. indent .. "\n"
		result = result .. indent .. "📎 ATTRIBUTES:\n"
		for attrName, attrValue in pairs(attributes) do
			result = result .. indent .. "  • " .. attrName .. ": " .. tostring(attrValue) .. "\n"
		end
	end
	
	-- Children
	local children = instance:GetChildren()
	if #children > 0 then
		result = result .. indent .. "\n"
		result = result .. indent .. "👶 CHILDREN (" .. #children .. "):\n"
		result = result .. indent .. "├─────────────────────────────────────────────────────────\n"
		for i, child in pairs(children) do
			local prefix = i == #children and "└─ " or "├─ "
			local childIndent = i == #children and "   " or "│  "
			result = result .. indent .. prefix .. child.ClassName .. ' "' .. child.Name .. '"\n'
			result = result .. serializeInstance(child, indent .. childIndent, visitedTables)
		end
	end
	
	result = result .. "\n"
	return result
end

-- ANA IŞLEM
print("🚀 Workspace kopyalama başlatılıyor...")
wait(0.5)

local fullData = [[
╔═══════════════════════════════════════════════════════════════╗
║           🎮 ROBLOX WORKSPACE FULL COPY 🎮                    ║
║              Tüm Detaylar Dahil                               ║
╚═══════════════════════════════════════════════════════════════╝

]]

local totalObjects = 0

for _, child in pairs(workspace:GetChildren()) do
	-- Kamera ve Terrain'i atlama
	if child.Name ~= "Camera" and child.Name ~= "Terrain" then
		fullData = fullData .. serializeInstance(child)
		totalObjects = totalObjects + 1
	end
end

fullData = fullData .. "\n" .. string.rep("═", 63) .. "\n"
fullData = fullData .. "✅ TOPLAM OBJE: " .. totalObjects .. "\n"
fullData = fullData .. "📅 TARİH: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
fullData = fullData .. string.rep("═", 63) .. "\n"

-- Panoya kopyala
if setclipboard then
	setclipboard(fullData)
	print("✅ Workspace panoya kopyalandı! (setclipboard)")
	print("📋 Toplam " .. totalObjects .. " obje kopyalandı!")
	print("👉 Şimdi CTRL+V yaparak yapıştırabilirsin!")
elseif writefile then
	writefile("workspace_copy.txt", fullData)
	print("✅ Workspace dosyaya kaydedildi! (workspace_copy.txt)")
	print("📋 Toplam " .. totalObjects .. " obje kopyalandı!")
	print("👉 Exploit klasöründen 'workspace_copy.txt' dosyasını aç!")
else
	print("⚠️ setclipboard/writefile bulunamadı. Output'tan kopyala:")
	print(fullData)
end

print("✅✅✅ İşlem tamamlandı!")
