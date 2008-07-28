WIM = {}; -- WIM's core object.
local WIM = WIM;

WIM.debug = true; -- turn debugging on and off.
WIM.constants = {}; -- constants such as class colors will be stored here. (includes female class names).
WIM.modules = {}; -- module table. consists of all registerd WIM modules/plugins/skins. (treated the same).
WIM.windows = {active = {}}; -- table of WIM windows.
WIM.libs = {}; -- table of loaded library references.

-- default options. live data is found in WIM.db
-- modules may insert fields into this table to
-- respect their option contributions.
WIM.db_defaults = {
    enabled = true,
    showToolTips = true,
}

-- WIM.env is an evironmental reference for the current instance of WIM.
-- Information is stored here such as .realm and .character.
-- View table dump for more available information.
WIM.env = {};

-- default lists - This will store lists such as friends, guildies, raid members etc.
WIM.lists = {};

-- list of all the events registered from attached modules.
local Events = {};

local WIM_isEnabled = false;
local WIM_isBeta = true;


-- create a frame to moderate events and frame updates.
    local workerFrame = CreateFrame("Frame", "WIM_workerFrame");
    workerFrame:SetScript("OnEvent", function() WIM:EventHandler(event) end);
    
    -- some events we always want to listen to so data is ready upon WIM being enabled.
    workerFrame:RegisterEvent("VARIABLES_LOADED");
    workerFrame:RegisterEvent("ADDON_LOADED");
    workerFrame:RegisterEvent("GUILD_ROSTER_UPDATE");
    workerFrame:RegisterEvent("FRIENDLIST_UPDATE");
    

-- called when WIM is first loaded into memory but after variables are loaded.
local function initialize()
    --load cached information from the WIM_Cache saved variable.
	WIM_Cache[WIM.env.realm] = WIM_Cache[WIM.env.realm] or {};
        WIM_Cache[WIM.env.realm][WIM.env.character] = WIM_Cache[WIM.env.realm][WIM.env.character] or {};
	WIM.lists.friends = WIM_Cache[WIM.env.realm][WIM.env.character].friendList;
	WIM.lists.guild = WIM_Cache[WIM.env.realm][WIM.env.character].guildList;
        
        if(type(WIM.lists.friends) ~= "table") then WIM.lists.friends = {}; end
        if(type(WIM.lists.guild) ~= "table") then WIM.lists.guild = {}; end
        
        --querie guild roster
        if( IsInGuild() ) then
            GuildRoster();
        end
    
    WIM.libs.Astrolabe = DongleStub("Astrolabe-0.4");
    
    WIM.isInitialized = true;
    
    WIM:RegisterPrematureSkins();
    
    WIM:dPrint("WIM initialized...");
end

-- called when WIM is enabled.
-- WIM will not be enabled until WIM is initialized event is fired.
local function onEnable()
    WIM.db.enabled = true;
    
    local tEvent;
    for tEvent, _ in pairs(Events) do
        workerFrame:RegisterEvent(tEvent);
    end
    
    local module = WIM.modules[moduleName];
    if(module) then
        module.enabled = enabled;
        if(type(module.OnEnableWIM) == "function") then
            module:OnEnableWIM();
        end
    end
    
    WIM_isEnabled = true;
    WIM:dPrint("WIM is now enabled.");
end

-- called when WIM is disabled.
local function onDisable()
    WIM.db.enabled = false;
    
    local tEvent;
    for tEvent, _ in pairs(Events) do
        workerFrame:UnregisterEvent(tEvent);
    end
    
    local module = WIM.modules[moduleName];
    if(module) then
        module.enabled = enabled;
        if(type(module.OnDisableWIM) == "function") then
            module:OnDisableWIM();
        end
    end
    
    WIM_isEnabled = false;
    WIM:dPrint("WIM is now disabled.");
end


function WIM:SetEnabled(enabled)
    if( enabled ) then
        onEnable();
    else
        onDisable();
    end
end

-- events are passed to modules. Events do not need to be
-- unregistered. A disabled module will not receive events.
local function RegisterEvent(event)
    Events[event] = true;
    if( WIM_isEnabled ) then
        workerFrame:RegisterEvent(event);
    end
end

-- create a new WIM module. Will return module object.
function WIM:CreateModule(moduleName)
    if(type(moduleName) == "string") then
        WIM.modules[moduleName] = {
            title = moduleName,
            enabled = false,
            canDisable = true,
            resources = {
                lists = WIM.lists,
                windows = WIM.windows,
                env = WIM.env,
                constants = WIM.constants,
                libs = WIM.libs,
            },
            db = WIM.db,
            db_defaults = WIM.db_defaults;
            RegisterEvent = function(self, event) RegisterEvent(event); end,
            Enable = function() WIM:EnableModule(moduleName, true) end,
            Disable = function() WIM:EnableModule(moduleName, false) end,
            dPrint = function(self, t) WIM:dPrint(t); end,
        }
        return WIM.modules[moduleName];
    else
        return nil;
    end
end

function WIM:EnableModule(moduleName, enabled)
    local module = WIM.modules[moduleName];
    if(module) then
        if(module.canDisable == false and enabled == false) then
            WIM:dPrint("Module '"..moduleName.."' can not be disabled!");
            return;
        end
        module.enabled = enabled;
        if(type(module.OnEnableDisable) == "function") then
            module:OnEnableDisable(enabled);
        end
        if(enabled) then
            WIM:dPrint("Module '"..moduleName.."' Enabled");
        else
            WIM:dPrint("Module '"..moduleName.."' Disabled");
        end
    end
end

--------------------------------------
--          Event Handlers          --
--------------------------------------

local function honorChatFrameEventFilter(event, msg)
	local chatFilters = ChatFrame_GetMessageEventFilters(event);
	if chatFilters then 
		local filter, newmsg = false;
		for _, filterFunc in next, chatFilters do
			-- first make sure, we aren't doubling up on events. We don't need WIM to do its own twice.
			if(filterFunc ~= WIM_ChatFrame_MessageEventFilter_WHISPERS) then
				filter, newmsg = filterFunc(msg);
				if filter then 
					return true; 
				end 
			end
		end 
	end 
	return false;
end


-- This is WIM's core event controler.
function WIM:EventHandler(event)
    -- before we do any filtering, make sure that we are not speaking to a GM.
    -- no matter what, we want to see these.
    if(not (event == "CHAT_MSG_WHISPER" and agr6 ~= "GM")) then
        -- first we will filter out
        if(honorChatFrameEventFilter(event, agr1 or "")) then
            -- ChatFrame's event filters said to block this message.
            return;
        end
        -- other filtering will take place in individual event handlers within modules.
    end

    -- Core WIM Event Handlers.
    WIM:dPrint("Event '"..event.."' received.");
    local fun = WIM[event];
    if(type(fun) == "function") then
        WIM:dPrint("  +-- WIM:"..event);
        fun();
    end
    
    -- Module Event Handlers
    local module, tData;
    for module, tData in pairs(WIM.modules) do
        fun = tData[event];
        if(type(fun) == "function" and tData.enabled) then
            WIM:dPrint("  +-- "..module..":"..event);
            fun();
        end
    end
end

function WIM:VARIABLES_LOADED()
    WIM.db = WIM3_Data or {};
    WIM_Cache = WIM_Cache or {};
    
    -- load some environment data.
    WIM.env.realm = GetCVar("realmName");
    WIM.env.character = UnitName("player");
    
    -- inherrit any new default options which wheren't shown in previous releases.
    WIM.copyTable(WIM.db_defaults, WIM.db);
    WIM.lists.gm = {};
    
    initialize();
    WIM:SetEnabled(WIM.db.enabled);
end

function WIM:FRIENDLIST_UPDATE()
    WIM_Cache[WIM.env.realm][WIM.env.character].friendList = {};
	for i=1, GetNumFriends() do 
		local name, junk = GetFriendInfo(i);
		if(name) then
			WIM_Cache[WIM.env.realm][WIM.env.character].friendList[name] = "1"; --[set place holder for quick lookup
		end
	end
    WIM.lists.friends = WIM_Cache[WIM.env.realm][WIM.env.character].friendList;
    WIM:dPrint("Friends list updated...");
end

function WIM:GUILD_ROSTER_UPDATE()
	WIM_Cache[WIM.env.realm][WIM.env.character].guildList = {};
	if(IsInGuild()) then
		for i=1, GetNumGuildMembers(true) do 
			local name, junk = GetGuildRosterInfo(i);
			if(name) then
				WIM_Cache[WIM.env.realm][WIM.env.character].guildList[name] = "1"; --[set place holder for quick lookup
			end
		end
	end
	WIM.lists.guild = WIM_Cache[WIM.env.realm][WIM.env.character].guildList;
        WIM:dPrint("Guild list updated...");
end

function WIM:IsGM(name)
    if(name == nil or name == "") then
		return false;
	end
	if(string.len(name) < 4) then return false; end
	if(string.sub(name, 1, 4) == "<GM>") then
		local tmp = string.gsub(name, "<GM> ", "");
		WIM.lists.gm[tmp] = 1;
		return true;
	else
		if(WIM.lists.gm[user]) then
			return true;
		else
			return false;
		end
	end
end

