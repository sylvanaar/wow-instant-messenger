--imports
local WIM = WIM;
local _G = _G;
local table = table;

--set namespace
setfenv(1, WIM);

db_defaults.stats = {
    whispers = 0,
    mostConvos = 0,
    versions = 1,
    startDate = "",
}

local credits = {
    "Pazza <Bronzebeard> - "..L["Creator"],
    "Stewarta - "..L["Beta Tester"]..", "..L["Skinner"],
};

local function General_Main()
    local frame = options.CreateOptionsFrame()
    frame.welcome = frame:CreateSection(L["Welcome!"], L["_Description"]);
    frame.welcome.nextOffSetY = -10;
    frame.welcome.cb1 = frame.welcome:CreateCheckButton(L["Enable WIM"], WIM.db, "enabled", nil, function(self, button) SetEnabled(self:GetChecked()); end);
    frame.welcome.nextOffSetY = -20;
    frame.welcome.cb2 = frame.welcome:CreateCheckButton(L["Display Minimap Icon"], WIM.modules.MinimapIcon, "enabled", nil, function(self, button) EnableModule("MinimapIcon", self:GetChecked()); end);
    frame.nextOffSetY = -100;
    frame.credits = frame:CreateSection(L["Credits"], table.concat(credits, "\n"));
    frame.credits:ClearAllPoints();
    frame.credits:SetFullSize();
    frame.credits:SetPoint("BOTTOM", 0, 10);
    return frame;
end







RegisterOptionFrame(L["General"], L["Main"], "This is just a test Category", General_Main, "Display WIM's options.");
