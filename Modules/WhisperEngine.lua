-- File: WhisperEngine.lua
-- Author: John Langone (Pazza - Bronzebeard)
-- Description: This module handles whisper behaviors as well as their respective window actions.

--[[
    Extends Modules by adding:
        Module:OnEvent_Whisper(eventItem)
        Module:OnEvent_WhisperInform(eventItem)
        Module:PostEvent_Whisper(args[...])
        Module:PostEvent_WhisperInform(args[...])
]]


-- imports
local WIM = WIM;
local _G = _G;
local CreateFrame = CreateFrame;
local hooksecurefunc = hooksecurefunc;
local table = table;
local pairs = pairs;
local strupper = strupper;
local gsub = gsub;
local strlen = strlen;
local strsub = strsub;
local string = string;
local IsShiftKeyDown = IsShiftKeyDown;
local select = select;
local unpack = unpack;

-- set name space
setfenv(1, WIM);

-- create WIM Module
local WhisperEngine = CreateModule("WhisperEngine");

-- declare default settings for whispers.
-- if new global env wasn't set to WIM's namespace, then your module would call as follows:
--      WhisperEngine.db_defaults... or WIM.db_defaults...
db_defaults.whispers = {
    pop_rules = {
        --pop-up rule sets based off of your location
        resting = {
            onSend = true,
            onReceive = true,
            onNew = true,
            supress = true,
        },
        combat = {
            onSend = false,
            onReceive = false,
            onNew = false,
            supress = false,
        },
        pvp = {
            onSend = true,
            onReceive = true,
            onNew = true,
            supress = true,
        },
        arena = {
            onSend = false,
            onReceive = false,
            onNew = false,
            supress = false,
        },
        party = {
            onSend = true,
            onReceive = true,
            onNew = true,
            supress = true,
        },
        raid = {
            onSend = true,
            onReceive = true,
            onNew = true,
            supress = true,
        },
        other = {
            onSend = true,
            onReceive = true,
            onNew = true,
            supress = true,
        },
        alwaysOther = true,
        intercept = true,
    },
    playSound = true,
}

db_defaults.displayColors.wispIn = {
	r=0.5607843137254902, 
	g=0.03137254901960784, 
	b=0.7607843137254902
    }
db_defaults.displayColors.wispOut = {
        r=1, 
	g=0.07843137254901961, 
	b=0.9882352941176471
    }

-- register events needed for Whisper handling. (Note WIM handles these events for modules declared within.)
WhisperEngine:RegisterEvent("CHAT_MSG_WHISPER");
WhisperEngine:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
WhisperEngine:RegisterEvent("CHAT_MSG_AFK");
WhisperEngine:RegisterEvent("CHAT_MSG_DND");
WhisperEngine:RegisterEvent("CHAT_MSG_SYSTEM");

local Windows = windows.active.whisper;

local WhisperQueue_Bowl = {}; -- used to recycle tables for queue
local WhisperQueue = {}; -- active event queue
local WhisperQueue_Index = {}; -- a quick reference to an active index

local CF_MessageEventHandler_orig; -- used for a hook of the chat frame. Messaage filter handlers aren't sufficient.

local addToTableUnique = addToTableUnique;
local removeFromTable = removeFromTable;

function WhisperEngine:OnEnableWIM()
    -- this exists for documenation purposes and is not used in this module.
end

function WhisperEngine:OnDisableWIM()
    -- this exists for documenation purposes and is not used in this module.
end

local function getWhisperWindowByUser(user)
    user = FormatUserName(user);
    if(not user or user == "") then
        -- if invalid user, then return nil;
        return nil;
    end
    local obj = Windows[user];
    if(obj and obj.type == "whisper") then
        -- if the whisper window exists, return the object
        return obj;
    else
        -- otherwise, create a new one.
        Windows[user] = CreateWhisperWindow(user);
        return Windows[user];
    end
end

local function windowDestroyed(self)
    if(IsShiftKeyDown() or self.forceShift) then
        local user = self:GetParent().theUser;
        Windows[user] = nil;
    end
end

RegisterWidgetTrigger("close", "whisper", "OnClick", windowDestroyed);

RegisterWidgetTrigger("msg_box", "whisper", "OnEnterPressed", function(self)
        local obj = self:GetParent();
        _G.SendChatMessage(self:GetText(), "WHISPER", nil, obj.theUser);
        self:SetText("");
    end);

local function CHAT_MSG_WHISPER(...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;
    local color = WIM.db.displayColors.wispIn; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_WHISPER", ...);
    win:Pop("in");

    if(db.whispers.pop_rules[WIM.curState].supress) then
        _G.ChatEdit_SetLastTellTarget(arg2);
    end
    CallModuleFunction("PostEvent_Whisper", ...);
end

local function CHAT_MSG_WHISPER_INFORM(...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;
    local color = db.displayColors.wispOut; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_WHISPER_INFORM", ...);
    win:Pop("out");
    if(db.whispers.pop_rules[curState].supress) then
        _G.ChatEdit_SetLastToldTarget(arg2);
    end
    CallModuleFunction("PostEvent_WhisperInform", ...);
end

local function getNewEventTable(msgID)
    if(msgID) then
        if(WhisperQueue_Index[msgID]) then
            return WhisperQueue_Index[msgID];
        end
    end
    local i;
    for i=1, #WhisperQueue_Bowl do
        if(WhisperQueue_Bowl[i].argCount == 0) then
            if(msgID) then
                WhisperQueue_Index[msgID] = WhisperQueue_Bowl[i];
            end
            return WhisperQueue_Bowl[i];
        end
    end
    table.insert(WhisperQueue_Bowl, {
        arg = {},
        argCount = 0,
        flags = {
            suspend = false,
            block = false,
            ignore = false,
            supress = false,
        },
        msgID = msgID or 0,
        ChatFrames = {}
    });
    local eventItem = WhisperQueue_Bowl[#WhisperQueue_Bowl];
    eventItem.Suspend = function(self)
                            if(self.arg[6] ~= "GM") then -- not allowed when talking to a GM
                                self.flags.suspend = true;
                            end
                        end
    eventItem.Release = function(self)
                            if(self.arg[6] ~= "GM") then -- not allowed when talking to a GM
                                if(self.flags.suspend) then
                                    self.flags.suspend = false;
                                    popEvents();
                                end
                            end
                        end
    eventItem.Block = function(self)
                            if(self.arg[6] ~= "GM") then -- not allowed when talking to a GM
                                self.flags.block = true;
                                if(self.flags.suspend) then
                                    self.flags.supress = true;
                                    self.flags.suspend = false;
                                    popEvents();
                                end
                            end
                        end
    eventItem.Ignore = function(self)
                            if(self.arg[6] ~= "GM") then -- not allowed when talking to a GM
                                self.flags.ignore = true;
                                if(self.flags.suspend) then
                                    self.flags.supress = false;
                                    self.flags.suspend = false;
                                    popEvents();
                                end
                            end
                        end
    eventItem.SetSupress = function(self, supress)
                                supress = supress or false;
                                self.flags.supress = supress;
                        end

    WhisperQueue_Index[msgID or arg1] = eventItem;
    return eventItem;
end

local function removeEventTable(index)
    local i, eventItem = 0, WhisperQueue[index];
    WhisperQueue_Index[eventItem.msgID] = nil;
    for i=1, #eventItem.arg do
        table.remove(eventItem.arg, 1);
    end
    eventItem.flags.suspend = false;
    eventItem.flags.block = false;
    eventItem.flags.ignore = false;
    eventItem.flags.supress = false;
    eventItem.flags.passedToModules = nil;
    eventItem.msgID = 0;
    eventItem.argCount = 0;
    -- remove registered chat frame objects.
    for i=1, #eventItem.ChatFrames do
        table.remove(eventItem.ChatFrames, 1);
    end
    table.remove(WhisperQueue, index);
end

local function popEvents()
    local i = 1;
    while(#WhisperQueue > 0 and i <= #WhisperQueue) do
        --WIM:dPrint("Processing "..i.." of "..table.getn(WhisperQueue));
        local eventItem = WhisperQueue[i];
        if(not eventItem.flags.suspend) then
            if(not eventItem.flags.block) then
                if(not eventItem.flags.ignore) then
                    if(eventItem.event == "CHAT_MSG_WHISPER") then
                        CHAT_MSG_WHISPER(unpack(eventItem.arg, 1, eventItem.argCount));
                    else
                        CHAT_MSG_WHISPER_INFORM(unpack(eventItem.arg, 1, eventItem.argCount));
                    end
                end
                if(not eventItem.flags.supress) then
                    -- temproary hack for compatibility with TBC & WOTK -- REMOVE UPON RELEASE OF WOTK
                    if(WIM.isWOTLK) then
                            local j;
                            for j=1, #eventItem.ChatFrames do
                                CF_MessageEventHandler_orig(eventItem.ChatFrames[j], eventItem.event, unpack(eventItem.arg, 1, eventItem.argCount));
                            end
                    else
                            -- TBC
                            local tthis, targ1, targ2, targ3, targ4, targ5, targ6, targ7, targ8, targ9, targ10, targ11 = this, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11;
                            for j=1, #eventItem.ChatFrames do
                                this, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = eventItem.ChatFrames[j], unpack(eventItem.arg, 1, eventItem.argCount);
                                CF_MessageEventHandler_orig(eventItem.event);
                            end
                            this, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = tthis, targ1, targ2, targ3, targ4, targ5, targ6, targ7, targ8, targ9, targ10, targ11;
                    end
                end
            end
            removeEventTable(i);
            i = 1;
        else
            i = i+1;
        end
    end
end

-- this function returns the EventItem so it can have be additionally modified.
local function pushEvent(event, ...)
    local eventItem = getNewEventTable(select(11, ...));
    if(eventItem.flags.passedToModules) then
        --event already loaded, return to creator.
        return eventItem;
    end
    eventItem.event = event;
    local i, argCount = 0, select("#", ...);
    eventItem.argCount = argCount;
    for i=1, argCount do
        table.insert(eventItem.arg, select(i, ...) or nil);
    end
    addToTableUnique(WhisperQueue, eventItem);
    -- notify all modules.
    if(eventItem.argCount > 0) then
        if(eventItem.event == "CHAT_MSG_WHISPER") then
            CallModuleFunction("OnEvent_Whisper", eventItem);
        else
            CallModuleFunction("OnEvent_WhisperInform", eventItem);
        end
    end
    eventItem.flags.passedToModules = true;
    return eventItem;
end


local function bumpWhisperEventToEnd()
    --WIM:dPrint("WhisperEngine: Moving WIM to the end of the event chain.");
    _G.WIM_workerFrame:UnregisterEvent("CHAT_MSG_WHISPER_INFORM");
    _G.WIM_workerFrame:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
    _G.WIM_workerFrame:UnregisterEvent("CHAT_MSG_WHISPER");
    _G.WIM_workerFrame:RegisterEvent("CHAT_MSG_WHISPER");
end

--------------------------------------
--          Event Handlers          --
--------------------------------------

function WhisperEngine:OnEvent_Whisper(eventItem)
    -- execute appropriate supression rules
    eventItem:SetSupress(WIM.db.whispers.pop_rules[WIM.curState].supress);
end

function WhisperEngine:OnEvent_WhisperInform(eventItem)
    -- execute appropriate supression rules
    eventItem:SetSupress(WIM.db.whispers.pop_rules[WIM.curState].supress);
end

function WhisperEngine:CHAT_MSG_WHISPER(...)
    -- incoming messages will be put into a FIFO queue and have an event triggered to each
    -- module requesting to see whispers before they are received. Modules may then decide
    -- if the message should be disabled, blocked or ignored...
    local eventItem = pushEvent("CHAT_MSG_WHISPER", ...);
    popEvents();
end

function WhisperEngine:CHAT_MSG_WHISPER_INFORM(...)
    -- these incoming messages do not need to be queued in order to be filtered.
    -- All messages can be filtered immidiately from Unit(Player) information.
    local eventItem = pushEvent("CHAT_MSG_WHISPER_INFORM", ...);
    popEvents();
end

function WhisperEngine:ADDON_LOADED(...)
    bumpWhisperEventToEnd();
end

--------------------------------------
--          Whisper Related Hooks   --
--------------------------------------

local function replyTellTarget(TellNotTold)
    if(db.enabled) then
        if(db.whispers.pop_rules.intercept and db.whispers.pop_rules[curState].onSend) then
            local lastTell;
            if(TellNotTold) then
                lastTell = _G.ChatEdit_GetLastTellTarget();
            else
                lastTell = _G.ChatEdit_GetLastToldTarget();
            end
            if ( lastTell ~= "" ) then
                local win = getWhisperWindowByUser(lastTell);
                win.widgets.msg_box.setText = 1;
                win:Pop(true); -- force popup
                win.widgets.msg_box:SetFocus();
		_G.ChatEdit_OnEscapePressed(_G.ChatFrameEditBox);
            end
        end
    end
end

local function CF_extractTellTarget(editBox, msg)
    if(db.enabled) then
        -- Grab the first "word" in the string
        local target = gsub(msg, "(%s*)([^%s]+)(.*)", "%2", 1);
        if ( (strlen(target) <= 0) or (strsub(target, 1, 1) == "|") ) then
            return;
        end
	
        if(db.whispers.pop_rules.intercept and db.whispers.pop_rules[curState].onSend) then
            target = string.gsub(target, "^%l", string.upper)
	    local win = getWhisperWindowByUser(target);
            win.widgets.msg_box.setText = 1;
            win:Pop(true); -- force popup
            win.widgets.msg_box:SetFocus();
	    _G.ChatEdit_OnEscapePressed(_G.ChatFrameEditBox);
        end
    end
end

local function CF_sendTell(name) -- needed in order to UnitPopups to work with whispers.
    if(db and db.enabled) then
	if(db.whispers.pop_rules.intercept and db.whispers.pop_rules[curState].onSend) then
            -- Remove spaces from the server name for slash command parsing
            name = gsub(name, " ", "");
	    local win = getWhisperWindowByUser(name);
            win.widgets.msg_box.setText = 1;
            win:Pop(true); -- force popup
            win.widgets.msg_box:SetFocus();
	    _G.ChatEdit_OnEscapePressed(_G.ChatFrameEditBox);
	end
    end
end

local function CF_HandleChatType(editBox, msg, command, send)
	for index, value in pairs(_G.ChatTypeInfo) do
		local i = 1;
		local cmdString = _G["SLASH_"..index..i];
		while ( cmdString ) do
			cmdString = strupper(cmdString);
			if ( cmdString == command ) then
				-- index is the entered command
				if(index == "REPLY") then replyTellTarget(true); end
				return;
			end
			i = i + 1;
			cmdString = _G["SLASH_"..index..i];
		end
	end
end

---- THIS SECTION IS A HACK TO WORK WITH BOTH TBC AND WOTLK - UPDATE FOR RELEASE OF WOTK
CF_MessageEventHandler_orig = _G.ChatFrame_MessageEventHandler;
local function CF_MessageEventHandler(self, event, ...)
    if(db and db.enabled and (event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM")) then
        local eventItem = WhisperQueue[select(11, ...)];
        if(eventItem) then
            addToTableUnique(eventItem.ChatFrames, self);
        else
            eventItem = pushEvent(event, ...);
            addToTableUnique(eventItem.ChatFrames, self);
        end
    else
        CF_MessageEventHandler_orig(self, event, ...);
    end
end
local function CF_MessageEventHandlerTBC(event)
    if(db and db.enabled and (event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM")) then
        local eventItem = WhisperQueue[arg11];
        if(eventItem) then
            addToTableUnique(eventItem.ChatFrames, this);
        else
            eventItem = pushEvent(event, _G.arg1, _G.arg2, _G.arg3, _G.arg4, _G.arg5, _G.arg6, _G.arg7, _G.arg8, _G.arg9, _G.arg10, _G.arg11);
            addToTableUnique(eventItem.ChatFrames, this);
        end
    else
        CF_MessageEventHandler_orig(event);
    end
end
if(isWOTLK) then
    _G.ChatFrame_MessageEventHandler = CF_MessageEventHandler;
else
    _G.ChatFrame_MessageEventHandler = CF_MessageEventHandlerTBC;
end
--------------------------------------------------------


-- the following hook is needed in order to intercept Send Whisper from UnitPopup Menus
hooksecurefunc("ChatFrame_SendTell", CF_sendTell);

-- the following hook is needed in order to intercept /w, /whisper
hooksecurefunc("ChatEdit_ExtractTellTarget", CF_extractTellTarget);

-- the following hook is needed in order to intercept /r
hooksecurefunc("ChatEdit_HandleChatType", CF_HandleChatType);

--Hook ChatFrame_ReplyTell & ChatFrame_ReplyTell2
hooksecurefunc("ChatFrame_ReplyTell", function() replyTellTarget(true) end);
hooksecurefunc("ChatFrame_ReplyTell2", function() replyTellTarget(false) end);

--Hook in order to make sure that WIM receives it's events after the default chat frames.
hooksecurefunc("ChatFrame_AddMessageGroup", function() bumpWhisperEventToEnd(); end);
hooksecurefunc("ChatFrame_RemoveMessageGroup", function() bumpWhisperEventToEnd(); end);



-- This is a core module and must always be loaded...
WhisperEngine.canDisable = false;
WhisperEngine:Enable();