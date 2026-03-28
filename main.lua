local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")

local Window = Rayfield:CreateWindow({
   Name = "NanzzxDev | Anti-Detection Edition",
   LoadingTitle = "Bypassing Anti-Cheat...",
   LoadingSubtitle = "by Natoaji",
})

-- [[ VARIABLES ]]
local savedBase = nil
local noclip = false
local safeFly = false
local flySpeed = 25

-- [[ LOGIKA LANTAI GAIB (ANTI-FLY DETECT) ]]
local part = Instance.new("Part")
part.Size = Vector3.new(5, 1, 5)
part.Transparency = 1 -- Tidak terlihat
part.Anchored = true
part.CanCollide = true
part.Parent = workspace

task.spawn(function()
    while task.wait() do
        local lp = game.Players.LocalPlayer
        if safeFly and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            -- Lantai gaib selalu mengikuti di bawah kaki
            part.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
            part.CanCollide = true
        else
            part.CanCollide = false
            part.CFrame = CFrame.new(0, -1000, 0) -- Buang ke jauh kalau gak dipake
        end
    end
end)

-- [[ FUNGSI MELUNCUR VIA SKY (DENGAN LANTAI GAIB) ]]
local function SkyMove(targetCFrame)
    local lp = game.Players.LocalPlayer
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and targetCFrame then
        local hrp = lp.Character.HumanoidRootPart
        local startPos = hrp.Position
        local endPos = targetCFrame.Position
        
        -- Titik Langit
        local skyPos = Vector3.new(startPos.X, 150, startPos.Z)
        local skyTarget = Vector3.new(endPos.X, 150, endPos.Z)
        
        -- Naik, Meluncur, Turun
        local t1 = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = CFrame.new(skyPos)})
        local dist = (skyPos - skyTarget).Magnitude
        local t2 = TweenService:Create(hrp, TweenInfo.new(dist/60, Enum.EasingStyle.Linear), {CFrame = CFrame.new(skyTarget)})
        local t3 = TweenService:Create(hrp, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = targetCFrame * CFrame.new(0, 3, 0)})
        
        safeFly = true -- Aktifkan lantai gaib selama meluncur
        t1:Play(); t1.Completed:Wait()
        t2:Play(); t2.Completed:Wait()
        t3:Play(); t3.Completed:Wait()
        safeFly = false
    end
end

-- [[ TABS ]]
local FarmTab = Window:CreateTab("Safe Farm", 4483362458)
local MoveTab = Window:CreateTab("Movement", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)

-- [[ FARM: AUTO BASE ]]
FarmTab:CreateButton({
   Name = "SAVE BASE",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then savedBase = hrp.CFrame end
   end,
})

local ManualAutoBase = false
FarmTab:CreateToggle({
   Name = "Instant Click + Sky Move (Anti-Ban)",
   CurrentValue = false,
   Callback = function(Value)
      ManualAutoBase = Value
      task.spawn(function()
         while ManualAutoBase do
            for _, v in pairs(game:GetDescendants()) do
               if v:IsA("ProximityPrompt") then
                  v.HoldDuration = 0 
                  if not v:GetAttribute("Connected") then
                      v:SetAttribute("Connected", true)
                      v.Triggered:Connect(function()
                         if ManualAutoBase and savedBase then
                            task.wait(0.8)
                            local char = game.Players.LocalPlayer.Character
                            local hasItem = char:FindFirstChildOfClass("Tool") or char:FindFirstChild("Handle", true)
                            
                            if hasItem then SkyMove(savedBase) end
                         end
                      end)
                  end
               end
            end
            task.wait(1.5)
         end
      end)
   end,
})

-- [[ MOVEMENT: SAFE GLIDE ]]
MoveTab:CreateToggle({
   Name = "Safe Glide (Pake Lantai Gaib)",
   CurrentValue = false,
   Callback = function(v)
      safeFly = v
      local lp = game.Players.LocalPlayer
      task.spawn(function()
         while safeFly do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                -- Kita matikan PlatformStand biar kaki tetep "napak"
                lp.Character.Humanoid.PlatformStand = false 
            end
            task.wait()
         end
      end)
   end,
})

MoveTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = function(v)
      noclip = v
      game:GetService("RunService").Stepped:Connect(function()
         if noclip and game.Players.LocalPlayer.Character then
            for _, x in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
               if x:IsA("BasePart") then x.CanCollide = false end
            end
         end
      end)
   end,
})

-- [[ VISUALS: ESP ]]
VisualTab:CreateButton({
   Name = "ESP Player",
   Callback = function()
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.FillTransparency = 0.5; h.FillColor = Color3.fromRGB(255, 0, 0)
         end
      end
   end,
})

Rayfield:LoadConfiguration()
