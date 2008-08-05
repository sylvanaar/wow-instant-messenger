local WIM = WIM;

WIM.db_defaults.tabs = {
    enabled = true,
};


local tabsPerStrip = 10;
local minimumWidth = 75;

local tabGroups = {};

local function addToTableUnique(tbl, item)
    local i;
    for i=1,table.getn(tbl) do
        if(tbl[i] == item) then
            return;
        end
    end
    table.insert(tbl, item);
end

local function removeFromTable(tbl, item)
    local i;
    for i=1,table.getn(tbl) do
        if(tbl[i] == item) then
            table.remove(tbl, i);
            return;
        end
    end
end

local function applySkin(tabStrip)
    
end

local function setTabOffset(tabStrip, PlusOrMinus)
    if(PlusOrMinus > 0) then
	if(tabStrip.curOffset + tabStrip.visibleCount >= table.getn(tabStrip.attached)) then
	    tabStrip.curOffset = table.getn(tabStrip.attached) - tabStrip.visibleCount;
	    if(tabStrip.curOffset < 0) then
                tabStrip.curOffset = 0;
            end
	else
	    tabStrip.curOffset = tabStrip.curOffset + 1;
	end
    elseif(PlusOrMinus < 0) then
	if(tabStrip.curOffset <= 0) then 
	    tabStrip.curOffset = 0;
	else
	    tabStrip.curOffset = tabStrip.curOffset - 1;
	end
    end
    tabStrip:UpdateTabs();
end

local function createTabGroup()
    local stripName = "WIM_TabStrip"..(table.getn(tabGroups) + 1);
    local tabStrip = CreateFrame("Frame", stripName, UIParent);
    tabStrip:SetFrameStrata("DIALOG");
    tabStrip:SetToplevel(true);
    tabStrip:SetWidth(384);
    tabStrip:SetHeight(32);
    
    -- properties, tags, trackers
    tabStrip.attached = {};
    tabStrip.selected = {
        name = "",
        tab = 0,
        obj = nil
    };
    tabStrip.curOffset = 0;
    tabStrip.visibleCount = 0;
    
    --create tabs for tab strip.
    tabStrip.tabs = {};
    local i;
    for i=1,tabsPerStrip do
        local tab = CreateFrame("Button", stripName.."_Tab"..i, tabStrip);
        
        table.insert(tabStrip.tabs, tab);
    end
    
    -- create prev and next buttons
    tabStrip.prevButton = CreateFrame("Button", stripName.."_Prev", tabStrip);
    tabStrip.prevButton:SetScript("OnClick", function() setTabOffset(tabStrip, -1); end);
    tabStrip.nextButton = CreateFrame("Button", stripName.."_Next", tabStrip);
    tabStrip.nextButton:SetScript("OnClick", function() setTabOffset(tabStrip, 1); end);
    
    -- tabStip functions
    tabStrip.UpdateTabs = function(self)
        -- re-order tabs & sizing
        local skinTable = WIM:GetSelectedSkin();
        local curSize;
        if(skinTable.tab_strip.vertical) then
            curSize = tabStrip:GetHeight();
        else
            curSize = tabStrip:GetWidth();
        end
        local count = math.floor(curSize / minimumWidth);
        if(count >= table.getn(tabStrip.attached)) then
		count = table.getn(tabStrip.attached)
		tabStrip.nextButton:Hide();
		tabStrip.prevButton:Hide();
	else
		tabStrip.nextButton:Show();
		tabStrip.prevButton:Show();
		if(tabStrip.curOffset <= 0) then
			tabStrip.prevButton:Disable();
		else
			tabStrip.prevButton:Enable();
		end
		if(tabStrip.curOffset >= table.getn(tabStrip.attached) - count) then
			tabStrip.nextButton:Disable();
		else
			tabStrip.nextButton:Enable();
		end
	end
        tabStrip.visibleCount = count;
        local i;
        for i=1,tabsPerStrip do
            if(i <= count) then
                local str = tabStrip.attached[i+tabStrip.curOffset];
                tabStrip.tabs[i]:Show();
                tabStrip.tabs[i].childObj = WIM.windows.active.whisper[str] or WIM.windows.active.chat[str] or WIM.windows.active.w2w[str];
                tabStrip.tabs[i].childName = str;
                tabStrip.tabs[i]:SetText("");
            else
                tabStrip.tabs[i]:Hide();
                tabStrip.tabs[i].childName = "";
                tabStrip.tabs[i].childObj = nil;
                tabStrip.tabs[i]:SetText("");
            end
        end
    end
    
    tabStrip.Attach = function(self, winName)
        local win = WIM.windows.active.whisper[winName] or WIM.windows.active.chat[winName] or WIM.windows.active.w2w[winName];
        addToTableUnique(tabStrip.attached, winName);
        win.tabStrip = tabStrip;
        tabStrip:UpdateTabs();
        WIM:dPrint(win:GetName().." is attached to "..tabStrip:GetName());
    end
    
    tabStrip.Detach = function(self, winName)
        local win = WIM.windows.active.whisper[winName] or WIM.windows.active.chat[winName] or WIM.windows.active.w2w[winName];
        removeFromTable(tabStrip.attached, winName);
        win.tabStrip = nil;
        tabStrip:UpdateTabs();
        WIM:dPrint(win:GetName().." is detached from "..tabStrip:GetName());
    end
    
    -- hide after first created.
    tabStrip:Hide();
    table.insert(tabGroups, tabStrip);
end



createTabGroup();
