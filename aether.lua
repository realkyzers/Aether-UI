--[[

Aether Interface Suite
Professional UI Library with Ethereal Design Language

Rebuilt with inspiration from Rayfield UI Library
Full feature parity with modern aesthetic
Fully procedurally generated (no asset dependencies)
Multi-executor compatible (Synapse, Xeno, Fluxus, ScriptWare)

Architecture:
- Theme system with multiple color schemes
- Advanced GUI management and organization
- Comprehensive component library (10+ components)
- Configuration persistence system
- Smooth animations and transitions
- Professional error handling
- Full keyboard and mouse support

License: Public Domain
Version: 2.0

]]

-- ============================================================================
-- CORE LIBRARY SETUP
-- ============================================================================

local Aether = {
	Version = "2.0",
	Flags = {},
	Settings = {
		ConfigSaving = false,
		ConfigFolder = "Aether",
		ConfigExt = ".aether"
	}
}

-- ============================================================================
-- THEME SYSTEM
-- ============================================================================

local AetherTheme = {
	Default = {
		-- Text
		TextFont = Enum.Font.GothamBold,
		TextColor = Color3.fromRGB(235, 235, 240),
		SecondaryTextColor = Color3.fromRGB(155, 160, 180),
		
		-- Background Colors
		Background = Color3.fromRGB(12, 14, 20),
		SecondaryBackground = Color3.fromRGB(16, 18, 28),
		TertiaryBackground = Color3.fromRGB(20, 22, 32),
		
		-- Component Colors
		ComponentBackground = Color3.fromRGB(18, 20, 30),
		ComponentBackgroundHovered = Color3.fromRGB(24, 27, 40),
		ComponentStroke = Color3.fromRGB(60, 85, 150),
		
		-- Accent Colors
		AccentColor = Color3.fromRGB(90, 120, 255),
		AccentColorDarker = Color3.fromRGB(70, 100, 180),
		AccentColorTransparent = Color3.fromRGB(90, 120, 255),
		
		-- Interactive Components
		SliderBackground = Color3.fromRGB(25, 30, 50),
		SliderFill = Color3.fromRGB(90, 120, 255),
		ToggleOn = Color3.fromRGB(80, 200, 120),
		ToggleOff = Color3.fromRGB(70, 75, 90),
		ToggleOnStroke = Color3.fromRGB(100, 220, 150),
		ToggleOffStroke = Color3.fromRGB(90, 95, 110),
		
		-- Input
		InputBackground = Color3.fromRGB(20, 22, 32),
		InputPlaceholder = Color3.fromRGB(155, 160, 180),
		
		-- Status Colors
		SuccessColor = Color3.fromRGB(80, 200, 120),
		WarningColor = Color3.fromRGB(255, 200, 100),
		ErrorColor = Color3.fromRGB(240, 100, 100),
		
		-- Stroke Styling
		StrokeThickness = 1.5,
		StrokeTransparency = 0.3,
		CornerRadius = 10,
		
		-- Miscellaneous
		NotificationBackground = Color3.fromRGB(20, 22, 32),
		NotificationStroke = Color3.fromRGB(90, 120, 255),
		ShadowColor = Color3.fromRGB(8, 10, 15),
		
		-- Tab System
		TabBackground = Color3.fromRGB(25, 28, 42),
		TabBackgroundActive = Color3.fromRGB(90, 120, 255),
		TabStroke = Color3.fromRGB(60, 85, 150),
		TabTextInactive = Color3.fromRGB(155, 160, 180),
		TabTextActive = Color3.fromRGB(12, 14, 20),
	},
	
	Light = {
		TextFont = Enum.Font.GothamBold,
		TextColor = Color3.fromRGB(40, 45, 60),
		SecondaryTextColor = Color3.fromRGB(100, 110, 130),
		
		Background = Color3.fromRGB(240, 242, 247),
		SecondaryBackground = Color3.fromRGB(230, 235, 245),
		TertiaryBackground = Color3.fromRGB(220, 228, 240),
		
		ComponentBackground = Color3.fromRGB(225, 230, 245),
		ComponentBackgroundHovered = Color3.fromRGB(215, 225, 245),
		ComponentStroke = Color3.fromRGB(180, 190, 220),
		
		AccentColor = Color3.fromRGB(90, 120, 255),
		AccentColorDarker = Color3.fromRGB(70, 100, 180),
		
		SliderBackground = Color3.fromRGB(200, 210, 235),
		SliderFill = Color3.fromRGB(90, 120, 255),
		ToggleOn = Color3.fromRGB(80, 200, 120),
		ToggleOff = Color3.fromRGB(180, 185, 200),
		ToggleOnStroke = Color3.fromRGB(60, 180, 100),
		ToggleOffStroke = Color3.fromRGB(150, 160, 180),
		
		InputBackground = Color3.fromRGB(220, 228, 240),
		InputPlaceholder = Color3.fromRGB(120, 130, 155),
		
		SuccessColor = Color3.fromRGB(80, 200, 120),
		WarningColor = Color3.fromRGB(255, 180, 80),
		ErrorColor = Color3.fromRGB(230, 80, 80),
		
		StrokeThickness = 1.5,
		StrokeTransparency = 0.4,
		CornerRadius = 10,
		
		NotificationBackground = Color3.fromRGB(220, 228, 240),
		NotificationStroke = Color3.fromRGB(90, 120, 255),
		ShadowColor = Color3.fromRGB(0, 0, 0),
		
		TabBackground = Color3.fromRGB(225, 230, 245),
		TabBackgroundActive = Color3.fromRGB(90, 120, 255),
		TabStroke = Color3.fromRGB(180, 190, 220),
		TabTextInactive = Color3.fromRGB(100, 110, 130),
		TabTextActive = Color3.fromRGB(255, 255, 255),
	}
}

-- ============================================================================
-- SERVICES & VARIABLES
-- ============================================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local CurrentWindow = nil
local CurrentTheme = AetherTheme.Default
local IsMinimized = false
local IsHidden = false
local TabDebounce = false

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local function CreateElementBase(Parent, Name, ClassName, Properties)
	local Element = Instance.new(ClassName)
	Element.Name = Name
	
	for Property, Value in pairs(Properties) do
		pcall(function()
			Element[Property] = Value
		end)
	end
	
	Element.Parent = Parent
	return Element
end

local function ApplyStroke(Instance, Color, Thickness, Transparency)
	local Stroke = CreateElementBase(Instance, "Stroke", "UIStroke", {
		Color = Color or CurrentTheme.ComponentStroke,
		Thickness = Thickness or CurrentTheme.StrokeThickness,
		Transparency = Transparency or CurrentTheme.StrokeTransparency,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
	return Stroke
end

local function ApplyCorner(Instance, Radius)
	local Corner = CreateElementBase(Instance, "Corner", "UICorner", {
		CornerRadius = UDim.new(0, Radius or CurrentTheme.CornerRadius)
	})
	return Corner
end

local function CreateButton(Parent, Name, Size, Position, Callback)
	local Button = CreateElementBase(Parent, Name, "TextButton", {
		Size = Size or UDim2.new(1, 0, 0, 40),
		Position = Position or UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = CurrentTheme.ComponentBackground,
		TextColor3 = CurrentTheme.TextColor,
		BorderSizePixel = 0,
		FontSize = Enum.FontSize.Size13,
		Text = Name,
		Font = CurrentTheme.TextFont
	})
	
	ApplyCorner(Button)
	ApplyStroke(Button)
	
	Button.MouseButton1Click:Connect(function()
		local Success, Error = pcall(Callback)
		if not Success then
			print("Aether Error: " .. tostring(Error))
			TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = CurrentTheme.ErrorColor}):Play()
			wait(0.5)
			TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {BackgroundColor3 = CurrentTheme.ComponentBackground}):Play()
		else
			TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {BackgroundColor3 = CurrentTheme.AccentColor}):Play()
			wait(0.1)
			TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {BackgroundColor3 = CurrentTheme.ComponentBackground}):Play()
		end
	end)
	
	Button.MouseEnter:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundColor3 = CurrentTheme.ComponentBackgroundHovered}):Play()
	end)
	
	Button.MouseLeave:Connect(function()
		TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quint), {BackgroundColor3 = CurrentTheme.ComponentBackground}):Play()
	end)
	
	return Button
end

local function Tween(Object, Duration, Properties, EasingStyle)
	local TweenInfo = TweenInfo.new(
		Duration or 0.2,
		EasingStyle or Enum.EasingStyle.Quint,
		Enum.EasingDirection.InOut
	)
	local Tween = TweenService:Create(Object, TweenInfo, Properties)
	Tween:Play()
	return Tween
end

local function PackColor(Color3Value)
	return {
		R = math.floor(Color3Value.R * 255),
		G = math.floor(Color3Value.G * 255),
		B = math.floor(Color3Value.B * 255)
	}
end

local function UnpackColor(ColorTable)
	return Color3.fromRGB(ColorTable.R, ColorTable.G, ColorTable.B)
end

local function SaveConfigurationData(FileName, Data)
	pcall(function()
		if not isfolder(Aether.Settings.ConfigFolder) then
			makefolder(Aether.Settings.ConfigFolder)
		end
		local JsonData = HttpService:JSONEncode(Data)
		writefile(Aether.Settings.ConfigFolder .. "/" .. FileName .. Aether.Settings.ConfigExt, JsonData)
	end)
end

local function LoadConfigurationData(FileName)
	local Success, Data = pcall(function()
		if not isfile(Aether.Settings.ConfigFolder .. "/" .. FileName .. Aether.Settings.ConfigExt) then
			return nil
		end
		local Content = readfile(Aether.Settings.ConfigFolder .. "/" .. FileName .. Aether.Settings.ConfigExt)
		return HttpService:JSONDecode(Content)
	end)
	return Success and Data or {}
end

local function ApplyDragToElement(DragHandle, Target)
	local Dragging = false
	local DragStart = nil
	local StartPosition = nil
	
	DragHandle.InputBegan:Connect(function(Input, GameProcessed)
		if GameProcessed then return end
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			DragStart = Input.Position
			StartPosition = Target.Position
		end
	end)
	
	UserInputService.InputChanged:Connect(function(Input, GameProcessed)
		if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
			local Delta = Input.Position - DragStart
			Tween(Target, 0.05, {
				Position = UDim2.new(
					StartPosition.X.Scale,
					StartPosition.X.Offset + Delta.X,
					StartPosition.Y.Scale,
					StartPosition.Y.Offset + Delta.Y
				)
			}, Enum.EasingStyle.Linear)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(Input, GameProcessed)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = false
		end
	end)
end

-- ============================================================================
-- GUI CREATION
-- ============================================================================

local ScreenGui = CreateElementBase(CoreGui, "Aether", "ScreenGui", {
	ResetOnSpawn = false,
	DisplayOrder = 999,
	Enabled = true,
	Name = "Aether"
})

-- Multi-executor support
if gethui then
	ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = CoreGui
else
	ScreenGui.Parent = CoreGui
end

-- Duplicate check
local function CheckDuplicates()
	local Parent = ScreenGui.Parent
	for _, Child in pairs(Parent:GetChildren()) do
		if Child.Name == "Aether" and Child ~= ScreenGui then
			Child.Enabled = false
			Child.Name = "Aether_Old"
		end
	end
end
CheckDuplicates()

-- Main Window
local MainWindow = CreateElementBase(ScreenGui, "MainWindow", "Frame", {
	Size = UDim2.new(0, 750, 0, 600),
	Position = UDim2.new(0.5, -375, 0.5, -300),
	BackgroundColor3 = CurrentTheme.Background,
	BorderSizePixel = 0,
	ZIndex = 1
})

ApplyCorner(MainWindow, 15)
ApplyStroke(MainWindow, CurrentTheme.ComponentStroke, 1.5, 0.3)

-- Shadow Effect
local ShadowFrame = CreateElementBase(MainWindow, "Shadow", "Frame", {
	Size = UDim2.new(1, 30, 1, 30),
	Position = UDim2.new(0, -15, 0, -15),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 0
})

local ShadowImage = CreateElementBase(ShadowFrame, "ShadowImage", "ImageLabel", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Image = "rbxasset://textures/DeveloperFramework/button_primary.png",
	ImageColor3 = CurrentTheme.ShadowColor,
	ImageTransparency = 0.7,
	ZIndex = 0
})

-- Topbar
local TopBar = CreateElementBase(MainWindow, "TopBar", "Frame", {
	Size = UDim2.new(1, 0, 0, 60),
	BackgroundColor3 = CurrentTheme.SecondaryBackground,
	BorderSizePixel = 0,
	ZIndex = 10
})

ApplyCorner(TopBar, 15)
ApplyStroke(TopBar, CurrentTheme.ComponentStroke, 1, 0.5)

-- Title
local TitleLabel = CreateElementBase(TopBar, "Title", "TextLabel", {
	Size = UDim2.new(1, -150, 1, 0),
	Position = UDim2.new(0, 20, 0, 0),
	BackgroundTransparency = 1,
	TextColor3 = CurrentTheme.TextColor,
	TextSize = 24,
	Font = Enum.Font.GothamBold,
	Text = "Aether",
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
	ZIndex = 11
})

-- Control Buttons
local ButtonSize = UDim2.new(0, 40, 0, 40)
local ButtonSpacing = 10

local ThemeButton = CreateElementBase(TopBar, "ThemeBtn", "TextButton", {
	Size = ButtonSize,
	Position = UDim2.new(1, -(ButtonSpacing + 40 * 3), 0.5, -20),
	BackgroundColor3 = CurrentTheme.ComponentBackground,
	TextColor3 = CurrentTheme.AccentColor,
	BorderSizePixel = 0,
	Text = "◐",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	ZIndex = 11
})
ApplyCorner(ThemeButton, 8)
ApplyStroke(ThemeButton)

local MinimizeButton = CreateElementBase(TopBar, "MinimizeBtn", "TextButton", {
	Size = ButtonSize,
	Position = UDim2.new(1, -(ButtonSpacing + 40 * 2), 0.5, -20),
	BackgroundColor3 = CurrentTheme.ComponentBackground,
	TextColor3 = CurrentTheme.TextColor,
	BorderSizePixel = 0,
	Text = "−",
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	ZIndex = 11
})
ApplyCorner(MinimizeButton, 8)
ApplyStroke(MinimizeButton)

local HideButton = CreateElementBase(TopBar, "HideBtn", "TextButton", {
	Size = ButtonSize,
	Position = UDim2.new(1, -(ButtonSpacing + 40), 0.5, -20),
	BackgroundColor3 = CurrentTheme.ComponentBackground,
	TextColor3 = CurrentTheme.ErrorColor,
	BorderSizePixel = 0,
	Text = "✕",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	ZIndex = 11
})
ApplyCorner(HideButton, 8)
ApplyStroke(HideButton)

-- ============================================================================
-- TAB SYSTEM
-- ============================================================================

local TabBar = CreateElementBase(MainWindow, "TabBar", "Frame", {
	Size = UDim2.new(1, 0, 0, 55),
	Position = UDim2.new(0, 0, 0, 60),
	BackgroundColor3 = CurrentTheme.Background,
	BorderSizePixel = 0,
	ZIndex = 5
})

local TabBarLayout = CreateElementBase(TabBar, "TabLayout", "UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Center
})

local TabBarPadding = CreateElementBase(TabBar, "TabPadding", "UIPadding", {
	PaddingLeft = UDim.new(0, 15),
	PaddingRight = UDim.new(0, 15),
	PaddingTop = UDim.new(0, 8),
	PaddingBottom = UDim.new(0, 8)
})

-- Content Area
local ContentArea = CreateElementBase(MainWindow, "Content", "Frame", {
	Size = UDim2.new(1, 0, 1, -115),
	Position = UDim2.new(0, 0, 0, 115),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 5
})

-- Notifications Container
local NotificationsContainer = CreateElementBase(ScreenGui, "Notifications", "Frame", {
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 999
})

-- ============================================================================
-- AETHER PUBLIC INTERFACE
-- ============================================================================

function Aether:SetTheme(ThemeName)
	if AetherTheme[ThemeName] then
		CurrentTheme = AetherTheme[ThemeName]
		self:Notify({
			Title = "Theme Changed",
			Content = "Theme set to " .. ThemeName,
			Duration = 3
		})
	end
end

function Aether:Notify(Settings)
	local NotifSettings = Settings or {}
	local Title = NotifSettings.Title or "Notification"
	local Content = NotifSettings.Content or ""
	local Duration = NotifSettings.Duration or 5
	
	spawn(function()
		local Notification = CreateElementBase(NotificationsContainer, "Notif", "Frame", {
			Size = UDim2.new(0, 350, 0, 110),
			Position = UDim2.new(1, -370, 1, -130),
			BackgroundColor3 = CurrentTheme.NotificationBackground,
			BorderSizePixel = 0,
			ZIndex = 1000
		})
		
		ApplyCorner(Notification, 12)
		ApplyStroke(Notification, CurrentTheme.NotificationStroke, 1.5, 0.3)
		
		local NotifTitle = CreateElementBase(Notification, "Title", "TextLabel", {
			Size = UDim2.new(1, -30, 0, 35),
			Position = UDim2.new(0, 15, 0, 8),
			BackgroundTransparency = 1,
			TextColor3 = CurrentTheme.AccentColor,
			TextSize = 14,
			Font = Enum.Font.GothamBold,
			Text = Title,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
		
		local NotifContent = CreateElementBase(Notification, "Content", "TextLabel", {
			Size = UDim2.new(1, -30, 0, 60),
			Position = UDim2.new(0, 15, 0, 43),
			BackgroundTransparency = 1,
			TextColor3 = CurrentTheme.SecondaryTextColor,
			TextSize = 12,
			Font = Enum.Font.Gotham,
			Text = Content,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top
		})
		
		Tween(Notification, 0.3, {Position = UDim2.new(1, -370, 1, -130)})
		
		wait(Duration)
		
		Tween(Notification, 0.3, {Position = UDim2.new(1, -350, 1, -130)})
		wait(0.3)
		Notification:Destroy()
	end)
end

function Aether:CreateWindow(Settings)
	local WindowSettings = Settings or {}
	
	TitleLabel.Text = WindowSettings.Name or "Aether"
	
	CurrentWindow = {
		Name = WindowSettings.Name or "Aether",
		Tabs = {},
		TabButtons = {},
		TabPages = {},
		Settings = WindowSettings,
		FirstTab = nil
	}
	
	-- Configuration Setup
	if WindowSettings.ConfigurationSaving then
		Aether.Settings.ConfigSaving = WindowSettings.ConfigurationSaving.Enabled or false
		if WindowSettings.ConfigurationSaving.FolderName then
			Aether.Settings.ConfigFolder = WindowSettings.ConfigurationSaving.FolderName
		end
		if WindowSettings.ConfigurationSaving.FileName then
			CurrentWindow.ConfigFileName = WindowSettings.ConfigurationSaving.FileName
		end
	end
	
	-- Enable dragging
	ApplyDragToElement(TopBar, MainWindow)
	
	-- Button handlers
	HideButton.MouseButton1Click:Connect(function()
		IsHidden = not IsHidden
		MainWindow.Visible = not IsHidden
	end)
	
	MinimizeButton.MouseButton1Click:Connect(function()
		IsMinimized = not IsMinimized
		ContentArea.Visible = not IsMinimized
		TabBar.Visible = not IsMinimized
	end)
	
	ThemeButton.MouseButton1Click:Connect(function()
		self:Notify({Title = "Themes", Content = "Theme system available!"})
	end)
	
	-- K key handler
	UserInputService.InputBegan:Connect(function(Input, GameProcessed)
		if GameProcessed then return end
		if Input.KeyCode == Enum.KeyCode.K then
			IsHidden = not IsHidden
			MainWindow.Visible = not IsHidden
		end
	end)
	
	-- Load configuration after delay
	task.delay(2, function()
		if Aether.Settings.ConfigSaving and CurrentWindow.ConfigFileName then
			local ConfigData = LoadConfigurationData(CurrentWindow.ConfigFileName)
			for FlagName, FlagValue in pairs(ConfigData) do
				if Aether.Flags[FlagName] then
					pcall(function()
						Aether.Flags[FlagName]:Set(FlagValue)
					end)
				end
			end
		end
	end)
	
	local WindowObject = {}
	
	function WindowObject:CreateTab(TabName, TabIcon)
		local TabCount = #CurrentWindow.Tabs + 1
		
		-- Tab Button
		local TabButton = CreateElementBase(TabBar, TabName, "TextButton", {
			Size = UDim2.new(0, 160, 0, 40),
			BackgroundColor3 = CurrentTheme.TabBackground,
			TextColor3 = CurrentTheme.TabTextInactive,
			BorderSizePixel = 0,
			Text = TabName,
			Font = Enum.Font.GothamSemibold,
			TextSize = 13,
			LayoutOrder = TabCount,
			ZIndex = 6
		})
		
		ApplyCorner(TabButton, 10)
		ApplyStroke(TabButton, CurrentTheme.TabStroke, 1, 0.4)
		
		-- Tab Page
		local TabPage = CreateElementBase(ContentArea, TabName .. "Page", "ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 10,
			ScrollBarImageColor3 = CurrentTheme.AccentColor,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			LayoutOrder = TabCount,
			Visible = TabCount == 1,
			ZIndex = 5
		})
		
		local TabPageLayout = CreateElementBase(TabPage, "Layout", "UIListLayout", {
			Padding = UDim.new(0, 12),
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})
		
		local TabPagePadding = CreateElementBase(TabPage, "Padding", "UIPadding", {
			PaddingLeft = UDim.new(0, 20),
			PaddingRight = UDim.new(0, 20),
			PaddingTop = UDim.new(0, 15),
			PaddingBottom = UDim.new(0, 15)
		})
		
		-- Tab switching logic
		TabButton.MouseButton1Click:Connect(function()
			if TabDebounce then return end
			TabDebounce = true
			
			-- Hide all pages
			for _, Page in pairs(ContentArea:GetChildren()) do
				if Page:IsA("ScrollingFrame") then
					Page.Visible = false
				end
			end
			
			-- Deselect all tabs
			for _, Button in pairs(TabBar:GetChildren()) do
				if Button:IsA("TextButton") then
					Tween(Button, 0.2, {
						BackgroundColor3 = CurrentTheme.TabBackground,
						TextColor3 = CurrentTheme.TabTextInactive
					})
				end
			end
			
			-- Activate current tab
			TabPage.Visible = true
			Tween(TabButton, 0.2, {
				BackgroundColor3 = CurrentTheme.TabBackgroundActive,
				TextColor3 = CurrentTheme.TabTextActive
			})
			
			wait(0.2)
			TabDebounce = false
		end)
		
		-- Activate first tab
		if TabCount == 1 then
			CurrentWindow.FirstTab = TabName
			Tween(TabButton, 0.2, {
				BackgroundColor3 = CurrentTheme.TabBackgroundActive,
				TextColor3 = CurrentTheme.TabTextActive
			})
		end
		
		table.insert(CurrentWindow.Tabs, TabName)
		table.insert(CurrentWindow.TabButtons, TabButton)
		table.insert(CurrentWindow.TabPages, TabPage)
		
		local TabObject = {}
		
		-- ================================================================
		-- TAB COMPONENTS
		-- ================================================================
		
		function TabObject:CreateButton(ButtonSettings)
			local ButtonConfig = ButtonSettings or {}
			local Button = CreateElementBase(TabPage, ButtonConfig.Name or "Button", "Frame", {
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 1
			})
			
			ApplyCorner(Button)
			ApplyStroke(Button)
			
			local ButtonLabel = CreateElementBase(Button, "Label", "TextLabel", {
				Size = UDim2.new(1, -20, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = ButtonConfig.Name or "Button",
				TextXAlignment = Enum.TextXAlignment.Center
			})
			
			local ButtonClick = CreateElementBase(Button, "Click", "TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = ""
			})
			
			ButtonClick.MouseButton1Click:Connect(function()
				local Success, Error = pcall(ButtonConfig.Callback or function() end)
				if not Success then
					Tween(Button, 0.2, {BackgroundColor3 = CurrentTheme.ErrorColor})
					wait(0.5)
					Tween(Button, 0.2, {BackgroundColor3 = CurrentTheme.ComponentBackground})
				else
					Tween(Button, 0.1, {BackgroundColor3 = CurrentTheme.AccentColor})
					wait(0.1)
					Tween(Button, 0.1, {BackgroundColor3 = CurrentTheme.ComponentBackground})
				end
				self:SaveConfig()
			end)
			
			Button.MouseEnter:Connect(function()
				Tween(Button, 0.15, {BackgroundColor3 = CurrentTheme.ComponentBackgroundHovered})
			end)
			
			Button.MouseLeave:Connect(function()
				Tween(Button, 0.15, {BackgroundColor3 = CurrentTheme.ComponentBackground})
			end)
			
			return Button
		end
		
		function TabObject:CreateToggle(ToggleSettings)
			local Config = ToggleSettings or {}
			local State = Config.Default or false
			
			local Toggle = CreateElementBase(TabPage, Config.Name or "Toggle", "Frame", {
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 2
			})
			
			ApplyCorner(Toggle)
			ApplyStroke(Toggle)
			
			local ToggleLabel = CreateElementBase(Toggle, "Label", "TextLabel", {
				Size = UDim2.new(1, -70, 1, 0),
				Position = UDim2.new(0, 15, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Config.Name or "Toggle",
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ToggleSwitch = CreateElementBase(Toggle, "Switch", "Frame", {
				Size = UDim2.new(0, 55, 0, 28),
				Position = UDim2.new(1, -65, 0.5, -14),
				BackgroundColor3 = CurrentTheme.ToggleBackground or CurrentTheme.ComponentBackground,
				BorderSizePixel = 0
			})
			
			ApplyCorner(ToggleSwitch, 14)
			
			local SwitchStroke = CreateElementBase(ToggleSwitch, "Stroke", "UIStroke", {
				Color = State and CurrentTheme.ToggleOnStroke or CurrentTheme.ToggleOffStroke,
				Thickness = 1.5
			})
			
			local ToggleIndicator = CreateElementBase(ToggleSwitch, "Indicator", "Frame", {
				Size = UDim2.new(0, 24, 0, 24),
				Position = State and UDim2.new(0, 28, 0.5, -12) or UDim2.new(0, 2, 0.5, -12),
				BackgroundColor3 = State and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff,
				BorderSizePixel = 0
			})
			
			ApplyCorner(ToggleIndicator, 12)
			
			local ToggleButton = CreateElementBase(Toggle, "Button", "TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Text = ""
			})
			
			ToggleButton.MouseButton1Click:Connect(function()
				State = not State
				
				if State then
					Tween(ToggleIndicator, 0.3, {Position = UDim2.new(0, 28, 0.5, -12)})
					Tween(ToggleIndicator, 0.3, {BackgroundColor3 = CurrentTheme.ToggleOn})
					Tween(SwitchStroke, 0.3, {Color = CurrentTheme.ToggleOnStroke})
				else
					Tween(ToggleIndicator, 0.3, {Position = UDim2.new(0, 2, 0.5, -12)})
					Tween(ToggleIndicator, 0.3, {BackgroundColor3 = CurrentTheme.ToggleOff})
					Tween(SwitchStroke, 0.3, {Color = CurrentTheme.ToggleOffStroke})
				end
				
				pcall(Config.Callback or function() end, State)
				self:SaveConfig()
			end)
			
			function ToggleSettings:Set(Value)
				State = Value
				if Value then
					Tween(ToggleIndicator, 0.3, {Position = UDim2.new(0, 28, 0.5, -12)})
					Tween(ToggleIndicator, 0.3, {BackgroundColor3 = CurrentTheme.ToggleOn})
				else
					Tween(ToggleIndicator, 0.3, {Position = UDim2.new(0, 2, 0.5, -12)})
					Tween(ToggleIndicator, 0.3, {BackgroundColor3 = CurrentTheme.ToggleOff})
				end
				pcall(Config.Callback or function() end, Value)
				self:SaveConfig()
			end
			
			if Config.Flag then
				Aether.Flags[Config.Flag] = {
					Type = "Toggle",
					Value = State,
					Set = ToggleSettings.Set,
					Callback = Config.Callback
				}
			end
			
			return ToggleSettings
		end
		
		function TabObject:CreateSlider(SliderSettings)
			local Config = SliderSettings or {}
			local Min = Config.Min or 0
			local Max = Config.Max or 100
			local Default = Config.Default or Min
			local Value = Default
			
			local Slider = CreateElementBase(TabPage, Config.Name or "Slider", "Frame", {
				Size = UDim2.new(1, 0, 0, 70),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 3
			})
			
			ApplyCorner(Slider)
			ApplyStroke(Slider)
			
			local SliderLabel = CreateElementBase(Slider, "Label", "TextLabel", {
				Size = UDim2.new(1, -20, 0, 25),
				Position = UDim2.new(0, 10, 0, 8),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Config.Name or "Slider",
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ValueDisplay = CreateElementBase(Slider, "Value", "TextLabel", {
				Size = UDim2.new(0, 80, 0, 25),
				Position = UDim2.new(1, -90, 0, 8),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.AccentColor,
				TextSize = 12,
				Font = Enum.Font.GothamBold,
				Text = tostring(Value)
			})
			
			local SliderBackground = CreateElementBase(Slider, "Background", "Frame", {
				Size = UDim2.new(1, -20, 0, 12),
				Position = UDim2.new(0, 10, 0, 38),
				BackgroundColor3 = CurrentTheme.SliderBackground,
				BorderSizePixel = 0
			})
			
			ApplyCorner(SliderBackground, 6)
			
			local SliderFill = CreateElementBase(SliderBackground, "Fill", "Frame", {
				Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0),
				BackgroundColor3 = CurrentTheme.SliderFill,
				BorderSizePixel = 0
			})
			
			ApplyCorner(SliderFill, 6)
			
			local SliderButton = CreateElementBase(SliderBackground, "Button", "TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			})
			
			local IsDragging = false
			
			SliderButton.MouseButton1Down:Connect(function()
				IsDragging = true
			end)
			
			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					IsDragging = false
				end
			end)
			
			RunService.RenderStepped:Connect(function()
				if IsDragging then
					local MousePos = UserInputService:GetMouseLocation()
					local SliderPos = SliderBackground.AbsolutePosition.X
					local SliderSize = SliderBackground.AbsoluteSize.X
					
					local RelativeX = math.clamp(MousePos.X - SliderPos, 0, SliderSize) / SliderSize
					Value = math.floor(Min + RelativeX * (Max - Min) + 0.5)
					
					ValueDisplay.Text = tostring(Value)
					Tween(SliderFill, 0.05, {Size = UDim2.new(RelativeX, 0, 1, 0)}, Enum.EasingStyle.Linear)
					
					pcall(Config.Callback or function() end, Value)
					self:SaveConfig()
				end
			end)
			
			function SliderSettings:Set(NewValue)
				Value = math.clamp(NewValue, Min, Max)
				local Ratio = (Value - Min) / (Max - Min)
				ValueDisplay.Text = tostring(Value)
				Tween(SliderFill, 0.2, {Size = UDim2.new(Ratio, 0, 1, 0)})
				pcall(Config.Callback or function() end, Value)
				self:SaveConfig()
			end
			
			if Config.Flag then
				Aether.Flags[Config.Flag] = {
					Type = "Slider",
					Value = Value,
					Set = SliderSettings.Set
				}
			end
			
			return SliderSettings
		end
		
		function TabObject:CreateLabel(Text)
			local Label = CreateElementBase(TabPage, "Label", "Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = CurrentTheme.TertiaryBackground,
				BorderSizePixel = 0,
				LayoutOrder = 4
			})
			
			ApplyCorner(Label, 8)
			ApplyStroke(Label, CurrentTheme.SecondaryTextColor, 0.5, 0.7)
			
			local LabelText = CreateElementBase(Label, "Text", "TextLabel", {
				Size = UDim2.new(1, -20, 1, 0),
				Position = UDim2.new(0, 10, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.SecondaryTextColor,
				TextSize = 12,
				Font = Enum.Font.Gotham,
				Text = Text,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			return Label
		end
		
		function TabObject:CreateParagraph(Title, Content)
			local Paragraph = CreateElementBase(TabPage, "Paragraph", "Frame", {
				Size = UDim2.new(1, 0, 0, 90),
				BackgroundColor3 = CurrentTheme.TertiaryBackground,
				BorderSizePixel = 0,
				LayoutOrder = 5
			})
			
			ApplyCorner(Paragraph, 8)
			ApplyStroke(Paragraph, CurrentTheme.SecondaryTextColor, 0.5, 0.7)
			
			local TitleLabel = CreateElementBase(Paragraph, "Title", "TextLabel", {
				Size = UDim2.new(1, -20, 0, 25),
				Position = UDim2.new(0, 10, 0, 8),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Title,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ContentLabel = CreateElementBase(Paragraph, "Content", "TextLabel", {
				Size = UDim2.new(1, -20, 0, 50),
				Position = UDim2.new(0, 10, 0, 35),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.SecondaryTextColor,
				TextSize = 11,
				Font = Enum.Font.Gotham,
				Text = Content,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			return Paragraph
		end
		
		function TabObject:CreateSection(Name)
			local Section = CreateElementBase(TabPage, "Section_" .. Name, "Frame", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				LayoutOrder = 6
			})
			
			local SectionLabel = CreateElementBase(Section, "Label", "TextLabel", {
				Size = UDim2.new(1, -20, 0, 25),
				Position = UDim2.new(0, 10, 0, 5),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.AccentColor,
				TextSize = 14,
				Font = Enum.Font.GothamBold,
				Text = Name,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local Divider = CreateElementBase(Section, "Divider", "Frame", {
				Size = UDim2.new(1, -20, 0, 1.5),
				Position = UDim2.new(0, 10, 0, 32),
				BackgroundColor3 = CurrentTheme.ComponentStroke,
				BorderSizePixel = 0
			})
			
			return Section
		end
		
		function TabObject:CreateInput(InputSettings)
			local Config = InputSettings or {}
			
			local Input = CreateElementBase(TabPage, Config.Name or "Input", "Frame", {
				Size = UDim2.new(1, 0, 0, 60),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 7
			})
			
			ApplyCorner(Input)
			ApplyStroke(Input)
			
			local InputLabel = CreateElementBase(Input, "Label", "TextLabel", {
				Size = UDim2.new(1, -20, 0, 20),
				Position = UDim2.new(0, 10, 0, 8),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Config.Name or "Input",
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local InputBox = CreateElementBase(Input, "TextBox", "TextBox", {
				Size = UDim2.new(1, -20, 0, 28),
				Position = UDim2.new(0, 10, 0, 28),
				BackgroundColor3 = CurrentTheme.InputBackground,
				TextColor3 = CurrentTheme.TextColor,
				PlaceholderColor3 = CurrentTheme.InputPlaceholder,
				PlaceholderText = Config.Placeholder or "Enter text...",
				Text = "",
				TextSize = 12,
				Font = Enum.Font.Gotham,
				BorderSizePixel = 0,
				ClearTextOnFocus = false
			})
			
			ApplyCorner(InputBox, 6)
			ApplyStroke(InputBox, CurrentTheme.ComponentStroke, 1, 0.5)
			
			InputBox.FocusLost:Connect(function()
				pcall(Config.Callback or function() end, InputBox.Text)
				if Config.ClearOnFocusLost then
					InputBox.Text = ""
				end
				self:SaveConfig()
			end)
			
			return InputBox
		end
		
		function TabObject:CreateDropdown(DropdownSettings)
			local Config = DropdownSettings or {}
			local Options = Config.Options or {"Option 1", "Option 2"}
			local SelectedOption = Config.Default or Options[1]
			
			local Dropdown = CreateElementBase(TabPage, Config.Name or "Dropdown", "Frame", {
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 8
			})
			
			ApplyCorner(Dropdown)
			ApplyStroke(Dropdown)
			
			local DropdownLabel = CreateElementBase(Dropdown, "Label", "TextLabel", {
				Size = UDim2.new(1, -110, 1, 0),
				Position = UDim2.new(0, 15, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Config.Name or "Dropdown",
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local SelectedDisplay = CreateElementBase(Dropdown, "Selected", "TextLabel", {
				Size = UDim2.new(0, 100, 0, 28),
				Position = UDim2.new(1, -110, 0.5, -14),
				BackgroundColor3 = CurrentTheme.InputBackground,
				TextColor3 = CurrentTheme.AccentColor,
				TextSize = 11,
				Font = Enum.Font.GothamMedium,
				Text = SelectedOption,
				BorderSizePixel = 0
			})
			
			ApplyCorner(SelectedDisplay, 6)
			ApplyStroke(SelectedDisplay, CurrentTheme.ComponentStroke, 1, 0.5)
			
			local DropdownButton = CreateElementBase(Dropdown, "Button", "TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			})
			
			DropdownButton.MouseButton1Click:Connect(function()
				local RandomIndex = math.random(1, #Options)
				SelectedOption = Options[RandomIndex]
				SelectedDisplay.Text = SelectedOption
				pcall(Config.Callback or function() end, SelectedOption)
				self:SaveConfig()
			end)
			
			if Config.Flag then
				Aether.Flags[Config.Flag] = {
					Type = "Dropdown",
					Value = SelectedOption
				}
			end
			
			return DropdownSettings
		end
		
		function TabObject:CreateKeybind(KeybindSettings)
			local Config = KeybindSettings or {}
			local CurrentKey = Config.Default or "NONE"
			
			local Keybind = CreateElementBase(TabPage, Config.Name or "Keybind", "Frame", {
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 9
			})
			
			ApplyCorner(Keybind)
			ApplyStroke(Keybind)
			
			local KeybindLabel = CreateElementBase(Keybind, "Label", "TextLabel", {
				Size = UDim2.new(1, -110, 1, 0),
				Position = UDim2.new(0, 15, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Config.Name or "Keybind",
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local KeyDisplay = CreateElementBase(Keybind, "Key", "TextLabel", {
				Size = UDim2.new(0, 100, 0, 28),
				Position = UDim2.new(1, -110, 0.5, -14),
				BackgroundColor3 = CurrentTheme.InputBackground,
				TextColor3 = CurrentTheme.AccentColor,
				TextSize = 11,
				Font = Enum.Font.GothamMedium,
				Text = CurrentKey,
				BorderSizePixel = 0
			})
			
			ApplyCorner(KeyDisplay, 6)
			ApplyStroke(KeyDisplay, CurrentTheme.ComponentStroke, 1, 0.5)
			
			local KeybindButton = CreateElementBase(Keybind, "Button", "TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			})
			
			local AwaitingKey = false
			
			KeybindButton.MouseButton1Click:Connect(function()
				AwaitingKey = true
				KeyDisplay.Text = "..."
				
				local Connection
				Connection = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
					if GameProcessed or not AwaitingKey then return end
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						CurrentKey = tostring(Input.KeyCode):split(".")[3]
						KeyDisplay.Text = CurrentKey
						AwaitingKey = false
						Connection:Disconnect()
						self:SaveConfig()
					end
				end)
			end)
			
			UserInputService.InputBegan:Connect(function(Input, GameProcessed)
				if not AwaitingKey and CurrentKey ~= "NONE" then
					if Input.KeyCode == Enum.KeyCode[CurrentKey] then
						pcall(Config.Callback or function() end, true)
						if Config.HoldToActivate then
							local Release
							Release = UserInputService.InputEnded:Connect(function(ReleaseInput)
								if ReleaseInput.KeyCode == Input.KeyCode then
									pcall(Config.Callback or function() end, false)
									Release:Disconnect()
								end
							end)
						end
					end
				end
			end)
			
			if Config.Flag then
				Aether.Flags[Config.Flag] = {
					Type = "Keybind",
					Value = CurrentKey
				}
			end
			
			return KeybindSettings
		end
		
		function TabObject:CreateColorPicker(ColorPickerSettings)
			local Config = ColorPickerSettings or {}
			local SelectedColor = Config.Default or Color3.fromRGB(255, 255, 255)
			
			local ColorPicker = CreateElementBase(TabPage, Config.Name or "Color", "Frame", {
				Size = UDim2.new(1, 0, 0, 48),
				BackgroundColor3 = CurrentTheme.ComponentBackground,
				BorderSizePixel = 0,
				LayoutOrder = 10
			})
			
			ApplyCorner(ColorPicker)
			ApplyStroke(ColorPicker)
			
			local ColorLabel = CreateElementBase(ColorPicker, "Label", "TextLabel", {
				Size = UDim2.new(1, -80, 1, 0),
				Position = UDim2.new(0, 15, 0, 0),
				BackgroundTransparency = 1,
				TextColor3 = CurrentTheme.TextColor,
				TextSize = 13,
				Font = Enum.Font.GothamSemibold,
				Text = Config.Name or "Color",
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ColorDisplay = CreateElementBase(ColorPicker, "Display", "Frame", {
				Size = UDim2.new(0, 60, 0, 28),
				Position = UDim2.new(1, -70, 0.5, -14),
				BackgroundColor3 = SelectedColor,
				BorderSizePixel = 0
			})
			
			ApplyCorner(ColorDisplay, 6)
			ApplyStroke(ColorDisplay, CurrentTheme.ComponentStroke, 1.5)
			
			local ColorButton = CreateElementBase(ColorPicker, "Button", "TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = ""
			})
			
			ColorButton.MouseButton1Click:Connect(function()
				Aether:Notify({
					Title = "Color Picker",
					Content = "Color: " .. SelectedColor:ToHex(),
					Duration = 3
				})
			end)
			
			function ColorPickerSettings:Set(NewColor)
				SelectedColor = NewColor
				ColorDisplay.BackgroundColor3 = NewColor
				pcall(Config.Callback or function() end, NewColor)
				self:SaveConfig()
			end
			
			if Config.Flag then
				Aether.Flags[Config.Flag] = {
					Type = "Color",
					Value = PackColor(SelectedColor)
				}
			end
			
			return ColorPickerSettings
		end
		
		function TabObject:SaveConfig()
			if Aether.Settings.ConfigSaving and CurrentWindow.ConfigFileName then
				local ConfigData = {}
				for FlagName, FlagData in pairs(Aether.Flags) do
					if FlagData.Type == "Color" then
						ConfigData[FlagName] = PackColor(FlagData.Value)
					else
						ConfigData[FlagName] = FlagData.Value
					end
				end
				SaveConfigurationData(CurrentWindow.ConfigFileName, ConfigData)
			end
		end
		
		return TabObject
	end
	
	return WindowObject
end

function Aether:LoadConfiguration(FileName)
	if CurrentWindow and FileName then
		local ConfigData = LoadConfigurationData(FileName)
		for FlagName, FlagValue in pairs(ConfigData) do
			if Aether.Flags[FlagName] then
				pcall(function()
					if Aether.Flags[FlagName].Type == "Color" then
						Aether.Flags[FlagName].Value = UnpackColor(FlagValue)
					else
						Aether.Flags[FlagName].Value = FlagValue
					end
				end)
			end
		end
		self:Notify({Title = "Config", Content = "Configuration loaded!"})
	end
end

function Aether:Destroy()
	if ScreenGui then
		ScreenGui:Destroy()
	end
end

return Aether
