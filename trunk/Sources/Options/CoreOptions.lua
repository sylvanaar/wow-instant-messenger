--imports
local WIM = WIM;
local _G = _G;
local table = table;
local CreateFrame = CreateFrame;
local unpack = unpack;
local UnitName = UnitName;

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
    "|cff69ccf0"..L["Special Thanks:"].."|r Stewarta, Zeke <Coilfang>,\n     Morphieus <Spinebreaker>",
};

local states = {"resting", "combat", "pvp", "arena", "party", "raid", "other"};

local function General_Main()
    local frame = options.CreateOptionsFrame()
    frame.welcome = frame:CreateSection(L["Welcome!"], L["_Description"]);
    frame.welcome.nextOffSetY = -10;
    frame.welcome.cb1 = frame.welcome:CreateCheckButton(L["Enable WIM"], WIM.db, "enabled", nil, function(self, button) SetEnabled(self:GetChecked()); end);
    frame.welcome.nextOffSetY = -20;
    frame.welcome.cb2 = frame.welcome:CreateCheckButton(L["Display Minimap Icon"], WIM.modules.MinimapIcon, "enabled", nil, function(self, button) EnableModule("MinimapIcon", self:GetChecked()); end);
    frame.welcome.nextOffSetY = -20;
    frame.welcome.cb2 = frame.welcome:CreateCheckButton(L["Display Tutorials"], WIM.modules.Tutorials, "enabled", nil, function(self, button) EnableModule("Tutorials", self:GetChecked()); end);
    frame.welcome.reset = frame.welcome:CreateButton(L["Reset Tutorials"], function() db.shownTutorials = {}; end);
    frame.welcome.reset:ClearAllPoints();
    frame.welcome.reset:SetPoint("LEFT", frame.welcome.cb2, "RIGHT", frame.welcome.cb2.text:GetStringWidth()+30, 0);
    frame.welcome.lastObj = frame.welcome.cb2;
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
            local font, height, flags = _G[db.skin.font]:GetFont();
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
    frame.menu.nextOffSetY = -10;
    
    frame.menu:CreateColorPicker(L["Color: System Messages"], db.displayColors, "sysMsg");
    frame.menu:CreateColorPicker(L["Color: Error Messages"], db.displayColors, "errorMsg");
    frame.menu:CreateColorPicker(L["Color: URL - Web Addresses"], db.displayColors, "webAddress");
    frame.menu.nextOffSetY = -10;
    frame.menu:CreateCheckButton(L["Use colors suggested by skin."], db.displayColors, "useSkin");
    frame.menu.nextOffSetY = -40;
    frame.menu:CreateSlider(L["Chat Font Size"], "8", "50", 8, 50, 1, db, "fontSize", function(self) UpdateAllWindowProps(); end);
    frame.menu.nextOffSetY = -50;
    frame.menu.sub = frame.menu:CreateSection();
    options.AddFramedBackdrop(frame.menu.sub);
    frame.menu.sub:CreateCheckButton(L["Enable window fading effects."], db, "winFade");
    frame.menu.sub:CreateCheckButton(L["Enable window animation effects."], db, "winAnimation");
    
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
    
    return frame;
end


RegisterOptionFrame(L["General"], L["Main"], "This is just a test Category", General_Main, "Display WIM's options.");
RegisterOptionFrame(L["General"], L["Window Settings"], "This is just a test Category", General_WindowSettings, "Display WIM's options.");
RegisterOptionFrame(L["General"], L["Display Settings"], "This is just a test Category", General_VisualSettings, "Display WIM's options.");
RegisterOptionFrame(L["General"], L["Message Formatting"], "This is just a test Category", General_MessageFormatting, "Display WIM's options.");

RegisterOptionFrame(L["Whispers"], L["Display Settings"], "This is just a test Category", Whispers_DisplaySettings, "Display WIM's options.");
RegisterOptionFrame(L["Whispers"], L["Window Behavior"], "This is just a test Category", WhisperPopRules, "Display WIM's options.");
