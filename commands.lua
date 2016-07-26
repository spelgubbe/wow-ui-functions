SLASH_COMMAND1 = '/uf'
local functions = {
	"resizeArenaFrames(scale)",
	"resizeArenaPetFrames(scale)",
	"resizeSpellBars(player, focus, target)",
	"moveArenaFrames(position, offsetx, offsety)",
	"showActionBarTextures(true/false)",
	"showMenuBarTextures(true/false)",
	"showMaxLevelBar(true/false)",
	"showXPBar(true/false)",
	"showBinds(true/false)",
	"hideMacroText()",
	"showGryphons(true/false)",
	"showActionBarNumber(true/false)",
	"classIconPortraits()",
	"classColorHealthBars()",
	"classColorNameBackground()",
	"arenaTrinketFrames()",
	"normalizeBarsWhileCC()",
	"fixFollowingNameplates()",
	"snowfall()"
}
local function handler(msg, editbox)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if command=="help" then
		print("Write /uf functions to see available functions")
	elseif command=="functions" then
		print("Functions: (run from macro/chatbox by /run functionName())")
		for i in pairs(functions) do
			print("|cff00ccff"..i..". "..functions[i])
		end
	else
		print("Write /uf functions to see available functions")
	end

end
SlashCmdList['COMMAND'] = handler;