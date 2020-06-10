
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

local player = game.Players.LocalPlayer
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/AtQAJECZ", true))()
local OwlESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/scripts/OwlESP.lua"))();

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
			self:InitializeUI()	
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

local hub = Hub.new()
do
    local UNIVERSAL = "Universal"
    do
        hub:AddGame(UNIVERSAL, {0})
        hub.games[UNIVERSAL].InitializeUI = function(self)
            self.espEnabled = false
            self.tracersEnabled = false

            local tracking = {};

            local remove = table.remove;
            local fromRGB = Color3.fromRGB;

            local espColor = fromRGB(255, 255, 255);
            local teamCheck = true;

            local function characterRemoving(char)
                for i, v in next, tracking do
                    if v.char == char then
                        v:remove();
                        remove(tracking, i);
                    end;
                end;
            end;

            local function characterAdded(plr)
                local char = plr.Character;
                char:WaitForChild("HumanoidRootPart"); 
                char:WaitForChild("Head");
                tracking[#tracking + 1] = OwlESP.new({
                    plr = plr,
                    espBoxVisible = self.espEnabled,
                    tracerVisible = self.tracersEnabled,
                    text = plr.Name,
                    teamCheck = teamCheck,
                    espColor = espColor
                });
            end;

            local function playerAdded(plr)
                local char = plr.Character;
                if char then
                    characterAdded(plr)
                end;
                plr.CharacterAdded:Connect(function()
                    characterAdded(plr);
                end);
                plr.CharacterRemoving:Connect(characterRemoving);
            end;

            players.PlayerAdded:Connect(playerAdded);

            runService.RenderStepped:Connect(function()
                for _, v in ipairs(tracking) do
                    v:update();
                end;
            end);


            local window = Library:CreateWindow("Universal")
            window:Section("Render")
            window:Toggle("ESP", {
                flag = "esp"
            }, function(enable)
                for _, v in pairs(tracking) do
                    v:remove();
                end
                tracking = {};
                self.espEnabled = enable
                for _, plr in ipairs(players:GetPlayers()) do
                    playerAdded(plr)
                end;
            end)

            window:Toggle("Tracers", {
                flag = "tracers"
            }, function(enable)
                for _, v in pairs(tracking) do
                    v:remove();
                end
                tracking = {};
                self.tracersEnabled = enable
                for _, plr in ipairs(players:GetPlayers()) do
                    playerAdded(plr)
                end;
            end)
        end
    end

	local THE_STREETS = "The Streets"
	do
		hub:AddGame(THE_STREETS, {455366377, 4669040})
        hub.games[THE_STREETS].InitializeUI = function(self)
            self.speed = 24

            local function grip()
                game:GetService("RunService").Stepped:connect(function()
                    local hum = player.Character.Humanoid
                    if GripOnOff == true and not GripOnOff == false then
                        hum.Health = 0
                        for _,x in pairs(player.Character:GetChildren()) do
                            if x.Name == "Right Leg" then
                                x:Destroy()
                            end
                        end
                    end
                end)
            end

            local function dupe()
                local hum = player.Character.Humanoid
                if DupeOnOff == true and GripOnOff == true then
                    repeat
                        for _, x in pairs(player.Backpack:GetChildren()) do
                            if x:IsA("Tool") then
                                x.Parent = player
                            end
                        end
                        for _, b in pairs(player.Character:GetChildren()) do
                            if b:IsA("Part") then
                                if b.Name == "Right Leg" then
                                    print("Leg Found")
                                else
                                    hum:Destroy()
                                    hum:RemoveAccessories()
                                    b:Destroy()
                                end
                            end
                        end
                        wait()
                    until DupeOnOff == false
                else
                    if DupeOnOff == true and GripOnOff == false then
                        player.Character.Humanoid.Health = 0
                        GripOnOff = true
                        grip()
                        wait(7)
                        repeat
                            for _,x in pairs(player.Backpack:GetChildren()) do
                                if x:IsA("Tool") then
                                    x.Parent = player
                                end
                            end
                            for _, b in pairs(player.Character:GetChildren()) do
                                if b:IsA("Part") then
                                    if b.Name == "Right Leg" then
                                        print("Leg Found")
                                    else
                                        player:Destroy()
                                        hum:RemoveAccessories()
                                        b:Destroy()
                                    end
                                end
                            end
                            wait()
                        until DupeOnOff == false
                    end
                end
            end

            local window = Library:CreateWindow("The Streets")
            window:Section("Bypass")
            window:Button("Anti-Cheat Bypass", function()
                pcall(function()
                    local mt = getrawmetatable(game)
                    local newcclosure, checkcaller = hide_me or newcclosure, checkcaller or is_protosmasher_caller or Cer.isCerus
                    local mt_namecall, mt_newindex = mt.__namecall, mt.__newindex
                    local setreadonly = setreadonly or make_writable
                    
                    setreadonly(mt, false)

                    mt.__newindex = newcclosure(function(self, index, value)
                        if not checkcaller() then
                            if self:IsA('Humanoid') then
                                game:GetService('StarterGui'):SetCore('ResetButtonCallback', true)

                                if index == "WalkSpeed" then
                                    return
                                end

                                if index == "Health" or index == "JumpPower" or index == "HipHeight" then
                                    return
                                end
                            end

                            if index == "CFrame" and self.Name == "HumanoidRootPart" or self.Name == "Torso" then
                                return
                            end 
                        end

                        return mt_newindex(self, index, value)
                    end)

                    mt.__namecall = newcclosure(function(self, ...)
                        if not checkcaller() then
                            local args = {...}

                            if getnamecallmethod() == "Destroy" and self:IsA("BodyMover") then
                                return fuckyou(self, ...)
                            end

                            if getnamecallmethod() == "BreakJoints" and self.Name == player.Character.Name then
                                return fuckyou(self, ...)
                            end

                            if getnamecallmethod() == "FireServer" then
                                if self.Name == "lIII" or self.Parent.Name == "ReplicatedStorage" then
                                    return wait(9e9)
                                end

                                if args[1] == "hey" then
                                    return wait(9e9)
                                end
                            end
                        end

                        return mt_namecall(self, ...)
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

            local slider = window:Slider("Sprint Speed", {
                min = 24,
                max = 128,
                flag = "speed"
            }, function(v)
                self.speed = v
            end)

            window:Button("Reset Sprint Speed", function()
                slider:Set(24)
            end)

            window:Section("Requires Bypass")
            window:Toggle("God", {flag = "god"}, function(value)
                if self.bypass then
                    if value then
                        if not self.godConn then
                            local hum = player.Character.Humanoid
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

            window:Button("Buy Uzi", function()
                if self.bypass then
                    if game.PlaceId == 4669040 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "[TP Failed]";
                            Text = "You're in the prison!";
                        })
                    else
                        fastSpawn(function()
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
                        end)
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)
            
            window:Button("Buy Glock", function()
                 if self.bypass then
                    if game.PlaceId == 4669040 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "[TP Failed]";
                            Text = "You're in the prison!";
                        })
                    else
                        fastSpawn(function()
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
                        end)
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)

            window:Button("Buy Sawed Off", function()
                if self.bypass then
                   if game.PlaceId == 4669040 then
                       game:GetService("StarterGui"):SetCore("SendNotification", {
                           Title = "[TP Failed]";
                           Text = "You're in the prison!";
                       })
                   else
                        fastSpawn(function()
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
                        end)
                   end
               else
                   game:GetService("StarterGui"):SetCore("SendNotification", {
                       Title = "[Anticheat]";
                       Text = "You have not enabled the anticheat bypass!";
                   })
               end
           end)

            window:Toggle("Antiknock", {flag = "antiknock"}, function(value)
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

            window:Toggle("Infinite Jump", {flag = "infiniteJump"}, function(value)
                infiniteJump = value
            end)

            local superPunch = window:Toggle("Superpunch", {flag = "superPunch"}, function(value)
                fastSpawn(function()
                    if value then
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
                        elseif player.Backpack:FindFirstChild("Punch") then
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
                        end
                    end
                end)
            end)

            local antistomp = false
            window:Toggle("Antistomp", {flag = "antistomp"}, function(value)
                antistomp = value
                if antistomp then
                    repeat
                        if player.Character:FindFirstChild("KO") then
                            player.Character:findFirstChildOfClass("Humanoid"):ChangeState(7)
                        end
                        wait()
                    until not antistomp
                end
            end)
        end
    end

    local SHARK_BITE = "Sharkbite"
    do
        hub:AddGame(SHARK_BITE, {734159876})
        hub.games[SHARK_BITE].InitializeUI = function(self)
            self.flySpeed = 100

            local window = Library:CreateWindow("Sharkbite")

            -- Shark Commands
            window:Section("Shark Commands")
            window:Toggle("Fly as Shark", {flag = "sharkFly"}, function(enabled)
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

            window:Slider("Fly Speed", {
                min = 100,
                max = 500,
                flags = "flySpeed"
            }, function(speed)
                self.flySpeed = speed
            end)
            
            -- Human Commands
            window:Section("Human Commands")
            window:Button("Rapidfire Laser Gun [Hold Gun]", function()
               loadstring([[
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
                ]])();
            end)
            
        end
    end
    
    hub:OpenGame(game.PlaceId)
    hub:OpenGame(0)
end
 
