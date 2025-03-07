--[[

                         /$$                 /$$                 /$$      
                        | $$                | $$                | $$      
 /$$$$$$/$$$$   /$$$$$$ | $$$$$$$  /$$   /$$| $$$$$$$  /$$   /$$| $$$$$$$ 
| $$_  $$_  $$ /$$__  $$| $$__  $$| $$  | $$| $$__  $$| $$  | $$| $$__  $$
| $$ \ $$ \ $$| $$  \ $$| $$  \ $$| $$  | $$| $$  \ $$| $$  | $$| $$  \ $$
| $$ | $$ | $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$| $$  | $$
| $$ | $$ | $$|  $$$$$$/| $$$$$$$/|  $$$$$$$| $$  | $$|  $$$$$$/| $$$$$$$/
|__/ |__/ |__/ \______/ |_______/  \____  $$|__/  |__/ \______/ |_______/ 
                                   /$$  | $$                              
                                  |  $$$$$$/                              
                                   \______/             
--]]

repeat 
    wait()
until game:IsLoaded()

local players = game:GetService("Players");
local runService = game:GetService("RunService");

local discordLink = game:HttpGet("https://mobyhub-pipeline.glitch.me/discord")

print("mobyhub by alumark")

function randomString()
	local length = math.random(10,20)
	local array = {}
	for i = 1, length do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local player = game.Players.LocalPlayer

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/alumark/mobyhub-dependencies/master/ui.lua", true))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/alumark/mobyhub-dependencies/master/esp.lua", true))()

local GripOnOff = false
local DupeOnOff = false
local antiknock = false

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

local Game = {}
Game.__index = Game
do
	function Game.new(placeIds)
		local self = setmetatable({}, Game)
		
		self.placeIds = placeIds

		return self
	end
	
	function Game:Open()
		if self.InitializeUI then
			fastSpawn(self.InitializeUI, self)	
		end
	end
end

local Hub = {}
Hub.__index = Hub
do
	function Hub.new()
		local self = setmetatable({}, Hub)

		self.games = {}
		
		return self
	end
	
	--[[
		local CROSSROADS = "Crossroads"
		
		local hub = Hub.new()
		hub:AddGame(CROSSROADS, {1818})
		hub.games[CROSSROADS].InitializeUI = function(self)
			local w = library:CreateWindow('Example')
			w:Section('Top')
			local t = w:Toggle('Example Toggle', {flag = "toggle1"})
			local b = w:Button("Example Button", function()
			   print(w.flags.toggle1)
			end)
			w:Section('Middle')
			local old = workspace.CurrentCamera.FieldOfView
			local s = w:Slider("FOV", {
			   min = math.floor(workspace.CurrentCamera.FieldOfView);
			   max = 120;
			   flag = 'fov'
			}, function(v)
			   workspace.CurrentCamera.FieldOfView = v;
			end)
		end
	
		hub:OpenGame(game.PlaceId)
	--]]
	function Hub:AddGame(name, placeIds)
		self.games[name] = Game.new(placeIds)
	end
	
	function Hub:OpenGame(placeId)
		for index, _ in pairs(self.games) do
			if table.find(self.games[index].placeIds, placeId) then
				self.games[index]:Open()	
			end
		end
	end
end

local tracking = {};

local espEnabled = false
local tracerEnabled = false

local hub = Hub.new()
do
    local UNIVERSAL = "Universal"
    do
        hub:AddGame(UNIVERSAL, {0})
        hub.games[UNIVERSAL].InitializeUI = function(self)
            local remove = table.remove;
            local fromRGB = Color3.fromRGB;

            local espColor = fromRGB(255, 255, 255);

            local function characterRemoving(plr)
                for i, v in next, tracking do
                    if v.plr == plr then
                        v:remove();
                        remove(tracking, i);
                    end;
                end;
            end;

            local function characterAdded(plr)
                local char = plr.Character;
                local rootPart = char:WaitForChild("HumanoidRootPart"); 
                table.insert(tracking, ESP.new({
                    plr = plr,
                    part = rootPart,
                    name = plr.Name,
                    espBoxVisible = espEnabled,
                    tracerVisible = tracerEnabled,
                    text = plr.Name,
                    teamCheck = false,
                    espColor = espColor
                }))
            end;

            local function playerAdded(plr)
                local char = plr.Character;
                if char then
                    characterAdded(plr)
                end;
                plr.CharacterAdded:Connect(function()
                    characterAdded(plr);
                end);
                plr.CharacterRemoving:Connect(function()
                    characterRemoving(plr);
                end);
            end;

            players.PlayerAdded:Connect(playerAdded);

            runService.RenderStepped:Connect(function()
                for _, v in pairs(tracking) do
                    v:update();
                end;
            end);


            local window = Library:CreateWindow("Universal")
            local discord = window:CreateFolder("Made by Alumark")
            discord:Button("Copy Discord", function()
                setclipboard(discordLink)
            end)
            discord:Button("Run Infinite Yield", function()
                loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            end)

            local render = window:CreateFolder("Render")
            render:Toggle("ESP", function(toggle)
                for _, v in pairs(tracking) do
                    v:remove();
                end
                tracking = {};
                espEnabled = toggle
                if espEnabled then
                    for _, plr in ipairs(players:GetPlayers()) do
                        playerAdded(plr)
                    end
                end
            end)

            render:Toggle("Tracers", function(enable)
                for _, v in pairs(tracking) do
                    v:remove();
                end
                tracking = {};
                tracerEnabled = enable
                if espEnabled then
                    for _, plr in ipairs(players:GetPlayers()) do
                        playerAdded(plr)
                    end
                end
            end)


            fastSpawn(function()
                local mouse = player:GetMouse()
                while true do
                    wait()
                    if self.triggerbot then
                        if mouse.Target then
                            if mouse.Target.Parent:FindFirstChildOfClass("Humanoid") or mouse.Target.Parent.Parent:FindFirstChildOfClass("Humanoid") then
                                mouse1click()
                            end
                        end
                    end
                end
            end)

            local VirtualUser=game:GetService'VirtualUser'
            game:GetService'Players'.LocalPlayer.Idled:Connect(function()
                if self.antiafk then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)

            local utilities = window:CreateFolder("Utilities")
            utilities:Toggle("Triggerbot", function(enabled)
                self.triggerbot = enabled
            end)

            utilities:Toggle("Anti-AFK", function(enabled)
                self.antiafk = enabled
            end)
        end
    end

	local THE_STREETS = "The Streets"
	do
		hub:AddGame(THE_STREETS, {455366377, 4669040})
        hub.games[THE_STREETS].InitializeUI = function(self)
            self.speed = 24

            local window = Library:CreateWindow("The Streets")
            local Bypass = window:CreateFolder("Bypass")
            Bypass:Button("Anti-Cheat Bypass", function()
                pcall(function()
                    local mt = getrawmetatable(game)
                    local closure, caller = hide_me or newcclosure, checkcaller or is_protosmasher_caller or Cer.isCerus
                    local setreadonly = setreadonly or make_writable

                    local mt_namecall, mt_newindex = mt.__namecall, mt.__newindex

                    setreadonly(mt, false)

                    mt.__newindex = closure(function(instance, index, value)
                        if not caller() then
                            if instance:IsA('Humanoid') then
                                game:GetService('StarterGui'):SetCore('ResetButtonCallback', true)

                                if index == "WalkSpeed" then
                                    return
                                end

                                if index == "Health" or index == "JumpPower" or index == "HipHeight" then
                                    return
                                end
                            end

                            if index == "CFrame" and instance.Name == "HumanoidRootPart" or instance.Name == "Torso" then
                                return
                            end 
                        end

                        return mt_newindex(instance, index, value)
                    end)

                    mt.__namecall = closure(function(instance, ...)
                        local method = getnamecallmethod()
                        if not caller() then
                            local args = {...}

                            if method == "Destroy" and instance:IsA("BodyMover") then
                                return fuckyou(instance, ...)
                            end

                            if method == "BreakJoints" and instance.Name == player.Character.Name then
                                return fuckyou(instance, ...)
                            end

                            if method == "FireServer" then
                                if instance.Name == "lIII" then
                                    return wait(9e9)
                                end

                                if args[1] == "hey" then
                                    return wait(9e9)
                                end
                            end
                        end

                        return mt_namecall(instance, ...)
                    end)

                    self.bypass = true
                end)

                game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if self.bypass then
                        if input.KeyCode == Enum.KeyCode.LeftShift then
                            player.Character.Humanoid.WalkSpeed = self.speed      
                        end
                    end
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if self.bypass then
                        if input.KeyCode == Enum.KeyCode.LeftShift then
                            player.Character.Humanoid.WalkSpeed = 16        
                        end
                    end
                end)
            end)

            local slider = Bypass:Slider("Sprint Speed", 24, 128, true, function(v)
                self.speed = v
            end)

            Bypass:Button("Reset Sprint Speed", function()
                slider:Set(24)
            end)

            Bypass = window:CreateFolder("Requires Bypass")
            Bypass:Toggle("God", function(value)
                if self.bypass then
                    if value then
                        if not self.godConn then
                            local hum = player.Humanoid
                            self.godConn = game:GetService("RunService").Stepped:Connect(function()
                                hum.Health = 0
                                for _, v in pairs(player.Character:GetChildren()) do
                                    if v.Name == "Right Leg" then
                                        v:Destroy()
                                    end
                                end
                            end)
                        end
                    else
                        self.godConn = self.godConn:Disconnect()
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)

            Bypass:Button("Buy Uzi", function()
                if self.bypass then
                    if game.PlaceId == 4669040 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "[TP Failed]";
                            Text = "You're in the prison!";
                        })
                    else
                        local bought

                        local conn
                        conn = player.Backpack.ChildAdded:Connect(function(child)
                            if child:IsA("Tool") then
                                bought = true
                                conn:Disconnect()
                            end
                        end)

                        repeat
                            wait()
                            player.Character.HumanoidRootPart.CFrame = workspace["Uzi | $150"].Head.CFrame + Vector3.new(0, 2, 0)
                        until bought
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)
            
            Bypass:Button("Buy Glock", function()
                 if self.bypass then
                    if game.PlaceId == 4669040 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "[TP Failed]";
                            Text = "You're in the prison!";
                        })
                    else
                        local bought

                        local conn
                        conn = player.Backpack.ChildAdded:Connect(function(child)
                            if child:IsA("Tool") then
                                bought = true
                                conn:Disconnect()
                            end
                        end)

                        repeat
                            wait()
                            player.Character.HumanoidRootPart.CFrame = workspace["Glock | $200"].Head.CFrame + Vector3.new(0, 2, 0)
                        until bought
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)

            Bypass:Button("Buy Sawed Off", function()
                if self.bypass then
                   if game.PlaceId == 4669040 then
                       game:GetService("StarterGui"):SetCore("SendNotification", {
                           Title = "[TP Failed]";
                           Text = "You're in the prison!";
                       })
                   else
                        local bought

                        local conn
                        conn = player.Backpack.ChildAdded:Connect(function(child)
                            if child:IsA("Tool") then
                                bought = true
                                conn:Disconnect()
                            end
                        end)

                        repeat
                            wait()
                            player.Character.HumanoidRootPart.CFrame = workspace["Sawed Off | $150"].Head.CFrame + Vector3.new(0, 2, 0)
                        until bought
                   end
               else
                   game:GetService("StarterGui"):SetCore("SendNotification", {
                       Title = "[Anticheat]";
                       Text = "You have not enabled the anticheat bypass!";
                   })
               end
           end)

           Bypass:Toggle("Antiknock", {flag = "antiknock"}, function(value)
                if self.bypass then
                    antiknock = value
                    local conn
                    conn = player.Character.Humanoid.StateChanged:Connect(function(antifunction)
                        if antiknock then
                            repeat
                                wait()
                                if antifunction == Enum.HumanoidStateType.FallingDown or antifunction == Enum.HumanoidStateType.RunningNoPhysics then
                                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding and Enum.HumanoidStateType.GettingUp)
                                else
                                    return
                                end
                            until not antiknock

                            conn:Disconnect()
                        end
                    end)
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)

            local infiniteJump = false
            game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.KeyCode == Enum.KeyCode.Space then
                    if infiniteJump then
                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    else
                        return
                    end
                end
            end)

            Bypass:Toggle("Infinite Jump", function(value)
                infiniteJump = value
            end)

            Bypass:Toggle("Superpunch", function(value)
                if value then
                    fastSpawn(function()
                        if player.Character:FindFirstChild("Punch") then
                            for _, x in ipairs(player.Character:GetChildren()) do
                                if x:IsA("Tool") and x.Name == "Punch" then
                                    x.Grip = player.Character.Torso.CFrame * CFrame.new(math.huge,math.huge,math.huge)
                                    wait(0.3)
                                    x.Parent = player.Backpack
                                    wait(0.5)
                                    x.Parent = player.Character
                                end
                            end
                        end
                    end)
                elseif player.Backpack:FindFirstChild("Punch") then
                    fastSpawn(function()
                        player.Backpack.Punch.Parent = player.Character
                        wait(0.01)
                        for _, x in ipairs(player.Character:GetChildren()) do
                            if x:IsA("Tool") and x.Name == "Punch" then
                                x.Grip = player.Character.Torso.CFrame * CFrame.new(math.huge,math.huge,math.huge)
                                wait(0.3)
                                x.Parent = player.Backpack
                                wait(0.5)
                                x.Parent = player.Character
                            end
                        end
                    end)
                end
            end)

            local antistomp = false
            Bypass:Toggle("Antistomp", function(value)
                antistomp = value
                if antistomp then
                    fastSpawn(function()
                        repeat
                            if player.Character:FindFirstChild("KO") then
                                player.Character:findFirstChildOfClass("Humanoid"):ChangeState(7)
                            end
                            wait()
                        until not antistomp
                    end)
                end
            end)

            local Utilities = window:CreateFolder("Utilities")
            pcall(function()
                local game_metatable = getrawmetatable(game)
                local namecall_original = game_metatable.__namecall

                setreadonly(game_metatable, false)

                game_metatable.__namecall = newcclosure(function(instance, ...)
                    local method = getnamecallmethod()
                    
                    local args = {...}

                    if instance.Name == "Fire" and method == "FireServer" and self.aimbot then
                        local closestCharacter, closestDistance = nil, math.huge
                        for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
                            if currentPlayer ~= game.Players.LocalPlayer then
                                local character = currentPlayer.Character
                                if character then
                                    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                                    if humanoid and humanoid.Health > 0 then
                                        local distance = currentPlayer.DistanceFromCharacter(currentPlayer, args[1].Position)
                                        if distance < closestDistance then
                                            closestCharacter, closestDistance = character, distance
                                        end
                                    end
                                end
                            end
                        end
                    
                        if closestCharacter then
                            args[1] = closestCharacter.HumanoidRootPart.CFrame
                        end
                        
                        return instance.FireServer(instance, unpack(args))
                    end
                    
                    return namecall_original(instance, unpack(args)) 
                end)
            end)

            Utilities:Toggle("Aimbot", function(bool)
                self.aimbot = bool
            end)
        end
    end

    local SHARK_BITE = "Sharkbite"
    do
        hub:AddGame(SHARK_BITE, {734159876})
        hub.games[SHARK_BITE].InitializeUI = function(self)
            self.flySpeed = 100

            local window = Library:CreateWindow("Sharkbite")

            local sharkESP = false
            local sharkTracer = false

            local sharkTracking = {}
            runService.RenderStepped:Connect(function()
                for _, v in pairs(sharkTracking) do
                    v:update()
                end
            end)

            fastSpawn(function()
                while wait(0.1) do
                    for _, esp in pairs(sharkTracking) do
                        esp:remove()
                    end
                    sharkTracking = {}

                    for _, shark in pairs(workspace.Sharks:GetChildren()) do
                        local text = shark.Name:sub(("SHARK_"):len())
                        table.insert(sharkTracking, 
                            ESP.new({
                                part = shark.Body,
                                name = text,
                                espBoxVisible = sharkESP,
                                tracerVisible = sharkTracer,
                                text = text,
                                teamCheck = false,
                                espColor = Color3.new(1, 0, 0)
                            })
                        )
                    end
                end
            end)

            -- Shark Commands
            local sharkCommands = window:CreateFolder("Shark Commands")
            sharkCommands:Toggle("Fly as Shark", function(enabled)
                self.flyEnabled = enabled
                fastSpawn(function()
                    local mouse = game.Players.LocalPlayer:GetMouse()

                    repeat 
                        wait() 
                    until mouse
                    
                    while self.flyEnabled do 
                        wait()
                        local body = workspace.Sharks:FindFirstChild("Shark"..game.Players.LocalPlayer.Name)
                        if body then
                            local torso = body.Body
                    
                            for _, move in next, body:GetChildren() do 
                                if move:IsA("BodyMover") then 
                                    move:Destroy() 
                                end
                            end
                            
                            torso.Velocity = mouse.Hit.lookVector * self.flySpeed
                        end
                    end
                end)
            end)

            sharkCommands:Slider("Fly Speed", 100, 500, true, function(speed)
                self.flySpeed = speed
            end)

            sharkCommands:Toggle("Noclip as Shark", function(bool)
                self.noclip = bool
            end)
            
            fastSpawn(function()
                while wait() do
                    local body = workspace.Sharks:FindFirstChild("Shark"..game.Players.LocalPlayer.Name)
                    if body and self.noclip then
                        for _, part in ipairs(body:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)

            -- Human Commands
            local humanCommands = window:CreateFolder("Human Commands")
            humanCommands:Button("Rapidfire Laser Gun [Hold Gun]", function()
               loadstring([[
                    local weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if weapon:FindFirstChildOfClass("LocalScript") then
                        weapon:FindFirstChildOfClass("LocalScript"):Destroy()
                    end
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
                                l__Projectiles__10.ProjectileRenderEvent:FireServer(10, l__LocalPlayer__2.Name, 20, l__Position__14, v7, 20, 700);
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
                                                l__Projectiles__10.HealthChange:FireServer(l__Body__22.Parent.OwnerName.Value, 1, u11);
                                            end;
                                            local l__Body__23 = v20.Parent.Parent:FindFirstChild("Body");
                                            if l__Body__23 then
                                                l__Projectiles__10.HealthChange:FireServer(l__Body__23.Parent.OwnerName.Value, 1, u11);
                                            end;
                                            l__Projectiles__10.ProjectileRenderEvent:FireServer(3, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 20, 700);
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
                ]])();
            end)

            humanCommands:Button("Godmode Gun [Hold Gun]", function()
                loadstring([[
                     local weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                     if weapon:FindFirstChildOfClass("LocalScript") then
                        weapon:FindFirstChildOfClass("LocalScript"):Destroy()
                    end
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
                                 l__Projectiles__10.ProjectileRenderEvent:FireServer(0, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 20, 700);
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
                                                 l__Projectiles__10.HealthChange:FireServer(l__Body__22.Parent.OwnerName.Value, -math.huge, u11);
                                             end;
                                             local l__Body__23 = v20.Parent.Parent:FindFirstChild("Body");
                                             if l__Body__23 then
                                                 l__Projectiles__10.HealthChange:FireServer(l__Body__23.Parent.OwnerName.Value, -math.huge, u11);
                                             end;
                                             l__Projectiles__10.ProjectileRenderEvent:FireServer(3, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 20, 700);
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
                 ]])();
             end)

             humanCommands:Button("Instakill Gun [Hold Gun]", function()
                loadstring([[
                     local weapon = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
                     weapon:FindFirstChildOfClass("LocalScript"):Destroy()
                     if weapon:FindFirstChildOfClass("LocalScript") then
                        weapon:FindFirstChildOfClass("LocalScript"):Destroy()
                    end
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
                                 l__Projectiles__10.ProjectileRenderEvent:FireServer(0, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 20, 700);
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
                                                 l__Projectiles__10.HealthChange:FireServer(l__Body__22.Parent.OwnerName.Value, math.huge, u11);
                                             end;
                                             local l__Body__23 = v20.Parent.Parent:FindFirstChild("Body");
                                             if l__Body__23 then
                                                 l__Projectiles__10.HealthChange:FireServer(l__Body__23.Parent.OwnerName.Value, math.huge, u11);
                                             end;
                                             l__Projectiles__10.ProjectileRenderEvent:FireServer(3, l__LocalPlayer__2.Name, 1, l__Position__14, v7, 20, 700);
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
                 ]])();
             end)
            
            humanCommands:Toggle("Aimbot", function(bool)
                self.aimbot = bool    
            end)

            local game_metatable = getrawmetatable(game)
            local namecall_original = game_metatable.__namecall

            setreadonly(game_metatable, false)
            local mouse = game.Players.LocalPlayer:GetMouse()


            game_metatable.__namecall = newcclosure(function(instance, ...)
                local method = getnamecallmethod()
                
                local args = {...}

                if instance.Name == "ProjectileRenderEvent" and method == "FireServer" and self.aimbot then
                    local closestCharacter, closestDistance = workspace.Sharks:GetChildren()[1], math.huge
                    for _, shark in ipairs(workspace.Sharks:GetChildren()) do
                        if shark then
                            local pos = args[5]
                            if typeof(pos) == "CFrame" then
                                pos = pos.Position
                            end
                            local distance = (shark.Body.Position - pos).magnitude
                            if distance < closestDistance then
                                closestCharacter, closestDistance = shark, distance
                            end
                        end
                    end
                
                    if closestCharacter then
                        args[5] = closestCharacter.Body.CFrame
                        args[4] = closestCharacter.Body.CFrame.Position
                    end
                    
                    return instance.FireServer(instance, unpack(args))
                end
                
                if method == "FindPartOnRay" and not checkcaller() and getcallingscript():IsDescendantOf(game.Players.LocalPlayer.Character) then
                    if self.wallbang then
                        local ray = Ray.new(args[1].Origin, (mouse.Hit.p - args[1].Origin))
                        args[1] = ray
                    end

                    if self.aimbot then
                        local closestCharacter, closestDistance = workspace.Sharks:GetChildren()[1], math.huge
                        for _, shark in ipairs(workspace.Sharks:GetChildren()) do
                            if shark then
                                local pos = localMouse.Hit.p
                                local distance = (shark.Body.Position - pos).magnitude
                                if distance < closestDistance then
                                    closestCharacter, closestDistance = shark, distance
                                end
                            end
                        end
                        
                        if closestCharacter then
                            local ray = Ray.new(args[1].Origin, (closestCharacter.Body.Position - args[1].Origin))
                            args[1] = ray
                        end
                    end

                    args[2] = {args[2]}

                    return instance.FindPartOnRayWithIgnoreList(instance, unpack(args))
                end
                
                return namecall_original(instance, unpack(args)) 
            end)

            local oldFunction
            oldFunction = hookfunction(workspace.FindPartOnRayWithIgnoreList, newcclosure(function(instance, ...)
                local args = {...}
                
                if self.wallbang then
                    table.insert(args[2], workspace.Terrain)
                    table.insert(args[2], workspace.Boats)
                    table.insert(args[2], workspace.Lobby)
                end
                
                return oldFunction(instance, unpack(args))
            end))

            local render = window:CreateFolder("Render")
            render:Toggle("Shark ESP", function(bool)
                sharkESP = bool
            end)

            render:Toggle("Shark Tracers", function(bool)
                sharkTracer = bool
            end)
        end
    end
    
    local MURDER_MYSTERY_2 = "MM2"
    do
        hub:AddGame(MURDER_MYSTERY_2, {142823291})
        hub.games[MURDER_MYSTERY_2].InitializeUI = function(self)
            local window = Library:CreateWindow("Murder Mystery 2")
            
            local sheriffCommands = window:CreateFolder("Sheriff Commands")

            local game_metatable = getrawmetatable(game)
            local namecall_original = game_metatable.__namecall

            setreadonly(game_metatable, false)

            local function getMap()
                local map
            
                for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("Spawns") then
                        map = v
                    end
                end
            
                return map
            end

            local aimbot = false
            game_metatable.__namecall = newcclosure(function(instance, ...)
                local method = getnamecallmethod()
                
                local args = {...}

                if instance.Name == "ShootGun" and method == "InvokeServer" and aimbot then
                    local closestCharacter
                    for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
                        if currentPlayer ~= game.Players.LocalPlayer then
                            local character = currentPlayer.Character
                            if character then
                                local knife = currentPlayer.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")
                                if knife then
                                    closestCharacter = character 
                                end
                            end
                        end
                    end
                
                    if closestCharacter then
                        args[2] = closestCharacter.HumanoidRootPart.CFrame.p
                    end
                    
                    return instance.InvokeServer(instance, unpack(args))
                end

                return namecall_original(instance, unpack(args)) 
            end)

            sheriffCommands:Toggle("Aimbot", function(bool)
                aimbot = bool
            end)

            local gunESP
            local player = game.Players.LocalPlayer
            workspace.ChildAdded:Connect(function(child)
                if child.Name == "GunDrop" then
                    if not gunESP then
                        gunESP = ESP.new({
                            part = child,
                            name = child.Name,
                            espBoxVisible = espEnabled,
                            tracerVisible = tracerEnabled,
                            text = "Gun",
                            teamCheck = false,
                            espColor = self.colours.GunDrop
                        })
                    end




                    if self.teleportToGun then
                        local character = player.Character
                        if character then
                            local knife = player.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")
                            local waiting = player.PlayerGui:FindFirstChild("MainGUI"):FindFirstChild("Game"):FindFirstChild("Waiting")
                            if not knife and waiting and not waiting.Visible then
                                wait(self.tpDelay)
                                local bambam
                                if self.flingWhenTP then
                                    for _, child in pairs(player.Character:GetDescendants()) do
                                        if child:IsA("BasePart") then
                                            child.CustomPhysicalProperties = PhysicalProperties.new(2, 0.3, 0.5)
                                        end
                                    end
                                    for _,v in pairs(player.Character.Humanoid:GetAccessories()) do
                                        for e,c in pairs(v:GetDescendants()) do
                                            if c:IsA('BasePart') then
                                                c.CustomPhysicalProperties = PhysicalProperties.new(0, 0.3, 0.5)
                                            end
                                        end
                                    end
                                    wait(0.1)
                                    bambam = Instance.new("BodyAngularVelocity", player.Character.HumanoidRootPart)
                                    bambam.Name = ""
                                    bambam.AngularVelocity = Vector3.new(0,311111,0)
                                    bambam.MaxTorque = Vector3.new(0,311111,0)
                                    bambam.P = math.huge
                                    local function PauseFling()
                                        if player.Character:FindFirstChildOfClass("Humanoid") then
                                            if player.Character:FindFirstChildOfClass("Humanoid").FloorMaterial == Enum.Material.Air then
                                                bambam.AngularVelocity = Vector3.new(0,0,0)
                                            else
                                                bambam.AngularVelocity = Vector3.new(0,311111,0)
                                            end
                                        end
                                    end
                                    if TouchingFloor then
                                        TouchingFloor:Disconnect()
                                    end
                                    if TouchingFloorReset then
                                        TouchingFloorReset:Disconnect()
                                    end
                                    TouchingFloor = player.Character:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("FloorMaterial"):connect(PauseFling)
                                    flinging = true
                                    local function flingDied()
                                        if TouchingFloor then
                                            TouchingFloor:Disconnect()
                                        end
                                        if TouchingFloorReset then
                                            TouchingFloorReset:Disconnect()
                                        end
                                        flinging = false
                                        wait(0.1)
                                        local speakerChar = player.Character
                                        if not speakerChar or not speakerChar:FindFirstChild("HumanoidRootPart") then return end
                                        for _,v in pairs(speakerChar.HumanoidRootPart:GetChildren()) do
                                            if v.ClassName == 'BodyAngularVelocity' then
                                                v:Destroy()
                                            end
                                        end
                                        for _, child in pairs(speakerChar:GetDescendants()) do
                                            if child.ClassName == "Part" or child.ClassName == "MeshPart" then
                                                child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
                                            end
                                        end
                                    end
                                    TouchingFloorReset = player.Character:FindFirstChildOfClass('Humanoid').Died:connect(flingDied)
                                end
                                local lastCFrame = player.Character.HumanoidRootPart.CFrame
                                player.Character.HumanoidRootPart.CFrame = child.CFrame
                                player.Character.Humanoid:Move(Vector3.new(1,0,0))
                                player.Backpack.ChildAdded:Wait()
                                player.Character.HumanoidRootPart.CFrame = lastCFrame
                                bambam:Destroy()
                            end
                        end
                    end
                end
            end)

            workspace.ChildRemoved:Connect(function(child)
                if child.Name == "GunDrop" then
                    if gunESP then
                        gunESP = gunESP:remove() 
                    end
                end
            end)

            game:GetService("RunService").RenderStepped:Connect(function()
                if gunESP then
                    gunESP:update()
                end
            end)

            sheriffCommands:Toggle("Teleport to Gun", function(bool)
                self.teleportToGun = bool
            end)

            self.flingWhenTP = false
            self.tpDelay = 2

            local tpDelay = sheriffCommands:Slider("Teleport Delay", 0, 10, false, function(v)
                self.tpDelay = v
            end)

            tpDelay:Set(2)

            sheriffCommands:Toggle("Fling on TP [Prevents Campers]", function(v)
                self.flingWhenTP = v
            end)

            self.colours = {
                Innocent = Color3.fromRGB(0, 255, 0),
                Sheriff = Color3.fromRGB(1, 66, 243),
                Murderer = Color3.fromRGB(243, 1, 1),
                GunDrop = Color3.fromRGB(255, 0, 255)
            }

            local render = window:CreateFolder("Render")
            render:ColorPicker("Innocent ESP Color", Color3.fromRGB(0, 255, 34), function(color)
                self.colours.Innocent = color
            end)

            render:ColorPicker("Sheriff ESP Color", Color3.fromRGB(1, 66, 243), function(color)
                self.colours.Sheriff = color
            end)

            render:ColorPicker("Murderer ESP Color", Color3.fromRGB(243, 1, 1), function(color)
                self.colours.Murderer = color
            end)

            render:ColorPicker("Gun ESP Color", Color3.fromRGB(255, 0, 255), function(color)
                self.colours.GunDrop = color
            end)


            fastSpawn(function()
                while wait(0.1) do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        local character = player.Character
                        if character then
                            local knife = player.Backpack:FindFirstChild("Knife") or character:FindFirstChild("Knife")
                            local gun = (
                                player.Backpack:FindFirstChild("Revolver") or 
                                character:FindFirstChild("Revolver") or 
                                player.Backpack:FindFirstChild("Gun") or 
                                character:FindFirstChild("Gun")
                            )
    
                            local colour = self.colours.Innocent
                            if knife then
                                colour = self.colours.Murderer
                            elseif gun then
                                colour = self.colours.Sheriff
                            end
    
                            for index, esp in pairs(tracking) do
                                if esp.plr == player then
                                    tracking[index].espColor = colour
                                end
                            end
                        end
                    end
                end
            end)
        end
    end

    local localPlayer = game.Players.LocalPlayer

    local WILD_REVOLVERS = "Wild Revolvers"
    do
        hub:AddGame(WILD_REVOLVERS, {983224898})
        hub.games[WILD_REVOLVERS].InitializeUI = function(self)
            local window = Library:CreateWindow("Wild Revolvers")
            local utilities = window:CreateFolder("Utilities")
            utilities:Toggle("Wallbang", function(bool)
                self.wallbang = bool
            end)

            utilities:Toggle("Aimbot", function(bool)
                self.aimbot = bool
            end)

            pcall(function()
                local function getMap()
                    local map
                
                    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
                        if v:IsA("Folder") and v.Name ~= "PlayerData" and v.Name ~= "Lobbies" then
                            map = v
                        end
                    end
                
                    return map
                end
                
                local player = game.Players.LocalPlayer
                
                local mt = getrawmetatable(game)
                if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end
                local getnamecallmethod = getnamecallmethod or get_namecall_method
                local newcclosure = newcclosure or hide_me or function(f) return f end
                local checkcaller = checkcaller or is_protosmasher_caller or Cer.isCerus
                local mt_namecall = mt.__namecall
                
                mt.__namecall = newcclosure(function(instance, ...)
                    if not checkcaller() then
                        
                        if getnamecallmethod() == "FindPartOnRayWithIgnoreList" and self.wallbang then
                            local args = {...}
                            
                            table.insert(args[2], getMap())
                            
                            return instance.FindPartOnRayWithIgnoreList(instance, unpack(args))
                        end
                        
                    end
                    
                    return mt_namecall(
                        instance,
                        ...
                    )
                end)                
            end)

            pcall(function()
                local game_metatable = getrawmetatable(game)
                local namecall_original = game_metatable.__namecall

                setreadonly(game_metatable, false)

                game_metatable.__namecall = newcclosure(function(instance, ...)
                    local method = getnamecallmethod()
                    
                    local args = {...}

                    if instance.Name == "GunFired" and method == "FireServer" and self.aimbot then
                        local closestCharacter, closestDistance = nil, math.huge
                        for _, currentPlayer in ipairs(game.Players:GetPlayers()) do
                            if currentPlayer ~= game.Players.LocalPlayer then
                                local character = currentPlayer.Character
                                if character then
                                    local shirt = character:FindFirstChildWhichIsA("Shirt") 
                                    local localShirt = (localPlayer.Character or localPlayer.CharacterAdded:Wait()):FindFirstChildWhichIsA("Shirt")
                                    if shirt and localShirt then
                                        local sameShirt = (shirt.ShirtTemplate ~= localShirt.ShirtTemplate)
                                        if sameShirt then
                                            local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                                            if humanoid and humanoid.Health > 0 then
                                                local distance = currentPlayer.DistanceFromCharacter(currentPlayer, args[1].HitPosition)
                                                if distance < closestDistance then
                                                    closestCharacter, closestDistance = character, distance
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    
                        if closestCharacter then
                            args[1].HitPosition = closestCharacter.HumanoidRootPart.CFrame.p
                        end
                        
                        return self.FireServer(instance, unpack(args))
                    end
                    
                    return namecall_original(instance, unpack(args)) 
                end)
            end)

            fastSpawn(function()
                while wait(1) do
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        local character = player.Character
                        if character then
                            local colour = Color3.fromRGB(1, 243, 106)
                            
                            pcall(function()
                                if character:FindFirstChildWhichIsA("Shirt").ShirtTemplate ~= localPlayer.Character:FindFirstChildWhichIsA("Shirt").ShirtTemplate then
                                    colour = Color3.fromRGB(189, 27, 27)
                                end
                            end)
    
                            for index, esp in pairs(tracking) do
                                if esp.plr == player then
                                    tracking[index].espColor = colour
                                end
                            end
                        end
                    end
                end
            end)
        end
    end

    local REASON_2_DIE = "Reason 2 Die"
    do
        hub:AddGame(REASON_2_DIE, {177200271, 628009815})
        hub.games[REASON_2_DIE].InitializeUI = function(self)
            local player = game.Players.LocalPlayer

            local fireserver_original, invokeserver_original
            local re, rf = Instance.new("RemoteEvent"), Instance.new("RemoteFunction")
            fireserver_original = hookfunction(re.FireServer, newcclosure(function(instance, method, ...)
                local script = getcallingscript()
                
                local noob = false
                for _, arg in ipairs({...}) do
                    if typeof(arg) == "string" then
                        if arg:lower():find("noobbuster") then
                            noobs = true
                        end
                    end
                end

                if noob then
                    return
                end
                
                if instance.Name == "BooBuster" then
                    return
                end
                
                if instance.Name == "FX" then
                    return    
                end
                
                if instance.Name == "SelfDamage" then
                    return    
                end
                
                return fireserver_original(self, method, ...)
            end))

            local function spoof(instance, returns)
                returns[2].CLIPS = 100
                returns[2].AMMO = 200
                returns[2].RANGE = 9999999
                returns[2].KICKBACK = 0
                returns[2].ACCURACY = 9999999
                
                return unpack(returns)
            end

            invokeserver_original = hookfunction(rf.InvokeServer, newcclosure(function(instance, ...)
                if instance.Name == "GetCodes" then
                    return spoof(instance, instance:InvokeServer(...))
                end
                
                
                return invokeserver_original(instance, ...)
            end))

            local game_metatable = getrawmetatable(game)
            local namecall_original = game_metatable.__namecall
            local index_original = game_metatable.__index

            setreadonly(game_metatable, false)

            game_metatable.__namecall = newcclosure(function(instance, ...)
                local method = getnamecallmethod()

                if method == "Kick" and instance.Name == player.Name then
                    return
                end
                
                if method == "Destroy" and instance.ClassName == "ModuleScript" then
                    return    
                end
                
                if method == "FireServer" then
                    if instance.Name == "FX" then
                        return    
                    end
                    
                    if instance.Name == "SelfDamage" then
                        return    
                    end
                end
                
                return namecall_original(instance, ...)
            end)

        end
    end

    hub:OpenGame(0)
    hub:OpenGame(game.PlaceId)
end
 
 