
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

local player = game.Players.LocalPlayer
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/AtQAJECZ", true))()

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
	local THE_STREETS = "The Streets"
	do
		hub:AddGame(THE_STREETS, {455366377, 4669040})
        hub.games[THE_STREETS].InitializeUI = function(self)
            self.speed = 24

            local window = Library:CreateWindow("The Streets")
            window:Section("Bypass")
            window:Button("Anti-Cheat Bypass", function()
                fastSpawn(function()
                    local mt = getrawmetatable(game)
                    local newcclosure, checkcaller = hide_me or newcclosure, checkcaller or is_protosmasher_caller or Cer.isCerus
                    local mt_namecall, mt_index, mt_newindex = mt.__namecall, mt.__index, mt.__newindex

                    if setreadonly then
                        setreadonly(mt, false)
                    elseif makewriteable then
                        make_writeable(mt)
                    end

                    mt.__newindex = newcclosure(function(self, index, value)
                        if not newcclosure() then
                            if self:IsA('Humanoid') then
                                game:GetService('StarterGui'):SetCore('ResetButtonCallback', true)

                                if index == "WalkSpeed" then
                                    return
                                end

                                if index == "Health" or index == "JumpPower" or index == "HipHeight" then
                                    return
                                end
                            end

                            if index == "CFrame" and self:IsDescendantOf(player.Character) then
                                return
                            end
                        end

                        return mt_newindex(self, index, value)
                    end)

                    mt.__namecall = newcclosure(function(self, ...)
                        if not checkcaller() then
                            local args = {...}

                            if getnamecallmethod() == "Destroy" and self:IsA("BodyMover") then
                                return invalidfunctiongang(self, ...)
                            end

                            if getnamecallmethod() == "BreakJoints" and self.Name == player.Character.Name then
                                return invalidfunctiongang(self, ...)
                            end

                            if getnamecallmethod() == "FireServer" then
                                if self.Name == "lIII" or self.Parent:IsA("ReplicatedStorage") then
                                    return wait(9e9)
                                end

                                if args[1] == "hey" then
                                    return wait(9e9)
                                end
                            end

                            if getnamecallmethod() == "SetState" and self:IsA("Humanoid") then
                                return 
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

            local resetSprint = window:Button("Reset Sprint Speed", function()
                slider:Set(24)
            end)

            window:Selection("Requires Bypass")
            local godMode = window:Toggle("God", {flag = "god"}, function(value)
                if self.bypass then
                    if value then
                        if not self.godConn then
                            self.godConn = game:GetService("RunService").Stepped:Connect(function()
                                player.Character.Humanoid.Health = 0
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

            local uziButton = window:Button("Buy Uzi", function()
                if self.bypass then
                    if game.PlaceId == 4669040 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "[TP Failed]";
                            Text = "You're in the prison!";
                        })
                    else
                        player.Character:MoveTo(workspace["Uzi | $150"].Head.Position)
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)
            
            local glockButton = window:Button("Buy Glock", function()
                 if self.bypass then
                    if game.PlaceId == 4669040 then
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "[TP Failed]";
                            Text = "You're in the prison!";
                        })
                    else
                        player.Character:MoveTo(workspace["Glock | $200"].Head.Position)
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)

            local antiKnock = window:Toggle("Antiknock", {flag = "antiknock"}, function(value)
                if self.bypass then
                    if value then
                        if not self.antiKnock then
                            self.antiKnock = player.Character.Humanoid.StateChanged:Connect(function(state)
                                repeat
                                    wait()
                                    if state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.RunningNoPhysics then
                                        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding)
                                    end
                                until not self.antiKnock
                            end)
                        end
                    else
                        self.antiKnock = self.antiKnock:Disconnect()
                    end
                else
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Anticheat]";
                        Text = "You have not enabled the anticheat bypass!";
                    })
                end
            end)
        end
    end
    
    hub:OpenGame(game.PlaceId)
    hub:OpenGame(0)
end
 
