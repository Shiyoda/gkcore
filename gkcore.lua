PLUGIN.Title		= "Gamekeller Core Plugin"
PLUGIN.Description	= "This is a Server Core Plugin which includes: EasyPlayerlist, EasyAdminRights, EasyServerSaver, RustClock, Help, AdminHelp, CoreReloader, MotD, BaseAttackAlert, DeathLog, ChatLog, EasyAnnouncer"
PLUGIN.Version		= "1.13.01"
PLUGIN.Author		= "Gamekeller"
print("-----------------------")
print( "Loading " .. PLUGIN.Title .. " Version: " .. PLUGIN.Version .. " by " .. PLUGIN.Author .. "..." )
print( "Initialize functions..." )

--[[
	#####################################################################################################
	#								Gamekeller Core Plugin by Gamekeller								#
	#	This plugin includes a lot of functions and you will able to activate/deactivate them trough	#
	#	the game.																						#
	#																									#
	#	Currently included functions:																	#
	#	EasyPlayerList		- Function to get a list of connected players.								#
	#	EasyAdminRights		- You are able to set ingame Admins and remove them without using rcon.		#
	#	RustClock			- This function shows the currently ingame time.							#
	#	Help				- If you want to see all commands ingame type /help.						#
	#	AdminHelp			- Admins can type /adminhelp to see all admin commands.						#
	#	EasyServerSaver		- An easy ingame function to save all server data.							#
	#	Message of the Day	- A typical message if someone joined/left the server.						#
	#	BaseAttackAlert		- It alerts you if your base will be attacked and show you the attacker.	#
	#	DeathLog			- DeathLog creates a txt file which allows you to review all deaths.		#
	#	ChatLog				- ChatLog is a function to save the server chat into a file.				#
	#																									#
	#	Functions in development:																		#
	#	EasySuicide			- Chat Command to suicide.													#
	#	RandomCrate			- Function to spawn a random crate on map for a while. It could be used		#
	#						  as an alternative way for airdrops.										#
	#	EasyTeleport		- Teleport players via chat command.										#
	#	EasyAnnouncer		- An automated message shown in chat every 5 minutes.						#
	#																									#
	#	Gamekeller Core Plugin is written by Gamekeller Dev Team										#
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

-- Time
local vTimeOfDay = util.GetStaticPropertyGetter( Rust.EnvironmentControlCenter, "timeOfDay" )

-- DeathLog Time
local func_dateTime = util.GetStaticPropertyGetter( System.DateTime, 'Now' )

-- Counting included Functions
local functioncounter = 0

function PLUGIN:Init()
	-- Gamekeller Settings Loader
	self.settingsDataFile = util.GetDatafile( "gk_settings" )
	local settingstxt = self.settingsDataFile:GetText()
	if (settingstxt ~= "") then
		self.settingsText = json.decode( settingstxt )
	else
		self.settingsText = {
			["PluginSettings"] = {
				["chatName"] = "GKCore"
			},
			["GetTime"] = {
				["addsub"] = "",
				["timediff"] = ""
			},
			["EasyPlayerList"] = {
				["enabled"] = "true",
				["maxPlayersPerLine"] = "5"
			},
			["EasyAdminRights"] = {
				["enabled"] = "true"
			},
			["RustClock"] = {
				["enabled"] = "true"
			},
			["Help"] = {
				["enabled"] = "true"
			},
			["AdminHelp"] = {
				["enabled"] = "true"
			},
			["EasyServerSaver"] = {
				["enabled"] = "true"
			},
			["MotD"] = {
				["enabled"] = "true"
			},
			["BaseAttackAlert"] = {
				["enabled"] = "true"
			},
			["DeathLog"] = {
				["enabled"] = "true"
			},
			["ChatLog"] = {
				["enabled"] = "true"
			},
			["EasyAnnouncer"] = {
				["enabled"] = "false",
				["message"] = "Type /help to show commands in chat.",
			}
		}
		self:SaveSettings()
	end

	-- EasyAnnouncer
	--self.myTimer = timer.Repeat(20, 0, function() self:EasyAnnouncer() end)
	--self:AddChatCommand("announce.enable", self.enableEasyAnnouncer)
	--self:AddChatCommand("announce.disable", self.disableEasyAnnouncer)
	--self:AddChatCommand("announce", self.changeEasyAnnouncerMessage)
	--self:AddChatCommand("announce.stop", self.stopEasyAnnouncer)
	--self:AddChatCommand("announce.start", self.startEasyAnnouncer)

	-- Change ChatName Chat Command
	self:AddChatCommand("chatname", self.changeChatName)

	-- CoreReloader Console Command
	self:AddCommand("gkcore", "reload", self.consoleCommandReload)
	-- CoreReloader Chat Command
	self:AddChatCommand("gkcore.reload", self.chatCommandReload)

	-- BaseAttackAlert Chat Command
	self:AddChatCommand("baa.enable", self.enableBaseAttackAlert)
	self:AddChatCommand("baa.disable", self.disableBaseAttackAlert)

	-- Help Chat Command
	self:AddChatCommand("help", self.Help)
	self:AddChatCommand("help.enable", self.enableHelp)
	self:AddChatCommand("help.disable", self.disableHelp)

	-- AdminHelp Chat Command
	self:AddChatCommand("adminhelp", self.AdminHelp)
	self:AddChatCommand("adminhelp.enable", self.enableAdminHelp)
	self:AddChatCommand("adminhelp.disable", self.disableAdminHelp)

	-- EasyPlayerList Chat Command
	self:AddChatCommand("list", self.EasyPlayerList)
	self:AddChatCommand("list.enable", self.enableEasyPlayerList)
	self:AddChatCommand("list.disable", self.disableEasyPlayerList)

	-- RustClock Chat Command
	self:AddChatCommand("time", self.RustClock)
	self:AddChatCommand("time.enable", self.enableRustClock)
	self:AddChatCommand("time.disable", self.disableRustClock)

	-- EasyServerSaver Chat Command
	self:AddChatCommand("save", self.EasyServerSaver)
	self:AddChatCommand("save.enable", self.enableEasyServerSaver)
	self:AddChatCommand("save.disable", self.disableEasyServerSaver)

	-- EasyAdminRights Chat Command
	self:AddChatCommand("giveadmin", self.giveAdminRights)
	self:AddChatCommand("remadmin", self.removeAdminRights)
	self:AddChatCommand("admin.enable", self.enableEasyAdminRights)
	self:AddChatCommand("admin.disable", self.disableEasyAdminRights)
	-- EasyAdminRights Config
	self.AdminDataFile = util.GetDatafile( "gk_admins" )
	local admintxt = self.AdminDataFile:GetText()
	if (admintxt ~= "") then
		self.AdminData = json.decode( admintxt )
	else
		self.AdminData = {}
	end

	-- EasySuicide
	--self:AddChatCommand("suicide", self.doSuicide)

	-- DeathLog Chat Command
	self:AddChatCommand("deathlog.enable", self.enableDeathLog)
	self:AddChatCommand("deathlog.disable", self.disableDeathLog)
	-- DeathLog
	self.deathLogDataFile = util.GetDatafile( "gk_deathlog" )
	local deathLogtxt = self.deathLogDataFile:GetText()
	if (deathLogtxt ~= "") then
		self.deathLogText = deathLogtxt
	else
		self.deathLogText = ""
	end

	-- ChatLog
	self:AddChatCommand("chatlog.enable", self.enableChatLog)
	self:AddChatCommand("chatlog.disable", self.disableChatLog)
	self.chatLogDataFile = util.GetDatafile( "gk_chatlog" )
	local chatLogtxt = self.chatLogDataFile:GetText()
	if (chatLogtxt ~= "") then
		self.chatLogText = chatLogtxt
	else
		self.chatLogText = ""
	end

	-- Server Time Zone Correction for Log Files
	self:AddChatCommand("timezone", self.changeTimeZone)
end

-- Reloads the plugin via console
function PLUGIN:consoleCommandReload( arg )
	local user = arg.argUser
	if (user and not user:CanAdmin()) then
		rust.Notice(arg.argUser, "You do not have permission to use this command!")
		return
	end
	cs.reloadplugin(self.Name)
	rust.Notice(arg.argUser, "Gamekeller Core reloaded.")
end

-- Reloads the plugin via chat
function PLUGIN:chatCommandReload( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	cs.reloadplugin(self.Name)
	rust.Notice(netUser, "Gamekeller Core reloaded.")
end
functioncounter = functioncounter + 1
print( functioncounter .. " - CoreReload function loaded..." )

-- PLUGINS WITH Commands
-- Help Message
function PLUGIN:Help( netUser )
	if (self.settingsText["Help"]["enabled"] == "true") then
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Available chat commands:" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/share Name - Add Player to DoorShare-List" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/unshare Name - Remove Player from DoorShare-List" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/list - Shows Online Players" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/time - Shows Game Time" ) .. "\"" )
		if (netUser:CanAdmin()) then
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/adminhelp - Shows admin commands" ) .. "\"" )
		end
	else
		rust.Notice(netUser, "Help is currently disabled.")
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - Help function loaded..." )

-- AdminHelp Message
function PLUGIN:AdminHelp( netUser )
	if (self.settingsText["AdminHelp"]["enabled"] == "true") then
		if (netUser:CanAdmin()) then
			-- Function calls
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Available admin chat commands:" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/save - Save Server Data" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/giveadmin Name - Give Admin Rights to Player" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/remadmin Name - Remove Admin Rights from Player" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/chatname Name - Change the Server Chatname" ) .. "\"" )

			-- Function enable/disable commands
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Write enable or disable after the dot in these commands:" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/admin.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/list.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/baa.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/help.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/adminhelp.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/save.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/chatlog.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/deathlog.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/chatname.enable/disable - Enable/Disable EasyAdminRights" ) .. "\"" )

			-- Reload Function call
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "/gkcore.reload - Reload Gamekeller Core Plugin" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Available console commands:" ) .. "\"" )
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "gkcore.reload - Reload Gamekeller Core Plugin" ) .. "\"" )
		end
	else
		rust.Notice(netUser, "AdminHelp is currently disabled.")
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - AdminHelp function loaded..." )

-- EasyPlayerList
function PLUGIN:EasyPlayerList( netUser, cmd, args )
	if (self.settingsText["EasyPlayerList"]["enabled"] == "true") then
		local maxplayers = RustFirstPass.server.maxplayers
		local maxpPL = tonumber(self.settingsText["EasyPlayerList"]["maxPlayersPerLine"])
		local playerlist = rust.GetAllNetUsers()
		local playercounter = 0
		for var, value in pairs(playerlist) do
			playercounter = playercounter + 1
		end
		local players = 0
		local plcmsg = ""
		if(playercounter == 1) then
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "You're the only connected player." ) .. "\"" )
		else
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( playercounter .. "/".. maxplayers .. " Players Online" ) .. "\"" )
			for i=1, playercounter, 1 do
				if(players < maxpPL) then
					plcmsg = plcmsg .. util.QuoteSafe(playerlist[i].displayName) .. ", "
					players=players+1
				else
					plcmsg = string.sub(plcmsg,1,string.len(plcmsg)-2)
					rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( plcmsg ) .. "\"" )
					plcmsg = util.QuoteSafe(playerlist[i].displayName .. ", ")
					players=1
				end
			end
			plcmsg = string.sub(plcmsg,1,string.len(plcmsg)-2)
			rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( plcmsg ) .. "\"" )
		end
	else
		rust.Notice(netUser, "EasyPlayerList is currently disabled.")
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - EasyPlayerList function loaded..." )

-- Save Gamekeller Settings
function PLUGIN:SaveSettings()
	self.settingsDataFile:SetText( json.encode( self.settingsText ) )
	self.settingsDataFile:Save()
end

-- Message of the Day + EasyAdminRights
function PLUGIN:OnUserConnect( netUser )
	-- EasyAdminRights
	if (self.settingsText["EasyAdminRights"]["enabled"] == "true") then
		local adminUser = self:GetUserData( netUser )
		if (adminUser.isAdmin) then
			netUser:SetAdmin(true)
			rust.Notice( netUser, "You are admin!" )
		end
	end

	-- MotD
	if (self.settingsText["MotD"]["enabled"] == "true") then
		if (netUser:CanAdmin()) then 
			rust.BroadcastChat(self.settingsText["PluginSettings"]["chatName"], "Admin " .. netUser.displayName .. " joined the server.")
		else
			rust.BroadcastChat(self.settingsText["PluginSettings"]["chatName"], "Player " .. netUser.displayName .. " joined the server.")
		end
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Welcome " .. netUser.displayName .. "!" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Server Settings:" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "DoorShare, EasyPlayerList, RustClock, BaseAttackAlert, MotD" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Airdrops at 8 Players, Sleepers On, Commands /help" ) .. "\"" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "TS3 IP: 88.80.200.100" ) .. "\"" )
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - EasyAdminRights function loaded..." )
functioncounter = functioncounter + 1
print( functioncounter .. " - Message of the Day function loaded..." )

-- Message of the Day
function PLUGIN:OnUserDisconnect( netUser )
	if (self.settingsText["MotD"]["enabled"] == "true") then
		if (netUser:CanAdmin()) then 
			rust.BroadcastChat(self.settingsText["PluginSettings"]["chatName"], "Admin " .. netUser.displayName .. " left the server.")
		else
			rust.BroadcastChat(self.settingsText["PluginSettings"]["chatName"], "Player " .. netUser.displayName .. " left the server.")
		end
	end
end

-- RustClock
function PLUGIN:RustClock( netUser, cmd, args )
	if (self.settingsText["RustClock"]["enabled"] == "true") then
		local rawTime = tonumber(vTimeOfDay())
		local hour	= math.floor(rawTime)
		local minutes = math.floor(self:round(((rawTime - hour) * 60), 2))
		local time	= string.format("%02d:%02d", hour, minutes)
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "Time: " .. time ) .. "\"" )
	else
		rust.Notice(netUser, "RustClock is currently disabled.")
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - RustClock function loaded..." )

-- RustClock Round
function PLUGIN:round( num, idp )
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- EasyServerSaver
function PLUGIN:EasyServerSaver( netUser, args )
	if (self.settingsText["EasyServerSaver"]["enabled"] == "true") then
		if (netUser:CanAdmin()) then 
			local SaveCommand = "save.all"
			rust.RunServerCommand(SaveCommand)
			rust.Notice( netUser, "Server Data saved!" )
		else
			rust.Notice( netUser, "You do not have permission to use this command!" )
		end
	else
		rust.Notice(netUser, "EasyServerSaver is currently deacitvated.")
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - EasyServerSaver function loaded..." )

-- EasyAdminRights give Admin Rights
function PLUGIN:giveAdminRights( netUser, cmd, args )
	if (self.settingsText["EasyAdminRights"]["enabled"] == "true") then
		if (not(args[1])) then
			return
		end
		if (not(netUser:CanAdmin())) then
			rust.Notice( netUser, "You do not have permission to use this command!" )
			return
		end
		
		local b, targetuser = rust.FindNetUsersByName( args[1] )
		if (not b) then
			if (targetuser == 0) then
				rust.Notice( netUser, "No players found with that name!" )
			else
				rust.Notice( netUser, "Multiple players found with that name!" )
			end
			return
		end	
		local data = self:GetUserData( targetuser )
		self.AdminData[data.ID].isAdmin = true
		targetuser:SetAdmin(true)
		self:adminSave()
		rust.Notice( targetuser, "You've received Admin rights!" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "You've given Admin rights to " .. targetuser.displayName ) .. "\"" )
	else
		rust.Notice(netUser, "EasyAdminRights is currently disabled.")
	end
end

-- EasyAdminRights remove Admin Rights
function PLUGIN:removeAdminRights( netUser, cmd, args )
	if (self.settingsText["EasyAdminRights"]["enabled"] == "true") then
		if (not(args[1])) then
			return
		end
		if (not(netUser:CanAdmin())) then
			rust.Notice( netUser, "You do not have permission to use this command!" )
			return
		end
		
		local b, targetuser = rust.FindNetUsersByName( args[1] )
		if (not b) then
			if (targetuser == 0) then
				rust.Notice( netUser, "No players found with that name!" )
			else
				rust.Notice( netUser, "Multiple players found with that name!" )
			end
			return
		end
		
		local data = self:GetUserData( targetuser )
		self.AdminData[data.ID].isAdmin = false
		targetuser:SetAdmin(false)
		self:adminSave()
		rust.Notice( targetuser, "You're Admin rights were removed!" )
		rust.RunClientCommand(netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( "You removed Admin rights from " .. targetuser.displayName ) .. "\"" )
	else
		rust.Notice(netUser, "EasyAdminRights is currently disabled.")
	end
end

-- EasyAdminRights Save
function PLUGIN:adminSave()
	self.AdminDataFile:SetText( json.encode( self.AdminData ) )
	self.AdminDataFile:Save()
end

-- EasyAdminRights GetUserData
function PLUGIN:GetUserData( netUser )
	local userID = rust.GetUserID( netUser )
	return self:GetUserDataFromID( userID, netUser.displayName )
end

-- EasyAdminRights GetUserDataFromID
function PLUGIN:GetUserDataFromID( userID, name )
	local userentry = self.AdminData[ userID ]
	if (not userentry) then
		userentry = {}
		userentry.ID = userID
		userentry.Name = name
		userentry.isAdmin = false
		self.AdminData[ userID ] = userentry
		self:adminSave()
	end
	return userentry
end

-- Timezone Changer
function PLUGIN:changeTimeZone( netUser, cmd, args )
	if (netUser:CanAdmin()) then
		if (args[1] and args[2] and (args[1] == "add" or args[1] == "sub")) then
			self.settingsText["GetTime"]["addsub"] = args[1]
			self.settingsText["GetTime"]["timediff"] = args[2]
			self:SaveSettings()
			rust.Notice( netUser, "Time Zone changed." )
		else
			rust.Notice( netUser, "Syntax: /timezone \"add/sub\" \"number of hours\" " )
		end
	else
		rust.Notice( netUser, "You do not have permission to use this command!" )
	end
end

-- EasyAnnouncer Stop
--function PLUGIN:stopEasyAnnouncer( netUser )
--	if (netUser:CanAdmin()) then
--			self.myTimer:Destroy()
--			rust.Notice( netUser, "EasyAnnouncer stopped." )
--	else
--		rust.Notice( netUser, "You do not have permission to use this command!" )
--	end
--end

-- EasyAnnouncer Start
--function PLUGIN:startEasyAnnouncer( netUser )
--	if (netUser:CanAdmin()) then
--			self.myTimer = timer.Repeat(20, 0, function() self:EasyAnnouncer() end)
--			rust.Notice( netUser, "EasyAnnouncer started." )
--	else
--		rust.Notice( netUser, "You do not have permission to use this command!" )
--	end
--end

-- EasySuicide
--function PLUGIN:doSuicide( netUser, cmd )
-- 	rust.RunClientCommand( netUser, "suicide" )
-- 	rust.Notice ( netUser, "Suicided!" )
--end
--functioncounter = functioncounter + 1
--print ( functioncounter .. " - EasySuicide function loaded...")

-- PLUGINS WITHOUT Commands
-- EasyAnnouncer
--function PLUGIN:EasyAnnouncer( netUser )
--	if (self.settingsText["EasyAnnouncer"]["enabled"] == "true") then
--		rust.RunClientCommand( netUser, "chat.add \"" .. util.QuoteSafe( self.settingsText["PluginSettings"]["chatName"] ) .. "\" \"" .. util.QuoteSafe( self.settingsText["EasyAnnouncer"]["Message"] ) .. "\"" )
--		print(self.settingsText["EasyAnnouncer"]["Message"])
--	end
--end
--functioncounter = functioncounter + 1
--print ( functioncounter .. " - EasyAnnouncer function loaded...")

-- DeathLog Save
function PLUGIN:deathLogSave( netUser )
	self.deathLogDataFile:SetText( self.deathLogText )
	self.deathLogDataFile:Save()
end

--ChatLog
function PLUGIN:OnUserChat( netUser, name, msg )
	if (self.settingsText["ChatLog"]["enabled"] == "true") then
		local time = self:getTime()
		if (self.chatLogText ~= "") then
				self.chatLogText = self.chatLogText .. time .. " " .. name .. ": " .. msg .. "\r\n"
			else
				self.chatLogText = time .. " " .. name .. ": " .. msg .. "\r\n"
		end
		self:chatLogSave()
	end
end
functioncounter = functioncounter + 1
print ( functioncounter .. " - ChatLog function loaded...")

-- ChatLog Save
function PLUGIN:chatLogSave( netUser )
	self.chatLogDataFile:SetText( self.chatLogText )
	self.chatLogDataFile:Save()
end

-- EasyAnnouncer Save
--function PLUGIN:changeEasyAnnouncerMessage( netUser, cmd, args)
--	if (netUser:CanAdmin()) then
--		if (args[1]) then
--			self.settingsText["EasyAnnouncer"]["message"] = args[1]
--			self:SaveSettings()
--			rust.Notice( netUser, "EasyAnnouncer message changed." )
--		else
--			rust.Notice( netUser, "Syntax: /announce \"Message\"" )
--		end
--	else
--		rust.Notice( netUser, "You do not have permission to use this command!" )
--	end
--end

-- BaseAttackAlert / DeathLog
function PLUGIN:OnKilled( takedamage, damage )
	-- DeathLog
	if (self.settingsText["DeathLog"]["enabled"] == "true") then
		local message = ""
		local suicide
		local time = self:getTime()

		if (takedamage:GetComponent("HumanController")) then
			if (damage.victim.client.netUser.displayName) then
				if (damage.victim.client.netUser.displayName == damage.attacker.client.netUser.displayName) then
					message = damage.victim.client.netUser.displayName .. " has commited suicide"
				else
					if (damage.victim.client.netUser.displayName ~= damage.attacker.client.netUser.displayName) then
						message = damage.victim.client.netUser.displayName .. " was killed by " .. damage.attacker.client.netUser.displayName
					else
						return
					end
				end
				
				if (message == "") then
					message = damage.victim.client.netUser.displayName .. " died otherwise"
				end

				if (self.deathLogText ~= "") then
					self.deathLogText = self.deathLogText .. time .. " " .. message .. "\r\n"
					self:deathLogSave()
				else
					self.deathLogText = time .. " " .. message .. "\r\n"
					self:deathLogSave()
				end
			end
		end
	end

	-- BaseAttackAlert
	if (self.settingsText["BaseAttackAlert"]["enabled"] == "true") then
		if (takedamage:GetComponent( "DeployableObject" )) then
			if(damage.attacker.client) then
				local deployable = takedamage:GetComponent( "DeployableObject" )
				local players = rust.GetAllNetUsers()
				if(deployable.creatorID ~= damage.attacker.client.netUser.Userid) then
					for key,value in pairs(players) do
						if(deployable.creatorID == value.User.Userid) then
							rust.Notice(value, "Your base is under attack by " .. damage.attacker.client.netUser.displayName .. "!")
							rust.SendChatToUser(value, "Your base is under attack by " .. damage.attacker.client.netUser.displayName .. "!")						
						end
					end 
				end
				return
			end
		end		
		if (takedamage:GetComponent ( "StructureComponent" )) then
			if(damage.attacker.client) then
				local entity = takedamage:GetComponent("StructureComponent")
				local master = entity._master
				if(master.creatorID ~= damage.attacker.client.netUser.Userid) then
				local players = rust.GetAllNetUsers()
					for key,value in pairs(players) do
						if(master.creatorID == value.User.Userid) then
							rust.Notice(value, "Your base is under attack by " .. damage.attacker.client.netUser.displayName .. "!")
							rust.SendChatToUser(value, "Your base is under attack by " .. damage.attacker.client.netUser.displayName .. "!")						
						end
					end
				end
				return
			end
		end
	end
end
functioncounter = functioncounter + 1
print( functioncounter .. " - BaseAttackAlert function loaded..." )
functioncounter = functioncounter + 1
print( functioncounter .. " - DeathLog function loaded...")

-- LOCAL FUNCTIONS
-- String Explode
function PLUGIN:stringExplode( sep, str )
	local t = {}
	for word in string.gmatch( str, "[^"..sep.."]+" ) do 
		table.insert( t, word )
	end	
	return t
end

-- Get System Time
function PLUGIN:getTime()
	local dateTime = self:stringExplode( " ", tostring( func_dateTime() ) )
	local date = dateTime[1]
	local time = dateTime[2]
	local ampm = dateTime[3]
	local dateParts = self:stringExplode( "/", date )
	local timeParts = self:stringExplode( ":", time )

	local checktime = tonumber( timeParts[1] )

	if ampm == "PM:" then 
		checktime = checktime + 12
	end

	-- CORRECT TIME ZONE: vars addsub and timediff are at the top of the plugin
	if (self.settingsText["GetTime"]["addsub"] and self.settingsText["GetTime"]["timediff"]) then
		if (self.settingsText["GetTime"]["addsub"] == "add") then
			checktime = checktime + self.settingsText["GetTime"]["timediff"]
			if (checktime > 24) then
				checktime = checktime - 24
				dateParts[2] = dateParts[2] + 1
			end
		elseif (self.settingsText["GetTime"]["addsub"] == "sub") then
			checktime = checktime - self.settingsText["GetTime"]["timediff"]
			if (checktime < 0) then
				checktime = checktime + 24
				dateParts[2] = dateParts[2] - 1
			end
		end

		if (checktime < 12) then
			ampm = "AM:"
		else
			ampm = "PM:"
		end
	end

	timeParts[1] = tostring( checktime )
	date = table.concat( { dateParts[2], dateParts[1], dateParts[3] }, "." )
	time = table.concat( timeParts, ":" )
	return "[" .. date .. " " .. time .. "]"
end

-- Change Chatname
function PLUGIN:changeChatName( netUser, cmd, args )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	if (not args[1]) then
		rust.Notice( netuser, "Syntax: /chatname name" )
		return
	end
	self.settingsText["PluginSettings"]["chatName"] = args[1]
	self:SaveSettings()
end

-- Activate/Deactivate Functions
-- enable EasyPlayerList through Chat
function PLUGIN:enableEasyPlayerList( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "EasyPlayerList enabled.")
	self.settingsText["EasyPlayerList"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable EasyPlayerList through Chat
function PLUGIN:disableEasyPlayerList( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "EasyPlayerList disabled.")
	self.settingsText["EasyPlayerList"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable EasyAdminRights through Chat
function PLUGIN:enableEasyAdminRights( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "EasyAdminRights enabled.")
	self.settingsText["EasyAdminRights"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable EasyAdminRights through Chat
function PLUGIN:disableEasyAdminRights( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "EasyAdminRights disabled.")
	self.settingsText["EasyAdminRights"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable RustClock through Chat
function PLUGIN:enableRustClock( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "RustClock enabled.")
	self.settingsText["RustClock"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable RustClock through Chat
function PLUGIN:disableRustClock( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "RustClock disabled.")
	self.settingsText["RustClock"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable Help through Chat
function PLUGIN:enableHelp( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "Help enabled.")
	self.settingsText["Help"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable Help through Chat
function PLUGIN:disableHelp( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "Help disabled.")
	self.settingsText["Help"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable EasyServerSaver through Chat
function PLUGIN:enableEasyServerSaver( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "EasyServerSaver enabled.")
	self.settingsText["EasyServerSaver"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable EasyServerSaver through Chat
function PLUGIN:disableEasyServerSaver( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "EasyServerSaver disabled.")
	self.settingsText["EasyServerSaver"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable MotD through Chat
function PLUGIN:enableMotD( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "MotD enabled.")
	self.settingsText["MotD"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable MotD through Chat
function PLUGIN:disableMotD( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "MotD disabled.")
	self.settingsText["MotD"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable BaseAttackAlert through Chat
function PLUGIN:enableBaseAttackAlert( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "BaseAttackAlert enabled.")
	self.settingsText["BaseAttackAlert"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable BaseAttackAlert through Chat
function PLUGIN:disableBaseAttackAlert( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "BaseAttackAlert disabled.")
	self.settingsText["BaseAttackAlert"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable DeathLog through Chat
function PLUGIN:enableDeathLog( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "DeathLog enabled.")
	self.settingsText["DeathLog"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable DeathLog through Chat
function PLUGIN:disableDeathLog( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "DeathLog disabled.")
	self.settingsText["DeathLog"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable ChatLog through Chat
function PLUGIN:enableChatLog( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "ChatLog enabled.")
	self.settingsText["ChatLog"]["enabled"] = "true"
	self:SaveSettings()
end
-- disable ChatLog through Chat
function PLUGIN:disableChatLog( netUser )
	if (not(netUser:CanAdmin())) then
		rust.Notice(netUser, "You do not have permission to use this command!")
		return
	end
	rust.Notice(netUser, "ChatLog disabled.")
	self.settingsText["ChatLog"]["enabled"] = "false"
	self:SaveSettings()
end

-- enable EasyAnnouncer through Chat
--function PLUGIN:enableEasyAnnouncer( netUser )
--	if (not(netUser:CanAdmin())) then
--		rust.Notice(netUser, "You do not have permission to use this command!")
--		return
--	end
--	rust.Notice(netUser, "EasyAnnouncer enabled.")
--	self.settingsText["EasyAnnouncer"]["enabled"] = "true"
--	self:SaveSettings()
--end
-- disable EasyAnnouncer through Chat
--function PLUGIN:disableEasyAnnouncer( netUser )
--	if (not(netUser:CanAdmin())) then
--		rust.Notice(netUser, "You do not have permission to use this command!")
--		return
--	end
--	rust.Notice(netUser, "EasyAnnouncer disabled.")
--	self.settingsText["EasyAnnouncer"]["enabled"] = "false"
--	self:SaveSettings()
--end

print( functioncounter .. " functions loaded")
print( "Plugin is ready to use" )
print("-----------------------")