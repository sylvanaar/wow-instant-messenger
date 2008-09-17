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



RegisterOptionFrame(L["General"], L["Main"], "This is just a test Category", General_Main, "Display WIM's options.");
RegisterOptionFrame(L["General"], L["Message Formatting"], "This is just a test Category", General_MessageFormatting, "Display WIM's options.");

RegisterOptionFrame(L["Whispers"], L["Window Behavior"], "This is just a test Category", WhisperPopRules, "Display WIM's options.");
