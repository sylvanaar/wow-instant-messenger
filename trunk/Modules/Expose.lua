--imports
local WIM = WIM;
local _G = _G;
local table = table;
local unpack = unpack;
local string = string;
local pairs = pairs;

--set namespace
setfenv(1, WIM);

db_defaults.expose = {
    combat = true,
    borderSize = 20,
};

local Expose = WIM.CreateModule("Expose", true);

local inCombat = false;

function Expose:OnStateChange(state)
    --if(1) then return; end -- not ready for release.
    if(db.expose.combat) then
        if(state == "combat") then
            --entered combat
            HideContainer(true);
            inCombat = true;
        elseif(inCombat) then
            --left combat
            ShowContainer(true);
        end
    end
end


local exposeFrame = _G.CreateFrame("Frame", "WIM_UIParent_Expose", _G.UIParent);
exposeFrame:SetFrameStrata("BACKGROUND");
exposeFrame:SetAllPoints();
exposeFrame.top = exposeFrame:CreateTexture("BACKGROUND");
exposeFrame.top:SetTexture(0, 0, 0, .5);
exposeFrame.bottom = exposeFrame:CreateTexture("BACKGROUND");
exposeFrame.bottom:SetTexture(0, 0, 0, .5);
exposeFrame.left = exposeFrame:CreateTexture("BACKGROUND");
exposeFrame.left:SetTexture(0, 0, 0, .5);
exposeFrame.right = exposeFrame:CreateTexture("BACKGROUND");
exposeFrame.right:SetTexture(0, 0, 0, .5);
exposeFrame:SetAlpha(0);

local function AnimAlpha(self, fraction)
    return fraction;
end

local AnimTable = {
	totalTime = 0.3,
	updateFunc = "SetAlpha",
	getPosFunc = AnimAlpha,
	}

function Expose:OnContainerShow()
    _G.SetUpAnimation(exposeFrame, AnimTable, function(self) self:SetAlpha(0); end, true);
end

function Expose:OnContainerHide()
    exposeFrame.top:SetPoint("TOPLEFT", exposeFrame, "TOPLEFT", 0, 0);
    exposeFrame.top:SetPoint("BOTTOMRIGHT", exposeFrame, "TOPRIGHT", 0, -(db.expose.borderSize));
    exposeFrame.bottom:SetPoint("BOTTOMLEFT", exposeFrame, "BOTTOMLEFT", 0, 0);
    exposeFrame.bottom:SetPoint("TOPRIGHT", exposeFrame, "BOTTOMRIGHT", 0, db.expose.borderSize);
    exposeFrame.left:SetPoint("TOPLEFT", exposeFrame.top, "BOTTOMLEFT", 0, 0);
    exposeFrame.left:SetPoint("BOTTOMRIGHT", exposeFrame.bottom, "TOPLEFT", db.expose.borderSize, 0);
    exposeFrame.right:SetPoint("TOPRIGHT", exposeFrame.top, "TOPRIGHT", 0, 0);
    exposeFrame.right:SetPoint("BOTTOMLEFT", exposeFrame.bottom, "TOPRIGHT", -(db.expose.borderSize), 0);
    
    _G.SetUpAnimation(exposeFrame, AnimTable, function(self) self:SetAlpha(1); end, false);
end


-- This module will always remain running.
Expose.canDisable = false;
Expose:Enable();