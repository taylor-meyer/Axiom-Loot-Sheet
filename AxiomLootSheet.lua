-------------------------------------------
-- Slash Commands --
-------------------------------------------
SLASH_AxiomLootSheet1 = "/axiom"
local function LootSheet(msg)
	print("Axiom is a Horde guild on MoonGuard-US.")
end
SlashCmdList["AxiomLootSheet"] = LootSheet


-------------------------------------------
-- Functions --
-------------------------------------------
function HelloWorld(self)
	print("Hello World!")
end

-------------------------------------------
-- Frames --
-------------------------------------------
CreateFrame("Frame", "AxiomLootSheetFrame", UIParent, "BasicFrameTemplateWithInset")
AxiomLootSheetFrame:SetSize(800, 600)
AxiomLootSheetFrame:EnableMouse(true)
AxiomLootSheetFrame:SetMovable(true)
AxiomLootSheetFrame:SetClampedToScreen(true)
AxiomLootSheetFrame:SetPoint("CENTER")
AxiomLootSheetFrame:RegisterForDrag("LeftButton")
AxiomLootSheetFrame:SetScript("OnDragStart", AxiomLootSheetFrame.StartMoving)
AxiomLootSheetFrame:SetScript("OnDragStop", AxiomLootSheetFrame.StopMovingOrSizing)


AxiomLootSheetFrame.title = AxiomLootSheetFrame:CreateFontString(nil, "OVERLAY")
AxiomLootSheetFrame.title:SetFontObject("GameFontHighlightLarge")
AxiomLootSheetFrame.title:SetPoint("LEFT", AxiomLootSheetFrame.TitleBg, "LEFT", 5, 0)
AxiomLootSheetFrame.title:SetText("Axiom Loot Sheet")

