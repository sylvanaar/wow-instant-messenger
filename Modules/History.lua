--imports
local WIM = WIM;
local _G = _G;
local table = table;
local string = string;
local pairs = pairs;
local CreateFrame = CreateFrame;
local date = date;
local time = time;

--set namespace
setfenv(1, WIM);

local History = WIM.CreateModule("History", true);

-- default history settings.
db_defaults.history = {
    whispers = true,
    preview = true,
    previewCount = 25,
};
db_defaults.displayColors.historyIn = {
    r=0.4705882352941176,
    g=0.4705882352941176,
    b=0.4705882352941176
};
db_defaults.displayColors.historyOut = {
    r=0.7058823529411764,
    g=0.7058823529411764,
    b=0.7058823529411764
};

local dDay = 60*60*24;
local dWeek = dDay*7;
local dMonth = dWeek*4;
local dYear = dMonth*12;

local tmpTable = {};

local ViewTypes = {};

local function clearTmpTable()
    for key, _ in pairs(tmpTable) do
        tmpTable[key] = nil;
    end
end

local function getPlayerHistoryTable(convoName)
    if(history[env.realm] and history[env.realm][env.character] and history[env.realm][env.character][convoName]) then
        return history[env.realm][env.character][convoName];
    else
        -- this player hasn't been set up yet. Do it now.
        history[env.realm] = history[env.realm] or {};
        history[env.realm][env.character] = history[env.realm][env.character] or {};
        history[env.realm][env.character][convoName] = history[env.realm][env.character][convoName] or {};
        return history[env.realm][env.character][convoName];
    end
end

local function createWidget()
    local button = _G.CreateFrame("Button");
    button.SetHistory = function(self, isHistory)
        self.isHistory = isHistory;
        if(isHistory and modules.History.enabled) then
            self:SetAlpha(1);
        else
            self:SetAlpha(0);
        end
    end
    button.UpdateProps = function(self)
        self:SetHistory(self.parentWindow.isHistory);
    end
    button:SetScript("OnEnter", function(self)
        if(db.showToolTips == true) then
            _G.GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
            _G.GameTooltip:SetText(L["Click to view message history."]);
        end
    end);
    button:SetScript("OnLeave", function(self)
        _G.GameTooltip:Hide();
    end);
    return button;
end


local function recordWhisper(inbound, ...)
    if(db.history.whispers) then
        local msg, from = ...;
        local win = windows.active.whisper[from] or windows.active.chat[from] or windows.active.w2w[from];
        if(win) then
            win.widgets.history:SetHistory(true);
            local history = getPlayerHistoryTable(from);
            table.insert(history, {
                convo = from,
                type = 1, -- whisper
                inbound = inbound or false,
                from = inbound and from or env.character,
                msg = msg,
                time = _G.time();
            });
        end
    end
end

function History:PostEvent_Whisper(...)
    recordWhisper(true, ...);
end

function History:PostEvent_WhisperInform(...)
    recordWhisper(false, ...);
end

function History:OnEnableWIM()
    -- clean up history if asked to.
end

function History:OnEnable()
    RegisterWidget("history", createWidget);
end

function History:OnDisable()
    for widget in Widgets("history") do
        widget:SetHistory(false); -- module is disabled, hide Icons.
    end
end

function History:OnWindowDestroyed(win)
    win.isHistory = nil;
end

function History:OnWindowCreated(win)
    if(db.history.preview) then
        local history = history[env.realm] and history[env.realm][env.character] and history[env.realm][env.character][win.theUser];
        if(history) then
            local type = win.type == "whisper" and 1;
            for i=#history, 1, -1 do
                table.insert(tmpTable, 1, history[i]);
                if(#tmpTable >= db.history.previewCount) then
                    break;
                end
            end
            if(#tmpTable > 0) then
                win.isHistory = true;
                win.widgets.history:SetHistory(true);
                for i=1, #tmpTable do
                    local event = tmpTable[i].inbound and "CHAT_MSG_WHISPER" or "CHAT_MSG_WHISPER_INFORM";
                    local color = db.displayColors[tmpTable[i].inbound and "historyIn" or "historyOut"];
                    win.nextStamp = tmpTable[i].time;
                    win.nextStampColor = db.displayColors.historyOut;
                    win:AddMessage(applyMessageFormatting(win.widgets.chat_display, event, tmpTable[i].msg, tmpTable[i].from,
                                    nil, nil, nil, nil, nil, nil, nil, nil, -i, color.r, color.g, color.b), color.r, color.g, color.b);
                end
                win.widgets.chat_display:AddMessage(" ");
            end
            clearTmpTable();
        end
    end
end




--------------------------------------
--          History Viewer          --
--------------------------------------

local function searchResult(msg, search)
    search = string.lower(string.trim(search));
    msg = string.lower(msg);
    local start, stop, match = string.find(search, "([^%s]+)",1);
    while(match) do
        if(not string.find(msg, match)) then
            return false;
        end
        start, stop, match = string.find(search, "([^%s]+)",stop+1);
    end
    return true;
end

local HistoryViewer;
local function createHistoryViewer()
    local win = CreateFrame("Frame", "WIM3_FilterFrame", _G.UIParent);
    win:Hide();
    win.filter = {};
    -- set size and position
    win:SetWidth(700);
    win:SetHeight(505);
    win:SetPoint("CENTER");
    
    -- set backdrop
    win:SetBackdrop({bgFile = "Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\Frame_Background", 
        edgeFile = "Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\Frame", 
        tile = true, tileSize = 64, edgeSize = 64, 
        insets = { left = 64, right = 64, top = 64, bottom = 64 }});

    -- set basic frame properties
    win:SetClampedToScreen(true);
    win:SetFrameStrata("DIALOG");
    win:SetMovable(true);
    win:SetToplevel(true);
    win:EnableMouse(true);
    win:RegisterForDrag("LeftButton");
    win:SetMinResize(600, 400);

    -- set script events
    win:SetScript("OnDragStart", function(self) self:StartMoving(); end);
    win:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
    
    -- create and set title bar text
    win.title = win:CreateFontString(win:GetName().."Title", "OVERLAY", "ChatFontNormal");
    win.title:SetPoint("TOPLEFT", 50 , -20);
    local font = win.title:GetFont();
    win.title:SetFont(font, 16, "");
    win.title:SetText(L["History Viewer"])
    
    -- create close button
    win.close = CreateFrame("Button", win:GetName().."Close", win);
    win.close:SetWidth(18); win.close:SetHeight(18);
    win.close:SetPoint("TOPRIGHT", -24, -20);
    win.close:SetNormalTexture("Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\blipRed");
    win.close:SetHighlightTexture("Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\close", "BLEND");
    win.close:SetScript("OnClick", function(self)
            self:GetParent():Hide();
        end);
    
    -- window actions
    win:SetScript("OnShow", function(self)
            _G.PlaySound("igMainMenuOpen");
            self.UpdateUserList();
        end);
    win:SetScript("OnHide", function(self) _G.PlaySound("igMainMenuClose"); end);
    table.insert(_G.UISpecialFrames,win:GetName());
    
    -- create nav
    win.nav = CreateFrame("Frame", nil, win);
    win.nav.border = win.nav:CreateTexture(nil, "BACKGROUND");
    win.nav.border:SetTexture(1,1,1,.25);
    win.nav.border:SetPoint("TOPRIGHT");
    win.nav.border:SetPoint("BOTTOMRIGHT");
    win.nav.border:SetWidth(2);
    win.nav:SetPoint("TOPLEFT", 18, -47);
    win.nav:SetPoint("BOTTOMLEFT", 18, 18);
    win.nav:SetWidth(200);
    win.nav.user = CreateFrame("Frame", "WIM3_HistoryUserMenu", win.nav, "UIDropDownMenuTemplate");
    win.nav.user:SetPoint("TOPLEFT", -15, 0);
    if(isWOTLK) then
        _G.UIDropDownMenu_SetWidth(win.nav.user, win.nav:GetWidth() - 25);
    else
        _G.UIDropDownMenu_SetWidth(win.nav:GetWidth() - 25, win.nav.user);
    end
    win.nav.user.list = {};
    win.nav.user.getUserList = function(self)
            for key, _ in pairs(self.list) do
                self.list[key] = nil;
            end
            for realm, users in pairs(history) do
                table.insert(self.list, realm);
                for user, _ in pairs(users) do
                    table.insert(self.list, realm.."/"..user);
                end
            end
            table.sort(self.list);
            return self.list;
        end
    win.nav.user.init = function()
            local self = win.nav.user;
            local list = self:getUserList();
            for i=1, #list do
                local info = _G.UIDropDownMenu_CreateInfo();
                info.text = list[i];
                info.value = list[i];
                info.func = function(self)
                        self = self or _G.this;
                        win.USER = self.value;
                        win.CONVO = "";
                        win.FILTER = "";
                        win.UpdateUserList();
                        _G.UIDropDownMenu_SetSelectedValue(win.nav.user, self.value);
                    end;
                _G.UIDropDownMenu_AddButton(info, _G.UIDROPDOWNMENU_MENU_LEVEL);
            end
        end
    win.nav.user:SetScript("OnShow", function(self)
            _G.UIDropDownMenu_Initialize(self, self.init);
            _G.UIDropDownMenu_SetSelectedValue(self, win.USER);
        end);
    win.nav.filters = CreateFrame("Frame", nil, win.nav);
    win.nav.filters:SetPoint("BOTTOMLEFT");
    win.nav.filters:SetPoint("BOTTOMRIGHT", -2, 0);
    win.nav.filters:SetHeight(125);
    win.nav.filters.border = win.nav.filters:CreateTexture(nil, "BACKGROUND");
    win.nav.filters.border:SetTexture(1, 1, 1, .25);
    win.nav.filters.border:SetPoint("TOPLEFT");
    win.nav.filters.border:SetPoint("TOPRIGHT");
    win.nav.filters.border:SetHeight(20);
    win.nav.filters.text = win.nav.filters:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
    win.nav.filters.text:SetPoint("TOPLEFT", win.nav.filters.border);
    win.nav.filters.text:SetPoint("BOTTOMRIGHT", win.nav.filters.border);
    win.nav.filters.text:SetText(L["Filters"]);
    win.nav.filters.text:SetTextColor(_G.GameFontNormal:GetTextColor());
    win.nav.filters.scroll = CreateFrame("ScrollFrame", "WIM3_HistoryFilterListScroll", win.nav.filters, "FauxScrollFrameTemplate");
    win.nav.filters.scroll:SetPoint("TOPLEFT", 0, -22);
    win.nav.filters.scroll:SetPoint("BOTTOMRIGHT", -23, 0);
    win.nav.filters.scroll.buttons = {};
    win.nav.filters.scroll.createButton = function()
            local button = CreateFrame("Button", nil, win.nav.filters);
                if(#win.nav.filters.scroll.buttons > 0) then
                    button:SetPoint("TOPLEFT", win.nav.filters.scroll.buttons[#win.nav.filters.scroll.buttons], "BOTTOMLEFT");
                    button:SetPoint("TOPRIGHT", win.nav.filters.scroll.buttons[#win.nav.filters.scroll.buttons], "BOTTOMRIGHT");
                else
                    button:SetPoint("TOPLEFT", win.nav.filters.scroll);
                    button:SetPoint("TOPRIGHT", win.nav.filters.scroll);
                end
                button:SetHeight(20);
                button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight" , "ADD");
                button:GetHighlightTexture():SetVertexColor(.196, .388, .5);
                
                button.text = button:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
                button.text:SetAllPoints();
                button.text:SetJustifyH("LEFT");
                
                button.SetFilter = function(self, filter)
                        self.filter = filter;
                        if(_G.type(filter) == "number") then
                            self.text:SetText("     "..date(L["_DateFormat"], filter));
                        else
                            self.filter = "";
                            self.text:SetText("     "..filter);
                        end
                    end
                button:SetScript("OnClick", function(self)
                        win.FILTER = self.filter;
                        win.nav.filters.scroll.update();
                        win.UpdateDisplay();
                    end);
                
                table.insert(win.nav.filters.scroll.buttons, button);
            return button;
        end
    for i=1, 5 do
        win.nav.filters.scroll.createButton();
    end
    win.nav.filters.scroll.update = function()
            local self = win.nav.filters.scroll;
            local offset = _G.FauxScrollFrame_GetOffset(self);
            for i=1, #self.buttons do
                local index = i + offset;
                if(index <= #win.FILTERLIST) then
                    self.buttons[i]:SetFilter(win.FILTERLIST[index]);
                    self.buttons[i]:Show();
                    if(self.buttons[i].filter == win.FILTER) then
                        self.buttons[i]:LockHighlight();
                    else
                        self.buttons[i]:UnlockHighlight();
                    end
                else
                    self.buttons[i]:Hide();
                end
            end
            
            _G.FauxScrollFrame_Update(self, #win.FILTERLIST, 5, 20);
        end
    win.nav.filters.scroll:SetScript("OnShow", function(self)
            self:update();
        end);
    win.nav.filters.scroll:SetScript("OnVerticalScroll", function(self)
            _G.FauxScrollFrame_OnVerticalScroll(20, win.nav.filters.scroll.update);
        end);
    

    win.nav.userList = CreateFrame("Frame", nil, win.nav);
    win.nav.userList:SetPoint("BOTTOMLEFT", win.nav.filters, "TOPLEFT", 0, 1);
    win.nav.userList:SetPoint("BOTTOMRIGHT", win.nav.filters, "TOPRIGHT", 0, 1);
    win.nav.userList:SetPoint("TOP", 0, -30);
    win.nav.userList.border = win.nav.userList:CreateTexture(nil, "BACKGROUND");
    win.nav.userList.border:SetTexture(1,1,1,.25);
    win.nav.userList.border:SetPoint("TOPLEFT", 0, 1);
    win.nav.userList.border:SetPoint("TOPRIGHT", 0, 1);
    win.nav.userList.border:SetHeight(1);
    win.nav.userList.scroll = CreateFrame("ScrollFrame", "WIM3_HistoryUserListScroll", win.nav.userList, "FauxScrollFrameTemplate");
    win.nav.userList.scroll:SetPoint("TOPLEFT", 0, -2);
    win.nav.userList.scroll:SetPoint("BOTTOMRIGHT", -23, 0);
    win.nav.userList.scroll.buttons = {};
    win.nav.userList.scroll.createButton = function()
            local button = CreateFrame("Button", nil, win.nav.userList);
                if(#win.nav.userList.scroll.buttons > 0) then
                    button:SetPoint("TOPLEFT", win.nav.userList.scroll.buttons[#win.nav.userList.scroll.buttons], "BOTTOMLEFT");
                    button:SetPoint("TOPRIGHT", win.nav.userList.scroll.buttons[#win.nav.userList.scroll.buttons], "BOTTOMRIGHT");
                else
                    button:SetPoint("TOPLEFT", win.nav.userList.scroll);
                    button:SetPoint("TOPRIGHT", win.nav.userList.scroll);
                end
                button:SetHeight(20);
                button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight" , "ADD");
                button:GetHighlightTexture():SetVertexColor(.196, .388, .5);
                
                button.text = button:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
                button.text:SetAllPoints();
                button.text:SetJustifyH("LEFT");
                
                button.SetUser = function(self, user)
                        self.user = user;
                        self.text:SetText("     "..user);
                    end
                button:SetScript("OnClick", function(self)
                        win:SelectConvo(self.user);
                        win.nav.userList.scroll.update();
                    end);
                
                table.insert(win.nav.userList.scroll.buttons, button);
            return button;
        end
    win.nav.userList.scroll.update = function()
            local self = win.nav.userList.scroll;
            local maxButtons = _G.math.floor(self:GetHeight()/20);
            local offset = _G.FauxScrollFrame_GetOffset(self);
            for i=1, #self.buttons do
                if(i <= maxButtons) then
                    self.buttons[i]:Show();
                    local index = i + offset;
                    if(index <= #win.USERLIST) then
                        self.buttons[i]:SetUser(win.USERLIST[index]);
                        self.buttons[i]:Show();
                        if(self.buttons[i].user == win.CONVO) then
                            self.buttons[i]:LockHighlight();
                        else
                            self.buttons[i]:UnlockHighlight();
                        end
                    else
                        self.buttons[i]:Hide();
                    end
                else
                    self.buttons[i]:Hide();
                end
            end
            
            _G.FauxScrollFrame_Update(self, #win.USERLIST, maxButtons, 20);
        end
    win.nav.userList.scroll:SetScript("OnShow", function(self)
            local maxButtons = _G.math.floor(self:GetHeight()/20);
            if(maxButtons > #self.buttons) then
                local toCreate = maxButtons - #self.buttons;
                for i=1, toCreate do
                    self.createButton();
                end
            end
            self:update();
        end);
    win.nav.userList.scroll:SetScript("OnVerticalScroll", function(self)
            _G.FauxScrollFrame_OnVerticalScroll(20, win.nav.userList.scroll.update);
        end);
    
    --search bar
    win.search = CreateFrame("Frame", nil, win);
    win.search.bg = win.search:CreateTexture(nil, "BACKGROUND");
    win.search.bg:SetTexture(1,1,1,.25);
    win.search.bg:SetAllPoints();
    win.search:SetPoint("TOPLEFT", win.nav, "TOPRIGHT");
    win.search:SetPoint("RIGHT", -18, 0);
    win.search:SetHeight(30);
    win.search.clear = CreateFrame("Button", nil, win.search);
    win.search.clear:SetNormalTexture("Interface\\AddOns\\"..addonTocName.."\\Modules\\Textures\\xNormal");
    win.search.clear:SetPushedTexture("Interface\\AddOns\\"..addonTocName.."\\Modules\\Textures\\xPressed");
    win.search.clear:SetWidth(16);
    win.search.clear:SetHeight(16);
    win.search.clear:SetPoint("RIGHT", -5, 0)
    win.search.clear:SetScript("OnClick", function(self)
            win.search.text:ClearFocus();
            win.search.text:SetText("");
            for key, _ in pairs(win.SEARCHLIST) do
                win.SEARCHLIST[key] = nil;
            end
            win.UpdateFilterList();
            win.UpdateDisplay();
        end);
    win.search.text = CreateFrame("EditBox", nil, win.search);
    win.search.text:SetFontObject(_G.ChatFontNormal);
    win.search.text:SetWidth(200); win.search.text:SetHeight(15);
    win.search.text:SetPoint("RIGHT", win.search.clear, "LEFT", -5, 0);
    win.search.text:SetScript("OnEditFocusGained", function(self) self:HighlightText() end);
    win.search.text:SetScript("OnEditFocusLost", function(self) self:HighlightText(0, 0) end);
    win.search.text:SetScript("OnEnterPressed", function(self)
            for key, _ in pairs(win.SEARCHLIST) do
                win.SEARCHLIST[key] = nil;
            end
            local realm, character = string.match(win.USER, "^([%w%s]+)/?(.*)$");
            if(realm and character and history[realm] and history[realm][character]) then
                for convo, tbl in pairs(history[realm][character]) do
                    for i=1, #tbl do
                        if(searchResult(tbl[i].msg, self:GetText())) then
                            table.insert(win.SEARCHLIST, tbl[i]);
                        end
                    end
                end
            elseif(realm and history[realm]) then
                for character, convos in pairs(history[realm]) do
                    for convo, tbl in pairs(convos) do
                        for i=1, #tbl do
                            if(searchResult(tbl[i].msg, self:GetText())) then
                                table.insert(win.SEARCHLIST, tbl[i]);
                            end
                        end
                    end
                end
            end
            table.sort(win.SEARCHLIST, function(a, b)
                return a.time < b.time;
            end);
            self:ClearFocus();
            win.UpdateFilterList();
            win.UpdateDisplay();
        end);
    options.AddFramedBackdrop(win.search.text);
    win.search.text:SetAutoFocus(false);
    win.search.text:SetScript("OnEscapePressed", function(self) self:ClearFocus() end);
    win.search.label = win.search:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
    win.search.label:SetText(L["Search"]..":");
    win.search.label:SetTextColor(_G.GameFontNormal:GetTextColor());
    win.search.label:SetPoint("RIGHT", win.search.text, "LEFT", -5, 0);
    
    
    --content frame
    win.content = CreateFrame("Frame", nil, win);
    win.content.border = win.content:CreateTexture(nil, "BACKGROUND");
    win.content.border:SetTexture(1,1,1,.25);
    win.content.border:SetPoint("BOTTOMLEFT");
    win.content.border:SetPoint("BOTTOMRIGHT");
    win.content.border:SetHeight(1);
    win.content:SetPoint("TOPLEFT", win.search, "BOTTOMLEFT");
    win.content:SetPoint("TOPRIGHT", win.search, "BOTTOMRIGHT");
    win.content:SetPoint("BOTTOM", 0, 40);
    win.content.tabs = {};
    win.content.createTab = function(self, index)
            local tab = CreateFrame("Button", nil, self);
            tab.index = index;
            tab.frame = ViewTypes[index].frame;
            tab:SetHeight(20);
            tab.text = tab:CreateFontString(nil, "OVERLAY", "ChatFontSmall");
            tab.text:SetAllPoints();
            tab.text:SetText(ViewTypes[index].text);
            tab.bg = tab:CreateTexture(nil, "BACKGROUND");
            tab.bg:SetTexture(1, 1, 1, .25);
            tab.bg:SetAllPoints();
            tab:SetWidth(tab.text:GetStringWidth() + 16);
            if(#self.tabs > 0) then
                tab:SetPoint("TOPLEFT", self.tabs[#self.tabs], "TOPRIGHT",2 ,0);
            else
                tab:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 5, 0);
            end
            tab:SetScript("OnClick", function(self)
                for i=1, #win.content.tabs do
                    if(self.index == i) then
                        win.content.tabs[i]:SetAlpha(1);
                        win.TAB = index;
                        if(self.frame == "chatFrame") then
                            win.content.chatFrame:Show();
                            win.content.textFrame:Hide();
                        else
                            win.content.chatFrame:Hide();
                            win.content.textFrame:Show();
                        end
                    else
                        win.content.tabs[i]:SetAlpha(.5);
                    end
                    win:UpdateDisplay();
                end
            end);
            table.insert(self.tabs, tab);
        end
    for i=1, #ViewTypes do
        win.content:createTab(i);
    end
    
    
    win.content.chatFrame = CreateFrame("ScrollingMessageFrame", nil, win.content);
    win.content.chatFrame:SetPoint("TOPLEFT", 4, -4);
    win.content.chatFrame:SetPoint("BOTTOMRIGHT", -30, 4);
    win.content.chatFrame:SetFontObject("ChatFontNormal");
    win.content.chatFrame:EnableMouse(true);
    win.content.chatFrame:SetJustifyH("LEFT");
    win.content.chatFrame:SetFading(false);
    win.content.chatFrame:SetMaxLines(800);
    win.content.chatFrame.update = function(self)
            if(self:AtTop()) then
		self.up:Disable();
            else
		self.up:Enable();
            end
            if(self:AtBottom()) then
                self.down:Disable();
            else
		self.down:Enable();
            end
        end
    win.content.chatFrame:SetScript("OnShow", function(self)
            self:update();
        end);
    win.content.chatFrame:SetScript("OnMouseWheel", function(self, ...)
	    if(select(1, ...) > 0) then
		if( _G.IsControlKeyDown() ) then
		    self:ScrollToTop();
		else
		    if( _G.IsShiftKeyDown() ) then
			self:PageUp();
		    else
			self:ScrollUp();
		    end
		end
	    else
		if( _G.IsControlKeyDown() ) then
		    self:ScrollToBottom();
		else
		    if( _G.IsShiftKeyDown() ) then
	                self:PageDown();
		    else
			self:ScrollDown();
		    end
		end
	    end
	    self:update();
	end);
    win.content.chatFrame.up = CreateFrame("Button", nil, win.content.chatFrame);
    win.content.chatFrame.up:SetWidth(28); win.content.chatFrame.up:SetHeight(28);
    win.content.chatFrame.up:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up");
    win.content.chatFrame.up:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down");
    win.content.chatFrame.up:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled");
    win.content.chatFrame.up:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
    win.content.chatFrame.up:SetPoint("TOPRIGHT", 30 ,0);
    win.content.chatFrame.up:SetScript("OnClick", function(self)
            local obj = self:GetParent();
	    if( _G.IsControlKeyDown() ) then
		obj:ScrollToTop();
	    else
		if( _G.IsShiftKeyDown() ) then
		    obj:PageUp();
		else
		    obj:ScrollUp();
		end
	    end
            obj:update();
        end);
    win.content.chatFrame.down = CreateFrame("Button", nil, win.content.chatFrame);
    win.content.chatFrame.down:SetWidth(28); win.content.chatFrame.down:SetHeight(28);
    win.content.chatFrame.down:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up");
    win.content.chatFrame.down:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down");
    win.content.chatFrame.down:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled");
    win.content.chatFrame.down:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD");
    win.content.chatFrame.down:SetPoint("BOTTOMRIGHT", 30 ,-4);
    win.content.chatFrame.down:SetScript("OnClick", function(self)
            local obj = self:GetParent();
	    if( _G.IsControlKeyDown() ) then
		obj:ScrollToBottom();
	    else
		if( _G.IsShiftKeyDown() ) then
		    obj:PageDown();
		else
		    obj:ScrollDown();
		end
	    end
            obj:update();
        end);
    
    win.content.textFrame = CreateFrame("ScrollFrame", "WIM3_HistoryTextFrame", win.content, "UIPanelScrollFrameTemplate");
    win.content.textFrame:SetPoint("TOPLEFT", win.content, "TOPLEFT", 4, -4);
    win.content.textFrame:SetPoint("BOTTOMRIGHT", -25, 4);
    win.content.textFrame.text = CreateFrame("EditBox", "WIM3_HistoryTextFrameText", win.content.textFrame);
    win.content.textFrame.text:SetFontObject(_G.ChatFontNormal);
    win.content.textFrame.text:SetMultiLine(true);
    win.content.textFrame:SetScrollChild(win.content.textFrame.text);
    win.content.textFrame.text:SetWidth(win.content.textFrame:GetWidth());
    win.content.textFrame.text:SetHeight(200);
    win.content.textFrame.text:SetAutoFocus(false);
    win.content.textFrame.text:SetScript("OnEscapePressed", function(self) self:ClearFocus() end);
    win.content.textFrame.text:SetScript("OnTextChanged", function(self)
            win.content.textFrame:UpdateScrollChildRect();
        end);
    win.content.textFrame.text.AddMessage = function(self, msg, r, g, b)
            local color;
            if(r and g and b) then
                color = RGBPercentToHex(r, g, b);
            end
            self:SetText(self:GetText()..(color and "|cff"..color or "")..msg..(color and "|r" or "").."\n");
        end;
    
    
    
    --resize
    win.resize = CreateFrame("Button", nil, win);
    win.resize:SetNormalTexture("Interface\\AddOns\\"..addonTocName.."\\Skins\\Default\\resize");
    win.resize:SetHighlightTexture("Interface\\AddOns\\"..addonTocName.."\\Skins\\Default\\resize", "ADD");
    win.resize:SetWidth(20); win.resize:SetHeight(20);
    win.resize:SetPoint("BOTTOMRIGHT", -11, 11);
    win.resize:SetScript("OnMouseDown", function(self)
            self:GetParent().isSizing = true;
	    self:GetParent():SetResizable(true);
	    self:GetParent():StartSizing("BOTTOMRIGHT");
            self:SetScript("OnUpdate", function(self)
                win.nav.userList.scroll:update();
            end);
        end);
    win.resize:SetScript("OnMouseUp", function(self)
            self:SetScript("OnUpdate", nil);
            self:GetParent().isSizing = false;
	    self:GetParent():StopMovingOrSizing();
            win.nav.userList.scroll:Hide();
            win.nav.userList.scroll:Show();
        end);
    
    win.USER = env.realm.."/"..env.character;
    win.USERLIST = {};
    win.CONVO = "";
    win.CONVOLIST = {};
    win.FILTER = "";
    win.FILTERLIST = {};
    win.SEARCHLIST = {};

    win.SelectConvo = function(self, convo)
        win.CONVO = convo;
        win.FILTER = "";
        win.UpdateConvoList();
        win.UpdateFilterList();
        win.UpdateDisplay();
    end
    
    win.UpdateDisplay = function(self)
        local curList = #win.SEARCHLIST > 0 and win.SEARCHLIST or win.CONVOLIST;
        win.content.chatFrame:Clear();
        win.content.chatFrame.lastDate = nil;
        win.content.chatFrame:SetIndentedWordWrap(db.wordwrap_indent);
        win.content.textFrame.text:SetText("");
        win.content.textFrame.text.lastDate = nil;
        local frame = ViewTypes[win.TAB].frame == "chatFrame" and win.content.chatFrame or win.content.textFrame.text;
        local filter = _G.type(win.FILTER) == "number" or nil;
        local min, max = 0, 0;
        if(filter) then
            local t = win.FILTER;
            local tbl = date("*t", t);
            t = time{year=tbl.year, month=tbl.month, day=tbl.day, hour=0};
            min, max = t, t+dDay;
        end
        for i=1, #curList do
            if(filter) then
                if(min <= curList[i].time and max > curList[i].time) then
                    ViewTypes[win.TAB].func(frame, curList[i]);
                end
            else
                ViewTypes[win.TAB].func(frame, curList[i]);
            end
        end
        win.content.chatFrame:update();
    end
    
    win.UpdateFilterList = function(self)
        for i=1, #win.FILTERLIST do
            win.FILTERLIST[i] = nil;
        end
        local theList = #win.SEARCHLIST > 0 and win.SEARCHLIST or win.CONVOLIST;
        for i=1, #theList do
            local t = theList[i].time;
            local tbl = date("*t", t);
            t = time{year=tbl.year, month=tbl.month, day=tbl.day, hour=0};
            addToTableUnique(win.FILTERLIST, t);
        end
        if(#win.FILTERLIST > 0) then
            table.insert(win.FILTERLIST, 1, L["Show All"]);
        end
        win.nav.filters.scroll:Hide();
        win.nav.filters.scroll:Show();
    end
    
    win.UpdateConvoList = function(self)
        for i=1, #win.CONVOLIST do
            win.CONVOLIST[i] = nil;
        end
        local realm, character = string.match(win.USER, "^([%w%s]+)/?(.*)$");
        if(realm and character and history[realm] and history[realm][character]) then
            local tbl = history[realm][character][win.CONVO];
            for i=1, #tbl do
                table.insert(win.CONVOLIST, tbl[i]);
            end
        elseif(realm and history[realm]) then
            for character, tbl in pairs(history[realm]) do
                if(tbl[win.CONVO]) then
                    for i=1, #tbl[win.CONVO] do
                        table.insert(win.CONVOLIST, tbl[win.CONVO][i]);
                    end
                end
            end
        end
        table.sort(win.CONVOLIST, function(a, b)
            return a.time < b.time;
        end);
    end
    
    win.UpdateUserList = function(self)
        for i=1, #win.USERLIST do
            win.USERLIST[i] = nil;
        end
        local realm, character = string.match(win.USER, "^([%w%s]+)/?(.*)$");
        if(realm and character and history[realm] and history[realm][character]) then
            local tbl = history[realm][character];
            for convo, _ in pairs(tbl) do
                addToTableUnique(win.USERLIST, convo);
            end
        elseif(realm and history[realm]) then
            for character, tbl in pairs(history[realm]) do
                for convo, _ in pairs(tbl) do
                    addToTableUnique(win.USERLIST, convo);
                end
            end
        end
        table.sort(win.USERLIST);
        win.nav.userList.scroll:Hide();
        win.nav.userList.scroll:Show();
        if(#win.USERLIST>0) then
            win.nav.userList.scroll.buttons[1]:Click();
        end
    end
    
    win.content.tabs[1]:Click();
    
    return win;
end


table.insert(ViewTypes, {
        text = L["Chat View"],
        frame = "chatFrame",
        func = function(frame, msg)
            if(msg.type == 1) then
                local event = msg.inbound and "CHAT_MSG_WHISPER" or "CHAT_MSG_WHISPER_INFORM";
                local color = db.displayColors[msg.inbound and "wispIn" or "wispOut"];
                frame.nextStamp = msg.time;
                frame:AddMessage(applyStringModifiers(applyMessageFormatting(frame, event, msg.msg, msg.from), frame), color.r, color.g, color.b)
            end
        end
    });
table.insert(ViewTypes, {
        text = L["Text View"],
        frame = "textFrame",
        func = function(frame, msg)
            if(msg.type == 1) then
                local event = msg.inbound and "CHAT_MSG_WHISPER" or "CHAT_MSG_WHISPER_INFORM";
                local color = db.displayColors[msg.inbound and "wispIn" or "wispOut"];
                frame.nextStamp = msg.time;
                frame:AddMessage(applyStringModifiers(applyMessageFormatting(frame, event, msg.msg, msg.from), frame), color.r, color.g, color.b)
            end
        end
    });




function ShowHistoryViewer()
    HistoryViewer = HistoryViewer or createHistoryViewer();
    HistoryViewer:Show();
end

RegisterSlashCommand("history", ShowHistoryViewer, L["Display history viewer."])
