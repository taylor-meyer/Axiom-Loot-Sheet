LinkTable = {}
TextTable = {}
Items = {}
CharacterTable = {}
CheckButtons = {}
ofs = -50

------------------------------------------------------------------------------------------
local SavedVariablesFrame = CreateFrame("Frame")
SavedVariablesFrame:RegisterEvent("ADDON_LOADED")
SavedVariablesFrame:RegisterEvent("PLAYER_LOGOUT")

SavedVariablesFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "AxiomLootSheet" then
		-- Our saved variables have been loaded
		if CharacterStrings == nil then
			--print("Character strings are nil")
			-- This is the first time this addon is loaded; set SVs to default values
			CharacterStrings = {}
			MSStrings = {}
			OSStrings = {}
			TMOGStrings = {}
			for i=1, 20 do
				CharacterStrings[i] = "Character"
				MSStrings[i] = "MS"
				OSStrings[i] = "OS"
				TMOGStrings[i] = "TM"
			end
		end
	elseif event == "PLAYER_LOGOUT" then
		print("PLAYER_LOGOUT")
            -- Save the values when logout/reload
            for i=1, 20 do
				CharacterStrings[i] = CharacterBoxes[i]:GetText()
				MSStrings[i] = MSBoxes[i]:GetText()
				OSStrings[i] = OSBoxes[i]:GetText()
				TMOGStrings[i] = TMOGBoxes[i]:GetText()
			end
	end
end)
------------------------------------------------------------------------------------------


-------------------------------------------
-- Slash Commands --
-------------------------------------------
SLASH_AxiomLootSheet1 = "/axiom"
local function LootSheet(msg)
	print("Here is your loot sheet, sir Punk.")
	CreateMainFrame()
end
SlashCmdList["AxiomLootSheet"] = LootSheet


-------------------------------------------
-- Functions --
-------------------------------------------
function CreateMainFrame(self)

	if not Sheet then
	
		------------------------------------------------------------------------------------------
		-- main sheet
		local f = CreateFrame("Frame", "Sheet", UIParent)
		f:SetPoint("CENTER")
		f:SetSize(283, 1000)
		f:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		f:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		-- Movable
		f:SetMovable(true)
		f:SetClampedToScreen(true)
		f:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				self:StartMoving()
			end
		end)
		f:SetScript("OnMouseUp", f.StopMovingOrSizing)
		-----------------------------------------------------------------------------------------
	
		-----------------------------------------------------------------------------------------
		-- boxes
		CharacterBoxes = {}
		CharacterBoxes[1] = CreateFrame("EditBox", nil, Sheet)
		CharacterBoxes[1]:SetPoint("TOPLEFT", Sheet, "TOPLEFT", 25, -25)
		for i=2, 20 do
			CharacterBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			CharacterBoxes[i]:SetPoint("TOP", CharacterBoxes[i-1], "BOTTOM", 0, -5)
		end
	
	
		for i=1, 20 do
			CharacterBoxes[i]:SetSize(100, 40)
			CharacterBoxes[i]:SetMultiLine(false)
			CharacterBoxes[i]:SetAutoFocus(false)
			CharacterBoxes[i]:SetFontObject("ChatFontNormal")
			CharacterBoxes[i]:SetMaxLetters(12)
			CharacterBoxes[i]:SetText(CharacterStrings[i])
			CharacterBoxes[i]:SetTextInsets(8, 0, 0, 0)
			CharacterBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			CharacterBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		-----------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------
		MSBoxes = {}
		for i=1, 20 do
			MSBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			MSBoxes[i]:SetPoint("LEFT", CharacterBoxes[i], "RIGHT", 5, 0)
			MSBoxes[i]:SetSize(40, 40)
			MSBoxes[i]:SetMultiLine(false)
			MSBoxes[i]:SetAutoFocus(false)
			MSBoxes[i]:SetFontObject("ChatFontNormal")
			MSBoxes[i]:SetMaxLetters(2)
			MSBoxes[i]:SetText(MSStrings[i])
			MSBoxes[i]:SetTextInsets(8, 0, 0, 0)
			MSBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			MSBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		-----------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------
		OSBoxes = {}
		for i=1, 20 do
			OSBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			OSBoxes[i]:SetPoint("LEFT", MSBoxes[i], "RIGHT", 5, 0)
			-- textures
			OSBoxes[i]:SetSize(40, 40)
			OSBoxes[i]:SetMultiLine(false)
			OSBoxes[i]:SetAutoFocus(false)
			OSBoxes[i]:SetFontObject("ChatFontNormal")
			OSBoxes[i]:SetMaxLetters(2)
			OSBoxes[i]:SetText(OSStrings[i])
			OSBoxes[i]:SetTextInsets(8, 0, 0, 0)
			-- Texture
			OSBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			OSBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		-----------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------
		TMOGBoxes = {}
		for i=1, 20 do
			TMOGBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			TMOGBoxes[i]:SetPoint("LEFT", OSBoxes[i], "RIGHT", 5, 0)
			TMOGBoxes[i]:SetSize(40, 40)
			TMOGBoxes[i]:SetMultiLine(false)
			TMOGBoxes[i]:SetAutoFocus(false) -- dont automatically focus
			TMOGBoxes[i]:SetFontObject("ChatFontNormal")
			TMOGBoxes[i]:SetMaxLetters(2)
			TMOGBoxes[i]:SetText(TMOGStrings[i])
			TMOGBoxes[i]:SetTextInsets(8, 0, 0, 0)
			TMOGBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			TMOGBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		-----------------------------------------------------------------------------------------
		
		-----------------------------------------------------------------------------------------
		local CloseButton = CreateFrame('Button', nil, Sheet, "UIPanelButtonTemplate")
		CloseButton:SetPoint('BOTTOM', Sheet, 'BOTTOM', -60, 20)
		CloseButton:SetSize(75, 40)
		-- Texture
		CloseButton:SetText("Close")
		CloseButton:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		CloseButton:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		CloseButton:SetScript('OnClick', function()
		   Sheet:Hide()
		end)
		
		local ClearButton = CreateFrame('Button', nil, Sheet, "UIPanelButtonTemplate")
		ClearButton:SetPoint('BOTTOM', Sheet, 'BOTTOM', 60, 20)
		ClearButton:SetSize(75, 40)
		-- Texture
		ClearButton:SetText("Clear")
		ClearButton:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		ClearButton:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		ClearButton:SetScript('OnClick', function()
		
			StaticPopupDialogs["CLEAR_SHEET"] = {
				text = "Clear loot sheet?",
				button1 = "Yes",
				button2 = "No",
				OnAccept = function()
					ClearAllBoxes(CharacterBoxes, MSBoxes, OSBoxes, TMOGBoxes)
				end,
				timeout = 0,
				whileDead = true,
				hideOnEscape = true,
			}
			StaticPopup_Show ("CLEAR_SHEET")
		end)
	end
	Sheet:Show()
end

-- Clears all EditBoxes
function ClearAllBoxes(CharacterBoxes, MSBoxes, OSBoxes, TMOGBoxes)
	for i=1, 20 do
		CharacterBoxes[i]:SetText("")
		MSBoxes[i]:SetText("")
		OSBoxes[i]:SetText("")
		TMOGBoxes[i]:SetText("")
	
	end
end



-----------------------------------------------------------------------------------------
-- LOOT FRAME --
-----------------------------------------------------------------------------------------
local blf = CreateFrame("Frame", "BossLootFrame", UIParent)

blf:SetPoint("CENTER")
blf:SetSize(350, 500)
blf:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})

blf:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
blf:SetMovable(true)
blf:SetClampedToScreen(true)
--blf:SetHyperlinksEnabled()


blf:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		self:StartMoving()
	end
end)
blf:SetScript("OnMouseUp", BossLootFrame.StopMovingOrSizing)

blf:RegisterEvent("BOSS_KILL")
blf:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
blf:RegisterEvent("PLAYER_LOGIN")

local BossLootFrameText = BossLootFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
BossLootFrameText:SetPoint("TOP", 0, -25)
BossLootFrameText:SetText("Loot:")

blf:Hide()
-----------------------------------------------------------------------------------------


for i=1, 10 do

	local CharacterFontString = BossLootFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	CharacterFontString:SetPoint("TOPLEFT", 15, ofs)
	CharacterFontString:SetText(" ")
	CharacterTable[i] = CharacterFontString

	local ItemLinkFrame = CreateFrame("Frame", "LinkFrame" .. i, BossLootFrame)
	ItemLinkFrame:SetPoint("TOP", 0, ofs)
	ItemLinkFrame:SetSize(75,30)
	--ItemLinkFrame:EnableMouse(true)
	
	local ItemLinkText = ItemLinkFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	ItemLinkText:SetPoint("CENTER")
	
	LinkTable[i] = ItemLinkFrame
	TextTable[i] = ItemLinkText

	local CheckButton = CreateFrame("CheckButton", "AnnounceCheckButton" .. i, BossLootFrame, "ChatConfigCheckButtonTemplate")
	CheckButton:SetPoint("TOPRIGHT", -15, ofs + 7)
	CheckButton.tooltip = "Up for roll"
	CheckButton:SetChecked(false)
	CheckButton:HookScript("OnClick", function()
		-- do stuff
	end)
	
	CheckButton:Hide()
	CheckButtons[i] = CheckButton

	ofs = ofs - 50
end

BossLootFrame:SetScript("OnEvent", function(self, event, ...)

	if event == "BOSS_KILL" then
		BossLootFrame:Show()

	elseif event == "ENCOUNTER_LOOT_RECEIVED" then
	
		local encounterID, itemID, itemLink, quantity, itemName, fileName = ...
		--print(encounterID .. " " .. itemID .. " " .. itemLink .. " " .. quantity .. " " .. itemName .. " " .. fileName)
		
		-- Character name
		for i=1, 10 do
			if CharacterTable[i]:GetText() == " " then
				TableItr = i
				CharacterTable[i]:SetText(itemName)
				--CharacterTable[TableItr]:SetText(itemName)
				break
			end
		end

		-- Set Text
		TextTable[TableItr]:SetText(itemLink)
			
		-- Mouse over script
		LinkTable[TableItr]:HookScript("OnEnter", function()
		  if (itemLink) then
			GameTooltip:SetOwner(LinkTable[TableItr], "ANCHOR_TOP")
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show()
		  end
		end)
		 
		LinkTable[TableItr]:HookScript("OnLeave", function()
		  GameTooltip:Hide()
		end)
		
		CheckButtons[TableItr]:Show()
		
		Items[TableItr] = itemLink
		
	end	
end)


-- close button
-----------------------------------------------------------------------------------------
local CloseButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
CloseButton:SetPoint('BOTTOM', BossLootFrame, 'BOTTOM', -50, 20)
CloseButton:SetSize(75, 40)
-- Texture
CloseButton:SetText("Close")
CloseButton:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
CloseButton:SetBackdropBorderColor(0, .44, .87, 0.5)
CloseButton:SetScript('OnClick', function()

	StaticPopupDialogs["CLOSE_WINDOW"] = {
		text = "Close loot sheet? (Everything you see will enter the maw)",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function()
			CloseLootSheet()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
	}
	StaticPopup_Show ("CLOSE_WINDOW")
end)

-- Clears all EditBoxes
function CloseLootSheet()
	BossLootFrame:Hide()
	ofs = -50
	for i=1, 10 do
		CharacterTable[i]:SetText(" ")
		TextTable[i]:SetText(" ")
		CheckButtons[i]:SetChecked(false)
		CheckButtons[i]:Hide()
		Items = {}
	end	
end


--- raid warning button
-----------------------------------------------------------------------------------------
LootAnnounceButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
LootAnnounceButton:SetPoint('BOTTOM', BossLootFrame, 'BOTTOM', 50, 20)
LootAnnounceButton:SetSize(85, 40)
LootAnnounceButton:SetText("Announce")
LootAnnounceButton:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
LootAnnounceButton:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
LootAnnounceButton:SetScript('OnClick', function()
   RWmsg = " "
   -- announce loop
   for i=1, 10 do
		-- add item to msg if checkbox is checked
		if CheckButtons[i]:GetChecked() == true then
			RWmsg = RWmsg .. Items[i]
		end
   end
   
   SendChatMessage(RWmsg, "RAID_WARNING", nil, "channel");
   
end)

--[=====[ 
-- code I found online to generate an item link from equipped mainhand weapon
local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
local _, itemLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)
-- send it to chat window to test it works and it does, you can click it in the window and see the item
DEFAULT_CHAT_FRAME:AddMessage(itemLink)
--]=====]

-- table size
--print(     "table size: " ..         (table.getn(ItemLinkTable))    )
