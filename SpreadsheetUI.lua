local addon, ns = ... -- Addon name & common namespace



------------------------------------------------------------------------------------------
-- Spreadsheet --
------------------------------------------------------------------------------------------
function CreateLootSheet()
			local f = CreateFrame("Frame", "LootSheet", UIParent, BackdropTemplateMixin and "BackdropTemplate")
			f:SetPoint("TOP", 0, -25)
			f:SetSize(290, 70)
			f:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
				})
			f:SetBackdropBorderColor(1, 0, 0, .5)
			f:SetMovable(true)
			f:SetClampedToScreen(true)
			f:SetScript("OnMouseDown", function(self, button)
				if button == "LeftButton" then
					self:StartMoving()
				end
			end)
			f:SetScript("OnMouseUp", f.StopMovingOrSizing)
			
			-- Close button
			local button = CreateFrame("Button", "LootResultsCloseButton", f)
			button:SetHeight(25)
			button:SetWidth(25)
			button:SetPoint("TOPRIGHT", -10, -10)
			button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
			button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
			button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight", "ADD")
			button:SetScript("OnClick", function(self)
				self:GetParent():Hide()
				RollFrame:UnregisterEvent("CHAT_MSG_SYSTEM")
			end)
			
			CreateNewRowButton()
			CreateRemoveRowButton()
			CreateNameBoxes()
			CreateMainSpecBoxes()
			CreateOffSpecBoxes()
			CreateTransmogBoxes()
			CreateClearButton()
			CreateSpreadsheetTabs()
			
			local title_name = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_name:SetPoint("TOP", NameBoxes[1], "TOP", 0, 10)
			title_name:SetText("Name")
			
			local title_mainspec = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_mainspec:SetPoint("TOP", MainSpecBoxes[1], "TOP", 0, 10)
			title_mainspec:SetText("MS")
			
			local title_offspec = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_offspec:SetPoint("TOP", OffSpecBoxes[1], "TOP", 0, 10)
			title_offspec:SetText("OS")
	
			local title_tmog = LootSheet:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			title_tmog:SetPoint("TOP", TransmogBoxes[1], "TOP", 0, 10)
			title_tmog:SetText("TMOG")
			
			f:Hide()
			ns.SpreadsheetFrame = f
end




function CreateNameBoxes()
	for i=1, 20 do
		if i == 1 then
			NameBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
			NameBoxes[i]:SetPoint("TOPLEFT", LootSheet, "TOPLEFT", 15, -25)
		else
			NameBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
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
		NameBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		NameBoxes[i]:Hide()
		
		NameBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			MainSpecBoxes[i]:SetFocus()
		end)
	end
end

function CreateMainSpecBoxes()
	for i=1, 20 do
		if i == 1 then
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
			MainSpecBoxes[i]:SetPoint("LEFT", NameBoxes[i], "RIGHT", 5, 0)
		else
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
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
		MainSpecBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		MainSpecBoxes[i]:Hide()
		
		MainSpecBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			OffSpecBoxes[i]:SetFocus()
		end)
	end
end

function CreateOffSpecBoxes()
	for i=1, 20 do
		if i == 1 then
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
			OffSpecBoxes[i]:SetPoint("LEFT", MainSpecBoxes[i], "RIGHT", 5, 0)
		else
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
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
		OffSpecBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		OffSpecBoxes[i]:Hide()
		
		OffSpecBoxes[i]:SetScript("OnTabPressed", function(self)
			-- tab over
			TransmogBoxes[i]:SetFocus()
		end)
	end
end

function CreateTransmogBoxes()
	for i=1, 20 do
		if i == 1 then
			TransmogBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
			TransmogBoxes[i]:SetPoint("LEFT", OffSpecBoxes[i], "RIGHT", 5, 0)
		else
			TransmogBoxes[i] = CreateFrame("EditBox", nil, LootSheet, BackdropTemplateMixin and "BackdropTemplate")
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
		TransmogBoxes[i]:SetBackdropBorderColor(1, 0, 0, 0)
		TransmogBoxes[i]:Hide()
		
		if i < 20 then
			TransmogBoxes[i]:SetScript("OnTabPressed", function(self)
				-- tab over
				NameBoxes[i+1]:SetFocus()
			end)
		end
	end
end

function CreateNewRowButton()
	local button = CreateFrame("Button", "AddRowButton", LootSheet, "UIPanelButtonTemplate")
			button:SetPoint("RIGHT", LootSheet, "TOPLEFT", 5, -17)
			button:SetSize(25, 25)
			button:SetText("+")
			button:SetScript('OnClick', function()
				ShowRow(RowsShowing+1)
			end)
end

function CreateRemoveRowButton()
	local button = CreateFrame("Button", "RemoveRowButton", LootSheet, "UIPanelButtonTemplate")
			button:SetPoint("TOP", AddRowButton, "BOTTOM", 0, 0)
			button:SetSize(25, 25)
			button:SetText("-")
			button:SetScript('OnClick', function()
				HideRow(RowsShowing)
			end)
end

function ShowRow(i)
	if i < 21 then
		LootSheet:SetHeight(LootSheet:GetHeight() + 40);
		NameBoxes[i]:Show()
		MainSpecBoxes[i]:Show()
		OffSpecBoxes[i]:Show()
		TransmogBoxes[i]:Show()
		RowsShowing = RowsShowing + 1
	end
end

function HideRow(i)
	if i > 0 then
		LootSheet:SetHeight(LootSheet:GetHeight() - 40);
		NameBoxes[i]:Hide()
		MainSpecBoxes[i]:Hide()
		OffSpecBoxes[i]:Hide()
		TransmogBoxes[i]:Hide()
		RowsShowing = RowsShowing - 1
	end
end

function CreateCloseButton()
	local button = CreateFrame("Button", "CloseButton", LootSheet, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOM", LootSheet, "BOTTOM", -70, 10)
	button:SetSize(50, 30)
	button:SetText("Close")
	button:SetScript("OnClick", function()
		SaveStrings()
		LootSheet:Hide()
	end)
end

function CreateClearButton()
	local button = CreateFrame("Button", "ClearButton", LootSheet, "UIPanelButtonTemplate")
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












--[=[
--Addon1
local addon, ns = ... -- get the addon name and common table.
ns.SomeVar = 666 -- create an entry in the table.
function ns:SomeFunc(arg1) -- create a function in the table.
    print(arg1)
end

-- ... all the other code in the file adding/using "ns" entries also used by other "modules".


--------------------
--Addon2
-- module testing
ns:SomeFunc(ns.SomeVar) -- prints 666

-- ... all the other code in the file adding/using "ns" entries also used by other "modules".

]=]