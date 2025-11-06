-- LocalScript (StarterPlayer > StarterPlayerScripts içine koy)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- FFlag kontrolü için fonksiyon
local function checkForFFlags()
    warn("=== FFlag Kontrol Başlatıldı ===")
    
    -- UserSettings kontrolü
    local success, userSettings = pcall(function()
        return UserSettings()
    end)
    
    if success and userSettings then
        local gameSettings = pcall(function()
            return userSettings:GetService("UserGameSettings")
        end)
        
        if gameSettings then
            warn("UserGameSettings'e erişim sağlandı - FFlag değişiklikleri tespit edilebilir")
        end
    end
    
    -- FFlag değişikliklerini kontrol et
    local knownFFlags = {
        "DFIntTaskSchedulerTargetFps",
        "FFlagDebugGraphicsPreferVulkan",
        "DFIntMaxFrameBufferSize",
        "FFlagHandleAltEnterFullscreenManually"
    }
    
    for _, flagName in ipairs(knownFFlags) do
        local success, value = pcall(function()
            return settings():GetFFlag(flagName)
        end)
        
        if success then
            warn("⚠️ FFLAG TESPİT EDİLDİ: " .. flagName .. " = " .. tostring(value))
            
            -- Oyuncuya uyarı mesajı göster
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[UYARI] FFlag ayarı tespit edildi: " .. flagName,
                Color = Color3.fromRGB(255, 0, 0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size18
            })
        end
    end
end

-- Script başlatıldığında kontrol et
wait(2) -- Oyunun yüklenmesi için bekle
checkForFFlags()

-- Periyodik kontrol (her 30 saniyede bir)
while true do
    wait(30)
    checkForFFlags()
end
