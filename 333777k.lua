-- MOD MENU: Reborn as Swordsman (Android Friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Estados
local godMode = false
local oneHitKill = false

-- GUI flotante
local gui = Instance.new("ScreenGui")
gui.Name = "SwordmanModMenu"
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Parent = frame

local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 20
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.Parent = frame
	btn.AutoButtonColor = true
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- BOTÓN MODO DIOS
local godBtn = createButton("Modo Dios: OFF", function()
	godMode = not godMode
	godBtn.Text = "Modo Dios: " .. (godMode and "ON" or "OFF")
end)

-- BOTÓN 1 HIT KILL (toggleable)
local oneHitBtn = createButton("1 Hit Kill: OFF", function()
	oneHitKill = not oneHitKill
	oneHitBtn.Text = "1 Hit Kill: " .. (oneHitKill and "ON" or "OFF")
end)

-- Función para aplicar 1 Hit Kill a enemigos cercanos
local function applyOneHitKill()
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
	local myPos = LocalPlayer.Character.HumanoidRootPart.Position

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
			local targetHum = player.Character.Humanoid
			local targetHRP = player.Character.HumanoidRootPart
			local dist = (targetHRP.Position - myPos).Magnitude
			if dist <= 25 and targetHum.Health > 0 then
				-- Daño instantáneo
				targetHum.Health = 0
			end
		end
	end
end

-- Loop para Modo Dios y 1 Hit Kill
RunService.RenderStepped:Connect(function()
	-- Modo Dios: Regenerar salud constantemente
	if godMode and LocalPlayer.Character then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end

	-- Aplicar 1 Hit Kill si está activo
	if oneHitKill then
		applyOneHitKill()
	end
end)

-- Reaplicar modo dios después de respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	local hum = nil
	repeat
		hum = char:FindFirstChildOfClass("Humanoid")
		wait(0.1)
	until hum ~= nil
	-- Si modo dios estaba activado, restaurar salud al máximo y mantenerlo regenerando
	if godMode then
		hum.Health = hum.MaxHealth
	end
end)
