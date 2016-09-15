-- nameplate defaults are about 141x39
-- /run DAMAGE_TEXT_FONT = "Fonts\\SKURRI.TTF"
-- test  /run DAMAGE_TEXT_FONT = "Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME"
-- fix that damage is shown like Arc in Legion -- not cool (should go up)
-- /run DAMAGE_TEXT_FONT = "Fonts\\SKURRI.TTF" -- seems to be dmg font

-- frame.combatText:SetHeight(1)
-- frame.combatText:SetWidth(1) -- mer pixlar!

-- FUNCTIONS
local function functionPrint(str)
	if SHOW_FUNCTION_MESSAGES then
		print("|cff00ccff" .. str)
	else
		return
	end
end

function setDamageFont(fontLocation)
	DAMAGE_TEXT_FONT = fontLocation
end

function setNameplateFont(fontLocation)
	NAMEPLATE_FONT = fontLocation
end

function setNameFont(fontLocation)
	UNIT_NAME_FONT = fontLocation
end

function resizeArenaFrames(scale)
	for number=1,5,1 do
		_G["ArenaEnemyFrame"..number]:SetScale(scale)
	end
	functionPrint("Arena Frames at "..scale.." scale")
end

function resizeArenaPetFrames(scale)
	for number=1,5,1 do
		_G["ArenaEnemyFrame"..number.."PetFrame"]:SetScale(scale)
	end
	functionPrint("Arena Pet Frames at "..scale.." scale")
end

function moveArenaFrames(position, offsetx, offsety)
	for number=1,5,1 do
		_G["ArenaEnemyFrame"..number]:SetPoint(position, offsetx, offsety)
	end
	functionPrint("Arena Frames were moved to position "..position.." with offsets ("..offsetx..", "..offsety..")")
end
function showActionBarTextures(bool)
	for number=1,4,1 do
		local texture = _G["BonusActionBarFrameTexture"..number]
		if texture then
			if bool then
				texture:Show()
			else
				texture:Hide()
			end
		end
	end
	functionPrint(bool and "Showing" or "Hiding" .. " ActionBar textures")
end

function showMenuBarTextures(bool)
	for number=0,3,1 do
		local texture = _G["MainMenuBarTexture"..number]
		if texture then
			if bool then
				texture:Show()
			else
				texture:Hide()
			end
		end
	end
	functionPrint(bool and "Showing" or "Hiding" .. " MenuBar textures")
end

function showMaxLevelBar(bool)
	for number=0,3,1 do
		local texture = _G["MainMenuMaxLevelBar"..number]
		if texture then
			if bool then
				texture:Show()
			else
				texture:Hide()
			end
		end
	end
	functionPrint(bool and "Showing" or "Hiding" .. " Max Level bar")
end

function showXPBar(bool) -- doesn't seem to work
	if bool then
		MainMenuExpBar:Show()
		functionPrint("Showing XP bar")
	else
		MainMenuExpBar:Hide()
		functionPrint("Hiding XP bar")
	end
end

function classIconPortraits()
	UFP = "UnitFramePortrait_Update"
	--UICC = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
	UICC = "Interface\\TargetingFrame\\UI-Classes-Circles"
	--defaultPortrait = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate"
	CIT = CLASS_ICON_TCOORDS
	hooksecurefunc(UFP,function(self)
		if self.portrait
		then
			local t = CIT[select(2,UnitClass(self.unit))]
			if t and UnitIsPlayer(self.unit)
			then
				--functionPrint("previous texture coords was: "..self.portrait:GetTexCoord())
				self.portrait:SetTexture(UICC)
				self.portrait:SetTexCoord(unpack(t))
			else
				self.portrait:SetTexCoord(0,1,0,1)
			end
		end
	end)
end
function arenaTrinketFrames()
	trinkets = {}
	local arenaFrame, trinket
	for i = 1, 5 do
		arenaFrame = "ArenaEnemyFrame"..i
		trinket = CreateFrame("Cooldown", arenaFrame.."Trinket", ArenaEnemyFrames)
		trinket:SetPoint("TOPRIGHT", arenaFrame, 30, -6)
		trinket:SetSize(36, 36)
		trinket.icon = trinket:CreateTexture(nil, "BACKGROUND")
		trinket.icon:SetAllPoints()
		trinket.icon:SetTexture("Interface\\Icons\\inv_jewelry_trinketpvp_01")
		trinket:Hide()
		trinkets["arena"..i] = trinket
	end

	local events = CreateFrame("Frame")
	function events:UNIT_SPELLCAST_SUCCEEDED(unitID, spell, rank, lineID, spellID)
		if not trinkets[unitID] then
			return
		end
		if spellID == 208683 then
			CooldownFrame_Set(trinkets[unitID], GetTime(), 120, 1)
			--SendChatMessage("Trinket used by: "..GetUnitName(unitID, true), "PARTY")
		elseif spellID == 195710 then
			CooldownFrame_Set(trinkets[unitID], GetTime(), 180, 1)
		elseif spellID == 7744 or spellID == 59752 then
			CooldownFrame_Set(trinkets[unitID], GetTime(), 30, 1)
		end
	end

	function events:PLAYER_ENTERING_WORLD()
		local _, instanceType = IsInInstance()
		if instanceType == "arena" then
			self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
		elseif self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") then
			self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
			for _, trinket in pairs(trinkets) do
				trinket:SetCooldown(0, 0)
				trinket:Hide()
			end
		end
	end
	events:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
	events:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function showBinds(bool)
	-- /run local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"} for b=1,#r do for i=1,12 do _G[r[b].."Button"..i.."Name"]:SetAlpha(0) end end -- is shorter
	local hkAlpha = (bool and 1 or 0)
	local bars = {"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"}
	for h=1,#bars do
		for i=1, 12 do
			_G[bars[h].."Button"..i.."HotKey"]:SetAlpha(hkAlpha)
		end
	end
	functionPrint(bool and "Showing binds" or "Hiding binds")
end

function hideMacroText()
	hooksecurefunc("ActionButton_Update", function(btn)
		local name = _G[btn:GetName().."Name"]
		if name then
			name:Hide()
		end
	end)
	functionPrint("Hiding macro names (requires /reload to revert unless in userProfile)")
end

function showGryphons(bool)
	if bool then
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()
		functionPrint("Showing gryphons")
	else
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
		functionPrint("Hiding gryphons")
	end
end

function resizeSpellBars(player, focus, target)
	CastingBarFrame:SetScale(player)
	FocusFrameSpellBar:SetScale(focus)
	TargetFrameSpellBar:SetScale(target)
	functionPrint("Castbars resized, scales: "..player.." (for player), "..focus.." (for focus), "..target.." (for target)")
end

function normalizeBarsWhileCC() -- no red bars while in CC
	hooksecurefunc("CooldownFrame_Set", function(self)
		if self.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL then
			--self:SetDrawBling(false)
			self:SetCooldown(0, 0)
			--self:SetDrawBling(true)
		end
	end)
	functionPrint("Loss of control cooldown disabled (requires /reload to revert unless in userProfile)")
end

function showActionBarNumber(bool)
	if bool then
		MainMenuBarPageNumber:Show()
		ActionBarUpButton:Show()
		ActionBarDownButton:Show()
		functionPrint("Showing ActionBar number and arrows")
	else
		MainMenuBarPageNumber:Hide()
		ActionBarUpButton:Hide()
		ActionBarDownButton:Hide()
		functionPrint("Hiding ActionBar number and arrows")
	end
end

local function getClassColour(statusbar, unit)
	local _, class, c
	if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
		_, class = UnitClass(unit)
		c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		statusbar:SetStatusBarColor(c.r, c.g, c.b)
		PlayerFrameHealthBar:SetStatusBarColor(0,1,0)
	end
end
function classColorHealthBars()
	hooksecurefunc("UnitFrameHealthBar_Update", getClassColour)
	hooksecurefunc("HealthBar_OnValueChanged", function(self)
		getClassColour(self, self.unit)
	end)
	functionPrint("Class color on player health bars enabled")
end

function classColorNameBackground()
	local frame = CreateFrame("FRAME")
	frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
	frame:RegisterEvent("UNIT_FACTION")

	local function eventHandler(self, event, ...)
		if UnitIsPlayer("target") then
			c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
			TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
		end
		if UnitIsPlayer("focus") then
			c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))]
			FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
		end
	end
	frame:SetScript("OnEvent", eventHandler)

	for _, BarTextures in pairs({TargetFrameNameBackground, FocusFrameNameBackground}) do
		BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	end
	functionPrint("Class color on portrait names enabled")
end

function snowfall()
	local animationsCount, animations = 5, {}
	local animationNum = 1
	local replace = string.gsub
	local frame, texture, animationGroup, alpha1, scale1, scale2, rotation2

	for i = 1, animationsCount do
	frame = CreateFrame("Frame")
	texture = frame:CreateTexture()
	texture:SetTexture([[Interface\Cooldown\star4]])
	texture:SetAlpha(0)
	texture:SetAllPoints()
	texture:SetBlendMode("ADD")

	animationGroup = texture:CreateAnimationGroup()

	alpha1 = animationGroup:CreateAnimation("Alpha")
	alpha1:SetFromAlpha(0)
	alpha1:SetToAlpha(1)
	alpha1:SetDuration(0)
	alpha1:SetOrder(1)

	scale1 = animationGroup:CreateAnimation("Scale")
	scale1:SetFromScale(1.0, 1.0) -- works better/is bigger this way
	scale1:SetToScale(1.5, 1.5)
	--scale1:SetScale(1.5, 1.5) --original
	scale1:SetDuration(0)
	scale1:SetOrder(1)
	--scale1:SetToFinalAlpha()

	scale2 = animationGroup:CreateAnimation("Scale")
	--scale2:SetScale(0, 0) -- original
	scale2:SetFromScale(1.5, 1.5)
	scale2:SetToScale(0,0)
	scale2:SetDuration(0.3)
	scale2:SetOrder(2)

	rotation2 = animationGroup:CreateAnimation("Rotation")
	rotation2:SetDegrees(90)
	rotation2:SetDuration(0.3)
	rotation2:SetOrder(2)

	animations[i] = {frame = frame, animationGroup = animationGroup}
	end

	local animate = function(button)
		if not button:IsVisible() then
			return true
		end
		local animation = animations[animationNum]
		local frame = animation.frame
		local animationGroup = animation.animationGroup

		frame:SetFrameStrata("HIGH")
		frame:SetFrameLevel(button:GetFrameLevel() + 10)
		frame:SetAllPoints(button)
		animationGroup:Stop()
		animationGroup:Play()
		animationNum = (animationNum % animationsCount) + 1
		return true
	end
	hooksecurefunc('PetActionButtonDown', function(id)
		local button
			if PetActionBarFrame then
				if id > NUM_PET_ACTION_SLOTS then return end
				button = _G["PetActionButton"..id]
				if not button then return end
			end
			return
		animate(button)
	end)
	-- didn't run on PLAYER_ENTERING_WORLD
	hooksecurefunc('ActionButton_Update', function(button)
		if InCombatLockdown() then return end -- can't hook functions in combat
		if not button.hooked then
			local actionButtonType, key
			actionButtonType = button:GetAttribute('binding') or string.upper(button:GetName())
			--actionButtonType = replace(actionButtonType, 'PETACTION', 'BONUSACTION') -- pet action buttons attempt
			actionButtonType = replace(actionButtonType, 'BOTTOMLEFT', '1')
			actionButtonType = replace(actionButtonType, 'BOTTOMRIGHT', '2')
			actionButtonType = replace(actionButtonType, 'RIGHT', '3')
			actionButtonType = replace(actionButtonType, 'LEFT', '4')
			actionButtonType = replace(actionButtonType, 'MULTIBAR', 'MULTIACTIONBAR')
			local key = GetBindingKey(actionButtonType)
			if key then
				button:RegisterForClicks("AnyDown")
				--SetOverrideBinding(button, true, key, 'CLICK '..button:GetName()..':LeftButton')
				SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
			end
			button.AnimateThis = animate
			SecureHandlerWrapScript(button, "OnClick", button, [[ control:CallMethod("AnimateThis", self) ]])
			button.hooked = true
		end
	end)
	functionPrint("Snowfall Keypress is enabled")
end

-- CVar functions

-- att fixa ... nameplates hitbox != nameplates width

function fixFollowingNameplates()
	SetCVar("nameplateOtherTopInset", -1)
	SetCVar("nameplateOtherBottomInset", -1)
	functionPrint("Nameplates set to not follow")
end

function combatTextStyle(number)
	SetCVar("floatingCombatTextCombatDamageDirectionalScale", number)
end
function comboPointLocation(number)
	SetCVar("comboPointLocation", number) -- old combo point location (otherwise 2)
	functionPrint("Combo points are being shown "..(number == 1 and "on target frame" or "in the middle of the screen"))
end
function showAllTargetDebuffs(bool)
	SetCVar("NoBuffDebuffFilterOnTarget", bool)
end
function setNameplateDistance(yards)
	SetCVar("nameplateMaxDistance", yards)
end
function enableFullscreenGlow(bool)
	SetCVar("ffxGlow", bool)
end
--[[function showAggroPercentage(bool)
	-- not working
	SetCVar("threatShowNumeric", bool)
end]]

-- END FUNCTIONS

-- What's run by default
function loadRequiredScripts()
	LoadAddOn("Blizzard_ArenaUI")
end
loadRequiredScripts()
functionPrint("thangs are working if you see this =]")