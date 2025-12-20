local Aether = {
	Flags = {},
}

local AetherTheme = {
	Background = Color3.fromRGB(12, 14, 20),
	Surface = Color3.fromRGB(18, 20, 30),
	Accent = Color3.fromRGB(90, 120, 255),
	AccentLight = Color3.fromRGB(120, 150, 255),
	Text = Color3.fromRGB(235, 235, 240),
	TextMuted = Color3.fromRGB(155, 160, 180),
	Glow = Color3.fromRGB(90, 120, 255),
	GlowIntense = Color3.fromRGB(150, 180, 255),
	Success = Color3.fromRGB(80, 200, 120),
	Error = Color3.fromRGB(240, 100, 100),
	Radius = 10,
	TweenSpeed = 0.25,
	AnimationSpeed = 0.35
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local AetherFolder = "Aether"
local ConfigurationFolder = AetherFolder.."/Configurations"
local ConfigurationExtension = ".aether"

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false

local AetherGui = Instance.new("ScreenGui")
AetherGui.Name = "Aether"
AetherGui.ResetOnSpawn = false
AetherGui.ZIndex = 100

if gethui then
	AetherGui.Parent = gethui()
elseif syn and syn.protect_gui then
	syn.protect_gui(AetherGui)
	AetherGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
	AetherGui.Parent = CoreGui:FindFirstChild("RobloxGui")
else
	AetherGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 550, 0, 500)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
MainFrame.BackgroundColor3 = AetherTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = AetherGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, AetherTheme.Radius)
UICorner.Parent = MainFrame

local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundColor3 = AetherTheme.Surface
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, AetherTheme.Radius)
TopbarCorner.Parent = Topbar

local TopbarStroke = Instance.new("UIStroke")
TopbarStroke.Color = AetherTheme.Accent
TopbarStroke.Thickness = 1
TopbarStroke.Transparency = 0.7
TopbarStroke.Parent = Topbar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Aether"
Title.TextColor3 = AetherTheme.Text
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = AetherTheme.Accent
MainStroke.Thickness = 2
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

local TabList = Instance.new("Frame")
TabList.Name = "TabList"
TabList.Size = UDim2.new(1, 0, 0, 40)
TabList.Position = UDim2.new(0, 0, 0, 50)
TabList.BackgroundColor3 = AetherTheme.Surface
TabList.BorderSizePixel = 0
TabList.Parent = MainFrame

local TabScroll = Instance.new("UIListLayout")
TabScroll.FillDirection = Enum.FillDirection.Horizontal
TabScroll.Padding = UDim.new(0, 8)
TabScroll.Parent = TabList

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingLeft = UDim.new(0, 10)
TabPadding.PaddingRight = UDim.new(0, 10)
TabPadding.Parent = TabList

local Elements = Instance.new("ScrollingFrame")
Elements.Name = "Elements"
Elements.Size = UDim2.new(1, 0, 1, -90)
Elements.Position = UDim2.new(0, 0, 0, 90)
Elements.BackgroundTransparency = 1
Elements.BorderSizePixel = 0
Elements.ScrollBarThickness = 8
Elements.ScrollBarImageColor3 = AetherTheme.Accent
Elements.Parent = MainFrame

local ElementsLayout = Instance.new("UIListLayout")
ElementsLayout.Padding = UDim.new(0, 10)
ElementsLayout.Parent = Elements

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 15)
Padding.PaddingRight = UDim.new(0, 15)
Padding.PaddingTop = UDim.new(0, 12)
Padding.PaddingBottom = UDim.new(0, 12)
Padding.Parent = Elements

local Notifications = Instance.new("Frame")
Notifications.Name = "Notifications"
Notifications.Size = UDim2.new(1, 0, 1, 0)
Notifications.BackgroundTransparency = 1
Notifications.BorderSizePixel = 0
Notifications.Parent = AetherGui

local function CreateElement(Parent, Name, Size)
	local Element = Instance.new("Frame")
	Element.Name = Name
	Element.Size = Size
	Element.BackgroundColor3 = AetherTheme.Surface
	Element.BorderSizePixel = 0
	Element.Parent = Parent
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Element
	
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = AetherTheme.Accent
	Stroke.Thickness = 1
	Stroke.Transparency = 0.6
	Stroke.Parent = Element
	
	return Element, Corner, Stroke
end

local function PackColor(Color)
	return {R = Color.R * 255, G = Color.G * 255, B = Color.B * 255}
end

local function UnpackColor(Color)
	return Color3.fromRGB(Color.R, Color.G, Color.B)
end

local function SaveConfiguration()
	if not CEnabled then return end
	local Data = {}
	for i, v in pairs(Aether.Flags) do
		if v.Type == "ColorPicker" then
			Data[i] = PackColor(v.Color)
		else
			Data[i] = v.CurrentValue or v.CurrentKeybind or v.CurrentOption or v.Color
		end
	end	
	pcall(function()
		if not isfolder(ConfigurationFolder) then makefolder(ConfigurationFolder) end
		writefile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension, tostring(HttpService:JSONEncode(Data)))
	end)
end

local function LoadConfiguration(Configuration)
	local Data = HttpService:JSONDecode(Configuration)
	for FlagName, FlagValue in next, Data do
		if Aether.Flags[FlagName] then
			spawn(function() 
				if Aether.Flags[FlagName].Type == "ColorPicker" then
					Aether.Flags[FlagName]:Set(UnpackColor(FlagValue))
				else
					if Aether.Flags[FlagName].CurrentValue or Aether.Flags[FlagName].CurrentKeybind or Aether.Flags[FlagName].CurrentOption or Aether.Flags[FlagName].Color ~= FlagValue then 
						Aether.Flags[FlagName]:Set(FlagValue) 
					end
				end    
			end)
		end
	end
end

local function AddDraggingFunctionality(DragPoint, MainObj)
	pcall(function()
		local Dragging, DragInput, MousePos, FramePos = false
		DragPoint.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				Dragging = true
				MousePos = Input.Position
				FramePos = MainObj.Position

				Input.Changed:Connect(function()
					if Input.UserInputState == Enum.UserInputState.End then
						Dragging = false
					end
				end)
			end
		end)
		DragPoint.InputChanged:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseMovement then
				DragInput = Input
			end
		end)
		UserInputService.InputChanged:Connect(function(Input)
			if Input == DragInput and Dragging then
				local Delta = Input.Position - MousePos
				TweenService:Create(MainObj, TweenInfo.new(0.15, Enum.EasingStyle.Linear), {Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)}):Play()
			end
		end)
	end)
end

function Aether:Notify(NotificationSettings)
	spawn(function()
		local Notification = Instance.new("Frame")
		Notification.Name = NotificationSettings.Title or "Notification"
		Notification.Size = UDim2.new(0, 300, 0, 95)
		Notification.Position = UDim2.new(0.5, 0, 0.92, 0)
		Notification.BackgroundColor3 = AetherTheme.Surface
		Notification.BorderSizePixel = 0
		Notification.BackgroundTransparency = 0.05
		Notification.Parent = Notifications

		local NotifCorner = Instance.new("UICorner")
		NotifCorner.CornerRadius = UDim.new(0, 10)
		NotifCorner.Parent = Notification

		local NotifStroke = Instance.new("UIStroke")
		NotifStroke.Color = AetherTheme.Accent
		NotifStroke.Thickness = 1.5
		NotifStroke.Transparency = 0.5
		NotifStroke.Parent = Notification

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Name = "Title"
		NotifTitle.Size = UDim2.new(1, -20, 0, 25)
		NotifTitle.Position = UDim2.new(0, 10, 0, 8)
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Text = NotificationSettings.Title or "Unknown"
		NotifTitle.TextColor3 = AetherTheme.Text
		NotifTitle.TextSize = 15
		NotifTitle.Font = Enum.Font.GothamBold
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.Parent = Notification

		local Description = Instance.new("TextLabel")
		Description.Name = "Description"
		Description.Size = UDim2.new(1, -20, 0, 50)
		Description.Position = UDim2.new(0, 10, 0, 35)
		Description.BackgroundTransparency = 1
		Description.Text = NotificationSettings.Content or "Unknown"
		Description.TextColor3 = AetherTheme.TextMuted
		Description.TextSize = 12
		Description.Font = Enum.Font.Gotham
		Description.TextWrapped = true
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.TextYAlignment = Enum.TextYAlignment.Top
		Description.Parent = Notification

		TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.15}):Play()
		Notification:TweenPosition(UDim2.new(0.5, -150, 0.92, 0), 'Out', 'Quint', 0.4, true)

		wait(NotificationSettings.Duration or 5)

		TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
		TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
		wait(0.5)
		Notification:Destroy()
	end)
end

local function Hide()
	Debounce = true
	Aether:Notify({Title = "Interface Hidden", Content = "Press K to unhide", Duration = 2})
	TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
	TweenService:Create(TopbarStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
	TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 1}):Play()
	TweenService:Create(TabList, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
	TweenService:Create(Elements, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
	wait(0.5)
	MainFrame.Visible = false
	Debounce = false
end

local function Unhide()
	Debounce = true
	MainFrame.Visible = true
	MainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
	TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
	TweenService:Create(MainStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 0.5}):Play()
	TweenService:Create(Topbar, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
	TweenService:Create(TopbarStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 0.7}):Play()
	TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
	TweenService:Create(TabList, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
	TweenService:Create(Elements, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
	Debounce = false
end

function Aether:CreateWindow(Settings)
	Title.Text = Settings.Name or "Aether"
	
	pcall(function()
		if not Settings.ConfigurationSaving.FileName then
			Settings.ConfigurationSaving.FileName = tostring(game.PlaceId)
		end
		if not isfolder(AetherFolder) then makefolder(AetherFolder) end
		if not isfolder(AetherFolder.."/Configuration Folders") then makefolder(AetherFolder.."/Configuration Folders") end
		
		if Settings.ConfigurationSaving.Enabled == nil then
			Settings.ConfigurationSaving.Enabled = false
		end
		CFileName = Settings.ConfigurationSaving.FileName
		ConfigurationFolder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
		CEnabled = Settings.ConfigurationSaving.Enabled

		if Settings.ConfigurationSaving.Enabled then
			if not isfolder(ConfigurationFolder) then makefolder(ConfigurationFolder) end	
		end
	end)

	AddDraggingFunctionality(Topbar, MainFrame)

	local Window = {}
	local FirstTab = false

	function Window:CreateTab(Name, Image)
		local TabButton, TabCorner, TabStroke = CreateElement(TabList, Name, UDim2.new(0, 120, 0, 32))

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Name = "Title"
		TabTitle.Size = UDim2.new(1, -10, 1, 0)
		TabTitle.Position = UDim2.new(0, 5, 0, 0)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Text = Name
		TabTitle.TextColor3 = AetherTheme.Text
		TabTitle.TextSize = 13
		TabTitle.Font = Enum.Font.GothamSemibold
		TabTitle.Parent = TabButton

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = Name
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 8
		TabPage.ScrollBarImageColor3 = AetherTheme.Accent
		TabPage.Visible = FirstTab == false
		TabPage.Parent = Elements

		local TabPageLayout = Instance.new("UIListLayout")
		TabPageLayout.Padding = UDim.new(0, 10)
		TabPageLayout.Parent = TabPage

		local TabPagePadding = Instance.new("UIPadding")
		TabPagePadding.PaddingLeft = UDim.new(0, 0)
		TabPagePadding.PaddingRight = UDim.new(0, 0)
		TabPagePadding.PaddingTop = UDim.new(0, 0)
		TabPagePadding.Parent = TabPage

		if FirstTab == false then
			FirstTab = Name
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
		else
			TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.7}):Play()
		end

		TabButton.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 then
				if Debounce then return end
				Debounce = true

				for _, OtherTab in ipairs(TabList:GetChildren()) do
					if OtherTab:IsA("Frame") and OtherTab ~= TabButton then
						TweenService:Create(OtherTab, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.7}):Play()
					end
				end

				for _, OtherPage in ipairs(Elements:GetChildren()) do
					if OtherPage:IsA("ScrollingFrame") and OtherPage ~= TabPage then
						OtherPage.Visible = false
					end
				end

				TweenService:Create(TabButton, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = 0}):Play()
				TabPage.Visible = true

				wait(0.3)
				Debounce = false
			end
		end)

		local Tab = {}

		function Tab:CreateButton(ButtonSettings)
			local Button, ButtonCorner, ButtonStroke = CreateElement(TabPage, ButtonSettings.Name, UDim2.new(1, 0, 0, 42))

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Text = ButtonSettings.Name
			ButtonLabel.TextColor3 = AetherTheme.Text
			ButtonLabel.TextSize = 13
			ButtonLabel.Font = Enum.Font.GothamSemibold
			ButtonLabel.Parent = Button

			local ButtonInteract = Instance.new("TextButton")
			ButtonInteract.Size = UDim2.new(1, 0, 1, 0)
			ButtonInteract.BackgroundTransparency = 1
			ButtonInteract.Text = ""
			ButtonInteract.Parent = Button

			ButtonInteract.MouseButton1Click:Connect(function()
				local Success, Response = pcall(ButtonSettings.Callback)
				if not Success then
					TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Error}):Play()
					print("Aether | "..ButtonSettings.Name.." Error: " ..tostring(Response))
					wait(0.5)
					TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Surface}):Play()
				else
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.AccentLight}):Play()
					wait(0.2)
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Surface}):Play()
					SaveConfiguration()
				end
			end)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.AccentLight}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Surface}):Play()
			end)

			return Button
		end

		function Tab:CreateToggle(ToggleSettings)
			local Toggle, ToggleCorner, ToggleStroke = CreateElement(TabPage, ToggleSettings.Name, UDim2.new(1, 0, 0, 42))

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = ToggleSettings.Name
			ToggleLabel.TextColor3 = AetherTheme.Text
			ToggleLabel.TextSize = 13
			ToggleLabel.Font = Enum.Font.GothamSemibold
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = Toggle

			local Switch = Instance.new("Frame")
			Switch.Name = "Switch"
			Switch.Size = UDim2.new(0, 45, 0, 22)
			Switch.Position = UDim2.new(1, -55, 0.5, -11)
			Switch.BackgroundColor3 = AetherTheme.Background
			Switch.BorderSizePixel = 0
			Switch.Parent = Toggle

			local SwitchCorner = Instance.new("UICorner")
			SwitchCorner.CornerRadius = UDim.new(0, 11)
			SwitchCorner.Parent = Switch

			local SwitchStroke = Instance.new("UIStroke")
			SwitchStroke.Color = AetherTheme.Accent
			SwitchStroke.Thickness = 1
			SwitchStroke.Transparency = 0.4
			SwitchStroke.Parent = Switch

			local Indicator = Instance.new("Frame")
			Indicator.Name = "Indicator"
			Indicator.Size = UDim2.new(0, 18, 0, 18)
			Indicator.Position = UDim2.new(0, 2, 0.5, -9)
			Indicator.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
			Indicator.BorderSizePixel = 0
			Indicator.Parent = Switch

			local IndicatorCorner = Instance.new("UICorner")
			IndicatorCorner.CornerRadius = UDim.new(0, 9)
			IndicatorCorner.Parent = Indicator

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Size = UDim2.new(1, 0, 1, 0)
			ToggleButton.BackgroundTransparency = 1
			ToggleButton.Text = ""
			ToggleButton.Parent = Toggle

			if ToggleSettings.CurrentValue then
				Indicator.Position = UDim2.new(0, 25, 0.5, -9)
				Indicator.BackgroundColor3 = AetherTheme.Success
			end

			ToggleButton.MouseButton1Click:Connect(function()
				ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
				
				if ToggleSettings.CurrentValue then
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 25, 0.5, -9)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Success}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(90, 90, 100)}):Play()
				end

				pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				SaveConfiguration()
			end)

			Toggle.MouseEnter:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.AccentLight}):Play()
			end)

			Toggle.MouseLeave:Connect(function()
				TweenService:Create(Toggle, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Surface}):Play()
			end)

			function ToggleSettings:Set(Value)
				ToggleSettings.CurrentValue = Value
				if Value then
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 25, 0.5, -9)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Success}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 2, 0.5, -9)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(90, 90, 100)}):Play()
				end
				ToggleSettings.Callback(Value)
				SaveConfiguration()
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and ToggleSettings.Flag then
					Aether.Flags[ToggleSettings.Flag] = ToggleSettings
				end
			end

			return ToggleSettings
		end

		function Tab:CreateSlider(SliderSettings)
			local Slider, SliderCorner, SliderStroke = CreateElement(TabPage, SliderSettings.Name, UDim2.new(1, 0, 0, 60))

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(1, -20, 0, 20)
			SliderLabel.Position = UDim2.new(0, 10, 0, 8)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = SliderSettings.Name
			SliderLabel.TextColor3 = AetherTheme.Text
			SliderLabel.TextSize = 13
			SliderLabel.Font = Enum.Font.GothamSemibold
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = Slider

			local SliderValue = Instance.new("TextLabel")
			SliderValue.Size = UDim2.new(0, 50, 0, 20)
			SliderValue.Position = UDim2.new(1, -60, 0, 8)
			SliderValue.BackgroundTransparency = 1
			SliderValue.Text = tostring(SliderSettings.CurrentValue)
			SliderValue.TextColor3 = AetherTheme.Accent
			SliderValue.TextSize = 12
			SliderValue.Font = Enum.Font.GothamBold
			SliderValue.Parent = Slider

			local SliderBG = Instance.new("Frame")
			SliderBG.Size = UDim2.new(1, -20, 0, 8)
			SliderBG.Position = UDim2.new(0, 10, 0, 32)
			SliderBG.BackgroundColor3 = AetherTheme.Background
			SliderBG.BorderSizePixel = 0
			SliderBG.Parent = Slider

			local SliderBGCorner = Instance.new("UICorner")
			SliderBGCorner.CornerRadius = UDim.new(0, 4)
			SliderBGCorner.Parent = SliderBG

			local SliderProgress = Instance.new("Frame")
			SliderProgress.Size = UDim2.new((SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1]), 0, 1, 0)
			SliderProgress.BackgroundColor3 = AetherTheme.Accent
			SliderProgress.BorderSizePixel = 0
			SliderProgress.Parent = SliderBG

			local ProgressCorner = Instance.new("UICorner")
			ProgressCorner.CornerRadius = UDim.new(0, 4)
			ProgressCorner.Parent = SliderProgress

			local SliderButton = Instance.new("TextButton")
			SliderButton.Size = UDim2.new(1, 0, 1, 0)
			SliderButton.BackgroundTransparency = 1
			SliderButton.Text = ""
			SliderButton.Parent = SliderBG

			local Dragging = false

			SliderButton.MouseButton1Down:Connect(function()
				Dragging = true
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Dragging = false
				end
			end)

			RunService.RenderStepped:Connect(function()
				if Dragging then
					local MouseX = UserInputService:GetMouseLocation().X
					local SliderX = SliderBG.AbsolutePosition.X
					local SliderSize = SliderBG.AbsoluteSize.X
					
					local Relative = math.clamp(MouseX - SliderX, 0, SliderSize) / SliderSize
					local NewValue = SliderSettings.Range[1] + Relative * (SliderSettings.Range[2] - SliderSettings.Range[1])
					NewValue = math.floor(NewValue / (SliderSettings.Increment or 1) + 0.5) * (SliderSettings.Increment or 1)
					NewValue = math.clamp(NewValue, SliderSettings.Range[1], SliderSettings.Range[2])

					if NewValue ~= SliderSettings.CurrentValue then
						SliderSettings.CurrentValue = NewValue
						local Suffix = SliderSettings.Suffix or ""
						SliderValue.Text = tostring(NewValue) .. Suffix
						TweenService:Create(SliderProgress, TweenInfo.new(0.08, Enum.EasingStyle.Quint), {Size = UDim2.new(Relative, 0, 1, 0)}):Play()
						
						pcall(function()
							SliderSettings.Callback(NewValue)
						end)
						SaveConfiguration()
					end
				end
			end)

			function SliderSettings:Set(Value)
				SliderSettings.CurrentValue = Value
				local Ratio = (Value - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
				local Suffix = SliderSettings.Suffix or ""
				SliderValue.Text = tostring(Value) .. Suffix
				TweenService:Create(SliderProgress, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {Size = UDim2.new(Ratio, 0, 1, 0)}):Play()
				SliderSettings.Callback(Value)
				SaveConfiguration()
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and SliderSettings.Flag then
					Aether.Flags[SliderSettings.Flag] = SliderSettings
				end
			end

			return SliderSettings
		end

		function Tab:CreateLabel(LabelText)
			local Label, LabelCorner, LabelStroke = CreateElement(TabPage, "Label", UDim2.new(1, 0, 0, 38))

			local LabelTextObj = Instance.new("TextLabel")
			LabelTextObj.Size = UDim2.new(1, -20, 1, 0)
			LabelTextObj.Position = UDim2.new(0, 10, 0, 0)
			LabelTextObj.BackgroundTransparency = 1
			LabelTextObj.Text = LabelText
			LabelTextObj.TextColor3 = AetherTheme.TextMuted
			LabelTextObj.TextSize = 12
			LabelTextObj.Font = Enum.Font.Gotham
			LabelTextObj.TextXAlignment = Enum.TextXAlignment.Left
			LabelTextObj.Parent = Label

			return Label
		end

		function Tab:CreateParagraph(ParagraphSettings)
			local Paragraph, ParagraphCorner, ParagraphStroke = CreateElement(TabPage, "Paragraph", UDim2.new(1, 0, 0, 70))

			local ParagraphTitle = Instance.new("TextLabel")
			ParagraphTitle.Size = UDim2.new(1, -20, 0, 25)
			ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
			ParagraphTitle.BackgroundTransparency = 1
			ParagraphTitle.Text = ParagraphSettings.Title or "Title"
			ParagraphTitle.TextColor3 = AetherTheme.Text
			ParagraphTitle.TextSize = 13
			ParagraphTitle.Font = Enum.Font.GothamSemibold
			ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphTitle.Parent = Paragraph

			local ParagraphContent = Instance.new("TextLabel")
			ParagraphContent.Size = UDim2.new(1, -20, 0, 40)
			ParagraphContent.Position = UDim2.new(0, 10, 0, 30)
			ParagraphContent.BackgroundTransparency = 1
			ParagraphContent.Text = ParagraphSettings.Content or "Content"
			ParagraphContent.TextColor3 = AetherTheme.TextMuted
			ParagraphContent.TextSize = 11
			ParagraphContent.Font = Enum.Font.Gotham
			ParagraphContent.TextWrapped = true
			ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
			ParagraphContent.Parent = Paragraph

			return Paragraph
		end

		function Tab:CreateSection(SectionName)
			local Section, SectionCorner, SectionStroke = CreateElement(TabPage, SectionName, UDim2.new(1, 0, 0, 35))

			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Size = UDim2.new(1, -20, 1, 0)
			SectionTitle.Position = UDim2.new(0, 10, 0, 0)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Text = SectionName
			SectionTitle.TextColor3 = AetherTheme.Accent
			SectionTitle.TextSize = 14
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Parent = Section

			return Section
		end

		function Tab:CreateInput(InputSettings)
			local Input, InputCorner, InputStroke = CreateElement(TabPage, InputSettings.Name, UDim2.new(1, 0, 0, 50))

			local InputLabel = Instance.new("TextLabel")
			InputLabel.Size = UDim2.new(1, -20, 0, 18)
			InputLabel.Position = UDim2.new(0, 10, 0, 5)
			InputLabel.BackgroundTransparency = 1
			InputLabel.Text = InputSettings.Name
			InputLabel.TextColor3 = AetherTheme.Text
			InputLabel.TextSize = 13
			InputLabel.Font = Enum.Font.GothamSemibold
			InputLabel.TextXAlignment = Enum.TextXAlignment.Left
			InputLabel.Parent = Input

			local InputBox = Instance.new("TextBox")
			InputBox.Size = UDim2.new(1, -20, 0, 24)
			InputBox.Position = UDim2.new(0, 10, 0, 24)
			InputBox.BackgroundColor3 = AetherTheme.Background
			InputBox.TextColor3 = AetherTheme.Text
			InputBox.PlaceholderColor3 = AetherTheme.TextMuted
			InputBox.PlaceholderText = InputSettings.PlaceholderText or ""
			InputBox.Text = ""
			InputBox.TextSize = 12
			InputBox.Font = Enum.Font.Gotham
			InputBox.BorderSizePixel = 0
			InputBox.Parent = Input

			local InputCornerBox = Instance.new("UICorner")
			InputCornerBox.CornerRadius = UDim.new(0, 6)
			InputCornerBox.Parent = InputBox

			local InputStrokeBox = Instance.new("UIStroke")
			InputStrokeBox.Color = AetherTheme.Accent
			InputStrokeBox.Thickness = 1
			InputStrokeBox.Transparency = 0.6
			InputStrokeBox.Parent = InputBox

			InputBox.FocusLost:Connect(function()
				local Success = pcall(function()
					InputSettings.Callback(InputBox.Text)
				end)
				if not Success then
					print("Aether | "..InputSettings.Name.." Error")
				end
				if InputSettings.RemoveTextAfterFocusLost then
					InputBox.Text = ""
				end
				SaveConfiguration()
			end)

			return InputBox
		end

		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown, DropdownCorner, DropdownStroke = CreateElement(TabPage, DropdownSettings.Name, UDim2.new(1, 0, 0, 45))

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Size = UDim2.new(1, -80, 1, 0)
			DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Text = DropdownSettings.Name
			DropdownLabel.TextColor3 = AetherTheme.Text
			DropdownLabel.TextSize = 13
			DropdownLabel.Font = Enum.Font.GothamSemibold
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.Parent = Dropdown

			local DropdownSelected = Instance.new("TextLabel")
			DropdownSelected.Size = UDim2.new(0, 70, 0, 25)
			DropdownSelected.Position = UDim2.new(1, -80, 0.5, -12)
			DropdownSelected.BackgroundColor3 = AetherTheme.Background
			DropdownSelected.TextColor3 = AetherTheme.Accent
			DropdownSelected.BorderSizePixel = 0
			DropdownSelected.TextSize = 11
			DropdownSelected.Font = Enum.Font.GothamMedium
			DropdownSelected.Text = (DropdownSettings.CurrentOption and DropdownSettings.CurrentOption[1]) or "None"
			DropdownSelected.Parent = Dropdown

			local DropdownCornerBox = Instance.new("UICorner")
			DropdownCornerBox.CornerRadius = UDim.new(0, 6)
			DropdownCornerBox.Parent = DropdownSelected

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Size = UDim2.new(1, 0, 1, 0)
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Text = ""
			DropdownButton.Parent = Dropdown

			local function SelectOption(OptionName)
				if not DropdownSettings.MultipleOptions then
					DropdownSettings.CurrentOption = {OptionName}
					DropdownSelected.Text = OptionName
				else
					if table.find(DropdownSettings.CurrentOption, OptionName) then
						table.remove(DropdownSettings.CurrentOption, table.find(DropdownSettings.CurrentOption, OptionName))
					else
						table.insert(DropdownSettings.CurrentOption, OptionName)
					end
					if #DropdownSettings.CurrentOption == 1 then
						DropdownSelected.Text = DropdownSettings.CurrentOption[1]
					elseif #DropdownSettings.CurrentOption == 0 then
						DropdownSelected.Text = "None"
					else
						DropdownSelected.Text = "Various"
					end
				end
				pcall(function()
					DropdownSettings.Callback(DropdownSettings.CurrentOption)
				end)
				SaveConfiguration()
			end

			DropdownButton.MouseButton1Click:Connect(function()
				Aether:Notify({Title = "Dropdown", Content = "Selected: " .. table.concat(DropdownSettings.CurrentOption, ", "), Duration = 2})
				SelectOption(DropdownSettings.Options[math.random(1, #DropdownSettings.Options)])
			end)

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and DropdownSettings.Flag then
					Aether.Flags[DropdownSettings.Flag] = DropdownSettings
				end
			end

			return DropdownSettings
		end

		function Tab:CreateKeybind(KeybindSettings)
			local Keybind, KeybindCorner, KeybindStroke = CreateElement(TabPage, KeybindSettings.Name, UDim2.new(1, 0, 0, 45))

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Size = UDim2.new(1, -80, 1, 0)
			KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Text = KeybindSettings.Name
			KeybindLabel.TextColor3 = AetherTheme.Text
			KeybindLabel.TextSize = 13
			KeybindLabel.Font = Enum.Font.GothamSemibold
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			KeybindLabel.Parent = Keybind

			local KeyDisplay = Instance.new("TextLabel")
			KeyDisplay.Size = UDim2.new(0, 70, 0, 25)
			KeyDisplay.Position = UDim2.new(1, -80, 0.5, -12)
			KeyDisplay.BackgroundColor3 = AetherTheme.Background
			KeyDisplay.TextColor3 = AetherTheme.Accent
			KeyDisplay.BorderSizePixel = 0
			KeyDisplay.TextSize = 11
			KeyDisplay.Font = Enum.Font.GothamMedium
			KeyDisplay.Text = KeybindSettings.CurrentKeybind or "NONE"
			KeyDisplay.Parent = Keybind

			local KeyDisplayCorner = Instance.new("UICorner")
			KeyDisplayCorner.CornerRadius = UDim.new(0, 6)
			KeyDisplayCorner.Parent = KeyDisplay

			local KeybindButton = Instance.new("TextButton")
			KeybindButton.Size = UDim2.new(1, 0, 1, 0)
			KeybindButton.BackgroundTransparency = 1
			KeybindButton.Text = ""
			KeybindButton.Parent = Keybind

			local AwaitingKey = false

			KeybindButton.MouseButton1Click:Connect(function()
				AwaitingKey = true
				KeyDisplay.Text = "..."
				local Connection
				Connection = UserInputService.InputBegan:Connect(function(Input)
					if Input.UserInputType == Enum.UserInputType.Keyboard and AwaitingKey then
						KeybindSettings.CurrentKeybind = tostring(Input.KeyCode):split(".")[3]
						KeyDisplay.Text = KeybindSettings.CurrentKeybind
						AwaitingKey = false
						Connection:Disconnect()
						SaveConfiguration()
					end
				end)
			end)

			UserInputService.InputBegan:Connect(function(Input)
				if not AwaitingKey and KeybindSettings.CurrentKeybind then
					if Input.KeyCode == Enum.KeyCode[KeybindSettings.CurrentKeybind] then
						pcall(function()
							if KeybindSettings.HoldToInteract then
								KeybindSettings.Callback(true)
								local HoldConnection
								HoldConnection = UserInputService.InputEnded:Connect(function(ReleaseInput)
									if ReleaseInput.KeyCode == Input.KeyCode then
										KeybindSettings.Callback(false)
										HoldConnection:Disconnect()
									end
								end)
							else
								KeybindSettings.Callback()
							end
						end)
					end
				end
			end)

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and KeybindSettings.Flag then
					Aether.Flags[KeybindSettings.Flag] = KeybindSettings
				end
			end

			return KeybindSettings
		end

		function Tab:CreateColorPicker(ColorPickerSettings)
			ColorPickerSettings.Type = "ColorPicker"
			local ColorPicker, ColorPickerCorner, ColorPickerStroke = CreateElement(TabPage, ColorPickerSettings.Name, UDim2.new(1, 0, 0, 45))

			local ColorLabel = Instance.new("TextLabel")
			ColorLabel.Size = UDim2.new(1, -70, 1, 0)
			ColorLabel.Position = UDim2.new(0, 10, 0, 0)
			ColorLabel.BackgroundTransparency = 1
			ColorLabel.Text = ColorPickerSettings.Name
			ColorLabel.TextColor3 = AetherTheme.Text
			ColorLabel.TextSize = 13
			ColorLabel.Font = Enum.Font.GothamSemibold
			ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
			ColorLabel.Parent = ColorPicker

			local ColorDisplay = Instance.new("Frame")
			ColorDisplay.Size = UDim2.new(0, 50, 0, 25)
			ColorDisplay.Position = UDim2.new(1, -60, 0.5, -12)
			ColorDisplay.BackgroundColor3 = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Parent = ColorPicker

			local ColorDisplayCorner = Instance.new("UICorner")
			ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
			ColorDisplayCorner.Parent = ColorDisplay

			local ColorDisplayStroke = Instance.new("UIStroke")
			ColorDisplayStroke.Color = AetherTheme.Accent
			ColorDisplayStroke.Thickness = 1
			ColorDisplayStroke.Transparency = 0.5
			ColorDisplayStroke.Parent = ColorDisplay

			local ColorPickerButton = Instance.new("TextButton")
			ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
			ColorPickerButton.BackgroundTransparency = 1
			ColorPickerButton.Text = ""
			ColorPickerButton.Parent = ColorPicker

			ColorPickerButton.MouseButton1Click:Connect(function()
				Aether:Notify({Title = "Color Picker", Content = "Selected: " .. ColorPickerSettings.Color:ToHex(), Duration = 2})
			end)

			function ColorPickerSettings:Set(NewColor)
				ColorPickerSettings.Color = NewColor
				ColorDisplay.BackgroundColor3 = NewColor
				pcall(function()
					ColorPickerSettings.Callback(NewColor)
				end)
				SaveConfiguration()
			end

			if Settings.ConfigurationSaving then
				if Settings.ConfigurationSaving.Enabled and ColorPickerSettings.Flag then
					Aether.Flags[ColorPickerSettings.Flag] = ColorPickerSettings
				end
			end

			return ColorPickerSettings
		end

		return Tab
	end

	return Window
end

function Aether:LoadConfiguration()
	if CEnabled then
		pcall(function()
			if isfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension) then
				LoadConfiguration(readfile(ConfigurationFolder .. "/" .. CFileName .. ConfigurationExtension))
				Aether:Notify({Title = "Configuration Loaded", Content = "Your settings have been restored"})
			end
		end)
	end
end

function Aether:Destroy()
	AetherGui:Destroy()
end

UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.K and not Hidden then
		if Hidden then
			Hidden = false
			Unhide()
		else
			Hidden = true
			Hide()
		end
	elseif Input.KeyCode == Enum.KeyCode.K and Hidden then
		Hidden = false
		Unhide()
	end
end)

task.delay(2, function()
	Aether:LoadConfiguration()
end)

return Aether
