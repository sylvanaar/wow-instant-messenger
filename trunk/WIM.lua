-- imports
local WIM = WIM;
local _G = _G;
local CreateFrame = CreateFrame;
local select = select;
local type = type;
local table = table;
local pairs = pairs;
local string = string;

-- set name space
setfenv(1, WIM);

-- Core information
addonTocName = "WIM_Rewrite";
version = "3.0.0";
beta = true; -- flags current version as beta.
debug = true; -- turn debugging on and off.

-- WOTLK check by CKKnight
isWOTLK = select(4, _G.GetBuildInfo()) >= 30000;

constants = {}; -- constants such as class colors will be stored here. (includes female class names).
modules = {}; -- module table. consists of all registerd WIM modules/plugins/skins. (treated the same).
windows = {active = {whisper = {}, chat = {}, w2w = {}}}; -- table of WIM windows.
libs = {}; -- table of loaded library references.

-- default options. live data is found in WIM.db
-- modules may insert fields into this table to
-- respect their option contributions.
db_defaults = {
    enabled = true,
    showToolTips = true,
    modules = {},
};

-- WIM.env is an evironmental reference for the current instance of WIM.
-- Information is stored here such as .realm and .character.
-- View table dump for more available information.
env = {};

-- default lists - This will store lists such as friends, guildies, raid members etc.
lists = {};

-- list of all the events registered from attached modules.
local Events = {};


-- create a frame to moderate events and frame updates.
    local workerFrame = CreateFrame("Frame", "WIM_workerFrame");
    workerFrame:SetScript("OnEvent", function(self, event, ...) WIM:EventHandler(event, ...); end);
    
    -- some events we always want to listen to so data is ready upon WIM being enabled.
    workerFrame:RegisterEvent("VARIABLES_LOADED");
    workerFrame:RegisterEvent("ADDON_LOADED");
    workerFrame:RegisterEvent("GUILD_ROSTER_UPDATE");
    workerFrame:RegisterEvent("FRIENDLIST_UPDATE");


-- called when WIM is first loaded into memory but after variables are loaded.
local function initialize()
    --load cached information from the WIM_Cache saved variable.
	env.cache[env.realm] = env.cache[env.realm] or {};
        env.cache[env.realm][env.character] = env.cache[env.realm][env.character] or {};
	lists.friends = env.cache[env.realm][env.character].friendList;
	lists.guild = env.cache[env.realm][env.character].guildList;
        
        if(type(lists.friends) ~= "table") then lists.friends = {}; end
        if(type(lists.guild) ~= "table") then lists.guild = {}; end
        
        --querie guild roster
        if( _G.IsInGuild() ) then
            _G.GuildRoster();
        end
    
    libs.WhoLib = _G.AceLibrary and _G.AceLibrary('WhoLib-1.0');
    libs.Astrolabe = _G.DongleStub("Astrolabe-0.4");
    
    isInitialized = true;
    
    RegisterPrematureSkins();
    
    --enableModules
    local moduleName, tData;
    for moduleName, tData in pairs(modules) do
        modules[moduleName].db = db;
        if(modules[moduleName].canDisable ~= false) then
            local modDB = db.modules[moduleName];
            if(modDB) then
                if(modDB.enabled == nil) then
                    modDB.enabled = modules[moduleName].enableByDefault;
                end
                EnableModule(moduleName, modDB.enabled);
            else
                if(modules[moduleName].enableByDefault) then
                    EnableModule(moduleName, true);
                end
            end
        end
    end
    -- notify all modules of current state.
    CallModuleFunction("OnStateChange", WIM.curState);
    
    dPrint("WIM initialized...");
end

-- called when WIM is enabled.
-- WIM will not be enabled until WIM is initialized event is fired.
local function onEnable()
    db.enabled = true;
    
    local tEvent;
    for tEvent, _ in pairs(Events) do
        workerFrame:RegisterEvent(tEvent);
    end
    
    for _, module in pairs(modules) do
        if(type(module.OnEnableWIM) == "function") then
            module:OnEnableWIM();
        end
    end
    DisplayTutorial(L["WIM (WoW Instant Messenger)"], L["WIM is currently running. To access WIM's wide array of options type:"].." |cff69ccf0/wim|r");
    dPrint("WIM is now enabled.");
end

-- called when WIM is disabled.
local function onDisable()
    db.enabled = false;
    
    local tEvent;
    for tEvent, _ in pairs(Events) do
        workerFrame:UnregisterEvent(tEvent);
    end
    
    for _, module in pairs(modules) do
        if(type(module.OnDisableWIM) == "function") then
            module:OnDisableWIM();
        end
    end
    
    dPrint("WIM is now disabled.");
end


function SetEnabled(enabled)
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
    if( db and db.enabled ) then
        workerFrame:RegisterEvent(event);
    end
end

-- create a new WIM module. Will return module object.
function CreateModule(moduleName, enableByDefault)
    if(type(moduleName) == "string") then
        modules[moduleName] = {
            title = moduleName,
            enabled = false,
            enableByDefault = enableByDefault or false,
            canDisable = true,
            resources = {
                lists = lists,
                windows = windows,
                env = env,
                constants = constants,
                libs = libs,
            },
            db = db,
            db_defaults = db_defaults,
            RegisterEvent = function(self, event) RegisterEvent(event); end,
            Enable = function() EnableModule(moduleName, true) end,
            Disable = function() EnableModule(moduleName, false) end,
            dPrint = function(self, t) dPrint(t); end,
            hasWidget = false,
            RegisterWidget = function(widgetName, createFunction) RegisterWidget(widgetName, createFunction, moduleName); end
        }
        return modules[moduleName];
    else
        return nil;
    end
end

function EnableModule(moduleName, enabled)
    if(enabled == nil) then enabled = false; end
    local module = modules[moduleName];
    if(module) then
        if(module.canDisable == false and enabled == false) then
            dPrint("Module '"..moduleName.."' can not be disabled!");
            return;
        end
        if(enabled) then
            module.enabled = enabled;
            if(enabled and type(module.OnEnable) == "function") then
                module:OnEnable();
            elseif(not enabled and type(module.OnDisable) == "function") then
                module:OnDisable();
            end
            dPrint("Module '"..moduleName.."' Enabled");
        else
            if(module.hasWidget) then
                dPrint("Module '"..moduleName.."' will be disabled after restart.");
            else
                module.enabled = enabled;
                if(enabled and type(module.OnEnable) == "function") then
                    module:OnEnable();
                elseif(not enabled and type(module.OnDisable) == "function") then
                    module:OnDisable();
                end
                dPrint("Module '"..moduleName.."' Disabled");
            end
        end
        if(db) then
            db.modules[moduleName] = WIM.db.modules[moduleName] or {};
            db.modules[moduleName].enabled = enabled;
        end
    end
end

function CallModuleFunction(funName, ...)
    -- notify all enabled modules.
    local module, tData, fun;
    for module, tData in pairs(WIM.modules) do
        fun = tData[funName];
        if(type(fun) == "function" and tData.enabled) then
            fun(tData, ...);
        end
    end
end
--------------------------------------
--          Event Handlers          --
--------------------------------------

local function honorChatFrameEventFilter(event, msg)
    local chatFilters = _G.ChatFrame_GetMessageEventFilters(event);
    if chatFilters then 
	local filter, newmsg = false;
        for _, filterFunc in pairs(chatFilters) do
            filter, newmsg = filterFunc(msg);
            if filter then 
		return true; 
	    end 
	end 
    end 
    return false;
end


-- This is WIM's core event controler.
function WIM:EventHandler(event, ...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
    -- before we do any filtering, make sure that we are not speaking to a GM.
    -- no matter what, we want to see these.
    if(not (event == "CHAT_MSG_WHISPER" and agr6 ~= "GM")) then
        -- first we will filter out
        if(honorChatFrameEventFilter(event, arg1 or "")) then
            -- ChatFrame's event filters said to block this message.
            return;
        end
        -- other filtering will take place in individual event handlers within modules.
    end

    -- Core WIM Event Handlers.
    dPrint("Event '"..event.."' received.");
    
    local fun = WIM[event];
    if(type(fun) == "function") then
        dPrint("  +-- WIM:"..event);
        fun(WIM, ...);
    end
    
    -- Module Event Handlers
    local module, tData;
    for module, tData in pairs(modules) do
        fun = tData[event];
        if(type(fun) == "function" and tData.enabled) then
            dPrint("  +-- "..module..":"..event);
            fun(modules[module], ...);
        end
    end
end

function WIM:VARIABLES_LOADED()
    _G.WIM3_Data = _G.WIM3_Data or {};
    db = _G.WIM3_Data;
    _G.WIM3_Cache = _G.WIM3_Cache or {};
    env.cache = _G.WIM3_Cache;
    
    -- load some environment data.
    env.realm = _G.GetCVar("realmName");
    env.character = _G.UnitName("player");
    
    
    -- inherrit any new default options which wheren't shown in previous releases.
    inherritTable(db_defaults, db);
    lists.gm = {};
    
    -- load previous state into memory
    curState = db.lastState;
    
    initialize();
    SetEnabled(db.enabled);
end

function WIM:FRIENDLIST_UPDATE()
    env.cache[env.realm][env.character].friendList = {};
	for i=1, _G.GetNumFriends() do 
		local name, junk = _G.GetFriendInfo(i);
		if(name) then
			env.cache[env.realm][env.character].friendList[name] = "1"; --[set place holder for quick lookup
		end
	end
    lists.friends = env.cache[env.realm][env.character].friendList;
    dPrint("Friends list updated...");
end

function WIM:GUILD_ROSTER_UPDATE()
	env.cache[env.realm][env.character].guildList = {};
	if(_G.IsInGuild()) then
		for i=1, _G.GetNumGuildMembers(true) do 
			local name, junk = _G.GetGuildRosterInfo(i);
			if(name) then
				env.cache[env.realm][env.character].guildList[name] = "1"; --[set place holder for quick lookup
			end
		end
	end
	lists.guild = env.cache[env.realm][env.character].guildList;
        dPrint("Guild list updated...");
end

function IsGM(name)
    if(name == nil or name == "") then
		return false;
	end
	if(string.len(name) < 4) then return false; end
	if(string.sub(name, 1, 4) == "<GM>") then
		local tmp = string.gsub(name, "<GM> ", "");
		lists.gm[tmp] = 1;
		return true;
	else
		if(lists.gm[user]) then
			return true;
		else
			return false;
		end
	end
end


