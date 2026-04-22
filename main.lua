-- Modernes Fly & Noclip Script für Roblox
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- Flugvariablen
local flying = false
local flySpeed = 50
local noclip = false
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil

-- Flugsteuerung
local flyControls = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

-- GUI Erstellung
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "FlyNoclipGUI"

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BackgroundTransparency = 0.1
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
TitleBar.BorderSizePixel = 0
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 15)
titleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(1, -45, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "✈️ Fly & Noclip Control"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseButton

local FlyButton = Instance.new("TextButton")
FlyButton.Parent = MainFrame
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
FlyButton.BorderSizePixel = 0
FlyButton.Position = UDim2.new(0, 20, 0, 60)
FlyButton.Size = UDim2.new(0, 170, 0, 50)
FlyButton.Font = Enum.Font.Gotham
FlyButton.Text = "Fliegen: AUS"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 16
local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 10)
flyCorner.Parent = FlyButton

local NoclipButton = Instance.new("TextButton")
NoclipButton.Parent = MainFrame
NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
NoclipButton.BorderSizePixel = 0
NoclipButton.Position = UDim2.new(0, 210, 0, 60)
NoclipButton.Size = UDim2.new(0, 170, 0, 50)
NoclipButton.Font = Enum.Font.Gotham
NoclipButton.Text = "Noclip: AUS"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.TextSize = 16
local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 10)
noclipCorner.Parent = NoclipButton

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
SpeedLabel.BorderSizePixel = 0
SpeedLabel.Position = UDim2.new(0, 20, 0, 130)
SpeedLabel.Size = UDim2.new(0, 170, 0, 40)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Geschwindigkeit: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 14
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 10)
speedCorner.Parent = SpeedLabel

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Parent = MainFrame
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Position = UDim2.new(0, 210, 0, 130)
SpeedSlider.Size = UDim2.new(0, 170, 0, 40)
local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = SpeedSlider

local SliderFill = Instance.new("Frame")
SliderFill.Parent = SpeedSlider
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.Size = UDim2.new(0.3, 0, 1, 0)
local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Parent = SpeedSlider
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderSizePixel = 0
SliderButton.Position = UDim2.new(0.3, -10, 0.5, -10)
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Text = ""
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 10)
buttonCorner.Parent = SliderButton

local Instructions = Instance.new("TextLabel")
Instructions.Parent = MainFrame
Instructions.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Instructions.BorderSizePixel = 0
Instructions.Position = UDim2.new(0, 20, 0, 190)
Instructions.Size = UDim2.new(1, -40, 0, 90)
Instructions.Font = Enum.Font.Gotham
Instructions.Text = "Steuerung:\nWASD - Bewegen\nLeertaste - Hoch\nShift - Runter\nF - Fliegen umschalten\nN - Noclip umschalten"
Instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
Instructions.TextSize = 14
Instructions.TextXAlignment = Enum.TextXAlignment.Left
Instructions.TextYAlignment = Enum.TextYAlignment.Top
local instCorner = Instance.new("UICorner")
instCorner.CornerRadius = UDim.new(0, 10)
instCorner.Parent = Instructions

-- GUI Animation und Schließen
local open = true
CloseButton.MouseButton1Click:Connect(function()
    open = not open
    if open then
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 300), "Out", "Quad", 0.3, true)
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 40), "Out", "Quad", 0.3, true)
    end
end)

-- Geschwindigkeitsregler
local dragging = false
SpeedSlider.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp((input.Position.X - SpeedSlider.AbsolutePosition.X) / SpeedSlider.AbsoluteSize.X, 0, 1)
        SliderButton.Position = UDim2.new(pos, -10, 0.5, -10)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        flySpeed = math.floor(pos * 150 + 10)
        SpeedLabel.Text = "Geschwindigkeit: " .. flySpeed
        
        -- Geschwindigkeit während des Fluges aktualisieren
        if flying and bodyVelocity then
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Funktion zum Aktivieren/Deaktivieren von Noclip
local function toggleNoclip()
    noclip = not noclip
    
    if noclip then
        NoclipButton.Text = "Noclip: AN"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        -- Noclip-Verbindung erstellen, um Kollisionen kontinuierlich zu deaktivieren
        local noclipConnection
        noclipConnection = RunService.Stepped:Connect(function()
            if noclip then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            else
                noclipConnection:Disconnect()
            end
        end)
    else
        NoclipButton.Text = "Noclip: AUS"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        
        -- Kollisionen wiederherstellen
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function updateFlyControls(input, gameProcessed)
    if gameProcessed or not flying then return end

    if input.KeyCode == Enum.KeyCode.W then
        flyControls.Forward = input.UserInputState == Enum.UserInputState.Begin
    elseif input.KeyCode == Enum.KeyCode.S then
        flyControls.Backward = input.UserInputState == Enum.UserInputState.Begin
    elseif input.KeyCode == Enum.KeyCode.A then
        flyControls.Left = input.UserInputState == Enum.UserInputState.Begin
    elseif input.KeyCode == Enum.KeyCode.D then
        flyControls.Right = input.UserInputState == Enum.UserInputState.Begin
    elseif input.KeyCode == Enum.KeyCode.Space then
        flyControls.Up = input.UserInputState == Enum.UserInputState.Begin
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        flyControls.Down = input.UserInputState == Enum.UserInputState.Begin
    end
end

local function fly()
    if not flying or not bodyVelocity then return end
    
    local direction = Vector3.new()
    
    if flyControls.Forward then
        direction = direction + camera.CFrame.LookVector
    end
    if flyControls.Backward then
        direction = direction - camera.CFrame.LookVector
    end
    if flyControls.Left then
        direction = direction - camera.CFrame.RightVector
    end
    if flyControls.Right then
        direction = direction + camera.CFrame.RightVector
    end
    if flyControls.Up then
        direction = direction + Vector3.new(0, 1, 0)
    end
    if flyControls.Down then
        direction = direction - Vector3.new(0, 1, 0)
    end
    
    if direction.Magnitude > 0 then
        direction = direction.Unit
    end
    
    -- BodyVelocity verwenden für bessere Kontrolle
    bodyVelocity.Velocity = direction * flySpeed
    bodyGyro.CFrame = camera.CFrame
end

-- Toggle-Funktionen
local function toggleFly()
    flying = not flying
    
    if flying then
        -- BodyVelocity und BodyGyro erstellen
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.P = 5000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 5000
        bodyGyro.CFrame = camera.CFrame
        bodyGyro.Parent = character:WaitForChild("HumanoidRootPart")
        
        -- Schwerkraft deaktivieren
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        FlyButton.Text = "Fliegen: AN"
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        -- Flugverbindung herstellen
        flyConnection = RunService.Heartbeat:Connect(fly)
    else
        -- Flugverbindung trennen
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        -- BodyVelocity und BodyGyro entfernen
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        
        -- Normalen Zustand wiederherstellen
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
        
        FlyButton.Text = "Fliegen: AUS"
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    end
end

-- Button-Funktionen
FlyButton.MouseButton1Click:Connect(toggleFly)
NoclipButton.MouseButton1Click:Connect(toggleNoclip)

-- Tastenbelegung
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    elseif input.KeyCode == Enum.KeyCode.N then
        toggleNoclip()
    end
end)

UserInputService.InputChanged:Connect(updateFlyControls)
UserInputService.InputEnded:Connect(updateFlyControls)

-- Benachrichtigung
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("ChatMakeSystemMessage", {
    Text = "[FLY & NOCLIP] Modernes Script geladen! Verwende die Schaltflächen oder Tasten F/N";
    Color = Color3.new(0, 1, 0);
    Font = Enum.Font.GothamBold;
    Size = 18;
})

-- Automatisches Schließen bei Disconnect
player.Changed:Connect(function(property)
    if property == "Parent" and not player.Parent then
        if ScreenGui then
            ScreenGui:Destroy()
        end
    end
end)
