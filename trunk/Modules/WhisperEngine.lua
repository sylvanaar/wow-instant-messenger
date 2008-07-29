-- File: WhisperEngine.lua
-- Author: John Langone (Pazza - Bronzebeard)
-- Description: This module handles whisper behaviors as well as their respective window actions.

-- create WIM Module
WhisperEngine = WIM:CreateModule("WhisperEngine");

-- declare default settings for whispers.
WhisperEngine.db_defaults.whispers = {
    pop_rules = {
        --pop-up rule sets based off of your location
        city = {
            onSend = true,
            onReceive = true,
            onNew = true,
            supress = true,
        },
        combat = {},
        pvp = {},
        arena = {},
        party = {},
        raid = {},
        other = {}
    },
}

-- register events needed for Whisper handling. (Note WIM handles these events for modules declared within.)
WhisperEngine:RegisterEvent("CHAT_MSG_WHISPER");
WhisperEngine:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
WhisperEngine:RegisterEvent("CHAT_MSG_AFK");
WhisperEngine:RegisterEvent("CHAT_MSG_DND");
WhisperEngine:RegisterEvent("CHAT_MSG_SYSTEM");
--WhisperEngine:RegisterEvent("CHAT_MSG_ADDON");

local Windows = WIM.windows.active;


function WhisperEngine:OnEnableWIM()

end

function WhisperEngine:OnDisableWIM()

end

local function getWhisperWindowByUser(user)
    user = WIM:FormatUserName(user);
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
        Windows[user] = WIM:CreateWhisperWindow(user);
        return Windows[user];
    end
end


--------------------------------------
--          Event Handlers          --
--------------------------------------

function WhisperEngine:CHAT_MSG_WHISPER()
    local color = WIM.db.displayColors.wispIn; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddUserMessage(arg2, arg1, color.r, color.g, color.b);
    win:Pop();
end

function WhisperEngine:CHAT_MSG_WHISPER_INFORM()
    local color = WIM.db.displayColors.wispOut; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddUserMessage(UnitName("player"), arg1, color.r, color.g, color.b);
    win:Pop();
end


-- This is a core module and must always be loaded...
WhisperEngine.canDisable = false;
WhisperEngine:Enable();