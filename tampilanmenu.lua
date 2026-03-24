local Players = game:GetService("Players")
local player = Players.LocalPlayer
local Menu = {}

function Menu.Create(ScreenGui)
    local MainMenu = Instance.new("Frame")
    MainMenu.Name = "MainMenu"
    MainMenu.Size = UDim2.new(0, 420, 0, 260)
    MainMenu.Position = UDim2.new(0.5, -210, 0.5, -130)
    MainMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MainMenu.BackgroundTransparency = 0.5
    MainMenu.BorderSizePixel = 0
    MainMenu.Visible = true
    MainMenu.Parent = ScreenGui

    Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)

    -- RGB Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "NANZZXDEV"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothamBold
    Title.Parent = MainMenu

    local Grad = Instance.new("UIGradient", Title)
    spawn(function()
        while task.wait() do
            local t = tick()
            Grad.Color = ColorSequence.new(Color3.fromHSV(t % 5 / 5, 1, 1), Color3.fromHSV((t + 0.1) % 5 / 5, 1, 1))
        end
    end)

    -- Line Separator
    local Line = Instance.new("Frame", MainMenu)
    Line.Size = UDim2.new(0.9, 0, 0, 2)
    Line.Position = UDim2.new(0.05, 0, 0, 45)
    Line.BackgroundTransparency = 0.6

    -- Content & Button Profil
    local Content = Instance.new("Frame", MainMenu)
    Content.Size = UDim2.new(0.65, 0, 0.7, 0)
    Content.Position = UDim2.new(0.32, 0, 0.22, 0)
    Content.BackgroundTransparency = 1

    local ProfileBtn = Instance.new("TextButton", MainMenu)
    ProfileBtn.Size = UDim2.new(0, 100, 0, 35)
    ProfileBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
    ProfileBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    ProfileBtn.Text = "Profil"
    ProfileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", ProfileBtn).CornerRadius = UDim.new(0, 8)

    -- Profil Logic
    ProfileBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Content:GetChildren()) do v:Destroy() end
        local Av = Instance.new("ImageLabel", Content)
        Av.Size = UDim2.new(0, 65, 0, 65)
        Av.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        Av.BackgroundTransparency = 1
        Instance.new("UICorner", Av).CornerRadius = UDim.new(1, 0)

        local function Lbl(j, i, y)
            local f = Instance.new("Frame", Content)
            f.Size = UDim2.new(1, 0, 0, 25)
            f.Position = UDim2.new(0, 0, 0, y)
            f.BackgroundTransparency = 1
            local t1 = Instance.new("TextLabel", f)
            t1.Text = j..":"; t1.TextColor3 = Color3.fromRGB(255,0,0); t1.Size = UDim2.new(0,80,1,0); t1.BackgroundTransparency = 1; t1.Font = "GothamBold"
            local t2 = Instance.new("TextLabel", f)
            t2.Text = i; t2.TextColor3 = Color3.fromRGB(0,150,255); t2.Position = UDim2.new(0,85,0,0); t2.Size = UDim2.new(0,150,1,0); t2.BackgroundTransparency = 1
        end
        Lbl("Profil", "Main Profil", 80)
        Lbl("Daftar", os.date("%d %B %Y", os.time() - (player.AccountAge * 86400)), 110)
    end)
end

return Menu

