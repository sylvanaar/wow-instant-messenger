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
local time = time;

-- set name space
setfenv(1, WIM);

local Windows = windows.active.chat;


local function getChatWindow(ChatName, chatType)
    if(not ChatName or ChatName == "") then
        -- if invalid user, then return nil;
        return nil;
    end
    local obj = Windows[ChatName];
    if(obj and obj.type == "chat") then
        -- if the whisper window exists, return the object
        return obj;
    else
        -- otherwise, create a new one.
        Windows[ChatName] = CreateChatWindow(ChatName);
        Windows[ChatName].chatType = chatType;
        Windows[ChatName]:UpdateIcon();
        return Windows[ChatName];
    end
end


RegisterWidgetTrigger("msg_box", "chat", "OnEnterPressed", function(self)
        local obj, msg, TARGET = self:GetParent(), self:GetText();
        if(obj.chatType == "guild") then
            TARGET = "GUILD";
        elseif(obj.chatType == "officer") then
            TARGET = "OFFICER";
        elseif(obj.chatType == "party") then
            TARGET = "PARTY";
        elseif(obj.chatType == "raid") then
            TARGET = "RAID";
        else
            return;
        end
        local msgCount = math.ceil(string.len(msg)/255);
        if(msgCount == 1) then
            _G.ChatThrottleLib:SendChatMessage("NORMAL", "WIM", msg, TARGET);
        elseif(msgCount > 1) then
            --SendSplitMessage(msg, obj.theUser);
        end
        self:SetText("");
    end);



--------------------------------------
--              Guild Chat          --
--------------------------------------

-- create GuildChat Module
local Guild = CreateModule("GuildChat");

-- This Module requires LibChatHandler-1.0
_G.LibStub:GetLibrary("LibChatHandler-1.0"):Embed(Guild);

function Guild:OnEnable()
    if(not db.chatBeta) then
        return;
    end
    self:RegisterChatEvent("CHAT_MSG_GUILD");
    self:RegisterChatEvent("CHAT_MSG_GUILD_ACHIEVEMENT");
end

function Guild:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_GUILD");
    self:UnregisterChatEvent("CHAT_MSG_GUILD_ACHIEVEMENT");
end

function Guild:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "guild") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName] = nil;
    end
end

function Guild:CHAT_MSG_GUILD(msg, from, language)
    local win = getChatWindow(_G.GUILD, "guild");
    local color = _G.ChatTypeInfo["GUILD"];
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_GUILD", msg, from);
end





--------------------------------------
--            Officer Chat          --
--------------------------------------

-- create OfficerChat Module
local Officer = CreateModule("OfficerChat");

-- This Module requires LibChatHandler-1.0
_G.LibStub:GetLibrary("LibChatHandler-1.0"):Embed(Officer);

function Officer:OnEnable()
    if(not db.chatBeta) then
        return;
    end
    self:RegisterChatEvent("CHAT_MSG_OFFICER");
end

function Officer:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_OFFICER");
end

function Officer:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "officer") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName] = nil;
    end
end

function Officer:CHAT_MSG_OFFICER(msg, from, language)
    local win = getChatWindow(_G.GUILD_RANK1_DESC, "officer");
    local color = _G.ChatTypeInfo["OFFICER"];
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_OFFICER", msg, from);
end




--------------------------------------
--            Party Chat            --
--------------------------------------

-- create PartyChat Module
local Party = CreateModule("PartyChat");

-- This Module requires LibChatHandler-1.0
_G.LibStub:GetLibrary("LibChatHandler-1.0"):Embed(Party);

function Party:OnEnable()
    if(not db.chatBeta) then
        return;
    end
    self:RegisterChatEvent("CHAT_MSG_PARTY");
end

function Officer:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_PARTY");
end

function Party:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "party") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName] = nil;
    end
end

function Party:CHAT_MSG_PARTY(msg, from, language)
    local win = getChatWindow(_G.PARTY, "party");
    local color = _G.ChatTypeInfo["PARTY"];
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_PARTY", msg, from);
end



--------------------------------------
--            Raid Chat             --
--------------------------------------

-- create RaidChat Module
local Raid = CreateModule("RaidChat");

-- This Module requires LibChatHandler-1.0
_G.LibStub:GetLibrary("LibChatHandler-1.0"):Embed(Raid);

function Raid:OnEnable()
    if(not db.chatBeta) then
        return;
    end
    self:RegisterChatEvent("CHAT_MSG_RAID");
    self:RegisterChatEvent("CHAT_MSG_RAID_LEADER");
end

function Raid:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_RAID");
    self:UnregisterChatEvent("CHAT_MSG_RAID_LEADER");
end

function Raid:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "raid") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName] = nil;
    end
end

function Raid:CHAT_MSG_RAID(msg, from, language)
    local win = getChatWindow(_G.RAID, "raid");
    local color = _G.ChatTypeInfo["RAID"];
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_RAID", msg, from);
end

function Raid:CHAT_MSG_RAID_LEADER(msg, from, language)
    local win = getChatWindow(_G.RAID, "raid");
    local color = _G.ChatTypeInfo["RAID_LEADER"];
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_RAID_LEADER", msg, from);
end







-- Options
-- create ChatOptions Module
local ChatOptions = CreateModule("ChatOptions");
local function loadChatOptions()
    if(not db.chatBeta or ChatOptions.optionsLoaded) then
        return;
    end
    
    local desc = L["WIM will manage this chat type within its own message windows."];
    
    -- standard chat template
    local function createChatTemplate(chatName, moduleName)
        local f = options.CreateOptionsFrame();
        f.sub = f:CreateSection(chatName, desc);
        f.sub.nextOffSetY = -10;
        f.sub:CreateCheckButton(L["Enable"], WIM.modules[moduleName], "enabled", nil, function(self, button) EnableModule(moduleName, self:GetChecked()); end);
        f.sub.nextOffSetY = -15;
        return f;
    end
    
    local function createGuildChat()
        local f = createChatTemplate(_G.GUILD, "GuildChat");
        return f;
    end
    
    local function createOfficerChat()
        local f = createChatTemplate(_G.GUILD_RANK1_DESC, "OfficerChat");
        return f;
    end
    
    local function createPartyChat()
        local f = createChatTemplate(_G.PARTY, "PartyChat");
        return f;
    end
    
    local function createRaidChat()
        local f = createChatTemplate(_G.RAID, "RaidChat");
        return f;
    end
    
    RegisterOptionFrame(L["Chat"], _G.GUILD, createGuildChat);
    RegisterOptionFrame(L["Chat"], _G.GUILD_RANK1_DESC, createOfficerChat);
    RegisterOptionFrame(L["Chat"], _G.PARTY, createPartyChat);
    RegisterOptionFrame(L["Chat"], _G.RAID, createRaidChat);
    
    dPrint("Chat Options Initialized...");
    ChatOptions.optionsLoaded = true;
end

function ChatOptions:OnEnableWIM()
    loadChatOptions();
end
