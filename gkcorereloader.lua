PLUGIN.Title		= "Gamekeller Core Reloader"
PLUGIN.Description	= "This is the Gamekeller Core Reload plugin which is able to reload the main plugin through In-Game Chat or Console."
PLUGIN.Version		= "1.13.03"
PLUGIN.Author		= "Gamekeller"

--[[
	#####################################################################################################
	#								Gamekeller Core Plugin by Gamekeller								#
	#	This plugin is able to reload the Gamekeller Core Plugin.										#
	#																									#
	#	Gamekeller Core Reload Plugin is written by Gamekeller Dev Team									#
	#																									#
	#	Special Thanks to: Yeti, Endstille, Sunny														#
	#																									#
	#	Join us on our server with this console command (press F1 ingame):								#
	#	net.connect 176.9.3.135:28075																	#
	#																									#
	#	If you have any suggestions or need help with this Plugin write an email to						#
	#	shiyoda@arcor.de																				#
	#																	copyright 2014 by Gamekeller	#
	#####################################################################################################
]]

function PLUGIN:Init()
	-- CoreReloader Console Command
	self:AddCommand("gkcore", "reload", self.consoleCommandReload)
	-- CoreReloader Chat Command
	self:AddChatCommand("gkcore.reload", self.chatCommandReload)
end

-- Reloads the plugin via console
function PLUGIN:consoleCommandReload( arg )
	local user = arg.argUser
	if (user and not user:CanAdmin()) then
		rust.Notice(arg.argUser, "You do not have permission to use this command!")
		return
	end
	cs.reloadplugin("gkcore")
	rust.Notice(arg.argUser, "Gamekeller Core reloaded.")
end

-- Reloads the plugin via chat
function PLUGIN:chatCommandReload( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	cs.reloadplugin("gkcore")
	rust.Notice(netUser, "Gamekeller Core reloaded.")
end