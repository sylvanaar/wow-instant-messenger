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
    playSound = true,
}

WhisperEngine.db_defaults.displayColors.wispIn = {
	r=0.5607843137254902, 
	g=0.03137254901960784, 
	b=0.7607843137254902
    }
WhisperEngine.db_defaults.displayColors.wispOut = {
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
--WhisperEngine:RegisterEvent("CHAT_MSG_ADDON");

local Windows = WIM.windows.active.whisper;


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

local function windowDestroyed()
    if(IsShiftKeyDown()) then
        local user = this:GetParent().theUser;
        Windows[user] = nil;
    end
end

WIM:RegisterWidgetTrigger("close", "whisper", "OnClick", windowDestroyed);

WIM:RegisterWidgetTrigger("msg_box", "whisper", "OnEnterPressed", function()
        local obj = this:GetParent();
        SendChatMessage(this:GetText(), "WHISPER", nil, obj.theUser);
        this:SetText("");
    end);

--------------------------------------
--          Event Handlers          --
--------------------------------------

function WhisperEngine:CHAT_MSG_WHISPER()
    local color = WIM.db.displayColors.wispIn; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddUserMessage(arg2, arg1, color.r, color.g, color.b);
    win:Pop();
    if(WIM.db.whispers.playSound) then
        PlaySoundFile("Interface\\AddOns\\"..WIM.addonTocName.."\\Sounds\\wisp.wav");
    end
end

function WhisperEngine:CHAT_MSG_WHISPER_INFORM()
    local color = WIM.db.displayColors.wispOut; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddUserMessage(UnitName("player"), arg1, color.r, color.g, color.b);
    win:Pop();
end




--------------------------------------
--          Whisper Related Hooks   --
--------------------------------------
local function FF_SendMessage()
	if(WIM.db.enabled) then
		if(WIM.EditBoxInFocus) then
			WIM.EditBoxInFocus:SetText("");
		end
		local name = GetFriendInfo(FriendsFrame.selectedFriend);
		local win = getWhisperWindowByUser(name);
                win:Pop(true); -- force popup
                win.widgets.msg_box:SetFocus();
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end
end


--hooksecurefunc("ChatFrame_SendTell", WIM_ChatFrame_SendTell);
hooksecurefunc("FriendsFrame_SendMessage", FF_SendMessage);
--hooksecurefunc("ChatEdit_ExtractTellTarget", WIM_ChatEdit_ExtractTellTarget);
--hooksecurefunc("SendChatMessage", WIM_SendChatMessage);
--hooksecurefunc("ChatEdit_HandleChatType", WIM_ChatEdit_HandleChatType);
--Hook ChatFrame_ReplyTell & ChatFrame_ReplyTell2
--hooksecurefunc("ChatFrame_ReplyTell", WIM_ChatFrame_ReplyTell);
--hooksecurefunc("ChatFrame_ReplyTell2", WIM_ChatFrame_ReplyTell2);






-- This is a core module and must always be loaded...
WhisperEngine.canDisable = false;
WhisperEngine:Enable();