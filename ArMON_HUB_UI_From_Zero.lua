--[[
    ArMON HUB | Blue & White UI (สร้าง UI ใหม่จากศูนย์)
    Roblox LocalScript / UI base
    - ธีมกรมท่า + ฟ้าอ่อน + ขาว
    - หน้าต่างลากย้ายได้
    - ปุ่มเปิด/ปิดหน้าต่าง
    - ข้อมูลผู้เล่นอัปเดตแบบเรียลไทม์
    - เมนูภาษาไทยพร้อมจุดเชื่อมต่อสำหรับฟังก์ชันเดิม
    หมายเหตุ: ไฟล์นี้เป็นส่วน UI ไม่ได้รวมระบบฟาร์มหรือระบบอัตโนมัติเดิม
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("ArMON_HUB_UI")
if oldGui then oldGui:Destroy() end

local C = {
    bg = Color3.fromRGB(5, 12, 28),
    panel = Color3.fromRGB(10, 22, 43),
    panel2 = Color3.fromRGB(14, 32, 58),
    cyan = Color3.fromRGB(77, 201, 255),
    blue = Color3.fromRGB(55, 139, 255),
    white = Color3.fromRGB(242, 249, 255),
    muted = Color3.fromRGB(151, 181, 211),
    green = Color3.fromRGB(67, 230, 163),
    line = Color3.fromRGB(50, 113, 160),
}

local gui = Instance.new("ScreenGui")
gui.Name = "ArMON_HUB_UI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 12)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or C.line
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function label(parent, text, size, color, font, x, y, w, h)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Text = text or ""
    l.TextSize = size or 14
    l.TextColor3 = color or C.white
    l.Font = font or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Position = UDim2.new(0, x or 0, 0, y or 0)
    l.Size = UDim2.new(0, w or 200, 0, h or 24)
    l.Parent = parent
    return l
end

local function button(parent, text, pos, size, active)
    local b = Instance.new("TextButton")
    b.AutoButtonColor = false
    b.Text = text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.TextColor3 = active and C.bg or C.white
    b.BackgroundColor3 = active and C.cyan or C.panel2
    b.Position = pos
    b.Size = size
    b.Parent = parent
    corner(b, 9)
    if not active then stroke(b, C.line, 1, 0.35) end
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = active and C.cyan or Color3.fromRGB(22, 47, 78)
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {
            BackgroundColor3 = active and C.cyan or C.panel2
        }):Play()
    end)
    return b
end

-- ปุ่มลอยสำหรับเปิด/ปิดหน้าต่าง
local toggle = Instance.new("TextButton")
toggle.Name = "ArMON_Toggle"
toggle.Size = UDim2.fromOffset(58, 58)
toggle.Position = UDim2.new(0, 20, 0.5, -29)
toggle.BackgroundColor3 = C.bg
toggle.Text = "A"
toggle.TextColor3 = C.cyan
toggle.TextSize = 27
toggle.Font = Enum.Font.GothamBlack
toggle.Parent = gui
corner(toggle, 18)
stroke(toggle, C.cyan, 2, 0.08)

local main = Instance.new("Frame")
main.Name = "MainWindow"
main.Size = UDim2.new(0.78, 0, 0.68, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = C.bg
main.Parent = gui
corner(main, 22)
stroke(main, C.cyan, 2, 0.12)

local sizeLimit = Instance.new("UISizeConstraint")
sizeLimit.MinSize = Vector2.new(320, 330)
sizeLimit.MaxSize = Vector2.new(900, 620)
sizeLimit.Parent = main

local top = Instance.new("Frame")
top.Size = UDim2.new(1, -2, 0, 62)
top.Position = UDim2.new(0, 1, 0, 1)
top.BackgroundColor3 = C.panel
top.Parent = main
corner(top, 20)

local title = label(top, "ArMON HUB", 22, C.white, Enum.Font.GothamBlack, 22, 7, 260, 28)
local subtitle = label(top, "BLUE / WHITE  •  LIVE CONTROL PANEL", 9, C.cyan, Enum.Font.GothamBold, 24, 34, 300, 15)

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.fromOffset(8, 8)
statusDot.Position = UDim2.new(1, -91, 0, 20)
statusDot.BackgroundColor3 = C.green
statusDot.Parent = top
corner(statusDot, 8)
label(top, "ออนไลน์", 12, C.green, Enum.Font.GothamSemibold, -75, 12, 60, 24).Position = UDim2.new(1, -75, 0, 12)

local close = button(top, "×", UDim2.new(1, -43, 0, 12), UDim2.fromOffset(30, 30), false)
close.TextSize = 23

local sidebar = Instance.new("Frame")
sidebar.Position = UDim2.new(0, 14, 0, 76)
sidebar.Size = UDim2.new(0, 142, 1, -92)
sidebar.BackgroundColor3 = C.panel
sidebar.Parent = main
corner(sidebar, 14)
stroke(sidebar, C.line, 1, 0.65)

label(sidebar, "เมนูหลัก", 11, C.muted, Enum.Font.GothamBold, 14, 12, 110, 22)

local content = Instance.new("Frame")
content.Position = UDim2.new(0, 168, 0, 76)
content.Size = UDim2.new(1, -182, 1, -92)
content.BackgroundTransparency = 1
content.Parent = main

local pages = {}
local activeTab = nil
local function makePage(name)
    local p = Instance.new("ScrollingFrame")
    p.Name = name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.BorderSizePixel = 0
    p.ScrollBarThickness = 3
    p.ScrollBarImageColor3 = C.cyan
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.Visible = false
    p.Parent = content
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = p
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        p.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)
    pages[name] = p
    return p
end

local function card(parent, height)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -4, 0, height)
    f.BackgroundColor3 = C.panel
    f.Parent = parent
    corner(f, 13)
    stroke(f, C.line, 1, 0.55)
    return f
end

local statsPage = makePage("ภาพรวม")
local overview = card(statsPage, 138)
label(overview, "ACCOUNT STATS", 12, C.cyan, Enum.Font.GothamBold, 16, 10, 220, 20)
local username = label(overview, "@" .. player.Name, 14, C.white, Enum.Font.GothamSemibold, 16, 34, 260, 22)
local levelText = label(overview, "เลเวล: กำลังโหลด...", 14, C.white, Enum.Font.GothamBold, 16, 63, 220, 22)
local beliText = label(overview, "เงิน: กำลังโหลด...", 14, C.cyan, Enum.Font.GothamBold, 16, 91, 220, 22)
local fragmentsText = label(overview, "Fragments: กำลังโหลด...", 13, C.muted, Enum.Font.GothamSemibold, 245, 63, 230, 22)
local raceText = label(overview, "เผ่า: ไม่ทราบ", 13, C.muted, Enum.Font.GothamSemibold, 245, 91, 230, 22)

local taskCard = card(statsPage, 94)
label(taskCard, "สถานะระบบ", 13, C.cyan, Enum.Font.GothamBold, 16, 10, 180, 20)
local taskStatus = label(taskCard, "UI พร้อมใช้งาน • รอเชื่อมต่อฟังก์ชัน", 12, C.muted, Enum.Font.Gotham, 16, 38, 420, 24)
local uptime = label(taskCard, "เวลาเปิด UI: 00:00:00", 11, C.muted, Enum.Font.Gotham, 16, 63, 250, 18)

local function makeInfoPage(name, heading, desc)
    local p = makePage(name)
    local f = card(p, 100)
    label(f, heading, 15, C.cyan, Enum.Font.GothamBold, 16, 12, 360, 24)
    label(f, desc, 12, C.muted, Enum.Font.Gotham, 16, 42, 460, 42)
    return p
end

local farmPage = makeInfoPage("ฟาร์ม", "ระบบฟาร์ม", "พื้นที่สำหรับเชื่อมต่อปุ่มฟาร์มเดิม โดยยังไม่ได้ผูกคำสั่งอัตโนมัติ")
local itemsPage = makeInfoPage("ไอเทม", "ไอเทมและอุปกรณ์", "พื้นที่สำหรับแสดงรายการไอเทมและสถานะการเก็บไอเทม")
local settingsPage = makeInfoPage("ตั้งค่า", "ตั้งค่า ArMON HUB", "UI นี้สร้างใหม่จากศูนย์ สามารถนำฟังก์ชันเดิมมาเชื่อมต่อภายหลังได้")

local navNames = {"ภาพรวม", "ฟาร์ม", "ไอเทม", "ตั้งค่า"}
local navButtons = {}
local function showTab(name)
    activeTab = name
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
    for navName, nav in pairs(navButtons) do
        local isActive = navName == name
        nav.BackgroundColor3 = isActive and C.cyan or C.panel2
        nav.TextColor3 = isActive and C.bg or C.white
    end
end

for i, name in ipairs(navNames) do
    local nav = button(sidebar, name, UDim2.new(0, 10, 0, 42 + (i - 1) * 46), UDim2.new(1, -20, 0, 36), i == 1)
    nav.TextXAlignment = Enum.TextXAlignment.Left
    nav.Text = "   " .. name
    navButtons[name] = nav
    nav.MouseButton1Click:Connect(function() showTab(name) end)
end
showTab("ภาพรวม")

-- ลากหน้าต่างได้ทั้งบนมือถือและคอมพิวเตอร์
local dragging = false
local dragStart, startPosition
top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

local opened = true
local function setOpen(state)
    opened = state
    if state then
        main.Visible = true
        main.BackgroundTransparency = 1
        TweenService:Create(main, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
    else
        main.Visible = false
    end
end
toggle.MouseButton1Click:Connect(function() setOpen(not opened) end)
close.MouseButton1Click:Connect(function() setOpen(false) end)

local startedAt = os.clock()
local function readValue(container, name)
    local obj = container and container:FindFirstChild(name)
    return obj and obj.Value
end

local function updateStats()
    local data = player:FindFirstChild("Data")
    local level = readValue(data, "Level")
    local beli = readValue(data, "Beli")
    local fragments = readValue(data, "Fragments")
    levelText.Text = "เลเวล: " .. (level and tostring(level) or "—")
    beliText.Text = "เงิน: $" .. (beli and string.format("%s", tostring(beli)) or "—")
    fragmentsText.Text = "Fragments: " .. (fragments and tostring(fragments) or "—")

    local character = player.Character
    local race = character and character:FindFirstChild("Race")
    if not race then race = data and data:FindFirstChild("Race") end
    raceText.Text = "เผ่า: " .. (race and tostring(race.Value or race.Name) or "ไม่ทราบ")
end

local function formatTime(seconds)
    seconds = math.floor(seconds)
    return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor(seconds / 60) % 60, seconds % 60)
end

task.spawn(function()
    while gui.Parent do
        pcall(updateStats)
        uptime.Text = "เวลาเปิด UI: " .. formatTime(os.clock() - startedAt)
        task.wait(1)
    end
end)

-- API สำหรับเชื่อมต่อกับฟังก์ชันเดิมจากสคริปต์หลัก
getgenv().ArMON_HUB_UI = {
    SetStatus = function(text)
        taskStatus.Text = tostring(text or "")
    end,
    SetMainTask = function(text)
        taskStatus.Text = tostring(text or "")
    end,
    ShowTab = showTab,
    SetOpen = setOpen,
    GUI = gui,
}

print("[ArMON HUB] UI loaded successfully.")
