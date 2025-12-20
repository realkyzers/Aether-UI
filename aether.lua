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
elseif syn.protect_gui then
	syn.protect_gui(AetherGui)
	AetherGui.Parent = CoreGui
elseif CoreGui:FindFirstChild("RobloxGui") then
	AetherGui.Parent = CoreGui:FindFirstChild("RobloxGui")
else
	AetherGui.Parent = CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 475)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -237)
MainFrame.BackgroundColor3 = AetherTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = AetherGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, AetherTheme.Radius)
UICorner.Parent = MainFrame

local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 45)
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
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = AetherTheme.Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

local TabList = Instance.new("Frame")
TabList.Name = "TabList"
TabList.Size = UDim2.new(1, 0, 0, 35)
TabList.Position = UDim2.new(0, 0, 0, 45)
TabList.BackgroundTransparency = 1
TabList.BorderSizePixel = 0
TabList.Parent = MainFrame

local TabScroll = Instance.new("UIListLayout")
TabScroll.FillDirection = Enum.FillDirection.Horizontal
TabScroll.Padding = UDim.new(0, 5)
TabScroll.Parent = TabList

local Elements = Instance.new("ScrollingFrame")
Elements.Name = "Elements"
Elements.Size = UDim2.new(1, 0, 1, -80)
Elements.Position = UDim2.new(0, 0, 0, 80)
Elements.BackgroundTransparency = 1
Elements.BorderSizePixel = 0
Elements.ScrollBarThickness = 6
Elements.ScrollBarImageColor3 = AetherTheme.Accent
Elements.Parent = MainFrame

local ElementsLayout = Instance.new("UIListLayout")
ElementsLayout.Padding = UDim.new(0, 8)
ElementsLayout.Parent = Elements

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = Elements

local Notifications = Instance.new("Frame")
Notifications.Name = "Notifications"
Notifications.Size = UDim2.new(1, 0, 1, 0)
Notifications.BackgroundTransparency = 1
Notifications.BorderSizePixel = 0
Notifications.Parent = AetherGui

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
		else
			Aether:Notify({Title = "Flag Error", Content = "Aether was unable to find '"..FlagName.. "' in the current script"})
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
		Notification.Size = UDim2.new(0, 280, 0, 80)
		Notification.Position = UDim2.new(0.5, 0, 0.915, 0)
		Notification.BackgroundColor3 = AetherTheme.Surface
		Notification.BorderSizePixel = 0
		Notification.BackgroundTransparency = 0.95
		Notification.Parent = Notifications

		local NotifCorner = Instance.new("UICorner")
		NotifCorner.CornerRadius = UDim.new(0, 8)
		NotifCorner.Parent = Notification

		local NotifStroke = Instance.new("UIStroke")
		NotifStroke.Color = AetherTheme.Accent
		NotifStroke.Thickness = 1
		NotifStroke.Transparency = 0.6
		NotifStroke.Parent = Notification

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Name = "Title"
		NotifTitle.Size = UDim2.new(1, -20, 0, 20)
		NotifTitle.Position = UDim2.new(0, 10, 0, 5)
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Text = NotificationSettings.Title or "Unknown"
		NotifTitle.TextColor3 = AetherTheme.Text
		NotifTitle.TextSize = 14
		NotifTitle.Font = Enum.Font.GothamBold
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.Parent = Notification

		local Description = Instance.new("TextLabel")
		Description.Name = "Description"
		Description.Size = UDim2.new(1, -20, 0, 40)
		Description.Position = UDim2.new(0, 10, 0, 28)
		Description.BackgroundTransparency = 1
		Description.Text = NotificationSettings.Content or "Unknown"
		Description.TextColor3 = AetherTheme.TextMuted
		Description.TextSize = 12
		Description.Font = Enum.Font.Gotham
		Description.TextWrapped = true
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.TextYAlignment = Enum.TextYAlignment.Top
		Description.Parent = Notification

		TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.1}):Play()
		Notification:TweenPosition(UDim2.new(0.5, -140, 0.915, 0), 'Out', 'Quint', 0.5, true)

		wait(NotificationSettings.Duration or 5)

		TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
		TweenService:Create(NotifStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Transparency = 1}):Play()
		wait(0.5)
		Notification:Destroy()
	end)
end

local function Hide()
	Debounce = true
	Aether:Notify({Title = "Interface Hidden", Content = "Press K to unhide", Duration = 3})
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
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -237)
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
		if not isfolder(AetherFolder.."/".."Configuration Folders") then
			makefolder(AetherFolder.."/".."Configuration Folders")
		end
		if Settings.ConfigurationSaving.Enabled == nil then
			Settings.ConfigurationSaving.Enabled = false
		end
		CFileName = Settings.ConfigurationSaving.FileName
		ConfigurationFolder = Settings.ConfigurationSaving.FolderName or ConfigurationFolder
		CEnabled = Settings.ConfigurationSaving.Enabled

		if Settings.ConfigurationSaving.Enabled then
			if not isfolder(ConfigurationFolder) then
				makefolder(ConfigurationFolder)
			end	
		end
	end)

	AddDraggingFunctionality(Topbar, MainFrame)

	local Window = {}
	local FirstTab = false

	function Window:CreateTab(Name, Image)
		local TabButton = Instance.new("Frame")
		TabButton.Name = Name
		TabButton.Size = UDim2.new(0, 100, 0, 30)
		TabButton.BackgroundColor3 = AetherTheme.Surface
		TabButton.BorderSizePixel = 0
		TabButton.Parent = TabList

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 6)
		TabCorner.Parent = TabButton

		local TabStroke = Instance.new("UIStroke")
		TabStroke.Color = AetherTheme.Accent
		TabStroke.Thickness = 1
		TabStroke.Transparency = 0.6
		TabStroke.Parent = TabButton

		local TabTitle = Instance.new("TextLabel")
		TabTitle.Name = "Title"
		TabTitle.Size = UDim2.new(1, -10, 1, 0)
		TabTitle.Position = UDim2.new(0, 5, 0, 0)
		TabTitle.BackgroundTransparency = 1
		TabTitle.Text = Name
		TabTitle.TextColor3 = AetherTheme.Text
		TabTitle.TextSize = 12
		TabTitle.Font = Enum.Font.GothamMedium
		TabTitle.Parent = TabButton

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = Name
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 6
		TabPage.ScrollBarImageColor3 = AetherTheme.Accent
		TabPage.Visible = FirstTab == false
		TabPage.Parent = Elements

		local TabPageLayout = Instance.new("UIListLayout")
		TabPageLayout.Padding = UDim.new(0, 8)
		TabPageLayout.Parent = TabPage

		local TabPagePadding = Instance.new("UIPadding")
		TabPagePadding.PaddingLeft = UDim.new(0, 0)
		TabPagePadding.PaddingRight = UDim.new(0, 0)
		TabPagePadding.PaddingTop = UDim.new(0, 5)
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
			local Button = Instance.new("Frame")
			Button.Name = ButtonSettings.Name
			Button.Size = UDim2.new(1, 0, 0, 40)
			Button.BackgroundColor3 = AetherTheme.Surface
			Button.BorderSizePixel = 0
			Button.Parent = TabPage

			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, 6)
			ButtonCorner.Parent = Button

			local ButtonStroke = Instance.new("UIStroke")
			ButtonStroke.Color = AetherTheme.Accent
			ButtonStroke.Thickness = 1
			ButtonStroke.Transparency = 0.5
			ButtonStroke.Parent = Button

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Text = ButtonSettings.Name
			ButtonLabel.TextColor3 = AetherTheme.Text
			ButtonLabel.TextSize = 12
			ButtonLabel.Font = Enum.Font.GothamMedium
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
					print("Aether | "..ButtonSettings.Name.." Callback Error: " ..tostring(Response))
					wait(0.5)
					TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Surface}):Play()
				else
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Accent}):Play()
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
			local Toggle = Instance.new("Frame")
			Toggle.Name = ToggleSettings.Name
			Toggle.Size = UDim2.new(1, 0, 0, 40)
			Toggle.BackgroundColor3 = AetherTheme.Surface
			Toggle.BorderSizePixel = 0
			Toggle.Parent = TabPage

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, 6)
			ToggleCorner.Parent = Toggle

			local ToggleStroke = Instance.new("UIStroke")
			ToggleStroke.Color = AetherTheme.Accent
			ToggleStroke.Thickness = 1
			ToggleStroke.Transparency = 0.5
			ToggleStroke.Parent = Toggle

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = ToggleSettings.Name
			ToggleLabel.TextColor3 = AetherTheme.Text
			ToggleLabel.TextSize = 12
			ToggleLabel.Font = Enum.Font.GothamMedium
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = Toggle

			local Switch = Instance.new("Frame")
			Switch.Name = "Switch"
			Switch.Size = UDim2.new(0, 40, 0, 20)
			Switch.Position = UDim2.new(1, -50, 0.5, -10)
			Switch.BackgroundColor3 = AetherTheme.Surface
			Switch.BorderSizePixel = 0
			Switch.Parent = Toggle

			local SwitchCorner = Instance.new("UICorner")
			SwitchCorner.CornerRadius = UDim.new(0, 10)
			SwitchCorner.Parent = Switch

			local SwitchStroke = Instance.new("UIStroke")
			SwitchStroke.Color = AetherTheme.Accent
			SwitchStroke.Thickness = 1
			SwitchStroke.Transparency = 0.4
			SwitchStroke.Parent = Switch

			local Indicator = Instance.new("Frame")
			Indicator.Name = "Indicator"
			Indicator.Size = UDim2.new(0, 16, 0, 16)
			Indicator.Position = UDim2.new(0, 2, 0.5, -8)
			Indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
			Indicator.BorderSizePixel = 0
			Indicator.Parent = Switch

			local IndicatorCorner = Instance.new("UICorner")
			IndicatorCorner.CornerRadius = UDim.new(0, 8)
			IndicatorCorner.Parent = Indicator

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Size = UDim2.new(1, 0, 1, 0)
			ToggleButton.BackgroundTransparency = 1
			ToggleButton.Text = ""
			ToggleButton.Parent = Toggle

			if ToggleSettings.CurrentValue then
				Indicator.Position = UDim2.new(0, 22, 0.5, -8)
				Indicator.BackgroundColor3 = AetherTheme.Success
			end

			ToggleButton.MouseButton1Click:Connect(function()
				ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
				
				if ToggleSettings.CurrentValue then
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Success}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
				end

				local Success, Response = pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)

				if not Success then
					print("Aether | "..ToggleSettings.Name.." Callback Error: " ..tostring(Response))
				end
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
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = AetherTheme.Success}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
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
			local Slider = Instance.new("Frame")
			Slider.Name = SliderSettings.Name
			Slider.Size = UDim2.new(1, 0, 0, 50)
			Slider.BackgroundColor3 = AetherTheme.Surface
			Slider.BorderSizePixel = 0
			Slider.Parent = TabPage

			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, 6)
			SliderCorner.Parent = Slider

			local SliderStroke = Instance.new("UIStroke")
			SliderStroke.Color = AetherTheme.Accent
			SliderStroke.Thickness = 1
			SliderStroke.Transparency = 0.5
			SliderStroke.Parent = Slider

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(1, -20, 0, 20)
			SliderLabel.Position = UDim2.new(0, 10, 0, 5)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = SliderSettings.Name
			SliderLabel.TextColor3 = AetherTheme.Text
			SliderLabel.TextSize = 12
			SliderLabel.Font = Enum.Font.GothamMedium
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = Slider

			local SliderValue = Instance.new("TextLabel")
			SliderValue.Size = UDim2.new(0, 40, 0, 20)
			SliderValue.Position = UDim2.new(1, -50, 0, 5)
			SliderValue.BackgroundTransparency = 1
			SliderValue.Text = tostring(SliderSettings.CurrentValue)
			SliderValue.TextColor3 = AetherTheme.Accent
			SliderValue.TextSize = 11
			SliderValue.Font = Enum.Font.GothamMedium
			SliderValue.Parent = Slider

			local SliderBG = Instance.new("Frame")
			SliderBG.Size = UDim2.new(1, -20, 0, 6)
			SliderBG.Position = UDim2.new(0, 10, 0, 28)
			SliderBG.BackgroundColor3 = AetherTheme.Background
			SliderBG.BorderSizePixel = 0
			SliderBG.Parent = Slider

			local SliderBGCorner = Instance.new("UICorner")
			SliderBGCorner.CornerRadius = UDim.new(0, 3)
			SliderBGCorner.Parent = SliderBG

			local SliderProgress = Instance.new("Frame")
			SliderProgress.Size = UDim2.new((SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1]), 0, 1, 0)
			SliderProgress.BackgroundColor3 = AetherTheme.Accent
			SliderProgress.BorderSizePixel = 0
			SliderProgress.Parent = SliderBG

			local ProgressCorner = Instance.new("UICorner")
			ProgressCorner.CornerRadius = UDim.new(0, 3)
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
						SliderValue.Text = tostring(NewValue)
						TweenService:Create(SliderProgress, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {Size = UDim2.new(Relative, 0, 1, 0)}):Play()
						
						local Success = pcall(function()
							SliderSettings.Callback(NewValue)
						end)
						if Success then
							SaveConfiguration()
						end
					end
				end
			end)

			function SliderSettings:Set(Value)
				SliderSettings.CurrentValue = Value
				local Ratio = (Value - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
				SliderValue.Text = tostring(Value)
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
			local Label = Instance.new("Frame")
			Label.Size = UDim2.new(1, 0, 0, 35)
			Label.BackgroundColor3 = AetherTheme.Surface
			Label.BorderSizePixel = 0
			Label.Parent = TabPage

			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, 6)
			LabelCorner.Parent = Label

			local LabelStroke = Instance.new("UIStroke")
			LabelStroke.Color = AetherTheme.Accent
			LabelStroke.Thickness = 1
			LabelStroke.Transparency = 0.6
			LabelStroke.Parent = Label

			local LabelTextObj = Instance.new("TextLabel")
			LabelTextObj.Size = UDim2.new(1, -20, 1, 0)
			LabelTextObj.Position = UDim2.new(0, 10, 0, 0)
			LabelTextObj.BackgroundTransparency = 1
			LabelTextObj.Text = LabelText
			LabelTextObj.TextColor3 = AetherTheme.TextMuted
			LabelTextObj.TextSize = 11
			LabelTextObj.Font = Enum.Font.Gotham
			LabelTextObj.TextXAlignment = Enum.TextXAlignment.Left
			LabelTextObj.Parent = Label

			return Label
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
				Aether:Notify({Title = "Configuration Loaded", Content = "Loaded previous session settings"})
			end
		end)
	end
end

function Aether:Destroy()
	AetherGui:Destroy()
end

UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.K and not Input.UserInputState == Enum.UserInputState.Begin then
		if Hidden then
			Hidden = false
			Unhide()
		else
			Hidden = true
			Hide()
		end
	end
end)

task.delay(2, function()
	Aether:LoadConfiguration()
end)

return Aether
