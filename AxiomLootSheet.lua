-------------------------------------------
-- Slash Commands --
-------------------------------------------
SLASH_AxiomLootSheet1 = "/axiom"
local function LootSheet(msg)
	print("Axiom is a Horde guild on MoonGuard-US.")
	CreateMainFrame()
end
SlashCmdList["AxiomLootSheet"] = LootSheet


-------------------------------------------
-- Functions --
-------------------------------------------
--function HelloWorld(self)
--	print("Hello World!")
--end

function CreateMainFrame(self)
	if not Sheet then
	
	
	
		-----------------------------------------------------
		-- main sheet
		local f = CreateFrame("Frame", "Sheet", UIParent)
		f:SetPoint("CENTER")
		f:SetSize(283, 1000)
			
		-- Texture
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
		-----------------------------------------------------
	
	
	
	
	
		-----------------------------------------------------
		-- boxes
		CharacterBoxes = {}
		CharacterBoxes[1] = CreateFrame("EditBox", nil, Sheet)
		CharacterBoxes[1]:SetPoint("TOPLEFT", Sheet, "TOPLEFT", 25, -25)
		for i=2, 20 do
			CharacterBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			CharacterBoxes[i]:SetPoint("TOP", CharacterBoxes[i-1], "BOTTOM", 0, -5)
		end
	
	
		for i=1, 20 do
			-- textures
			CharacterBoxes[i]:SetSize(100, 40)
			CharacterBoxes[i]:SetMultiLine(false)
			CharacterBoxes[i]:SetAutoFocus(false) -- dont automatically focus
			CharacterBoxes[i]:SetFontObject("ChatFontNormal")
			CharacterBoxes[i]:SetMaxLetters(12)
			CharacterBoxes[i]:SetText("Character")
			CharacterBoxes[i]:SetTextInsets(8, 0, 0, 0)
			
			-- Texture
			CharacterBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			CharacterBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		
		-----------------------------------------------------
		
		
		
		
		
		
		
		
		-----------------------------------------------------
		MSBoxes = {}
		for i=1, 20 do
			MSBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			MSBoxes[i]:SetPoint("LEFT", CharacterBoxes[i], "RIGHT", 5, 0)
			-- textures
			MSBoxes[i]:SetSize(40, 40)
			MSBoxes[i]:SetMultiLine(false)
			MSBoxes[i]:SetAutoFocus(false) -- dont automatically focus
			MSBoxes[i]:SetFontObject("ChatFontNormal")
			MSBoxes[i]:SetMaxLetters(12)
			MSBoxes[i]:SetText("MS")
			MSBoxes[i]:SetTextInsets(8, 0, 0, 0)
			-- Texture
			MSBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			MSBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		-----------------------------------------------------
		
		
		
		-----------------------------------------------------
		OSBoxes = {}
		for i=1, 20 do
			OSBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			OSBoxes[i]:SetPoint("LEFT", MSBoxes[i], "RIGHT", 5, 0)
			-- textures
			OSBoxes[i]:SetSize(40, 40)
			OSBoxes[i]:SetMultiLine(false)
			OSBoxes[i]:SetAutoFocus(false) -- dont automatically focus
			OSBoxes[i]:SetFontObject("ChatFontNormal")
			OSBoxes[i]:SetMaxLetters(12)
			OSBoxes[i]:SetText("OS")
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
		-----------------------------------------------------
		
		
		
		-----------------------------------------------------
		TMOGBoxes = {}
		for i=1, 20 do
			TMOGBoxes[i] = CreateFrame("EditBox", nil, Sheet)
			TMOGBoxes[i]:SetPoint("LEFT", OSBoxes[i], "RIGHT", 5, 0)
			-- textures
			TMOGBoxes[i]:SetSize(40, 40)
			TMOGBoxes[i]:SetMultiLine(false)
			TMOGBoxes[i]:SetAutoFocus(false) -- dont automatically focus
			TMOGBoxes[i]:SetFontObject("ChatFontNormal")
			TMOGBoxes[i]:SetMaxLetters(12)
			TMOGBoxes[i]:SetText("TM")
			TMOGBoxes[i]:SetTextInsets(8, 0, 0, 0)
			-- Texture
			TMOGBoxes[i]:SetBackdrop({
				bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
				edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
				edgeSize = 16,
				insets = { left = 8, right = 6, top = 8, bottom = 8 },
			})
			TMOGBoxes[i]:SetBackdropBorderColor(0, .44, .87, 0.5) -- darkblue
		end
		-----------------------------------------------------
		
		
		
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
		   Sheet:Hide()
		end)
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	end
	Sheet:Show()
end