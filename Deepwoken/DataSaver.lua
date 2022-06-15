--//game-load

if not game:IsLoaded() then
    game.Loaded:Wait()
end


--//services

local Players = game:GetService("Players")


--//variables

local plr = Players.LocalPlayer

local folder = workspace:WaitForChild("Thrown")

local params = {}
local paramsToCheck = {"Color","Material","ClassName","MeshId"}
local ifContain = {"Training","Mantra","Talent","NoStack"}
local FileName = "DataAboutItems.json"


--//preparation

loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/MirroxGame/Tools/main/settings/settings.lua'))()

local ExistingFile = pcall(readfile, FileName)

if not ExistingFile then
    Set(FileName,params)
else
    params = Load(FileName)
end


--//functions

local function checkStatus(v)
    local isTrue = true
    for _,stat in pairs(ifContain) do
        if v:FindFirstChild(stat) then
            isTrue = false
            break
        end
    end
    return isTrue
end


local function backpackCheck(v)
    if v:IsA("Tool") and v:FindFirstChild("Handle") and not table.find(params,v.Name) and checkStatus(v) then
            
        params[v.Name:match("[^$]+")] = {}
        
        for _,param in pairs(paramsToCheck) do
            
            if pcall(function() return v.Handle[param] end) then
                params[v.Name:match("[^$]+")][param] = tostring(v.Handle[param])
                
            end
        end
        
        Update(FileName,params)
    end
end


--//main-code

for _,v in pairs(plr:WaitForChild("Backpack"):GetChildren()) do
    backpackCheck(v)
end

plr:WaitForChild("Backpack").ChildAdded:Connect(backpackCheck)

plr.ChildAdded:Connect(function(obj)
    if obj:IsA("Backpack") or v.Name == "Backpack" then
        
        for _,v in pairs(obj:GetChildren()) do
            backpackCheck(v)
        end
            
        obj.ChildAdded:Connect(backpackCheck)
    end
end)
