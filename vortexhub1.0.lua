-- Alfie T Script
-- Features: Fly, NoClip
-- UI: Rayfield

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua'))()

local Window = Rayfield:CreateWindow({
    Name = "Alfie T Script",
    LoadingTitle = "Alfie T Script",
    LoadingSubtitle = "by Sizzle",
    ConfigurationSaving = {Enabled = true, FolderName = "AlfieTScript", FileName = "Config"},
    Discord = {Enabled = false}
})

local MainTab = Window:CreateTab("Main")

-- Variables
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character, Humanoid, RootPart
local Connections = {}
local Flying, NoClip = false, false
local FlySpeed = 16

-- Update character references
local function UpdateCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end
UpdateCharacter()
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

-- NoClip Function
local function SetNoClip(state)
    NoClip = state
    if NoClip then
        Connections.NoClip = RunService.Stepped:Connect(function()
            if RootPart then
                for _, part in ipairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if Connections.NoClip then Connections.NoClip:Disconnect() end
        NoClip = false
    end
end

-- Fly Function
local function SetFly(state)
    Flying = state
    if Flying then
        Humanoid:SetAttribute("OriginalPlatformStand", Humanoid.PlatformStanding)
        Humanoid.PlatformStanding = true
        SetNoClip(true)
        Connections.Fly = RunService.RenderStepped:Connect(function()
            if not RootPart then return end
            local camCF = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.yAxis end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.yAxis end
            moveDir = moveDir.Unit * FlySpeed
            RootPart.Velocity = moveDir
        end)
    else
        if Connections.Fly then Connections.Fly:Disconnect() end
        Humanoid.PlatformStanding = Humanoid:GetAttribute("OriginalPlatformStand") or false
        if not NoClip then SetNoClip(false) end
    end
end

-- UI Elements
MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(Value) SetFly(Value) end
})

MainTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Callback = function(Value) SetNoClip(Value) end
})

MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {8, 120},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value) FlySpeed = Value end
})

Rayfield:Notify({
    Title = "Alfie T Script Loaded",
    Content = "Script ready",
    Duration = 3
})
