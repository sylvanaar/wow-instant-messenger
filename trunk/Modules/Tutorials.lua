--imports
local WIM = WIM;
local _G = _G;
local string = string;
local tostring = tostring;

--set namespace
setfenv(1, WIM);

db_defaults.shownTutorials = {};

local Tutorials = CreateModule("Tutorials", true);

local function varFriendly(var)
    var = string.gsub(var, "[^%w_]", "_");
    return var;
end

local _FlagTutorial = _G.FlagTutorial;
function _G.FlagTutorial(id)
    local tut = string.match(tostring(id), "^WIM(.+)");
    if(tut) then
        -- flag internally
        _G.TutorialFrame.wimTip = true;
        -- update text.
        if(tut ~= varFriendly(L["WIM Update Available!"])) then
            db.shownTutorials[tut] = true;
            _G.TutorialFrameCheckButton:Enable();
        else
            _G.TutorialFrameCheckButton:Disable();
        end
        _G.TutorialFrameCheckboxText:SetText(L["Display WIM tips"]);
    else
        -- this tutorial isn't WIM's call origional function
        _G.TutorialFrameCheckButton:Enable();
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
    local var = varFriendly(title);
    if(not db.shownTutorials[var]) then
        db.shownTutorials[var] = true;
        _G["TUTORIAL_TITLEWIM"..var] = title;
        _G["TUTORIALWIM"..var] = tutorial;
        _G.TutorialFrame_NewTutorial("WIM"..var);
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

-- this is used to show tutorial even if Tutorials are disabled.
DisplayTutorialForce = displayTutorial; 