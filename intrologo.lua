local TweenService = game:GetService("TweenService")
local Intro = {}

function Intro.Run(ScreenGui, fileName)
    -- Create Black Frame
    local IntroFrame = Instance.new("Frame")
    IntroFrame.Name = "IntroFrame"
    IntroFrame.Size = UDim2.new(1, 0, 1, 0)
    IntroFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    IntroFrame.BorderSizePixel = 0
    IntroFrame.ZIndex = 100
    IntroFrame.Parent = ScreenGui

    local IntroLogo = Instance.new("ImageLabel")
    IntroLogo.Name = "IntroLogo"
    IntroLogo.Size = UDim2.new(0.8, 0, 0.8, 0)
    IntroLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    IntroLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
    IntroLogo.BackgroundTransparency = 1
    IntroLogo.Image = getcustomasset(fileName)
    IntroLogo.ScaleType = Enum.ScaleType.Fit
    IntroLogo.ImageTransparency = 1
    IntroLogo.Parent = IntroFrame

    -- Fade In
    TweenService:Create(IntroLogo, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    
    task.wait(10) -- Diam 10 Detik
    
    -- Slide Down
    local tweenOut = TweenService:Create(IntroFrame, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 0, 1, 0)})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    
    IntroFrame:Destroy()
end

return Intro
