-- mobyhub by alumark
-- 6 June 2020

repeat wait() until game:IsLoaded()

local player = game.Players.LocalPlayer

print("mobyhub by alumark")

local VirtualUser = game:GetService("VirtualUser")

local Command = {}
Command.__index = Command

local FRAME_SIZE = 200

function fastSpawn(func, ...)

	assert(type(func) == "function")

	local args = {...}
	local bindable = Instance.new("BindableEvent")
	bindable.Event:Connect(function()
		func(unpack(args))
	end)

	bindable:Fire()
	bindable:Destroy()

end

function Command.new(frame, name, settings, func, layoutOrder)
    local self = {}

    self.frame = Instance.new("TextButton")
    self.frame.Size = UDim2.new(UDim.new(1, 0), UDim.new(0, 16))
    self.frame.LayoutOrder = layoutOrder
	self.frame.BackgroundTransparency = 0
	
	self.frame.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	self.frame.ZIndex = 2
	self.frame.Text = ""
    self.frame.Parent = frame

    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingBottom = UDim.new(0, 2)
    uiPadding.PaddingTop = UDim.new(0, 2)
    uiPadding.PaddingLeft = UDim.new(0, 2)
    uiPadding.PaddingRight = UDim.new(0.15, 0)
    uiPadding.Parent = self.frame

    self.event = Instance.new("BindableEvent")
    self.func = func

    local uiText = Instance.new("TextLabel")
    uiText.Text = name
    uiText.Size = UDim2.fromScale(1, 1)
	uiText.BackgroundTransparency = 1
	uiText.TextColor3 = Color3.new(1, 1, 1)
	uiText.Font = Enum.Font.GothamBold
	uiText.TextStrokeTransparency = 0.8
	uiText.TextScaled = true
	uiText.ZIndex = 3
    uiText.Parent = self.frame

    if settings.Type == "Toggle" then
        self.value = false

		self.inputLabel = Instance.new("Frame")
		self.inputLabel.AnchorPoint = Vector2.new(1, 0.5)
		self.inputLabel.Position = UDim2.fromScale(1.15, 0.5)
		self.inputLabel.Size = UDim2.fromOffset(12, 12)
		self.inputLabel.BackgroundColor3 = Color3.new(0.8, 0.2, 0)
		self.inputLabel.BorderSizePixel = 0
		self.inputLabel.ZIndex = 4
		self.inputLabel.Parent = self.frame

        self.event.Event:Connect(function(value)
            fastSpawn(self.func, self)

			if value then
				self.inputLabel.BackgroundColor3 = Color3.new(0.2, 0.8, 0)
			else
				self.inputLabel.BackgroundColor3 = Color3.new(0.8, 0.2, 0)
			end
        end)

		self.frame.Activated:Connect(function(input, gameProcessed)
			self.value = not self.value
			self.event:Fire(self.value)
		end)
    end

	if settings.Type == "Number" then
		
	end

    return setmetatable(self, Command)
end

function Command:__newindex(index, value)
	if index == "value" then
		rawset(self, index, value)
		self.event:Fire(self.value)
	end
end

local Game = {}
Game.__index = Game

local DEFAULT_VALUE = 10
local INCREMENT = FRAME_SIZE + DEFAULT_VALUE

function Game.new(placeId, gui)
    local self = {}

    self.commands = {}
    self.length = 0

	self.placeId = placeId

    self.screenGui = gui

    self.frame = Instance.new("Frame")
    self.frame.Size = UDim2.fromOffset(FRAME_SIZE, 0)
    self.frame.BackgroundTransparency = 1
    self.frame.Visible = false
    self.frame.Parent = self.screenGui

    local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Padding = UDim.new(0, 1)
    uiListLayout.Parent = self.frame

    function self:AddCommand(commandName, settings, func)
        self.length = self.length + 1
        self.frame.Size = UDim2.fromOffset(FRAME_SIZE, self.length * 20)
        self.commands[commandName] = Command.new(self.frame, commandName, settings, func, self.length)
    end
	

    function self:Open(position)
        self.frame.Position = UDim2.fromOffset(position, DEFAULT_VALUE)
		self.frame.Visible = true
    end

    return setmetatable(self, Game)
end

local Hub = {}
Hub.__index = Hub

function Hub.new(parent)
    local self = {}

    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.ResetOnSpawn = false
	self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    self.screenGui.Parent = parent

    self.games = {}

    -- universal
    self.games.Universal = Game.new(0, self.screenGui)

    function self:AddGame(name, placeId)
        self.games[name] = Game.new(placeId, self.screenGui)
    end

	self.position = DEFAULT_VALUE

    function self:OpenGame(placeId)
        for index, currentGame in pairs(self.games) do
            if currentGame.placeId == placeId then
                self.games[index]:Open(self.position)
				self.position = self.position + INCREMENT
            end
        end
    end

    function self:AddCommand(name, commandName, settings, func)
        self.games[name]:AddCommand(commandName, settings, func)
    end

	local mouse = player:GetMouse()
	self:AddCommand("Universal", "Triggerbot [S^X]", {
		Type = "Toggle"
	}, function(self)
		while wait() and self.value do
			if mouse.Target then
		        if mouse.Target.Parent:FindFirstChildOfClass("Humanoid") or mouse.Target.Parent.Parent:FindFirstChildOfClass("Humanoid") then
					mouse1click()
		        end
	    	end
		end
	end)
	
	self:AddCommand("Universal", "Anti-AFK", {
		Type = "Toggle"
	}, function(self)
		if self.conn then
			self.conn:Disconnect()
		end
		
		if self.value then
			self.conn = player.Idle:Connect(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end)
		end
	end)
	

    return setmetatable(self, Hub)
end

local GUI_LOCATION = game.CoreGui
_G.hub = Hub.new(GUI_LOCATION)

local THE_STREETS_GAME_NAME = "The Streets"
local function addStreets(name, id)
	_G.hub:AddGame(name, id)

	_G.hub:AddCommand(name, "Auto Stomp", {
	    Type = "Toggle"
	}, function(self)
	    while wait() and self.value do
	        local character = player.Character
	        if character then
	            local ray = Ray.new(character.HumanoidRootPart.Position, Vector3.new(0, -10, 0))
	            local part, position = workspace:FindPartOnRay(ray, character)
	            if part.Parent:FindFirstChildOfClass("Humanoid") or part.Parent.Parent:FindFirstChildOfClass("Humanoid") then
	                game.Players.LocalPlayer.Backpack.ServerTraits.Finish:FireServer(player.Character:FindFirstChildOfClass("Tool"))
	                wait(0.1)
	            end
	        end
	    end
	end)
	_G.hub:AddCommand(name, "Anti-Slow", {
		Type = "Toggle"
	}, function(self)
		 end)
  pcall(function()
  local gamelememe = getrawmetatable(game)
  local Closure, Caller = hide_me or newcclosure, checkcaller or is_protosmasher_caller or Cer.isCerus
  local writeable = setreadonly(gamelememe, false) or make_writeable(gamelememe)
  local name, index, nindex = gamelememe.__namecall, gamelememe.__index, gamelememe.__newindex
  local meta = getrawmetatable(game)
  local namecall = meta.__namecall
  local newindex = meta.__newindex
  local index = meta.__index
  local fakemodel = Instance.new("Model")
  fakemodel.Parent = game.Workspace
  fakehumanoid = Instance.new("Humanoid")

  gamelememe.__newindex = Closure(function(self, Property, b)
  	if not Caller() then
  		if self:IsA'Humanoid' then
  			game:GetService'StarterGui':SetCore('ResetButtonCallback', true)
  			if Property == "WalkSpeed" then
  			    return
  			elseif Property == "Health" or Property == "JumpPower" or Property == "HipHeight"  then
  				return
  			end
  		end
  		if Property == "CFrame" and self.Name == "HumanoidRootPart" or self.Name == "Torso" then
  			return
  		end
  	end
  	return nindex(self, Property, b)
  end)

  gamelememe.__namecall = Closure(function(self, ...)
  	if not Caller() then
  		local Arguments = {
  			...
  		}
  		if getnamecallmethod() == "Destroy" and tostring(self) == "BodyPosition" or getnamecallmethod() == "Destroy" and tostring(self) == "BodyVelocity" then
  			return invalidfunctiongang(self, ...)
  		end
  		if getnamecallmethod() == "BreakJoints" and tostring(self) == game:GetService'Players'.LocalPlayer.Character.Name then
  			return invalidfunctiongang(self, ...)
  		end
  		if getnamecallmethod() == "FireServer" then
  			if self.Name == "lIII" or tostring(self.Parent) == "ReplicatedStorage" then
  				return wait(9e9)
  			end
  			if Arguments[1] == "hey" then
  				return wait(9e9)
  			end
  		end
  	end
  	return name(self, ...)
  end)
    
    local player = game.Players.LocalPlayer
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        player.Character.Humanoid.WalkSpeed = 32        
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        player.Character.Humanoid.WalkSpeed = 16        
    end
end)
end)
end

addStreets(THE_STREETS_GAME_NAME, 455366377)
addStreets("The Prison", 4669040)

local SHARKBITE_GAME_NAME = "Sharkbite"
_G.hub:AddGame(SHARKBITE_GAME_NAME, 734159876)
_G.hub:AddCommand(SHARKBITE_GAME_NAME, "Fly as Shark", {
	Type = "Toggle"
}, function(self)
	repeat wait()
	until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Torso") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	local mouse = game.Players.LocalPlayer:GetMouse()
	repeat wait() until mouse
	local plr = game.Players.LocalPlayer
	local torso
	local flying = true
	local deb = true
	local maxspeed = 50
	local speed = 0
	local bv, bg
	
	while self.value do 
	    wait()
	    local body = workspace.Sharks:FindFirstChild("Shark"..game.Players.LocalPlayer.Name)
	    if body then
	        torso = body.Body
	
	        for _, move in next, body:GetChildren() do 
	            if move:IsA("BodyMover") then move:Destroy() end
	        end
	        if not bv then
	            bv = Instance.new("BodyVelocity", torso)
	            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
	        end
	        
	        if not bg then
	            bg = Instance.new("BodyGyro", torso)
	            bg.P = 9e4
	            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	        end
	        
	        bg.CFrame = mouse.Hit
	        torso.Velocity = mouse.Hit.lookVector * 100
	    end
	end
end)

_G.hub:AddCommand(SHARKBITE_GAME_NAME, "Rapidfire (Hold Weapon)", {
	Type = "Toggle"
}, function(self)
	if not self.value then
		return
	end

	local weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
	weapon:FindFirstChildOfClass("LocalScript"):Destroy()
	script.Parent = weapon
	
	local l__RenderStepped__1 = game:GetService("RunService").RenderStepped;
	local l__LocalPlayer__2 = game.Players.LocalPlayer;
	local l__mouse__3 = l__LocalPlayer__2:GetMouse();
	local u1 = false;
	local u2 = nil;
	local l__WeaponDisplay__3 = script.Parent:WaitForChild("WeaponDisplay");
	local u4 = 10;
	local u5 = false;
	local u6 = nil;
	local u7 = nil;
	script.Parent.Equipped:connect(function()
		u1 = true;
		u2 = l__WeaponDisplay__3:Clone();
		u2.Parent = game.Players.LocalPlayer.PlayerGui;
		u2.Frame.Ammo.Text = u4 .. " / " .. 10;
		game:GetService("UserInputService").InputBegan:connect(function(p1)
			if p1.KeyCode == Enum.KeyCode.ButtonX then
				reload();
			end;
		end);
		u6 = script.Parent.Parent.Humanoid:LoadAnimation(script.Parent.Idle);
		u7 = script.Parent.Parent.Humanoid:LoadAnimation(script.Parent.Shoot);
		u6:Play();
	end);
	local u8 = false;
	local u9 = false;
	script.Parent.Unequipped:connect(function()
		u1 = false;
		u8 = false;
		u9 = false;
		local l__WeaponDisplay__4 = game.Players.LocalPlayer.PlayerGui:FindFirstChild("WeaponDisplay");
		if l__WeaponDisplay__4 then
			l__WeaponDisplay__4:Destroy();
		end;
		u6:Stop();
		u7:Stop();
		game:GetService("ContextActionService"):UnbindAction("Reload");
	end);
	game.Players.LocalPlayer.Character.Humanoid.Died:connect(function()
		local l__WeaponDisplay__5 = game.Players.LocalPlayer.PlayerGui:FindFirstChild("WeaponDisplay");
		if l__WeaponDisplay__5 then
			l__WeaponDisplay__5:Destroy();
		end;
	end);
	l__mouse__3.Button1Down:connect(function()
		fireWeapon();
	end);
	local l__Projectiles__10 = game.Workspace.Events.Projectiles;
	local u11 = 0;
	function fireWeapon()
		local v6 = script.Parent.Handle.FireSound:Clone();
		v6.Parent = script.Parent.Handle;
		v6:Destroy();
		game.Workspace.Events.Projectiles.GunSound:FireServer(script.Parent.Handle);
		u7:Play();
				local v7 = l__mouse__3.Hit;
				if u5 then
					local l__AbsolutePosition__8 = u2.MobileAim.AbsolutePosition;
					local l__AbsoluteSize__9 = u2.MobileAim.AbsoluteSize;
					local l__Magnitude__10 = (l__LocalPlayer__2.Character.Head.Position - game.Workspace.CurrentCamera.CFrame.p).Magnitude;
					local v11 = game.Workspace.CurrentCamera:ScreenPointToRay(l__AbsolutePosition__8.X + l__AbsoluteSize__9.X / 2, l__AbsolutePosition__8.Y + l__AbsoluteSize__9.Y / 2, 0);
					local v12, v13 = game.Workspace:FindPartOnRay(Ray.new(v11.Origin, v11.Direction * 10000), l__LocalPlayer__2.Character);
					v7 = CFrame.new(v13);
				end;
				local l__Position__14 = script.Parent.Handle.Position;
				local l__lookVector__15 = CFrame.new(l__Position__14, v7.p).lookVector;
				l__Projectiles__10.ProjectileRenderEvent:FireServer(0, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 10000, 10000);
				coroutine.wrap(function()
					local v16 = game.ReplicatedStorage.ProjectileRayGun:Clone();
					v16.Parent = game.Workspace;
					local v17 = 0;
					local v18 = l__Position__14;
					local v19 = 2;
					while true do
						if v17 < 700 then
	
						else
							break;
						end;
						local v20, v21 = game.Workspace:FindPartOnRay(Ray.new(v18, l__lookVector__15.unit * v19), game.Players.LocalPlayer.Character, true, true);
						v18 = v21;
						if not v20 then
	
						else
							local l__Body__22 = v20.Parent:FindFirstChild("Body");
							if l__Body__22 then
								l__Projectiles__10.HealthChange:FireServer(l__Body__22.Parent.OwnerName.Value, 20, u11);
							end;
							local l__Body__23 = v20.Parent.Parent:FindFirstChild("Body");
							if l__Body__23 then
								l__Projectiles__10.HealthChange:FireServer(l__Body__23.Parent.OwnerName.Value, 20, u11);
							end;
							l__Projectiles__10.ProjectileRenderEvent:FireServer(1, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 20, 700);
							break;
						end;
						v16.CFrame = CFrame.new(v18, v18 + l__lookVector__15);
						if v19 * 2 < 20 then
							v19 = v19 * 2;
						elseif v19 ~= 20 then
							v19 = 20;
						end;
						v17 = v17 + v19;
						l__RenderStepped__1:wait();							
					end;
					v16:Destroy();
				end)();
		wait(0.1);
		u7:Stop();
	end;
	function reload()
		if u9 then
			return;
		end;
		u9 = true;
		u8 = false;
		script.Parent.Handle.ReloadSound:Play();
		wait(2.2);
		if not u1 then
			return;
		end;
		u4 = 10;
		u2.Frame.Ammo.Text = u4 .. " / " .. 10;
		u2.Frame.ReloadReminder.Visible = false;
		u9 = false;
	end;
	game.Workspace.Events.S.SEvent.OnClientEvent:connect(function(p2)
		u11 = p2;
	end);
end)


local MINEVERSE = "Mineverse"
_G.hub:AddGame(MINEVERSE, 4267085951)

_G.hub:AddCommand(MINEVERSE, "X-Ray", {
	Type = "Toggle"
}, function(self)
	local chamFolder = workspace:FindFirstChild("ChamFolder")
	if not chamFolder then
	    chamFolder = Instance.new("Folder")
	    chamFolder.Name = "ChamFolder"
	    chamFolder.Parent = workspace
	end
	
	while self.value do
		chamFolder:ClearAllChildren()
        local blocks = workspace.Blocks:GetDescendants()
        for i = 1, #blocks do
            local v = blocks[i]
            if v.Name == "CoalOre" and v:IsA("Part") then
                local cham = Instance.new("BoxHandleAdornment")
                cham.Adornee = v
                cham.Color3 = Color3.fromRGB(10,10,10)
                cham.Transparency = 0
                cham.Size = v.Size
                cham.AlwaysOnTop = true
                cham.ZIndex = 5
                cham.Parent = chamFolder
            end
        	if v.Name == "DiamondOre" and v:IsA("Part") then
               local cham = Instance.new("BoxHandleAdornment")
                cham.Adornee = v
                cham.Color3 = Color3.fromRGB(85, 170, 255)
                cham.Transparency = 0
                cham.Size = v.Size
                cham.AlwaysOnTop = true
                cham.ZIndex = 5
                cham.Parent = chamFolder
            end
            if v.Name == "IronOre" and v:IsA("Part") then
                local cham = Instance.new("BoxHandleAdornment")
                cham.Adornee = v
                cham.Color3 = Color3.fromRGB(255, 170, 127)
                cham.Size = v.Size
                cham.Transparency = 0
                cham.AlwaysOnTop = true
                cham.ZIndex = 5
                cham.Parent = chamFolder
            end
        end
	    
	    wait(5/2)
	end
end)

_G.hub:AddCommand(MINEVERSE, "Killaura", {
	Type = "Toggle"
}, function(self)	
	if self.conn then
		self.conn:Disconnect()
	end
	
	if not self.value then
		return
	end
	
	if not self.toggle then
		self.toggle = Instance.new("BindableEvent")
	end
	
	self.conn = self.toggle.Event:Connect(function()
		local player = game.Players.LocalPlayer
	    for i,v in ipairs(game.Players:GetPlayers()) do
	        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and player:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) < 12 and not player:IsFriendsWith(v.UserId) then
	            game.ReplicatedStorage.GameRemotes.Attack:InvokeServer(v.Character)
	        end
	    end
	end)
	
	while self.value do
		game:GetService("RunService").RenderStepped:Wait()
		self.toggle:Fire()
	end
end)

_G.hub:AddCommand(SHARKBITE_GAME_NAME, "Shark ESP", {
	Type = "Toggle"
}, function(self)
	local RunService = game:GetService("RunService")

	local ChamsFolder = Instance.new("Folder", game.CoreGui)
	
	local function transformToColor3(col) --Function to convert, just cuz c;
	    local r = col.r --Red value
	    local g = col.g --Green value
	    local b = col.b --Blue value
	    return Color3.new(r,g,b); --Color3 datatype, made of the RGB inputs
	end
	
	while wait(0.1) and self.value do
		ChamsFolder:ClearAllChildren()
		for _, character in pairs(workspace.Sharks:GetChildren()) do 
			for _, part in pairs(character:GetChildren()) do 
				if part:IsA("BasePart") then 
					local Box = Instance.new("BoxHandleAdornment")
					Box.Size = part.Size
					Box.Name = "Cham"
					Box.Adornee = part
					Box.AlwaysOnTop = true
					Box.ZIndex = 5
					Box.Transparency = 0.5
					Box.Parent = ChamsFolder
					Box.Color3 = transformToColor3(BrickColor.new("Bright red"))
				end
			end
		end
	end
end)

local function addMM2(name, id)
	_G.hub:AddGame(name, id)
	_G.hub:AddCommand(name, "Sheriff Aimbot [S^X]", {
		Type = "Toggle"
	}, function(self)
		while wait() and self.value do
			--if player.Backpack:FindFirstChild("Revolver") or player.Character:FindFirstChild("Revolver") then
				for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
					if currentPlayer.Character then
						if currentPlayer.Backpack:FindFirstChild("Knife") or currentPlayer.Character:FindFirstChild("Knife") then
							workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, currentPlayer.Character:GetBoundingBox().Position)
							local position = workspace.CurrentCamera:WorldToScreenPoint(currentPlayer.Character:GetBoundingBox().Position)
							mousemoveabs(position.X, position.Y)
						end
					end
				end
			--end
		end
	end)
end

addMM2("Casual", 142823291)

_G.hub:OpenGame(0)
_G.hub:OpenGame(game.PlaceId)
 