--//game-load

if not game:IsLoaded() then
    game.Loaded:Wait()
end


--//double execute

assert(not getgenv().DoubleExecuteMumur,"The script was already executed.")
getgenv().DoubleExecuteMumur = true


--//services

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")


--//variables

local Player = Players.LocalPlayer

local Names = {
    ["Ardour"] = "Talent:Murmur: Ardour",
    ["Tacet"] = "Talent:Murmur: Tacet"
    
}


--//functions

local function GetChar(Object,WaitForPart)
    local Character = Player.Character or Player.CharacterAdded:Wait()
    if Object then
        return Character:FindFirstChild(Object) or WaitForPart and Character:WaitForChild(Object,2)
    end
    
    return Character
end

local function GetWeapon()
    local Humanoid = GetChar("Humanoid",true)
    local Hand = GetChar("RightHand",true)
    
    local Backpack = Player:WaitForChild("Backpack")
    
    if Backpack:FindFirstChild("Weapon") then
        Humanoid:EquipTool(Backpack:FindFirstChild("Weapon"))
    end
    
    local Weapon = Hand:WaitForChild("HandWeapon",5)
    
    if not Weapon then
        GetWeapon()
        return
    end
    
    return Weapon
end

local function GetEtherState()
    local Ether = GetChar("Ether",true)
    if not Ether then GetEtherState() return false end
    return Ether.Value == Ether.MaxValue
end

local function MumurType()
    local Backpack = Player:WaitForChild("Backpack")
    local RequestsFolder = GetChar("CharacterHandler",true):WaitForChild("Requests")
    
    for EventName,Mumur in pairs(Names) do
        if Backpack:FindFirstChild(Mumur) then
            local Event = RequestsFolder:WaitForChild(EventName)
            return EventName,Event
        end
    end
    
    return false
end

local function DetectActivation()
    local MumurName,MumurEvent = MumurType()
    
    
    if MumurName == "Ardour" then
        local Weapon = GetWeapon()
        
        if Weapon:FindFirstChild("ArdourPartic") then
            return true
        end
        return false
    end
end

local function Main()
    if GetEtherState() and not DetectActivation() then
        local _,MumurEvent = MumurType()
        MumurEvent:FireServer()
    end
end


--//mumur checking

local OwnedMumur,_ = MumurType()
assert(OwnedMumur,"You don't have a mumur.")


--//anti afk

Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)


--//main

while true do
    if getgenv().Active then
        wait(.5)
        Main()
    else
        getgenv().DoubleExecuteMumur = false
        break
    end
end
