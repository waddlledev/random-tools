local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Moon = {}

local Theme = {
    Bg = Color3.fromRGB(10, 8, 18),
    Panel = Color3.fromRGB(18, 14, 30),
    Accent = Color3.fromRGB(155, 120, 255),
    Text = Color3.fromRGB(235,230,255),
    Muted = Color3.fromRGB(150,140,200)
}

function Moon:CreateWindow(title, keybind)
    local Window = {}
    local Open = true
    keybind = keybind or Enum.KeyCode.RightShift

    local Gui = Instance.new("ScreenGui", CoreGui)
    Gui.ResetOnSpawn = false

    local Main = Instance.new("Frame", Gui)
    Main.Size = UDim2.fromOffset(520, 360)
    Main.Position = UDim2.fromScale(0.5,0.5)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.BackgroundColor3 = Theme.Bg
    Main.BorderSizePixel = 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,14)

    local Header = Instance.new("TextLabel", Main)
    Header.Size = UDim2.new(1,-40,0,40)
    Header.Position = UDim2.fromOffset(20,0)
    Header.BackgroundTransparency = 1
    Header.Text = title
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 20
    Header.TextColor3 = Theme.Text
    Header.TextXAlignment = Enum.TextXAlignment.Left

    local Close = Instance.new("TextButton", Main)
    Close.Size = UDim2.fromOffset(30,30)
    Close.Position = UDim2.new(1,-40,0,5)
    Close.Text = "✕"
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 16
    Close.TextColor3 = Theme.Text
    Close.BackgroundColor3 = Theme.Panel
    Instance.new("UICorner", Close).CornerRadius = UDim.new(1,0)

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
        local drag, startPos, startInput
        Main.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                startInput = i.Position
                startPos = Main.Position
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - startInput
                Main.Position = startPos + UDim2.fromOffset(d.X,d.Y)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = false
            end
        end)
    end

    local Tabs = Instance.new("Frame", Main)
    Tabs.Size = UDim2.fromOffset(140,300)
    Tabs.Position = UDim2.fromOffset(10,50)
    Tabs.BackgroundColor3 = Theme.Panel
    Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0,12)

    local TabLayout = Instance.new("UIListLayout", Tabs)
    TabLayout.Padding = UDim.new(0,6)

    local Pages = Instance.new("Frame", Main)
    Pages.Size = UDim2.fromOffset(340,300)
    Pages.Position = UDim2.fromOffset(170,50)
    Pages.BackgroundTransparency = 1

    function Window:CreateTab(name)
        local Tab = {}
        local Btn = Instance.new("TextButton", Tabs)
        Btn.Size = UDim2.new(1,-10,0,34)
        Btn.Text = name
        Btn.Font = Enum.Font.Gotham
        Btn.TextSize = 14
        Btn.TextColor3 = Theme.Text
        Btn.BackgroundColor3 = Theme.Bg
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,8)

        local Page = Instance.new("ScrollingFrame", Pages)
        Page.Visible = false
        Page.ScrollBarImageTransparency = 1
        Page.Size = UDim2.fromScale(1,1)

        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0,8)

        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Page.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 8)
        end)

        Btn.MouseButton1Click:Connect(function()
            for _,v in ipairs(Pages:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            Page.Visible = true
        end)

        function Tab:CreateLabel(text)
            local L = Instance.new("TextLabel", Page)
            L.Size = UDim2.new(1,-10,0,24)
            L.BackgroundTransparency = 1
            L.Text = text
            L.Font = Enum.Font.Gotham
            L.TextSize = 13
            L.TextColor3 = Theme.Muted
            L.TextXAlignment = Enum.TextXAlignment.Left
        end

        function Tab:CreateToggle(text, callback)
            local B = Instance.new("TextButton", Page)
            B.Size = UDim2.new(1,-10,0,34)
            B.Text = text
            B.Font = Enum.Font.Gotham
            B.TextSize = 14
            B.TextColor3 = Theme.Text
            B.BackgroundColor3 = Theme.Panel
            Instance.new("UICorner", B).CornerRadius = UDim.new(0,8)

            local state = false
            B.MouseButton1Click:Connect(function()
                state = not state
                B.BackgroundColor3 = state and Theme.Accent or Theme.Panel
                callback(state)
            end)
        end

        function Tab:CreateSlider(text,min,max,callback)
            local S = Instance.new("TextBox", Page)
            S.Size = UDim2.new(1,-10,0,34)
            S.Text = tostring(min)
            S.PlaceholderText = text.." ("..min.." - "..max..")"
            S.Font = Enum.Font.Gotham
            S.TextSize = 14
            S.TextColor3 = Theme.Text
            S.BackgroundColor3 = Theme.Panel
            Instance.new("UICorner", S).CornerRadius = UDim.new(0,8)

            S.FocusLost:Connect(function()
                local v = tonumber(S.Text)
                if v then
                    v = math.clamp(v,min,max)
                    callback(v)
                end
            end)
        end

        function Tab:CreateDropdown(text,list,callback)
            for _,v in ipairs(list) do
                Tab:CreateToggle(text..": "..v,function(on)
                    if on then callback(v) end
                end)
            end
        end

        return Tab
    end

    return Window
end

return Moon
