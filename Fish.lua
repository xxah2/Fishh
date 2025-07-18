--// GUI con botones: Noclip, ESP y Forzar robo en Steal a Fish
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local NoclipBtn = Instance.new("TextButton", Frame)
local ESPBtn = Instance.new("TextButton", Frame)
local StealBtn = Instance.new("TextButton", Frame)

-- GUI Config
ScreenGui.Name = "StealAFishHackGui"
Frame.Size = UDim2.new(0, 150, 0, 180)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Active = true
Frame.Draggable = true

-- Botones
NoclipBtn.Size = UDim2.new(1, 0, 0, 50)
NoclipBtn.Position = UDim2.new(0, 0, 0, 0)
NoclipBtn.Text = "🌟 Noclip ON/OFF"
NoclipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

ESPBtn.Size = UDim2.new(1, 0, 0, 50)
ESPBtn.Position = UDim2.new(0, 0, 0, 60)
ESPBtn.Text = "👁 ESP ON/OFF"
ESPBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ESPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

StealBtn.Size = UDim2.new(1, 0, 0, 50)
StealBtn.Position = UDim2.new(0, 0, 0, 120)
StealBtn.Text = "🔓 Forzar Robo ON/OFF"
StealBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
StealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Variables
local noclip = false
local espEnabled = false
local stealEnabled = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local drawings = {}

-- Noclip toggle
local function toggleNoclip()
    noclip = not noclip
    NoclipBtn.Text = noclip and "✅ Noclip: ON" or "🌟 Noclip: OFF"
end
NoclipBtn.MouseButton1Click:Connect(toggleNoclip)

RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ESP toggle
local function createESP(player)
    local box = Drawing.new("Text")
    box.Text = player.Name
    box.Size = 13
    box.Center = true
    box.Outline = true
    box.Color = Color3.fromRGB(0, 255, 0)
    box.Visible = true
    box.Transparency = 1
    drawings[player] = box
end

local function removeESP(player)
    if drawings[player] then
        drawings[player]:Remove()
        drawings[player] = nil
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    ESPBtn.Text = espEnabled and "✅ ESP: ON" or "👁 ESP: OFF"

    if not espEnabled then
        for _, d in pairs(drawings) do
            d:Remove()
        end
        drawings = {}
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
    end
end
ESPBtn.MouseButton1Click:Connect(toggleESP)

RunService.RenderStepped:Connect(function()
    if espEnabled then
        for player, drawing in pairs(drawings) do
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local pos, onscreen = workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
                drawing.Position = Vector2.new(pos.X, pos.Y)
                drawing.Visible = onscreen
            else
                drawing.Visible = false
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Forzar robo toggle
StealBtn.MouseButton1Click:Connect(function()
    stealEnabled = not stealEnabled
    StealBtn.Text = stealEnabled and "✅ Robo Forzado: ON" or "🔓 Forzar Robo OFF"

    if stealEnabled then
        -- Aquí hay que poner el path y variable real del juego Steal a Fish que bloquea el robo
        -- Ejemplo genérico:
        local base = workspace:FindFirstChild("Base") or workspace:FindFirstChild("SafeZone") or workspace:FindFirstChild("Container")
        if base then
            local locked = base:FindFirstChild("IsLocked") or base:FindFirstChild("Closed") or base:FindFirstChild("Locked")
            if locked and (locked:IsA("BoolValue") or locked:IsA("IntValue")) then
                locked.Value = false
                locked.Changed:Connect(function()
                    if stealEnabled then
                        locked.Value = false
                    end
                end)
            end
        end
    end
end)
