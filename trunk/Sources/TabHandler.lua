local WIM = WIM;

WIM.db_defaults.tabs = {
    enabled = true,
};


local tabsPerStrip = 10;
local minimumWidth = 75;

local tabGroups = {};

-- helperFrame's purpose is to assist with dragging and dropping of Windows out of tab strips.
-- The frame will monitor which tab objects are being hovered over and attach itself to them when
-- it's key trigger is pressed.
local helperFrame = CreateFrame("Frame", "WIM_TabHelperFrame", UIParent);
helperFrame.flash = helperFrame:CreateTexture(helperFrame:GetName().."Flash", "OVERLAY");
helperFrame.flash:SetPoint("BOTTOMLEFT");
helperFrame.flash:SetPoint("BOTTOMRIGHT");
helperFrame.flash:SetHeight(2);
helperFrame.flash:SetBlendMode("ADD");
helperFrame.flash:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
helperFrame:SetClampedToScreen(true);
helperFrame:SetFrameStrata("TOOLTIP");
helperFrame:SetMovable(true);
helperFrame:SetToplevel(true);
helperFrame:SetWidth(1);
helperFrame:SetHeight(1);
helperFrame:EnableMouse(true);
helperFrame.ResetState = function(self)
        helperFrame:RegisterForDrag();
        helperFrame:ClearAllPoints();
        helperFrame:SetWidth(1);
        helperFrame:SetHeight(1);
        helperFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
        helperFrame.attachedTo = nil;
        helperFrame.isAttached = false;
        helperFrame.obj = nil;
    end
helperFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
helperFrame:SetScript("OnDragStart", function()
                this:StartMoving();
                this.isMoving = true;
                if(this.obj) then
                    local win = this.obj.childObj;
                    this.obj.tabStrip:Detach(this.obj.childName);
                    this.parentWindow = win;
                    this.parentWindow.isMoving = true;
                    win:Show()
                    win:ClearAllPoints();
                    win:SetPoint("TOPLEFT", this, "TOPLEFT");
                else
                    WIM:dPrint("TabHelperFrame couldn't find 'obj'. Reseting State.");
                    this:StopMovingOrSizing();
                    this.isMoving = false;
                    helperFrame:ResetState();
                end
            end);
helperFrame:SetScript("OnDragStop", function()
                local win = this.parentWindow;
                local x,y = win:GetLeft(), win:GetTop();
                win:ClearAllPoints();
                win:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);
                
                -- account for win's helper frame.
                if(win.helperFrame.isAttached) then
                    local dropTo = win.helperFrame.attachedTo;
                    win.helperFrame:ResetState();
                    if(dropTo) then
                        -- win was already detached when drag started.
                        -- so no need to check for that again.
                        if(dropTo.tabStrip) then
                            dropTo.tabStrip:Attach(win.theUser);
                        else
                            local tabStrip = WIM:GetAvailableTabGroup();
                            tabStrip:Attach(dropTo.theUser);
                            tabStrip:Attach(win.theUser);
                        end
                    end
                end
                this:StopMovingOrSizing();
                this.isMoving = false;
                win.isMoving = false;
                helperFrame:ResetState();
            end);
helperFrame:SetScript("OnUpdate", function()
                if(this.isMoving and this.isAttached) then
                    helperFrame.flash:Hide();
                    return;
                end
                
                if(IsShiftKeyDown()) then
                    local obj = GetMouseFocus();
                    if(obj and obj.isWimTab and not this.isAttached) then
                        -- attach to tab + position window
                        this.attachedTo = obj;
                        this:RegisterForDrag("LeftButton");
                        this.tabStrip = obj.tabStrip;
                        this.isTabHelper = true;
                        this:ClearAllPoints();
                        this:SetPoint("TOPLEFT", obj, "TOPLEFT", 0, 0);
                        this:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 0, 0);
                        this.isAttached = true;
                        this.obj = obj;
                    elseif(obj and this.isAttached) then
                        if(obj ~= helperFrame) then
                            this:ResetState();
                        end
                    else
                        if(this.isAttached) then
                            this:ResetState();
                        end
                    end
                else
                    if(this.isAttached) then
                        this:ResetState();
                    end
                end
                if(this.isAttached) then
                    this.flash:Show();
                else
                    this.flash:Hide();
                end
            end);
helperFrame:Show();



----------------------------------
--      Core Tab Management     --
----------------------------------

-- a simple function to add an item to a table checking for duplicates.
-- this is ok, since the table is never too large to slow things down.
local addToTableUnique = WIM.addToTableUnique;

-- remove item from table. Return true if removed, false otherwise.
local removeFromTable = WIM.removeFromTable;


-- get the table index of an item. return's 0 if not found
local function getIndexFromTable(tbl, item)
    local i;
    for i=1,table.getn(tbl) do
        if(tbl[i] == item) then
            return i;
        end
    end
    return 0;
end

-- update tabStip with propper skin layout.
local function applySkin(tabStrip)
    local skinTable = WIM:GetSelectedSkin().tab_strip;
    local i;
    for i=1,table.getn(tabStrip.tabs) do
        local tab = tabStrip.tabs[i];
        tab:ClearAllPoints();
        if(skinTable.vertical) then
            if(i == 1) then
                tab:SetPoint("TOPLEFT", tabStrip, "TOPLEFT");
                tab:SetPoint("TOPRIGHT", tabStrip, "TOPRIGHT");
            else
                tab:SetPoint("TOPLEFT", tabStrip.tabs[i-1], "BOTTOMLEFT");
                tab:SetPoint("TOPRIGHT", tabStrip.tabs[i-1], "BOTTOMRIGHT");
            end
        else
            if(i == 1) then
                tab:SetPoint("TOPLEFT", tabStrip, "TOPLEFT");
                tab:SetPoint("BOTTOMLEFT", tabStrip, "BOTTOMLEFT");
            else
                tab:SetPoint("TOPLEFT", tabStrip.tabs[i-1], "TOPRIGHT");
                tab:SetPoint("BOTTOMLEFT", tabStrip.tabs[i-1], "BOTTOMRIGHT");
            end
        end
    end
end

-- modify and manage tab offsets. pass 1 or -1. will always increment/decriment by 1.
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

-- create a tabStrip object and register it to table TabGroups.
-- returns the tabStrip just created.
local function createTabGroup()
    local stripName = "WIM_TabStrip"..(table.getn(tabGroups) + 1);
    local tabStrip = CreateFrame("Frame", stripName, UIParent);
    tabStrip:SetFrameStrata("DIALOG");
    tabStrip:SetToplevel(true);
    --tabStrip:SetWidth(384);
    --tabStrip:SetHeight(32);
    
    -- properties, tags, trackers
    tabStrip.attached = {};
    tabStrip.selected = {
        name = "",
        tab = 0,
        obj = nil
    };
    tabStrip.curOffset = 0;
    tabStrip.visibleCount = 0;
    
    --test
    tabStrip:SetPoint("CENTER");
    
    --create tabs for tab strip.
    tabStrip.tabs = {};
    local i;
    for i=1,tabsPerStrip do
        local tab = CreateFrame("Button", stripName.."_Tab"..i, tabStrip);
        tab.tabIndex = i;
        tab.tabStrip = tabStrip;
        tab.left = tab:CreateTexture(stripName.."_Tab"..i.."Backdrop_L", "BORDER");
        tab.left:SetTexCoord(0.0, 0.25, 0.0, 1.0);
        tab.left:SetWidth(16);
        tab.left:SetPoint("TOPLEFT", tab, "TOPLEFT");
        tab.left:SetPoint("BOTTOMLEFT", tab, "BOTTOMLEFT");
        tab.right = tab:CreateTexture(stripName.."_Tab"..i.."Backdrop_R", "BORDER");
        tab.right:SetTexCoord(0.75, 1.0, 0.0, 1.0);
        tab.right:SetWidth(16);
        tab.right:SetPoint("TOPRIGHT", tab, "TOPRIGHT");
        tab.right:SetPoint("BOTTOMRIGHT", tab, "BOTTOMRIGHT");
        tab.middle = tab:CreateTexture(stripName.."_Tab"..i.."Backdrop_M", "BORDER");
        tab.middle:SetTexCoord(0.25, 0.75, 0.0, 1.0);
        tab.middle:SetPoint("TOPLEFT", tab.left, "TOPRIGHT");
        tab.middle:SetPoint("BOTTOMRIGHT", tab.right, "BOTTOMLEFT");
        tab.SetTexture = function(self, pathOrTexture)
            tab.left:SetTexture(pathOrTexture);
            tab.middle:SetTexture(pathOrTexture);
            tab.right:SetTexture(pathOrTexture);
        tab:SetScript("OnClick", function() tabStrip:JumpToTabName(this.childName); end);
        tab.isWimTab = true;
        end
        
        table.insert(tabStrip.tabs, tab);
    end
    
    -- create prev and next buttons
    tabStrip.prevButton = CreateFrame("Button", stripName.."_Prev", tabStrip);
    tabStrip.prevButton:SetScript("OnClick", function() setTabOffset(tabStrip, -1); end);
    tabStrip.nextButton = CreateFrame("Button", stripName.."_Next", tabStrip);
    tabStrip.nextButton:SetScript("OnClick", function() setTabOffset(tabStrip, 1); end);
    
    -- tabStip functions
    tabStrip.UpdateTabs = function(self)
        -- first check to see if we have more than one tab to show...
        if(table.getn(tabStrip.attached) > 1) then
            tabStrip:Show();
        else
            tabStrip:Hide();
            return;
        end
    
        -- relocate tabStrip to window
        local win = tabStrip.selected.obj;
        local skinTable = WIM:GetSelectedSkin().tab_strip;
        tabStrip:SetParent(win);
        tabStrip.parentWindow = win;
        WIM:SetWidgetRect(tabStrip, skinTable);
    
        -- re-order tabs & sizing
        local curSize;
        if(skinTable.vertical) then
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
                tabStrip.tabs[i]:SetText(str);
                if(tabStrip.tabs[i].childObj == tabStrip.selected.obj) then
                    tabStrip.tabs[i]:SetAlpha(1);
                    tabStrip.tabs[i]:SetTexture("Interface\\AddOns\\WIM_Rewrite\\Skins\\Default\\tab_selected");
                else
                    tabStrip.tabs[i]:SetAlpha(.7);
                    tabStrip.tabs[i]:SetTexture("Interface\\AddOns\\WIM_Rewrite\\Skins\\Default\\tab_normal");
                end
            else
                tabStrip.tabs[i]:Hide();
                tabStrip.tabs[i].childName = "";
                tabStrip.tabs[i].childObj = nil;
                tabStrip.tabs[i]:SetText("");
            end
            --include logic here to show selected tab or not.
            tabStrip.tabs[i]:SetWidth(curSize/count);
            tabStrip.tabs[i]:SetHeight(curSize/count);
        end
    end
    
    tabStrip.SetSelectedName = function(self, winName)
        local win = WIM.windows.active.whisper[winName] or WIM.windows.active.chat[winName] or WIM.windows.active.w2w[winName];
        if(win) then
            tabStrip.selected.name = winName;
            tabStrip.selected.obj = win;
            tabStrip:UpdateTabs();
            tabStrip.parentWindow = win;
        end
    end
    
    tabStrip.JumpToTabName = function(self, winName)
        local oldWin = tabStrip.selected.obj;
        
        tabStrip:SetSelectedName(winName);
        local win = tabStrip.selected.obj;
        if(oldWin and oldWin ~= win) then
            win:SetWidth(oldWin:GetWidth());
            win:SetHeight(oldWin:GetHeight());
            win:ClearAllPoints();
            win:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", oldWin:GetLeft(), oldWin:GetTop());
            win:SetAlpha(oldWin:GetAlpha());
        end
        win:Show();
        tabStrip:UpdateTabs();
        local i;
        for i=1,table.getn(tabStrip.attached) do
            local obj = WIM.windows.active.whisper[tabStrip.attached[i]] or WIM.windows.active.chat[tabStrip.attached[i]] or WIM.windows.active.w2w[tabStrip.attached[i]];
            if(obj ~= win) then
                obj:Hide();
            end
        end
    end
    
    tabStrip.Detach = function(self, winName)
        local win = WIM.windows.active.whisper[winName] or WIM.windows.active.chat[winName] or WIM.windows.active.w2w[winName];
        if(win) then
            local curIndex = getIndexFromTable(tabStrip.attached, winName);
            if(win == tabStrip.selected.obj) then
                if(table.getn(tabStrip.attached) <= 1) then
                    tabStrip.selected.name = "";
                    tabStrip.selected.obj = nil;
                else
                    local nextIndex;
                    if(curIndex > 1) then
                        nextIndex = curIndex - 1;
                    else
                        nextIndex = curIndex + 1;
                    end
                    tabStrip:JumpToTabName(tabStrip.attached[nextIndex]);
                end
            end
            removeFromTable(tabStrip.attached, winName);
            win.tabStrip = nil;
            tabStrip:UpdateTabs();
            win:Show();
            WIM:dPrint(win:GetName().." is detached from "..tabStrip:GetName());
        end
    end
    
    tabStrip.Attach = function(self, winName)
        local win = WIM.windows.active.whisper[winName] or WIM.windows.active.chat[winName] or WIM.windows.active.w2w[winName];
        if(win) then
            --if already attached, detach then attach here.
            if(win.tabStrip and win.tabStrip ~= tabStrip) then
                win.tabStrip:Detach(winName);
            end
            addToTableUnique(tabStrip.attached, winName);
            win.tabStrip = tabStrip;
            if(table.getn(tabStrip.attached) == 1 or win:IsVisible()) then
                tabStrip:JumpToTabName(winName);
            else
                win:Hide();
            end
            tabStrip:UpdateTabs();
            WIM:dPrint(win:GetName().." is attached to "..tabStrip:GetName());
        end
    end
    
    applySkin(tabStrip);
    
    -- hide after first created.
    tabStrip:Hide();
    table.insert(tabGroups, tabStrip);
    return tabStrip;
end

-- using the following logic, get an unsed tab group, if none
-- are available, create a new one and return.
local function getAvailableTabGroup()
    if(table.getn(tabGroups) == 0) then
        return createTabGroup();
    else
        local i;
        for i=1, table.getn(tabGroups) do
            if(table.getn(tabGroups[i].attached) == 0) then
                return tabGroups[i];
            end
        end
        return createTabGroup();
    end
end

--------------------------------------
--          Global Tab Functions    --
--------------------------------------

-- update skin to all tabStrips.
function WIM:ApplySkinToTabs()
    local i;
    for i=1, table.getn(tabGroups) do
        applySkin(tabGroups[i]);
    end
end

-- give getAvailableTabGroup() a global reference.
function WIM:GetAvailableTabGroup()
    return getAvailableTabGroup();
end
