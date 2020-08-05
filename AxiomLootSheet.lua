LinkTable = {}
TextTable = {}
Items = {}
CharacterTable = {}
CheckButtons = {}
ofs = -50
SheetIterator = 1 -- This is currently a saved variable and it doesn't need to be, future fix
countTimer = 5
highestScore = 0
currentWinner = 1

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
				SheetIterator = 1 -- Band-aid for saved variables
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
	
		local sheety = 80
	
		------------------------------------------------------------------------------------------
		-- main sheet
		local f = CreateFrame("Frame", "Sheet", UIParent)
		f:SetPoint("TOP", 0, -25)
		f:SetSize(300, sheety)
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
		
		-- add button
		local AddRowButton = CreateFrame('Button', nil, Sheet, "UIPanelButtonTemplate")
		AddRowButton:SetPoint('TOPLEFT', Sheet, 'TOPLEFT', 12, -25)
		AddRowButton:SetSize(25, 25)
		AddRowButton:SetText("+")
		AddRowButton:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
			edgeSize = 16,
			insets = { left = 8, right = 6, top = 8, bottom = 8 },
		})
		AddRowButton:SetBackdropBorderColor(0, 0, 0, 0)
		AddRowButton:SetScript('OnClick', function()
		
			-- TODO ADD ROW
			if SheetIterator < 21 then
				CharacterBoxes[SheetIterator]:Show()
				MSBoxes[SheetIterator]:Show()
				OSBoxes[SheetIterator]:Show()
				TMOGBoxes[SheetIterator]:Show()
				SheetIterator = SheetIterator + 1
				sheety = sheety + 45
				Sheet:SetSize(300, sheety)
				Sheet:Show()
			end
		end)	
		
		-----------------------------------------------------------------------------------------
		-- boxes
		CharacterBoxes = {}
		CharacterBoxes[1] = CreateFrame("EditBox", nil, Sheet)
		CharacterBoxes[1]:SetPoint("TOPLEFT", Sheet, "TOPLEFT", 35, -25)
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
			CharacterBoxes[i]:Hide()
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
			MSBoxes[i]:Hide()
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
			OSBoxes[i]:Hide()
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
			TMOGBoxes[i]:Hide()
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
		CloseButton:SetBackdropBorderColor(0, 0, 0, 0)
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
		ClearButton:SetBackdropBorderColor(0, 0, 0, 0)
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
	ItemLinkFrame:SetPoint("TOP", 0, ofs+10)
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
CloseButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
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
CloseButton:SetBackdropBorderColor(0, 0, 0, 0)
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

-- Clears loot sheet
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
	ClearRollFrame()
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
LootAnnounceButton:SetBackdropBorderColor(0, 0, 0, 0)
LootAnnounceButton:SetScript('OnClick', function()
   -- announce loop
   for i=1, 10 do
		-- add item to msg if checkbox is checked
		if CheckButtons[i]:GetChecked() == true then
			SendChatMessage(Items[i], "SAY", nil, "channel");
		end
   end
end)


--- ms roll button
-----------------------------------------------------------------------------------------
MSAnnounceButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
MSAnnounceButton:SetPoint('BOTTOM', BossLootFrame, 'BOTTOM', -110, 70)
MSAnnounceButton:SetSize(85, 40)
MSAnnounceButton:SetText("ROLL MS")
MSAnnounceButton:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
MSAnnounceButton:SetBackdropBorderColor(0, 0, 0, 0)
MSAnnounceButton:SetScript('OnClick', function()
	print("MS Roll Button Clicked")
   -- roll loop
	for i=1, 10 do
		-- add item to msg if checkbox is checked
		if CheckButtons[i]:GetChecked() == true then
			SendChatMessage("ROLL FOR MS: " .. Items[i], "SAY", nil, "channel");
			break;
		end
	end
end)


--- os roll button
-----------------------------------------------------------------------------------------
OSAnnounceButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
OSAnnounceButton:SetPoint('BOTTOM', BossLootFrame, 'BOTTOM', -20, 70)
OSAnnounceButton:SetSize(85, 40)
OSAnnounceButton:SetText("ROLL OS")
OSAnnounceButton:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
OSAnnounceButton:SetBackdropBorderColor(0, 0, 0, 0)
OSAnnounceButton:SetScript('OnClick', function()
	print("OS Roll Button Clicked")
	-- roll loop
	for i=1, 10 do
		-- add item to msg if checkbox is checked
		if CheckButtons[i]:GetChecked() == true then
			SendChatMessage("ROLL FOR OS: " .. Items[i], "SAY", nil, "channel");
			break;
		end
	end
end)


--- tmog roll button
-----------------------------------------------------------------------------------------
TMAnnounceButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
TMAnnounceButton:SetPoint('BOTTOM', BossLootFrame, 'BOTTOM', 70, 70)
TMAnnounceButton:SetSize(85, 40)
TMAnnounceButton:SetText("ROLL TM")
TMAnnounceButton:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
TMAnnounceButton:SetBackdropBorderColor(0, 0, 0, 0)
TMAnnounceButton:SetScript('OnClick', function()
	print("TM Roll Button Clicked")
	-- roll loop
	for i=1, 10 do
		-- add item to msg if checkbox is checked
		if CheckButtons[i]:GetChecked() == true then
			SendChatMessage("ROLL FOR TMOG: " .. Items[i], "SAY", nil, "channel");
			break;
		end
	end
end)

--- 5 seconds countdown button
-----------------------------------------------------------------------------------------
CountdownButton = CreateFrame('Button', nil, BossLootFrame, "UIPanelButtonTemplate")
CountdownButton:SetPoint('BOTTOM', BossLootFrame, 'BOTTOM', 140, 70)
CountdownButton:SetSize(35, 40)
CountdownButton:SetText("5")
CountdownButton:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
CountdownButton:SetBackdropBorderColor(0, 0, 0, 0)
CountdownButton:SetScript('OnClick', function()
	print("Countdown Button Clicked")
	Countdown()
	C_Timer.After(6, function() countTimer = 5 end)
	
end)

function Countdown()
	SendChatMessage(countTimer, "SAY", nil, "channel");
	if countTimer ~=1 then
		countTimer = countTimer - 1
		C_Timer.After(1, Countdown)
	end
end




-- roll frame
CreateFrame("Frame", "RollFrame", BossLootFrame)
RollFrame:SetPoint("TOPRIGHT", 150, 0)
RollFrame:SetSize(150, 500)
RollFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
RollFrame:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue

local RollFrameText = RollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
RollFrameText:SetPoint("TOP", 0, -10)
RollFrameText:SetText("Rolls:")



-- table for names
RollNames = {}
RollScores = {}

for i=1, 30 do

	local name = RollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	name:SetPoint("TOPLEFT", 12, -17-(i*15))
	name:SetText(" ")
	
	RollNames[i] = name;

	
	
	local score = RollFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	score:SetPoint("TOPRIGHT", -12, -17-(i*15))
	score:SetText(" ")
	
	RollScores[i] = score
	
	RollNames[i]:SetTextColor(1, 1, 1, 1)
	RollScores[i]:SetTextColor(1, 1, 1, 1)
end

--event
RollFrame:RegisterEvent("CHAT_MSG_SYSTEM")

RollFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_SYSTEM" then

		-- get rolls
		local message = ...
		local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)")
		--print(author .. " " .. rollResult .. " " .. rollMin .. " " .. rollMin)
		if author then
			--Do stuff here
			
		
			for i=1, 30 do
				if RollNames[i]:GetText() == " " then
					RollNames[i]:SetText(author)
					RollScores[i]:SetText(rollResult)
					--CharacterTable[TableItr]:SetText(itemName)
					
					if tonumber(rollResult) > highestScore then
						highestScore = tonumber(rollResult) -- set winner to green
						RollNames[i]:SetTextColor(0, 1, 0, 1)
						RollScores[i]:SetTextColor(0, 1, 0, 1)
						currentWinner = i -- new winner
						
						for k=1,i-1 do
							RollNames[k]:SetTextColor(1, 1, 1, 1)
							RollScores[k]:SetTextColor(1, 1, 1, 1)
						end
					
				
					
					
					elseif tonumber(rollResult) == highestScore then
						RollNames[i]:SetTextColor(0, 0, 1, 1)
						RollScores[i]:SetTextColor(0, 0, 1, 1)
					end
					
					break
				end
			end
		end
	end
end)

--- roll frame clear button
-----------------------------------------------------------------------------------------
RollFrameClear = CreateFrame('Button', nil, RollFrame, "UIPanelButtonTemplate")
RollFrameClear:SetPoint('BOTTOM', RollFrame, 'BOTTOM', 0, 20)
RollFrameClear:SetSize(55, 40)
RollFrameClear:SetText("Clear")
RollFrameClear:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight",
	edgeSize = 16,
	insets = { left = 8, right = 6, top = 8, bottom = 8 },
})
RollFrameClear:SetBackdropBorderColor(0, 0, 0, 0)
RollFrameClear:SetScript('OnClick', function()
	print("rlf clear button")
	ClearRollFrame()
end)


-- Clears all EditBoxes
function ClearRollFrame()
	highestScore = 0
	currentWinner = 1
	for i=1,30 do
		RollNames[i]:SetText(" ")
		RollScores[i]:SetText(" ")
	end	
end










--[=====[ 
-- code I found online to generate an item link from equipped mainhand weapon
local mainHandLink = GetInventoryItemLink("player",GetInventorySlotInfo("MainHandSlot"))
local _, itemLink, _, _, _, _, itemType = GetItemInfo(mainHandLink)
-- send it to chat window to test it works and it does, you can click it in the window and see the item
DEFAULT_CHAT_FRAME:AddMessage(itemLink)
--]=====]

-- table size
--print(     "table size: " ..         (table.getn(ItemLinkTable))    )
