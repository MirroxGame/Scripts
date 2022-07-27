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
local Cooldown = false

--//main-code

UIS.InputEnded:Connect(function(Input,IsWriting)
    if not IsWriting and getgenv().Enabled and Input.KeyCode == getgenv().Key and not Cooldown and not GUI:FindFirstChild("ChoicePrompt") and not GUI:WaitForChild("StatsGui"):WaitForChild("Danger").Visible then
        Cooldown = true
        MenuEvent:FireServer()
        GUI:WaitForChild("ChoicePrompt"):WaitForChild("Choice"):FireServer(true)
        Cooldown = false
    end
end)
