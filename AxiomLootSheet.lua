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
		local f = CreateFrame("Frame", "Sheet", UIParent, "DialogBoxFrame")
		f:SetPoint("CENTER")
		f:SetSize(400, 1000)
			
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
	end
	
	Sheet:Show()
	
end

-------------------------------------------
-- Frames --
-------------------------------------------
