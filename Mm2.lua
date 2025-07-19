--// GUI con botones: Noclip, ESP, Vuelo y Velocidad para Murder Mystery 2
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local NoclipBtn = Instance.new("TextButton", Frame)
local ESPBtn = Instance.new("TextButton", Frame)
local FlyBtn = Instance.new("TextButton", Frame)
local SpeedSlider = Instance.new("TextButton", Frame)

-- GUI Config
ScreenGui.Name = "MM2HackGui"
Frame.Size = UDim2.new(0, 150, 0, 210)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundTransparency = 0.3
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.Active = true
Frame.Draggable = true

local function styleButton(btn, text, y)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
end

styleButton(NoclipBtn, "🌟 Noclip ON/OFF", 0)
styleButton(ESPBtn, "👁 ESP ON/OFF", 40)
styleButton(FlyBtn, "🕊️ Vuelo ON/OFF", 80)

SpeedSlider.Size = UDim2.new(1, 0, 0, 30)
SpeedSlider.Position = UDim2.new(0, 0, 0, 130)
SpeedSlider.Text = "Velocidad: 16"
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 0)

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local noclip = false
local espEnabled = false
local flying = false
local flySpeed = 50
local drawings = {}
local walkSpeeds = {16, 50, 75, 100, 150, 200}
local currentSpeedIndex = 1

-- Noclip
NoclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	NoclipBtn.Text = noclip and "✅ Noclip: ON" or "🌟 Noclip: OFF"
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

-- ESP
local function getRoleColor(player)
	local character = player.Character
	if not character then return Color3.fromRGB(255, 255, 255) end

	local knife = character:FindFirstChild("Knife") or character:FindFirstChildOfClass("Tool")
	local gun = character:FindFirstChild("Gun") or character:FindFirstChild("Revolver")

	if knife then
		return Color3.fromRGB(255, 0, 0) -- rojo (asesino)
	elseif gun then
		return Color3.fromRGB(0, 0, 255) -- azul (sheriff)
	else
		return Color3.fromRGB(0, 255, 0) -- verde (inocente)
	end
end

local function createESP(player)
	local box = Drawing.new("Text")
	box.Size = 13
	box.Center = true
	box.Outline = true
	box.Transparency = 1
	box.Visible = true
	box.Color = getRoleColor(player)
	box.Text = player.Name
	drawings[player] = box
end

local function removeESP(player)
	if drawings[player] then
		drawings[player]:Remove()
		drawings[player] = nil
	end
end

ESPBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	ESPBtn.Text = espEnabled and "✅ ESP: ON" or "👁 ESP: OFF"

	if not espEnabled then
		for _, d in pairs(drawings) do d:Remove() end
		drawings = {}
	else
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then createESP(p) end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if espEnabled then
		for player, drawing in pairs(drawings) do
			local char = player.Character
			if char and char:FindFirstChild("HumanoidRootPart") then
				local pos, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(char.HumanoidRootPart.Position)
				drawing.Position = Vector2.new(pos.X, pos.Y)
				drawing.Visible = onScreen
				drawing.Color = getRoleColor(player)
			else
				drawing.Visible = false
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	if espEnabled and p ~= LocalPlayer then createESP(p) end
end)

Players.PlayerRemoving:Connect(function(p)
	removeESP(p)
end)

-- Vuelo
FlyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	FlyBtn.Text = flying and "✅ Vuelo: ON" or "🕊️ Vuelo OFF"
end)

RunService.RenderStepped:Connect(function()
	if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = LocalPlayer.Character.HumanoidRootPart
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if (humanoid and humanoid.Jump) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			hrp.Velocity = Vector3.new(hrp.Velocity.X, flySpeed, hrp.Velocity.Z)
		end
	end
end)

-- Velocidad
SpeedSlider.MouseButton1Click:Connect(function()
	currentSpeedIndex = currentSpeedIndex + 1
	if currentSpeedIndex > #walkSpeeds then
		currentSpeedIndex = 1
	end
	local newSpeed = walkSpeeds[currentSpeedIndex]
	SpeedSlider.Text = "Velocidad: " .. tostring(newSpeed)

	if LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = newSpeed
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = walkSpeeds[currentSpeedIndex]
		end
	end
end)
