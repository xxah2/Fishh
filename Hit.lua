hit kill

--// MOD MENU REBORN AS SWORDMAN - KRNL ANDROID
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local godMode = false
local oneHit = false

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SwordsmanModMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 180, 0, 120)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uilist = Instance.new("UIListLayout", frame)
uilist.Padding = UDim.new(0, 5)
uilist.FillDirection = Enum.FillDirection.Vertical
uilist.HorizontalAlignment = Enum.HorizontalAlignment.Center
uilist.VerticalAlignment = Enum.VerticalAlignment.Top

local function createButton(name, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Modo Dios
local godBtn = createButton("Modo Dios: OFF", function()
    godMode = not godMode
    godBtn.Text = "Modo Dios: " .. (godMode and "ON" or "OFF")
end)

-- One Hit Kill
local hitBtn = createButton("1 Hit Kill", function()
    local nearest = nil
    local shortest = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < 25 and dist < shortest then
                    nearest = plr
                    shortest = dist
                end
            end
        end
    end

    if nearest and nearest.Character and nearest.Character:FindFirstChild("Humanoid") then
        pcall(function()
            nearest.Character.Humanoid.Health = 0
        end)
    end
end)

-- Aplicar Modo Dios si está activado
local function applyGodLoop()
    RunService.RenderStepped:Connect(function()
        if godMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end
    end)
end

-- Auto aplicar al reaparecer
LocalPlayer.CharacterAdded:Connect(function()
    repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end)

-- Ejecutar modo dios en loop
applyGodLoop()
