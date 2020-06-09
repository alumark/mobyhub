
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
            self.speed = 32

            local window = Library:CreateWindow("The Streets")
            window:Section("Bypass")
            window:Button("Anti-Cheat Bypass", function()
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
                end)

                game:GetService("UserInputService").InputBegan:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.LeftShift then
                        player.Character.Humanoid.WalkSpeed = self.speed        
                    end
                end)

                game:GetService("UserInputService").InputEnded:Connect(function(input)
                    if input.KeyCode == Enum.KeyCode.LeftShift then
                        player.Character.Humanoid.WalkSpeed = 16        
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
            end)

            local uziButton = window:Button("Buy Uzi", function()
                if game.PlaceId == 4669040 then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Teleport Failed]";
                        Text = "You're in the prison!";
                    })
                else
                    player.Character:MoveTo(workspace["Uzi | $150"].Head.Position)
                end
            end)
            
            local glockButton = window:Button("Buy Glock", function()
                if game.PlaceId == 4669040 then
                    game:GetService("StarterGui"):SetCore("SendNotification", {
                        Title = "[Teleport Failed]";
                        Text = "You're in the prison!";
                    })
                else
                    player.Character:MoveTo(workspace["Glock | $200"].Head.Position)
                end
            end)

            local antiKnock = window:Toggle("Antiknock", {flag = "antiknock"}, function(value)
                if value then
                    if not self.antiKnock then
                        self.antiKnock = player.Character.Humanoid.StateChanged:Connect(function(antifunction)
                            repeat
                                wait()
                                if antifunction == Enum.HumanoidStateType.FallingDown or antifunction == Enum.HumanoidStateType.RunningNoPhysics then
                                    player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.PlatformStanding and Enum.HumanoidStateType.GettingUp)
                                end
                            until not value
                        end)
                    end
                else
                    self.antiKnock = self.antiKnock:Disconnect()
                end
            end)
        end
    end
    
    hub:OpenGame(game.PlaceId)
    hub:OpenGame(0)
end
 
