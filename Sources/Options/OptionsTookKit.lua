--imports
local WIM = WIM;
local _G = _G;
local CreateFrame = CreateFrame;
local unpack = unpack;
local tostring = tostring;
local type = type;

--set namespace
setfenv(1, WIM);

--[[
    To create an option frame, invoke WIM.options.CreateOptionsFrame() returns Frame
    Available Tools:
    - frame:CreateSection(title[, description]) returns Frame
    - frame:SetFullSize()
    - frame:CreateText(inherritFrom[, fontHeight]) returns FontString
    - frame:ImportCustomObject(theObject) returns theObject
]]

local DefaultFont = "ChatFontNormal";
local TitleColor = {_G.GameFontNormal:GetTextColor()};

local ObjectStats = {};


local function statObject(str)
    ObjectStats[str] = ObjectStats[str] or 0;
    ObjectStats[str] = ObjectStats[str] + 1;
    return str..ObjectStats[str];
end

local function SetNextAnchor(obj)
    local parent = obj:GetParent();
    local relativePoint = parent.lastObj;
    --obj:ClearAllPoints();
    if(relativePoint) then
        obj:SetPoint("TOPLEFT", relativePoint, "BOTTOMLEFT", parent.nextOffsetX or 0, parent.nextOffSetY or 0);
    else
        obj:SetPoint("TOPLEFT", parent.nextOffsetX or 0, parent.nextOffSetY or 0);
    end
    parent.nextOffsetX, parent.nextOffSetY = 0, 0;
    parent.lastObj = obj;
end

local function SetFullSize(self)
    self:SetPoint("LEFT");
    self:SetPoint("RIGHT");
end

local function CreateCheckButton(parent, title, dbTree, varName, tooltip, valChanged)
    local cb = CreateFrame("CheckButton", parent:GetName()..statObject("CheckButton"), parent, "UICheckButtonTemplate");
    cb.text = _G.getglobal(cb:GetName().."Text");
    cb.text:SetText("  "..tostring(title));
    cb.text:SetTextColor(unpack(TitleColor));
    cb.text:SetFontObject(DefaultFont);
    cb:SetScript("OnShow", function(self)
            self:SetChecked(dbTree[varName]);
        end);
    cb:SetScript("OnClick", function(self, button)
            _G.PlaySound("igMainMenuOptionCheckBoxOn");
            dbTree[varName] = self:GetChecked();
            if(type(valChanged) == "function") then
                valChanged(self, button);
            end
        end);
    SetNextAnchor(cb);
    return cb;
end


local function CreateText(parent, inherritFrom, fontHeight)
    inherritFrom = inherritFrom or DefaultFont;
    local fs = parent:CreateFontString(parent:GetName()..statObject("FontString"), "OVERLAY", inherritFrom);
    fs:Show();
    if(fontHeight) then
        local font, _, flags = fs:GetFont();
        fs:SetFont(font, fontHeight, flags);
    end
    fs.SetFullSize = SetFullSize;
    SetNextAnchor(fs);
    return fs;
end

local function CreateSection(parent, title, desc)
    local frame = options.CreateOptionsFrame();
    frame:SetParent(parent);
    frame:Show();
    frame:SetFullSize();
    if(title) then
        frame.title = frame:CreateText(nil, 18);
        frame.title:SetText(title);
        frame.title:SetTextColor(unpack(TitleColor));
        frame.title:SetFullSize();
        frame.title:SetJustifyH("LEFT");
        frame.title:SetPoint("TOPLEFT");
        frame.nextOffSetY = -4;
    end
    if(desc) then
        frame.description = frame:CreateText();
        frame.description:SetText(desc);
        frame.description:SetFullSize();
        frame.description:SetJustifyH("LEFT");
        frame.description:SetJustifyV("TOP");
        frame:SetScript("OnUpdate", function(self, elapsed)
                if(frame:GetWidth() < frame.description:GetStringWidth()) then
                    frame.description:SetHeight(frame.description:GetStringWidth()/parent:GetWidth()*(frame.description:GetStringHeight()+
                                    frame.description:GetSpacing()) + (frame.description:GetStringHeight()+frame.description:GetSpacing()));
                end
                frame:Hide();
                frame:Show();
                self:SetScript("OnUpdate", nil);
            end);
    end
    frame:SetScript("OnShow", function(self)
            if(self.lastObj) then
                self:SetHeight(self:GetTop()-self.lastObj:GetBottom());
            end
        end);
    SetNextAnchor(frame);
    return frame;
end

local function InherritOptionFrameProperties(obj)
    obj.CreateSection = CreateSection;
    obj.CreateText = CreateText;
    obj.SetFullSize = SetFullSize;
    obj.CreateCheckButton = CreateCheckButton;
    obj.ImportCustomObject = ImportCustomObject;
end

local function ImportCustomObject(parent, obj)
    statObject("CustomObj");
    obj:SetParent(parent);
    InherritOptionFrameProperties(obj);
    SetNextAnchor(obj);
    return obj;
end


-- Global usage for modules
function options.CreateOptionsFrame()
    local frame = CreateFrame("Frame", "WIM3_OptionFrame"..statObject("Frame"));
    frame:Hide();
    -- declare the following tools.
    InherritOptionFrameProperties(frame);
    return frame;
end
