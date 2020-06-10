local HttpService = game:GetService("HttpService")

local loginDetails = {
    username = "username",
    password = "password"
}

--loadstring(game:HttpPostAsync('https://mobyhub-pipeline.glitch.me/script', HttpService:JSONEncode(loginDetails), "application/json"))()
loadstring(game:GetAsync('https://mobyhub-pipeline.glitch.me/script/' .. loginDetails.username .. "/" .. loginDetails.password, true))() 
