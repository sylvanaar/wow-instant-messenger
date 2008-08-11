local WIM = WIM;

-- load message window related default settings.
WIM.db_defaults.displayColors = {
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
WIM.db_defaults.fontSize = 12;
WIM.db_defaults.windowSize = 1;
WIM.db_defaults.windowAlpha = .8;
WIM.db_defaults.windowOnTop = true;
WIM.db_defaults.keepFocus = true;
WIM.db_defaults.keepFocusRested = true;
WIM.db_defaults.autoFocus = false;
WIM.db_defaults.winSize = {
		width = 384,
		height = 256
	};
WIM.db_defaults.winLoc = {
		left =242 ,
		top =775
	};
WIM.db_defaults.winCascade = {
		enabled = true,
		direction = "downright"
	};
WIM.db_defaults.winFade = true;


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

-- the following table defines a list of actions to be taken when
-- script handlers are fired for different type windows.
-- use WIM:RegisterWidgetTrigger(WindowType, ScriptEvent, function());
local Widget_Triggers = {};


local RegisteredWidgets = {}; -- a list of registered widgets added to windows from modules.
WIM.windows.widgets = RegisteredWidgets;

-- Sample Widget with triggers
RegisteredWidgets["Test"] = function(parentWindow)
	DEFAULT_CHAT_FRAME:AddMessage("Test Widget created!");
	local t = CreateFrame("Frame");
	t.SetDefaults = function()
			DEFAULT_CHAT_FRAME:AddMessage("Test Widget defaults set!");
		end
	t.UpdateProps = function()
			DEFAULT_CHAT_FRAME:AddMessage("Test Widget props updated!");
		end
	return t;
end

local windowListByLevel_Recycle = {};
local function getActiveWindowListByLevel()
	-- first remove items from previously used list.
	local i;
	for i=1,table.getn(windowListByLevel_Recycle) do
		table.remove(windowListByLevel_Recycle, 1);
	end
	-- load all used windows into table
	for i=1, table.getn(WindowSoupBowl.windows) do
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
	local x,y = GetCursorPosition();
	local windows = getActiveWindowListByLevel();
	local i;
	for i=1,table.getn(windows) do
		if(excludeObj ~= windows[i]) then
			local x1, y1 = windows[i]:GetLeft(), windows[i]:GetTop();
			local x2, y2 = x1 + windows[i]:GetWidth(), y1 - windows[i]:GetHeight();
			if(x >= x1 and x <= x2 and y <= y1 and y >= y2) then
				return windows[i];
			end
		end
	end
	return nil;
end

-- helperFrame's purpose is to assist with dragging and dropping of Windows into tab strips.
-- The frame will monitor which window objects are being dragged over and attach itself to them when
-- it's key trigger is pressed.
local helperFrame = CreateFrame("Frame", "WIM_WindowHelperFrame", UIParent);
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
        helperFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
	helperFrame.isAttached = false;
        helperFrame.attachedTo = nil;
    end
helperFrame:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 0, 0);
helperFrame:SetScript("OnUpdate", function()
                if(IsShiftKeyDown()) then
			local obj = GetMouseFocus();
			if(obj and (obj.isWimWindow or obj.parentWindow)) then
				local win;
				if(obj.isWimWindow) then
					win = obj;
				else
					win = obj.parentWindow;
				end
				if(win.isMoving and not (win.tabStrip and win.tabStrip:IsVisible())) then
				local mWin = getWindowAtCursorPosition(win);
					if(not this.isAttached) then
						if(mWin) then
							-- attach to window
							local skinTable = WIM:GetSelectedSkin().tab_strip;
							this.attachedTo = mWin;
							mWin.helperFrame = helperFrame;
							this:ClearAllPoints();
							this:SetParent(mWin);
							this:SetPoint(skinTable.rect.anchor_points.self, mWin, skinTable.rect.anchor_points.relative, skinTable.rect.offsets.margins.left, skinTable.rect.offsets.top);
							this:SetWidth(win:GetWidth() - skinTable.rect.offsets.margins.left - skinTable.rect.offsets.margins.right);
							this:SetHeight(this.flash:GetHeight());
							this.isAttached = true;
						end
					elseif(this.isAttached and mWin ~= this.attachedTo) then
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

local function executeHandlers(WidgetName, wType, HandlerName, ...)
	local tbl, fun;
	if(Widget_Triggers[WidgetName] and Widget_Triggers[WidgetName][HandlerName] and Widget_Triggers[WidgetName][HandlerName][wType]) then
		tbl = Widget_Triggers[WidgetName][HandlerName][wType];
	end
	if(type(tbl) == "table") then
		for i=1,table.getn(tbl) do
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
    for i=1,table.getn(WindowSoupBowl.windows) do
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

local function MessageWindow_MovementControler_OnDragStart()
    local window = getParentMessageWindow(this);
    if(window) then
        window:StartMoving();
        window.isMoving = true;
    end
end

local function MessageWindow_MovementControler_OnDragStop()
    local window = getParentMessageWindow(this);
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
			local tabStrip = WIM:GetAvailableTabGroup();
			tabStrip:Attach(dropTo.theUser);
			tabStrip:Attach(window.theUser);
		end
	end
    end
end

local function MessageWindow_Frame_OnShow()
    local user = this.theUser;
    if(user ~= nil and WIM.windows[user]) then
        WIM.windows[user].newMSG = false;
        WIM.windows[user].is_visible = true;
        if(WIM.db.autoFocus == true) then
		getglobal(this:GetName().."MsgBox"):SetFocus();
        end
        --WIM_WindowOnShow(this);
        updateScrollBars(this);
	local widgetName, widgetObj;
	for widgetName, widgetObj in pairs(obj.widgets) do
		if(type(widgetObj.OnWindowShow) == "function") then
			widgetObj:OnWindowShow();
		end
	end
    end
end

local function MessageWindow_Frame_OnHide()
    local user = this.theUser;
    if(user ~= nil and WIM.windows[user]) then
        --WIM_Tabs.lastParent = nil;
        --WIM_TabStrip:Hide();
        this.isMouseOver = false;
        if(WIM.windows[user]) then
            WIM.windows[user].is_visible = false;
        end
        if ( this.isMoving ) then
		this:StopMovingOrSizing();
		this.isMoving = false;
        end
	local widgetName, widgetObj;
	for widgetName, widgetObj in pairs(obj.widgets) do
		if(type(widgetObj.OnWindowHide) == "function") then
			widgetObj:OnWindowHide();
		end
	end
    end
end

local function MessageWindow_Frame_OnUpdate(event, elapsed)
	-- window is visible, there aren't any messages waiting...
	this.msgWaiting = false;
	
	-- fading segment
	if(WIM.db.winFade) then
		this.fadeElapsed = (this.fadeElapsed or 0) + elapsed;
		while(this.fadeElapsed > .1) do
			local window = GetMouseFocus();
			if(window) then
				if(((window == this or window.parentWindow == this  or this.isOnHyperLink or
						this == helperFrame.attachedTo or
						(WIM.EditBoxInFocus and WIM.EditBoxInFocus.parentWindow == this)) or
						(window.tabStrip and window.tabStrip.selected.obj == this)) and
						(not this.fadedIn or this.delayFade)) then
					this.fadedIn = true;
					this.delayFade = false;
					this.delayFadeElapsed = 0;
					UIFrameFadeIn(this, FadeProps.interval, this:GetAlpha(), FadeProps.max);
				elseif(window ~= this and window.parentWindow ~= this and not this.isOnHyperLink and
						(not (window.tabStrip and window.tabStrip.selected.obj == this)) and
						helperFrame.attachedTo ~= this and
						(not WIM.EditBoxInFocus or WIM.EditBoxInFocus.parentWindow ~= this) and this.fadedIn) then
					if(this.delayFade) then
						this.delayFadeElapsed = (this.delayFadeElapsed or 0) + elapsed;
						while(this.delayFadeElapsed > FadeProps.delay) do
							this.delayFade = false;
							this.delayFadeElapsed = 0;
						end
					else
						this.fadedIn = false;
						this.delayFadeElapsed = 0;
						UIFrameFadeOut(this, FadeProps.interval, this:GetAlpha(), FadeProps.min);
					end
				end
			end
			this.fadeElapsed = 0;
		end
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



--local function MessageWindow_MsgBox_OnMouseUp()
--    CloseDropDownMenus();
--    if(arg1 == "RightButton") then
--        WIM_MSGBOX_MENU_CUR_USER = this:GetParent().theUser;
--        UIDropDownMenu_Initialize(WIM_MsgBoxMenu, WIM_MsgBoxMenu_Initialize, "MENU");
--        ToggleDropDownMenu(1, nil, WIM_MsgBoxMenu, this, 0, 0);
--    end
--end


--local function MessageWindow_MsgBox_OnTabPressed()
--    --cycle through windows
--    if(WIM_Tabs.enabled == true) then
--        if(IsShiftKeyDown()) then
--            WIM_TabStep(-1);
--        else
--            WIM_TabStep(1);
--        end
--    else
--        WIM_ToggleWindow_Toggle();
--    end
--end

--local function MessageWindow_MsgBox_OnTextChanged()
    --[[if(WIM_W2W[this:GetParent().theUser]) then
	if(not this.w2w_typing) then 
	    this.w2w_typing = 0;
	end
	if(this:GetText() ~= "") then
	    if(time() - this.w2w_typing > 2) then
		this.w2w_typing = time();
                if(WIM.db.w2w.typing) then
        	    --WIM_W2W_SendAddonMessage(this:GetParent().theUser , "IS_TYPING#TRUE");
                end
	    end
	else
	    this.w2w_typing = 0;
            if(WIM.db.w2w.typing) then
                --WIM_W2W_SendAddonMessage(this:GetParent().theUser , "IS_TYPING#FALSE");
            end
	end
    end]]
    --WIM_EditBox_OnChanged();
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
	for i=1,table.getn(children) do
		setAllChildrenParentWindow(parent, children[i]);
	end
end

local function loadRegisteredWidgets(obj)
	local widgets = obj.widgets;
	for widget, createFun in pairs(RegisteredWidgets) do
		if(widgets[widget] == nil) then
			if(type(createFun) == "function") then
				widgets[widget]  = createFun(obj);
				WIM:dPrint("Widget '"..widget.."' added to '"..obj:GetName().."'");
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
	for i=1, table.getn(WindowSoupBowl.windows) do
		if(WindowSoupBowl.windows[i].inUse) then
			loadRegisteredWidgets(WindowSoupBowl.windows[i].obj);
			loadHandlers(WindowSoupBowl.windows[i].obj);
		end
	end
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
    obj:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 25, -125);
    obj:RegisterForDrag("LeftButton");
    obj:SetScript("OnDragStart", function() MessageWindow_MovementControler_OnDragStart(); end);
    obj:SetScript("OnDragStop", function() MessageWindow_MovementControler_OnDragStop(); end);
    obj:SetScript("OnMouseUp", function() MessageWindow_MovementControler_OnDragStop(); end);
    obj:SetScript("OnShow", MessageWindow_Frame_OnShow);
    obj:SetScript("OnHide", MessageWindow_Frame_OnHide);
    obj:SetScript("OnUpdate", MessageWindow_Frame_OnUpdate);
    obj.isWimWindow = true;
    obj.helperFrame = helperFrame;
    
    --obj.icon = createMipmapDodad(fName);
    
    --obj.w2w_menu = CreateFrame("Frame", fName.."W2WMenu", obj, "UIDropDownMenuTemplate");
    --obj.w2w_menu:SetClampedToScreen(true);
    
    
    obj.widgets = {};
    local widgets = obj.widgets;
    
    -- add window backdrop frame
    widgets.Backdrop = CreateFrame("Frame", fName.."Backdrop", obj);
    widgets.Backdrop:SetToplevel(false);
    widgets.Backdrop:SetAllPoints(obj);
    widgets.class_icon = widgets.Backdrop:CreateTexture(fName.."BackdropClassIcon", "BACKGROUND");
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
    widgets.char_info = widgets.Backdrop:CreateFontString(fName.."BackdropCharacterDetails", "OVERLAY", "GameFontNormal");
    
    -- create core window objects
    widgets.close = CreateFrame("Button", fName.."ExitButton", obj);
    widgets.close:RegisterForClicks("LeftButtonUp", "RightButtonUp");

    --buttons.history = CreateFrame("Button", fName.."HistoryButton", obj);
    --history:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    --history:SetScript("OnEnter", MessageWindow_HistoryButton_OnEnter);
    --history:SetScript("OnLeave", MessageWindow_HistoryButton_OnLeave);
    --history:SetScript("OnClick", MessageWindow_HistoryButton_OnClick);

    --local w2w = CreateFrame("Button", fName.."W2WButton", obj);
    --w2w:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    --w2w:SetScript("OnEnter", MessageWindow_W2WButton_OnEnter);
    --w2w:SetScript("OnLeave", MessageWindow_W2WButton_OnLeave);
    --w2w:SetScript("OnClick", MessageWindow_W2WButton_OnClick);
    
    --local chatting = CreateFrame("Button", fName.."IsChattingButton", obj);
    --chatting:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    --chatting:SetScript("OnEnter", MessageWindow_IsChattingButton_OnEnter);
    --chatting:SetScript("OnLeave", MessageWindow_IsChattingButton_OnLeave);
    --chatting:SetScript("OnUpdate", MessageWindow_IsChattingButton_OnUpdate);
    --chatting.time_elapsed = 0;
    --chatting.typing_stamp = 0;
    
    widgets.scroll_up = CreateFrame("Button", fName.."ScrollUp", obj);
    widgets.scroll_up:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    
    widgets.scroll_down = CreateFrame("Button", fName.."ScrollDown", obj);
    widgets.scroll_down:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    
    widgets.chat_display = CreateFrame("ScrollingMessageFrame", fName.."ScrollingMessageFrame", obj);
    widgets.chat_display:RegisterForDrag("LeftButton");
    widgets.chat_display:SetFading(false);
    widgets.chat_display:SetMaxLines(128);
    widgets.chat_display:SetMovable(true);
    widgets.chat_display:SetScript("OnDragStart", function() MessageWindow_MovementControler_OnDragStart(); end);
    widgets.chat_display:SetScript("OnDragStop", function() MessageWindow_MovementControler_OnDragStop(); end);
    widgets.chat_display:SetScript("OnHyperlinkClick", function() ChatFrame_OnHyperlinkShow(arg1, arg2, arg3); end);
    widgets.chat_display:SetScript("OnMessageScrollChanged", function() updateScrollBars(this:GetParent()); end);
    widgets.chat_display:SetJustifyH("LEFT");
    widgets.chat_display:EnableMouse(true);
    widgets.chat_display:EnableMouseWheel(1);
    
    widgets.msg_box = CreateFrame("EditBox", fName.."MsgBox", obj);
    widgets.msg_box:SetAutoFocus(false);
    widgets.msg_box:SetHistoryLines(32);
    widgets.msg_box:SetMaxLetters(255);
    widgets.msg_box:SetAltArrowKeyMode(true);
    widgets.msg_box:EnableMouse(true);
    
    --Addmessage functions
    obj.AddMessage = function(self, ...)
	obj.widgets.chat_display:AddMessage(...);
    end
    
    obj.AddUserMessage = function(self, user, msg, ...)
	local str = user.." - "..msg;
	obj:AddMessage(str, ...);
	obj.msgWaiting = true;
    end
    
    obj.UpdateIcon = function(self)
	local icon = obj.widgets.class_icon;
	local classTag = obj.class;
	if(obj.class == "") then
		classTag = "blank"
	else
		if(WIM.constants.classes[obj.class]) then
			classTag = string.lower(WIM.constants.classes[obj.class].tag);
		else
			classTag = "blank";
		end
	end
	local coord = WIM:GetSelectedSkin().message_window.class_icon[classTag];
	icon:SetTexCoord(coord[1], coord[2], coord[3], coord[4], coord[5], coord[6], coord[7], coord[8]);
    end
    
    obj.UpdateCharDetails = function(self)
	obj.widgets.char_info:SetText(WIM:GetSelectedSkin().message_window.strings.char_info.format(obj.guild, obj.level, obj.race, obj.class));
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
	end
    end
    
    obj.SendWho = function(self)
	local whoLib = WIM.libs.WhoLib;
	if(whoLib) then
		whoLib:UserInfo(obj.theUser, 
			{
				queue = whoLib.WHOLIB_QUEUE_QUIET, 
				timeout = 0,
				flags = whoLib.WHOLIB_FLAG_ALLWAYS_CALLBACK,
				callback = obj.WhoCallback
			});
	else
		WIM:dPrint("WhoLib-1.0 not loaded... Skipping who lookup!");
	end
    end
    
    -- PopUp rules
    obj.Pop = function(self, msgDirection, forceResult) -- true to force show, false it ignore rules and force quiet.
	-- account for variable arguments.
	if(type(msgDirection) ~= "string" and type(msgDirection) == "boolean") then
		forceResult = msgDirection;
		msgDirection = "in";
	elseif(msgDirection == nil) then
		msgDirection = "in";
	end
    
	-- pass isNew to pop ruleset.
	if(obj.isNew) then
		obj:SendWho();
	end
	if(forceResult ~= nil) then
		-- go by forceResult and ignore rules
		if(forceResult == true) then
			setWindowAsFadedIn(obj);
			if(obj.tabStrip) then
				obj.tabStrip:JumpToTabName(obj.theUser);
			else
				obj:Show();
			end
		end
	else
		-- execute pop rules.
		local rules = WIM.db.whispers.pop_rules[WIM.curState]; -- defaults incase unknown
		if(obj.type == "whisper") then
			rules = WIM.db.whispers.pop_rules[WIM.curState];
		end
		if((rules.onSend and msgDirection == "out") or
				(rules.onReceive and msgDirection == "in") or
				(rules.onNew and obj.isNew and msgDirection == "in")) then 
			setWindowAsFadedIn(obj);
			if(obj.tabStrip) then
				obj.tabStrip:JumpToTabName(obj.theUser);
			else
				obj:Show();
			end
		end
	end
	
	-- at this state the message is no longer classified as a new window, reset flag.
	obj.isNew = false;
    end
    
    obj.UpdateProps = function(self)
	obj:SetScale(WIM.db.windowSize);
	obj.widgets.Backdrop:SetAlpha(WIM.db.windowAlpha);
	local Path,_,Flags = obj.widgets.chat_display:GetFont();
	obj.widgets.chat_display:SetFont(Path,WIM.db.fontSize+2,Flags);
	obj.widgets.chat_display:SetAlpha(1);
	obj.widgets.msg_box:SetAlpha(1);
	obj.widgets.msg_box:SetAltArrowKeyMode(WIM.db.ignoreArrowKeys);
	
	obj.widgets.from:SetAlpha(1);
	obj.widgets.char_info:SetAlpha(1);
	obj.widgets.close:SetAlpha(WIM.db.windowAlpha);
	obj.widgets.scroll_up:SetAlpha(WIM.db.windowAlpha);
	obj.widgets.scroll_down:SetAlpha(WIM.db.windowAlpha);
	
	-- process registered widgets
	local widgetName, widgetObj;
	for widgetName, widgetObj in pairs(obj.widgets) do
		if(type(widgetObj.UpdateProps) == "function") then
			widgetObj:UpdateProps();
		end
	end
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
    
	obj.widgets.char_info:SetText("");
    
	obj.widgets.msg_box.setText = 0;
	obj.widgets.msg_box:SetText("");
    
	obj.widgets.chat_display:Clear();
	obj.widgets.chat_display:AddMessage("  ");
	obj.widgets.chat_display:AddMessage("  ");
	updateScrollBars(obj);
    
	-- load Registered Widgets (if not created already) & set defaults
	loadRegisteredWidgets(obj);
	loadHandlers(obj);
    
	WIM:ApplySkinToWindow(obj);
	-- process registered widgets
	local widgetName, widgetObj;
	for widgetName, widgetObj in pairs(obj.widgets) do
		if(type(widgetObj.SetDefaults) == "function") then
			widgetObj:SetDefaults();
		end
	end
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
                            for i=1,table.getn(WindowSoupBowl.windows) do
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
	obj.isGM = WIM:IsGM(userName);
        loadWindowDefaults(obj); -- clear contents of window and revert back to it's initial state.
        WIM:dPrint("Window recycled '"..obj:GetName().."'");
        return obj;
    else
        -- must create new object
        WindowSoupBowl.used = WindowSoupBowl.used + 1;
        WindowSoupBowl.windowToken = WindowSoupBowl.windowToken + 1; --increment token for propper frame name creation.
        local fName = "WIM3_msgFrame"..WindowSoupBowl.windowToken;
        local f = CreateFrame("Frame",fName, UIParent);
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
	f.isGM = WIM:IsGM(userName);
        instantiateWindow(f);
        --f.icon.theUser = userName;
        loadWindowDefaults(f);
        WIM:dPrint("Window created '"..f:GetName().."'");
        return f;
    end
end


--Returns object, SoupBowl_windows_index or nil if window can not be found.
local function getWindowByName(userName)
    if(type(userName) ~= "string") then
        return nil;
    end
    for i=1,table.getn(WindowSoupBowl.windows) do
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
	WIM:dPrint("Window '"..obj:GetName().."' destroyed.");
    end
end






function WIM:RegisterWidgetTrigger(WidgetName, wType, HandlerName, Function)
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

function WIM:GetWindowSoupBowl()
    return WindowSoupBowl;
end

function WIM:CreateWhisperWindow(playerName)
    return createWindow(playerName, "whisper");
end

function WIM:CreateChatWindow(chatName)
    return createWindow(playerName, "chat");
end

function WIM:CreateW2WWindow(chatName)
    return createWindow(playerName, "w2w");
end

function WIM:DestroyWindow(playerNameOrObject)
	destroyWindow(playerNameOrObject);
end

function WIM:RegisterWidget(widgetName, createFunction, moduleName)
	-- moduleName is optional if not being called from a module.
	RegisteredWidgets[widgetName] = createFunction;
	if(moduleName) then
		WIM.modules[widgetName].hasWidget = true;
	end
end


----------------------------------
-- Set default widget triggers	--
----------------------------------

WIM:RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnEnter", function()
		if(WIM.db.showToolTips == true) then
			GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT");
			GameTooltip:SetText(WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE);
		end
	end);
	
WIM:RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnLeave", function() GameTooltip:Hide(); end);
	
WIM:RegisterWidgetTrigger("close", "whisper,chat,w2w", "OnClick", function()
		if(IsShiftKeyDown()) then
			destroyWindow(this:GetParent());
		else
			this:GetParent():Hide();
		end
	end);

WIM:RegisterWidgetTrigger("scroll_up", "whisper,chat,w2w", "OnClick", function()
		local obj = this:GetParent();
		if( IsControlKeyDown() ) then
			obj.widgets.chat_display:ScrollToTop();
		else
			if( IsShiftKeyDown() ) then
			    obj.widgets.chat_display:PageUp();
			else
			    obj.widgets.chat_display:ScrollUp();
			end
		end
		updateScrollBars(obj);
	end);

WIM:RegisterWidgetTrigger("scroll_down", "whisper,chat,w2w", "OnClick", function()
		local obj = this:GetParent();
		if( IsControlKeyDown() ) then
			obj.widgets.chat_display:ScrollToBottom();
		else
			if( IsShiftKeyDown() ) then
			    obj.widgets.chat_display:PageDown();
			else
			    obj.widgets.chat_display:ScrollDown();
			end
		end
		updateScrollBars(obj);
	end);

WIM:RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnMouseWheel", function()
	    if(arg1 > 0) then
		if( IsControlKeyDown() ) then
		    this:ScrollToTop();
		else
		    if( IsShiftKeyDown() ) then
			this:PageUp();
		    else
			this:ScrollUp();
		    end
		end
	    else
		if( IsControlKeyDown() ) then
		    this:ScrollToBottom();
		else
		    if( IsShiftKeyDown() ) then
	                this:PageDown();
		    else
			this:ScrollDown();
		    end
		end
	    end
	    updateScrollBars(getParentMessageWindow(this));
	end);

WIM:RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnMouseDown", function()
	    this:GetParent().prevLeft = this:GetParent():GetLeft();
	    this:GetParent().prevTop = this:GetParent():GetTop();
	end);

WIM:RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnMouseUp", function()
	    if(this:GetParent().prevLeft == this:GetParent():GetLeft() and this:GetParent().prevTop == this:GetParent():GetTop()) then
		--[ Frame was clicked not dragged
		local msg_box = this:GetParent().widgets.msg_box;
		if(WIM.EditBoxInFocus == nil) then
		    msg_box:SetFocus();
		else
		    if(WIM.EditBoxInFocus == msg_box) then
			msg_box:Hide();
			msg_box:Show();
		    else
			msg_box:SetFocus();
		    end
		end
	    end
	end);
	
WIM:RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnHyperlinkEnter", function()
			local obj = this.parentWindow;
			obj.isOnHyperLink = true;
		end)
		
WIM:RegisterWidgetTrigger("chat_display", "whisper,chat,w2w", "OnHyperlinkLeave", function()
			local obj = this.parentWindow;
			obj.isOnHyperLink = false;
		end)

WIM:RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEnterPressed", function()
		if(strsub(this:GetText(), 1, 1) == "/") then
			WIM_EditBoxInFocus = nil;
			ChatFrameEditBox:SetText(this:GetText());
			ChatEdit_SendText(ChatFrameEditBox, 1);
			this:SetText("");
			WIM_EditBoxInFocus = this;
		else
			if(this:GetText() == "") then
				this:Hide();
				this:Show();
			end
		end
	end);
	
WIM:RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEscapePressed", function()
		this:SetText("");
		this:Hide();
		this:Show();
	end);
	
WIM:RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnUpdate", function()
		if(this.setText == 1) then
			this.setText = 0;
			this:SetText("");
		end
	end);
	
WIM:RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEditFocusGained", function() WIM.EditBoxInFocus = this; end);
WIM:RegisterWidgetTrigger("msg_box", "whisper,chat,w2w", "OnEditFocusLost", function() WIM.EditBoxInFocus = nil; end);

