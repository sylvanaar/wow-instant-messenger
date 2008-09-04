local WIM = WIM;

WIM.db_defaults.urls = {
    color = "FFFFFF";
};

local URL = WIM.CreateModule("URLHandler", true);

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
        return "|cff"..WIM.db.urls.color.."|Hwim_url:"..theURL.."|h".."["..theURL.."]".."|h|r";
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
    WIM.RegisterStringModifier(modifyURLs, true);
end

function URL:OnDisable()
    WIM.UnregisterStringModifier(modifyURLs);
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
        StaticPopupDialogs["WIM_SHOW_URL"] = {
  			text = "URL : %s",
 				button2 = TEXT(ACCEPT),
  			hasEditBox = 1,
  			hasWideEditBox = 1,
  			showAlert = 1, -- HACK : it"s the only way I found to make de StaticPopup have sufficient width to show WideEditBox :(
                        OnShow = function()
                                local editBox = getglobal(this:GetName().."WideEditBox");
                                editBox:SetText(format(theLink));
                                editBox:SetFocus();
                                editBox:HighlightText(0);

                                local button = getglobal(this:GetName().."Button2");
                                button:ClearAllPoints();
                                button:SetWidth(200);
                                button:SetPoint("CENTER", editBox, "CENTER", 0, -30);

                                getglobal(this:GetName().."AlertIcon"):Hide();  -- HACK : we hide the false AlertIcon
                        end,
                        OnHide = function() end,
                        OnAccept = function() end,
                        OnCancel = function() end,
                        EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
                        timeout = 0,
                        whileDead = 1,
                        hideOnEscape = 1
	};
	StaticPopup_Show ("WIM_SHOW_URL", theLink);
end


--Hook SetItemRef
local SetItemRef_orig = SetItemRef;
local function setItemRef (link, text, button)
	if (isLinkTypeURL(link)) then
		displayURL(link);
		return;
	end
	SetItemRef_orig(link, text, button);
end
SetItemRef = setItemRef;