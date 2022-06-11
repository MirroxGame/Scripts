--//settings

getgenv().ShowItems = true
getgenv().Sort = {"Dark Feather","Void Feather","Umbral Obsidian"}
getgenv().ItemsSort = true
getgenv().ChestShowType = "Closed" -- "Opened" or "Closed" or "All"
getgenv().ShowChests = true


--//game-load

if not game:IsLoaded() then
    game.Loaded:Wait()
end


--//double execute

assert(not getgenv().DoubleExecute,"The script was already executed.")
getgenv().DoubleExecute = true


--//variables

local Thrown = workspace:WaitForChild("Thrown")

local Data = {}

local FileName = "DataAboutItems.json"


--initialization

loadstring(game:HttpGet("https://raw.githubusercontent.com/MirroxGame/Tools/main/settings/settings.lua"))()

local ExistingFile = pcall(readfile, FileName)

if not ExistingFile then
    Set(FileName,Data)
else
    Data = Load(FileName)
end


local EspModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/misanthropic2005/DaHood/main/library(s)/KiriotEsp.lua"))()

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
        
        if isFound and (table.find(getgenv().Sort,LootName) and getgenv().ItemsSort or not getgenv().ItemsSort) then
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
        end
        
    end
end


--//main-code

for _,Object in pairs(Thrown:GetChildren()) do
    spawn(function()
        CheckObject(Object)
    end)
end

Thrown.DescendantAdded:Connect(CheckObject)

EspModule:Toggle(true)