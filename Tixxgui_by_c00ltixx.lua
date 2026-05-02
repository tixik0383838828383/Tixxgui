local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Helper functions
local function getChar()
    return player.Character
end

local function getHumanoid()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local c = getChar()
    return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart)
end

local function findPlayer(name)
    name = name:lower()
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name:lower():find(name) then
            return p
        end
    end
    return nil
end

local function getTorso()
    local char = getChar()
    if char then
        return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    end
    return nil
end

local function hasWeapon()
    local function checkContainer(container)
        if not container then return false end
        for _, item in pairs(container:GetChildren()) do
            if item:IsA("Tool") then
                local n = item.Name:lower()
                if n:find("sword") or n:find("gun") or n:find("knife") or n:find("blade") or n:find("pistol") then
                    return true
                end
            end
        end
        return false
    end
    return checkContainer(player.Backpack) or checkContainer(getChar())
end

local function showPlayerList(titleText, callback)
    local listFrame = Instance.new("Frame")
    listFrame.Name = "PlayerList"
    listFrame.Parent = screenGui
    listFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    listFrame.BorderColor3 = Color3.fromRGB(255, 170, 0)
    listFrame.BorderSizePixel = 2
    listFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
    listFrame.Size = UDim2.new(0,200,0,300)
    listFrame.Active = true
    listFrame.Draggable = true

    local title = Instance.new("TextLabel")
    title.Parent = listFrame
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0,0,0,0)
    title.Size = UDim2.new(1,0,0,30)
    title.Font = Enum.Font.SourceSansBold
    title.Text = titleText
    title.TextColor3 = Color3.new(1,1,1)
    title.TextSize = 16

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = listFrame
    scroll.BackgroundTransparency = 1
    scroll.Position = UDim2.new(0,0,0,30)
    scroll.Size = UDim2.new(1,0,1,-60)
    scroll.CanvasSize = UDim2.new(0,0,0,0)
    scroll.ScrollBarThickness = 6

    local layout = Instance.new("UIListLayout")
    layout.Parent = scroll
    layout.Padding = UDim.new(0,5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton")
            btn.Parent = scroll
            btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
            btn.BorderColor3 = Color3.fromRGB(255, 170, 0)
            btn.Size = UDim2.new(1,-10,0,30)
            btn.Font = Enum.Font.SourceSans
            btn.Text = p.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextSize = 14

            btn.MouseButton1Click:Connect(function()
                listFrame:Destroy()
                callback(p)
            end)

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70,70,70)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
            end)
        end
    end
    scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = listFrame
    closeBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    closeBtn.BorderColor3 = Color3.fromRGB(255, 170, 0)
    closeBtn.Position = UDim2.new(0,10,1,-25)
    closeBtn.Size = UDim2.new(1,-20,0,20)
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.Text = "Close"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.TextSize = 14
    closeBtn.MouseButton1Click:Connect(function()
        listFrame:Destroy()
    end)
end

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "tixxgui"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderColor3 = Color3.fromRGB(255, 170, 0)
mainFrame.BorderSizePixel = 2
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.Size = UDim2.new(0, 300, 0, 230)
mainFrame.Active = true
mainFrame.Draggable = true

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Text = "tixxgui V2 by c00ltixx"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18

local commandBar = Instance.new("TextBox")
commandBar.Name = "CommandBar"
commandBar.Parent = mainFrame
commandBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
commandBar.BorderColor3 = Color3.fromRGB(255, 170, 0)
commandBar.BorderSizePixel = 1
commandBar.Position = UDim2.new(0, 10, 0, 200)
commandBar.Size = UDim2.new(1, -20, 0, 20)
commandBar.Font = Enum.Font.SourceSans
commandBar.Text = "Enter command (e.g., goto player)"
commandBar.TextColor3 = Color3.fromRGB(255, 255, 255)
commandBar.TextSize = 14
commandBar.ClearTextOnFocus = true

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Parent = mainFrame
scrollFrame.BackgroundTransparency = 1
scrollFrame.Position = UDim2.new(0, 0, 0, 30)
scrollFrame.Size = UDim2.new(1, 0, 0, 160)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
scrollFrame.ScrollBarThickness = 8

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = scrollFrame
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

function createButton(name, callback, layoutOrder)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = scrollFrame
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderColor3 = Color3.fromRGB(255, 170, 0)
    button.BorderSizePixel = 1
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Font = Enum.Font.SourceSans
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.LayoutOrder = layoutOrder or 0

    button.MouseButton1Click:Connect(callback)

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)

    return button
end

-- Fly variables
local flying = false
local flyConnection
local flySpeed = 50
local bodyVelocity, bodyGyro

-- Noclip
local noclip = false
local noclipConnection

-- Spin
local spinning = false
local spinSpeed = 10
local bodyAngularVel

-- View
local viewing = false
local originalCameraSubject

-- Infjump
local infjump = false
local infjumpConnection

-- Nofall
local nofall = false
local nofallConnection

-- Loop commands tables
local loopkills = {}
local loopflings = {}

-- Jail tables
local jails = {}

-- Xray
local xray = false
local originalTransparencies = {}

-- ESP
local esp = false
local espHighlights = {}

-- ClickTP
local clicktp = false
local clicktpConnection

-- NoGrav
local nograv = false
local nogravBodyForce

-- Invis
local isInvisible = false
local invisPosition = Vector3.new(-25.95, 84, 3537.55)

-- Music
local musicPlaying = false
local musicSound

-- Command list
local commandsList = {
    "goto [player] or tp [player]: Teleports to the specified player.",
    "speed [number]: Sets your walk speed.",
    "jump [number]: Sets your jump power.",
    "kill [player]: Kills the specified player.",
    "respawn: Respawns your character.",
    "noclip or clip: Toggles noclip mode.",
    "fly [speed]: Toggles fly mode (WASD, Space/Shift for height).",
    "to [x] [y] [z]: Teleports to specific coordinates.",
    "bring [player]: Brings the specified player to you.",
    "fling [player]: Flings the specified player (powerful).",
    "god: Sets your health to infinite.",
    "ungod: Resets your health to normal.",
    "invis: Makes you invisible.",
    "uninvis: Makes you visible again.",
    "grav [number]: Sets workspace gravity.",
    "ungrav: Resets gravity to default.",
    "spin [speed]: Spins your character at optional speed (default 10).",
    "unspin: Stops spinning.",
    "view [player]: Views the specified player (changes camera subject).",
    "unview: Resets camera to your character.",
    "explode [player]: Creates an explosion at the player (or self if no arg).",
    "fire [player]: Adds fire effect to the player (or self).",
    "unfire [player]: Removes fire effect from the player (or self).",
    "infjump: Toggles infinite jump (jump in air).",
    "nofall: Toggles no fall damage.",
    "loopkill [player]: Loops killing the specified player (requires weapon).",
    "unloopkill [player]: Stops loop killing the player.",
    "loopfling [player]: Loops flinging the specified player.",
    "unloopfling [player]: Stops loop flinging the player.",
    "jail [player]: Jails the specified player in a part.",
    "unjail [player]: Removes the jail from the player.",
    "btools: Gives classic building tools.",
    "serverhop or hop: Teleports to a new server.",
    "rejoin: Rejoins the same server.",
    "time [time]: Sets Lighting.TimeOfDay (0-24).",
    "day: Sets time to day (12).",
    "night: Sets time to night (0).",
    "fog [end]: Sets Lighting.FogEnd.",
    "nofog: Sets FogEnd to infinity.",
    "xray: Makes all workspace parts transparent.",
    "unxray: Restores original transparencies.",
    "dex: Loads Dex explorer GUI.",
    "esp: Toggles ESP highlights on all players.",
    "clicktp: Toggles click to teleport.",
    "nograv: Toggles no gravity for player.",
    "playmusic: Plays c00ltixx theme (Spooky Scary Skeletons).",
    "stopmusic: Stops the music.",
    "freeze [player]: Freezes the player.",
    "unfreeze [player]: Unfreezes the player.",
    "dance [player]: Makes the player dance.",
    "cmds or help: Opens the command list GUI."
}

-- Command handler
local function handleCommand(input)
    local args = input:lower():split(" ")
    local command = args[1]
    table.remove(args, 1)

    if (command == "goto" or command == "tp") and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hrp = getHRP()
            if targetHRP and hrp then
                hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(3, 0, 3))
            end
        end
    elseif command == "speed" and args[1] then
        local humanoid = getHumanoid()
        if humanoid then
            local speed = tonumber(args[1])
            if speed then humanoid.WalkSpeed = speed end
        end
    elseif command == "jump" and args[1] then
        local humanoid = getHumanoid()
        if humanoid then
            local jumpPower = tonumber(args[1])
            if jumpPower then humanoid.JumpPower = jumpPower end
        end
    elseif command == "kill" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if targetHumanoid then targetHumanoid.Health = 0 end
        end
    elseif command == "respawn" then
        player:LoadCharacter()
    elseif command == "noclip" or command == "clip" then
        noclip = not noclip
        local char = getChar()
        if not char then return end
        if noclip then
            noclipConnection = RunService.Stepped:Connect(function()
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end)
        else
            if noclipConnection then noclipConnection:Disconnect() end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    elseif command == "fly" then
        local newSpeed = args[1] and tonumber(args[1])
        if newSpeed then flySpeed = newSpeed end
        flying = not flying
        local humanoid = getHumanoid()
        local hrp = getHRP()
        if not hrp or not humanoid then return end
        humanoid.PlatformStand = flying
        if flying then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = hrp

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 10000
            bodyGyro.D = 1000
            bodyGyro.CFrame = hrp.CFrame
            bodyGyro.Parent = hrp

            flyConnection = RunService.Heartbeat:Connect(function()
                if not flying then return end
                local cam = workspace.CurrentCamera
                bodyGyro.CFrame = cam.CFrame

                local moveVector = Vector3.zero
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector -= Vector3.new(0, 1, 0) end

                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit * flySpeed
                end
                bodyVelocity.Velocity = moveVector
            end)
        else
            if flyConnection then flyConnection:Disconnect() end
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
            humanoid.PlatformStand = false
        end
    elseif command == "to" and args[1] and args[2] and args[3] then
        local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if x and y and z then
            local hrp = getHRP()
            if hrp then hrp.CFrame = CFrame.new(Vector3.new(x, y, z)) end
        end
    elseif command == "bring" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hrp = getHRP()
            if targetHRP and hrp then
                targetHRP.CFrame = CFrame.new(hrp.Position + Vector3.new(3, 0, 3))
            end
        end
    elseif command == "fling" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local bv = Instance.new("BodyVelocity")
                bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
                bv.Velocity = Vector3.new(math.random(-500, 500), 10000, math.random(-500, 500))
                bv.Parent = targetHRP
                Debris:AddItem(bv, 1.5)
            end
        end
    elseif command == "god" then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    elseif command == "ungod" then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    elseif command == "invis" then
        if isInvisible then return end
        isInvisible = true
        local char = getChar()
        if not char then return end
        local hrp = getHRP()
        if not hrp then return end
        local savedCFrame = hrp.CFrame
        char:MoveTo(invisPosition)
        task.wait(0.15)
        local seat = Instance.new("Seat")
        seat.Name = "invischair"
        seat.Anchored = false
        seat.CanCollide = false
        seat.Transparency = 1
        seat.Position = invisPosition
        seat.Parent = workspace
        local weld = Instance.new("Weld")
        weld.Part0 = seat
        weld.Part1 = getTorso()
        weld.Parent = seat
        task.wait()
        seat.CFrame = savedCFrame
        for _, descendant in char:GetDescendants() do
            if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                descendant.Transparency = 0.5
            end
        end
    elseif command == "uninvis" then
        if not isInvisible then return end
        isInvisible = false
        local invisChair = workspace:FindFirstChild("invischair")
        if invisChair then invisChair:Destroy() end
        local char = getChar()
        if char then
            for _, descendant in char:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.Transparency = 0
                end
            end
        end
    elseif command == "grav" and args[1] then
        local grav = tonumber(args[1])
        if grav then workspace.Gravity = grav end
    elseif command == "ungrav" then
        workspace.Gravity = 196.2
    elseif command == "spin" then
        local newSpeed = args[1] and tonumber(args[1])
        if newSpeed then spinSpeed = newSpeed end
        spinning = true
        local hrp = getHRP()
        if hrp then
            bodyAngularVel = Instance.new("BodyAngularVelocity")
            bodyAngularVel.MaxTorque = Vector3.new(0, math.huge, 0)
            bodyAngularVel.AngularVelocity = Vector3.new(0, spinSpeed, 0)
            bodyAngularVel.Parent = hrp
        end
    elseif command == "unspin" then
        spinning = false
        if bodyAngularVel then bodyAngularVel:Destroy() end
    elseif command == "view" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if targetHumanoid then
                originalCameraSubject = workspace.CurrentCamera.CameraSubject
                workspace.CurrentCamera.CameraSubject = targetHumanoid
                viewing = true
            end
        end
    elseif command == "unview" then
        viewing = false
        local humanoid = getHumanoid()
        if humanoid and originalCameraSubject then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    elseif command == "explode" then
        local targetPlayer = args[1] and findPlayer(args[1]) or player
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local explosion = Instance.new("Explosion")
                explosion.Position = targetHRP.Position
                explosion.BlastRadius = 10
                explosion.BlastPressure = 500000
                explosion.Parent = workspace
            end
        end
    elseif command == "fire" then
        local targetPlayer = args[1] and findPlayer(args[1]) or player
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                Instance.new("Fire", targetHRP)
            end
        end
    elseif command == "unfire" then
        local targetPlayer = args[1] and findPlayer(args[1]) or player
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP and targetHRP:FindFirstChild("Fire") then
                targetHRP.Fire:Destroy()
            end
        end
    elseif command == "infjump" then
        infjump = not infjump
        if infjump then
            infjumpConnection = UserInputService.JumpRequest:Connect(function()
                local humanoid = getHumanoid()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infjumpConnection then infjumpConnection:Disconnect() end
        end
    elseif command == "nofall" then
        nofall = not nofall
        local humanoid = getHumanoid()
        if nofall and humanoid then
            nofallConnection = humanoid.StateChanged:Connect(function(old, new)
                if new == Enum.HumanoidStateType.Freefall then
                    local hrp = getHRP()
                    if hrp then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                    end
                end
            end)
        else
            if nofallConnection then nofallConnection:Disconnect() end
        end
    elseif command == "loopkill" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer then
            if not hasWeapon() then
                print("Loopkill: требуется оружие (меч/пушка) в инвентаре!")
                return
            end
            loopkills[targetPlayer.UserId] = true
            spawn(function()
                while loopkills[targetPlayer.UserId] do
                    if targetPlayer.Character then
                        local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if targetHumanoid then targetHumanoid.Health = 0 end
                    end
                    wait(0.5)
                end
            end)
        end
    elseif command == "unloopkill" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer then
            loopkills[targetPlayer.UserId] = false
        end
    elseif command == "loopfling" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer then
            loopflings[targetPlayer.UserId] = true
            spawn(function()
                while loopflings[targetPlayer.UserId] do
                    if targetPlayer.Character then
                        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            local bv = Instance.new("BodyVelocity")
                            bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
                            bv.Velocity = Vector3.new(math.random(-500, 500), 10000, math.random(-500, 500))
                            bv.Parent = targetHRP
                            Debris:AddItem(bv, 1.5)
                        end
                    end
                    wait(0.5)
                end
            end)
        end
    elseif command == "unloopfling" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer then
            loopflings[targetPlayer.UserId] = false
        end
    elseif command == "jail" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local jailPart = Instance.new("Part")
                jailPart.Size = Vector3.new(5, 5, 5)
                jailPart.Anchored = true
                jailPart.CanCollide = true
                jailPart.Transparency = 0.5
                jailPart.BrickColor = BrickColor.new("Bright red")
                jailPart.Position = targetHRP.Position
                jailPart.Parent = workspace
                jails[targetPlayer.UserId] = jailPart
            end
        end
    elseif command == "unjail" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and jails[targetPlayer.UserId] then
            jails[targetPlayer.UserId]:Destroy()
            jails[targetPlayer.UserId] = nil
        end
    elseif command == "btools" then
        local cloneTool = Instance.new("Tool")
        cloneTool.Name = "Clone"
        cloneTool.RequiresHandle = false
        cloneTool.Parent = player.Backpack
        cloneTool.Activated:Connect(function()
            local target = mouse.Target
            if target then
                local clone = target:Clone()
                clone.Parent = workspace
                clone.Position = mouse.Hit.Position + Vector3.new(0, clone.Size.Y / 2, 0)
            end
        end)

        local deleteTool = Instance.new("Tool")
        deleteTool.Name = "Delete"
        deleteTool.RequiresHandle = false
        deleteTool.Parent = player.Backpack
        deleteTool.Activated:Connect(function()
            local target = mouse.Target
            if target then target:Destroy() end
        end)
    elseif command == "serverhop" or command == "hop" then
        TeleportService:Teleport(game.PlaceId, player)
    elseif command == "rejoin" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    elseif command == "time" and args[1] then
        local timeVal = tonumber(args[1])
        if timeVal then Lighting.TimeOfDay = timeVal end
    elseif command == "day" then
        Lighting.TimeOfDay = 12
    elseif command == "night" then
        Lighting.TimeOfDay = 0
    elseif command == "fog" and args[1] then
        local fogEnd = tonumber(args[1])
        if fogEnd then Lighting.FogEnd = fogEnd end
    elseif command == "nofog" then
        Lighting.FogEnd = math.huge
    elseif command == "xray" then
        if xray then return end
        xray = true
        originalTransparencies = {}
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part:IsDescendantOf(getChar()) then
                originalTransparencies[part] = part.Transparency
                part.Transparency = 0.7
            end
        end
    elseif command == "unxray" then
        xray = false
        for part, trans in pairs(originalTransparencies) do
            if part and part.Parent then part.Transparency = trans end
        end
        originalTransparencies = {}
    elseif command == "dex" then
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()
        end)
        if not success then warn("Dex error: " .. err) end
    elseif command == "esp" then
        esp = not esp
        if esp then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = p.Character
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    espHighlights[p.UserId] = highlight
                end
            end
            Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function(char)
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = char
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    espHighlights[p.UserId] = highlight
                end)
            end)
        else
            for _, highlight in pairs(espHighlights) do
                if highlight then highlight:Destroy() end
            end
            espHighlights = {}
        end
    elseif command == "clicktp" then
        clicktp = not clicktp
        if clicktp then
            clicktpConnection = mouse.Button1Down:Connect(function()
                local hrp = getHRP()
                if hrp and mouse.Target then
                    hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
                end
            end)
        else
            if clicktpConnection then clicktpConnection:Disconnect() end
        end
    elseif command == "nograv" then
        nograv = not nograv
        local hrp = getHRP()
        if nograv and hrp then
            nogravBodyForce = Instance.new("BodyForce")
            nogravBodyForce.Force = Vector3.new(0, workspace.Gravity * hrp:GetMass(), 0)
            nogravBodyForce.Parent = hrp
        else
            if nogravBodyForce then nogravBodyForce:Destroy() end
        end
    elseif command == "playmusic" then
        if musicPlaying then return end
        musicPlaying = true
        local char = getChar()
        if char then
            musicSound = Instance.new("Sound")
            musicSound.SoundId = "rbxassetid://1839246711"
            musicSound.Volume = 1
            musicSound.Looped = true
            musicSound.Parent = char
            local success, err = pcall(function() musicSound:Play() end)
            if not success then
                warn("Music error: " .. tostring(err))
                musicPlaying = false
                musicSound:Destroy()
            end
        end
    elseif command == "stopmusic" then
        if not musicPlaying then return end
        musicPlaying = false
        if musicSound then
            musicSound:Stop()
            musicSound:Destroy()
        end
    elseif command == "freeze" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then targetHRP.Anchored = true end
        end
    elseif command == "unfreeze" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then targetHRP.Anchored = false end
        end
    elseif command == "dance" and args[1] then
        local targetPlayer = findPlayer(args[1])
        if targetPlayer and targetPlayer.Character then
            local hum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://507771019"  -- Проверенная анимация танца
                local track = hum:LoadAnimation(anim)
                track:Play()
            end
        end
    elseif command == "cmds" or command == "help" then
        local cmdFrame = Instance.new("Frame")
        cmdFrame.Name = "CommandList"
        cmdFrame.Parent = screenGui
        cmdFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        cmdFrame.BorderColor3 = Color3.fromRGB(255, 170, 0)
        cmdFrame.BorderSizePixel = 2
        cmdFrame.Position = UDim2.new(0.1, 0, 0.5, -150)
        cmdFrame.Size = UDim2.new(0, 300, 0, 400)
        cmdFrame.Active = true
        cmdFrame.Draggable = true

        local cmdTitle = Instance.new("TextLabel")
        cmdTitle.Parent = cmdFrame
        cmdTitle.BackgroundTransparency = 1
        cmdTitle.Position = UDim2.new(0, 0, 0, 0)
        cmdTitle.Size = UDim2.new(1, 0, 0, 30)
        cmdTitle.Font = Enum.Font.SourceSansBold
        cmdTitle.Text = "Infinite Yield Commands"
        cmdTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        cmdTitle.TextSize = 16

        local cmdScroll = Instance.new("ScrollingFrame")
        cmdScroll.Parent = cmdFrame
        cmdScroll.BackgroundTransparency = 1
        cmdScroll.Position = UDim2.new(0, 0, 0, 30)
        cmdScroll.Size = UDim2.new(1, 0, 1, -60)
        cmdScroll.CanvasSize = UDim2.new(0, 0, 0, #commandsList * 25)
        cmdScroll.ScrollBarThickness = 6

        local cmdListLayout = Instance.new("UIListLayout")
        cmdListLayout.Parent = cmdScroll
        cmdListLayout.Padding = UDim.new(0, 5)
        cmdListLayout.SortOrder = Enum.SortOrder.LayoutOrder

        for _, cmdDesc in ipairs(commandsList) do
            local cmdLabel = Instance.new("TextLabel")
            cmdLabel.Parent = cmdScroll
            cmdLabel.BackgroundTransparency = 1
            cmdLabel.Size = UDim2.new(1, 0, 0, 20)
            cmdLabel.Font = Enum.Font.SourceSans
            cmdLabel.Text = cmdDesc
            cmdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            cmdLabel.TextSize = 12
            cmdLabel.TextWrapped = true
            cmdLabel.TextXAlignment = Enum.TextXAlignment.Left
        end

        local closeCmdButton = Instance.new("TextButton")
        closeCmdButton.Parent = cmdFrame
        closeCmdButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        closeCmdButton.BorderColor3 = Color3.fromRGB(255, 170, 0)
        closeCmdButton.Position = UDim2.new(0, 10, 1, -25)
        closeCmdButton.Size = UDim2.new(1, -20, 0, 20)
        closeCmdButton.Font = Enum.Font.SourceSans
        closeCmdButton.Text = "Close"
        closeCmdButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeCmdButton.TextSize = 14

        closeCmdButton.MouseButton1Click:Connect(function()
            cmdFrame:Destroy()
        end)
    end
end

commandBar.FocusLost:Connect(function(enterPressed)
    if enterPressed and commandBar.Text ~= "" then
        handleCommand(commandBar.Text)
        commandBar.Text = ""
    end
end)

-- GUI Buttons
createButton("Fly (Toggle)", function()
    handleCommand("fly")
end, 1)

createButton("Noclip (Toggle)", function()
    handleCommand("noclip")
end, 2)

createButton("Teleport to Mouse", function()
    local hrp = getHRP()
    if hrp and mouse.Target then
        hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 5, 0))
    end
end, 3)

createButton("Teleport to Player", function()
    showPlayerList("Select Player to Teleport", function(target)
        if target.Character then
            local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
            local hrp = getHRP()
            if targetHRP and hrp then
                hrp.CFrame = CFrame.new(targetHRP.Position + Vector3.new(3, 0, 3))
            end
        end
    end)
end, 4)

createButton("Speed Boost (x2)", function()
    local humanoid = getHumanoid()
    if humanoid then humanoid.WalkSpeed = humanoid.WalkSpeed * 2 end
end, 5)

createButton("Reset Speed", function()
    local humanoid = getHumanoid()
    if humanoid then humanoid.WalkSpeed = 16 end
end, 6)

createButton("Random Colors", function()
    local char = getChar()
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            end
        end
    end
end, 7)

createButton("Flood", function()
    local hrp = getHRP()
    if not hrp then return end
    local centerPos = hrp.Position
    for x = -50, 50, 5 do
        for z = -50, 50, 5 do
            local water = Instance.new("Part")
            water.Name = "Water"
            water.Material = Enum.Material.Water
            water.BrickColor = BrickColor.new("Bright blue")
            water.Anchored = true
            water.CanCollide = false
            water.Transparency = 0.3
            water.Size = Vector3.new(5, 2, 5)
            water.Position = centerPos + Vector3.new(x, 2, z)
            water.Parent = workspace
            Debris:AddItem(water, 30)
        end
    end
end, 8)

createButton("c00ltixx Skybox", function()
    local sky = Instance.new("Sky", Lighting)
    sky.SkyboxBk = "http://www.roblox.com/asset/?id=1012890"
    sky.SkyboxDn = "http://www.roblox.com/asset/?id=1012890"
    sky.SkyboxFt = "http://www.roblox.com/asset/?id=1012890"
    sky.SkyboxLf = "http://www.roblox.com/asset/?id=1012890"
    sky.SkyboxRt = "http://www.roblox.com/asset/?id=1012890"
    sky.SkyboxUp = "http://www.roblox.com/asset/?id=1012890"
end, 9)

createButton("Disco Fog", function()
    Lighting.FogEnd = 50
    Lighting.FogColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    spawn(function()
        while wait(1) do
            Lighting.FogColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        end
    end)
end, 10)

createButton("666 Theme", function()
    local char = getChar()
    if char then
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then part.Color = Color3.fromRGB(255, 0, 0) end
        end
    end
    Lighting.Ambient = Color3.fromRGB(100, 0, 0)
end, 11)

createButton("Command List", function()
    handleCommand("cmds")
end, 12)

createButton("Dex Explorer", function()
    handleCommand("dex")
end, 13)

createButton("Play c00ltixx Theme", function()
    handleCommand("playmusic")
end, 14)

-- Новые кнопки для loadstring
createButton("uhhhhhh reaminate", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/STEVE-916-create/Uhhhhhh/main/source/reanim.lua"))()
    end)
    if not success then warn("reaminate error: " .. err) end
end, 15)

createButton("Tix hub", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/tixik0383838828383/Gui_GmanFromGarrysMod/refs/heads/main/LolGui.lua"))()
    end)
    if not success then warn("Tix hub error: " .. err) end
end, 16)

createButton("Close GUI", function()
    if noclip then noclip = false; if noclipConnection then noclipConnection:Disconnect() end; local char = getChar(); if char then for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = true end end end end
    if flying then flying = false; if flyConnection then flyConnection:Disconnect() end; local humanoid = getHumanoid(); if humanoid then humanoid.PlatformStand = false end; if bodyVelocity then bodyVelocity:Destroy() end; if bodyGyro then bodyGyro:Destroy() end end
    if spinning then spinning = false; if bodyAngularVel then bodyAngularVel:Destroy() end end
    if viewing then viewing = false; local humanoid = getHumanoid(); if humanoid and originalCameraSubject then workspace.CurrentCamera.CameraSubject = humanoid end end
    for userid in pairs(loopkills) do loopkills[userid] = false end
    for userid in pairs(loopflings) do loopflings[userid] = false end
    for userid, jail in pairs(jails) do if jail then jail:Destroy() end end
    if xray then handleCommand("unxray") end
    if esp then handleCommand("esp") end
    if clicktp then clicktp = false; if clicktpConnection then clicktpConnection:Disconnect() end end
    if nograv then nograv = false; if nogravBodyForce then nogravBodyForce:Destroy() end end
    if isInvisible then isInvisible = false; local invisChair = workspace:FindFirstChild("invischair"); if invisChair then invisChair:Destroy() end; local char = getChar(); if char then for _, descendant in ipairs(char:GetDescendants()) do if descendant:IsA("BasePart") or descendant:IsA("Decal") then descendant.Transparency = 0 end end end end
    if musicPlaying then musicPlaying = false; if musicSound then musicSound:Stop(); musicSound:Destroy() end end
    screenGui:Destroy()
end, 17)

mainFrame:TweenPosition(UDim2.new(0.5, -150, 0.5, -100), "Out", "Quad", 0.5, true)

print("tixxgui V2 loaded. Fly, commands, and new scripts ready.")
