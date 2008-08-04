-- File: WhisperEngine.lua
-- Author: John Langone (Pazza - Bronzebeard)
-- Description: This module handles whisper behaviors as well as their respective window actions.

-- create WIM Module
WhisperEngine = WIM:CreateModule("WhisperEngine");

-- declare default settings for whispers.
WhisperEngine.db_defaults.whispers = {
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
    win:Pop("in");
    if(WIM.db.whispers.playSound) then
        PlaySoundFile("Interface\\AddOns\\"..WIM.addonTocName.."\\Sounds\\wisp.wav");
    end
end

function WhisperEngine:CHAT_MSG_WHISPER_INFORM()
    local color = WIM.db.displayColors.wispOut; -- color contains .r, .g & .b
    local win = getWhisperWindowByUser(arg2);
    win:AddUserMessage(UnitName("player"), arg1, color.r, color.g, color.b);
    win:Pop("out");
end




--------------------------------------
--          Whisper Related Hooks   --
--------------------------------------

local function replyTellTarget(TellNotTold)
    if(WIM.db.enabled) then
        if(WIM.db.whispers.pop_rules.intercept and WIM.db.whispers.pop_rules[WIM.curState].onSend) then
            local lastTell;
            if(TellNotTold) then
                lastTell = ChatEdit_GetLastTellTarget();
            else
                lastTell = ChatEdit_GetLastToldTarget();
            end
            if ( lastTell ~= "" ) then
                local win = getWhisperWindowByUser(lastTell);
                win.widgets.msg_box.setText = 1;
                win:Pop(true); -- force popup
                win.widgets.msg_box:SetFocus();
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
            end
        end
    end
end

local function CF_extractTellTarget(editBox, msg)
    if(WIM.db.enabled) then
        -- Grab the first "word" in the string
        local target = gsub(msg, "(%s*)([^%s]+)(.*)", "%2", 1);
        if ( (strlen(target) <= 0) or (strsub(target, 1, 1) == "|") ) then
            return;
        end
	
        if(WIM.db.whispers.pop_rules.intercept and WIM.db.whispers.pop_rules[WIM.curState].onSend) then
            target = string.gsub(target, "^%l", string.upper)
	    local win = getWhisperWindowByUser(target);
            win.widgets.msg_box.setText = 1;
            win:Pop(true); -- force popup
            win.widgets.msg_box:SetFocus();
	    ChatEdit_OnEscapePressed(ChatFrameEditBox);
        end
    end
end

local function CF_sendTell(name) -- needed in order to UnitPopups to work with whispers.
    if(WIM.db.enabled) then
	if(WIM.db.whispers.pop_rules.intercept and WIM.db.whispers.pop_rules[WIM.curState].onSend) then
            -- Remove spaces from the server name for slash command parsing
            name = gsub(name, " ", "");
	    local win = getWhisperWindowByUser(name);
            win.widgets.msg_box.setText = 1;
            win:Pop(true); -- force popup
            win.widgets.msg_box:SetFocus();
	    ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end
    end
end

local function CF_HandleChatType(editBox, msg, command, send)
	for index, value in pairs(ChatTypeInfo) do
		local i = 1;
		local cmdString = getglobal("SLASH_"..index..i);
		while ( cmdString ) do
			cmdString = strupper(cmdString);
			if ( cmdString == command ) then
				-- index is the entered command
				if(index == "REPLY") then replyTellTarget(true); end
				return;
			end
			i = i + 1;
			cmdString = getglobal("SLASH_"..index..i);
		end
	end
end



-- the following hook is needed in order to intercept Send Whisper from UnitPopup Menus
hooksecurefunc("ChatFrame_SendTell", CF_sendTell);

-- the following hook is needed in order to intercept /w, /whisper
hooksecurefunc("ChatEdit_ExtractTellTarget", CF_extractTellTarget);

-- the following hook is needed in order to intercept /r
hooksecurefunc("ChatEdit_HandleChatType", CF_HandleChatType);

--Hook ChatFrame_ReplyTell & ChatFrame_ReplyTell2
hooksecurefunc("ChatFrame_ReplyTell", function() replyTellTarget(true) end);
hooksecurefunc("ChatFrame_ReplyTell2", function() replyTellTarget(false) end);






-- This is a core module and must always be loaded...
WhisperEngine.canDisable = false;
WhisperEngine:Enable();