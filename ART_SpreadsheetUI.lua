------------------------------------------------------------------------------------------
-- Spreadsheet --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ...

local NameBoxes = {}
local MainSpecBoxes = {}
local OffSpecBoxes = {}
local TransmogBoxes = {}

local RowsShowing = 0

--- Event frame for loading spreadsheet db.
local SavedVariablesFrame = CreateFrame("Frame")
SavedVariablesFrame:RegisterEvent("ADDON_LOADED")
SavedVariablesFrame:RegisterEvent("PLAYER_LOGOUT")
SavedVariablesFrame:SetScript("OnEvent", function(self, event, arg1)
	
	-- Player login
	if event == "ADDON_LOADED" and arg1 == "AxiomRaidTools" then
	
		-- First time loading addon
		if MFP_SpreadsheetDB == nil then
			ns:setDefaultValues()
		else
			ns:LoadSpreadsheet(MFP_SpreadsheetDB[1])
		end
		
	-- Player logout/reload
	elseif event == "PLAYER_LOGOUT" then
		if CurrentSpreadsheet == 1 then
			ns:SaveSpreadsheet(1)
		elseif CurrentSpreadsheet == 2 then
			ns:SaveSpreadsheet(2)
		else -- CurrentSpreadsheet == 3
			ns:SaveSpreadsheet(3)
		end
	end
end)

--- Creates close button for the spreadsheet
local function ns:CreateCloseButton()
	-- Close button
	local button = CreateFrame("Button", "SpreadsheetCloseButton", SpreadsheetFrame)
	
	-- Size & location
	button:SetHeight(25)
	button:SetWidth(25)
	button:SetPoint("TOPRIGHT", -10, -10)
	
	-- Textures
	button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
	button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
	
	-- Script
	button:SetScript("OnClick", function(self)
		self:GetParent():Hide()
	end)
end

--- Creates edit boxes for player names for the spreadsheet.
-- An editbox is an editable text field. In this case, it is a cell of the spreadsheet.
local function ns:CreateNameBoxes()
	for i=1, 20 do
		if i == 1 then
			NameBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			NameBoxes[i]:SetPoint("TOPLEFT", SpreadsheetFrame, "TOPLEFT", 15, -25)
		else
			NameBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			NameBoxes[i]:SetPoint("TOP", NameBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		NameBoxes[i]:SetSize(100, 40)
		NameBoxes[i]:SetMultiLine(false)
		NameBoxes[i]:SetAutoFocus(false)
		NameBoxes[i]:SetFontObject("ChatFontNormal")
		NameBoxes[i]:SetMaxLetters(12)
		NameBoxes[i]:SetTextInsets(12, 0, 0, 0)
		NameBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		NameBoxes[i]:SetBackdropBorderColor(1, 1, 1, 0.25)
		NameBoxes[i]:Hide()
		
		NameBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			MainSpecBoxes[i]:SetFocus()
		end)
	end
	ns.NameBoxes = NameBoxes
end

--- Creates edit boxes for main spec items received for the spreadsheet.
local function ns:CreateMainSpecBoxes()
	for i=1, 20 do
		if i == 1 then
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			MainSpecBoxes[i]:SetPoint("LEFT", NameBoxes[i], "RIGHT", 5, 0)
		else
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			MainSpecBoxes[i]:SetPoint("TOP", MainSpecBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		MainSpecBoxes[i]:SetSize(40, 40)
		MainSpecBoxes[i]:SetTextInsets(20, 0, 0, 0)
		MainSpecBoxes[i]:SetMultiLine(false)
		MainSpecBoxes[i]:SetAutoFocus(false)
		MainSpecBoxes[i]:SetFontObject("ChatFontNormal")
		MainSpecBoxes[i]:SetMaxLetters(2)
		MainSpecBoxes[i]:SetTextInsets(14, 0, 0, 0)
		MainSpecBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		MainSpecBoxes[i]:SetBackdropBorderColor(1, 1, 1, 0.25)
		MainSpecBoxes[i]:Hide()
		
		MainSpecBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			OffSpecBoxes[i]:SetFocus()
		end)
	end
	ns.MainSpecBoxes = MainSpecBoxes
end

--- Creates edit boxes for off spec items received for the spreadsheet.
local function ns:CreateOffSpecBoxes()
	for i=1, 20 do
		if i == 1 then
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			OffSpecBoxes[i]:SetPoint("LEFT", MainSpecBoxes[i], "RIGHT", 5, 0)
		else
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			OffSpecBoxes[i]:SetPoint("TOP", OffSpecBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		OffSpecBoxes[i]:SetSize(40, 40)
		OffSpecBoxes[i]:SetMultiLine(false)
		OffSpecBoxes[i]:SetAutoFocus(false)
		OffSpecBoxes[i]:SetFontObject("ChatFontNormal")
		OffSpecBoxes[i]:SetMaxLetters(2)
		OffSpecBoxes[i]:SetTextInsets(14, 0, 0, 0)
		OffSpecBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		OffSpecBoxes[i]:SetBackdropBorderColor(1, 1, 1, 0.25)
		OffSpecBoxes[i]:Hide()
		
		OffSpecBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			TransmogBoxes[i]:SetFocus()
		end)
	end
	ns.OffSpecBoxes = OffSpecBoxes
end

--- Creates edit boxes for transmog items received for the spreadsheet.
local function ns:CreateTransmogBoxes()
	for i=1, 20 do
		if i == 1 then
			TransmogBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			TransmogBoxes[i]:SetPoint("LEFT", OffSpecBoxes[i], "RIGHT", 5, 0)
		else
			TransmogBoxes[i] = CreateFrame("EditBox", nil, SpreadsheetFrame, BackdropTemplateMixin and "BackdropTemplate")
			TransmogBoxes[i]:SetPoint("TOP", TransmogBoxes[i-1], "BOTTOM", 0, 0)
		end
		
		TransmogBoxes[i]:SetSize(40, 40)
		TransmogBoxes[i]:SetMultiLine(false)
		TransmogBoxes[i]:SetAutoFocus(false)
		TransmogBoxes[i]:SetFontObject("ChatFontNormal")
		TransmogBoxes[i]:SetMaxLetters(2)
		TransmogBoxes[i]:SetTextInsets(14, 0, 0, 0)
		TransmogBoxes[i]:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		TransmogBoxes[i]:SetBackdropBorderColor(1, 1, 1, 0.25)
		TransmogBoxes[i]:Hide()
		
		if i < 20 then
			TransmogBoxes[i]:SetScript("OnTabPressed", function(self)
				-- tab over
				NameBoxes[i+1]:SetFocus()
			end)
		end
	end
	ns.TransmogBoxes = TransmogBoxes
end

--- Creates text that act as headers for each column.
local function ns:CreateColumnHeaders()
	local title_name = SpreadsheetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title_name:SetPoint("TOP", NameBoxes[1], "TOP", 0, 10)
	title_name:SetText("Name")
			
	local title_mainspec = SpreadsheetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title_mainspec:SetPoint("TOP", MainSpecBoxes[1], "TOP", 0, 10)
	title_mainspec:SetText("MS")
	
	local title_offspec = SpreadsheetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title_offspec:SetPoint("TOP", OffSpecBoxes[1], "TOP", 0, 10)
	title_offspec:SetText("OS")

	local title_tmog = SpreadsheetFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	title_tmog:SetPoint("TOP", TransmogBoxes[1], "TOP", 0, 10)
	title_tmog:SetText("TMOG")
end

--- Creates a button that clears every edit box on the spreadsheet.
local function ns:CreateClearButton()
	local button = CreateFrame("Button", "ClearButton", SpreadsheetFrame, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOM", 0, 10)
	button:SetSize(50, 30)
	button:SetText("Clear")
	button:SetScript("OnClick", function()
		StaticPopupDialogs["CLEAR_SHEET"] = {
			text = "Wipe loot sheet (all data will enter The Maw)?",
			button1 = "Yes",
			button2 = "No",
			OnAccept = function()
				ClearAllRows()
			end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
		}
		StaticPopup_Show ("CLEAR_SHEET")
	end)
end

--- Uses a index variable to keep track of which row is on the bottom.
-- When called, it shows the row below the current and increments the index.
local function ns:ShowRow(i)
	if i < 21 then
		SpreadsheetFrame:SetHeight(SpreadsheetFrame:GetHeight() + 40);
		NameBoxes[i]:Show()
		MainSpecBoxes[i]:Show()
		OffSpecBoxes[i]:Show()
		TransmogBoxes[i]:Show()
		RowsShowing = RowsShowing + 1
	end
end

--- Uses a index variable to keep track of which row is on the bottom.
-- When called, it hides the last row showing and decrements the index.
local function ns:HideRow(i)
	if i > 0 then
		SpreadsheetFrame:SetHeight(SpreadsheetFrame:GetHeight() - 40);
		NameBoxes[i]:Hide()
		MainSpecBoxes[i]:Hide()
		OffSpecBoxes[i]:Hide()
		TransmogBoxes[i]:Hide()
		RowsShowing = RowsShowing - 1
	end
end

--- Creates button that calls ShowRow()
local function ns:CreateNewRowButton()
	local button = CreateFrame("Button", "AddRowButton", SpreadsheetFrame, "UIPanelButtonTemplate")
	button:SetPoint("RIGHT", SpreadsheetFrame, "TOPLEFT", 5, -17)
	button:SetSize(25, 25)
	button:SetText("+")
	button:SetScript('OnClick', function()
		ShowRow(RowsShowing+1)
	end)
end

--- Creates button that calls HideRow()
local function ns:CreateRemoveRowButton()
	local button = CreateFrame("Button", "RemoveRowButton", SpreadsheetFrame, "UIPanelButtonTemplate")
	button:SetPoint("TOP", AddRowButton, "BOTTOM", 0, 0)
	button:SetSize(25, 25)
	button:SetText("-")
	button:SetScript('OnClick', function()
		HideRow(RowsShowing)
	end)
end

--- Creates tab buttons at the top of the frame.
-- One tab for normal, heroic, and mythic difficulties.
local function ns:CreateSpreadsheetTabs()
	local Tab_1 = CreateFrame("Button", "$parentTab1", SpreadsheetFrame, "TabButtonTemplate")
	Tab_1:SetID(1)
	Tab_1:SetPoint("BOTTOMLEFT", SpreadsheetFrame, "TOPLEFT", 9, -5)
	Tab_1:SetText("Normal");
	PanelTemplates_TabResize(Tab_1, 0)

	local Tab_2 = CreateFrame("Button", "$parentTab2", SpreadsheetFrame, "TabButtonTemplate");
	Tab_2:SetID(2)
	Tab_2:SetPoint("LEFT", Tab_1, "RIGHT", 3, 0)
	Tab_2:SetText("Heroic")
	PanelTemplates_TabResize(Tab_2, 0)

	local Tab_3 = CreateFrame("Button", "$parentTab2", SpreadsheetFrame, "TabButtonTemplate")
	Tab_3:SetID(3)
	Tab_3:SetPoint("LEFT", Tab_2, "RIGHT", 3, 0)
	Tab_3:SetText("Mythic");
	PanelTemplates_TabResize(Tab_3, 0)


	Tab_1:SetScript("OnClick", function()
		SaveSpreadsheet(CurrentSpreadsheet)
		CurrentSpreadsheet = 1
		LoadSpreadsheet(SpreadsheetSave[1])
	end)

	Tab_2:SetScript("OnClick", function()
		SaveSpreadsheet(CurrentSpreadsheet)
		CurrentSpreadsheet = 2
		LoadSpreadsheet(SpreadsheetSave[2])
	end)

	Tab_3:SetScript("OnClick", function()
		SaveSpreadsheet(CurrentSpreadsheet)
		CurrentSpreadsheet = 3
		LoadSpreadsheet(SpreadsheetSave[3])
	end)
end

--- Deletes all values from all edit boxes.
function ns:ClearAllRows()
	for i=1,20 do
		NameBoxes[i]:SetText("")
		MainSpecBoxes[i]:SetText("")
		OffSpecBoxes[i]:SetText("")
		TransmogBoxes[i]:SetText("")
	end
end

--- Driver to create the spreadsheet frame and all its UI elements.
function ns:CreateSpreadsheetUI()

	local f = CreateFrame("Frame", "SpreadsheetFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")

	-- Size & location
	f:SetPoint("TOP", 0, -25)
	f:SetSize(290, 70)

	-- Colors
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
		edgeSize = 16,
		insets = { left = 8, right = 6, top = 8, bottom = 8 },
	})
	f:SetBackdropBorderColor(1, 0, 0, .5)

	-- Make moveable
	f:EnableMouse(true)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

	-- Frame can't leave screen
	f:SetClampedToScreen(true)

	-- Setup components
	CreateNameBoxes()
	CreateMainSpecBoxes()
	CreateOffSpecBoxes()
	CreateTransmogBoxes()
	
	CreateColumnHeaders()
	CreateClearButton()
	CreateNewRowButton()
	CreateRemoveRowButton()
	CreateCloseButton()
	CreateSpreadsheetTabs()

	-- Assign to addon namespace
	ns.SpreadsheetFrame = f
end
