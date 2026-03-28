local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NanzzxDev VIP Hub | Nusantara Edition (FINAL V2)",
   LoadingTitle = "Loading Secure Hub...",
   LoadingSubtitle = "by Natoaji",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NanzzxConfig",
      FileName = "DeltaHub"
   }
})

Rayfield.Flags = {["NoNotifications"] = true}

-- [[ UI CHAT SPY ]]
local SpyGui = Instance.new("ScreenGui")
local SpyFrame = Instance.new("Frame")
local SpyLabel = Instance.new("TextLabel")
SpyGui.Name = "NanzzxChatSpy"; SpyGui.Parent = game.CoreGui; SpyGui.Enabled = false
SpyFrame.Name = "SpyFrame"; SpyFrame.Parent = SpyGui; SpyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0); SpyFrame.BackgroundTransparency = 0.5
SpyFrame.Position = UDim2.new(0.7, 0, 0.05, 0); SpyFrame.Size = UDim2.new(0, 280, 0, 200)
SpyLabel.Name = "SpyLabel"; SpyLabel.Parent = SpyFrame; SpyLabel.BackgroundTransparency = 1; SpyLabel.Position = UDim2.new(0, 10, 0, 10)
SpyLabel.Size = UDim2.new(1, -20, 1, -20); SpyLabel.Font = Enum.Font.SourceSansBold; SpyLabel.Text = "--- Menunggu Chat Server ---"
SpyLabel.TextColor3 = Color3.fromRGB(255, 255, 255); SpyLabel.TextSize = 14; SpyLabel.TextWrapped = true; SpyLabel.TextYAlignment = Enum.TextYAlignment.Top; SpyLabel.TextXAlignment = Enum.TextXAlignment.Left

-- [[ TABS ]]
local MainTab = Window:CreateTab("Main Features", 4483362458)
local ClientTab = Window:CreateTab("Client Features", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

-- [[ VARIABLE & LOGIKA ]]
local ChatSpyActive, chatHistory = false, {}
local savedBase, savedManual = nil, nil
local InstantProx = false
local noclip, flying, Aimlock = false, false, false

local function SafeTP(targetCFrame)
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(0,0,0)
        task.wait(0.1)
        hrp.CFrame = targetCFrame * CFrame.new(0, 3, 0)
    end
end

-- [[ MAIN TAB: FLY, NOCLIP, SPEED, AIMLOCK ]]
MainTab:CreateSlider({
   Name = "Walkspeed (Lari Laju)",
   Min = 16, Max = 300, Default = 16,
   Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end,
})

MainTab:CreateToggle({
   Name = "Fly (Terbang)",
   CurrentValue = false,
   Callback = function(v)
      flying = v
      local lp = game.Players.LocalPlayer
      if flying then
         local bg = Instance.new("BodyGyro", lp.Character.HumanoidRootPart)
         local bv = Instance.new("BodyPosition", lp.Character.HumanoidRootPart)
         bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
         task.spawn(function()
            while flying do
               lp.Character.Humanoid.PlatformStand = true
               bv.position = lp.Character.HumanoidRootPart.Position + (workspace.CurrentCamera.CFrame.LookVector * 4)
               bg.cframe = workspace.CurrentCamera.CFrame; task.wait()
            end
            lp.Character.Humanoid.PlatformStand = false; bg:Destroy(); bv:Destroy()
         end)
      end
   end,
})

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

MainTab:CreateToggle({
   Name = "Aim Lock",
   CurrentValue = false,
   Callback = function(v)
      Aimlock = v
      game:GetService("RunService").RenderStepped:Connect(function()
         local lp = game.Players.LocalPlayer
         if Aimlock and lp.Character:FindFirstChildOfClass("Tool") then
            local t, d = nil, math.huge
            for _, p in pairs(game.Players:GetPlayers()) do
               if p ~= lp and p.Character and p.Character:FindFirstChild("Head") then
                  local pos, sc = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                  if sc then
                     local m = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).magnitude
                     if m < d then t = p; d = m end
                  end
               end
            end
            if t then workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(workspace.CurrentCamera.CFrame.Position, t.Character.Head.Position), 0.2) end
         end
      end)
   end,
})

-- [[ CLIENT TAB: CHAT SPY, COLLECT, GOD MODE ]]
ClientTab:CreateToggle({
   Name = "Chat Spy",
   CurrentValue = false,
   Callback = function(v) ChatSpyActive = v; SpyGui.Enabled = v end,
})

ClientTab:CreateToggle({
   Name = "Instant Collect + 1s Auto Base",
   CurrentValue = false,
   Callback = function(Value)
      InstantProx = Value
      task.spawn(function()
         while InstantProx do
            for _, v in pairs(game:GetDescendants()) do
               if v:IsA("ProximityPrompt") then
                  v.HoldDuration = 0
                  if not v:GetAttribute("Connected") then
                      v:SetAttribute("Connected", true)
                      v.Triggered:Connect(function()
                         if InstantProx and savedBase then
                            task.wait(1) -- JEDA 1 DETIK AMAN
                            local char = game.Players.LocalPlayer.Character
                            local hasItem = false
                            for _, obj in pairs(char:GetDescendants()) do
                               if (obj:IsA("BasePart") or obj:IsA("Model")) and (string.find(string.lower(obj.Name), "fish") or string.find(string.lower(obj.Name), "ikan")) then
                                     hasItem = true; break
                               end
                            end
                            if hasItem or char:FindFirstChildOfClass("Tool") then SafeTP(savedBase) end
                         end
                      end)
                  end
               end
            end; task.wait(1)
         end
      end)
   end,
})

ClientTab:CreateToggle({
   Name = "God Mode",
   CurrentValue = false,
   Callback = function(v)
      if v then
         local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
         if hum then local n = hum:Clone(); n.Parent = game.Players.LocalPlayer.Character; hum:Destroy() end
      end
   end,
})

-- [[ VISUALS: ESP ]]
VisualTab:CreateButton({
   Name = "Aktifkan ESP Player (Anti-Error)",
   Callback = function()
      local function applyESP(player)
          if player ~= game.Players.LocalPlayer and player.Character then
              pcall(function()
                  local h = player.Character:FindFirstChild("Highlight") or Instance.new("Highlight", player.Character)
                  h.FillTransparency = 0.5; h.FillColor = Color3.fromRGB(0, 0, 255)
              end)
          end
      end
      for _, p in pairs(game.Players:GetPlayers()) do
          applyESP(p); p.CharacterAdded:Connect(function() task.wait(0.5); applyESP(p) end)
      end
      game.Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.5); applyESP(p) end) end)
   end,
})

-- [[ TELEPORT: BASE & MANUAL & PLAYER ]]
TeleportTab:CreateSection("1. Base Position (Auto Collect Target)")
TeleportTab:CreateButton({
   Name = "Save Base Position",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then savedBase = hrp.CFrame; Rayfield:Notify({Title = "Base", Content = "Base Saved!", Duration = 2}) end
   end,
})

TeleportTab:CreateSection("2. Manual Checkpoint")
TeleportTab:CreateButton({
   Name = "Save Current Position",
   Callback = function()
      local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
      if hrp then savedManual = hrp.CFrame; Rayfield:Notify({Title = "Saved", Content = "Posisi Disimpan!", Duration = 2}) end
   end,
})
TeleportTab:CreateButton({
   Name = "Teleport Ke Lokasi Save",
   Callback = function() if savedManual then SafeTP(savedManual) end end,
})

TeleportTab:CreateSection("3. Player Teleport")
local pList = {}
for _, v in pairs(game.Players:GetPlayers()) do if v ~= game.Players.LocalPlayer then table.insert(pList, v.Name) end end
TeleportTab:CreateDropdown({
   Name = "Pilih Player",
   Options = pList,
   CurrentOption = "",
   Callback = function(opt)
      local t = game.Players:FindFirstChild(opt[1])
      if t and t.Character then SafeTP(t.Character.HumanoidRootPart.CFrame) end
   end,
})

-- Logic Chat Spy Connection
local function HandlePlayer(player) player.Chatted:Connect(function(msg) AddToSpy(player.Name, msg) end) end
for _, p in pairs(game.Players:GetPlayers()) do HandlePlayer(p) end
game.Players.PlayerAdded:Connect(HandlePlayer)

Rayfield:LoadConfiguration()
