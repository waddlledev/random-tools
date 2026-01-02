--// Purple Black UI Library
--// Author: ChatGPT
--// Works in exploits or LocalScripts

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Library = {}
Library.Keybind = Enum.KeyCode.RightShift
Library.Open = true

--// Theme
local Theme = {
    Background = Color3.fromRGB(10, 8, 18),
    Panel = Color3.fromRGB(18, 14, 30),
    Accent = Color3.fromRGB(155, 120, 255),
    Text = Color3.fromRGB(235, 230, 255),
    Muted = Color3.fromRGB(160, 150, 200)
}

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PurpleUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

--// Main Window
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(520, 360)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

--// Drag
do
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = startPos + UDim2.fromOffset(delta.X, delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

--// Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, -40, 0, 44)
Header.Position = UDim2.fromOffset(20, 0)
Header.BackgroundTransparency = 1
Header.Text = "Purple UI"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Theme.Text
Header.TextXAlignment = Left
Header.Parent = Main

--// Close Button
local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(30, 30)
Close.Position = UDim2.new(1, -40, 0, 7)
Close.BackgroundColor3 = Theme.Panel
Close.Text = "✕"
Close.TextColor3 = Theme.Text
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.Parent = Main
Instance.new("UICorner", Close).CornerRadius = UDim.new(1, 0)

Close.MouseButton1Click:Connect(function()
    Library.Open = false
    Main.Visible = false
end)

--// Toggle UI Key
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Library.Keybind then
        Library.Open = not Library.Open
        Main.Visible = Library.Open
    end
end)

--// Tabs
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.fromOffset(140, 300)
Tabs.Position = UDim2.fromOffset(10, 50)
Tabs.BackgroundColor3 = Theme.Panel
Tabs.BorderSizePixel = 0
Tabs.Parent = Main
Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0, 12)

local TabList = Instance.new("UIListLayout", Tabs)
TabList.Padding = UDim.new(0, 6)

--// Pages
local Pages = Instance.new("Frame")
Pages.Size = UDim2.fromOffset(340, 300)
Pages.Position = UDim2.fromOffset(170, 50)
Pages.BackgroundTransparency = 1
Pages.Parent = Main

--// Create Tab
function Library:CreateTab(name)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 36)
    Button.BackgroundColor3 = Theme.Background
    Button.Text = name
    Button.TextColor3 = Theme.Text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = Tabs
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.fromScale(1, 1)
    Page.CanvasSize = UDim2.fromScale(0, 0)
    Page.ScrollBarImageTransparency = 1
    Page.Visible = false
    Page.Parent = Pages

    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 10)
    end)

    Button.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages:GetChildren()) do
            if v:IsA("ScrollingFrame") then
                v.Visible = false
            end
        end
        Page.Visible = true
    end)

    return Page
end

--// UI Elements
function Library:Label(parent, text)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -10, 0, 30)
    L.BackgroundTransparency = 1
    L.Text = text
    L.Font = Enum.Font.Gotham
    L.TextSize = 14
    L.TextColor3 = Theme.Muted
    L.TextXAlignment = Left
    L.Parent = parent
end

function Library:Toggle(parent, text, callback)
    local T = Instance.new("TextButton")
    T.Size = UDim2.new(1, -10, 0, 36)
    T.BackgroundColor3 = Theme.Panel
    T.Text = text
    T.TextColor3 = Theme.Text
    T.Font = Enum.Font.Gotham
    T.TextSize = 14
    T.Parent = parent
    Instance.new("UICorner", T).CornerRadius = UDim.new(0, 8)

    local on = false
    T.MouseButton1Click:Connect(function()
        on = not on
        T.BackgroundColor3 = on and Theme.Accent or Theme.Panel
        callback(on)
    end)
end

function Library:Textbox(parent, placeholder, callback)
    local B = Instance.new("TextBox")
    B.Size = UDim2.new(1, -10, 0, 36)
    B.BackgroundColor3 = Theme.Panel
    B.PlaceholderText = placeholder
    B.Text = ""
    B.TextColor3 = Theme.Text
    B.Font = Enum.Font.Gotham
    B.TextSize = 14
    B.Parent = parent
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 8)

    B.FocusLost:Connect(function()
        callback(B.Text)
    end)
end

--// Return Library
return Library
