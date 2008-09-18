--[[
    Extends Modules by adding:
        Module:OnWindowCreated(winObj)
        Module:OnWindowDestroyed(winObj)
        Module:OnWindowPopped(winObj)
	Module:OnWindowMessageAdded(winObj, msg, r, g, b)
]]

local WIM = WIM;

-- imports
local _G = _G;
local CreateFrame = CreateFrame;
local UIFrameFadeIn = UIFrameFadeIn;
local UIFrameFadeOut = UIFrameFadeOut;
local GetMouseFocus = GetMouseFocus;
local table = table;
local string = string;
local IsShiftKeyDown = IsShiftKeyDown;
local select = select;
local pairs = pairs;
local type = type;
local unpack = unpack;
local strsub = strsub;
local time = time;

-- set namespace
setfenv(1, WIM);

-- load message window related default settings.
db_defaults.displayColors = {
		sysMsg = {
				r=1, 
				g=0.6627450980392157, 
				b=0
			},
		errorMsg = {
				r=1, 
				g=0, 
				b=0
			},
		webAddress = {
				r=0, 
				g=0, 
				b=1
			},
	};
db_defaults.fontSize = 12;
db_defaults.windowAlpha = 80;
db_defaults.windowOnTop = true;
db_defaults.keepFocus = true;
db_defaults.keepFocusRested = true;
db_defaults.autoFocus = false;
db_defaults.winSize = {
		width = 384,
		height = 256,
		scale = 85
	};
db_defaults.winLoc = {
		left =242 ,
		top =775
	};
db_defaults.winCascade = {
		enabled = true,
		direction = "downright"
	};
db_defaults.winFade = true;
db_defaults.winAnimation = true;
db_defaults.wordwrap_indent = false;
db_defaults.escapeToHide = true;
db_defaults.ignoreArrowKeys = true;
db_defaults.pop_rules = {};


local WindowSoupBowl = {
    windowToken = 0,
    available = 0,
    used = 0,
    windows = {
    }
}

local FadeProps = {
	min = .5,
	max = 1,
	interval = .25,
	delay = 1
};

local FormattingCallsList = {}; -- used to get a list of available Formattings.
local FormattingCalls = {}; -- functions which are passed events to be formatted. Only one may be used at once.
	
	
	
local StringModifiers = {}; -- registered functions which will be used to format the message part of the string.


-- the following table defines a list of actions to be taken when
-- script handlers are fired for different type windows.
-- use WIM:RegisterWidgetTrigger(WindowType, ScriptEvent, function());
local Widget_Triggers = {};

local function getFormatByName(format)
	local i;
	for i=1, #FormattingCalls do
		if(FormattingCalls[i].name == format) then
			return FormattingCalls[i].fun;
		end
	end
	return FormattingCalls[1].fun;
end

function applyMessageFormatting(...)
	local fun = getFormatByName(db.messageFormat);
	return fun(...);
end


function applyStringModifiers(str)
	for i=1, #StringModifiers do
		str = StringModifiers[i](str);
	end
	return str;
end


local RegisteredWidgets = {}; -- a list of registered widgets added to windows from modules.
windows.widgets = RegisteredWidgets;

--[[ Sample Widget with triggers
RegisteredWidgets["Test"] = function(parentWindow)
	_G.DEFAULT_CHAT_FRAME:AddMessage("Test Widget created!");
	local t = CreateFrame("Frame");
	t.SetDefaults = function()
			_G.DEFAULT_CHAT_FRAME:AddMessage("Test Widget defaults set!");
		end
	t.UpdateProps = function()
			_G.DEFAULT_CHAT_FRAME:AddMessage("Test Widget props updated!");
		end
	return t;
end
]]

local windowListByLevel_Recycle = {};
local function getActiveWindowListByLevel()
	-- first remove items from previously used list.
	local i;
	for i=1,#windowListByLevel_Recycle do
		table.remove(windowListByLevel_Recycle, 1);
	end
	-- load all used windows into table
	for i=1, #WindowSoupBowl.windows do
		if(WindowSoupBowl.windows[i].inUse and WindowSoupBowl.windows[i].obj:IsVisible()) then
			table.insert(windowListByLevel_Recycle, WindowSoupBowl.windows[i].obj);
		end
	end
	table.sort(windowListByLevel_Recycle, function(a,b)
		a, b = a:GetFrameLevel(), b:GetFrameLevel();
		return a>b;
	end);
	return windowListByLevel_Recycle;
end

function getWindowAtCursorPosition(excludeObj)
	-- can optionaly exclude an object
	local x,y = _G.GetCursorPosition();
	local windows = getActiveWindowListByLevel();
	local i;
	for i=1,#windows do
		if(excludeObj ~= windows[i]) then
			local x1, y1 = windows[i]:GetLeft()*windows[i]:GetEffectiveScale(), windows[i]:GetTop()*windows[i]:GetEffectiveScale();
			local x2, y2 = x1 + windows[i]:GetWidth()*windows[i]:GetEffectiveScale(), y1 - windows[i]:GetHeight()*windows[i]:GetEffectiveScale();
			if(x >= x1 and x <= x2 and y <= y1 and y >= y2) then
				return windows[i];
			end
		end
	end
	return nil;
end

-- window resizing helper
local resizeFrame = CreateFrame("Button", "WIM_WindowResizeFrame", _G.UIParent);
resizeFrame:Hide();
resizeFrame.widgetName = "resize";
resizeFrame.Attach = function(self, win)
		if(win.widgets.close ~= GetMouseFocus() and not EditBoxInFocus) then
			self:SetParent(win);
			self.parentWindow = win;
			ApplySkinToWidget(self);
			self:Show();
			resizeFrame:SetFrameLevel(999);
		else
			resizeFrame:Hide();
		end
	end
resizeFrame.Reset = function(self)
		self:SetParent(_G.UIParent);
		self:ClearAllPoints();
		self:SetPoint("TOPLEFT");
		self:Hide();
	end
resizeFrame:SetScript("OnMouseDown", function(self)
		self.isSizing = true;
                self.parentWindow.customSize = true;
		self.parentWindow:SetResizable(true);
		self.parentWindow:StartSizing("BOTTOMRIGHT");
	end);
resizeFrame:SetScript("OnMouseUp", function(self)
		self.isSizing = false;
                self.parentWindow.customSize = true;
		self.parentWindow:StopMovingOrSizing();
		local tabStrip = self.parentWindow.tabStrip;
		if(tabStrip) then
			dPrint("Size sent to tab strip.");
		end
	end);
resizeFrame:SetScript("OnUpdate", function(self)
		if(self.isSizing and self.parentWindow and self.parentWindow.tabStrip) then
			local curSize = self.parentWindow:GetWidth()..self.parentWindow:GetHeight();
			if(self.prevSize ~= curSize) then
				self.parentWindow.tabStrip:UpdateTabs();
				self.prevSize = curSize;
			end
		end
		if(self.parentWindow.isMoving) then
			self:Reset();
		end
	end);


-- helperFrame's purpose is to assist with dragging and dropping of Windows into tab strips.
-- The frame will monitor which window objects are being dragged over and attach itself to them when
-- it's key trigger is pressed.
local helperFrame = CreateFrame("Frame", "WIM_WindowHelperFrame", _G.UIParent);
helperFrame.flash = helperFrame:CreateTexture(helperFrame:GetName().."Flash", "OVERLAY");
helperFrame.flash:SetPoint("BOTTOMLEFT");
helperFrame.flash:SetPoint("BOTTOMRIGHT");
helperFrame.flash:SetHeight(4);
helperFrame.flash:SetBlendMode("ADD");
helperFrame.flash:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
helperFrame:SetFrameStrata("TOOLTIP");
helperFrame:SetWidth(1);
helperFrame:SetHeight(1);
helperFrame.ResetState = function(self)
        helperFrame:ClearAllPoints();
	helperFrame:SetParent(UIPanel);
        helperFrame:SetWidth(1);
        helperFrame:SetHeight(1);
        helperFrame:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", 0, 0);
	helperFrame.isAttached = false;
        helperFrame.attachedTo = nil;
    end
helperFrame:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", 0, 0);
helperFrame:SetScript("OnUpdate", function(self)
                if(IsShiftKeyDown()) then
			local obj = GetMouseFocus();
			if(obj and (obj.isWimWindow or obj.parentWindow)) then
				local win;
				if(obj.isWimWindow) then
					win = obj;
				else
					win = obj.parentWindow;
				end
				resizeFrame:Attach(win);
				if(win.isMoving and not (win.tabStrip and win.tabStrip:IsVisible())) then
				local mWin = getWindowAtCursorPosition(win);
					if(not self.isAttached) then
						if(mWin) then
							-- attach to window
							local skinTable = GetSelectedSkin().tab_strip;
							self.parentWindow = mWin;
							self.attachedTo = mWin;
							mWin.helperFrame = helperFrame;
							self:SetParent(mWin);
							SetWidgetRect(self, skinTable);
							self:SetHeight(self.flash:GetHeight());
							self.isAttached = true;
						end
					elseif(self.isAttached and mWin ~= self.attachedTo) then
						self:ResetState();
					end
				else
					if(self.isAttached) then
						self:ResetState();
					end
				end
			else
				resizeFrame:Reset();
				if(self.isAttached) then
					self:ResetState();
				end
			end
                else
		    resizeFrame:Reset();
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


local function executeHandlers(WidgetName, wType, HandlerName, ...)
	local tbl, fun;
	if(Widget_Triggers[WidgetName] and Widget_Triggers[WidgetName][HandlerName] and Widget_Triggers[WidgetName][HandlerName][wType]) then
		tbl = Widget_Triggers[WidgetName][HandlerName][wType];
	end
	if(type(tbl) == "table") then
		for i=1,#tbl do
			fun = tbl[i];
			fun(...);
		end
	end
end

--Returns object, SoupBowl_windows_index or nil if window can not be found.
local function getWindowBy(userName)
    if(type(userName) ~= "string") then
        return nil;
    end
    for i=1,#WindowSoupBowl.windows do
        if(WindowSoupBowl.windows[i].user == userName) then
            return WindowSoupBowl.windows[i].obj, i;
        end
    end
end

-- climb up inherritance tree and find parent window recursively.
local function getParentMessageWindow(obj)
    if(not obj) then
	return nil;
    elseif(obj.isParent) then
        return obj;
    elseif(obj.parentWindow) then
	return obj.parentWindow;
    elseif(obj:GetName() == "UIParent") then
        return nil;
    else
        return getParentMessageWindow(obj:GetParent())
    end
end

local function setWindowAsFadedIn(obj)
	if(WIM.db.winFade) then
		obj.delayFadeElapsed = 0;
		obj.delayFade = true;
		obj.fadedIn = true;
		UIFrameFadeIn(obj, FadeProps.interval, obj:GetAlpha(), FadeProps.max)
	else
		obj:SetAlpha(FadeProps.max);
	end
end

--------------------------------------
--       Widget Script Handlers     --
--------------------------------------

function updateScrollBars(parentWindow)
	if(parentWindow.widgets.chat_display:AtTop()) then
		parentWindow.widgets.scroll_up:Disable();
	else
		parentWindow.widgets.scroll_up:Enable();
	end
	if(parentWindow.widgets.chat_display:AtBottom()) then
		parentWindow.widgets.scroll_down:Disable();
	else
		parentWindow.widgets.scroll_down:Enable();
	end
end

local function MessageWindow_MovementControler_OnDragStart(self)
    local window = getParentMessageWindow(self);
    if(window) then
        window:StartMoving();
        window.isMoving = true;
    end
end

local function MessageWindow_MovementControler_OnDragStop(self)
    local window = getParentMessageWindow(self);
    if(window) then
	local dropTo = helperFrame.attachedTo;
	helperFrame:ResetState();
        window:StopMovingOrSizing();
        window.isMoving = false;
	if(dropTo) then
		if(window.tabStrip) then
			window.tabStrip:Detach(window.theUser);
		end
		if(dropTo.tabStrip) then
			dropTo.tabStrip:Attach(window.theUser);
		else
			local tabStrip = GetAvailableTabGroup();
			tabStrip:Attach(dropTo.theUser);
			tabStrip:Attach(window.theUser);
		end
	end
    end
end

-- this needs to be looked at. it isn't doing anything atm...
local function MessageWindow_Frame_OnShow(self)
        if(db.autoFocus == true) then
		--_G[self:GetName().."MsgBox"]:SetFocus();
        end
        updateScrollBars(self);
        if(self.tabStrip) then
                self.tabStrip:JumpToTabName(self.theUser);
        end
	for widgetName, widgetObj in pairs(self.widgets) do
		if(type(widgetObj.OnWindowShow) == "function") then
			widgetObj:OnWindowShow();
		end
	end
end

-- this needs to be looked at. it isn't doing anything atm...
local function MessageWindow_Frame_OnHide(self)
        if ( self.isMoving ) then
		self:StopMovingOrSizing();
		self.isMoving = false;
        end
        self:ResetAnimation();
	for widgetName, widgetObj in pairs(self.widgets) do
		if(type(widgetObj.OnWindowHide) == "function") then
			widgetObj:OnWindowHide();
		end
        end
end

local function MessageWindow_Frame_OnUpdate(self, elapsed)
	-- window is visible, there aren't any messages waiting...
	self.msgWaiting = false;
	self.unreadCount = 0;
	-- fading segment
	if(db.winFade) then
		self.fadeElapsed = (self.fadeElapsed or 0) + elapsed;
		while(self.fadeElapsed > .1) do
			local window = GetMouseFocus();
			if(window) then
				if(((window == self or window.parentWindow == self  or self.isOnHyperLink or
						self == helperFrame.attachedTo or
						(EditBoxInFocus and EditBoxInFocus.parentWindow == self)) or
						(window.tabStrip and window.tabStrip.selected.obj == self)) and
						(not self.fadedIn or self.delayFade)) then
					self.fadedIn = true;
					self.delayFade = false;
					self.delayFadeElapsed = 0;
					UIFrameFadeIn(self, FadeProps.interval, self:GetAlpha(), FadeProps.max);
				elseif(window ~= self and window.parentWindow ~= self and not self.isOnHyperLink and
						(not (window.tabStrip and window.tabStrip.selected.obj == self)) and
						helperFrame.attachedTo ~= self and
						(not EditBoxInFocus or EditBoxInFocus.parentWindow ~= self) and self.fadedIn) then
					if(self.delayFade) then
						self.delayFadeElapsed = (self.delayFadeElapsed or 0) + elapsed;
						while(self.delayFadeElapsed > FadeProps.delay) do
							self.delayFade = false;
							self.delayFadeElapsed = 0;
						end
					else
						self.fadedIn = false;
						self.delayFadeElapsed = 0;
						UIFrameFadeOut(self, FadeProps.interval, self:GetAlpha(), FadeProps.min);
					end
				end
			end
			self.fadeElapsed = 0;
		end
	elseif(not self.fadedIn) then
                setWindowAsFadedIn(self);
        end
	
	-- animation segment
	if(self.animation.mode) then
		local animate = self.animation;
		if(animate.mode == "HIDE") then
			animate.elapsed = animate.elapsed + elapsed;
			if(animate.elapsed > animate.time) then
				self:Hide_Normal();
			else
				local prct = animate.elapsed/animate.time;
				self:SetScale(db.winSize.scale/100*(1-prct));
				if(animate.to) then
					local x1, y1, x2, y2 = animate.initLeft*self:GetEffectiveScale(), animate.initTop*self:GetEffectiveScale(),
								animate.to:GetLeft()*animate.to:GetEffectiveScale(), animate.to:GetTop()*animate.to:GetEffectiveScale();
					local rise, run = ((y2-y1)>=0) and (y2-y1) or 0, ((x2-x1)>=0) and (x2-x1) or 0;
					self:ClearAllPoints();
					self:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", (x1+run*prct)/self:GetEffectiveScale(), (y1+rise*prct)/self:GetEffectiveScale());
				end
				
			end
		end
	end
end

--local function MessageWindow_MsgBox_OnMouseUp()
--    CloseDropDownMenus();
--    if(arg1 == "RightButton") then
--        WIM_MSGBOX_MENU_CUR_USER = this:GetParent().theUser;
--        UIDropDownMenu_Initialize(WIM_MsgBoxMenu, WIM_MsgBoxMenu_Initialize, "MENU");
--        ToggleDropDownMenu(1, nil, WIM_MsgBoxMenu, this, 0, 0);
--    end
--end



local function loadHandlers(obj)
	local widgets = obj.widgets;
	for widget, tbl in pairs(Widget_Triggers) do
		for handler,_ in pairs(tbl) do
			if(not widgets[widget]:GetScript(handler)) then
				widgets[widget]:SetScript(handler, function(...) executeHandlers(widget, obj.type, handler, ...); end)
			end
		end
	end
end


local function setAllChildrenParentWindow(parent, child)
	local i;
	if(child ~= parent) then
		child.parentWindow = parent;
	end
	local children = {child:GetChildren()};
	for i=1,#children do
		setAllChildrenParentWindow(parent, children[i]);
	end
end

local function loadRegisteredWidgets(obj)
	local widgets = obj.widgets;
	for widget, createFun in pairs(RegisteredWidgets) do
		if(widgets[widget] == nil) then
			if(type(createFun) == "function") then
				widgets[widget]  = createFun(obj);
				widgets[widget].widgetName = widget;
				dPrint("Widget '"..widget.."' added to '"..obj:GetName().."'");
				if(type(widgets[widget].SetDefaults) == "function") then
					widgets[widget]:SetDefaults(); -- load defaults for this widget
				end
			end
		else
			if(type(widgets[widget].SetDefaults) == "function") then
				widgets[widget]:SetDefaults(); -- load defaults for this widget
			end
		end
		--widgets[widget].parentWindow = obj;
		if(type(widgets[widget]) == "table") then
			widgets[widget].parentWindow = obj;
		end
	end
	setAllChildrenParentWindow(obj, obj)
end

local function updateActiveObjects()
	for i=1, #WindowSoupBowl.windows do
		if(WindowSoupBowl.windows[i].inUse) then
			loadRegisteredWidgets(WindowSoupBowl.windows[i].obj);
			loadHandlers(WindowSoupBowl.windows[i].obj);
		end
	end
end

function scaleWindow(self, scale)
	-- scale down window and preserve location
	local left, top = self:GetLeft()*self:GetEffectiveScale(), self:GetTop()*self:GetEffectiveScale();
	local setScale = self.SetScale_Orig or self.SetScale;
	setScale(self, (scale > 0) and scale or 0.00001)
	self:ClearAllPoints();
	self:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", left/self:GetEffectiveScale(), top/self:GetEffectiveScale());
end

-- create all of MessageWindow's object children
local function instantiateWindow(obj)
    local fName = obj:GetName();
    -- set frame's initial properties
    obj:SetClampedToScreen(true);
    obj:SetFrameStrata("DIALOG");
    obj:SetMovable(true);
    obj:SetToplevel(true);
    obj:SetWidth(384);
    obj:SetHeight(256);
    obj:EnableMouse(true);
    obj:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", 25, -125);
    obj:RegisterForDrag("LeftButton");
    obj:SetScript("OnDragStart", MessageWindow_MovementControler_OnDragStart);
    obj:SetScript("OnDragStop", MessageWindow_MovementControler_OnDragStop);
    obj:SetScript("OnMouseUp", MessageWindow_MovementControler_OnDragStop);
    obj:SetScript("OnShow", MessageWindow_Frame_OnShow);
    obj:SetScript("OnHide", MessageWindow_Frame_OnHide);
    obj:SetScript("OnUpdate", MessageWindow_Frame_OnUpdate);
    obj.isWimWindow = true;
    obj.helperFrame = helperFrame;
    obj.animation = {};
    
    obj.SetScale_Orig = obj.SetScale;
    obj.SetScale = scaleWindow;
    
    obj.widgets = {};
    local widgets = obj.widgets;
    
    -- add window backdrop frame
    widgets.Backdrop = CreateFrame("Frame", fName.."Backdrop", obj);
    widgets.Backdrop:SetToplevel(false);
    widgets.Backdrop:SetAllPoints(obj);
    widgets.class_icon = widgets.Backdrop:CreateTexture(fName.."BackdropClassIcon", "BACKGROUND");
    widgets.class_icon.widgetName = "class_icon";
    widgets.class_icon.parentWindow = obj;
    widgets.Backdrop.tl = widgets.Backdrop:CreateTexture(fName.."Backdrop_TL", "BORDER");
    widgets.Backdrop.tr = widgets.Backdrop:CreateTexture(fName.."Backdrop_TR", "BORDER");
    widgets.Backdrop.bl = widgets.Backdrop:CreateTexture(fName.."Backdrop_BL", "BORDER");
    widgets.Backdrop.br = widgets.Backdrop:CreateTexture(fName.."Backdrop_BR", "BORDER");
    widgets.Backdrop.t  = widgets.Backdrop:CreateTexture(fName.."Backdrop_T" , "BORDER");
    widgets.Backdrop.b  = widgets.Backdrop:CreateTexture(fName.."Backdrop_B" , "BORDER");
    widgets.Backdrop.l  = widgets.Backdrop:CreateTexture(fName.."Backdrop_L" , "BORDER");
    widgets.Backdrop.r  = widgets.Backdrop:CreateTexture(fName.."Backdrop_R" , "BORDER");
    widgets.Backdrop.bg = widgets.Backdrop:CreateTexture(fName.."Backdrop_BG", "BORDER");
    widgets.from = widgets.Backdrop:CreateFontString(fName.."BackdropFrom", "OVERLAY", "GameFontNormalLarge");
    widgets.from.widgetName = "from";
    widgets.char_info = widgets.Backdrop:CreateFontString(fName.."BackdropCharacterDetails", "OVERLAY", "GameFontNormal");
    widgets.char_info.widgetName = "char_info";
    
    -- create core window objects
    widgets.close = CreateFrame("Button", fName.."ExitButton", obj);
    widgets.close:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    widgets.close.curTextureIndex = 1;
    widgets.close.parentWindow = obj;
    widgets.close.widgetName = "close";
    
    widgets.scroll_up = CreateFrame("Button", fName.."ScrollUp", obj);
    widgets.scroll_up:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    widgets.scroll_up.widgetName = "scroll_up";
    
    widgets.scroll_down = CreateFrame("Button", fName.."ScrollDown", obj);
    widgets.scroll_down:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    widgets.scroll_down.widgetName = "scroll_down";
    
    widgets.chat_display = CreateFrame("ScrollingMessageFrame", fName.."ScrollingMessageFrame", obj);
    widgets.chat_display:RegisterForDrag("LeftButton");
    widgets.chat_display:SetFading(false);
    widgets.chat_display:SetMaxLines(128);
    widgets.chat_display:SetMovable(true);
    widgets.chat_display:SetScript("OnDragStart", function(self) MessageWindow_MovementControler_OnDragStart(self); end);
    widgets.chat_display:SetScript("OnDragStop", function(self) MessageWindow_MovementControler_OnDragStop(self); end);
    widgets.chat_display:SetScript("OnHyperlinkClick", function(self, ...) _G.SetItemRef(...); end);
    widgets.chat_display:SetScript("OnMessageScrollChanged", function(self) updateScrollBars(self:GetParent()); end);
    widgets.chat_display:SetJustifyH("LEFT");
    widgets.chat_display:EnableMouse(true);
    widgets.chat_display:EnableMouseWheel(1);
    widgets.chat_display.widgetName = "chat_display";
    
    widgets.msg_box = CreateFrame("EditBox", fName.."MsgBox", obj);
    widgets.msg_box:SetAutoFocus(false);
    widgets.msg_box:SetHistoryLines(32);
    widgets.msg_box:SetMaxLetters(255);
    widgets.msg_box:SetAltArrowKeyMode(true);
    widgets.msg_box:EnableMouse(true);
    widgets.msg_box.widgetName = "msg_box";
    
    --Addmessage functions
    obj.AddMessage = function(self, msg, ...)
	msg = applyStringModifiers(msg);
	self.widgets.chat_display:AddMessage(msg, ...);
	CallModuleFunction("OnWindowMessageAdded", self, msg, ...);
    end
    
    obj.AddMessageRaw = function(self, msg, ...)
        self.widgets.chat_display:AddMessage(msg, ...);
    end
    
    obj.AddEventMessage = function(self, r, g, b, event, ...)
	local str = applyMessageFormatting(self.widgets.chat_display, event, ...);
	self:AddMessage(str, r, g, b);
	self.msgWaiting = true;
	self.lastActivity = time();
        self.unreadCount = self.unreadCount and (self.unreadCount + 1) or 1;
    end
    
    obj.UpdateIcon = function(self)
	local icon = self.widgets.class_icon;
	local classTag = obj.class;
	if(self.class == "") then
		classTag = "blank"
	else
		if(constants.classes[self.class]) then
			classTag = string.lower(constants.classes[self.class].tag);
                        classTag = string.gsub(classTag, "f$", "");
		else
			classTag = "blank";
		end
	end
	icon:SetTexCoord(unpack(GetSelectedSkin().message_window.widgets.class_icon[classTag]));
    end
    
    obj.UpdateCharDetails = function(self)
	self.widgets.char_info:SetText(GetSelectedSkin().message_window.widgets.char_info.format(self, self.guild, self.level, self.race, self.class));
    end
    
    obj.WhoCallback = function(result)
	if( result.Online and result.Name == obj.theUser) then
		obj.class = result.Class;
		obj.level = result.Level;
		obj.race = result.Race;
		obj.guild = result.Guild;
		obj.location = result.Zone;
		obj:UpdateIcon();
		obj:UpdateCharDetails();
		if(constants.classes[obj.class] and GetSelectedSkin().message_window.widgets.from.use_class_color) then
			obj.widgets.from:SetTextColor(RGBHexToPercent(constants.classes[obj.class].color));
		end
	end
    end
    
    obj.SendWho = function(self)
	local whoLib = libs.WhoLib;
	if(whoLib) then
		whoLib:UserInfo(self.theUser, 
			{
				queue = whoLib.WHOLIB_QUEUE_QUIET, 
				timeout = 0,
				flags = whoLib.WHOLIB_FLAG_ALLWAYS_CALLBACK,
				callback = self.WhoCallback
			});
	else
		dPrint("WhoLib-1.0 not loaded... Skipping who lookup!");
	end
    end
    
    obj.GetRuleSet = function(self)
        if(db.pop_rules[self.type]) then
                local curState = db.pop_rules[self.type].alwaysOther and "other" or curState
		return db.pop_rules[self.type][curState];
	else
                return db.pop_rules.whisper.other;
        end
    end
    
    -- PopUp rules
    obj.Pop = function(self, msgDirection, forceResult, forceFocus) -- true to force show, false it ignore rules and force quiet.
	-- account for variable arguments.
	if(type(msgDirection) ~= "string" and type(msgDirection) == "boolean") then
		forceResult, forceFocus = msgDirection, forceResult;
		msgDirection = "in";
	elseif(msgDirection == nil) then
		msgDirection = "in";
	end
        
	local rules = self:GetRuleSet(); -- defaults incase unknown
    
	-- pass isNew to pop ruleset.
	if(forceResult ~= nil) then
		-- go by forceResult and ignore rules
		if(forceResult == true) then
			setWindowAsFadedIn(self);
			if(self.tabStrip) then
				self.tabStrip:JumpToTabName(self.theUser);
                                if(rules.autofocus or forceFocus) then
                                        self.widgets.msg_box:SetFocus();
                                end
			else
				self:ResetAnimation();
				self:Show();
                                if((not EditBoxInFocus and rules.autofocus) or forceFocus) then
                                        self.widgets.msg_box:SetFocus();
                                end
				local count = 0;
				for i=1, #WindowSoupBowl.windows do
					count = WindowSoupBowl.windows[i].obj:IsShown() and count + 1 or count;
				end
				if(count > 1) then
					DisplayTutorial(L["Creating Tab Groups"], L["You can group two or many windows together by <Shift-Clicking> a window and dragging it on top of another."]);
				else
					DisplayTutorial(L["Resizing Windows"], L["You can resize a window by holding <Shift> and dragging the bottom right corner of the window."]);
				end
			end
		end
	else
		-- execute pop rules.
		if((rules.onSend and msgDirection == "out") or (rules.onReceive and msgDirection == "in")) then 
			setWindowAsFadedIn(self);
			if(self.tabStrip) then
				self:ResetAnimation();
                                if(EditBoxInFocus ~= self.tabStrip.selected.obj.widgets.msg_box) then
        				self.tabStrip:JumpToTabName(self.theUser);
                                end
			else
				self:ResetAnimation();
				self:Show();
                                if(not EditBoxInFocus and rules.autofocus and msgDirection == "in") then
                                        self.widgets.msg_box:SetFocus();
                                end
			end
		end
	end
	
	-- at this state the message is no longer classified as a new window, reset flag.
	obj.isNew = false;
	CallModuleFunction("OnWindowPopped", self);
    end
    
    obj.UpdateProps = function(self)
	self:SetScale(db.winSize.scale/100);
	self.widgets.Backdrop:SetAlpha(db.windowAlpha/100);
	local Path,_,Flags = self.widgets.chat_display:GetFont();
	self.widgets.chat_display:SetFont(Path,db.fontSize+2,Flags);
	self.widgets.chat_display:SetAlpha(1);
	self.widgets.chat_display:SetIndentedWordWrap(db.wordwrap_indent);
	self.widgets.msg_box:SetAlpha(1);
	self.widgets.msg_box:SetAltArrowKeyMode(db.ignoreArrowKeys);
	
	self.widgets.from:SetAlpha(1);
	self.widgets.char_info:SetAlpha(1);
	self.widgets.close:SetAlpha(db.windowAlpha);
	self.widgets.scroll_up:SetAlpha(db.windowAlpha);
	self.widgets.scroll_down:SetAlpha(db.windowAlpha);
	
	if(db.escapeToHide) then
		AddEscapeWindow(self);
	else
		RemoveEscapeWindow(self);
	end
	
        if(not self.customSize) then
                self:SetWidth(db.winSize.width);
                self:SetHeight(db.winSize.height);
        end
        
	-- process registered widgets
	local widgetName, widgetObj;
	for widgetName, widgetObj in pairs(obj.widgets) do
		if(type(widgetObj.UpdateProps) == "function") then
			widgetObj:UpdateProps();
		end
	end
    end
    
    obj.Hide_Normal = obj.Hide;
    obj.Hide = function(self, animate)
	if(not self:IsShown() or self.animation.mode) then
		-- don't do anything if window is already hidden.
		return;
	end
	if(not animate) then
		self:Hide_Normal();
		self:ResetAnimation();
	else
		if(not db.winAnimation) then
			self:Hide_Normal();
			self:ResetAnimation();
		else
			local a = self.animation;
			obj:SetClampedToScreen(false);
			a.initLeft = self:GetLeft();
			a.initTop = self:GetTop();
			a.to = MinimapIcon;
			a.elapsed, a.time = 0, .5;
			a.mode = "HIDE"; -- this starts the animation
			dPrint("Animation Started: "..self:GetName());
		end
	end
    end
    obj.ResetAnimation = function(self)
	if(self.animation.mode) then
		obj:SetClampedToScreen(true);
		self:SetScale(db.winSize.scale/100);
                self:ClearAllPoints();
		self:SetPoint("TOPLEFT", _G.UIParent, "BOTTOMLEFT", self.animation.initLeft, self.animation.initTop);
		dPrint("Animation Reset: "..self:GetName());
	end
	for key, _ in pairs(self.animation) do
		self.animation[key] = nil;
	end
    end
    
    --enforce that all core widgets have parentWindow set.
	local w;
	for _, w in pairs(obj.widgets) do
		w.parentWindow = obj;
	end
    
    -- load Registered Widgets
    loadRegisteredWidgets(obj);
    loadHandlers(obj);
    
    --local shortcuts = CreateFrame("Frame", fName.."ShortcutFrame", obj);
    --shortcuts:SetToplevel(true);
    --shortcuts:SetFrameStrata("DIALOG");
    --for i=1,ShortcutCount do
    --    CreateFrame("Button", fName.."ShortcutFrameButton"..i, shortcuts, "WIM_ShortcutButtonTemplate");
    --end

end

-- load object into it's default state.
local function loadWindowDefaults(obj)
	obj:Hide();

        obj.age = _G.time();

	obj.lastActivity = time();

        obj.customSize = false;

	obj.guild = "";
	obj.level = "";
	obj.race = "";
	obj.class = "blank";
	obj.location = "";
	obj:UpdateIcon();
    
	obj.isNew = true;

	obj:SetScale(1);
	obj:SetAlpha(1);
    
	obj.widgets.Backdrop:SetAlpha(1);
    
	obj.widgets.from:SetText(obj.theUser);
	obj.widgets.from:SetTextColor(RGBHexToPercent(GetSelectedSkin().message_window.widgets.from.font_color));
    
	obj.widgets.char_info:SetText("");
    
	obj.widgets.msg_box.setText = 0;
	obj.widgets.msg_box:SetText("");
    
	obj.widgets.chat_display:Clear();
	obj.widgets.chat_display:AddMessage("  ");
	obj.widgets.chat_display:AddMessage("  ");
	updateScrollBars(obj);
        
        obj.widgets.close.forceShift = false;
    
	-- load Registered Widgets (if not created already) & set defaults
	loadRegisteredWidgets(obj);
	loadHandlers(obj);
    
	-- process registered widgets
	local widgetName, widgetObj;
	for widgetName, widgetObj in pairs(obj.widgets) do
		if(type(widgetObj.SetDefaults) == "function") then
			widgetObj:SetDefaults();
		end
	end
	ApplySkinToWindow(obj);
	obj:UpdateProps();
end

--Create (recycle if available) message window. Returns object.
-- (wtype == "whisper", "chat" or "w2w")
local function createWindow(userName, wtype)
    if(type(userName) ~= "string") then
        return;
    end
    --if(type(WIM:GetSelectedSkin()) ~= "table") then
    --    WIM:LoadSkin(WIM.db.skin.selected, WIM.db.skin.style);
    --end
    local func = function ()
                        if(WindowSoupBowl.available > 0) then
                            local i;
                            for i=1,#WindowSoupBowl.windows do
                                if(WindowSoupBowl.windows[i].inUse == false) then
                                    return WindowSoupBowl.windows[i].obj, i;
                                end
                            end
                        else
                            return nil;
                        end
                    end
    local obj, index = func();
    if(obj) then
        --object available...
        WindowSoupBowl.available = WindowSoupBowl.available - 1;
        WindowSoupBowl.used = WindowSoupBowl.used + 1;
        WindowSoupBowl.windows[index].inUse = true;
        WindowSoupBowl.windows[index].user = userName;
        obj.theUser = userName;
        obj.type = wtype;
	obj.isGM = IsGM(userName);
        loadWindowDefaults(obj); -- clear contents of window and revert back to it's initial state.
        dPrint("Window recycled '"..obj:GetName().."'");
	CallModuleFunction("OnWindowCreated", obj);
        return obj;
    else
        -- must create new object
        WindowSoupBowl.used = WindowSoupBowl.used + 1;
        WindowSoupBowl.windowToken = WindowSoupBowl.windowToken + 1; --increment token for propper frame name creation.
        local fName = "WIM3_msgFrame"..WindowSoupBowl.windowToken;
        local f = CreateFrame("Frame",fName, _G.UIParent);
        local winTable = {
            user = userName,
            frameName = fName,
            inUse = true,
            obj = f
        };
        table.insert(WindowSoupBowl.windows, winTable);
        f.theUser = userName;
        f.type = wtype;
        f.isParent = true;
	f.isGM = IsGM(userName);
        instantiateWindow(f);
        --f.icon.theUser = userName;
        loadWindowDefaults(f);
        dPrint("Window created '"..f:GetName().."'");
	CallModuleFunction("OnWindowCreated", f);
        return f;
    end
end


--Returns object, SoupBowl_windows_index or nil if window can not be found.
local function getWindowByName(userName)
    if(type(userName) ~= "string") then
        return nil;
    end
    for i=1,#WindowSoupBowl.windows do
        if(WindowSoupBowl.windows[i].user == userName) then
            return WindowSoupBowl.windows[i].obj, i;
        end
    end
end

--Deletes message window and makes it available in the Soup Bowl.
local function destroyWindow(userNameOrObj)
    local obj, index;
    if(type(userNameOrObj) == "string") then
        obj, index = getWindowByName(userNameOrObj);
    else
	obj, index = getWindowByName(userNameOrObj.theUser);
    end
    
    if(obj) then
        WindowSoupBowl.windows[index].inUse = false;
        WindowSoupBowl.windows[index].user = "";
        WindowSoupBowl.available = WindowSoupBowl.available + 1;
        WindowSoupBowl.used = WindowSoupBowl.used - 1;
        --WIM_Astrolabe:RemoveIconFromMinimap(obj.icon);
        --obj.icon:Hide();
        --obj.icon.track = false;
	if(obj.tabStrip) then
		obj.tabStrip:Detach(obj.theUser);
	end
        obj:Show();
        obj.widgets.chat_display:Clear();
        obj:Hide();
	dPrint("Window '"..obj:GetName().."' destroyed.");
	CallModuleFunction("OnWindowDestroyed", obj);
    end
end






function RegisterWidgetTrigger(WidgetName, wType, HandlerName, Function)
	-- config table to handle widget
	if(not Widget_Triggers[WidgetName]) then
		Widget_Triggers[WidgetName] = {}
	end
	--config widget table to handle hander
	if(not Widget_Triggers[WidgetName][HandlerName]) then
		Widget_Triggers[WidgetName][HandlerName] = {
			whisper = {},
			chat = {},
			w2w = {}
		};
	end
	--register to table
	for i=1,select("#", string.split(",", wType)) do
		table.insert(Widget_Triggers[WidgetName][HandlerName][select(i, string.split(",", wType))], Function);
	end
	updateActiveObjects();
end

function GetWindowSoupBowl()
    return WindowSoupBowl;
end

function CreateWhisperWindow(playerName)
    return createWindow(playerName, "whisper");
end

function CreateChatWindow(chatName)
    return createWindow(playerName, "chat");
end

function CreateW2WWindow(chatName)
    return createWindow(playerName, "w2w");
end

function DestroyWindow(playerNameOrObject)
	destroyWindow(playerNameOrObject);
end

function RegisterWidget(widgetName, createFunction, moduleName)
	-- moduleName is optional if not being called from a module.
	RegisteredWidgets[widgetName] = createFunction;
	if(moduleName) then
		modules[widgetName].hasWidget = true;
	end
end

function RegisterStringModifier(fun, prioritize)
	addToTableUnique(StringModifiers, fun, prioritize);
end

function UnregisterStringModifier(fun)
	removeFromTable(StringModifiers, fun);
end

function RegisterMessageFormatting(name, fun)
	table.insert(FormattingCalls, {
		name = name,
		fun = fun
	});
	table.insert(FormattingCallsList, name);
end

function GetMessageFormattingList()
	return FormattingCallsList;
end

function HideAllWindows(type)
	type = type and string.lower(type) or nil;
	for i=1, #WindowSoupBowl.windows do
		if(WindowSoupBowl.windows[i].inUse and WindowSoupBowl.windows[i].obj.type == (type or WindowSoupBowl.windows[i].obj.type)) then
			WindowSoupBowl.windows[i].obj:Hide(true);
		end
	end
end

function ShowAllWindows(type)
	type = type and string.lower(type) or nil;
	for i=1, #WindowSoupBowl.windows do
		if(WindowSoupBowl.windows[i].inUse and WindowSoupBowl.windows[i].obj.type == (type or WindowSoupBowl.windows[i].obj.type)) then
			WindowSoupBowl.windows[i].obj:Pop(true);
		end
	end
end

function UpdateAllWindowProps()
	for i=1, #WindowSoupBowl.windows do
		if(WindowSoupBowl.windows[i].inUse) then
			WindowSoupBowl.windows[i].obj:UpdateProps();
		end
	end
end

function AddEscapeWindow(frame)
	for i=1, #_G.UISpecialFrames do 
		if(_G.UISpecialFrames[i] == frame:GetName()) then
			return;
		end
	end
	table.insert(_G.UISpecialFrames, frame:GetName());
end

function RemoveEscapeWindow(frame)
	for i=1, #_G.UISpecialFrames do 
		if(_G.UISpecialFrames[i] == frame:GetName()) then
			table.remove(_G.UISpecialFrames, i);
			return;
		end
	end
end
----------------------------------
-- Set default widget triggers	--
----------------------------------

RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnEnter", function(self)
		if(db.showToolTips == true) then
			_G.GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
			_G.GameTooltip:SetText(L["<Shift-Click> to close window."]);
		end
	end);
	
RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnLeave", function(self) _G.GameTooltip:Hide(); end);
	
RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnClick", function(self)
		if(IsShiftKeyDown() or self.forceShift) then
			destroyWindow(self:GetParent());
		else
			DisplayTutorial(L["Message Window Hidden"], L["WIM's message window has been hidden to WIM's Minimap Icon. If you want to end a conversation, you may do so by <Shift-Clicking> the close button."]);
			self:GetParent():Hide(true);
		end
	end);
	
RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnUpdate", function(self)
                local SelectedSkin = WIM:GetSelectedSkin();
		if(GetMouseFocus() == self) then
			if(IsShiftKeyDown() and self.curTextureIndex == 1) then
				self:SetNormalTexture(SelectedSkin.message_window.widgets.close.state_close.NormalTexture);
				self:SetPushedTexture(SelectedSkin.message_window.widgets.close.state_close.PushedTexture);
				self:SetHighlightTexture(SelectedSkin.message_window.widgets.close.state_close.HighlightTexture, SelectedSkin.message_window.widgets.close.state_close.HighlightAlphaMode);
				self.curTextureIndex = 2;
			elseif(not IsShiftKeyDown() and self.curTextureIndex == 2) then
				self:SetNormalTexture(SelectedSkin.message_window.widgets.close.state_hide.NormalTexture);
				self:SetPushedTexture(SelectedSkin.message_window.widgets.close.state_hide.PushedTexture);
				self:SetHighlightTexture(SelectedSkin.message_window.widgets.close.state_hide.HighlightTexture, SelectedSkin.message_window.widgets.close.state_hide.HighlightAlphaMode);
				self.curTextureIndex = 1;
			end
		elseif(self.curTextureIndex == 2) then
			self:SetNormalTexture(SelectedSkin.message_window.widgets.close.state_hide.NormalTexture);
			self:SetPushedTexture(SelectedSkin.message_window.widgets.close.state_hide.PushedTexture);
			self:SetHighlightTexture(SelectedSkin.message_window.widgets.close.state_hide.HighlightTexture, SelectedSkin.message_window.widgets.close.state_hide.HighlightAlphaMode);
			self.curTextureIndex = 1;
		end
	end);

RegisterWidgetTrigger("scroll_up", "whisper,chat,w2w", "OnClick", function(self)
		local obj = self:GetParent();
		if( _G.IsControlKeyDown() ) then
			obj.widgets.chat_display:ScrollToTop();
		else
			if( _G.IsShiftKeyDown() ) then
			    obj.widgets.chat_display:PageUp();
			else
			    obj.widgets.chat_display:ScrollUp();
			end
		end
		updateScrollBars(obj);
	end);

RegisterWidgetTrigger("scroll_down", "whisper,chat,w2w", "OnClick", function(self)
		local obj = self:GetParent();
		if( _G.IsControlKeyDown() ) then
			obj.widgets.chat_display:ScrollToBottom();
		else
			if( _G.IsShiftKeyDown() ) then
			    obj.widgets.chat_display:PageDown();
			else
			    obj.widgets.chat_display:ScrollDown();
			end
		end
		updateScrollBars(obj);
	end);

RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnMouseWheel", function(self, ...)
	    if(select(1, ...) > 0) then
		if( _G.IsControlKeyDown() ) then
		    self:ScrollToTop();
		else
		    if( _G.IsShiftKeyDown() ) then
			self:PageUp();
		    else
			self:ScrollUp();
		    end
		end
	    else
		if( _G.IsControlKeyDown() ) then
		    self:ScrollToBottom();
		else
		    if( _G.IsShiftKeyDown() ) then
	                self:PageDown();
		    else
			self:ScrollDown();
		    end
		end
	    end
	    updateScrollBars(getParentMessageWindow(self));
	end);

RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnMouseDown", function(self)
	    self:GetParent().prevLeft = self:GetParent():GetLeft();
	    self:GetParent().prevTop = self:GetParent():GetTop();
	end);

RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnMouseUp", function(self)
	    if(self:GetParent().prevLeft == self:GetParent():GetLeft() and self:GetParent().prevTop == self:GetParent():GetTop()) then
		--[ Frame was clicked not dragged
		local msg_box = self:GetParent().widgets.msg_box;
		if(EditBoxInFocus == nil) then
		    msg_box:SetFocus();
		else
		    if(EditBoxInFocus == msg_box) then
			msg_box:Hide();
			msg_box:Show();
		    else
			msg_box:SetFocus();
		    end
		end
	    end
	end);
	
RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnHyperlinkEnter", function(self)
			local obj = self.parentWindow;
			obj.isOnHyperLink = true;
		end)
		
RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnHyperlinkLeave", function(self)
			local obj = self.parentWindow;
			obj.isOnHyperLink = false;
		end)

RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEnterPressed", function(self)
		if(strsub(self:GetText(), 1, 1) == "/") then
			EditBoxInFocus = nil;
			_G.ChatFrameEditBox:SetText(self:GetText());
			_G.ChatEdit_SendText(_G.ChatFrameEditBox, 1);
			self:SetText("");
			EditBoxInFocus = self;
		else
                        if(self:GetText() == "") then
				self:Hide();
				self:Show();
                                return;
			end
                end
                -- keep focus or not
                if(self:GetParent():GetRuleSet().keepfocus) then
                        self:SetFocus();
                else
                        self:Hide();
			self:Show();
                end
                
	end);
	
RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEscapePressed", function(self)
		self:SetText("");
		self:Hide();
		self:Show();
	end);
	
RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnUpdate", function(self)
		if(self.setText == 1) then
			self.setText = 0;
			self:SetText("");
		end
	end);
	
RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEditFocusGained", function(self) EditBoxInFocus = self; end);
RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEditFocusLost", function(self) EditBoxInFocus = nil; end);


RegisterMessageFormatting(L["Default"], function(smf, event, ...)
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
		if(event == "CHAT_MSG_WHISPER") then
			arg11 = arg11 or 0;
			return "[|Hplayer:"..arg2..":"..arg11.."|h"..arg2.."|h]: "..arg1;
		elseif(event == "CHAT_MSG_WHISPER_INFORM") then
			return "[|Hplayer:".._G.UnitName("player").."|h".._G.UnitName("player").."|h]: "..arg1;
		else
			return "Unknown event received...";
		end
	end);

RegisterMessageFormatting(L["Test 1"], function(smf, event, ...)
		local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11 = ...;
		if(event == "CHAT_MSG_WHISPER") then
			arg11 = arg11 or 0;
			return "<|Hplayer:"..arg2..":"..arg11.."|h"..arg2.."|h>: "..arg1;
		elseif(event == "CHAT_MSG_WHISPER_INFORM") then
			return "<|Hplayer:".._G.UnitName("player").."|h".._G.UnitName("player").."|h>: "..arg1;
		else
			return "Unknown event received...";
		end
	end);


