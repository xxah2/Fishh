-- ... (todo igual hasta la función getNearestEnemy)

local function getNearestEnemy()
	local closestDist = math.huge
	local closestEnemy = nil

	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		return nil
	end

	local localPos = LocalPlayer.Character.HumanoidRootPart.Position
	local localTeam = LocalPlayer.Team -- Obtenemos el equipo del local player

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer 
		   and player.Character 
		   and player.Character:FindFirstChild("Humanoid") 
		   and player.Character.Humanoid.Health > 0 then

			-- Ignorar aliados (mismo equipo)
			if player.Team ~= localTeam then
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
	end

	return closestEnemy
end

-- Modificar función createESP para colorear según equipo y sólo mostrar enemigos

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

		-- Color rojo para enemigos, verde para aliados (si quieres)
		if player.Team == LocalPlayer.Team then
			box.Color3 = Color3.new(0, 1, 0) -- Verde aliados (opcional: también puedes no mostrar)
			-- Si no quieres que aliados tengan ESP, simplemente no crear ESP para ellos:
			-- box:Destroy()
			-- return
		else
			box.Color3 = Color3.new(1, 0, 0) -- Rojo enemigos
		end

		box.Parent = hrp
	end
end

-- Actualizar ESP para ignorar aliados (si quieres ignorarlos completamente, cambia esta función)

local function updateESP()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
				-- Sólo crear ESP para enemigos
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
end

-- El resto del script queda igual
