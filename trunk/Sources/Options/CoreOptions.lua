--imports
local WIM = WIM;
local _G = _G;
local CreateFrame = CreateFrame;

--set namespace
setfenv(1, WIM);

db_defaults.stats = {
    whispers = 0,
    mostConvos = 0,
    versions = 1,
    startDate = "",
}


local function General_Main()
    local frame = options.CreateOptionsFrame()
    frame.welcome = frame:CreateSection(L["Welcome!"], L["_Description"]);
    frame.welcome.nextOffSetY = -10;
    frame.welcome.cb1 = frame.welcome:CreateCheckButton(L["Enable WIM"], WIM.db, "enabled", nil, function(self, button) SetEnabled(self:GetChecked()); end);
    frame.nextOffSetY = -150;
    frame.credits = frame:CreateSection(L["Credits"], L["Special thanks to the following people."]..db.stats.startDate);
    return frame;
end







RegisterOptionFrame(L["General"], L["Main"], "This is just a test Category", General_Main);
