local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NanzzxDev VIP Hub | Nusantara Edition",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by Natoaji",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NanzzxConfig",
      FileName = "DeltaHub"
   }
})

Rayfield.Flags = {["NoNotifications"] = true}

-- GUI CHAT SPY (DIPERBAIKI)
local SpyGui = Instance.new("ScreenGui")
local SpyFrame = Instance.new("Frame")
local SpyLabel = Instance.new("TextLabel")

SpyGui.Name = "NanzzxChatSpy"
SpyGui.Parent = game.CoreGui
SpyGui.Enabled = false

SpyFrame.Name = "SpyFrame"
SpyFrame.Parent = SpyGui
SpyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpyFrame.BackgroundTransparency = 0.5
SpyFrame.Position = UDim2.new(0.75, 0, 0.05, 0)
SpyFrame.Size = UDim2.new(0, 250, 0, 180) -- Sedikit lebih tinggi

SpyLabel.Name = "SpyLabel"
SpyLabel.Parent = SpyFrame
SpyLabel.BackgroundTransparency = 1
SpyLabel.Size = UDim2.new(1, -10, 1, -10)
SpyLabel.Position = UDim2.new(0, 5, 0, 5)
SpyLabel.Font = Enum.Font.SourceSansBold
SpyLabel.Text = "--- Chat Spy Active ---"
SpyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpyLabel.TextSize = 14
SpyLabel.TextWrapped = true
SpyLabel.TextYAlignment = Enum.TextYAlignment.Top
SpyLabel.TextXAlignment = Enum.TextXAlignment.Left

local MainTab = Window:CreateTab("Main Features", 4483362458)
local ClientTab = Window:CreateTab("Client Features", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

--- [[ FITUR UTAMA ]] ---

-- 1. FLY
local flying, speed = false, 50
MainTab:CreateToggle({
   Name = "Fly (Terbang)",
   CurrentValue = false,
   Callback = function(v)
      flying = v
      local lp = game.Players.LocalPlayer
      if flying then
         local bg = Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
         local bv = Instance.new("BodyPosition", lp.Character.HumanoidRootPart)
         bg.P, bg.maxTorque = 9e4, Vector3.new(9e9, 9e9, 9e9)
         bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         task.spawn(function()
            while flying do
               lp.Character.Humanoid.PlatformStand = true
               bv.position = lp.Character.HumanoidRootPart.Position + (workspace.CurrentCamera.CFrame.LookVector * (speed/10))
               bg.cframe = workspace.CurrentCamera.CFrame
               task.wait()
            end
            lp.Character.Humanoid.PlatformStand = false
            bg:Destroy(); bv:Destroy()
         end)
      end
   end,
})

-- 2. NO CLIP
local noclip = false
MainTab:CreateToggle({
   Name = "Noclip (Tembus Tembok)",
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

-- 3. AIM LOCK (Smooth & Tool Only)
local Aimlock = false
MainTab:CreateToggle({
   Name = "Aim Lock (Kunci Kepala)",
   CurrentValue = false,
   Callback = function(v)
      Aimlock = v
      game:GetService("RunService").RenderStepped:Connect(function()
         local lp = game.Players.LocalPlayer
         if Aimlock and lp.Character:FindFirstChildOfClass("Tool") then
            local target, dist = nil, math.huge
            for _, p in pairs(game.Players:GetPlayers()) do
               if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                  local pos, sc = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                  if sc then
                     local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).magnitude
                     if m < dist then target = p; dist = m end
                  end
               end
            end
            if target then
               workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position), 0.2)
            end
         end
      end)
   end,
})

-- 8. GOD MODE (UTAMA)
MainTab:CreateToggle({
   Name = "God Mode (Gak Bisa Mati)",
   CurrentValue = false,
   Callback = function(v)
      if v then
         local lp = game.Players.LocalPlayer
         local char = lp.Character
         local hum = char:FindFirstChildOfClass("Humanoid")
         if hum then
            local newHum = hum:Clone()
            newHum.Parent = char
            hum:Destroy()
            lp.Character = char
            workspace.CurrentCamera.CameraSubject = char:FindFirstChild("Humanoid")
         end
      end
   end,
})

-- 9. KILL AURA
local KillAura = false
MainTab:CreateToggle({
   Name = "Kill Aura (Insta Kill)",
   CurrentValue = false,
   Callback = function(v)
      KillAura = v
      task.spawn(function()
         while KillAura do
            for _, p in pairs(game.Players:GetPlayers()) do
               if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).magnitude < 20 then
                     local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                     if tool then tool:Activate(); pcall(function() firetouchinterest(p.Character.Head, tool.Handle, 0); firetouchinterest(p.Character.Head, tool.Handle, 1) end) end
                  end
               end
            end
            task.wait(0.1)
         end
      end)
   end,
})

-- 12. CHAT SPY (DIPERBAIKI: Muncul Chat Sendiri & Orang Lain)
local ChatSpyActive, chatHistory = false, {}
ClientTab:CreateToggle({
   Name = "Chat Spy (UI Kanan Atas)",
   CurrentValue = false,
   Callback = function(Value)
      ChatSpyActive = Value
      SpyGui.Enabled = Value
      if ChatSpyActive then
         -- Listener untuk Orang Lain
         pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.OnMessageDoneFiltering.OnClientEvent:Connect(function(data)
               if ChatSpyActive and data then
                  table.insert(chatHistory, "[" .. tostring(data.FromSpeaker) .. "]: " .. tostring(data.Message))
                  if #chatHistory > 10 then table.remove(chatHistory, 1) end
                  SpyLabel.Text = table.concat(chatHistory, "\n")
               end
            end)
         end)
         -- Listener untuk Chat Sendiri (Biar masuk ke Label juga)
         game.Players.LocalPlayer.Chatted:Connect(function(msg)
            if ChatSpyActive then
               table.insert(chatHistory, "[YOU]: " .. msg)
               if #chatHistory > 10 then table.remove(chatHistory, 1) end
               SpyLabel.Text = table.concat(chatHistory, "\n")
            end
         end)
      else
         chatHistory = {}; SpyLabel.Text = "--- Chat Spy Active ---"
      end
   end,
})

--- [[ FITUR LAINNYA ]] ---

VisualTab:CreateButton({
   Name = "Aktifkan ESP Player",
   Callback = function()
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer then
            local h = Instance.new("Highlight", p.Character)
            h.FillTransparency = 0.5
            h.FillColor = game.Players.LocalPlayer:IsFriendsWith(p.UserId) and Color3.fromRGB(255,0,0) or Color3.fromRGB(0,0,255)
            local b = Instance.new("BillboardGui", p.Character.Head)
            b.Size, b.AlwaysOnTop = UDim2.new(0,100,0,50), true
            local l = Instance.new("TextLabel", b)
            l.Text, l.TextColor3, l.BackgroundTransparency, l.Size = p.Name, Color3.new(1,1,1), 1, UDim2.new(1,0,1,0)
         end
      end
   end,
})

-- AUTO TELEPORT LIST
local pList = {}
for _, v in pairs(game.Players:GetPlayers()) do if v ~= game.Players.LocalPlayer then table.insert(pList, v.Name) end end
TeleportTab:CreateDropdown({
   Name = "Pilih Player",
   Options = pList,
   CurrentOption = "",
   Callback = function(opt)
      local t = game.Players:FindFirstChild(opt[1])
      if t and t.Character then
         game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
         game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
      end
   end,
})

-- Fitur Pelengkap
ClientTab:CreateToggle({Name = "Invisible", CurrentValue = false, Callback = function(v) end})
MainTab:CreateToggle({Name = "Wallbang", CurrentValue = false, Callback = function(v) end})
MainTab:CreateToggle({Name = "Auto Reload", CurrentValue = false, Callback = function(v) end})

Rayfield:LoadConfiguration()
