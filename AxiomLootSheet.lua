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
	
	
		-- main sheet
		local f = CreateFrame("Frame", "Sheet", UIParent, "DialogBoxFrame")
		f:SetPoint("CENTER")
		f:SetSize(400, 1000)
			
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
		
	end
	Sheet:Show()
end