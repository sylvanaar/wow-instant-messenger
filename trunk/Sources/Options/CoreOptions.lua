--imports
local WIM = WIM;
local _G = _G;
local table = table;
local CreateFrame = CreateFrame;
local unpack = unpack;
local UnitName = UnitName;
local pairs = pairs;

--set namespace
setfenv(1, WIM);

db_defaults.stats = {
    whispers = 0,
    mostConvos = 0,
    versions = 1,
    startDate = "",
}

local credits = {
    "|cff69ccf0"..L["Created by:"].."|r Pazza <Bronzebeard>",
    "|cff69ccf0"..L["Special Thanks:"].."|r Stewarta, Zeke <Coilfang>,\n     Morphieus <Spinebreaker>, Nachonut <Bronzebeard>",
};

local states = {"resting", "combat", "pvp", "arena", "party", "raid", "other"};

local filterListCount = 9;

local function General_Main()
    local frame = options.CreateOptionsFrame()
    frame.welcome = frame:CreateSection(L["Welcome!"], L["_Description"]);
    frame.welcome.nextOffSetY = -10;
    frame.welcome.cb1 = frame.welcome:CreateCheckButton(L["Enable WIM"], WIM.db, "enabled", nil, function(self, button) SetEnabled(self:GetChecked()); end);
    frame.welcome.nextOffSetY = -30;
    frame.welcome.cb2 = frame.welcome:CreateCheckButton(L["Display Minimap Icon"], WIM.modules.MinimapIcon, "enabled", nil, function(self, button) EnableModule("MinimapIcon", self:GetChecked()); end);
    frame.welcome.cb2:CreateCheckButton(L["<Right-Click> to show unread messages."], db.minimap, "rightClickNew");
    frame.welcome.nextOffSetY = -45;
    frame.welcome.cb3 = frame.welcome:CreateCheckButton(L["Display Tutorials"], WIM.modules.Tutorials, "enabled", nil, function(self, button) EnableModule("Tutorials", self:GetChecked()); end);
    frame.welcome.reset = frame.welcome:CreateButton(L["Reset Tutorials"], function() db.shownTutorials = {}; end);
    frame.welcome.reset:ClearAllPoints();
    frame.welcome.reset:SetPoint("LEFT", frame.welcome.cb3, "RIGHT", frame.welcome.cb2.text:GetStringWidth()+30, 0);
    frame.welcome.lastObj = frame.welcome.cb3;
    frame.credits = frame:CreateSection(L["Credits"], table.concat(credits, "\n"));
    frame.credits:ClearAllPoints();
    frame.credits:SetFullSize();
    frame.credits:SetPoint("BOTTOM", 0, 10);
    return frame;
end


local function General_MessageFormatting()
    local Preview = {
        {"CHAT_MSG_WHISPER", L["This is a long message which contains both emoticons and urls 8). WIM's home is www.WIMAddon.com."], UnitName("player")},
    };

    local frame = options.CreateOptionsFrame();
    local f = frame:CreateSection(L["Message Formatting"], L["Manipulate how WIM displays messages."]);
    f.nextOffSetY = -15;
    local itemList = {};
    local formats = GetMessageFormattingList();
    for i=1, #formats do
        table.insert(itemList, {
            text = formats[i],
            value = formats[i],
            justifyH = "LEFT",
            func = function() f.prev:Hide(); f.prev:Show(); end,
        });
    end
    db.messageFormat = isInTable(formats, db.messageFormat) and db.messageFormat or formats[1];
    f.mf = f:CreateDropDownMenu(db, "messageFormat", itemList);
    f.prevTitle = f:CreateText(nil, 12);
    f.prevTitle:SetFullSize();
    f.prevTitle:SetText(L["Preview"]);
    f.prevTitle:SetJustifyH("LEFT");
    f.nextOffSetY = -10
    f.prevFrame = f:CreateSection();
    options.AddFramedBackdrop(f.prevFrame);
    f.prev = CreateFrame("ScrollingMessageFrame", f:GetName().."PrevScrollingMessageFrame");
    f.prev:SetScript("OnShow", function(self)
            local color = db.displayColors.wispIn;
            local font, height, flags;
            if(_G[db.skin.font]) then
                font, height, flags = _G[db.skin.font]:GetFont();
            else
                font = libs.SML.MediaTable.font[db.skin.font] or _G["ChatFontNormal"]:GetFont();
            end
            self:SetFont(font, 14, db.skin.font_outline);
            self:Clear();
            for i=1, #Preview do
                self:AddMessage(applyStringModifiers(applyMessageFormatting(self, unpack(Preview[i]))), color.r, color.g, color.b);
            end
            self:SetIndentedWordWrap(db.wordwrap_indent);
        end);
    f.prev:SetFading(false);
    f.prev:SetMaxLines(5);
    f.prev:SetJustifyH("LEFT");
    
    f.prevFrame:SetHeight(60);
    f.prevFrame:SetScript("OnShow", nil); -- we don't want this to trigger
    f.prevFrame:ImportCustomObject(f.prev):SetFullSize();
    f.prev:ClearAllPoints();
    f.prev:SetPoint("TOPLEFT", 5, -5); f.prev:SetPoint("BOTTOMRIGHT", -5, 5);
    f.nextOffSetY = -10
    formats = GetTimeStampFormats();
    tsList = {};
    for i=1, #formats do
        table.insert(tsList, {
            text = _G.date(formats[i]),
            value = formats[i],
            justifyH = "LEFT",
            func = function() f.prev:Hide(); f.prev:Show(); end,
        });
    end
    f:CreateCheckButtonMenu(L["Display Time Stamps"], modules.TimeStamps, "enabled", nil, function(self, button) EnableModule("TimeStamps", self:GetChecked()); f.prev:Hide(); f.prev:Show(); end, tsList, db, "timeStampFormat", function(self, button) f.prev:Hide(); f.prev:Show(); end);
    f:CreateCheckButton(L["Display Emoticons"], modules.Emoticons, "enabled", nil, function(self, button) EnableModule("Emoticons", self:GetChecked()); f.prev:Hide(); f.prev:Show(); end);
    f:CreateCheckButton(L["Display URLs as Links"], modules.URLHandler, "enabled", nil, function(self, button) EnableModule("URLHandler", self:GetChecked()); f.prev:Hide(); f.prev:Show(); end);
    f:CreateCheckButton(L["Indent long messages."], db, "wordwrap_indent", nil, function(self, button) UpdateAllWindowProps(); f.prev:Hide(); f.prev:Show(); end);
    return frame;
end


local function createPopRuleFrame(winType)
    local frame = options.CreateOptionsFrame();
    frame.type = winType;
    frame.main = frame:CreateSection(L["Window Behavior"], L["You can control how windows behave while you are in different situations."]);
    frame.main.nextOffSetY = -20;
    frame.main.intercept = frame.main:CreateCheckButton(L["Intercept Slash Commands"], db.pop_rules[frame.type], "intercept");
    frame.main.nextOffSetY = -20;
    frame.main.alwaysOther = frame.main:CreateCheckButton(L["Use the same rules for all states."], db.pop_rules[frame.type], "alwaysOther", nil, function(self)
            if(self:GetChecked()) then
                frame.main.selectedState = "other";
                frame:Hide();
                frame:Show();
            else
                frame:Hide();
                frame:Show();
            end
        end);
    frame.main.nextOffSetY = -20;
    frame.main.selectedState = "other";
    local itemList = {};
    for i=1, #states do
        table.insert(itemList, {
            text = L["Behaviors for state:"].." "..L["state_"..states[i]],
            value = states[i],
            justifyH = "LEFT",
            func = function(self)
                frame.main.selectedState = self.value;
                frame.main.options:Hide();
                frame.main.options:Show();
            end,
        });
    end
    frame.main.stateList = frame.main:CreateDropDownMenu(frame.main, "selectedState", itemList, 300);
    frame.main.options = frame.main:CreateSection();
    options.AddFramedBackdrop(frame.main.options);
    frame.main.options.getDBTree = function() return db.pop_rules[frame.type][frame.main.selectedState]; end;
    frame.main.options:CreateCheckButton(L["Pop-Up window when message is sent."], frame.main.options.getDBTree, "onSend");
    frame.main.options:CreateCheckButton(L["Pop-Up window when message is received."], frame.main.options.getDBTree, "onReceive");
    frame.main.options:CreateCheckButton(L["Auto focus a window when it is shown."], frame.main.options.getDBTree, "autofocus");
    frame.main.options:CreateCheckButton(L["Keep focus on window after sending a message."], frame.main.options.getDBTree, "keepfocus");
    frame.main.options:CreateCheckButton(L["Suppress messages from the default chat frame."], frame.main.options.getDBTree, "supress");
    
    frame:SetScript("OnShow", function(self)
            if(self.main.alwaysOther:GetChecked()) then
                self.main.stateList:Hide();
            else
                self.main.stateList:Show();
            end
        end);
    
    return frame;
end


local function WhisperPopRules()
    return createPopRuleFrame("whisper");
end


local function General_WindowSettings()
    local frame = options.CreateOptionsFrame();
    frame.menu = frame:CreateSection(L["Window Settings"], L["Some settings may be limited by certain skins."]);
    frame.menu.nextOffSetY = -35;
    frame.menu.width = frame.menu:CreateSlider(L["Default Width"], "150", "800", 150, 800, 1, db.winSize, "width", function(self) UpdateAllWindowProps(); end);
    frame.menu.nextOffSetY = -45;
    frame.menu.height = frame.menu:CreateSlider(L["Default Height"], "150", "600", 150, 600, 1, db.winSize, "height", function(self) UpdateAllWindowProps(); end);
    frame.menu.nextOffSetY = -45;
    frame.menu.scale = frame.menu:CreateSlider(L["Window Scale"], "10", "400", 10, 400, 1, db.winSize, "scale", function(self) UpdateAllWindowProps(); end);
    frame.menu.nextOffSetY = -45;
    frame.menu.alpha = frame.menu:CreateSlider(L["Window Alpha"], "1", "100", 1, 100, 1, db, "windowAlpha", function(self) UpdateAllWindowProps(); end);
    frame.menu.nextOffSetY = -25;
    frame.menu:CreateButton(L["Set Window Spawn Location"], ShowDemoWindow);
    frame.menu.nextOffSetY = -10;
    frame.menu.sub = frame.menu:CreateSection();
    options.AddFramedBackdrop(frame.menu.sub);
    local cascade = {L["Up"], L["Down"], L["Left"], L["Right"], L["Up"].." & "..L["Left"], L["Up"].." & "..L["Right"], L["Down"].." & "..L["Left"], L["Down"].." & "..L["Right"]};
    local tsList = {};
    for i=1, #cascade do
        table.insert(tsList, {
            text = cascade[i],
            value = i,
            justifyH = "LEFT",
        });
    end
    frame.menu.sub:CreateCheckButtonMenu(L["Cascade overlapping windows."], db.winCascade, "enabled", nil, nil, tsList, db.winCascade, "direction", nil);
    frame.menu.sub:CreateCheckButton(L["Ignore arrow keys in message box."], db, "ignoreArrowKeys", nil, function(self) UpdateAllWindowProps(); end);
    frame.menu.sub:CreateCheckButton(L["Allow <ESC> to hide windows."], db, "escapeToHide", L["Windows will also be hidden when frames such as the world map are shown."], function(self) UpdateAllWindowProps(); end);
    return frame;
end

local function General_VisualSettings()
    local frame = options.CreateOptionsFrame();
    frame.menu = frame:CreateSection(L["Display Settings"], L["Configure general window display settings."]);
    frame.menu.nextOffSetY = -20;
    frame.menu.skinText = frame.menu:CreateText();
    frame.menu.skinText:SetText(L["Window Skin:"]);
    frame.menu.skinTooltipText = function(theSkin)
            local text, skin  = "", GetSkinTable(theSkin);
            if(skin.version) then text = text.."\n"..L["Version"]..": |cffffffff"..skin.version.."|r"; end
            if(skin.author) then text = text.."\n"..skin.author; end
            if(skin.website) then text = text.."\n"..skin.website; end
            return text;
        end
    local skins = GetRegisteredSkins();
    local skinList = {};
    for i=1, #skins do
        table.insert(skinList, {
            text = skins[i],
            value = skins[i],
            tooltipTitle = skins[i],
            tooltipText = frame.menu.skinTooltipText(skins[i]),
            justifyH = "LEFT",
            func = function(self)
                LoadSkin(self.value);
            end,
        });
    end
    frame.menu.skinList = frame.menu:CreateDropDownMenu(db.skin, "selected", skinList, 150);
    frame.menu.skinList:ClearAllPoints();
    frame.menu.skinList:SetPoint("LEFT", frame.menu.skinText, "LEFT", frame.menu.skinText:GetStringWidth(), 0);
    frame.menu.lastObj = frame.menu.skinText;
    
    frame.menu.nextOffSetY = -15;
    frame.menu:CreateColorPicker(L["Color: System Messages"], db.displayColors, "sysMsg");
    frame.menu:CreateColorPicker(L["Color: Error Messages"], db.displayColors, "errorMsg");
    frame.menu:CreateColorPicker(L["Color: URL - Web Addresses"], db.displayColors, "webAddress");
    frame.menu.nextOffSetY = -10;
    frame.menu:CreateColorPicker(L["Color: History Messages Sent"], db.displayColors, "historyOut");
    frame.menu:CreateColorPicker(L["Color: History Messages Received"], db.displayColors, "historyIn");
    frame.menu.nextOffSetY = -10;
    frame.menu:CreateCheckButton(L["Use colors suggested by skin."], db.displayColors, "useSkin");
    frame.menu.nextOffSetY = -35;
    frame.menu.sub = frame.menu:CreateSection();
    options.AddFramedBackdrop(frame.menu.sub);
    frame.menu.sub:CreateCheckButton(L["Enable window fading effects."], db, "winFade");
    frame.menu.sub:CreateCheckButton(L["Enable window animation effects."], db, "winAnimation");
    frame.menu.sub:CreateCheckButton(L["Display item links when hovering over them."], db, "hoverLinks");
    
    return frame;
end

local function General_Fonts()
    local frame = options.CreateOptionsFrame();
    frame.menu = frame:CreateSection(L["Fonts"], L["Configure the fonts used in WIM's message windows."]);
    frame.menu.nextOffSetY = -30;
    
    
    frame.list = frame.menu:ImportCustomObject(CreateFrame("Frame"));
    options.frame.filterList = frame.list;
    options.AddFramedBackdrop(frame.list);
    frame.list:SetFullSize();
    frame.list:SetHeight(4 * 24);
    frame.list.scroll = CreateFrame("ScrollFrame", frame.menu:GetName().."FilterScroll", frame.list, "FauxScrollFrameTemplate");
    frame.list.scroll:SetPoint("TOPLEFT", 0, -1);
    frame.list.scroll:SetPoint("BOTTOMRIGHT", -23, 0);
    frame.list.scroll.update = function(self)
            self = self or _G.this;
            self.flist = self.flist or {};
            for key, _ in pairs(self.flist) do self.flist[key] = nil; end
            local sml = libs.SML.MediaTable.font;
            for font, _ in pairs(sml) do
                table.insert(self.flist, font);
            end
            table.sort(self.flist);
            local offset = _G.FauxScrollFrame_GetOffset(self);
            for i=1, #frame.list.buttons do
                local index = i+offset;
                if(index <= #self.flist) then
                    frame.list.buttons[i]:SetFontItem(self.flist[index]);
                    frame.list.buttons[i]:Show();
                    if(db.skin.font == self.flist[index]) then
                        frame.list.buttons[i]:LockHighlight();
                    else
                        frame.list.buttons[i]:UnlockHighlight();
                    end
                else
                    frame.list.buttons[i]:Hide();
                end
            end
            _G.FauxScrollFrame_Update(self, #self.flist, #frame.list.buttons, 24);
        end
    frame.list.scroll:SetScript("OnVerticalScroll", function(self)
            _G.FauxScrollFrame_OnVerticalScroll(24, frame.list.scroll.update);
        end);
    frame.list:SetScript("OnShow", function(self)
            self.scroll:update();
        end);
    frame.list.createButton = function(self)
            self.buttons = self.buttons or {};
            local button = CreateFrame("Button", nil, self);
            button:SetHeight(24);
            button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD");
            button.title = button:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
            button.title:SetAllPoints();
            button.title:SetJustifyH("LEFT")
            local font, height, flags = button.title:GetFont();
            button.title:SetFont(font, 18, flags);
            button.title:SetTextColor(_G.GameFontNormal:GetTextColor());
            button.title:SetText("Test");
            
            button.SetFontItem = function(self, theFont)
                self.font = theFont;
                self.title:SetText("    "..theFont);
                self.title:SetFont(libs.SML.MediaTable.font[theFont], 18, "");
            end
            
            button:SetScript("OnClick", function(self)
                    _G.PlaySound("igMainMenuOptionCheckBoxOn");
                    db.skin.font = self.font;
                    LoadSkin(db.skin.selected);
                    frame.list:Hide(); frame.list:Show();
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
    for i=1, 4 do
        frame.list:createButton();
    end
    
    frame.menu.nextOffSetY = -20;
    frame.menu.outlineText = frame.menu:CreateText();
    frame.menu.outlineText:SetText(L["Font Outline"]..":");
    local outlineList = {
            {text = L["None"],
            value = "",
            justifyH = "LEFT",
            func = function(self)
                LoadSkin(db.skin.selected);
            end},
            {text = L["Thin"],
            value = "OUTLINE",
            justifyH = "LEFT",
            func = function(self)
                LoadSkin(db.skin.selected);
            end},
            {text = L["Thick"],
            value = "THICKOUTLINE",
            justifyH = "LEFT",
            func = function(self)
                LoadSkin(db.skin.selected);
            end},
    };
    frame.menu.outlineList = frame.menu:CreateDropDownMenu(db.skin, "font_outline", outlineList, 150);
    frame.menu.outlineList:ClearAllPoints();
    frame.menu.outlineList:SetPoint("LEFT", frame.menu.outlineText, "LEFT", frame.menu.outlineText:GetStringWidth(), 0);
    frame.menu.lastObj = frame.menu.outlineText;
    
    frame.menu.nextOffSetY = -20;
    frame.menu:CreateCheckButton(L["Use font suggested by skin."], db.skin, "suggest", nil, function(self) LoadSkin(db.skin.selected); end);
    
    frame.menu.nextOffSetY = -60;
    frame.menu:CreateSlider(L["Chat Font Size"], "8", "50", 8, 50, 1, db, "fontSize", function(self) UpdateAllWindowProps(); end);
    
    return frame;
end

local function Whispers_DisplaySettings()
    local frame = options.CreateOptionsFrame();
    frame.menu = frame:CreateSection(L["Display Settings"], L["Configure general display settings when dealing with whispers."]);
    frame.menu.nextOffSetY = -10;
    
    frame.menu:CreateColorPicker(L["Color: Messages Sent"], db.displayColors, "wispOut");
    frame.menu:CreateColorPicker(L["Color: Messages Received"], db.displayColors, "wispIn");
    
    frame.menu.nextOffSetY = -10;
    frame.menu:CreateCheckButton(L["Use colors suggested by skin."], db.displayColors, "useSkin");
    
    frame.menu.nextOffSetY = -20;
    frame.menu:CreateCheckButton(L["Display user class icons and details."], db, "whoLookups", L["Requires who lookups."]);
    frame.menu:CreateCheckButton(L["Display Shortcut Bar"], WIM.modules.ShortcutBar, "enabled", nil, function(self, button) EnableModule("ShortcutBar", self:GetChecked()); end);
    return frame;
end

local function Whispers_Filters()
    local filterTypes = {L["Pattern"], L["User Type"], L["User Level"]};
    local filterActions = {L["Allow"], L["Ignore"], L["Block"]}
    local frame = options.CreateOptionsFrame();
    frame.sub = frame:CreateSection(L["Filtering"], L["Filtering allows you to control which messages are handled as well as how they are handlef by WIM."]);
    frame.sub.nextOffSetY = -10;
    frame.sub:CreateCheckButton(L["Enable Filtering"], WIM.modules.Filters, "enabled", nil, function(self, button) EnableModule("Filters", self:GetChecked()); end);
    frame.sub.nextOffSetY = -15;
    frame.list = frame.sub:ImportCustomObject(CreateFrame("Frame"));
    options.frame.filterList = frame.list;
    options.AddFramedBackdrop(frame.list);
    frame.list:SetFullSize();
    frame.list:SetHeight(filterListCount * 32);
    frame.list.scroll = CreateFrame("ScrollFrame", frame.sub:GetName().."FilterScroll", frame.list, "FauxScrollFrameTemplate");
    frame.list.scroll:SetPoint("TOPLEFT", 0, -1);
    frame.list.scroll:SetPoint("BOTTOMRIGHT", -23, 0);
    frame.list.scroll.update = function(self)
            self = self or _G.this;
            local offset = _G.FauxScrollFrame_GetOffset(self);
            for i=1, #frame.list.buttons do
                local index = i+offset;
                if(index <= #filters) then
                    frame.list.buttons[i]:SetFilterIndex(index);
                    frame.list.buttons[i]:Show();
                    if(frame.list.selected == frame.list.buttons[i].index) then
                        frame.list.buttons[i]:LockHighlight();
                    else
                        frame.list.buttons[i]:UnlockHighlight();
                    end
                else
                    frame.list.buttons[i]:Hide();
                end
            end
            _G.FauxScrollFrame_Update(self, #filters, #frame.list.buttons, 32);
            if(not frame.list.selected) then
                frame.edit:Disable();
                frame.delete:Disable();
            else
                frame.edit:Enable();
                if(frame.list.selected and filters[frame.list.selected] and filters[frame.list.selected].protected) then
                    frame.delete:Disable();
                else
                    frame.delete:Enable();
                end
            end
        end
    frame.list.scroll:SetScript("OnVerticalScroll", function(self)
            _G.FauxScrollFrame_OnVerticalScroll(32, frame.list.scroll.update);
        end);
    frame.list:SetScript("OnShow", function(self)
            self.scroll:update();
        end);
    frame.list.createButton = function(self)
            self.buttons = self.buttons or {};
            local button = CreateFrame("Button", nil, self);
            button:SetHeight(32);
            button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD");
            button.cb = CreateFrame("CheckButton", nil, button, "UICheckButtonTemplate");
            button.cb:SetPoint("TOPLEFT");
            button.cb:SetScale(.75);
            button.cb:SetScript("OnClick", function(self)
                    self:GetParent().filter.enabled = self:GetChecked() and true or false;
                    frame.list:Hide(); frame.list:Show();
                end);
            button.title = button:CreateFontString(nil, "OVERLAY", "ChatFontNormal");
            button.title:SetPoint("TOPLEFT", button.cb, "TOPRIGHT", 0, -4);
            button.title:SetPoint("RIGHT");
            button.title:SetJustifyH("LEFT")
            button.title:SetTextColor(_G.GameFontNormal:GetTextColor());
            button.title:SetText("Test Filter |cffffffff- User Type|r");
            button.action = button:CreateFontString(nil, "OVERLAY", "ChatFontSmall");
            button.action:SetPoint("TOPLEFT", button.title, "BOTTOMLEFT", 0, 0);
            button.action:SetText("Action: Ignore");
            button.stats = button:CreateFontString(nil, "OVERLAY", "ChatFontSmall");
            button.stats:SetPoint("TOPLEFT", button.action, "TOPRIGHT");
            button.stats:SetPoint("RIGHT");
            button.stats:SetJustifyH("RIGHT");
            button.stats:SetText("Total Filtered: 100");
            button.down = CreateFrame("Button", nil, button);
            button.down:SetWidth(14); button.down:SetHeight(14);
            button.down:SetPoint("TOPRIGHT", 0, 0);
            button.down:SetNormalTexture("Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\down");
            button.down:SetHighlightTexture("Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\down", "ADD");
            button.down:SetScript("OnClick", function(self)
                    local index = self:GetParent().index;
                    filters[index], filters[index+1] = filters[index+1], filters[index];
                    if(frame.list.selected == index) then frame.list.selected = frame.list.selected + 1; end
                    frame.list:Hide(); frame.list:Show();
                end);
            button.up = CreateFrame("Button", nil, button);
            button.up:SetWidth(14); button.up:SetHeight(14);
            button.up:SetPoint("RIGHT", button.down, "LEFT", -5, 0);
            button.up:SetNormalTexture("Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\up");
            button.up:SetHighlightTexture("Interface\\AddOns\\"..addonTocName.."\\Sources\\Options\\Textures\\up", "ADD");
            button.up:SetScript("OnClick", function(self)
                    local index = self:GetParent().index;
                    filters[index], filters[index-1] = filters[index-1], filters[index];
                    if(frame.list.selected == index) then frame.list.selected = frame.list.selected - 1; end
                    frame.list:Hide(); frame.list:Show();
                end);
            
            button.SetFilterIndex = function(self, index)
                self.index = index;
                self.filter = filters[index];
                local alpha = self.filter.enabled and 1 or .65;
                self.title:SetText(self.filter.name.."|cffffffff - "..filterTypes[self.filter.type]..(self.filter.protected and " ("..L["Protected"]..")" or "").."|r");
                self.title:SetAlpha(alpha);
                self.action:SetText(L["Action:"].." "..filterActions[self.filter.action]);
                self.action:SetAlpha(alpha);
                self.cb:SetChecked(self.filter.enabled);
                self.stats:SetText(L["Occurrences:"].." "..(self.filter.stats or "0"));
                self.stats:SetAlpha(alpha);
                if(index == 1) then self.up:Hide(); else self.up:Show(); end
                if(index == #filters) then self.down:Hide(); else self.down:Show(); end
            end
            
            button:SetScript("OnClick", function(self)
                    _G.PlaySound("igMainMenuOptionCheckBoxOn");
                    frame.list.selected = self.index;
                    frame.list:Hide(); frame.list:Show();
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
    for i=1, filterListCount do
        frame.list:createButton();
    end
    frame.nextOffSetY = -5;
    frame.add = frame:CreateButton(L["Add Filter"], function(self) ShowFilterFrame(); end);
    frame.edit = frame:CreateButton(L["Edit Filter"], function(self) ShowFilterFrame(filters[frame.list.selected], frame.list.selected); end);
    frame.edit:ClearAllPoints();
    frame.edit:SetPoint("LEFT", frame.add, "RIGHT", 0, 0);
    frame.delete = frame:CreateButton(L["Delete Filter"], function(self)
            table.remove(filters, frame.list.selected);
            if(frame.list.selected == 1) then
                if(#filters > 0) then frame.list.selected = 1 else frame.list.selected = nil; end
            else
                frame.list.selected = frame.list.selected - 1;
            end
            frame.list:Hide(); frame.list:Show();
        end);
    frame.delete:ClearAllPoints();
    frame.delete:SetPoint("TOP", frame.edit, "TOP");
    frame.delete:SetPoint("RIGHT", 0, 0);
    return frame;
end

local function General_History()
    local f = options.CreateOptionsFrame();
    f.sub = f:CreateSection(L["History"], L["WIM can store conversations to be viewed at a later time."]);
    f.sub.nextOffSetY = -10;
    f.sub:CreateCheckButton(L["Enable History"], WIM.modules.History, "enabled", nil, function(self, button) EnableModule("History", self:GetChecked()); end);
    f.sub.nextOffSetY = -15;
    local tsList = {};
    for i=1, 10 do
        table.insert(tsList, {
            text = (i*5).." "..L["Messages"],
            value = (i*5),
            justifyH = "LEFT",
        });
    end
    f.sub:CreateCheckButtonMenu(L["Preview history inside message windows."], db.history, "preview", nil, nil, tsList, db.history, "previewCount");
    f.sub.nextOffSetY = -10;
    f.sub.whispers = f.sub:CreateCheckButton(L["Record Whispers"], db.history.whispers, "enabled");
    f.sub.whispers:CreateCheckButton(L["Record Friends"], db.history.whispers, "friends");
    f.sub.whispers:CreateCheckButton(L["Record Guild"], db.history.whispers, "guild");
    f.sub.whispers:CreateCheckButton(L["Record Everyone"], db.history.whispers, "all");

    f.sub.chat = f.sub:CreateCheckButton(L["Record Chat"], db.history.chat, "enabled");
    f.sub.chat:ClearAllPoints();
    f.sub.chat:SetPoint("TOPLEFT", f.sub.whispers, 200, 0);
    f.sub.chat:CreateCheckButton(L["Record Friends"], db.history.chat, "friends");
    f.sub.chat:CreateCheckButton(L["Record Guild"], db.history.chat, "guild");
    f.sub.chat:CreateCheckButton(L["Record Everyone"], db.history.chat, "all");
    f.sub.chat:Disable();
    f.sub.lastObj = f.sub.whispers;
    
    f.maint = f:CreateSection(L["Maintenance"], L["Allowing your history logs to grow too large will affect the game's performance, therefore it is reccomended that you use the following options."]);
    f.maint:ClearAllPoints();
    f.maint:SetFullSize();
    f.maint:SetPoint("BOTTOM", 0, 10);
    local countList = {100, 200, 500, 1000};
    tsList = {};
    for i=1, #countList do
        table.insert(tsList, {
            text = countList[i].." "..L["Messages"],
            value = countList[i],
            justifyH = "LEFT",
        });
    end
    f.maint.nextOffSetY = -10;
    f.maint:CreateCheckButtonMenu(L["Save a maximum number of messages per person."], db.history, "maxPer", nil, nil, tsList, db.history, "maxCount");
    --f.maint.nextOffSetY = -10;
    local tsList2 = {};
    for i=1, 5 do
        table.insert(tsList2, {
            text = _G.format(L["%d |4Week:Weeks;"], i),
            value = 60*60*24*7*i,
            justifyH = "LEFT",
        });
    end
    f.maint:CreateCheckButtonMenu(L["Automatically delete old messages."], db.history, "ageLimit", nil, nil, tsList2, db.history, "maxAge");
    return f;
end


local function W2W_Main()
    local f = options.CreateOptionsFrame();
    f.sub = f:CreateSection("WIM-2-WIM (W2W)", L["WIM-2-WIM is a feature which allows users with WIM to interact in ways that normal whispering can not."]);
    f.sub.nextOffSetY = -10;
    f.sub:CreateCheckButton(L["Enable WIM-2-WIM"], WIM.modules.W2W, "enabled", nil, function(self, button) EnableModule("W2W", self:GetChecked()); end);
    f.sub.nextOffSetY = -15;
    return f;
end

local function W2W_Privacy()
    local f = options.CreateOptionsFrame();
    f.sub = f:CreateSection(L["Privacy"], L["Restrict the data that is shared."]);
    f.sub.nextOffSetY = -10;
    f.sub:CreateCheckButton(L["Allow others to see me typing."], db.w2w, "shareTyping", nil, function(self, button) UpdateAllServices(); end);
    f.sub:CreateCheckButton(L["Allow others to see my location."], db.w2w, "shareCoordinates", nil, function(self, button) UpdateAllServices(); end);
    f.sub.nextOffSetY = -15;
    return f;
end


RegisterOptionFrame(L["General"], L["Main"], General_Main);
RegisterOptionFrame(L["General"], L["Window Settings"], General_WindowSettings);
RegisterOptionFrame(L["General"], L["Display Settings"], General_VisualSettings);
RegisterOptionFrame(L["General"], L["Fonts"], General_Fonts);
RegisterOptionFrame(L["General"], L["Message Formatting"], General_MessageFormatting);
RegisterOptionFrame(L["General"], L["History"], General_History);

RegisterOptionFrame(L["Whispers"], L["Display Settings"], Whispers_DisplaySettings);
RegisterOptionFrame(L["Whispers"], L["Window Behavior"], WhisperPopRules);
RegisterOptionFrame(L["Whispers"], L["Filtering"], Whispers_Filters);

RegisterOptionFrame("WIM-2-WIM", L["General"], W2W_Main);
RegisterOptionFrame("WIM-2-WIM", L["Privacy"], W2W_Privacy);
