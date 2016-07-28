# wow-ui-functions
Great deal of UI manipulating functions (nameplates, actionbars, pvp functions, ...)

Functions documentation:

	"comboPointLocation(number)": 					1: CP are showed above target portrait, 2: CP are showed below your own portrait
	"combatTextStyle(number)": 						0: Scroll up, 1: ??, 2: ??, 3: Arc
	"setDamageFont(fontLocation)": 					This font is not only used for damage. Blame Blizzard. fontLocation example: "Fonts\\SKURRI.TTF"
	"setNameplateFont(fontLocation)": 				Font for names on nameplates
	"setNameFont(fontLocation)": 					Font for names on unit portraits
	"resizeArenaFrames(scale)": 					1 means 100% (default size), 1.5 means 150%, etc
	"resizeArenaPetFrames(scale)":
	"resizeSpellBars(player, focus, target)":
	"moveArenaFrames(position, offsetx, offsety)": 	Position examples: "topright", "bottomleft", "topleft", "bottomright".
													Offset is how many pixels you want them to be moved from their preset positions in x and y-coordinates.
	"showActionBarTextures(true/false)":
	"showMenuBarTextures(true/false)":
	"showMaxLevelBar(true/false)": 					Show/Hide the replacement for the XP-bar at max level
	"showXPBar(true/false)": 						Show/Hide XP bar
	"showBinds(true/false)": 						Show/Hide keybindings on your buttons
	"hideMacroText()":								Hide macro text on buttons
	"showGryphons(true/false)":
	"showActionBarNumber(true/false)":
	"showAllTargetDebuffs(true/false)": 			Show all debuffs on target (otherwise you mostly see your own debuffs)
	"enableFullscreenGlow(true/false)": 			Fullscreen glow effect
	--"showAggroPercentage(true/false)": 			Show aggro percentage above unit portraits
	"classIconPortraits()": 						Class icons instead of the usual portraits for players
	"classColorHealthBars()": 						Class color on target/focus healthbars
	"classColorNameBackground()": 					Class color behind the names on the target/focus portraits
	"arenaTrinketFrames()": 						Shows enemy trinket cooldowns in arena.
	"normalizeBarsWhileCC()": 						No red "cooldown" on your spells when you are in CC
	"fixFollowingNameplates()":
	"snowfall()": 									Shows an animation when a buttons are pressed on the actionbars
