--//double execute

assert(not getgenv().DoubleExecute,"The script was already executed")
getgenv().DoubleExecute = true


--//game status

if not game:IsLoaded() then
    game.Loaded:Wait()
end


--//functions check

for i,v in pairs({["getgenv"] = getgenv, ["firetouchinterest"] = firetouchinterest}) do
    assert(v,("Your exploit does not support %s function."):format(i))
end


--//services

local plrs = game:GetService("Players")
local run = game:GetService("RunService")
local core = game:GetService("CoreGui")
local tp = game:GetService("TeleportService")


--//variables

local plr = plrs.LocalPlayer
local bodyVelocity = nil

_G.Connections = {}


--//functions

local function getChar(part,isWait)
    local char = plr.Character or plr.CharacterAppearanceLoaded:Wait()
    
    if part then
        return char:FindFirstChild(part) or isWait and char:WaitForChild(part)
    end
    return char
end

local function autoFarm(v)
    if table.find(getgenv().Settings.ItemsName,v.Name) then
        getChar():SetPrimaryPartCFrame(CFrame.new(v.Position) * CFrame.new(0,-10,0))
        wait(getgenv().Settings.WaitTime)
        for i = 0,1 do
            firetouchinterest(v,getChar("HumanoidRootPart",true),i)
        end
    end
end


--//noclip

_G.Connections["NoclipConnection"] = run.Stepped:Connect(function()
    if getgenv().Settings.AutoFarm then
        
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity",getChar("HumanoidRootPart",true))
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            bodyVelocity.P = math.huge
        end
        
        for _,v in pairs(getChar():GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
        
    elseif bodyVelocity then
        bodyVelocity:Destroy()
        getgenv().DoubleExecute = false
        for _,v in pairs(_G.Connections) do
            v:Disconnect()
        end
    end
end)


--//auto-rejoin (Credits to Alpenidze just i am lazy to type it)

if getgenv().Settings.autoRejoinOnKick then
    _G.Connections["AutoRejoin"] = core.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
        if child.Name == "ErrorPrompt" and child:FindFirstChild('MessageArea') and child.MessageArea:FindFirstChild("ErrorFrame") then
            tp:Teleport(game.PlaceId)
        end
    end)
end


--//autofarm

for _,v in pairs(workspace:GetChildren()) do
    autoFarm(v)
end

_G.Connections["AutoFarm"] = workspace.ChildAdded:Connect(autoFarm)
