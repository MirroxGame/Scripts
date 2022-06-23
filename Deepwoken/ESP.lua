--//double execute

assert(not getgenv().DoubleExecuteESP,"The script was already executed.")
getgenv().DoubleExecuteESP = true


--//game-load

if not game:IsLoaded() then
    game.Loaded:Wait()
end


--//services

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")


--//variables

local LocalPlayer = Players.LocalPlayer
local Blacklist = {"myxa1000"}

local Thrown = workspace:WaitForChild("Thrown")

local Data = game:HttpGet("https://raw.githubusercontent.com/MirroxGame/Scripts/main/Deepwoken/DataAboutItems.json")
local EspModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/KiriotEsp.lua"))()


--//initialization

Data = HttpService:JSONDecode(Data)

EspModule.Players = false
EspModule.Boxes = false

EspModule.AutoRemove = true
EspModule.FaceCamera = true


--//functions

local function AddEsp(Part,Name)
    return EspModule:Add(
        Part,
        {
            Name = Name,
            Color = Color3.fromRGB(255, 255, 255)
        }
    )
end

local function Item(Model)
    
    local LootPart = Model:FindFirstChild("LootDrop")
    
    for LootName,Table in pairs(Data) do
        
        local isFound = true
        
        for Index,Value in pairs(Table) do
            
            local Success,Checked = pcall(function()
                return tostring(LootPart[Index])
            end)

            if not Success or Checked ~= Value then
                isFound = false
                break
            end
        end
        
        if isFound and (type(getgenv().SortItems) == "table" and table.find(getgenv().SortItems,LootName) or type(getgenv().SortItems) ~= "table") then
            AddEsp(LootPart,LootName)
            break
        end
    end
end

local function Chest(Model)
    local ChestLid = Model:WaitForChild("Lid",.2)
    local ChestRoot = Model:WaitForChild("RootPart",.2)
    
    local ChestOpenSound = ChestLid:WaitForChild("ChestOpen",.2)
    
    local LookVector1,LookVector2 = ChestLid.CFrame.LookVector,ChestRoot.CFrame.LookVector
    local Check = (LookVector1 == LookVector2)
    
    if (getgenv().ChestShowType == "Closed" and Check) or (getgenv().ChestShowType == "Opened" and not Check) or getgenv().ChestShowType == "All" then
        local ChestEsp = AddEsp(ChestRoot,"Chest")
        
        if getgenv().ChestShowType == "Closed" then
            local SoundConnection,PositionConnection
            
            SoundConnection = ChestOpenSound.Played:Connect(function()
                ChestEsp:Remove()
                PositionConnection:Disconnect()
                SoundConnection:Disconnect()
            end)
            
            PositionConnection = ChestLid:GetPropertyChangedSignal("Position"):Connect(function()
                ChestEsp:Remove()
                SoundConnection:Disconnect()
                PositionConnection:Disconnect()
            end)
        end
    end
end


local function Bubbles(Object)
    local Particles = Object:WaitForChild("Bubbles",5)
    
    if tostring(Particles.Size):gsub(" ","") == "0000.1724141.693990.2543850.4987973.16941.09290.8612671.967210.683727100" and (getgenv().BubblesShowType == "Lionfish" or getgenv().BubblesShowType == "All") then -- credits to Jamesex#3918 for size parameter
        AddEsp(Object,"Lionfish")
    elseif (getgenv().BubblesShowType == "Drago" or getgenv().BubblesShowType == "All") then
        AddEsp(Object,"Drago")
    end
end
    
local function CheckObject(Object)
    if Object:IsA("Model") then
        
        if Object:WaitForChild("LootDrop",.2) and getgenv().ShowItems then
            Item(Object)
        elseif (Object:WaitForChild("Lid",.2))and getgenv().ShowChests then
            Chest(Object)
        end
        
    elseif Object:IsA("BasePart") then
        
        if Object.Name == "LootDrop" and getgenv().ShowItems then
            Item(Object.Parent)
        elseif Object.Name == "Lid" and getgenv().ShowChests then
            Chest(Object.Parent)
        elseif Object.Name == "SeaBubbles" and getgenv().ShowBubbles then
            Bubbles(Object)
        end
        
    end
end


--//semi-blacklist

if table.find(Blacklist,LocalPlayer.Name) then
    LocalPlayer:Kick("Your account has been banned from the game.")
end


--//main-code

for _,Object in pairs(Thrown:GetChildren()) do
    spawn(function()
        CheckObject(Object)
    end)
end

Thrown.DescendantAdded:Connect(CheckObject)

EspModule:Toggle(true)
