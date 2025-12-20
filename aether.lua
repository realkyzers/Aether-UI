--[[

Aether Interface Suite
Modern Ethereal UI Library

Redesigned with inspiration from Rayfield
Fully procedurally generated (no asset dependencies)
Xeno executor compatible

]]

local Aether = {
	Flags = {},
	Theme = {
		Default = {
			TextFont = "GothamBold",
			TextColor = Color3.fromRGB(235, 235, 240),
			
			Background = Color3.fromRGB(12, 14, 20),
			Topbar = Color3.fromRGB(16, 18, 28),
			Shadow = Color3.fromRGB(8, 10, 15),
			
			NotificationBackground = Color3.fromRGB(20, 22, 32),
			NotificationActionsBackground = Color3.fromRGB(90, 120, 255),
			
			TabBackground = Color3.fromRGB(25, 28, 42),
			TabStroke = Color3.fromRGB(60, 85, 150),
			TabBackgroundSelected = Color3.fromRGB(90, 120, 255),
			TabTextColor = Color3.fromRGB(235, 235, 240),
			SelectedTabTextColor = Color3.fromRGB(12, 14, 20),
			
			ElementBackground = Color3.fromRGB(18, 20, 30),
			ElementBackgroundHover = Color3.fromRGB(24, 27, 40),
			SecondaryElementBackground = Color3.fromRGB(14, 16, 24),
			ElementStroke = Color3.fromRGB(60, 85, 150),
			SecondaryElementStroke = Color3.fromRGB(40, 50, 90),
			
			SliderBackground = Color3.fromRGB(25, 30, 50),
			SliderProgress = Color3.fromRGB(90, 120, 255),
			SliderStroke = Color3.fromRGB(70, 100, 180),
			
			ToggleBackground = Color3.fromRGB(20, 22, 32),
			ToggleEnabled = Color3.fromRGB(80, 200, 120),
			ToggleDisabled = Color3.fromRGB(70, 75, 90),
			ToggleEnabledStroke = Color3.fromRGB(100, 220, 150),
			ToggleDisabledStroke = Color3.fromRGB(90, 95, 110),
			ToggleEnabledOuterStroke = Color3.fromRGB(60, 180, 100),
			ToggleDisabledOuterStroke = Color3.fromRGB(50, 55, 70),
			
			InputBackground = Color3.fromRGB(20, 22, 32),
			InputStroke = Color3.fromRGB(60, 85, 150),
			PlaceholderColor = Color3.fromRGB(155, 160, 180)
		}
	}
}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Variables
local AetherFolder = "Aether"
local ConfigurationFolder = AetherFolder.."/Configurations"
local ConfigurationExtension = ".aether"

local CFileName = nil
local CEnabled = false
local Minimised = false
local Hidden = false
local Debounce = false

-- Create Main GUI
local AetherGui = Instance.new("ScreenGui")
AetherGui.Name = "Aether"
AetherGui.ResetOnSpawn = false
AetherGui.DisplayOrder = 100

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

-- Duplicate check
if gethui then
	for _, Interface in ipairs(gethui():GetChildren()) do
		if Interface.Name == AetherGui.Name and Interface ~= AetherGui then
			Interface.Enabled = false
			Interface.Name = "Aether-Old"
		end
	end
else
	for _, Interface in ipairs(CoreGui:GetChildren()) do
		if Interface.Name == AetherGui.Name and Interface ~= AetherGui then
			Interface.Enabled = false
			Interface.Name = "Aether-Old"
		end
	end
end

local SelectedTheme = Aether.Theme.Default

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 700, 0, 560)
Main.Position = UDim2.new(0.5, -350, 0.5, -280)
Main.BackgroundColor3 = SelectedTheme.Background
Main.BorderSizePixel = 0
Main.Parent = AetherGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = SelectedTheme.ElementStroke
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Shadow.Parent = Main

local ShadowImage = Instance.new("ImageLabel")
ShadowImage.Name = "Image"
ShadowImage.Size = UDim2.new(1, 0, 1, 0)
ShadowImage.BackgroundTransparency = 1
ShadowImage.ImageColor3 = SelectedTheme.Shadow
ShadowImage.ImageTransparency = 0.5
ShadowImage.Image = "rbxassetid://6015897843"
ShadowImage.Parent = Shadow

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 50)
Topbar.BackgroundColor3 = SelectedTheme.Topbar
Topbar.BorderSizePixel = 0
Topbar.Parent = Main

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 12)
TopbarCorner.Parent = Topbar

local TopbarStroke = Instance.new("UIStroke")
TopbarStroke.Color = SelectedTheme.ElementStroke
TopbarStroke.Thickness = 1
TopbarStroke.Transparency = 0.5
TopbarStroke.Parent = Topbar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Aether"
Title.TextColor3 = SelectedTheme.TextColor
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

-- Control buttons (Hide, Minimize, Theme)
local ControlSize = 30
local ControlSpacing = 10

local ThemeButton = Instance.new("TextButton")
ThemeButton.Name = "Theme"
ThemeButton.Size = UDim2.new(0, ControlSize, 0, ControlSize)
ThemeButton.Position = UDim2.new(1, -(ControlSize + ControlSpacing) * 3, 0.5, -ControlSize/2)
ThemeButton.BackgroundColor3 = SelectedTheme.ElementBackground
ThemeButton.TextColor3 = SelectedTheme.TextColor
ThemeButton.TextSize = 16
ThemeButton.Font = Enum.Font.GothamBold
ThemeButton.Text = "◐"
ThemeButton.BorderSizePixel = 0
ThemeButton.Parent = Topbar

local ThemeCorner = Instance.new("UICorner")
ThemeCorner.CornerRadius = UDim.new(0, 6)
ThemeCorner.Parent = ThemeButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Size = UDim2.new(0, ControlSize, 0, ControlSize)
MinimizeButton.Position = UDim2.new(1, -(ControlSize + ControlSpacing) * 2, 0.5, -ControlSize/2)
MinimizeButton.BackgroundColor3 = SelectedTheme.ElementBackground
MinimizeButton.TextColor3 = SelectedTheme.TextColor
MinimizeButton.TextSize = 16
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = Topbar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

local HideButton = Instance.new("TextButton")
HideButton.Name = "Hide"
HideButton.Size = UDim2.new(0, ControlSize, 0, ControlSize)
HideButton.Position = UDim2.new(1, -(ControlSize + ControlSpacing), 0.5, -ControlSize/2)
HideButton.BackgroundColor3 = SelectedTheme.ElementBackground
HideButton.TextColor3 = SelectedTheme.TextColor
HideButton.TextSize = 16
HideButton.Font = Enum.Font.GothamBold
HideButton.Text = "✕"
HideButton.BorderSizePixel = 0
HideButton.Parent = Topbar

local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 6)
HideCorner.Parent = HideButton

-- Tab Bar
local TabList = Instance.new("Frame")
TabList.Name = "TabList"
TabList.Size = UDim2.new(1, 0, 0, 45)
TabList.Position = UDim2.new(0, 0, 0, 50)
TabList.BackgroundColor3 = SelectedTheme.Background
TabList.BorderSizePixel = 0
TabList.Parent = Main

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabList

local TabListPadding = Instance.new("UIPadding")
TabListPadding.PaddingLeft = UDim.new(0, 10)
TabListPadding.PaddingRight = UDim.new(0, 10)
TabListPadding.PaddingTop = UDim.new(0, 5)
TabListPadding.PaddingBottom = UDim.new(0, 5)
TabListPadding.Parent = TabList

-- Elements Container
local Elements = Instance.new("ScrollingFrame")
Elements.Name = "Elements"
Elements.Size = UDim2.new(1, 0, 1, -95)
Elements.Position = UDim2.new(0, 0, 0, 95)
Elements.BackgroundTransparency = 1
Elements.BorderSizePixel = 0
Elements.ScrollBarThickness = 8
Elements.ScrollBarImageColor3 = SelectedTheme.SliderProgress
Elements.Parent = Main

local ElementsLayout = Instance.new("UIListLayout")
ElementsLayout.Padding = UDim.new(0, 10)
ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
ElementsLayout.Parent = Elements

local ElementsPadding = Instance.new("UIPadding")
ElementsPadding.PaddingLeft = UDim.new(0, 15)
ElementsPadding.PaddingRight = UDim.new(0, 15)
ElementsPadding.PaddingTop = UDim.new(0, 10)
ElementsPadding.PaddingBottom = UDim.new(0, 10)
ElementsPadding.Parent = Elements

-- Notifications
local Notifications = Instance.new("Frame")
Notifications.Name = "Notifications"
Notifications.Size = UDim2.new(1, 0, 1, 0)
Notifications.BackgroundTransparency = 1
Notifications.BorderSizePixel = 0
Notifications.Parent = AetherGui

-- Helper Functions
local function CreateElement(Parent, Name, Size, BackgroundColor)
	local Element = Instance.new("Frame")
	Element.Name = Name
	Element.Size = Size
	Element.BackgroundColor3 = BackgroundColor or SelectedTheme.ElementBackground
	Element.BorderSizePixel = 0
	Element.Parent = Parent
	
	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Element
	
	local Stroke = Instance.new("UIStroke")
	Stroke.Color = SelectedTheme.ElementStroke
	Stroke.Thickness = 1
	Stroke.Transparency = 0.5
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
		Notification.Size = UDim2.new(0, 320, 0, 100)
		Notification.Position = UDim2.new(1, -340, 1, -120)
		Notification.BackgroundColor3 = SelectedTheme.NotificationBackground
		Notification.BorderSizePixel = 0
		Notification.Parent = Notifications

		local NotifCorner = Instance.new("UICorner")
		NotifCorner.CornerRadius = UDim.new(0, 10)
		NotifCorner.Parent = Notification

		local NotifStroke = Instance.new("UIStroke")
		NotifStroke.Color = SelectedTheme.SliderProgress
		NotifStroke.Thickness = 1.5
		NotifStroke.Transparency = 0.3
		NotifStroke.Parent = Notification

		local NotifTitle = Instance.new("TextLabel")
		NotifTitle.Name = "Title"
		NotifTitle.Size = UDim2.new(1, -20, 0, 30)
		NotifTitle.Position = UDim2.new(0, 10, 0, 8)
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Text = NotificationSettings.Title or "Unknown"
		NotifTitle.TextColor3 = SelectedTheme.SliderProgress
		NotifTitle.TextSize = 15
		NotifTitle.Font = Enum.Font.GothamBold
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.Parent = Notification

		local Description = Instance.new("TextLabel")
		Description.Name = "Description"
		Description.Size = UDim2.new(1, -20, 0, 50)
		Description.Position = UDim2.new(0, 10, 0, 40)
		Description.BackgroundTransparency = 1
		Description.Text = NotificationSettings.Content or "Unknown"
		Description.TextColor3 = SelectedTheme.PlaceholderColor
		Description.TextSize = 12
		Description.Font = Enum.Font.Gotham
		Description.TextWrapped = true
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.Parent = Notification

		TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -340, 1, -120)}):Play()

		wait(NotificationSettings.Duration or 6.5)

		TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(1, -320, 1, -120)}):Play()
		wait(0.3)
		Notification:Destroy()
	end)
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

	AddDraggingFunctionality(Topbar, Main)

	local Window = {}
	local FirstTab = false
	local TabCount = 0

	function Window:CreateTab(Name, Image)
		TabCount = TabCount + 1
		
		local TabButton = Instance.new("TextButton")
		TabButton.Name = Name
		TabButton.Size = UDim2.new(0, 140, 0, 35)
		TabButton.BackgroundColor3 = SelectedTheme.TabBackground
		TabButton.TextColor3 = SelectedTheme.TabTextColor
		TabButton.Text = Name
		TabButton.TextSize = 13
		TabButton.Font = Enum.Font.GothamSemibold
		TabButton.BorderSizePixel = 0
		TabButton.LayoutOrder = TabCount
		TabButton.Parent = TabList

		local TabCorner = Instance.new("UICorner")
		TabCorner.CornerRadius = UDim.new(0, 8)
		TabCorner.Parent = TabButton

		local TabStroke = Instance.new("UIStroke")
		TabStroke.Color = SelectedTheme.TabStroke
		TabStroke.Thickness = 1
		TabStroke.Parent = TabButton

		local TabPage = Instance.new("ScrollingFrame")
		TabPage.Name = Name .. "Page"
		TabPage.Size = UDim2.new(1, 0, 1, 0)
		TabPage.BackgroundTransparency = 1
		TabPage.BorderSizePixel = 0
		TabPage.ScrollBarThickness = 8
		TabPage.ScrollBarImageColor3 = SelectedTheme.SliderProgress
		TabPage.Visible = FirstTab == false
		TabPage.LayoutOrder = TabCount
		TabPage.Parent = Elements

		local TabPageLayout = Instance.new("UIListLayout")
		TabPageLayout.Padding = UDim.new(0, 8)
		TabPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		TabPageLayout.Parent = TabPage

		local TabPagePadding = Instance.new("UIPadding")
		TabPagePadding.PaddingLeft = UDim.new(0, 0)
		TabPagePadding.PaddingRight = UDim.new(0, 0)
		TabPagePadding.PaddingTop = UDim.new(0, 5)
		TabPagePadding.Parent = TabPage

		if FirstTab == false then
			FirstTab = Name
			TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.TabBackgroundSelected, TextColor3 = SelectedTheme.SelectedTabTextColor}):Play()
		end

		TabButton.MouseButton1Click:Connect(function()
			if Debounce then return end
			Debounce = true

			for _, OtherTab in ipairs(TabList:GetChildren()) do
				if OtherTab:IsA("TextButton") then
					TweenService:Create(OtherTab, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.TabBackground, TextColor3 = SelectedTheme.TabTextColor}):Play()
				end
			end

			for _, OtherPage in ipairs(Elements:GetChildren()) do
				if OtherPage:IsA("ScrollingFrame") then
					OtherPage.Visible = false
				end
			end

			TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.TabBackgroundSelected, TextColor3 = SelectedTheme.SelectedTabTextColor}):Play()
			TabPage.Visible = true

			wait(0.2)
			Debounce = false
		end)

		local Tab = {}

		function Tab:CreateButton(ButtonSettings)
			local Button, ButtonCorner, ButtonStroke = CreateElement(TabPage, ButtonSettings.Name, UDim2.new(1, 0, 0, 42))

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
			ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Text = ButtonSettings.Name
			ButtonLabel.TextColor3 = SelectedTheme.TextColor
			ButtonLabel.TextSize = 13
			ButtonLabel.Font = Enum.Font.GothamSemibold
			ButtonLabel.TextXAlignment = Enum.TextXAlignment.Center
			ButtonLabel.Parent = Button

			local ButtonInteract = Instance.new("TextButton")
			ButtonInteract.Size = UDim2.new(1, 0, 1, 0)
			ButtonInteract.BackgroundTransparency = 1
			ButtonInteract.Text = ""
			ButtonInteract.Parent = Button

			ButtonInteract.MouseButton1Click:Connect(function()
				local Success, Response = pcall(ButtonSettings.Callback)
				if not Success then
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = Color3.fromRGB(240, 100, 100)}):Play()
					print("Aether | " .. ButtonSettings.Name .. " Error: " .. tostring(Response))
					wait(0.5)
					TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
				else
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.SliderProgress}):Play()
					wait(0.1)
					TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
					SaveConfiguration()
				end
			end)

			Button.MouseEnter:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ElementBackgroundHover}):Play()
			end)

			Button.MouseLeave:Connect(function()
				TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ElementBackground}):Play()
			end)

			return Button
		end

		function Tab:CreateToggle(ToggleSettings)
			local Toggle, ToggleCorner, ToggleStroke = CreateElement(TabPage, ToggleSettings.Name, UDim2.new(1, 0, 0, 45))

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
			ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Text = ToggleSettings.Name
			ToggleLabel.TextColor3 = SelectedTheme.TextColor
			ToggleLabel.TextSize = 13
			ToggleLabel.Font = Enum.Font.GothamSemibold
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.Parent = Toggle

			local Switch = Instance.new("Frame")
			Switch.Name = "Switch"
			Switch.Size = UDim2.new(0, 50, 0, 26)
			Switch.Position = UDim2.new(1, -60, 0.5, -13)
			Switch.BackgroundColor3 = SelectedTheme.ToggleBackground
			Switch.BorderSizePixel = 0
			Switch.Parent = Toggle

			local SwitchCorner = Instance.new("UICorner")
			SwitchCorner.CornerRadius = UDim.new(0, 13)
			SwitchCorner.Parent = Switch

			local SwitchStroke = Instance.new("UIStroke")
			SwitchStroke.Color = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabledStroke or SelectedTheme.ToggleDisabledStroke
			SwitchStroke.Thickness = 1.5
			SwitchStroke.Parent = Switch

			local Indicator = Instance.new("Frame")
			Indicator.Name = "Indicator"
			Indicator.Size = UDim2.new(0, 22, 0, 22)
			Indicator.Position = ToggleSettings.CurrentValue and UDim2.new(0, 24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
			Indicator.BackgroundColor3 = ToggleSettings.CurrentValue and SelectedTheme.ToggleEnabled or SelectedTheme.ToggleDisabled
			Indicator.BorderSizePixel = 0
			Indicator.Parent = Switch

			local IndicatorCorner = Instance.new("UICorner")
			IndicatorCorner.CornerRadius = UDim.new(0, 11)
			IndicatorCorner.Parent = Indicator

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Size = UDim2.new(1, 0, 1, 0)
			ToggleButton.BackgroundTransparency = 1
			ToggleButton.Text = ""
			ToggleButton.Parent = Toggle

			ToggleButton.MouseButton1Click:Connect(function()
				ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue

				if ToggleSettings.CurrentValue then
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 24, 0.5, -11)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ToggleEnabled}):Play()
					TweenService:Create(SwitchStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Color = SelectedTheme.ToggleEnabledStroke}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ToggleDisabled}):Play()
					TweenService:Create(SwitchStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Color = SelectedTheme.ToggleDisabledStroke}):Play()
				end

				pcall(function()
					ToggleSettings.Callback(ToggleSettings.CurrentValue)
				end)
				SaveConfiguration()
			end)

			function ToggleSettings:Set(Value)
				ToggleSettings.CurrentValue = Value
				if Value then
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 24, 0.5, -11)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ToggleEnabled}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
					TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundColor3 = SelectedTheme.ToggleDisabled}):Play()
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
			local Slider, SliderCorner, SliderStroke = CreateElement(TabPage, SliderSettings.Name, UDim2.new(1, 0, 0, 65))

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Size = UDim2.new(1, -20, 0, 20)
			SliderLabel.Position = UDim2.new(0, 10, 0, 8)
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Text = SliderSettings.Name
			SliderLabel.TextColor3 = SelectedTheme.TextColor
			SliderLabel.TextSize = 13
			SliderLabel.Font = Enum.Font.GothamSemibold
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
			SliderLabel.Parent = Slider

			local SliderValue = Instance.new("TextLabel")
			SliderValue.Size = UDim2.new(0, 60, 0, 20)
			SliderValue.Position = UDim2.new(1, -70, 0, 8)
			SliderValue.BackgroundTransparency = 1
			SliderValue.Text = tostring(SliderSettings.CurrentValue)
			SliderValue.TextColor3 = SelectedTheme.SliderProgress
			SliderValue.TextSize = 12
			SliderValue.Font = Enum.Font.GothamBold
			SliderValue.Parent = Slider

			local SliderBG = Instance.new("Frame")
			SliderBG.Size = UDim2.new(1, -20, 0, 10)
			SliderBG.Position = UDim2.new(0, 10, 0, 35)
			SliderBG.BackgroundColor3 = SelectedTheme.SliderBackground
			SliderBG.BorderSizePixel = 0
			SliderBG.Parent = Slider

			local SliderBGCorner = Instance.new("UICorner")
			SliderBGCorner.CornerRadius = UDim.new(0, 5)
			SliderBGCorner.Parent = SliderBG

			local SliderProgress = Instance.new("Frame")
			SliderProgress.Size = UDim2.new((SliderSettings.CurrentValue - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1]), 0, 1, 0)
			SliderProgress.BackgroundColor3 = SelectedTheme.SliderProgress
			SliderProgress.BorderSizePixel = 0
			SliderProgress.Parent = SliderBG

			local ProgressCorner = Instance.new("UICorner")
			ProgressCorner.CornerRadius = UDim.new(0, 5)
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
						TweenService:Create(SliderProgress, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {Size = UDim2.new(Relative, 0, 1, 0)}):Play()

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
			local Label, LabelCorner, LabelStroke = CreateElement(TabPage, "Label", UDim2.new(1, 0, 0, 35), SelectedTheme.SecondaryElementBackground)

			LabelStroke.Color = SelectedTheme.SecondaryElementStroke

			local LabelTextObj = Instance.new("TextLabel")
			LabelTextObj.Size = UDim2.new(1, -20, 1, 0)
			LabelTextObj.Position = UDim2.new(0, 10, 0, 0)
			LabelTextObj.BackgroundTransparency = 1
			LabelTextObj.Text = LabelText
			LabelTextObj.TextColor3 = SelectedTheme.PlaceholderColor
			LabelTextObj.TextSize = 12
			LabelTextObj.Font = Enum.Font.Gotham
			LabelTextObj.TextXAlignment = Enum.TextXAlignment.Left
			LabelTextObj.TextYAlignment = Enum.TextYAlignment.Center
			LabelTextObj.Parent = Label

			return Label
		end

		function Tab:CreateParagraph(ParagraphSettings)
			local Paragraph, ParagraphCorner, ParagraphStroke = CreateElement(TabPage, "Paragraph", UDim2.new(1, 0, 0, 75), SelectedTheme.SecondaryElementBackground)

			ParagraphStroke.Color = SelectedTheme.SecondaryElementStroke

			local ParagraphTitle = Instance.new("TextLabel")
			ParagraphTitle.Size = UDim2.new(1, -20, 0, 25)
			ParagraphTitle.Position = UDim2.new(0, 10, 0, 5)
			ParagraphTitle.BackgroundTransparency = 1
			ParagraphTitle.Text = ParagraphSettings.Title or "Title"
			ParagraphTitle.TextColor3 = SelectedTheme.TextColor
			ParagraphTitle.TextSize = 13
			ParagraphTitle.Font = Enum.Font.GothamSemibold
			ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphTitle.Parent = Paragraph

			local ParagraphContent = Instance.new("TextLabel")
			ParagraphContent.Size = UDim2.new(1, -20, 0, 45)
			ParagraphContent.Position = UDim2.new(0, 10, 0, 30)
			ParagraphContent.BackgroundTransparency = 1
			ParagraphContent.Text = ParagraphSettings.Content or "Content"
			ParagraphContent.TextColor3 = SelectedTheme.PlaceholderColor
			ParagraphContent.TextSize = 11
			ParagraphContent.Font = Enum.Font.Gotham
			ParagraphContent.TextWrapped = true
			ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
			ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
			ParagraphContent.Parent = Paragraph

			return Paragraph
		end

		function Tab:CreateSection(SectionName)
			local Section = Instance.new("Frame")
			Section.Name = SectionName
			Section.Size = UDim2.new(1, 0, 0, 40)
			Section.BackgroundTransparency = 1
			Section.BorderSizePixel = 0
			Section.Parent = TabPage

			local SectionTitle = Instance.new("TextLabel")
			SectionTitle.Size = UDim2.new(1, -20, 0, 20)
			SectionTitle.Position = UDim2.new(0, 10, 0, 5)
			SectionTitle.BackgroundTransparency = 1
			SectionTitle.Text = SectionName
			SectionTitle.TextColor3 = SelectedTheme.SliderProgress
			SectionTitle.TextSize = 14
			SectionTitle.Font = Enum.Font.GothamBold
			SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
			SectionTitle.Parent = Section

			local Divider = Instance.new("Frame")
			Divider.Size = UDim2.new(1, -20, 0, 1)
			Divider.Position = UDim2.new(0, 10, 0, 30)
			Divider.BackgroundColor3 = SelectedTheme.ElementStroke
			Divider.BorderSizePixel = 0
			Divider.Parent = Section

			return Section
		end

		function Tab:CreateInput(InputSettings)
			local Input, InputCorner, InputStroke = CreateElement(TabPage, InputSettings.Name, UDim2.new(1, 0, 0, 55))

			local InputLabel = Instance.new("TextLabel")
			InputLabel.Size = UDim2.new(1, -20, 0, 18)
			InputLabel.Position = UDim2.new(0, 10, 0, 5)
			InputLabel.BackgroundTransparency = 1
			InputLabel.Text = InputSettings.Name
			InputLabel.TextColor3 = SelectedTheme.TextColor
			InputLabel.TextSize = 13
			InputLabel.Font = Enum.Font.GothamSemibold
			InputLabel.TextXAlignment = Enum.TextXAlignment.Left
			InputLabel.Parent = Input

			local InputBox = Instance.new("TextBox")
			InputBox.Size = UDim2.new(1, -20, 0, 28)
			InputBox.Position = UDim2.new(0, 10, 0, 25)
			InputBox.BackgroundColor3 = SelectedTheme.InputBackground
			InputBox.TextColor3 = SelectedTheme.TextColor
			InputBox.PlaceholderColor3 = SelectedTheme.PlaceholderColor
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
			InputStrokeBox.Color = SelectedTheme.InputStroke
			InputStrokeBox.Thickness = 1
			InputStrokeBox.Transparency = 0.5
			InputStrokeBox.Parent = InputBox

			InputBox.FocusLost:Connect(function()
				local Success = pcall(function()
					InputSettings.Callback(InputBox.Text)
				end)
				if not Success then
					print("Aether | " .. InputSettings.Name .. " Error")
				end
				if InputSettings.RemoveTextAfterFocusLost then
					InputBox.Text = ""
				end
				SaveConfiguration()
			end)

			return InputBox
		end

		function Tab:CreateDropdown(DropdownSettings)
			local Dropdown, DropdownCorner, DropdownStroke = CreateElement(TabPage, DropdownSettings.Name, UDim2.new(1, 0, 0, 48))

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Size = UDim2.new(1, -90, 1, 0)
			DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Text = DropdownSettings.Name
			DropdownLabel.TextColor3 = SelectedTheme.TextColor
			DropdownLabel.TextSize = 13
			DropdownLabel.Font = Enum.Font.GothamSemibold
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.Parent = Dropdown

			local DropdownSelected = Instance.new("TextLabel")
			DropdownSelected.Size = UDim2.new(0, 75, 0, 28)
			DropdownSelected.Position = UDim2.new(1, -85, 0.5, -14)
			DropdownSelected.BackgroundColor3 = SelectedTheme.InputBackground
			DropdownSelected.TextColor3 = SelectedTheme.SliderProgress
			DropdownSelected.BorderSizePixel = 0
			DropdownSelected.TextSize = 12
			DropdownSelected.Font = Enum.Font.GothamMedium
			DropdownSelected.Text = (DropdownSettings.CurrentOption and DropdownSettings.CurrentOption[1]) or "Select"
			DropdownSelected.Parent = Dropdown

			local DropdownCornerBox = Instance.new("UICorner")
			DropdownCornerBox.CornerRadius = UDim.new(0, 6)
			DropdownCornerBox.Parent = DropdownSelected

			local DropdownStrokeBox = Instance.new("UIStroke")
			DropdownStrokeBox.Color = SelectedTheme.InputStroke
			DropdownStrokeBox.Thickness = 1
			DropdownStrokeBox.Transparency = 0.5
			DropdownStrokeBox.Parent = DropdownSelected

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
			local Keybind, KeybindCorner, KeybindStroke = CreateElement(TabPage, KeybindSettings.Name, UDim2.new(1, 0, 0, 48))

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
			KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Text = KeybindSettings.Name
			KeybindLabel.TextColor3 = SelectedTheme.TextColor
			KeybindLabel.TextSize = 13
			KeybindLabel.Font = Enum.Font.GothamSemibold
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
			KeybindLabel.Parent = Keybind

			local KeyDisplay = Instance.new("TextLabel")
			KeyDisplay.Size = UDim2.new(0, 75, 0, 28)
			KeyDisplay.Position = UDim2.new(1, -85, 0.5, -14)
			KeyDisplay.BackgroundColor3 = SelectedTheme.InputBackground
			KeyDisplay.TextColor3 = SelectedTheme.SliderProgress
			KeyDisplay.BorderSizePixel = 0
			KeyDisplay.TextSize = 12
			KeyDisplay.Font = Enum.Font.GothamMedium
			KeyDisplay.Text = KeybindSettings.CurrentKeybind or "NONE"
			KeyDisplay.Parent = Keybind

			local KeyDisplayCorner = Instance.new("UICorner")
			KeyDisplayCorner.CornerRadius = UDim.new(0, 6)
			KeyDisplayCorner.Parent = KeyDisplay

			local KeyDisplayStroke = Instance.new("UIStroke")
			KeyDisplayStroke.Color = SelectedTheme.InputStroke
			KeyDisplayStroke.Thickness = 1
			KeyDisplayStroke.Transparency = 0.5
			KeyDisplayStroke.Parent = KeyDisplay

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
			local ColorPicker, ColorPickerCorner, ColorPickerStroke = CreateElement(TabPage, ColorPickerSettings.Name, UDim2.new(1, 0, 0, 48))

			local ColorLabel = Instance.new("TextLabel")
			ColorLabel.Size = UDim2.new(1, -80, 1, 0)
			ColorLabel.Position = UDim2.new(0, 10, 0, 0)
			ColorLabel.BackgroundTransparency = 1
			ColorLabel.Text = ColorPickerSettings.Name
			ColorLabel.TextColor3 = SelectedTheme.TextColor
			ColorLabel.TextSize = 13
			ColorLabel.Font = Enum.Font.GothamSemibold
			ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
			ColorLabel.Parent = ColorPicker

			local ColorDisplay = Instance.new("Frame")
			ColorDisplay.Size = UDim2.new(0, 60, 0, 28)
			ColorDisplay.Position = UDim2.new(1, -70, 0.5, -14)
			ColorDisplay.BackgroundColor3 = ColorPickerSettings.Color or Color3.fromRGB(255, 255, 255)
			ColorDisplay.BorderSizePixel = 0
			ColorDisplay.Parent = ColorPicker

			local ColorDisplayCorner = Instance.new("UICorner")
			ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
			ColorDisplayCorner.Parent = ColorDisplay

			local ColorDisplayStroke = Instance.new("UIStroke")
			ColorDisplayStroke.Color = SelectedTheme.InputStroke
			ColorDisplayStroke.Thickness = 1.5
			ColorDisplayStroke.Parent = ColorDisplay

			local ColorPickerButton = Instance.new("TextButton")
			ColorPickerButton.Size = UDim2.new(1, 0, 1, 0)
			ColorPickerButton.BackgroundTransparency = 1
			ColorPickerButton.Text = ""
			ColorPickerButton.Parent = ColorPicker

			ColorPickerButton.MouseButton1Click:Connect(function()
				Aether:Notify({Title = "Color", Content = "Color: " .. ColorPickerSettings.Color:ToHex(), Duration = 3})
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
				Aether:Notify({Title = "Configuration", Content = "Settings loaded successfully"})
			end
		end)
	end
end

function Aether:Destroy()
	AetherGui:Destroy()
end

-- Button Click Handlers
HideButton.MouseButton1Click:Connect(function()
	Hidden = not Hidden
	Main.Visible = not Hidden
end)

MinimizeButton.MouseButton1Click:Connect(function()
	Minimised = not Minimised
	Elements.Visible = not Minimised
	TabList.Visible = not Minimised
end)

ThemeButton.MouseButton1Click:Connect(function()
	Aether:Notify({Title = "Theme", Content = "Theme system coming soon!"})
end)

-- K key hide/unhide
UserInputService.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.K then
		Hidden = not Hidden
		Main.Visible = not Hidden
	end
end)

-- Load config after delay
task.delay(2, function()
	Aether:LoadConfiguration()
end)

return Aether
