--// Blox Fruits Aggressive Exploit GUI v1
--// Menú interactivo que se puede abrir y cerrar

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local UIS = UserInputService

-- Variables de estado
local noclip = false
local godmode = false
local autoKill = false -- lo dejamos por si quieres usarlo pero sin matar a todos
local hitKill = false -- NUEVA opción Hit Kill
local speed = 16

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsAggressiveGui"
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 280)
MainFrame.Position = UDim2.new(0, 50, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "BloxFruits Aggressive Hack"
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

-- Función para ocultar/mostrar menú
local menuVisible = true
ToggleBtn.MouseButton1Click:Connect(function()
	menuVisible = not menuVisible
	MainFrame.Visible = menuVisible
	ToggleBtn.Text = menuVisible and "Cerrar Menú" or "Abrir Menú"
end)

-- Botones dentro del menú
local function createButton(text, posY)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Text = text
	return btn
end

local NoclipBtn = createButton("🌟 Noclip OFF", 40)
local GodmodeBtn = createButton("🛡️ Modo Dios OFF", 90)
local AutoKillBtn = createButton("⚔️ Auto Kill OFF", 140)
local HitKillBtn = createButton("💥 Hit Kill OFF", 190) -- Nuevo botón Hit Kill
local SpeedBtn = createButton("⚡ Velocidad: 16", 240)

-- Noclip
noclip = false
NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipBtn.Text = noclip and "🌟 Noclip ON" or "🌟 Noclip OFF"
end)

RunService.Stepped:Connect(function()
	if noclip and LocalPlayer.Character then
		for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Modo Dios (invencible)
GodmodeBtn.MouseButton1Click:Connect(function()
	godmode = not godmode
	GodmodeBtn.Text = godmode and "🛡️ Modo Dios ON" or "🛡️ Modo Dios OFF"
end)

RunService.Heartbeat:Connect(function()
	if godmode and LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = humanoid.MaxHealth
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		end
	end
end)

-- Auto Kill
AutoKillBtn.MouseButton1Click:Connect(function()
	autoKill = not autoKill
	AutoKillBtn.Text = autoKill and "⚔️ Auto Kill ON" or "⚔️ Auto Kill OFF"
end)

-- Hit Kill (enemigos mueren de un solo golpe)
HitKillBtn.MouseButton1Click:Connect(function()
	hitKill = not hitKill
	HitKillBtn.Text = hitKill and "💥 Hit Kill ON" or "💥 Hit Kill OFF"
end)

local function getNearestEnemy()
	local closestDist = math.huge
	local closestEnemy = nil

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = player.Character.Humanoid
			if humanoid.Health > 0 then
				local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestEnemy = player
				end
			end
		end
	end

	return closestEnemy
end

RunService.Heartbeat:Connect(function()
	if hitKill and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local enemy = getNearestEnemy()
		if enemy and enemy.Character and enemy.Character:FindFirstChild("Humanoid") and enemy.Character:FindFirstChild("HumanoidRootPart") then
			local enemyHumanoid = enemy.Character.Humanoid
			if enemyHumanoid.Health > 0 then
				-- Teletransportarse justo cerca del enemigo
				LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)

				-- Golpear enemigo una vez con la herramienta equipada
				local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					tool:Activate()
				end

				-- Bajar salud del enemigo a 0 para matarlo de un golpe
				enemyHumanoid.Health = 0
			end
		end
	end
end)

-- Velocidad
local walkSpeeds = {16, 50, 75, 100, 150, 200}
local currentSpeedIndex = 1
SpeedBtn.MouseButton1Click:Connect(function()
	currentSpeedIndex = currentSpeedIndex + 1
	if currentSpeedIndex > #walkSpeeds then currentSpeedIndex = 1 end
	speed = walkSpeeds[currentSpeedIndex]
	SpeedBtn.Text = "⚡ Velocidad: "..speed

	if LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = speed
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = speed
		end
	end
end)
