local HttpService = game:GetService("HttpService")

local username, password = "moby", "testAccount"

local uri = 'https://mobyhub-pipeline.glitch.me/script/' .. username .. "/" .. password
local res = game:HttpGet(uri, true)
local isJson, jsonDecoded = pcall(HttpService.JSONDecode, HttpService, res)

if isJson then
	warn("Error:", jsonDecoded.message)
else
	print("Successfully ran script!")
	loadstring(res)()
end
