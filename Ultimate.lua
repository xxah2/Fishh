-- Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = false
local espEnabled = false
local aimPart = "Head" -- Parte a la que apunta el aimbot

-- Crear GUI menú simple para activar/desactivar
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RivalsHackMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 150, 0, 100)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = pos
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local aimbotBtn = createButton("Aimbot: OFF", UDim2.new(0, 5, 0, 5), function()
    aimbotEnabled = not aimbotEnabled
    aimbotBtn.Text = "Aimbot: "..(aimbotEnabled and "ON" or "OFF")
end)

local espBtn = createButton("ESP: OFF", UDim2.new(0, 5, 0, 40), function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: "..(espEnabled and "ON" or "OFF")
    if not espEnabled then
        -- Limpiar ESP
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local humRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if humRoot and humRoot:FindFirstChild("ESPBox") then
                    humRoot.ESPBox:Destroy()
                end
            end
        end
    end
end)

-- Función para crear y actualizar ESP boxes
local function createESP(plr)
    if not plr.Character then return end
    local humRoot = plr.Character:FindFirstChild("HumanoidRootPart")
    if not humRoot then return end

    -- Si ya tiene ESP, no crear otro
    if humRoot:FindFirstChild("ESPBox") then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = humRoot
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 5, 1)
    box.Transparency = 0.5
    box.Color3 = (plr.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
    box.Parent = humRoot
end

-- Actualizar ESP constantemente
RunService.RenderStepped:Connect(function()
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
                createESP(plr)
                -- Actualizar color dinámicamente
                local humRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                if humRoot and humRoot:FindFirstChild("ESPBox") then
                    humRoot.ESPBox.Color3 = (plr.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                end
            end
        end
    end
end)

-- Función para obtener enemigo más cercano al mouse
local function getNearestEnemy()
    local closestDist = math.huge
    local closestEnemy = nil

    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local localPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 and player.Team ~= LocalPlayer.Team then
            local enemyPart = player.Character:FindFirstChild(aimPart)
            if enemyPart then
                local screenPos, onScreen = Camera:WorldToScreenPoint(enemyPart.Position)
                if onScreen then
                    local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distToMouse < closestDist and distToMouse < 200 then -- Rango de 200 pixeles para detección
                        closestDist = distToMouse
                        closestEnemy = player
                    end
                end
            end
        end
    end

    return closestEnemy
end

-- Aimbot loop
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getNearestEnemy()
        if target and target.Character and target.Character:FindFirstChild(aimPart) then
            local targetPos = target.Character[aimPart].Position
            -- KRNL: mousemoverel para mover el mouse suavemente hacia el objetivo
            local cameraPos = Camera.CFrame.Position
            local screenPos, onScreen = Camera:WorldToScreenPoint(targetPos)
            if onScreen then
                -- Diferencia entre la posición del mouse y la posición del objetivo
                local deltaX = screenPos.X - Mouse.X
                local deltaY = screenPos.Y - Mouse.Y

                -- Mover el mouse suavemente (ajusta el divisor para velocidad)
                local smoothness = 5
                pcall(function()
                    mousemoverel(deltaX / smoothness, deltaY / smoothness)
                end)
            end
        end
    end
end)
