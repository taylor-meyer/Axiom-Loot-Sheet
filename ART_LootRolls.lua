------------------------------------------------------------------------------------------
-- Loot Rolls --
--------------------
-- Author: Lypidius @ US-MoonGuard
------------------------------------------------------------------------------------------

-- Addon name & common namespace
local addon, ns = ... -- Addon name & common namespace

function CreateRollFrame()
	local f = CreateFrame("Frame", "RollFrame", LootResults, BackdropTemplateMixin and "BackdropTemplate")
	f:SetPoint("TOPLEFT", LootResults, "TOPRIGHT")
	f:SetSize(137, 0)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\PVPFrame\\UI-Character-PVP-Highlight", -- this one is neat
		edgeSize = 16,
		insets = { left = 8, right = 6, top = 8, bottom = 8 },
	})
	f:SetBackdropBorderColor(255, 215, 0, .5)
	
	-- Events
	RollFrame:SetScript("OnEvent", function(self, event, ...)
		if event == "CHAT_MSG_SYSTEM" then
			-- get event payload
			local message = ...
			local author, rollResult, rollMin, rollMax = string.match(message, "(.+) rolls (%d+) %((%d+)-(%d+)%)")
			-- is a roll?
			if author and rollResult and rollMin and rollMax then
				Payload = {
					Author = author,
					RollResult = rollResult,
					RollMin = rollMin,
					RollMax = rollMax
				}
				
				if RollFrame:IsVisible() == false then
					RollFrame:Show()
				end
				
				DetermineCurrentWinner(Payload)
			end
		end
	end)
	CreateRollRows()
end

function CreateRollRows()
	for i=1,20 do
		local row = CreateFrame("Frame", "RollRow" .. i, RollFrame)
		row:SetPoint("TOP", 0, 25-(30 * i))
		row:SetSize(125, 40)
		
		local name = row:CreateFontString("RollFontString", "OVERLAY", "GameFontNormal")
		name:SetPoint("LEFT", 9, 0)
		
		row:Hide()
		RollRows[i] = row
		RollNames[i] = name
	end
end

function ShowRollRow(i)
	if i < 21 then
		if i==1 then
			RollFrame:SetHeight(RollFrame:GetHeight() + 49)
		else
			RollFrame:SetHeight(RollFrame:GetHeight() + 30)
		end
		RollRows[i]:Show()
		RollRowsShowing = RollRowsShowing + 1
	end
end

function DetermineCurrentWinner(Payload)
	if RollRowsShowing ~= 20 then
		--- show new roll
		ShowRollRow(RollRowsShowing+1)
		RollNames[RollRowsShowing]:SetText(Payload.RollResult .. " - " .. Payload.Author)
		-- if roll is higher than the current winner
		if tonumber(Payload.RollResult) > HighestRollValue then
			-- set it to the new highest value and change display to green
			HighestRollValue = tonumber(Payload.RollResult)
			RollNames[RollRowsShowing]:SetTextColor(0, 1, 0, 1)
			-- reset all others to yellow
			-- for loop incase of ties that are showing multiple greens
			for i=1,(RollRowsShowing-1) do
				RollNames[i]:SetTextColor(1, 1, 0, 1)
			end
			-- set highest text to new row
			HighestRollText = RollNames[RollRowsShowing]
		-- if there is a tie with current winner, also set it to green
		-- but no need to change anyone else back to yellow
		-- or change the current max
		elseif tonumber(Payload.RollResult) == HighestRollValue then
			RollNames[RollRowsShowing]:SetTextColor(0, 1, 0, 1)
		end
	end
end

function ResetRolls()
	RollFrame:SetSize(137, 0)
	for i=1,20 do
		RollNames[i]:SetText("")
	end
	RollRowsShowing = 0
	RollFrame:Hide()
	HighestRollValue = 0
	HighestRollText = nil
end
------------------------------------------------------------------------------------------