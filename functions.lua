-- "Young, black and famous, with money hanging out the anus." - Puff Daddy

-- FUNCTIONS
local function resizeArenaFrames(scale)
	for number=1,5,1 do
		_G["ArenaEnemyFrame"..number]:SetScale(scale)
	end
	print("Arena Frames at "..scale.." scale")
end

local function resizeArenaPetFrames(scale)
	for number=1,5,1 do
		_G["ArenaEnemyFrame"..number.."PetFrame"]:SetScale(scale)
	end
	print("Arena Pet Frames at "..scale.." scale")
end

local function moveArenaFrames(position, offsetx, offsety)
	for number=1,5,1 do
		_G["ArenaEnemyFrame"..number]:SetPoint(position, offsetx, offsety)
	end
	print("Arena Frames were moved to position "..position.." with offsets ("..offsetx..", "..offsety..")")
end
local function removeActionBarTextures()
	for number=1,4,1 do
		--_G["BonusActionBarFrameTexture"..number]:Hide()
		local texture = _G["BonusActionBarFrameTexture"..number]
		if texture
		then
			texture:Hide()
		end
	end
end

local function cleanHUD()
	for number=0,3,1 do
		local texture = _G["MainMenuBarTexture"..number]
		if texture
		then
			texture:Hide()
		end
	end
end

local function cleanXPBar()
	for number=0,3,1 do
		local texture = _G["MainMenuMaxLevelBar"..number]
		if texture
		then
			texture:Hide()
		end
	end
end

local function classPortraits()
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
				--print("previous texture coords was: "..self.portrait:GetTexCoord())
				self.portrait:SetTexture(UICC)
				self.portrait:SetTexCoord(unpack(t))
			else
				self.portrait:SetTexCoord(0,1,0,1)
			end
		end
	end)
end
function arenaTrinketFrames() -- might be coming in le future Xd
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

local function hideBinds()
	-- /run local r={"MultiBarBottomLeft", "MultiBarBottomRight", "Action", "MultiBarLeft", "MultiBarRight"} for b=1,#r do for i=1,12 do _G[r[b].."Button"..i.."Name"]:SetAlpha(0) end end -- is shorter
	for i=1, 12 do
		_G["ActionButton"..i.."HotKey"]:SetAlpha(0) -- main bar
		_G["MultiBarBottomRightButton"..i.."HotKey"]:SetAlpha(0) -- bottom right bar
		_G["MultiBarBottomLeftButton"..i.."HotKey"]:SetAlpha(0) -- bottom left bar
		_G["MultiBarRightButton"..i.."HotKey"]:SetAlpha(0) -- right bar
		_G["MultiBarLeftButton"..i.."HotKey"]:SetAlpha(0) -- left bar
	end
end

local function hideMacros()
	hooksecurefunc("ActionButton_Update", function(btn)
		local name = _G[btn:GetName().."Name"]
		if name then
			name:Hide()
		end
	end)
end

local function ActionBarGryphons(enable)
	if MainMenuBarLeftEndCap:IsVisible() and MainMenuBarRightEndCap:IsVisible() then
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
	else
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()
	end
end

local function resizeSpellBars(player, focus, target)
	CastingBarFrame:SetScale(player)
	FocusFrameSpellBar:SetScale(focus)
	TargetFrameSpellBar:SetScale(target)
end

local function normalizeBarsWhileCC() -- no red bars while in CC
	hooksecurefunc("CooldownFrame_Set", function(self)
		if self.currentCooldownType == COOLDOWN_TYPE_LOSS_OF_CONTROL then
			--self:SetDrawBling(false)
			self:SetCooldown(0, 0) -- maybe :SetLossOfControlCooldown(0,0) -- could be self.cooldown:,,,
			--self:SetDrawBling(true)
			--self:SetLossOfControlCooldown(0,0) -- ok this function doesn't exist??
		end
	end)
end

local function toggleActionBarNumber()
	if MainMenuBarPageNumber:IsVisible() and ActionBarUpButton:IsVisible() and ActionBarDownButton:IsVisible() then
		MainMenuBarPageNumber:Hide()
		ActionBarUpButton:Hide()
		ActionBarDownButton:Hide()
	else
		MainMenuBarPageNumber:Show()
		ActionBarUpButton:Show()
		ActionBarDownButton:Show()
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
local function classColorNameplates()
	hooksecurefunc("UnitFrameHealthBar_Update", getClassColour)
	hooksecurefunc("HealthBar_OnValueChanged", function(self)
		getClassColour(self, self.unit)
	end)
end

local function classColorNameBackground()
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
	scale1:SetScale(1.5, 1.5)
	scale1:SetDuration(0)
	scale1:SetOrder(1)

	scale2 = animationGroup:CreateAnimation("Scale")
	scale2:SetScale(0, 0)
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
	frame:SetFrameStrata(button:GetFrameStrata())
	frame:SetFrameLevel(button:GetFrameLevel() + 10)
	frame:SetAllPoints(button)
	animationGroup:Stop()
	animationGroup:Play()
	animationNum = (animationNum % animationsCount) + 1
	return true
	end

	-- didn't run on PLAYER_ENTERING_WORLD
	--hooksecurefunc('ActionButton_UpdateHotkeys', function(button, buttonType)
	hooksecurefunc('ActionButton_Update', function(button, buttonType)
	if InCombatLockdown() then return end -- no animation while in CC
	if not button.hooked then
	local id, actionButtonType, key
	if not actionButtonType then
	actionButtonType = button:GetAttribute('binding') or string.upper(button:GetName())

	actionButtonType = replace(actionButtonType, 'BOTTOMLEFT', '1')
	actionButtonType = replace(actionButtonType, 'BOTTOMRIGHT', '2')
	actionButtonType = replace(actionButtonType, 'RIGHT', '3')
	actionButtonType = replace(actionButtonType, 'LEFT', '4')
	actionButtonType = replace(actionButtonType, 'MULTIBAR', 'MULTIACTIONBAR')
	--print(actionButtonType)
	end
	local key = GetBindingKey(actionButtonType)
	if key then
	--print('hey this runs!'..key)
	button:RegisterForClicks("AnyDown")
	SetOverrideBinding(button, true, key, 'CLICK '..button:GetName()..':LeftButton')
	end
	button.AnimateThis = animate
	SecureHandlerWrapScript(button, "OnClick", button, [[ control:CallMethod("AnimateThis", self) ]])
	button.hooked = true

	-- when an ability/macro is present (except on first bar) it doesn't flash, when the
	-- actionbutton has no ability/macro on it it flashes

	end
	end)
end

-- END FUNCTIONS

-- Load functions on Login ("PLAYER_LOGIN"), PLAYER_ENTERING_WORLD is maybe also a good choice.

--[[local eFrame = CreateFrame("Frame")
eFrame:RegisterEvent("PLAYER_LOGIN")]]

function loadAllScripts()
	LoadAddOn("Blizzard_ArenaUI") -- required before trying to change the ArenaUI frames (they are otherwise not loaded yet..)
	
	classColorNameplates()
	classPortraits()
	resizeArenaFrames(1.5)
	resizeArenaPetFrames(1.5)
	moveArenaFrames("topright", -335, -25)
	removeActionBarTextures()
	cleanHUD()
	cleanXPBar()
	hideBinds()
	ActionBarGryphons(false)
	resizeSpellBars(1.23, 1.4, 1.4)
	normalizeBarsWhileCC()
	toggleActionBarNumber()
	classColorNameBackground()
	arenaTrinketFrames() -- run after moving arena frames
	hideMacros()
	snowfall()
end
function disableScript(number)
	if (number + 0) <= 21 then
		number = number + 0
		print("disabling number "..number)
		if number == 0 then
			print("HEY (that's all this does atm)")
		end

	end
end

loadAllScripts()

--[[eFrame:SetScript("OnEvent",
	function(self, event, ...)
		snowfall()
	end)]]

print("thangs are working if you see this =]\nWrite /uf to see functions included in this addon")