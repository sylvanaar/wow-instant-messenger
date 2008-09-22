--imports
local WIM = WIM;
local _G = _G;
local strsub = strsub;
local string = string;
local format = format;
local table = table;
local type = type;

--set namespace
setfenv(1, WIM);

db_defaults.displayColors.webAddress = {
    r = 1,
    g = 1,
    b = 1
};

local URL = CreateModule("URLHandler", true);

-- patterns created by Sylvanaar & used in Prat
local patterns = {
	-- X@X.Y url (---> email)
	"^(www%.[%w_-]+%.%S+[^%p%s])",
	"%s(www%.[%w_-]+%.%S+[^%p%s])",
	-- XXX.YYY.ZZZ.WWW:VVVV/UUUUU url
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?/%S+[^%p%s])",
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?/%S+[^%p%s])",
	-- XXX.YYY.ZZZ.WWW:VVVV url (IP of ts server for example)
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)", 
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)", 
	-- XXX.YYY.ZZZ.WWW/VVVVV url (---> IP)
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?/%S+[^%p%s])", 
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?/%S+[^%p%s])", 
	-- XXX.YYY.ZZZ.WWW url (---> IP)
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)", 
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)",
	-- X.Y.Z:WWWW/VVVVV url
	"^([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?/%S+[^%p%s])", 
	"%s([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?/%S+[^%p%s])", 
	-- X.Y.Z:WWWW url  (ts server for example)
	"^([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?)", 
	"%s([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?)", 
	-- X.Y.Z/WWWWW url
	"^([%w_.-]+[%w_-]%.%a%a+/%S+[^%p%s])", 
	"%s([%w_.-]+[%w_-]%.%a%a+/%S+[^%p%s])", 
	-- X.Y.Z url
	"^([%w_.-]+[%w_-]%.%a%a+)", 
	"%s([%w_.-]+[%w_-]%.%a%a+)", 
	-- X://Y url
	"(%a+://[%d%w_-%.]+[%.%d%w_%-%/%?%%%=%;%:%+%&]*)", 
};	


local function formatRawURL(theURL)
    if(type(theURL) ~= "string" or theURL == "") then
        return "";
    else
        theURL = theURL:gsub('%%', '%%%%'); --make sure any %'s are escaped in order to preserve them.
        return " |cff"..RGBPercentToHex(db.displayColors.webAddress.r, db.displayColors.webAddress.g, db.displayColors.webAddress.b).."|Hwim_url:"..theURL.."|h".."["..theURL.."]".."|h|r";
    end
end

local function convertURLtoLinks(text)
	for i=1, table.getn(patterns) do
		text = string.gsub(text, patterns[i], formatRawURL);
	end
	return text;
end

local function modifyURLs(str)
    return convertURLtoLinks(str);
end


function URL:OnEnable()
    RegisterStringModifier(modifyURLs, true);
end

function URL:OnDisable()
    UnregisterStringModifier(modifyURLs);
end


local function isLinkTypeURL(link)
	if (strsub(link, 1, 7) == "wim_url") then
		return true;
	else
		return false;
	end
end

local function displayURL(link)
    local theLink = "";
    if (string.len(link) > 4) and (string.sub(link,1,8) == "wim_url:") then
	theLink = string.sub(link,9, string.len(link));
    end
    -- The following code was written by Sylvannar.
    _G.StaticPopupDialogs["WIM_SHOW_URL"] = {
        text = "URL : %s",
        button2 = _G.TEXT(_G.ACCEPT),
        hasEditBox = 1,
        hasWideEditBox = 1,
        showAlert = 1, -- HACK : it"s the only way I found to make de StaticPopup have sufficient width to show WideEditBox :(
        OnShow = function(self)
                self = self or _G.this; -- tbc hack
                local editBox = _G.getglobal(self:GetName().."WideEditBox");
                editBox:SetText(format(theLink));
                editBox:SetFocus();
                editBox:HighlightText(0);
    
                local button = _G.getglobal(self:GetName().."Button2");
                button:ClearAllPoints();
                button:SetWidth(100);
                button:SetPoint("CENTER", editBox, "CENTER", 0, -30);
    
                _G.getglobal(self:GetName().."AlertIcon"):Hide();  -- HACK : we hide the false AlertIcon
            end,
        OnHide = function() end,
        OnAccept = function() end,
        OnCancel = function() end,
        EditBoxOnEscapePressed = function(self)
                self = self or _G.this; -- tbc hack
                self:GetParent():Hide();
            end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1
    };        
    _G.StaticPopup_Show ("WIM_SHOW_URL", theLink);
end


--Hook SetItemRef
local SetItemRef_orig = _G.SetItemRef;
local function setItemRef (link, text, button)
	if (isLinkTypeURL(link)) then
		displayURL(link);
		return;
	end
	SetItemRef_orig(link, text, button);
end
_G.SetItemRef = setItemRef;