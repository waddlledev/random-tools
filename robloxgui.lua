local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Moon = {}

local Theme = {
    Bg = Color3.fromRGB(12, 12, 14),
    Panel = Color3.fromRGB(20, 20, 24),
    PanelDark = Color3.fromRGB(16, 16, 19),
    Accent = Color3.fromRGB(120, 110, 150),
    Text = Color3.fromRGB(235, 235, 240),
    Muted = Color3.fromRGB(150, 150, 160)
}

local function corner(o, r)
    Instance.new("UICorner", o).CornerRadius = UDim.new(0, r)
end

function Moon:CreateWindow(title, keybind)
    local Window = {}
    local Open = true
    keybind = keybind or Enum.KeyCode.RightShift

    local Gui = Instance.new("ScreenGui")
    Gui.Parent = CoreGui
    Gui.ResetOnSpawn = false

    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.fromOffset(560, 380)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Theme.Bg
    Main.BorderSizePixel = 0
    corner(Main, 14)

    local Header = Instance.new("Frame", Main)
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundColor3 = Theme.PanelDark
    Header.BorderSizePixel = 0
    corner(Header, 14)

    local HeaderMask = Instance.new("Frame", Header)
    HeaderMask.Size = UDim2.new(1, 0, 0, 26)
    HeaderMask.Position = UDim2.fromOffset(0, 26)
    HeaderMask.BackgroundColor3 = Theme.PanelDark
    HeaderMask.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.fromOffset(22, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.Font = Enum.Font.GothamSemibold
    Title.TextSize = 18
    Title.TextColor3 = Theme.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", Header)
    Close.Size = UDim2.fromOffset(32, 32)
    Close.Position = UDim2.new(1, -44, 0, 10)
    Close.Text = "×"
    Close.Font = Enum.Font.GothamSemibold
    Close.TextSize = 18
    Close.TextColor3 = Theme.Muted
    Close.BackgroundColor3 = Theme.Panel
    corner(Close, 8)

    Close.MouseButton1Click:Connect(function()
        Open = false
        Main.Visible = false
    end)

    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == keybind then
            Open = not Open
            Main.Visible = Open
        end
    end)

    do
        local drag, sPos, sIn
        Header.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                sIn = i.Position
                sPos = Main.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - sIn
                Main.Position = sPos + UDim2.fromOffset(d.X, d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = false
            end
        end)
    end

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.fromOffset(160, 300)
    Tabs.Position = UDim2.fromOffset(16, 64)
    Tabs.BackgroundColor3 = Theme.Panel
    corner(Tabs, 12)

    local TabLayout = Instance.new("UIListLayout", Tabs)
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.fromOffset(360, 300)
    Pages.Position = UDim2.fromOffset(192, 64)
    Pages.BackgroundTransparency = 1

    function Window:CreateTab(name)
        local Tab = {}

        local Btn = Instance.new("TextButton", Tabs)
        Btn.Size = UDim2.new(1, -16, 0, 36)
        Btn.BackgroundColor3 = Theme.PanelDark
        Btn.Text = name
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.TextColor3 = Theme.Text
        Btn.AutoButtonColor = false
        corner(Btn, 8)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Size = UDim2.fromScale(1, 1)
        Page.ScrollBarImageTransparency = 1
        Page.CanvasSize = UDim2.fromOffset(0, 0)
        Page.Visible = false

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 10)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 10)
        end)

        Btn.MouseButton1Click:Connect(function()
            for _, v in ipairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        function Tab:CreateLabel(text)
            local L = Instance.new("TextLabel", Page)
            L.Size = UDim2.new(1, -16, 0, 24)
            L.BackgroundTransparency = 1
            L.Text = text
            L.Font = Enum.Font.Gotham
            L.TextSize = 13
            L.TextColor3 = Theme.Muted
            L.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:CreateToggle(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1, -16, 0, 38)
            B.BackgroundColor3 = Theme.Panel
            B.Text = text
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextColor3 = Theme.Text
            B.AutoButtonColor = false
            corner(B, 10)

            local state = false
            B.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(
                    B,
                    TweenInfo.new(0.15),
                    {BackgroundColor3 = state and Theme.Accent or Theme.Panel}
                ):Play()
                callback(state)
            end)
        end

        function Tab:CreateSlider(text, min, max, callback)
            local S = Instance.new("TextBox", Page)
            S.Size = UDim2.new(1, -16, 0, 36)
            S.BackgroundColor3 = Theme.Panel
            S.PlaceholderText = text .. " (" .. min .. " - " .. max .. ")"
            S.Font = Enum.Font.Gotham
            S.TextSize = 14
            S.TextColor3 = Theme.Text
            S.ClearTextOnFocus = false
            corner(S, 10)

            S.FocusLost:Connect(function()
                local v = tonumber(S.Text)
                if v then
                    callback(math.clamp(v, min, max))
                end
            end)
        end

        return Tab
    end

    return Window
end

return Moon
