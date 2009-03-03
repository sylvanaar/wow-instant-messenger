--[[
Name: LibChatHandler-1.0
Revision: $Revision: 1 $
Author: Pazza <Bronzebeard> (johnlangone@gmail.com)
Website: http://www.wimaddon.com
Description: Event Model Control View (MCV) for handling chat events.
License: LGPL v2.1
]]

local MAJOR, MINOR = "LibChatHandler-1.0", tonumber(("$Revision: 1 $"):match("(%d+)"));
local lib = LibStub:NewLibrary(MAJOR, MINOR);

if not lib then return; end -- newer version is already loaded

-- locals are always faster than globals
local tbl_rm = table.remove;
local tbl_ins = table.insert;
local type = type;
local pairs = pairs;
local regd4Event = GetFramesRegisteredForEvent;
local str_find = string.find;

local eventHandler = CreateFrame("Frame", "LibChatHander_EventHandler");

local DelegatedEvents = {}; -- objects which handle events

--------------------------------------
--          table recycling         --
--------------------------------------
local tablePool =   {{}, -- [1] in use
                    {}}; -- [2] available

-- get index of table from in use pool
local function getTableIndex(tbl)
    for i=1, #tablePool[1] do
        if(tablePool[1][i] == tbl) then
            return i;
        end
    end
end

local function pack(tbl, ...)
    for i=1, select("#", ...) do
        tbl[i] = select(i, ...);
    end
end

-- get an available or new table
local function newTable(...)
    if(#tablePool[2] > 0) then
        local tbl = tbl_rm(tablePool[2], 1);
        tbl_ins(tablePool[1], tbl);
        pack(tbl, ...);
        return tbl;
    else
        local tbl = {};
        tbl_ins(tablePool[1], tbl);
        pack(tbl, ...);
        return tbl;
    end
end

local function destroyTable(tbl)
    if(tbl) then
        for k, v in pairs(tbl) do
            if(type(v) == "table" and not v.GetParent) then
                destroyTable(v);
            end
            tbl[k] = nil;
        end
        -- whether or not the table was created here,
        -- save it for future use.
        local index = getTableIndex(tbl);
        if(index) then
            tbl_rm(tablePool[1], index);
        end
        tbl_ins(tablePool[2], tbl);
    end
end

local function tbl_indexOf(tbl, obj)
    if(type(tbl) == "table") then
        for i=1, #tbl do
            if(tbl[i] == obj) then
                return i;
            end
        end
    end
    return nil;
end

--------------------------------------
--          Event Object Object       --
--------------------------------------

-- The following functions provide actions for the chat events.
local function Suspend(self)
    self.suspended = self.suspended + 1;
end

local function Release(self, releasedBy)
    self.suspended = self.suspended > 0 and self.suspended - 1 or 0;
    if(self.suspended == 0) then
        lib:popEvents();
    end
end

local function Block(self)
    self.flag_block = true;
end

local function BlockFromChatFrame(self)
    self.flag_blocked_from_chatFrame = true;
end

local function Allow(self)
    -- do nothing to event
end

-- provide some get methods for args & events
local function getArgs(self)
    -- function returns 15 args incase blizzard ever decides to add more.
    return self.arg[1], self.arg[2], self.arg[3], self.arg[4], self.arg[5],
        self.arg[6], self.arg[7], self.arg[8], self.arg[9], self.arg[10],
        self.arg[11], self.arg[12], self.arg[13], self.arg[14]; 
end

local function getEvent(self)
    return self.event;
end

-- instantiate new chat event object
local function newChatEvent(event, ...)
    local c = newTable();
    c.event = event;
    c.arg = newTable(...);
    c.frames = newTable(regd4Event(event));
    c.flag_block = false;
    c.flag_blocked_from_chatFrame = false;
    c.suspended = 0;
    --event actions
    c.Suspend = Suspend;
    c.Release = Release;
    c.Block = Block;
    c.BlockFromChatFrame = BlockFromChatFrame;
    c.Allow = Allow;
    --event data
    c.getArgs = getArgs;
    c.getEvent = getEvent;
    return c;
end



--------------------------------------
--          Event Handling          --
--------------------------------------
local ChatEvents = {};

local ChatFrame_MessageEventHandler_orig = ChatFrame_MessageEventHandler;

local function isChatEvent(event)
    if(type(event) == "string" and str_find(event, "^CHAT_")) then
        return true;
    else
        return false;
    end
end

local function popEvents()
    for i=#ChatEvents, 1, -1 do
        local e = ChatEvents[i];
        if(e.suspended == 0) then
            if(not e.flag_block) then
                tbl_rm(ChatEvents, i);
                -- first return to registered objects
                local delegates = DelegatedEvents[e:getEvent()];
                if(delegates) then
                    -- for each delegate handling the event
                    for j=1, #delegates do
                        local handler = delegates[j][e:getEvent()];
                        if(handler) then
                            handler(delegates[j], e:getArgs());
                        end
                    end
                end
                -- next return to chat frame... only if asked to...
                if(not e.flag_blocked_from_chatFrame) then
                    for j=1,#e.frames do
                        --send ChatFrame* windows only
                        local f = e.frames[j];
                        local fName = f and f.GetName and f:GetName();
                        if(fName and str_find(fName, "^ChatFrame%d+")) then
                            ChatFrame_MessageEventHandler_orig(e.frames[j], e:getEvent(), e:getArgs());
                        end
                    end
                end
            end
            -- destroy event
            destroyTable(e);
        end
    end
end

-- eventHandler OnEvent handler
local function eventHandler_OnEvent(self, event, ...)
    if(str_find(event, "^CHAT_")) then
        local e = newChatEvent(event, ...);
        local delegates = DelegatedEvents[event];
        tbl_ins(ChatEvents, 1, e);
        for i=1, #delegates do
            local delegate = delegates[i][event.."_CONTROLLER"];
            if(delegate) then
                delegate(delegates[i], e, ...);
            end
        end
        e.flag_sent_to_delegates = true;
        popEvents();
    end
end
eventHandler:SetScript("OnEvent", eventHandler_OnEvent);

-- Hook ChatFrame_MessageHandler. We want our delegates to see the event first.
_G.ChatFrame_MessageEventHandler = function(self, event, ...)
    -- This lib only handles CHAT_* events.
    if(event and str_find(event, "^CHAT_") and DelegatedEvents[event]) then
        -- chat events we want to block for now.
    else
        -- non chat event received, allow to pass
        ChatFrame_MessageEventHandler_orig(self, event, ...);
    end
end


--------------------------------------
--    local lib declarations        --
--------------------------------------

local function RegisterChatEvent(self, chatEvent, priority)
    -- only register if chat event
    if(isChatEvent(chatEvent)) then
        -- register delegate and event
        if(DelegatedEvents[chatEvent]) then
            -- don't register the event more than once
            if(not tbl_indexOf(DelegatedEvents[chatEvent], self)) then
                if(priority) then
                    tbl_ins(DelegatedEvents[chatEvent], 1, self);
                else
                    tbl_ins(DelegatedEvents[chatEvent], self);
                end
            end
        else
            DelegatedEvents[chatEvent] = newTable(self);
        end
        eventHandler:RegisterEvent(chatEvent);
    end
end

local function UnregisterChatEvent(self, chatEvent)
    if(isChatEvent(chatEvent) and DelegatedEvents[chatEvent]) then
        local index = tbl_indexOf(DelegatedEvents[chatEvent], self);
        if(index) then
            tbl_rm(DelegatedEvents[chatEvent], index);
            if(#DelegatedEvents[chatEvent] == 0) then
                eventHandler:UnregisterEvent(chatEvent);
                local tbl = DelegatedEvents[chatEvent];
                DelegatedEvents[chatEvent] = nil;
                destroyTable(tbl);
            end
        end
    end
end

local function prepDelegate(delegate)
    delegate.RegisterChatEvent = RegisterChatEvent;
    delegate.UnregisterChatEvent = UnregisterChatEvent;
end


--------------------------------------
--          Lib API                 --
--------------------------------------

-- debugging information
function lib:ShowStats()
    local cf = DEFAULT_CHAT_FRAME;
    cf:AddMessage("Tables in use: ".. #tablePool[1]);
    cf:AddMessage("Tables available: ".. #tablePool[2]);
    cf:AddMessage("Pending events in queue: "..#ChatEvents);
    cf:AddMessage("Delegated Events:");
    for event, tbl in pairs(DelegatedEvents) do
        cf:AddMessage("+-- "..event.." ("..#tbl..")");
    end
end


-- available lib API
function lib:newDelegate()
    local delegate = newTable();
    prepDelegate(delegate);
    
    return delegate;
end

function lib:embedLibrary(tbl)
    -- tbl must be a table, if not, do nothing
    if(type(tbl) ~= "table") then
        return;
    end
    -- prep the delegate
    prepDelegate(tbl);
end

-- public wrapper needed because of order of declarations.
-- (To keep code cleaner)
function lib:popEvents()
    popEvents();
end


