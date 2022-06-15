--//double execute

assert(not getgenv().DoubleExecuteLog,"The script was already executed.")
getgenv().DoubleExecuteLog = true


--//game-load

if not game:IsLoaded() then
    game.Loaded:Wait()
end


--//services 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")


--//variables

local Player = Players.LocalPlayer
local GUI = Player:WaitForChild("PlayerGui")

local MenuEvent = ReplicatedStorage:WaitForChild("Requests"):WaitForChild("ReturnToMenu")


--//main-code

UIS.InputEnded:Connect(function(Input,IsWriting)
    if not IsWriting and getgenv().Enabled and Input.KeyCode == getgenv().Key and not GUI:FindFirstChild("ChoicePrompt") and not GUI:WaitForChild("StatsGui",5):FindFirstChild("Danger") then
        MenuEvent:FireServer()
        GUI:WaitForChild("ChoicePrompt",5):WaitForChild("Choice",5):FireServer(true)
    end
end)
