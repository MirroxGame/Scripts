repeat wait() until game:IsLoaded()

--//checks

assert(hookmetamethod,"Your executor doesn't support this script. (hookmetamethod function)")

--//services

local plrs = game:GetService("Players")
local cs = game:GetService("CollectionService")

--//variables

local plr = plrs.LocalPlayer
local map = workspace:WaitForChild("Map")

--//main code

--//paint on any thing

for _,v in pairs(map:GetChildren()) do
  if cs:HasTag(v,"PaintRaycast") then continue end
  cs:AddTag(v,"PaintRaycast")
end

--//unlock gamepass and raycast changing

local old
old = hookmetamethod(game,"__namecall",newcclosure(function(...)

  local args = {...}
  local _method = getnamecallmethod()
  local _script = getcallingscript()

  if not checkcaller() and _method == "UserOwnsGamePassAsync" and args[3] == 26494268 then
    return true
  end

  if not checkcaller() and tostring(_script.Parent) == "SprayPaint" and _method == "Raycast" and tostring(args[1]) == "Workspace" then
    args[3] = args[3] * 20000
    return old(table.unpack(args))
  end

  return old(...)
end))

--//bypass magnitude

local old2
old2 = hookmetamethod(Vector3.zero,"__index",newcclosure(function(t,i)

  local _script = getcallingscript()

  if tostring(_script.Parent) == "SprayPaint" and i == "Magnitude" then
    return 1
  end

  return old2(t,i)

end),false)

print("Script was executed, credits: Stup#2746, Mirrox#1307\nScript unlocks: layers gamepass, spray distance")
