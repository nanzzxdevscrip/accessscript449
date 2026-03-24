-- Ganti link Github di bawah ini dengan link 'Raw' repository kamu
local rawUrl = "https://raw.githubusercontent.com/UsernameKamu/RepoKamu/main/"

-- Setup Gambar
local fileName = "NanzzxLogo.jpg"
if not isfile(fileName) then
    writefile(fileName, game:HttpGet("https://files.catbox.moe/iu414m.jpg"))
end

-- Create ScreenGui Utama
local player = game:GetService("Players").LocalPlayer
if player.PlayerGui:FindFirstChild("NanzzxUI_Mobile") then player.PlayerGui.NanzzxUI_Mobile:Destroy() end
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "NanzzxUI_Mobile"
ScreenGui.IgnoreGuiInset = true

-- Ambil Script Intro dan Menu dari Github
local Intro = loadstring(game:HttpGet(rawUrl .. "intrologo.lua"))()
local Menu = loadstring(game:HttpGet(rawUrl .. "tampilanmenu.lua"))()

-- JALANKAN PROSES
Intro.Run(ScreenGui, fileName) -- Munculkan Intro 10 Detik
Menu.Create(ScreenGui) -- Setelah intro selesai, munculkan Menu

