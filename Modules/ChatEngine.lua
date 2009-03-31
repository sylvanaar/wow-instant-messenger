-- imports
local WIM = WIM;
local _G = _G;
local hooksecurefunc = hooksecurefunc;
local table = table;
local pairs = pairs;
local string = string;
local select = select;
local math = math;

-- set name space
setfenv(1, WIM);

local Windows = windows.active.chat;

db_defaults.chat = {
    world = {
        enabled = false,
    },
    custom = {
        enabled = false,
    },
    channelSettings = {
        
    }
};


local function createWidget_Chat()
    local button = _G.CreateFrame("Button");
    button.text = button:CreateFontString(nil, "BACKGROUND");
    button.text:SetFont("Fonts\\SKURRI.ttf", 16);
    button.text:SetAllPoints();
    button.text:SetText("");
    button.SetText = function(self, text)
            self.text:SetText(text);
            --adjust font size to match widget
        end
    button.SetActive = function(self, active)
            self.active = active;
            if(active) then
                self:Show();
            else
                self:Hide();
            end
        end
    button.SetDefaults = function(self)
            self:SetActive(false);
        end
    button.UpdateSkin = function(self)
            --self.flash.bg:SetTexture(GetSelectedSkin().message_window.widgets.w2w.HighlightTexture);
        end
    button:SetScript("OnEnter", function(self)
            if(self.active) then
                
            end
        end);
    button:SetScript("OnLeave", function(self)

        end);
    
    return button;
end

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
        Windows[ChatName].widgets.chat_info:SetActive(true);
        Windows[ChatName].chatList = Windows[ChatName].chatList or {};
        return Windows[ChatName];
    end
end

local function cleanChatList(win)
    if(win.chatList) then
        for k, _ in pairs(win.chatList) do
            win.chatList[k] = nil;
        end
    end
end


RegisterWidgetTrigger("msg_box", "chat", "OnEnterPressed", function(self)
        local obj, msg, TARGET, NUMBER = self:GetParent(), self:GetText();
        if(obj.chatType == "guild") then
            TARGET = "GUILD";
        elseif(obj.chatType == "officer") then
            TARGET = "OFFICER";
        elseif(obj.chatType == "party") then
            TARGET = "PARTY";
        elseif(obj.chatType == "raid") then
            TARGET = "RAID";
        elseif(obj.chatType == "say") then
            TARGET = "SAY";
        elseif(obj.chatType == "channel") then
            TARGET = "CHANNEL";
            NUMBER = obj.channelNumber;
        else
            return;
        end
        local msgCount = math.ceil(string.len(msg)/255);
        if(msgCount == 1) then
            _G.ChatThrottleLib:SendChatMessage("ALERT", "WIM", msg, TARGET, nil, NUMBER);
        elseif(msgCount > 1) then
            SendSplitMessage("ALERT", "WIM", msg, TARGET, nil, NUMBER);
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
    RegisterWidget("chat_info", createWidget_Chat);
    self:RegisterChatEvent("CHAT_MSG_GUILD");
    self:RegisterChatEvent("CHAT_MSG_GUILD_ACHIEVEMENT");
    self:RegisterEvent("GUILD_ROSTER_UPDATE");
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
        Windows[chatName].chatLoaded = nil;
        cleanChatList(Windows[chatName]);
        Windows[chatName] = nil;
        Guild.guildWindow = nil;
    end
end


function Guild:GUILD_ROSTER_UPDATE()
    if(self.guildWindow) then
        -- update guild count
        cleanChatList(self.guildWindow);
        local count = 0;
        for i=1, _G.GetNumGuildMembers() do 
	    local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = _G.GetGuildRosterInfo(i);
	    if(online) then
		_G.GuildControlSetRank(rankIndex);
                local guildchat_listen, guildchat_speak, officerchat_listen, officerchat_speak, promote, demote,
                        invite_member, remove_member, set_motd, edit_public_note, view_officer_note, edit_officer_note,
                        modify_guild_info, _, withdraw_repair, withdraw_gold, create_guild_event = _G.GuildControlGetRankFlags();
        	if(guildchat_listen) then
                    count = count + 1;
                    table.insert(self.guildWindow.chatList, name);
                end
	    end
	end
        self.guildWindow.widgets.chat_info:SetText(count);
    end
end

function Guild:CHAT_MSG_GUILD(arg1, arg2, arg3, ...)
    local win = getChatWindow(_G.GUILD, "guild");
    local color = _G.ChatTypeInfo["GUILD"];
    self.guildWindow = win;
    if(not self.chatLoaded) then
        Guild:GUILD_ROSTER_UPDATE();
    end
    self.chatLoaded = true;
    arg3 = CleanLanguageArg(arg3);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_GUILD", arg1, arg2, arg3, ...);
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
    RegisterWidget("chat_info", createWidget_Chat);
    self:RegisterChatEvent("CHAT_MSG_OFFICER");
    self:RegisterEvent("GUILD_ROSTER_UPDATE");
end

function Officer:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_OFFICER");
end

function Officer:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "officer") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName].chatLoaded = nil;
        cleanChatList(Windows[chatName]);
        Windows[chatName] = nil;
        Officer.officerWin = nil;
    end
end

function Officer:GUILD_ROSTER_UPDATE()
    if(self.officerWindow) then
        -- update guild count
        cleanChatList(self.officerWindow);
        local count = 0;
        for i=1, _G.GetNumGuildMembers() do 
	    local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = _G.GetGuildRosterInfo(i);
            if(online) then
                _G.GuildControlSetRank(rankIndex);
                local guildchat_listen, guildchat_speak, officerchat_listen, officerchat_speak, promote, demote,
                        invite_member, remove_member, set_motd, edit_public_note, view_officer_note, edit_officer_note,
                        modify_guild_info, _, withdraw_repair, withdraw_gold, create_guild_event = _G.GuildControlGetRankFlags();
        	if(officerchat_listen) then
                    count = count + 1;
                    table.insert(self.officerWindow.chatList, name);
                end
            end
	end
        self.officerWindow.widgets.chat_info:SetText(count);
    end
end

function Officer:CHAT_MSG_OFFICER(arg1, arg2, arg3, ...)
    local win = getChatWindow(_G.GUILD_RANK1_DESC, "officer");
    local color = _G.ChatTypeInfo["OFFICER"];
    Officer.officerWindow = win;
    if(not self.chatLoaded) then
        Officer:GUILD_ROSTER_UPDATE();
    end
    self.chatLoaded = true;
    arg3 = CleanLanguageArg(arg3);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_OFFICER", arg1, arg2, arg3, ...);
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
    RegisterWidget("chat_info", createWidget_Chat);
    self:RegisterChatEvent("CHAT_MSG_PARTY");
    self:RegisterEvent("PARTY_MEMBERS_CHANGED");
end

function Party:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_PARTY");
end

function Party:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "party") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName].chatLoaded = nil;
        cleanChatList(Windows[chatName]);
        Windows[chatName] = nil;
        Party.partyWindow = nil;
    end
end

function Party:PARTY_MEMBERS_CHANGED()
    if(Party.partyWindow) then
        cleanChatList(self.partyWindow);
        local myName = _G.UnitName("player");
        table.insert(self.partyWindow.chatList, myName);
        local count = 0;
        for i=1, 4 do
            if(_G.GetPartyMember(i)) then
                count = count + 1;
                local name = _G.UnitName("party"..i);
                table.insert(self.partyWindow.chatList, name);
            end
        end
        Party.partyWindow.widgets.chat_info:SetText(count + 1);
    end
end

function Party:CHAT_MSG_PARTY(arg1, arg2, arg3, ...)
    local win = getChatWindow(_G.PARTY, "party");
    local color = _G.ChatTypeInfo["PARTY"];
    Party.partyWindow = win;
    if(not self.chatLoaded) then
        Party:PARTY_MEMBERS_CHANGED();
    end
    self.chatLoaded = true;
    arg3 = CleanLanguageArg(arg3);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_PARTY", arg1, arg2, arg3, ...);
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
    RegisterWidget("chat_info", createWidget_Chat);
    self:RegisterChatEvent("CHAT_MSG_RAID");
    self:RegisterChatEvent("CHAT_MSG_RAID_LEADER");
    self:RegisterEvent("PARTY_MEMBERS_CHANGED");
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
        Windows[chatName].chatLoaded = nil;
        cleanChatList(Windows[chatName]);
        Windows[chatName] = nil;
    end
end

function Raid:PARTY_MEMBERS_CHANGED()
    if(Raid.raidWindow) then
        cleanChatList(self.raidWindow);
        local count = 0;
        for i=1,40 do
            local name = _G.GetRaidRosterInfo(i);
            if(name) then
                count = count + 1;
                table.insert(self.raidWindow.chatList, name);
            end
        end
        self.raidWindow.widgets.chat_info:SetText(count);
    end 
end

function Raid:CHAT_MSG_RAID(arg1, arg2, arg3, ...)
    local win = getChatWindow(_G.RAID, "raid");
    local color = _G.ChatTypeInfo["RAID"];
    self.raidWindow = win;
    if(not self.chatLoaded) then
        Raid:PARTY_MEMBERS_CHANGED();
    end
    self.chatLoaded = true;
    arg3 = CleanLanguageArg(arg3);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_RAID", arg1, arg2, arg3, ...);
end

function Raid:CHAT_MSG_RAID_LEADER(arg1, arg2, arg3, ...)
    local win = getChatWindow(_G.RAID, "raid");
    local color = _G.ChatTypeInfo["RAID_LEADER"];
    self.raidWindow = win;
    if(not self.chatLoaded) then
        Raid:PARTY_MEMBERS_CHANGED();
    end
    self.chatLoaded = true;
    arg3 = CleanLanguageArg(arg3);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_RAID_LEADER", arg1, arg2, arg3, ...);
end



--------------------------------------
--            Say Chat            --
--------------------------------------

-- create SayChat Module
local Say = CreateModule("SayChat");

-- This Module requires LibChatHandler-1.0
_G.LibStub:GetLibrary("LibChatHandler-1.0"):Embed(Say);

function Say:OnEnable()
    if(not db.chatBeta) then
        return;
    end
    RegisterWidget("chat_info", createWidget_Chat);
    self:RegisterChatEvent("CHAT_MSG_SAY");
end

function Say:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_SAY");
end

function Say:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "say") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName].chatLoaded = nil;
        cleanChatList(Windows[chatName]);
        Windows[chatName] = nil;
    end
end

function Say:CHAT_MSG_SAY(arg1, arg2, arg3, ...)
    local win = getChatWindow(_G.SAY, "say");
    local color = _G.ChatTypeInfo["SAY"];
    self.chatLoaded = true;
    arg3 = CleanLanguageArg(arg3);
    win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
    win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_SAY", arg1, arg2, arg3, ...);
end



--------------------------------------
--            Channel Chat            --
--------------------------------------

-- create SayChat Module
local Channel = CreateModule("ChannelChat");

-- This Module requires LibChatHandler-1.0
_G.LibStub:GetLibrary("LibChatHandler-1.0"):Embed(Channel);

function Channel:OnEnable()
    if(not db.chatBeta) then
        return;
    end
    RegisterWidget("chat_info", createWidget_Chat);
    self:RegisterChatEvent("CHAT_MSG_CHANNEL");
    self:RegisterChatEvent("CHAT_MSG_CHANNEL_JOIN");
    self:RegisterChatEvent("CHAT_MSG_CHANNEL_LEAVE");
    self:RegisterChatEvent("CHAT_MSG_CHANNEL_NOTICE");
    self:RegisterChatEvent("CHAT_MSG_CHANNEL_NOTICE_USER");
end

function Channel:OnDisable()
    self:UnregisterChatEvent("CHAT_MSG_CHANNEL");
    self:UnregisterChatEvent("CHAT_MSG_CHANNEL_JOIN");
    self:UnregisterChatEvent("CHAT_MSG_CHANNEL_LEAVE");
    self:UnregisterChatEvent("CHAT_MSG_CHANNEL_NOTICE");
    self:UnregisterChatEvent("CHAT_MSG_CHANNEL_NOTICE_USER");
end

function Channel:OnWindowDestroyed(self)
    if(self.type == "chat" and self.chatType == "channel") then
        local chatName = self.theUser;
        Windows[chatName].chatType = nil;
        Windows[chatName].unreadCount = nil;
        Windows[chatName].chatLoaded = nil;
        Windows[chatName].channelNumber = nil;
        Windows[chatName].channelSpecial = nil;
        cleanChatList(Windows[chatName]);
        Windows[chatName] = nil;
    end
end


Channel.waitingList = {};
--GetChannelRosterInfo(id, rosterIndex)

local function loadChatList(win, ...)
    cleanChatList(win);
    for i=1, select("#", ...) do
        table.insert(win.chatList, string.trim(select(i, ...)));
    end
end

local function updateJoinLeave(event, ...)
    local arg1, who, arg3, channelIdentifier, arg5, arg6, arg7, channelNumber, arg9 = ...;
    for _, win in pairs(Windows) do
        if(win.channelIdentifier == channelIdentifier) then
            win.widgets.chat_info:SetText(GetChannelCount(win.channelNumber));
            local color = _G.ChatTypeInfo["CHANNEL"..channelNumber];
            win:AddEventMessage(color.r, color.g, color.b, event, ...);
            return;
        end
    end
end

function Channel:CHAT_MSG_CHANNEL_JOIN(...)
    local arg1, who, arg3, channelIdentifier, arg5, arg6, arg7, channelNumber, arg9 = ...;
    updateJoinLeave("CHAT_MSG_CHANNEL_JOIN", ...)
end

function Channel:CHAT_MSG_CHANNEL_LEAVE(...)
    local arg1, who, arg3, channelIdentifier, arg5, arg6, arg7, channelNumber, arg9 = ...;
    updateJoinLeave("CHAT_MSG_CHANNEL_LEAVE", ...)
end

function Channel:CHAT_MSG_CHANNEL_NOTICE(...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
    for _, win in pairs(Windows) do
        if(win.channelIdentifier == arg4) then
            local color = _G.ChatTypeInfo["CHANNEL"..arg8];
            win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_CHANNEL_NOTICE", ...);
            return;
        end
    end
    -- create new window if arg1 is YOU_JOINED
    if(arg1 == "YOU_JOINED") then
        -- open window.
        Channel:CHAT_MSG_CHANNEL("", "", nil, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
    end
end

function Channel:CHAT_MSG_CHANNEL_NOTICE_USER(...)
    local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
    for _, win in pairs(Windows) do
        if(win.channelIdentifier == arg4) then
            local color = _G.ChatTypeInfo["CHANNEL"..arg8];
            win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_CHANNEL_NOTICE_USER", ...);
            return;
        end
    end
end

function Channel:OnWindowShow(win)
    if(win.type == "chat" and win.chatType == "channel") then
        win.widgets.chat_info:SetText(GetChannelCount(win.channelNumber));
    end
end

function Channel:CHAT_MSG_CHANNEL(arg1, arg2, arg3, ...)
    local arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
    -- arg7 Generic Channels (1 for General, 2 for Trade, 22 for LocalDefense, 23 for WorldDefense and 26 for LFG)
    -- arg8 Channel Number
    -- arg9 Channel Name
    local isWorld = arg7 and arg7 > 0;
    local channelName = string.split(" - ", arg9);
    --check options. do we want the specified channels.
    if(isWorld and not db.chat.world.enabled) then
        return;
    elseif(not isWorld and not db.chat.custom.enabled) then
        return;
    elseif(not db.chat.channelSettings[channelName] or not db.chat.channelSettings[channelName].monitor) then
        return;
    end
    local win = getChatWindow(channelName, "channel");
    local color = _G.ChatTypeInfo["CHANNEL"..arg8];
    if(arg7 == 1 or arg7 == 2 or arg7 == 22 or arg7 == 23 or arg7 == 26) then
        win.widgets.char_info:SetText(arg9);
        win.channelSpecial = _G.time();
    else
        win.widgets.char_info:SetText("");
    end
    win.channelNumber = arg8;
    win.channelIdentifier = arg4;
    win.widgets.chat_info:SetText(GetChannelCount(win.channelNumber));
    self.chatLoaded = true;
    if(arg1 and _G.strlen(arg1) > 0) then
        arg3 = CleanLanguageArg(arg3);
        win.unreadCount = win.unreadCount and (win.unreadCount + 1) or 1;
        win:AddEventMessage(color.r, color.g, color.b, "CHAT_MSG_CHANNEL", arg1, arg2, arg3, ...);
    end
end

function Channel:SettingsChanged()
    if(db.chat.world.enabled or db.chat.world.enabled) then
        self:Enable();
    else
        self:Disable();
    end
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
    
    local channelList = {};
    local function getChannelList(world)
        --clear list
        for k, _ in pairs (channelList) do
            channelList[k] = nil;
        end
        for i=1, 20 do
            local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = _G.GetChannelDisplayInfo(i);
            if((world and category == "CHANNEL_CATEGORY_WORLD") or (not world and category == "CHANNEL_CATEGORY_CUSTOM")) then
                table.insert(channelList, name.."*"..(active and "1" or "0").."*"..(channelNumber or "0"));
            end
        end
        return channelList;
    end
    
    
    local channelScrollCount = 1;
    local function createChannelChatTemplate(chatName, channelType, channelListFun)
        local f = options.CreateOptionsFrame();
        f.sub = f:CreateSection(chatName, desc);
        f.sub.nextOffSetY = -10;
        f.sub.enabled = f.sub:CreateCheckButton(L["Enable"], db.chat[channelType], "enabled", nil, function(self, button) Channel:SettingsChanged(); end);
        f.sub.nextOffSetY = -20;
        
        --list
        f.sub.list = f.sub:ImportCustomObject(_G.CreateFrame("Frame"));
        options.AddFramedBackdrop(f.sub.list);
        f.sub.list:SetFullSize();
        f.sub.list:SetHeight(5 * 18);
        f.sub.list.scroll = _G.CreateFrame("ScrollFrame", f.sub:GetName().."ChannelScroll"..channelScrollCount, f.sub.list, "FauxScrollFrameTemplate");
        channelScrollCount = channelScrollCount + 1;
        f.sub.list.scroll:SetPoint("TOPLEFT", 0, -1);
        f.sub.list.scroll:SetPoint("BOTTOMRIGHT", -23, 0);
        f.sub.list.scroll.update = function(self)
            local channelList = channelListFun();
            local offset = _G.FauxScrollFrame_GetOffset(self);
            for i=1, #f.sub.list.buttons do
                local index = i+offset;
                if(index <= #channelList) then
                    local name, active, channelNumber = string.split("*", channelList[index]);
                    active = active == "1";
                    f.sub.list.buttons[i]:Show();
                    f.sub.list.buttons[i].channelName = name;
                    f.sub.list.buttons[i].title:SetText("|cffffffff"..channelNumber..". |r"..name);
                    f.sub.list.buttons[i].cb1:SetChecked(db.chat.channelSettings[name] and db.chat.channelSettings[name].monitor);
                    local color = _G.ChatTypeInfo["CHANNEL"..channelNumber];
                    f.sub.list.buttons[i].title:SetTextColor(color.r, color.g, color.b);
                    if(active) then
                        f.sub.list.buttons[i].title:SetAlpha(1);
                    else
                        f.sub.list.buttons[i].title:SetAlpha(.4);
                    end
                else
                    f.sub.list.buttons[i]:Hide();
                end
            end
            _G.FauxScrollFrame_Update(self, #channelList, #f.sub.list.buttons, 18);
        end
        f.sub.list.scroll:SetScript("OnVerticalScroll", function(self, offset)
            _G.FauxScrollFrame_OnVerticalScroll(self, offset, 18, f.sub.list.scroll.update);
        end);
        f.sub.list:SetScript("OnShow", function(self)
            self.scroll:update();
        end);
        f.sub.list.createButton = function(self)
            self.buttons = self.buttons or {};
            local button = _G.CreateFrame("Button", nil, self);
            button:SetHeight(18);
            button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD");
            button.title = button:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
            button.title:SetPoint("TOPLEFT", 30, 0);
            button.title:SetPoint("BOTTOMRIGHT");
            button.title:SetJustifyH("LEFT")
            local font, height, flags = button.title:GetFont();
            button.title:SetFont(font, 14, flags);
            button.title:SetTextColor(_G.GameFontNormal:GetTextColor());
            button.title:SetText("Test");
            button.cb1 = _G.CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate");
            button.cb1:SetPoint("LEFT");
            button.cb1:SetScale(.65);
            button.cb1:SetScript("OnEnter", function(self)
                self:GetParent():GetParent().help:SetJustifyH("LEFT");
                self:GetParent():GetParent().help:SetText(L["Have WIM monitor this channel."]);
                self:GetParent():LockHighlight();
            end);
            button.cb1:SetScript("OnLeave", function(self)
                self:GetParent():GetParent().help:SetText("");
                self:GetParent():UnlockHighlight();
            end);
            button.cb1:SetScript("OnClick", function(self)
                local name = self:GetParent().channelName;
                if(not db.chat.channelSettings[name]) then
                    db.chat.channelSettings[name] = {};
                end
                db.chat.channelSettings[name].monitor = self:GetChecked();
            end);
            
            if(#self.buttons == 0) then
                button:SetPoint("TOPLEFT");
                button:SetPoint("TOPRIGHT", -25, 0);
            else
                button:SetPoint("TOPLEFT", self.buttons[#self.buttons], "BOTTOMLEFT");
                button:SetPoint("TOPRIGHT", self.buttons[#self.buttons], "BOTTOMRIGHT");
            end
            
            table.insert(self.buttons, button);
        end
        for i=1, 5 do
            f.sub.list:createButton();
        end
        f.sub.list.help = f.sub.list:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
        f.sub.list.help:SetPoint("TOPLEFT", f.sub.list, "BOTTOMLEFT", 0, 0);
        f.sub.list.help:SetPoint("BOTTOMRIGHT", f.sub.list, "BOTTOMRIGHT", 0, -12);
        f.sub.list.help:SetText("");
        f.sub.list.help:SetJustifyH("LEFT");
        local font, height, flags = f.sub.list.help:GetFont();
        f.sub.list.help:SetFont(font, 12, flags);
        
        
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
    
    local function createSayChat()
        local f = createChatTemplate(_G.SAY, "SayChat");
        return f;
    end
    
    local function createWorldChat()
        local f = createChannelChatTemplate(L["World Chat"], "world", function() return getChannelList(true); end);
        return f;
    end
    
    local function createCustomChat()
        local f = createChannelChatTemplate(L["Custom Chat"], "custom", getChannelList);
        return f;
    end
    
    RegisterOptionFrame(L["Chat"], _G.GUILD, createGuildChat);
    RegisterOptionFrame(L["Chat"], _G.GUILD_RANK1_DESC, createOfficerChat);
    RegisterOptionFrame(L["Chat"], _G.PARTY, createPartyChat);
    RegisterOptionFrame(L["Chat"], _G.RAID, createRaidChat);
    RegisterOptionFrame(L["Chat"], _G.SAY, createSayChat);
    RegisterOptionFrame(L["Chat"], L["World Chat"], createWorldChat);
    RegisterOptionFrame(L["Chat"], L["Custom Chat"], createCustomChat);
    
    dPrint("Chat Options Initialized...");
    ChatOptions.optionsLoaded = true;
end

function ChatOptions:OnEnableWIM()
    loadChatOptions();
end


function CleanLanguageArg(arg)
    if(arg and arg ~= "Universal" and arg ~= _G.DEFAULT_CHAT_FRAME.defaultLanguage) then
        return arg;
    else
        return nil;
    end
end

function GetChannelCount(id)
    for i=1, 20 do
        local name, header, collapsed, channelNumber, count, active, category, voiceEnabled, voiceActive = _G.GetChannelDisplayInfo(i);
        if(id == channelNumber) then
            return count;
        end
    end
    return 0;
end
