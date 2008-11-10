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
local math = math;

-- set name space
setfenv(1, WIM);

-- create WIM Module
local WhisperEngine = CreateModule("WhisperEngine");

-- declare default settings for whispers.
-- if new global env wasn't set to WIM's namespace, then your module would call as follows:
--      WhisperEngine.db_defaults... or WIM.db_defaults...
db_defaults.pop_rules.whisper = {
        --pop-up rule sets based off of your location
        resting = {
            onSend = true,
            onReceive = true,
            supress = true,
            autofocus = true,
            keepfocus = true,
        },
        combat = {
            onSend = false,
            onReceive = false,
            supress = false,
            autofocus = false,
            keepfocus = false,
        },
        pvp = {
            onSend = true,
            onReceive = true,
            supress = true,
            autofocus = false,
            keepfocus = false,
        },
        arena = {
            onSend = false,
            onReceive = false,
            supress = false,
            autofocus = false,
            keepfocus = false,
        },
        party = {
            onSend = true,
            onReceive = true,
            supress = true,
            autofocus = false,
            keepfocus = false,
        },
        raid = {
            onSend = true,
            onReceive = true,
            supress = true,
            autofocus = false,
            keepfocus = false,
        },
        other = {
            onSend = true,
            onReceive = true,
            supress = true,
            autofocus = false,
            keepfocus = false,
        },
        alwaysOther = false,
        intercept = true,
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

local alertPushed = false;

local function updateMinimapAlerts()
    local count = 0;
    for _, win in pairs(Windows) do
        if(not win:IsShown()) then
            count = count + (win.unreadCount or 0);
        end
    end
    if(count == 0 and alertPushed) then
        alertPushed = false;
        MinimapPopAlert(L["Whispers"]);
    elseif(count > 0) then
        alertPushed = true;
        local color = db.displayColors.wispIn;
        MinimapPushAlert(L["Whispers"], RGBPercentToHex(color.r, color.g, color.b), count);
        DisplayTutorial(L["Whisper Received!"], L["You received a whisper which was hidden due to your current activity. You can change how whispers behave in WIM's options by typing"].." |cff69ccf0/wim|r");
    end
end

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
        if(db.whoLookups or lists.gm[user]) then
            Windows[user]:SendWho(); -- send who request
        end
        Windows[user].online = true;
        return Windows[user];
    end
end

local function windowDestroyed(self)
    if(IsShiftKeyDown() or self.forceShift) then
        local user = self:GetParent().theUser;
        Windows[user].online = nil;
        Windows[user].msgSent = nil;
        Windows[user] = nil;
    end
end

function WhisperEngine:OnWindowDestroyed(self)
    if(self.type == "whisper") then
        local user = self.theUser;
        Windows[user] = nil;
    end
end


function WhisperEngine:OnWindowShow(win)
    updateMinimapAlerts();
end

local splitMessage, splitMessageLinks = {}, {};
local function SendSplitMessage(theMsg, to)
        -- parse out links as to not split them incorrectly.
        theMsg, results = string.gsub(theMsg, "(|H[^|]+|h[^|]+|h)", function(theLink)
                table.insert(splitMessageLinks, theLink);
                return "\001\002"..paddString(#splitMessageLinks, "0", string.len(theLink)-4).."\003\004";
        end);
        
        -- split up each word.
        SplitToTable(theMsg, "%s", splitMessage);
        
        --reconstruct message into chunks of no more than 255 characters.
        local chunk = "";
        for i=1, #splitMessage + 1 do
                if(splitMessage[i] and string.len(chunk) + string.len(splitMessage[i]) <= 254) then
                        chunk = chunk..splitMessage[i].." ";
                else
                        -- reinsert links of necessary
                        chunk = string.gsub(chunk, "\001\002%d+\003\004", function(link)
                                local index = _G.tonumber(string.match(link, "(%d+)"));
                                return splitMessageLinks[index] or link;
                        end);
                        _G.ChatThrottleLib:SendChatMessage("NORMAL", "WIM", chunk, "WHISPER", nil, to);
                        chunk = splitMessage[i];
                end
        end
        
        -- clean up
        for k, _ in pairs(splitMessage) do
                splitMessage[k] = nil;
        end
        for k, _ in pairs(splitMessageLinks) do
                splitMessageLinks[k] = nil;
        end
end


RegisterWidgetTrigger("msg_box", "whisper", "OnEnterPressed", function(self)
        local obj = self:GetParent();
        local msg = self:GetText();
        local msgCount = math.ceil(string.len(msg)/255);
        if(msgCount == 1) then
            Windows[obj.theUser].msgSent = true;
            _G.ChatThrottleLib:SendChatMessage("NORMAL", "WIM", msg, "WHISPER", nil, obj.theUser);
        elseif(msgCount > 1) then
            Windows[obj.theUser].msgSent = true;
            SendSplitMessage(msg, obj.theUser);
        end
        self:SetText("");
    end);


local function CHAT_MSG_WHISPER(...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;
    local color = WIM.db.displayColors.wispIn; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_WHISPER", ...);
    win:Pop("in");
    _G.ChatEdit_SetLastTellTarget(arg2);
    win.online = true;
    updateMinimapAlerts();
    CallModuleFunction("PostEvent_Whisper", ...);
end

local function CHAT_MSG_WHISPER_INFORM(...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...;
    local color = db.displayColors.wispOut; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_WHISPER_INFORM", ...);
    win:Pop("out");
    _G.ChatEdit_SetLastToldTarget(arg2);
    win.online = true;
    win.msgSent = false;
    CallModuleFunction("PostEvent_WhisperInform", ...);
end


local function removeEventTable(index)
    local eventItem = WhisperQueue[index];
    WhisperQueue_Index[eventItem.msgID] = nil;
    for i, _ in pairs(eventItem.arg) do
        eventItem.arg[i] = nil;
    end
    eventItem.event = nil;
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
                        local j;
                        for j=1, #eventItem.ChatFrames do
                                CF_MessageEventHandler_orig(eventItem.ChatFrames[j], eventItem.event, unpack(eventItem.arg, 1, eventItem.argCount));
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


local function getNewEventTable(msgID)
    if(msgID) then
        if(WhisperQueue_Index[msgID]) then
            return WhisperQueue_Index[msgID];
        end
    end
    local i;
    for i=1, #WhisperQueue_Bowl do
        if(WhisperQueue_Bowl[i].event == nil) then
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
            supress = false
        },
        msgID = msgID or 0,
        ChatFrames = {}
    });
    local eventItem = WhisperQueue_Bowl[#WhisperQueue_Bowl];
    eventItem.Suspend = function(self)
                            if(not self.flags.ignore and not self.flags.block) then -- not allowed when talking to a GM
                                self.flags.suspend = true;
                            end
                        end
    eventItem.Release = function(self)
                            --if(self.flags.suspend) then
                                self.flags.suspend = false;
                                popEvents();
                            --end
                        end
    eventItem.Block = function(self)
                            self.flags.block = true;
                            self.flags.ignore = false;
                            self.flags.supress = true;
                            self.flags.suspend = false;
                        end
    eventItem.Ignore = function(self)
                            if(not self.flags.block) then -- not allowed when talking to a GM
                                self.flags.ignore = true;
                                self.flags.supress = false;
                                self.flags.suspend = false;
                            end
                        end
    eventItem.SetSupress = function(self, supress)
                                if(not self.flags.ignore and not self.flags.block) then
                                    self.flags.supress = supress or false;
                                end
                            end

    WhisperQueue_Index[msgID] = eventItem;
    return eventItem;
end



-- this function returns the EventItem so it can have be additionally modified.
local function pushEvent(event, ...)
    local eventItem = getNewEventTable(select(11, ...));
    if(eventItem.flags.passedToModules) then
        --event already loaded, return to creator.
        return eventItem;
    end
    eventItem.event = event;
    local argCount = select("#", ...);
    eventItem.argCount = argCount;
    for i=1, argCount do
        table.insert(eventItem.arg, select(i, ...) or nil);
    end
    addToTableUnique(WhisperQueue, eventItem);
    -- notify all modules.
    if(eventItem.argCount > 0) then
        if(eventItem.event == "CHAT_MSG_WHISPER" and not lists.gm[select(2,...)]) then
            CallModuleFunction("OnEvent_Whisper", eventItem);
        elseif(eventItem.event == "CHAT_MSG_WHISPER_INFORM" and not lists.gm[select(2,...)]) then
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
    _G.WIM_workerFrame:UnregisterEvent("CHAT_MSG_SYSTEM");
    _G.WIM_workerFrame:RegisterEvent("CHAT_MSG_SYSTEM");
end

--------------------------------------
--          Event Handlers          --
--------------------------------------

function WhisperEngine:OnEvent_Whisper(eventItem)
    -- execute appropriate supression rules
    local curState = curState;
    curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
    eventItem:SetSupress(WIM.db.pop_rules.whisper[curState].supress);
end

function WhisperEngine:OnEvent_WhisperInform(eventItem)
    -- execute appropriate supression rules
    local curState = curState;
    curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
    eventItem:SetSupress(WIM.db.pop_rules.whisper[curState].supress);
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

function WhisperEngine:CHAT_MSG_AFK(...)
    local color = db.displayColors.wispIn; -- color contains .r, .g & .b
    local win = Windows[select(2, ...)];
    if(win) then
        win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_AFK", ...);
        win:Pop("out");
        _G.ChatEdit_SetLastTellTarget(select(2, ...));
        win.online = true;
    end
end

function WhisperEngine:CHAT_MSG_DND(...)
    local color = db.displayColors.wispIn; -- color contains .r, .g & .b
    local win = Windows[select(2, ...)];
    if(win) then
        win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_AFK", ...);
        win:Pop("out");
        _G.ChatEdit_SetLastTellTarget(select(2, ...));
        win.online = true;
    end
end

function WhisperEngine:CHAT_MSG_SYSTEM(msg)
    local user;
    -- detect player not online
    user = FormatUserName(libs.Deformat(msg, _G.ERR_CHAT_PLAYER_NOT_FOUND_S));
    if(Windows[user]) then
        if(Windows[user].online or Windows[user].msgSent) then
            Windows[user]:AddMessage(msg, db.displayColors.errorMsg.r, db.displayColors.errorMsg.g, db.displayColors.errorMsg.b);
        end
        Windows[user].online = false;
        Windows[user].msgSent = nil;
        return;
    end
    
    -- detect player has you ignored
    user = FormatUserName(libs.Deformat(msg, _G.CHAT_IGNORED));
    if(Windows[user]) then
        if(Windows[user].online) then
            Windows[user]:AddMessage(msg, db.displayColors.errorMsg.r, db.displayColors.errorMsg.g, db.displayColors.errorMsg.b);
        end
        Windows[user].online = false;
        return;
    end
    
    -- detect player has come online
    user = FormatUserName(libs.Deformat(msg, _G.ERR_FRIEND_ONLINE_SS));
    if(Windows[user]) then
        Windows[user]:AddMessage(msg, db.displayColors.sysMsg.r, db.displayColors.sysMsg.g, db.displayColors.sysMsg.b);
        Windows[user].online = true;
        return;
    end
    
        -- detect player has gone offline
    user = FormatUserName(libs.Deformat(msg, _G.ERR_FRIEND_OFFLINE_S));
    if(Windows[user]) then
        Windows[user]:AddMessage(msg, db.displayColors.sysMsg.r, db.displayColors.sysMsg.g, db.displayColors.sysMsg.b);
        Windows[user].online = false;
        return;
    end
    
end

function WhisperEngine:ADDON_LOADED(...)
    bumpWhisperEventToEnd();
end

--------------------------------------
--          Whisper Related Hooks   --
--------------------------------------

local function replyTellTarget(TellNotTold)
    if(db.enabled) then
        local curState = curState;
        curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
        if(db.pop_rules.whisper.intercept and db.pop_rules.whisper[curState].onSend) then
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
        
	local curState = curState;
        curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
        if(db.pop_rules.whisper.intercept and db.pop_rules.whisper[curState].onSend) then
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
        local curState = curState;
        curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
	if(db.pop_rules.whisper.intercept and db.pop_rules.whisper[curState].onSend) then
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

CF_MessageEventHandler_orig = _G.ChatFrame_MessageEventHandler;
local function CF_MessageEventHandler(self, event, ...)
    -- supress status messages
    if(db and db.enabled and event == "CHAT_MSG_SYSTEM") then
        local msg, win = select(1, ...);
        local curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
        -- handle no user online and chat ignored from being shown in default chat frame.
        win = Windows[FormatUserName(libs.Deformat(msg, _G.ERR_CHAT_PLAYER_NOT_FOUND_S)) or "NIL"];
        win = win or Windows[FormatUserName(libs.Deformat(msg, _G.CHAT_IGNORED)) or "NIL"];
        if(win and win.type == "whisper") then
            if(win:IsShown() and db.pop_rules.whisper[curState].supress) then
                return;
            elseif(not win.msgSent) then
                return;
            end
        end
        -- user comes/goes online/offline.
        win = Windows[FormatUserName(libs.Deformat(msg, _G.ERR_FRIEND_ONLINE_SS)) or "NIL"];
        win = win or Windows[FormatUserName(libs.Deformat(msg, _G.ERR_FRIEND_OFFLINE_S)) or "NIL"];
        if(win and win:IsShown() and db.pop_rules.whisper[curState].supress) then
            return;
        end
    end
    
    if(db and db.enabled and (event == "CHAT_MSG_AFK" or event == "CHAT_MSG_DND")) then
        local curState = db.pop_rules.whisper.alwaysOther and "other" or curState;
        if(Windows[select(2,...)] and db.pop_rules.whisper[curState].supress) then
            return;
        end
    end

    -- process event whisper events
    if(db and db.enabled and (event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_WHISPER_INFORM")) then
        local eventItem = WhisperQueue_Index[select(11, ...)];
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
_G.ChatFrame_MessageEventHandler = CF_MessageEventHandler;
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

local hookedSendChatMessage = _G.SendChatMessage;
function _G.SendChatMessage(...)
    if(select(2, ...) == "WHISPER") then
        local win = Windows[FormatUserName(select(4, ...)) or "NIL"];
        if(win) then
            win.msgSent = true;
        end
    end
    hookedSendChatMessage(...);
end

-- This is a core module and must always be loaded...
WhisperEngine.canDisable = false;
WhisperEngine:Enable();