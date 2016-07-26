--[[
	The functions, with specified settings will run on login/reload.
	Leave empty to run none of the available functions at login/reload.
]]

-- Set to false if the functions should not print any information (on login/reload)
SHOW_FUNCTION_MESSAGES = true

function loadUserProfile()
	classColorHealthBars()
	classPortraits()
	resizeArenaFrames(1.5)
	resizeArenaPetFrames(1.5)
	moveArenaFrames("topright", -335, -25)
	showActionBarTextures(false)
	showMenuBarTextures(false)
	showMaxLevelBar(false)
	showBinds(false)
	showGryphons(false)
	resizeSpellBars(1.23, 1.4, 1.4)
	normalizeBarsWhileCC()
	showActionBarNumber(false)
	classColorNameBackground()
	arenaTrinketFrames()
	hideMacroText()
	fixFollowingNameplates()
	--showXPBar(false) -- seems to not work (also only for ppl below max lvl), disregard
	snowfall()
end

--[[
	You can either run the function on login/reload, or call it yourself
	in a macro using "/run loadUserProfile".

	By default the function is run at login/reload, by placing it below

	Remove the line if you want to run the function yourself through a macro.
]]

loadUserProfile()