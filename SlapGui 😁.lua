if game.CoreGui:FindFirstChild("TraThuGui") then
    game.CoreGui.TraThuGui:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInput = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TraThuGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local dragging = false
local dragInput, dragStart, startPos

local function clampPosition(pos)
    local vs = workspace.CurrentCamera.ViewportSize
    local x = math.clamp(pos.X.Offset, 0, vs.X - frame.AbsoluteSize.X)
    local y = math.clamp(pos.Y.Offset, 0, vs.Y - frame.AbsoluteSize.Y)
    return UDim2.new(0, x, 0, y)
end

local function updatePosition(input)
    local delta = input.Position - dragStart
    local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    frame.Position = clampPosition(newPos)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInput.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updatePosition(input) end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🖐 Dual Slap VIP GUI"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local textbox = Instance.new("TextBox", frame)
textbox.Size = UDim2.new(1, -20, 0, 30)
textbox.Position = UDim2.new(0, 10, 0, 40)
textbox.PlaceholderText = "Enter player name or OTHERS"
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
textbox.Text = ""
textbox.TextColor3 = Color3.new(1, 1, 1)
textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 8)

local suggestionFrame = Instance.new("Frame", frame)
suggestionFrame.Size = UDim2.new(1, -20, 0, 60)
suggestionFrame.Position = UDim2.new(0, 10, 0, 75)
suggestionFrame.BackgroundTransparency = 1
suggestionFrame.Visible = false
local suggestions = {}

textbox:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = textbox.Text:lower()
    suggestionFrame.Visible = false
    for _, v in pairs(suggestions) do v:Destroy() end
    suggestions = {}
    if txt == "" or txt == "others" then return end
    local idx = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Name:lower():find(txt, 1, true) then
            idx = idx + 1
            local btn = Instance.new("TextButton", suggestionFrame)
            btn.Size = UDim2.new(1, 0, 0, 20)
            btn.Position = UDim2.new(0, 0, 0, (idx-1)*22)
            btn.Text = plr.Name
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            btn.MouseButton1Click:Connect(function()
                textbox.Text = plr.Name
                suggestionFrame.Visible = false
            end)
            table.insert(suggestions, btn)
        end
    end
    suggestionFrame.Visible = #suggestions > 0
end)

local slapButton = Instance.new("TextButton", frame)
slapButton.Size = UDim2.new(1, -20, 0, 35)
slapButton.Position = UDim2.new(0, 10, 0, 140)
slapButton.Text = "VIP Slap"
slapButton.Font = Enum.Font.GothamBold
slapButton.TextSize = 16
slapButton.TextColor3 = Color3.new(1, 1, 1)
slapButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", slapButton).CornerRadius = UDim.new(0, 8)

local function slap(player)
    if not player or not player.Character or not player.Character.PrimaryPart then return end
    local v = vector.create(0/0, math.huge, -math.huge)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = v
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = player.Character.PrimaryPart
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(math.huge, math.huge, math.huge)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 1e5
    bav.Parent = player.Character.PrimaryPart
    player.Character:SetPrimaryPartCFrame(CFrame.new(vector.create(math.huge, math.huge, math.huge)))
    if LocalPlayer.Character:FindFirstChild("Dual Slap") and LocalPlayer.Character["Dual Slap"]:FindFirstChild("Event") then
        LocalPlayer.Character["Dual Slap"].Event:FireServer("slash", player.Character, v)
    end
end

slapButton.MouseButton1Click:Connect(function()
    local txt = textbox.Text
    local skipList = {"chinek_281216"} -- skip list
    if txt:lower() == "others" then
        for _, plr in ipairs(Players:GetPlayers()) do
            local skip = false
            for _, name in ipairs(skipList) do
                if plr.Name:lower() == name:lower() then
                    skip = true
                    break
                end
            end
            if plr ~= LocalPlayer and not skip then
                slap(plr)
            end
        end
    else
        local plr = Players:FindFirstChild(txt)
        if plr then slap(plr) end
    end
end)

task.spawn(function()
    local h = 0
    while gui.Parent do
        h = (h + 0.01) % 1
        local c = Color3.fromHSV(h, 1, 1)
        frame.BackgroundColor3 = c
        slapButton.BackgroundColor3 = c
        task.wait(0.03)
    end
end)