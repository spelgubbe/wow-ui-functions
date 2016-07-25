SLASH_COMMAND1 = '/jv'
local funcs = {
	"resize arena frames",
	"resize arena pet frames",
	"move arena frames",
	"remove action bar textures",
	"clean HUD |cff00ccff(no background on game menu)",
	"remove XP bar",
	"hide actionbar binds",
	"class icon as portrait",
	"removes the gryphons",
	"resize spell castbars |cff00ccff(self, focus, target)",
	"removes action bar number |cff00ccff(and the up and down arrows)",
	"snowfall keypress"
}
local commands = {
	"afscale <scale>",
	"afpetscale <scale>",
	"moveaf <position> <x-offset> <y-offset> (move arena frame)",
	"abartextures (run to show/hide action bar textures)",
	"xpbar (run to show/hide xpbar)",
	"gryphons (run to show/hide gryphons)",
	"castbarscales <castbarScale> <focusCastScale> <targetCastScale> (change the scale of cast bars)",
	"actionbarnumber (run to show/hide the action bar number and the up and down arrows)"

}


local function handler(msg, editbox)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if command=="info" then
		for i in pairs(funcs) do
			print("|cff00ccff"..i..". "..funcs[i])
		end
	elseif command=="help" then
		print("Write /uf commands to see available commands")
	elseif command=="commands" then
		print("Commands: (type /uf before them) NOT AVAILABLE YET")
		for i in pairs(commands) do
			print("|cff00ccff"..i..". "..funcs[i])
		end
	elseif command=="toggle" then
		--print(rest)
		disableScript(rest)
	end

end
SlashCmdList['COMMAND'] = handler;