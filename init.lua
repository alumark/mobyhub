
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

            local window = Library:Window("The Streets")
            window:Section("Bypass")
            window:Button("Anti-Cheat Bypass", function()
                loadstring([[ 
                    print("enabling bypass")

                    local mt = getrawmetatable(game)
                    local newcclosure = hide_me or newcclosure
                    local checkcaller = checkcaller or is_protosmasher_caller or Cer.isCerus
                    local mt_namecall, mt_newindex = mt.__namecall, mt.__index, mt.__newindex
                    if setreadonly then
                        setreadonly(mt, false)
                    elseif make_writable then
                        make_writable(mt)
                    end

                    mt.__newindex = newcclosure(function(self, index value)
                        if not checkcaller() then
                            if self:IsA("Humanoid") then
                                game:GetService('StarterGui'):SetCore('ResetButtonCallback', true)
                                if index == "WalkSpeed" then
                                    return
                                elseif index == "Health" or index == "JumpPower" or index == "HipHeight" then
                                    return
                                end

                                if index == "CFrame" and self.Name == "HumanoidRootPart" or self.Name == "Torso" then
                                    return
                                end
                            end
                        end

                        return mt_newindex(self, index, value)
                    end)

                    mt.__namecall = newcclosure(function(self, ...)
                        local args = {...}
                        if not checkcaller() then
                            if getnamecallmethod() == "Destroy" and self:IsA("BodyMover") then
                                return fuckyou(self, ...)
                            end

                            if getnamecallmethod() and self.Name == game.Players.LocalPlayer.Character.Name then
                                return fuckyou(self, ...)
                            end

                            if getnamecallmethod() == "FireServer" then
                                if self.Name == "lIII" or self.Parent:IsDescendantOf("ReplicatedStorage") then
                                    return wait(9e9)
                                end

                                if args[1] == "hey" then
                                    return wait(9e9)
                                end
                            end
                        end

                        return mt_namecall(self, unpack(args))
                    end)
                ]])()

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
                slider:Set(old)
            end)
        end
    end
    
    hub:OpenGame(game.PlaceId)
    hub:OpenGame(0)
end
 
