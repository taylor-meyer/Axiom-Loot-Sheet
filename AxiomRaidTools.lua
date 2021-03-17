------------------------------------------------------------------------------------------
-- Axiom Raid Tools --
--------------------
-- Author: Lypidius <Axiom> @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ... 

local LootRows = {}
local LootRowsUsed = 0

local LootNames = {}
local LootItemFrames = {}
local LootItemStrings = {}
local LootCheckButtons = {}
local LootItemLinks = {}

local CountdownTimer = 5

local RollRows = {}
local RollNames = {}
local RollRowsShowing = 0
local HighestRollValue = 0
local HighestRollText = nil

local CurrentSpreadsheet = 1


------------------------------------------------------------------------------------------


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
			-- Only show the loot results window if in Castle Nathria
			local _,_,_,_,_,_,_,instanceID = GetInstanceInfo()
			if instanceID == 2296 then
				ClearLootRows()
				LootResults:Show()
			end
		elseif event == "ENCOUNTER_LOOT_RECEIVED" then
			local encounterID, itemID, itemLink, quantity, itemName, fileName = ...
			local i = LootRowsUsed + 1
			LootRowsUsed = LootRowsUsed + 1
			LootItemLinks[i] = itemLink
			
			local _,_,itemQuality,_,_,itemType,_,_,_,_,_,_,_,_,_,_,_ = GetItemInfo(itemID) 
			
			if itemQuality >= 5 or itemType == "Consumable" or itemType == "Miscellaneous" then
				-- Do nothing
				LootRowsUsed = LootRowsUsed - 1
			elseif i < 25 then
				
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







ns:CreateSpreadsheetUI()
CreateLootResultsFrame()
CreateRollFrame()

--ns.SpreadsheetFrame:Hide()
