------------------------------------------------------------------------------------------
-- AxiomLootSheet --
--------------------
-- Author: Lypidius <Axiom> @ US-MoonGuard
------------------------------------------------------------------------------------------

NameBoxes = {}
MainSpecBoxes = {}
OffSpecBoxes = {}
TransmogBoxes = {}

RowsShowing = 0

LootRows = {}
LootRowsUsed = 0

LootNames = {}
LootItemFrames = {}
LootItemStrings = {}
LootCheckButtons = {}
LootItemLinks = {}

CountdownTimer = 5

RollRows = {}
RollNames = {} 
RollRowsShowing = 0
HighestRollValue = 0
HighestRollText = nil

CurrentSpreadsheet = 1

print("Running AxiomLootSheet v1.5.2")
------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------
-- Saved Variables --
------------------------------------------------------------------------------------------
local SavedVariablesFrame = CreateFrame("Frame")
SavedVariablesFrame:RegisterEvent("ADDON_LOADED")
SavedVariablesFrame:RegisterEvent("PLAYER_LOGOUT")
SavedVariablesFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "AxiomLootSheet" then
		
		if SpreadsheetSave == nil then
			-- First time loading addon
			SetDefaultValues()
		else
			-- SavedVariables do exist
			LoadSpreadsheet(SpreadsheetSave[1])
		end
	elseif event == "PLAYER_LOGOUT" then
		-- Save the values when player logout/reload
		
		if CurrentSpreadsheet == 1 then
			SaveSpreadsheet(1)
		elseif CurrentSpreadsheet == 2 then
			SaveSpreadsheet(2)
		else -- CurrentSpreadsheet == 3
			SaveSpreadsheet(3)
		end
		
		-- Temporary
		--SpreadsheetSave = nil
	end
end)
------------------------------------------------------------------------------------------





------------------------------------------------------------------------------------------
-- Slash Commands --
------------------------------------------------------------------------------------------
SLASH_SPREADSHEET1 = "/axiom"
SlashCmdList["SPREADSHEET"] = function(msg, editBox)
	if msg == "loots" then
		if LootResults:IsVisible() then
			LootResults:Hide()
		else
			LootResults:Show()
		end
	else
		if LootSheet:IsVisible() then
			LootSheet:Hide()
		else
			print("Here is your loot sheet, sir Punk.")
			LootSheet:Show()
		end
	end
end
------------------------------------------------------------------------------------------

function SetDefaultValues()
	-- For new spreadsheet tabs
	NormalNameStrings = {}
	NormalMainSpecCount = {}
	NormalOffSpecCount = {}
	NormalTransmogCount = {}

	HeroicNameStrings = {}
	HeroicMainSpecCount = {}
	HeroicOffSpecCount = {}
	HeroicTransmogCount = {}

	MythicNameStrings = {}
	MythicMainSpecCount = {}
	MythicOffSpecCount = {}
	MythicTransmogCount = {}

	for i=1,20 do
		NormalNameStrings[i] = "NoName"
		NormalMainSpecCount[i] = "MS"
		NormalOffSpecCount[i] = "OS"
		NormalTransmogCount[i] = "TM"
		
		HeroicNameStrings[i] = "HeName"
		HeroicMainSpecCount[i] = "MS"
		HeroicOffSpecCount[i] = "OS"
		HeroicTransmogCount[i] = "TM"
		
		MythicNameStrings[i] = "MyName"
		MythicMainSpecCount[i] = "MS"
		MythicOffSpecCount[i] = "OS"
		MythicTransmogCount[i] = "TM"
	end

	NormalSpreadsheet = {
		NormalNameStrings,
		NormalMainSpecCount,
		NormalOffSpecCount,
		NormalTransmogCount
	}
	HeroicSpreadsheet = {
		HeroicNameStrings,
		HeroicMainSpecCount,
		HeroicOffSpecCount,
		HeroicTransmogCount
	}
	MythicSpreadsheet = {
		MythicNameStrings,
		MythicMainSpecCount,
		MythicOffSpecCount,
		MythicTransmogCount
	}

	SpreadsheetSave = {
		NormalSpreadsheet,
		HeroicSpreadsheet,
		MythicSpreadsheet
	}

	print("loaded default values")

end

function LoadSpreadsheet(Spreadsheet)

	Names = Spreadsheet[1]
	MS = Spreadsheet[2]
	OS = Spreadsheet[3]
	TM = Spreadsheet[4]

	for i=1,20 do
		NameBoxes[i]:SetText(Names[i])
		MainSpecBoxes[i]:SetText(MS[i])
		OffSpecBoxes[i]:SetText(OS[i])
		TransmogBoxes[i]:SetText(TM[i])
	end
end

function SaveSpreadsheet(tab)

	Names = {}
	MS = {}
	OS = {}
	TM = {}

	for i=1,20 do
	
		Names[i] = NameBoxes[i]:GetText()
		MS[i] = MainSpecBoxes[i]:GetText()
		OS[i] = OffSpecBoxes[i]:GetText()
		TM[i] = TransmogBoxes[i]:GetText()
	
	
	end

	Sheet = {Names, MS, OS, TM}

	if tab == 1 then
		SpreadsheetSave[1] = Sheet
	elseif tab == 2 then
		SpreadsheetSave[2] = Sheet
	else -- tab == 3
		SpreadsheetSave[3] = Sheet
	end

end

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
			--CreateCloseButton()
			CreateClearButton()
			
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

function SaveStrings()
	for i=1, 20 do
		NameStrings[i] = NameBoxes[i]:GetText()
		MainSpecCount[i] = MainSpecBoxes[i]:GetText()
		OffSpecCount[i] = OffSpecBoxes[i]:GetText()
		TransmogCount[i] = TransmogBoxes[i]:GetText()
	end
end

function LoadSavedStrings()
	for i=1,20 do
		NameBoxes[i]:SetText(NameStrings[i])
		MainSpecBoxes[i]:SetText(MainSpecCount[i])
		OffSpecBoxes[i]:SetText(OffSpecCount[i])
		TransmogBoxes[i]:SetText(TransmogCount[i])
	end
end

function ClearAllRows()
	for i=1,20 do
		NameBoxes[i]:SetText("")
		MainSpecBoxes[i]:SetText("")
		OffSpecBoxes[i]:SetText("")
		TransmogBoxes[i]:SetText("")
	end
end

------------------------------------------------------------------------------------------

function CreateLootResultsFrame()
	local f = CreateFrame("Frame", "LootResults", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	f:SetPoint("CENTER")
	f:SetSize(450, 130)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
		edgeSize = 16,
		insets = { left = 8, right = 6, top = 8, bottom = 8 },
	})
	f:SetBackdropBorderColor(1, 0, 0, .5)
	
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
	
	-- Title text
	local text = LootResults:CreateFontString(LootResultsTitleText, "OVERLAY", "GameFontNormal")
	text:SetPoint("TOP", 0, -25)
	text:SetText("ENCOUNTER LOOT!")
	
	-- Moveable
	f:SetMovable(true)
	f:SetClampedToScreen(true)
	f:SetScript("OnMouseDown", function(self, button)
		if button == "LeftButton" then
			self:StartMoving()
		end
	end)
	f:SetScript("OnMouseUp", LootResults.StopMovingOrSizing)
	
	-- Events
	f:RegisterEvent("BOSS_KILL")
	f:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
	
	f:SetScript("OnEvent", function(self, event, ...)
		if event == "BOSS_KILL" then
			ClearLootRows()
			LootResults:Show()
		elseif event == "ENCOUNTER_LOOT_RECEIVED" then
			local encounterID, itemID, itemLink, quantity, itemName, fileName = ...
			local i = LootRowsUsed + 1
			LootRowsUsed = LootRowsUsed + 1
			--print("i: " .. i)
			--print("LRU: " .. LootRowsUsed)
			LootItemLinks[i] = itemLink
			if i < 25 then
				s = strsub(itemName, 1, 12)
				--print("Player that got loot: " .. itemName .. " SubStr: " .. s)
				LootRows[i]:Show()
				LootResults:SetHeight(LootResults:GetHeight() + 30)
				LootNames[i]:SetText(s)
				LootItemStrings[i]:SetText(itemLink)
				LootItemFrames[i]:HookScript("OnEnter", function()
					if (itemLink) then
						GameTooltip:SetOwner(f, "ANCHOR_TOP")
						GameTooltip:SetHyperlink(itemLink)
						GameTooltip:Show()
					end
				end)
				LootItemFrames[i]:HookScript("OnLeave", function()
					GameTooltip:Hide()
				end)
			end
		end
	end)
	
	CreateRows()
	CreateLootAnnounceButton()
	CreateRollMainSpecButton()
	CreateRollOffSpecButton()
	CreateRollTransmogSpecButton()
	CreateCountdownButton()
	
	LootResults:Hide()
end

function CreateRows()

	--local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
	--local _, itemLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)

	for i=1,25 do
	
		local row = CreateFrame("Frame", "Row " .. i, LootResults, BackdropTemplateMixin and "BackdropTemplate")
		row:SetPoint("TOPLEFT", 10, -5 - (30 * i))
		row:SetSize(415, 40)
		row:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		row:SetBackdropBorderColor(1, 0, 0, 0)
		row:Hide()
		-----------------------------------------------------------------------------------------
		
		local name = row:CreateFontString("NameFontString" .. i, "OVERLAY", "GameFontNormal")
		name:SetPoint("LEFT", 10, 0)
		-----------------------------------------------------------------------------------------
		
		-- Item frame size is big enough to encompass: "Merciless Gladiator's Crossbow of the Phoenix"
		-- (the longest item name in the game)
		local f = CreateFrame("Frame", "ItemFrame" .. i, row)
		f:SetPoint("LEFT", name, "RIGHT", 0, 0)
		f:SetSize(300,40)
		-----------------------------------------------------------------------------------------
		
		local s = f:CreateFontString("ItemString" .. i, "OVERLAY", "GameFontNormal")
		s:SetPoint("LEFT", 10, 0)
		-----------------------------------------------------------------------------------------
		
		local c = CreateFrame("CheckButton", "LootCheckButton"  .. i, row, "ChatConfigCheckButtonTemplate")
		c:SetPoint("RIGHT", 17, 0)
		c.tooltip = "Up for roll"
		c:SetChecked(false)
		c:HookScript("OnClick", function()
			-- do stuff
			--print("CheckButton clicked")
		end)
		
		LootNames[i] = name
		LootItemFrames[i] = f
		LootItemStrings[i] = s
		LootCheckButtons[i] = c
		LootRows[i] = row
	end
end

function CreateLootAnnounceButton()
	local button = CreateFrame("Button", "AnnounceButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOM", 0, 20)
	button:SetSize(80, 40)
	button:SetText("Announce")
	button:SetScript("OnClick", function()
		inInstance, instanceType = IsInInstance()
		if inInstance == false then
			print("Not in an instance!")
		elseif instanceType ~= "raid" then
			print("Not in a raid!")
		else
			-- announce loop
			for i=1,25 do
				if LootCheckButtons[i]:GetChecked() == true then
					SendChatMessage(LootItemLinks[i], "RAID_WARNING", nil, "channel")
				end
			end
		end
	end)
end

function CreateRollMainSpecButton()
	local button = CreateFrame("Button", "MainSpecRollButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("BOTTOMLEFT", AnnounceButton, "TOPLEFT", 0, 0)
	button:SetSize(35, 25)
	button:SetText("MS")
	button:SetScript("OnClick", function()
		inInstance, instanceType = IsInInstance()
		if inInstance == false then
			print("Not in an instance!")
		elseif instanceType ~= "raid" then
			print("Not in a raid!")
		else
			for i=1,25 do
				if LootCheckButtons[i]:GetChecked() == true then
					SendChatMessage("ROLL FOR MS: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
					ResetRolls()
					RollFrame:RegisterEvent("CHAT_MSG_SYSTEM")
					break;
				end
			end
		end
	end)
	
	-- Use for testing outside of a raid
	--[=====[
	button:SetScript("OnClick", function()
			for i=1,25 do
				if LootCheckButtons[i]:GetChecked() == true then
					SendChatMessage("ROLL FOR MS: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
					ResetRolls()
					RollFrame:RegisterEvent("CHAT_MSG_SYSTEM")
					break;
				end
			end
	end)
	--]=====]
end

function CreateRollOffSpecButton()
	local button = CreateFrame("Button", "OffSpecRollButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", MainSpecRollButton, "RIGHT", 0, 0)
	button:SetSize(35, 25)
	button:SetText("OS")
	button:SetScript("OnClick", function()
		inInstance, instanceType = IsInInstance()
		if inInstance == false then
			print("Not in an instance!")
		elseif instanceType ~= "raid" then
			print("Not in a raid!")
		else
			for i=1,25 do
				if LootCheckButtons[i]:GetChecked() == true then
					SendChatMessage("ROLL FOR OS: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
					ResetRolls()
					RollFrame:RegisterEvent("CHAT_MSG_SYSTEM")
					break;
				end
			end
		end
	end)
end

function CreateRollTransmogSpecButton()

	local button = CreateFrame("Button", "TransmogRollButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", OffSpecRollButton, "RIGHT", 0, 0)
	button:SetSize(35, 25)
	button:SetText("TM")
	button:SetScript("OnClick", function()
	
		inInstance, instanceType = IsInInstance()
		if inInstance == false then
			print("Not in an instance!")
		elseif instanceType ~= "raid" then
			print("Not in a raid!")
		else
			for i=1,25 do
				if LootCheckButtons[i]:GetChecked() == true then
					SendChatMessage("ROLL FOR TMOG: " .. LootItemLinks[i], "RAID_WARNING", nil, "channel")
					ResetRolls()
					RollFrame:RegisterEvent("CHAT_MSG_SYSTEM")
					break;
				end
			end
		end
	end)
end

function CreateCountdownButton()
	local button = CreateFrame("Button", "CountdownButton", LootResults, "UIPanelButtonTemplate")
	button:SetPoint("LEFT", AnnounceButton, "RIGHT", 0, 0)
	button:SetPoint("TOPRIGHT", TransmogRollButton, "BOTTOMRIGHT", 0, 0)
	button:SetSize(35, 40)
	button:SetText("5")
	button:SetScript("OnClick", function()
		inInstance, instanceType = IsInInstance()
		if inInstance == false then
			print("Not in an instance!")
		elseif instanceType ~= "raid" then
			print("Not in a raid!")
		else
			Countdown()
			-- Countdown is over, stop looking for rolls
			RollFrame:UnregisterEvent("CHAT_MSG_SYSTEM")
			C_Timer.After(6, function() CountdownTimer = 5 end)
		end
	end)
end

function Countdown()
	SendChatMessage(CountdownTimer, "RAID_WARNING", nil, "channel");
	if CountdownTimer ~=1 then
		CountdownTimer = CountdownTimer - 1
		C_Timer.After(1, Countdown)
	end
end

function ClearLootRows()
	LootResults:SetHeight(130)
	LootRowsUsed = 0
	for i=1,25 do
		LootRows[i]:Hide()
		LootNames[i]:SetText("")
		LootItemStrings[i]:SetText("")
		LootCheckButtons[i]:SetChecked(false)
	end
end
------------------------------------------------------------------------------------------

function CreateRollFrame()
	local f = CreateFrame("Frame", "RollFrame", LootResults, BackdropTemplateMixin and "BackdropTemplate")
	f:SetPoint("TOPLEFT", LootResults, "TOPRIGHT")
	f:SetSize(137, 0)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
		edgeSize = 16,
		insets = { left = 8, right = 6, top = 8, bottom = 8 },
	})
	f:SetBackdropBorderColor(255, 215, 0, .5)
	
	-- Events
	RollFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "CHAT_MSG_SYSTEM" then
			-- get event payload
			local message = ...
			local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)")
			-- is a roll?
			if author and rollResult and rollMin and rollMax then
				Payload = {
					Author = author,
					RollResult = rollResult,
					RollMin = rollMin,
					RollMax = rollMax
				}
				
				if RollFrame:IsVisible() == false then
					RollFrame:Show()
				end
				
				DetermineCurrentWinner(Payload)
			end
		end
	end)
	CreateRollRows()
end

function CreateRollRows()
	for i=1,20 do
		local row = CreateFrame("Frame", "RollRow" .. i, RollFrame)
		row:SetPoint("TOP", 0, 25-(30 * i))
		row:SetSize(125, 40)
		
		local name = row:CreateFontString("RollFontString", "OVERLAY", "GameFontNormal")
		name:SetPoint("LEFT", 9, 0)
		
		row:Hide()
		RollRows[i] = row
		RollNames[i] = name
	end
end

function ShowRollRow(i)
	if i < 21 then
		if i==1 then
			RollFrame:SetHeight(RollFrame:GetHeight() + 49)
		else
			RollFrame:SetHeight(RollFrame:GetHeight() + 30)
		end
		RollRows[i]:Show()
		RollRowsShowing = RollRowsShowing + 1
	end
end

function DetermineCurrentWinner(Payload)
	if RollRowsShowing ~= 20 then
		--- show new roll
		ShowRollRow(RollRowsShowing+1)
		RollNames[RollRowsShowing]:SetText(Payload.RollResult .. " - " .. Payload.Author)
		-- if roll is higher than the current winner
		if tonumber(Payload.RollResult) > HighestRollValue then
			-- set it to the new highest value and change display to green
			HighestRollValue = tonumber(Payload.RollResult)
			RollNames[RollRowsShowing]:SetTextColor(0, 1, 0, 1)
			-- reset all others to yellow
			-- for loop incase of ties that are showing multiple greens
			for i=1,(RollRowsShowing-1) do
				RollNames[i]:SetTextColor(1, 1, 0, 1)
			end
			-- set highest text to new row
			HighestRollText = RollNames[RollRowsShowing]
		-- if there is a tie with current winner, also set it to green
		-- but no need to change anyone else back to yellow
		-- or change the current max
		elseif tonumber(Payload.RollResult) == HighestRollValue then
			RollNames[RollRowsShowing]:SetTextColor(0, 1, 0, 1)
		end
	end
end

function ResetRolls()
	RollFrame:SetSize(137, 0)
	for i=1,20 do
		RollNames[i]:SetText("")
	end
	RollRowsShowing = 0
	RollFrame:Hide()
	HighestRollValue = 0
	HighestRollText = nil
end
------------------------------------------------------------------------------------------

CreateLootSheet()
CreateLootResultsFrame()
CreateRollFrame()



-- NEW THINGS!

local Tab_1 = CreateFrame("Button", "$parentTab1", LootSheet, "TabButtonTemplate");

-- TODO
-- Below not working even afte importing new 9.01 templates. Fix later. 
--[=====[ 
Tab_1:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
				})
Tab_1:SetBackdropBorderColor(1, 0, 0, .5)
--]=====]

Tab_1:SetID(1);
Tab_1:SetPoint("BOTTOMLEFT", LootSheet, "TOPLEFT", 9, -5);
Tab_1:SetText("Normal");
PanelTemplates_TabResize(Tab_1, 0)

local Tab_2 = CreateFrame("Button", "$parentTab2", LootSheet, "TabButtonTemplate");
Tab_2:SetID(2);
Tab_2:SetPoint("LEFT", Tab_1, "RIGHT", 3, 0);
Tab_2:SetText("Heroic");
PanelTemplates_TabResize(Tab_2, 0)

local Tab_3 = CreateFrame("Button", "$parentTab2", LootSheet, "TabButtonTemplate");
Tab_3:SetID(3);
Tab_3:SetPoint("LEFT", Tab_2, "RIGHT", 3, 0);
Tab_3:SetText("Mythic");
PanelTemplates_TabResize(Tab_3, 0)




Tab_1:SetScript('OnClick', function()
	print("tab1")
end)

Tab_2:SetScript('OnClick', function()
	print("tab2")
end)

Tab_3:SetScript('OnClick', function()
	print("tab3")
end)



LootSheet:Show()









--[=====[ 
-- Code I found online to generate an itemLink from the equipped mainhand weapon
	local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
	local _, itemLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)
-- send it to chat window to test it works and it does, you can click it in the window and see the item
	DEFAULT_CHAT_FRAME:AddMessage(itemLink)
--]=====]

-- How to get size of a table if I need it
--print("Table size: " .. (table.getn(ItemLinkTable)))
