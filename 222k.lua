-- MOD MENU: Reborn as Swordsman (Android Friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Estados
local godMode = false
local oneHitKill = false

-- GUI flotante
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SwordmanModMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local function createButton(text, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Botón: Modo Dios
local godBtn = createButton("Modo Dios: OFF", function()
	godMode = not godMode
	godBtn.Text = "Modo Dios: " .. (godMode and "ON" or "OFF")
end)

-- Botón: 1 Hit Kill
local oneHitBtn = createButton("1 Hit Kill: Ejecutar", function()
	local myChar = LocalPlayer.Character
	if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
	local myPos = myChar.HumanoidRootPart.Position

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
			if dist <= 25 then
				player.Character.Humanoid.Health = 0
			end
		end
	end
end)

-- Loop: Modo Dios
RunService.RenderStepped:Connect(function()
	if godMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
		local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health < hum.MaxHealth then
			hum.Health = hum.MaxHealth
		end
	end
end)

-- Autoaplicar modo dios en respawn
LocalPlayer.CharacterAdded:Connect(function()
	repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end)
