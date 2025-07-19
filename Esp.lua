-- Blox Fruits Aggressive Exploit GUI v1 (Modificado)
-- Solo menú minimizable con ESP y Aimbot para Rivals

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsAggressiveGui"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 120)
MainFrame.Position = UDim2.new(0, 50, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "BloxFruits ESP + Aimbot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Botón para minimizar y mostrar menú
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 120, 0, 30)
ToggleBtn.Position = UDim2.new(0, 50, 0, 100)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Text = "Abrir Menú"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 16

local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	MainFrame.Visible = menuVisible
	ToggleBtn.Text = menuVisible and "Cerrar Menú" or "Abrir Menú"
end)

-- ESP funcional
local function createESP(player)
	if player == LocalPlayer then return end
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart

		-- Evitar crear múltiples ESP para el mismo jugador
		if hrp:FindFirstChild("ESPBox") then return end

		local box = Instance.new("BoxHandleAdornment")
		box.Name = "ESPBox"
		box.Adornee = hrp
		box.AlwaysOnTop = true
		box.ZIndex = 10
		box.Transparency = 0.5
		box.Size = Vector3.new(4, 6, 1)
		box.Color3 = Color3.new(1, 0, 0) -- Rojo para enemigos
		box.Parent = hrp
	end
end

local function removeESP(player)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		local esp = hrp:FindFirstChild("ESPBox")
		if esp then
			esp:Destroy()
		end
	end
end

local function updateESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
				createESP(player)
			else
				removeESP(player)
			end
		end
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		updateESP()
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

-- Aimbot "duro" para Rivals
local aiming = false

local function getNearestEnemy()
	local closestDist = math.huge
	local closestEnemy = nil

	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return nil
	end

	local localPos = LocalPlayer.Character.HumanoidRootPart.Position

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				local dist = (hrp.Position - localPos).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestEnemy = player
				end
			end
		end
	end

	return closestEnemy
end

-- Botón para activar/desactivar aimbot
local AimBotBtn = Instance.new("TextButton", MainFrame)
AimBotBtn.Size = UDim2.new(1, -20, 0, 40)
AimBotBtn.Position = UDim2.new(0, 10, 0, 50)
AimBotBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AimBotBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AimBotBtn.Font = Enum.Font.GothamBold
AimBotBtn.TextSize = 16
AimBotBtn.Text = "🎯 Aimbot OFF"

local aimbotEnabled = false
AimBotBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	AimBotBtn.Text = aimbotEnabled and "🎯 Aimbot ON" or "🎯 Aimbot OFF"
end)

-- Aimbot loop: Apunta la cámara hacia la cabeza del enemigo más cercano
RunService.RenderStepped:Connect(function()
	if aimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local enemy = getNearestEnemy()
		if enemy and enemy.Character and enemy.Character:FindFirstChild("Head") then
			local headPos = enemy.Character.Head.Position
			local camera = workspace.CurrentCamera
			camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
		end
	end
end)

-- Actualizar ESP continuamente
RunService.Heartbeat:Connect(updateESP)
