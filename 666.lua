local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local aimbotEnabled = false
local espEnabled = false
local menuOpen = true

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimESPGui"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 220, 0, 160)
Frame.Position = UDim2.new(0, 10, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
ToggleBtn.Position = UDim2.new(1, -55, 0, 5)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Text = "-"
ToggleBtn.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 25)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1,1,1)
Title.Text = "Aimbot + ESP"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Frame

local AimbotBtn = Instance.new("TextButton")
AimbotBtn.Size = UDim2.new(1, -10, 0, 40)
AimbotBtn.Position = UDim2.new(0, 5, 0, 40)
AimbotBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
AimbotBtn.TextColor3 = Color3.new(1,1,1)
AimbotBtn.Text = "Aimbot: OFF"
AimbotBtn.Parent = Frame

local ESPBtn = Instance.new("TextButton")
ESPBtn.Size = UDim2.new(1, -10, 0, 40)
ESPBtn.Position = UDim2.new(0, 5, 0, 90)
ESPBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
ESPBtn.TextColor3 = Color3.new(1,1,1)
ESPBtn.Text = "ESP: OFF"
ESPBtn.Parent = Frame

ToggleBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	if menuOpen then
		Frame.Size = UDim2.new(0, 220, 0, 160)
		ToggleBtn.Text = "-"
	else
		Frame.Size = UDim2.new(0, 50, 0, 25)
		ToggleBtn.Text = "+"
	end
end)

AimbotBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	AimbotBtn.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
end)

ESPBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	ESPBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
	if espEnabled then
		updateESP()
	else
		clearAllESP()
	end
end)

-- Función para obtener el enemigo más cercano enemigo vivo y fuera del equipo
local function getNearestEnemy()
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return nil
	end
	local localPos = LocalPlayer.Character.HumanoidRootPart.Position
	local localTeam = LocalPlayer.Team

	local closestDist = math.huge
	local closestEnemy = nil

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer 
		   and player.Team ~= localTeam
		   and player.Character 
		   and player.Character:FindFirstChild("Humanoid") 
		   and player.Character.Humanoid.Health > 0
		   and player.Character:FindFirstChild("Head") then

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

-- Función para disparar duro a la cabeza (simulamos el disparo con raycast ignorando paredes)
local function shootAtHead(targetPos)
	local origin = workspace.CurrentCamera.CFrame.Position
	local direction = (targetPos - origin).Unit * 500 -- distancia del disparo

	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.IgnoreWater = true

	local rayResult = workspace:Raycast(origin, direction, rayParams)
	if rayResult and rayResult.Instance then
		-- Aquí se debería aplicar el daño, pero depende del juego
		-- Para Rivals es suficiente con apuntar bien, el juego maneja el disparo
		-- Si quieres, puedes poner un print para debug
		-- print("Disparo en: "..rayResult.Instance.Name)
	end
end

-- Aimbot: apunta y dispara automáticamente a la cabeza enemiga más cercana
RunService.RenderStepped:Connect(function()
	if aimbotEnabled then
		local target = getNearestEnemy()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			local camera = workspace.CurrentCamera
			local headPos = target.Character.Head.Position
			-- Apuntar cámara a la cabeza enemiga
			camera.CFrame = CFrame.new(camera.CFrame.Position, headPos)
			-- Disparar a la cabeza (simulado)
			shootAtHead(headPos)
		end
	end
end)

-- ESP
local espBoxes = {}

local function createESP(player)
	if player == LocalPlayer then return end
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart

		if hrp:FindFirstChild("ESPBox") then return end

		local box = Instance.new("BoxHandleAdornment")
		box.Name = "ESPBox"
		box.Adornee = hrp
		box.AlwaysOnTop = true
		box.ZIndex = 10
		box.Transparency = 0.5
		box.Size = Vector3.new(4, 6, 1)

		if player.Team == LocalPlayer.Team then
			-- No mostrar ESP a aliados
			return
		else
			box.Color3 = Color3.new(1, 0, 0) -- Rojo para enemigos
		end

		box.Parent = hrp
		espBoxes[player] = box
	end
end

local function removeESP(player)
	if espBoxes[player] then
		espBoxes[player]:Destroy()
		espBoxes[player] = nil
	end
end

function updateESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
			if player.Team ~= LocalPlayer.Team then
				createESP(player)
			else
				removeESP(player)
			end
		else
			removeESP(player)
		end
	end
end

function clearAllESP()
	for player, box in pairs(espBoxes) do
		if box and box.Parent then
			box:Destroy()
		end
	end
	espBoxes = {}
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		if espEnabled then
			updateESP()
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

-- Actualizar ESP cada 1 segundo para performance
while true do
	wait(1)
	if espEnabled then
		updateESP()
	else
		clearAllESP()
	end
end
