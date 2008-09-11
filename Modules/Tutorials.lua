--imports
local WIM = WIM;
local _G = _G;
local string = string;
local tostring = tostring;

--set namespace
setfenv(1, WIM);

db_defaults.shownTutorials = {};

local Tutorials = CreateModule("Tutorials", true);

local _FlagTutorial = _G.FlagTutorial;
function _G.FlagTutorial(id)
    local tut = string.match(tostring(id), "^WIM(.+)");
    if(tut) then
        -- flag internally
        _G.TutorialFrame.wimTip = true;
        -- update text.
        if(tut ~= L["WIM Update Available!"]) then
            _G.TutorialFrameCheckboxText:SetText(L["Display WIM tips"]);
        end
        db.shownTutorials[tut] = true;
    else
        -- this tutorial isn't WIM's call origional function
        _G.TutorialFrameCheckboxText:SetText(_G.ENABLE_TUTORIAL_TEXT);
        _G.TutorialFrame.wimTip = false;
        _FlagTutorial(id);
    end
end

local _TutorialFrame_OnHide = _G.TutorialFrame_OnHide;
function _G.TutorialFrame_OnHide(self)
    self = self or _G.TutorialFrame;
    if(self.wimTip) then
        -- handle own code here.
        _G.PlaySound("igMainMenuClose");
	if(not _G.TutorialFrameCheckButton:GetChecked()) then
            Tutorials:Disable();
        end
    else
        -- not wim's tip, operate as normal
        _TutorialFrame_OnHide(self);
    end
end

local function displayTutorial(title, tutorial)
    if(not db.shownTutorials[title]) then
        _G["TUTORIAL_TITLEWIM"..title] = title;
        _G["TUTORIALWIM"..title] = tutorial;
        _G.TutorialFrame_NewTutorial("WIM"..title);
    end
end

function Tutorials:OnEnable()
    DisplayTutorial = displayTutorial;
end

function Tutorials:OnDisable()
    -- to decrease table lookups, we can just define the function as such.
    DisplayTutorial = function() end;
end


--Global to add tutorial
function DisplayTutorial(title, tutorial)
    -- this function is defined when the module is enabled.
end
