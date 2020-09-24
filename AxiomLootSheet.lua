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
-- AxiomLootSheet --
--------------------
-- Author: Lypidius <Axiom> @ US-MoonGuard
------------------------------------------------------------------------------------------

NameBoxes = {}
MainSpecBoxes = {}
OffSpecBoxes = {}
TransmogBoxes = {}

RowsShowing = 0

print("Running AxiomLootSheet v1.3.4")
------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------
-- Saved Variables --
------------------------------------------------------------------------------------------
local SavedVariablesFrame = CreateFrame("Frame")
SavedVariablesFrame:RegisterEvent("ADDON_LOADED")
SavedVariablesFrame:RegisterEvent("PLAYER_LOGOUT")
SavedVariablesFrame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "AxiomLootSheet" then
		-- Our saved variables have been loaded
		if NameStrings == nil then
			-- This is the first time this addon is loaded; set SVs to default values
			NameStrings = {}
			MainSpecCount = {}
			OffSpecCount = {}
			TransmogCount = {}
			for i=1, 20 do
				NameStrings[i] = ""
				MainSpecCount[i] = ""
				OffSpecCount[i] = ""
				TransmogCount[i] = ""
			end
		end
	elseif event == "PLAYER_LOGOUT" then
            -- Save the values when player logout/reload
			LoadSavedStrings()
			SaveStrings()
	end
end)
------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------
-- Slash Commands --
------------------------------------------------------------------------------------------
SLASH_AxiomLootSheet1 = "/axiom"
local function ShowLootSheet(msg)
	LoadSavedStrings()
	if LootSheet:IsVisible() then
		LootSheet:Hide()
	else
		print("Here is your loot sheet, sir Punk.")
		LootSheet:Show()
	end
end
SlashCmdList["AxiomLootSheet"] = ShowLootSheet
------------------------------------------------------------------------------------------



function CreateLootSheet()
	local f = CreateFrame("Frame", "LootSheet", UIParent)
			f:SetPoint("TOP", 0, -25)
			f:SetSize(270, 70)
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
			
			CreateNewRowButton()
			CreateRemoveRowButton()
			CreateNameBoxes()
			CreateMainSpecBoxes()
			CreateOffSpecBoxes()
			CreateTransmogBoxes()
			CreateCloseButton()
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
			NameBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			NameBoxes[i]:SetPoint("TOPLEFT", LootSheet, "TOPLEFT", 15, -25)
		else
			NameBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
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
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			MainSpecBoxes[i]:SetPoint("LEFT", NameBoxes[i], "RIGHT", 5, 0)
		else
			MainSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
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
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			OffSpecBoxes[i]:SetPoint("LEFT", MainSpecBoxes[i], "RIGHT", 5, 0)
		else
			OffSpecBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
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
			TransmogBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
			TransmogBoxes[i]:SetPoint("LEFT", OffSpecBoxes[i], "RIGHT", 5, 0)
		else
			TransmogBoxes[i] = CreateFrame("EditBox", nil, LootSheet)
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
	button:SetPoint("LEFT", CloseButton, "RIGHT", 75, 0)
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

CreateLootSheet()



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
