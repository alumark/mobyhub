local HttpService = game:GetService("HttpService")

local GUI_NAME = "mobyhub login"

local gui = game.CoreGui:FindFirstChild(GUI_NAME)
if gui then
	gui:Destroy()
end

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Login = Instance.new("TextButton")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local Username = Instance.new("TextBox")
local Password = Instance.new("TextBox")
local Title = Instance.new("TextLabel")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local Error = Instance.new("TextLabel")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

--[[
	Properties:
--]]

local exists, data = pcall(readfile, "mobyhub.data")

local CHARACTER_SEPERATOR = "\n"

local savedUsername, savedPassword
if exists then
	local usernameEnd, passwordBegin = data:find(CHARACTER_SEPERATOR)

	savedUsername = data:sub(1, usernameEnd - CHARACTER_SEPERATOR:len())
	savedUsername = savedUsername:gsub(" ", "")
	savedUsername = savedUsername:gsub("\n", "")
	savedPassword = data:sub(passwordBegin + CHARACTER_SEPERATOR:len())
end

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = GUI_NAME
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.new(1, 1, 1)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0.5, 0, 0.75, 0)
Frame.Style = Enum.FrameStyle.RobloxRound

Login.Name = "Login"
Login.Parent = Frame
Login.AnchorPoint = Vector2.new(0.5, 0.5)
Login.BackgroundColor3 = Color3.new(1, 1, 1)
Login.BorderSizePixel = 0
Login.Position = UDim2.new(0.5, 0, 0.75, 0)
Login.Size = UDim2.new(0.400000006, 0, 0.100000001, 0)
Login.Style = Enum.ButtonStyle.RobloxRoundDropdownButton
Login.Font = Enum.Font.GothamBold
Login.Text = "LOGIN"
Login.TextColor3 = Color3.new(0, 0, 0)
Login.TextScaled = true
Login.TextSize = 14
Login.TextWrapped = true

UITextSizeConstraint.Parent = Login
UITextSizeConstraint.MaxTextSize = 16

Username.Name = "Username"
Username.Parent = Frame
Username.AnchorPoint = Vector2.new(0.5, 0)
Username.BackgroundColor3 = Color3.new(1, 1, 1)
Username.BorderSizePixel = 0
Username.Position = UDim2.new(0.5, 0, 0.349999994, 0)
Username.Size = UDim2.new(0.5, 0, 0.100000001, 0)
Username.ClearTextOnFocus = false
Username.Font = Enum.Font.GothamSemibold
Username.PlaceholderColor3 = Color3.new(0.0392157, 0.0392157, 0.0392157)
Username.PlaceholderText = "Username"
Username.Text = savedUsername or ""
Username.TextColor3 = Color3.new(0, 0, 0)
Username.TextSize = 14

Password.Name = "Password"
Password.Parent = Frame
Password.AnchorPoint = Vector2.new(0.5, 0)
Password.BackgroundColor3 = Color3.new(1, 1, 1)
Password.BorderSizePixel = 0
Password.Position = UDim2.new(0.5, 0, 0.5, 0)
Password.Size = UDim2.new(0.5, 0, 0.100000001, 0)
Password.ClearTextOnFocus = false
Password.Font = Enum.Font.GothamSemibold
Password.PlaceholderColor3 = Color3.new(0.0392157, 0.0392157, 0.0392157)
Password.PlaceholderText = "Password"
Password.Text = savedPassword or ""
Password.TextColor3 = Color3.new(0, 0, 0)
Password.TextSize = 14

Title.Name = "Title"
Title.Parent = Frame
Title.AnchorPoint = Vector2.new(0.5, 0.5)
Title.BackgroundColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0.5, 0, 0.174999997, 0)
Title.Size = UDim2.new(1, 0, 0.300000012, 0)
Title.Font = Enum.Font.Gotham
Title.Text = "mobyhub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.TextSize = 14
Title.TextWrapped = true

UITextSizeConstraint_2.Parent = Title
UITextSizeConstraint_2.MaxTextSize = 40

Error.Name = "Error"
Error.Parent = Frame
Error.AnchorPoint = Vector2.new(0.5, 1)
Error.BackgroundColor3 = Color3.new(1, 1, 1)
Error.BackgroundTransparency = 1
Error.Position = UDim2.new(0.5, 0, 0.949999988, 0)
Error.Size = UDim2.new(0.800000012, 0, 0.125, 0)
Error.Font = Enum.Font.Gotham
Error.Text = ""
Error.TextColor3 = Color3.new(1, 1, 1)
Error.TextScaled = true
Error.TextSize = 14
Error.TextWrapped = true

UITextSizeConstraint_3.Parent = Error
UITextSizeConstraint_3.MaxTextSize = 20

local conn
conn = Login.Activated:Connect(function()
	local username, password = Username.Text, Password.Text

	local uri = 'https://mobyhub.herokuapp.com/api/users/script/' .. username .. "/" .. password
	local res = game:HttpGet(uri, true)
	local isJson, jsonDecoded = pcall(HttpService.JSONDecode, HttpService, res)

	if isJson then
		Error.TextColor3 = Color3.new(1, 0, 0)
		Error.Text = jsonDecoded.message
	else
		local success, func = pcall(loadstring, res)
		if success and func then
    		Error.TextColor3 = Color3.new(1, 1, 1)
    		Error.Text = "Successfully ran script! (Closing in 5 seconds)"
    
    		local success = pcall(writefile, "mobyhub.data", username .. "\n" .. password)
    		if success then
    			print("Successfully saved file!")
    		else
    			print("Failed to save data.")
    		end
    
    		conn:Disconnect()
    		
    		local localtimer = 5
    		while localtimer > 0 do
    			wait(1)
    			localtimer = localtimer - 1
    			Error.Text = "Successfully ran script! (Closing in " .. localtimer .. " seconds)"
    		end
    
    		ScreenGui:Destroy()
        else
            Error.TextColor3 = Color3.new(1, 0, 0)
            Error.Text = "An error occurred when creating function.  This is most likely due to a syntax error on the creator's part."
		end
    end
end)
