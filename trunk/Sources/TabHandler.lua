local WIM = WIM;

-- imports
local _G = _G;
local CreateFrame = CreateFrame;
local IsShiftKeyDown = IsShiftKeyDown;
local GetMouseFocus = GetMouseFocus;
local table = table;
local pairs = pairs;
local math = math;

-- set namespace
setfenv(1, WIM);

db_defaults.tabs = {
    sortBy = 2, -- 1: Window created, 2: Activity, 3: Alphabetical
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
helperFrame:SetScript("OnDragStart", function(self)
                self:StartMoving();
                self.isMoving = true;
                if(self.obj) then
                    local win = self.obj.childObj;
                    self.obj.tabStrip:Detach(win);
                    self.parentWindow = win;
                    self.parentWindow.isMoving = true;
                    win:Show()
                    win:ClearAllPoints();
                    win:SetPoint("TOPLEFT", self, "TOPLEFT");
                else
                    dPrint("TabHelperFrame couldn't find 'obj'. Reseting State.");
                    self:StopMovingOrSizing();
                    self.isMoving = false;
                    helperFrame:ResetState();
                end
            end);
helperFrame:SetScript("OnDragStop", function(self)
                local win = self.parentWindow;
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
                            dropTo.tabStrip:Attach(win);
                        else
                            local tabStrip = GetAvailableTabGroup();
                            tabStrip:Attach(dropTo);
                            tabStrip:Attach(win);
                        end
                    end
                end
                self:StopMovingOrSizing();
                self.isMoving = false;
                win.isMoving = false;
                helperFrame:ResetState();
            end);
helperFrame:SetScript("OnUpdate", function(self)
                if(self.isMoving and self.isAttached) then
                    helperFrame.flash:Hide();
                    return;
                end
                
                if(IsShiftKeyDown()) then
                    local obj = GetMouseFocus();
                    if(obj and obj.isWimTab and not self.isAttached) then
                        -- attach to tab + position window
                        self.attachedTo = obj;
                        self:RegisterForDrag("LeftButton");
                        self.tabStrip = obj.tabStrip;
                        self.isTabHelper = true;
                        self:ClearAllPoints();
                        self:SetPoint("TOPLEFT", obj, "TOPLEFT", 0, 0);
                        self:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 0, 0);
                        self.isAttached = true;
                        self.obj = obj;
                    elseif(obj and self.isAttached) then
                        if(obj ~= helperFrame) then
                            self:ResetState();
                        end
                    else
                        if(self.isAttached) then
                            self:ResetState();
                        end
                    end
                else
                    if(self.isAttached) then
                        self:ResetState();
                    end
                end
                if(self.isAttached) then
                    self.flash:Show();
                else
                    self.flash:Hide();
                end
            end);
helperFrame:Show();



----------------------------------
--      Core Tab Management     --
----------------------------------

-- a simple function to add an item to a table checking for duplicates.
-- this is ok, since the table is never too large to slow things down.
local addToTableUnique = addToTableUnique;

-- remove item from table. Return true if removed, false otherwise.
local removeFromTable = removeFromTable;

-- sorting functions
local function sortTabs(a, b)
    if(db.tabs.sortBy == 1) then
        -- sort by window creation
        return a.age > b.age;
    elseif(db.tabs.sortBy == 2) then
        -- sort by activity
        return a.lastActivity > b.lastActivity;
    else
        -- sort alphabetical
        return a.theUser > b.theUser;
    end
end


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
    local skinTable = GetSelectedSkin().tab_strip;
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

local function applySkinToTab(tab, skinTable)
    tab:SetHighlightTexture(skinTable.textures.tab.HighlightTexture, skinTable.textures.tab.HighlightAlphaMode);
    local hlt = tab:GetHighlightTexture();
    if(hlt) then
        hlt:ClearAllPoints();
        hlt:SetAllPoints();
    end
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
        tab.text = tab:CreateFontString(tab:GetName().."Text", "OVERLAY", "ChatFontNormal")
        tab.text:ClearAllPoints();
        tab.text:SetAllPoints();
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
            self.left:SetTexture(pathOrTexture);
            self.middle:SetTexture(pathOrTexture);
            self.right:SetTexture(pathOrTexture);
        end
        tab:RegisterForClicks("LeftButtonUp", "RightButtonUp");
        tab:SetScript("OnClick", function(self, button)
            if(button == "RightButton") then
                self.childObj.widgets.close.forceShift = true;
                self.childObj.widgets.close:Click();
            else
                tabStrip:JumpToTab(self.childObj);
            end
        end);
        tab.isWimTab = true;
        
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
        if(#self.attached > 1) then
            self:Show();
        else
            if(#self.attached == 1) then
                self:Detach(self.attached[i])
            end
            self:Hide();
            return;
        end
    
        -- sort tabs
        table.sort(self.attached, sortTabs);
    
        -- relocate tabStrip to window
        local win = self.selected.obj;
        local skinTable = GetSelectedSkin().tab_strip;
        self:SetParent(win);
        self.parentWindow = win;
        SetWidgetRect(self, skinTable);
    
        -- re-order tabs & sizing
        local curSize;
        if(skinTable.vertical) then
            curSize = self:GetHeight();
        else
            curSize = self:GetWidth();
        end
        local count = math.floor(curSize / minimumWidth);
        if(count >= #self.attached) then
		count = #self.attached;
		self.nextButton:Hide();
		self.prevButton:Hide();
	else
                
		self.nextButton:Show();
		self.prevButton:Show();
                self.nextButton:SetNormalTexture(skinTable.textures.next.NormalTexture);
                self.nextButton:SetPushedTexture(skinTable.textures.next.PushedTexture);
                self.nextButton:SetHighlightTexture(skinTable.textures.next.HighlightTexture, skinTable.textures.next.HighlightAlphaMode);
                self.nextButton:SetDisabledTexture(skinTable.textures.next.DisabledTexture);
                self.prevButton:SetNormalTexture(skinTable.textures.prev.NormalTexture);
                self.prevButton:SetPushedTexture(skinTable.textures.prev.PushedTexture);
                self.prevButton:SetHighlightTexture(skinTable.textures.prev.HighlightTexture, skinTable.textures.prev.HighlightAlphaMode);
                self.prevButton:SetDisabledTexture(skinTable.textures.prev.DisabledTexture);
                
                self.prevButton:ClearAllPoints();
                self.prevButton:SetPoint("RIGHT", self, "LEFT", 0, 0);
                self.prevButton:SetWidth(skinTable.textures.prev.width); self.prevButton:SetHeight(skinTable.textures.prev.height);
                self.nextButton:ClearAllPoints();
                self.nextButton:SetPoint("LEFT", self, "RIGHT", 0, 0);
                self.nextButton:SetWidth(skinTable.textures.next.width); self.nextButton:SetHeight(skinTable.textures.next.height);
                
                self.prevButton.parentWindow = self:GetParent();
                self.nextButton.parentWindow = self:GetParent();
                
		if(self.curOffset <= 0) then
			self.prevButton:Disable();
		else
			self.prevButton:Enable();
		end
		if(self.curOffset >= #self.attached - count) then
			self.nextButton:Disable();
		else
			self.nextButton:Enable();
		end
	end
        self.visibleCount = count;
        for i=1,tabsPerStrip do
            if(i <= count) then
                local str = self.attached[i+self.curOffset].theUser;
                self.tabs[i]:Show();
                self.tabs[i].childObj = self.attached[i+self.curOffset];
                self.tabs[i].childName = str;
                self.tabs[i].text:SetText(str);
                applySkinToTab(self.tabs[i], skinTable);
                if(self.tabs[i].childObj == self.selected.obj) then
                    self.tabs[i]:SetAlpha(1);
                    self.tabs[i]:SetTexture(skinTable.textures.tab.PushedTexture);
                else
                    self.tabs[i]:SetAlpha(.7);
                    self.tabs[i]:SetTexture(skinTable.textures.tab.NormalTexture);
                end
            else
                self.tabs[i]:Hide();
                self.tabs[i].childName = "";
                self.tabs[i].childObj = nil;
                self.tabs[i]:SetText("");
            end
            --include logic here to show selected tab or not.
            self.tabs[i]:SetWidth(curSize/count);
            self.tabs[i]:SetHeight(curSize/count);
        end
    end
    
    tabStrip.SetSelectedName = function(self, win)
        --local win = windows.active.whisper[winName] or windows.active.chat[winName] or windows.active.w2w[winName];
        if(win) then
            self.selected.name = win.theUser;
            self.selected.obj = win;
            --self:UpdateTabs();
            self.parentWindow = win;
        end
    end
    
    tabStrip.JumpToTab = function(self, win)
        if(win) then
            local oldWin = self.selected.obj;
    
            DisplayTutorial(L["Manipulating Tabs"], L["You can <Shift-Click> a tab and drag it out into it's own window."]);
            self:SetSelectedName(win);
            local win = self.selected.obj;
            if(oldWin and oldWin ~= win) then
                win:SetWidth(oldWin:GetWidth());
                win:SetHeight(oldWin:GetHeight());
                win:ClearAllPoints();
                win:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", oldWin:GetLeft(), oldWin:GetTop());
                win:SetAlpha(oldWin:GetAlpha());
            end
            win:Show();
            self:UpdateTabs();
            for i=1,#self.attached do
                local obj = self.attached[i];
                if(obj ~= win) then
                    obj:Hide();
                end
            end
        end
    end
    
    tabStrip.Detach = function(self, win)
        --local win = windows.active.whisper[winName] or windows.active.chat[winName] or windows.active.w2w[winName];
        if(win) then
            local curIndex = getIndexFromTable(tabStrip.attached, win);
            if(win == self.selected.obj) then
                if(#self.attached <= 1) then
                    self.selected.name = "";
                    self.selected.obj = nil;
                else
                    local nextIndex;
                    if(curIndex > 1) then
                        nextIndex = curIndex - 1;
                    else
                        nextIndex = curIndex + 1;
                    end
                    self:JumpToTab(self.attached[nextIndex]);
                end
            end
            removeFromTable(self.attached, win);
            win.tabStrip = nil;
            self:UpdateTabs();
            win:Show();
            dPrint(win:GetName().." is detached from "..self:GetName());
        end
    end
    
    tabStrip.Attach = function(self, win)
        --local win = windows.active.whisper[winName] or windows.active.chat[winName] or windows.active.w2w[winName];
        if(win) then
            --if already attached, detach then attach here.
            if(win.tabStrip and win.tabStrip ~= self) then
                win.tabStrip:Detach(winName);
            end
            addToTableUnique(self.attached, win);
            win.tabStrip = self;
            if(#self.attached == 1 or win:IsVisible()) then
                self:JumpToTab(win);
                win:UpdateProps();
            else
                win:Hide();
            end
            self:UpdateTabs();
            dPrint(win:GetName().." is attached to "..self:GetName());
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

-- update All Tabs (used for options mainly)
function UpdateAllTabs()
    for i=1, table.getn(tabGroups) do
        tabGroups[i]:UpdateTabs();
    end
end

-- update skin to all tabStrips.
function ApplySkinToTabs()
    for i=1, table.getn(tabGroups) do
        applySkin(tabGroups[i]);
    end
end

-- give getAvailableTabGroup() a global reference.
function GetAvailableTabGroup()
    return getAvailableTabGroup();
end
