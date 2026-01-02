local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Moon = {}

local Theme = {
    Bg = Color3.fromRGB(8, 6, 14),
    Panel = Color3.fromRGB(14, 11, 24),
    Accent = Color3.fromRGB(170, 120, 255),
    AccentSoft = Color3.fromRGB(90, 60, 160),
    Text = Color3.fromRGB(240,235,255),
    Muted = Color3.fromRGB(160,150,200)
}

local function round(o,r)
    Instance.new("UICorner",o).CornerRadius = UDim.new(0,r)
end

local function glow(parent)
    local g = Instance.new("UIStroke", parent)
    g.Thickness = 1
    g.Color = Theme.Accent
    g.Transparency = 0.6
end

function Moon:CreateWindow(title, keybind)
    local Window = {}
    local Open = true
    keybind = keybind or Enum.KeyCode.RightShift

    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.ResetOnSpawn = false

    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.fromOffset(560, 380)
    Main.Position = UDim2.fromScale(0.5,0.5)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.BackgroundColor3 = Theme.Bg
    Main.BorderSizePixel = 0
    round(Main,16)
    glow(Main)

    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1,-60,0,44)
    Header.Position = UDim2.fromOffset(24,6)
    Header.BackgroundTransparency = 1
    Header.Text = title
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 22
    Header.TextColor3 = Theme.Text
    Header.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.fromOffset(34,34)
    Close.Position = UDim2.new(1,-48,0,8)
    Close.Text = "✕"
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 16
    Close.TextColor3 = Theme.Text
    Close.BackgroundColor3 = Theme.Panel
    round(Close,10)

    Close.MouseButton1Click:Connect(function()
        Open = false
        Main.Visible = false
    end)

    UIS.InputBegan:Connect(function(i,g)
        if not g and i.KeyCode == keybind then
            Open = not Open
            Main.Visible = Open
        end
    end)

    do
        local drag, sPos, sIn
        Main.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                sIn = i.Position
                sPos = Main.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - sIn
                Main.Position = sPos + UDim2.fromOffset(d.X,d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
        end)
    end

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.fromOffset(150,300)
    Tabs.Position = UDim2.fromOffset(14,60)
    Tabs.BackgroundColor3 = Theme.Panel
    round(Tabs,14)

    local TabLayout = Instance.new("UIListLayout", Tabs)
    TabLayout.Padding = UDim.new(0,8)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.fromOffset(360,300)
    Pages.Position = UDim2.fromOffset(184,60)
    Pages.BackgroundTransparency = 1

    function Window:CreateTab(name)
        local Tab = {}

        local Btn = Instance.new("TextButton", Tabs)
        Btn.Size = UDim2.new(1,-16,0,36)
        Btn.Text = name
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.TextColor3 = Theme.Text
        Btn.BackgroundColor3 = Theme.Bg
        round(Btn,10)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Visible = false
        Page.ScrollBarImageTransparency = 1
        Page.Size = UDim2.fromScale(1,1)

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,10)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 10)
        end)

        Btn.MouseButton1Click:Connect(function()
            for _,v in ipairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then v.Visible = false end
            end
            Page.Visible = true
        end)

        function Tab:CreateLabel(text)
            local L = Instance.new("TextLabel", Page)
            L.Size = UDim2.new(1,-16,0,26)
            L.BackgroundTransparency = 1
            L.Text = text
            L.Font = Enum.Font.GothamSemibold
            L.TextSize = 13
            L.TextColor3 = Theme.Muted
            L.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:CreateToggle(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1,-16,0,38)
            B.Text = text
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextColor3 = Theme.Text
            B.BackgroundColor3 = Theme.Panel
            round(B,10)

            local state = false
            B.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(
                    B,
                    TweenInfo.new(0.2),
                    {BackgroundColor3 = state and Theme.Accent or Theme.Panel}
                ):Play()
                callback(state)
            end)
        end

        function Tab:CreateSlider(text,min,max,callback)
            local S = Instance.new("TextBox", Page)
            S.Size = UDim2.new(1,-16,0,36)
            S.PlaceholderText = text.." ("..min.." - "..max..")"
            S.Font = Enum.Font.Gotham
            S.TextSize = 14
            S.TextColor3 = Theme.Text
            S.BackgroundColor3 = Theme.Panel
            round(S,10)

            S.FocusLost:Connect(function()
                local v = tonumber(S.Text)
                if v then callback(math.clamp(v,min,max)) end
            end)
        end

        return Tab
    end

    return Window
end

return Moon
