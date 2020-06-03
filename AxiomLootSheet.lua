function HelloWorld(self) 
	print("Hello World!"); 
end

-- Slash Commands
SLASH_AxiomLootSheet1 = "/axiom";
 
local function LootSheet(msg)
	print("Axiom is a Horde guild on MoonGuard-US."); 
end
 
SlashCmdList["AxiomLootSheet"] = LootSheet;

----------------------------------------------------------------