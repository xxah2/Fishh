--// Blox Fruits Aggressive Exploit GUI v1
--// Menú interactivo que se puede abrir y cerrar

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local UIS = UserInputService

-- Variables de estado
local isFlying = false
local flySpeed = 50
local noclip = false
local godmode = false
local autoKill = false
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

local FlyBtn = createButton("🕊️ Vuelo OFF", 40)
local NoclipBtn = createButton("🌟 Noclip OFF", 90)
local GodmodeBtn = createButton("🛡️ Modo Dios OFF", 140)
local AutoKillBtn = createButton("⚔️ Auto Kill OFF", 190)
local SpeedBtn = createButton("⚡ Velocidad: 16", 240)

-- Funciones para los hacks

-- Vuelo
local bodyVelocity
FlyBtn.MouseButton1Click:Connect(function()
	isFlying = not isFlying
	FlyBtn.Text = isFlying and "🕊️ Vuelo ON" or "🕊️ Vuelo OFF"

	if isFlying then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			bodyVelocity = Instance.new("BodyVelocity", hrp)
			bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			bodyVelocity.Velocity = Vector3.new(0,0,0)
		end
	else
		if bodyVelocity then
			bodyVelocity:Destroy()
			bodyVelocity = nil
		end
	end
end)

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

local function getNearestEnemy()
	local closestDist = math.huge
	local closestEnemy = nil

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
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
	if autoKill and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local enemy = getNearestEnemy()
		if enemy and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
			local enemyHumanoid = enemy.Character:FindFirstChildOfClass("Humanoid")
			if enemyHumanoid and enemyHumanoid.Health > 0 then
				-- Teleportarse al enemigo para atacar rápido
				LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)

				-- Golpear (usar espada si la tenés)
				local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool and tool:FindFirstChild("Handle") then
					tool:Activate()
				end
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

-- Vuelo con WASD y espacio para subir
UIS.InputBegan:Connect(function(input)
	if isFlying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		if bodyVelocity then
			local cam = workspace.CurrentCamera
			local direction = Vector3.new(0,0,0)
			if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0,1,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then direction = direction - Vector3.new(0,1,0) end

			bodyVelocity.Velocity = direction.Unit * flySpeed
		end
	end
end)
