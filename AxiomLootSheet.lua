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
	local base = CreateFrame("Frame", "AxiomLootSheetFrame", UIParent, "BasicFrameTemplateWithInset")
	base:SetSize(800, 600)
	base:EnableMouse(true)
	base:SetMovable(true)
	base:SetClampedToScreen(true)
	base:SetPoint("CENTER")
	base:RegisterForDrag("LeftButton")
	base:SetScript("OnDragStart", AxiomLootSheetFrame.StartMoving)
	base:SetScript("OnDragStop", AxiomLootSheetFrame.StopMovingOrSizing)

	base.title = AxiomLootSheetFrame:CreateFontString(nil, "OVERLAY")
	base.title:SetFontObject("GameFontHighlightLarge")
	base.title:SetPoint("LEFT", AxiomLootSheetFrame.TitleBg, "LEFT", 5, 0)
	base.title:SetText("Axiom Loot Sheet")
	
	local e = CreateFrame("EditBox", "editbox", base)
	e:SetMultiLine(true)
	e:SetFontObject(ChatFontNormal)
	e:SetWidth(300)
	--s:SetScrollChild(e)
	--- demo multi line text
	e:SetPoint("CENTER")
	e:SetText("line 1\nline 2\nline 3\nmore...\n\n\n\n\n\nanother one\n"
	.."some very long...dsf v asdf a sdf asd df as df asdf a sdfd as ddf as df asd f asd fd asd f asdf LONG LINE\n\n\nsome more.\nlast!")
	e:HighlightText() -- select all (if to be used for copy paste)
	-- optional/just to close that frame
	e:SetScript("OnEscapePressed", function()
		s:Hide()
	end)
end

-------------------------------------------
-- Frames --
-------------------------------------------
