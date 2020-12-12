------------------------------------------------------------------------------------------
-- AxiomLootSheet --
--------------------
-- Author: Lypidius <Axiom> @ US-MoonGuard
------------------------------------------------------------------------------------------
local addon, ns = ... -- Addon name & common namespace




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

print("Running AxiomLootSheet v1.6.1")
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- Saved Variables --
------------------------------------------------------------------------------------------
local SavedVariablesFrame = CreateFrame("Frame")
SavedVariablesFrame:RegisterEvent("ADDON_LOADED")
SavedVariablesFrame:RegisterEvent("PLAYER_LOGOUT")
SavedVariablesFrame:SetScript("OnEvent", function(self, event, arg1)
	-- Player login
	if event == "ADDON_LOADED" and arg1 == "AxiomLootSheet" then
		-- First time loading addon
		if SpreadsheetSave == nil then
			SetDefaultValues()
		end
		LoadSpreadsheet(SpreadsheetSave[1])
	-- Player logout/reload
	elseif event == "PLAYER_LOGOUT" then
		if CurrentSpreadsheet == 1 then
			SaveSpreadsheet(1)
		elseif CurrentSpreadsheet == 2 then
			SaveSpreadsheet(2)
		else -- CurrentSpreadsheet == 3
			SaveSpreadsheet(3)
		end
	end
end)
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- Slash Commands --
------------------------------------------------------------------------------------------
SLASH_SPREADSHEET1 = "/axiom"
SlashCmdList["SPREADSHEET"] = function(msg, editBox)
	-- /axiom loots
	if msg == "loots" then
		if LootResults:IsVisible() then
			LootResults:Hide()
		else
			LootResults:Show()
		end
	-- /axiom
	else
		if ns.SpreadsheetFrame:IsVisible() then
			ns.SpreadsheetFrame:Hide()
		else
			ns.SpreadsheetFrame:Show()
		end
	end
end
------------------------------------------------------------------------------------------




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



-- Initializes saved variable if it doesn't already exist
function SetDefaultValues()
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
end

-- Displays spreadsheet value to EditBoxes
function LoadSpreadsheet(Spreadsheet)
	local Names = Spreadsheet[1]
	local MS = Spreadsheet[2]
	local OS = Spreadsheet[3]
	local TM = Spreadsheet[4]
	for i=1,20 do
		ns.NameBoxes[i]:SetText(Names[i])
		ns.MainSpecBoxes[i]:SetText(MS[i])
		ns.OffSpecBoxes[i]:SetText(OS[i])
		ns.TransmogBoxes[i]:SetText(TM[i])
	end
end

-- Saves values of EditBoxes to appropriate spreadsheet
function SaveSpreadsheet(TabID)
	local Names = {}
	local MS = {}
	local OS = {}
	local TM = {}
	for i=1,20 do
		Names[i] = ns.NameBoxes[i]:GetText()
		MS[i] = ns.MainSpecBoxes[i]:GetText()
		OS[i] = ns.OffSpecBoxes[i]:GetText()
		TM[i] = ns.TransmogBoxes[i]:GetText()
	end
	Sheet = {Names, MS, OS, TM}
	
	-- 1 -> Normal
	-- 2 -> Heroic
	-- 3 -> Mythic
	if TabID == 1 then
		SpreadsheetSave[1] = Sheet
	elseif TabID == 2 then
		SpreadsheetSave[2] = Sheet
	else -- TabID == 3
		SpreadsheetSave[3] = Sheet
	end
end

























------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- Loot Results --
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
			LootItemLinks[i] = itemLink
			if i < 25 then
				s = strsub(itemName, 1, 12)
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

------------------------------------------------------------------------------------------
-- Roll Tracking --
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



ns:CreateSpreadsheetUI()
CreateLootResultsFrame()
CreateRollFrame()


