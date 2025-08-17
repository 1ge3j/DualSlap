if game.CoreGui:FindFirstChild("TraThuGui") then
    game.CoreGui.TraThuGui:Destroy()
end

local P=game:GetService("Players")
local L=P.LocalPlayer
local U=game:GetService("UserInputService")

local g=Instance.new("ScreenGui",game.CoreGui)
g.Name="TraThuGui"
g.ResetOnSpawn=false

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,280,0,180)
f.Position=UDim2.new(0.5,-140,0.5,-90)
f.BackgroundColor3=Color3.fromRGB(255,0,0)
f.BorderSizePixel=0
f.BackgroundTransparency=0.1
Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)

local d=false
local di,ds,sp

local function c(p)
    local vs=workspace.CurrentCamera.ViewportSize
    local x=math.clamp(p.X.Offset,0,vs.X-f.AbsoluteSize.X)
    local y=math.clamp(p.Y.Offset,0,vs.Y-f.AbsoluteSize.Y)
    return UDim2.new(0,x,0,y)
end

local function u(i)
    local delta=i.Position-ds
    local newPos=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y)
    f.Position=c(newPos)
end

f.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        d=true
        ds=i.Position
        sp=f.Position
        i.Changed:Connect(function()
            if i.UserInputState==Enum.UserInputState.End then d=false end
        end)
    end
end)

f.InputChanged:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
        di=i
    end
end)

U.InputChanged:Connect(function(i)
    if i==di and d then u(i) end
end)

local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,0,0,30)
t.Text="🖐 GUI Trả Thù Dual Slap VIP"
t.Font=Enum.Font.GothamBold
t.TextSize=18
t.TextColor3=Color3.new(1,1,1)
t.BackgroundTransparency=1

local n=Instance.new("TextBox",f)
n.Size=UDim2.new(1,-20,0,30)
n.Position=UDim2.new(0,10,0,40)
n.PlaceholderText="Nhập tên player hoặc OTHERS"
n.Font=Enum.Font.Gotham
n.TextSize=14
n.Text=""
n.TextColor3=Color3.new(1,1,1)
n.BackgroundColor3=Color3.fromRGB(30,30,30)
Instance.new("UICorner",n).CornerRadius=UDim.new(0,8)

local sF=Instance.new("Frame",f)
sF.Size=UDim2.new(1,-20,0,60)
sF.Position=UDim2.new(0,10,0,75)
sF.BackgroundTransparency=1
sF.Visible=false
local sug={}

n:GetPropertyChangedSignal("Text"):Connect(function()
    local txt=n.Text:lower()
    sF.Visible=false
    for _,v in pairs(sug) do v:Destroy() end
    sug={}
    if txt=="" or txt=="others" then return end
    local idx=0
    for _,plr in ipairs(P:GetPlayers()) do
        if plr~=L and plr.Name:lower():find(txt,1,true) then
            idx=idx+1
            local b=Instance.new("TextButton",sF)
            b.Size=UDim2.new(1,0,0,20)
            b.Position=UDim2.new(0,0,0,(idx-1)*22)
            b.Text=plr.Name
            b.Font=Enum.Font.Gotham
            b.TextSize=14
            b.TextColor3=Color3.new(1,1,1)
            b.BackgroundColor3=Color3.fromRGB(50,50,50)
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
            b.MouseButton1Click:Connect(function()
                n.Text=plr.Name
                sF.Visible=false
            end)
            table.insert(sug,b)
        end
    end
    sF.Visible=#sug>0
end)

local b=Instance.new("TextButton",f)
b.Size=UDim2.new(1,-20,0,35)
b.Position=UDim2.new(0,10,0,140)
b.Text="Tát VIP"
b.Font=Enum.Font.GothamBold
b.TextSize=16
b.TextColor3=Color3.new(1,1,1)
b.BackgroundColor3=Color3.fromRGB(40,40,40)
Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)

local function slap(plr)
    if not plr or not plr.Character or not plr.Character.PrimaryPart then return end
    local v=vector.create(0/0,math.huge,-math.huge)
    local bv=Instance.new("BodyVelocity")
    bv.Velocity=v
    bv.MaxForce=Vector3.new(math.huge,math.huge,math.huge)
    bv.Parent=plr.Character.PrimaryPart
    local bav=Instance.new("BodyAngularVelocity")
    bav.AngularVelocity=Vector3.new(math.huge,math.huge,math.huge)
    bav.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
    bav.P=1e5
    bav.Parent=plr.Character.PrimaryPart
    plr.Character:SetPrimaryPartCFrame(CFrame.new(vector.create(math.huge,math.huge,math.huge)))
    if L.Character:FindFirstChild("Dual Slap") and L.Character["Dual Slap"]:FindFirstChild("Event") then
        L.Character["Dual Slap"].Event:FireServer("slash",plr.Character,v)
    end
end

b.MouseButton1Click:Connect(function()
    local txt=n.Text
    local skipList = {"chinek_281216"} -- danh sách bỏ qua
    if txt:lower()=="others" then
        for _,plr in ipairs(P:GetPlayers()) do
            local skip=false
            for _,name in ipairs(skipList) do
                if plr.Name:lower()==name:lower() then
                    skip=true
                    break
                end
            end
            if plr~=L and not skip then
                slap(plr)
            end
        end
    else
        local plr=P:FindFirstChild(txt)
        if plr then slap(plr) end
    end
end)

task.spawn(function()
    local h=0
    while g.Parent do
        h=(h+0.01)%1
        local c=Color3.fromHSV(h,1,1)
        f.BackgroundColor3=c
        b.BackgroundColor3=c
        task.wait(0.03)
    end
end)
