local WIM = WIM;

-- load message window related default settings.
WIM.db_defaults.displayColors = {
		wispIn = {
				r=0.5607843137254902, 
				g=0.03137254901960784, 
				b=0.7607843137254902
			},
		wispOut = {
				r=1, 
				g=0.07843137254901961, 
				b=0.9882352941176471
			},
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
WIM.db_defaults.windowFade = false;
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

local WindowSoupBowl = {
    windowToken = 0,
    available = 0,
    used = 0,
    windows = {
    }
}

local RegisteredWidgets = {}; -- a list of registered widgets added to windows from modules.
WIM.windows.widgets = RegisteredWidgets;

-- Sample Widget with triggers
RegisteredWidgets["Test"] = {
	create = function() DEFAULT_CHAT_FRAME:AddMessage("HELLO WORLD!"); return 1; end,
	onShow = function() DEFAULT_CHAT_FRAME:AddMessage("Window Shown"); end,
	onHide = function() DEFAULT_CHAT_FRAME:AddMessage("Window Hidden"); end,
	defaults = function() DEFAULT_CHAT_FRAME:AddMessage("Defaults Loaded"); end,
	props = function() DEFAULT_CHAT_FRAME:AddMessage("Properties set"); end,
};

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
    if(obj.isParent) then
        return obj;
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
        window:StopMovingOrSizing();
        window.isMoving = false;
    end
end

local function MessageWindow_FadeControler_OnEnter()
    local window = getParentMessageWindow(this);
    if(window) then
        if(WIM.db.windowFade) then
            -- WIM_FadeIn(window.theUser);
        end
        window.isMouseOver = true;
        window.QueuedToHide = false;
    end
end

local function MessageWindow_FadeControler_OnLeave()
    local window = getParentMessageWindow(this);
    if(window) then
        if(WIM.db.windowFade) then
            if(getglobal(window:GetName().."MsgBox") ~= WIM_EditBoxInFocus) then
                -- WIM_FadeOut(window.theUser);
            else
                window.QueuedToHide = true;
            end
        end
        window.isMouseOver = false;
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
        this.QueuedToHide = false;
        updateScrollBars(this);
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
    end
end

local function MessageWindow_Frame_OnUpdate()
    --if(WIM_Tabs.enabled == true) then
    --      WIM_Tabs.x = this:GetLeft();
    --      WIM_Tabs.y = this:GetTop();
    --end
end

local function MessageWindow_ExitButton_OnEnter()
    if(WIM.db.showToolTips == true) then
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT");
	GameTooltip:SetText(WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE);
    end
    MessageWindow_FadeControler_OnEnter();
end

local function MessageWindow_ExitButton_OnLeave()
    GameTooltip:Hide();
    MessageWindow_FadeControler_OnLeave();
end

local function MessageWindow_ExitButton_OnClick()
    if(IsShiftKeyDown()) then
	--WIM_CloseConvo(this:GetParent().theUser);
	-- do some check if tabs are loaded and show next available.
    else
        this:GetParent():Hide();
    end
end

local function MessageWindow_ScrollUp_OnClick()
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
end

local function MessageWindow_ScrollDown_OnClick()
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
end

local function MessageWindow_ScrollingMessageFrame_OnMouseWheel()
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
end

local function MessageWindow_ScrollingMessageFrame_OnMouseDown()
    this:GetParent().prevLeft = this:GetParent():GetLeft();
    this:GetParent().prevTop = this:GetParent():GetTop();
end

local function MessageWindow_ScrollingMessageFrame_OnMouseUp()
    if(this:GetParent().prevLeft == this:GetParent():GetLeft() and this:GetParent().prevTop == this:GetParent():GetTop()) then
	--[ Frame was clicked not dragged
	if(WIM_EditBoxInFocus == nil) then
	    getglobal(this:GetParent():GetName().."MsgBox"):SetFocus();
	else
	    if(WIM_EditBoxInFocus:GetName() == this:GetParent():GetName().."MsgBox") then
		getglobal(this:GetParent():GetName().."MsgBox"):Hide();
		getglobal(this:GetParent():GetName().."MsgBox"):Show();
	    else
		getglobal(this:GetParent():GetName().."MsgBox"):SetFocus();
	    end
	end
    end
end

local function MessageWindow_MsgBox_OnMouseUp()
    CloseDropDownMenus();
    if(arg1 == "RightButton") then
        WIM_MSGBOX_MENU_CUR_USER = this:GetParent().theUser;
        UIDropDownMenu_Initialize(WIM_MsgBoxMenu, WIM_MsgBoxMenu_Initialize, "MENU");
        ToggleDropDownMenu(1, nil, WIM_MsgBoxMenu, this, 0, 0);
    end
end

local function MessageWindow_MsgBox_OnEnterPressed()
    local _, tParent = this:GetParent();
						
    if(this:GetText() == "") then
	if(WIM.db.windowFade and this:GetParent().QueuedToHide) then
            --WIM_FadeOut(this:GetParent().theUser);
        end
        this:Hide();
        this:Show();
        return;
    else
        if(WIM.db.windowFade) then
            --WIM_FadeOutDelayed(this:GetParent().theUser);
        end
    end
						
    if(strsub(this:GetText(), 1, 1) == "/") then
        WIM_EditBoxInFocus = nil;
        ChatFrameEditBox:SetText(this:GetText());
        ChatEdit_SendText(ChatFrameEditBox, 1);
        WIM_EditBoxInFocus = this;
    else
        SendChatMessage(this:GetText(), "WHISPER", nil, WIM_ParseNameTag(this:GetParent().theUser));
        this:AddHistoryLine(this:GetText());
    end
    this:SetText("");
    if(not WIM.db.keepFocus) then
        this:Hide();
        this:Show();
    elseif(not IsResting() and WIM.db.keepFocusRested) then
        this:Hide();
        this:Show();
    end
end

local function MessageWindow_MsgBox_OnEscapePressed()
    this:SetText("");
    this:Hide();
    this:Show();
    if(WIM.db.windowFade) then
        --WIM_FadeOut(this:GetParent().theUser);
    end
end

local function MessageWindow_MsgBox_OnTabPressed()
    --cycle through windows
    if(WIM_Tabs.enabled == true) then
        if(IsShiftKeyDown()) then
            WIM_TabStep(-1);
        else
            WIM_TabStep(1);
        end
    else
        WIM_ToggleWindow_Toggle();
    end
end

local function MessageWindow_MsgBox_OnTextChanged()
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
end

local function MessageWindow_MsgBox_OnUpdate()
    if(this.setText == 1) then
	this.setText = 0;
	this:SetText("");
    end
end


local function loadRegisteredWidgets(obj)
	local widgets = obj.widgets;
	for widget, data in pairs(RegisteredWidgets) do
		if(widgets[widget] == nil) then
			if(type(data.create) == "function") then
				widgets[widget]  = data.create();
				WIM:dPrint("Widget '"..widget.."' added to '"..obj:GetName().."'");
				data.defaults(widgets[widget], obj); -- load defaults for this widget
			end
		else
			data.defaults(widgets[widget], obj); -- load defaults for this widget
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
    obj:SetScript("OnEnter", MessageWindow_FadeControler_OnEnter);
    obj:SetScript("OnLeave", MessageWindow_FadeControler_OnLeave);
    obj:SetScript("OnShow", MessageWindow_Frame_OnShow);
    obj:SetScript("OnHide", MessageWindow_Frame_OnHide);
    obj:SetScript("OnUpdate", MessageWindow_Frame_OnUpdate);
    
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
    widgets.close:SetScript("OnEnter", MessageWindow_ExitButton_OnEnter);
    widgets.close:SetScript("OnLeave", MessageWindow_ExitButton_OnLeave);
    widgets.close:SetScript("OnClick", MessageWindow_ExitButton_OnClick);

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
    widgets.scroll_up:SetScript("OnEnter", MessageWindow_FadeControler_OnEnter);
    widgets.scroll_up:SetScript("OnLeave", MessageWindow_FadeControler_OnLeave);
    widgets.scroll_up:SetScript("OnClick", MessageWindow_ScrollUp_OnClick);
    
    widgets.scroll_down = CreateFrame("Button", fName.."ScrollDown", obj);
    widgets.scroll_down:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    widgets.scroll_down:SetScript("OnEnter", MessageWindow_FadeControler_OnEnter);
    widgets.scroll_down:SetScript("OnLeave", MessageWindow_FadeControler_OnLeave);
    widgets.scroll_down:SetScript("OnClick", MessageWindow_ScrollDown_OnClick);
    
    widgets.chat_display = CreateFrame("ScrollingMessageFrame", fName.."ScrollingMessageFrame", obj);
    widgets.chat_display:RegisterForDrag("LeftButton");
    widgets.chat_display:SetFading(false);
    widgets.chat_display:SetMaxLines(128);
    widgets.chat_display:SetMovable(true);
    widgets.chat_display:SetScript("OnDragStart", function() MessageWindow_MovementControler_OnDragStart(); end);
    widgets.chat_display:SetScript("OnDragStop", function() MessageWindow_MovementControler_OnDragStop(); end);
    widgets.chat_display:SetScript("OnMouseWheel", MessageWindow_ScrollingMessageFrame_OnMouseWheel);
    widgets.chat_display:SetScript("OnHyperlinkClick", function() ChatFrame_OnHyperlinkShow(arg1, arg2, arg3); end);
    widgets.chat_display:SetScript("OnMessageScrollChanged", function() updateScrollBars(this:GetParent()); end);
    widgets.chat_display:SetScript("OnMouseDown", MessageWindow_ScrollingMessageFrame_OnMouseDown);
    widgets.chat_display:SetScript("OnMouseUp", MessageWindow_ScrollingMessageFrame_OnMouseUp);
    widgets.chat_display:SetScript("OnEnter", MessageWindow_FadeControler_OnEnter);
    widgets.chat_display:SetScript("OnLeave", MessageWindow_FadeControler_OnLeave);
    widgets.chat_display:SetScript("OnHyperlinkEnter", MessageWindow_Hyperlink_OnEnter);
    widgets.chat_display:SetScript("OnHyperlinkLeave", MessageWindow_Hyperlink_OnLeave);
    widgets.chat_display:SetJustifyH("LEFT");
    widgets.chat_display:EnableMouse(true);
    widgets.chat_display:EnableMouseWheel(1);
    
    widgets.msg_box = CreateFrame("EditBox", fName.."MsgBox", obj);
    widgets.msg_box:SetAutoFocus(false);
    widgets.msg_box:SetHistoryLines(32);
    widgets.msg_box:SetMaxLetters(255);
    widgets.msg_box:SetAltArrowKeyMode(true);
    widgets.msg_box:EnableMouse(true);
    widgets.msg_box:SetScript("OnEnterPressed", MessageWindow_MsgBox_OnEnterPressed);
    widgets.msg_box:SetScript("OnEscapePressed", MessageWindow_MsgBox_OnEscapePressed);
    widgets.msg_box:SetScript("OnTabPressed", MessageWindow_MsgBox_OnTabPressed);
    widgets.msg_box:SetScript("OnEditFocusGained", function() WIM_EditBoxInFocus = this; end);
    widgets.msg_box:SetScript("OnEditFocusLost", function() WIM_EditBoxInFocus = nil; end);
    widgets.msg_box:SetScript("OnEnter", MessageWindow_FadeControler_OnEnter);
    widgets.msg_box:SetScript("OnLeave", MessageWindow_FadeControler_OnLeave);
    widgets.msg_box:SetScript("OnTextChanged", MessageWindow_MsgBox_OnTextChanged);
    widgets.msg_box:SetScript("OnUpdate", MessageWindow_MsgBox_OnUpdate);
    widgets.msg_box:SetScript("OnMouseUp", MessageWindow_MsgBox_OnMouseUp);
    
    
    -- load Registered Widgets
    loadRegisteredWidgets(obj);
    
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

    obj.theGuild = "";
    obj.theLevel = "";
    obj.theRace = "";
    obj.theClass = "";
    
    --obj.icon.track = false;

    obj:SetScale(1);
    obj:SetAlpha(1);
    
    obj.widgets.Backdrop:SetAlpha(1);
    
    obj.widgets.class_icon.class = "blank";
    
    obj.widgets.from:SetText(obj.theUser);
    
    obj.widgets.char_info:SetText("");
    
    --local history = getglobal(fName.."HistoryButton");
    --history:Hide();
    
    --local w2w = getglobal(fName.."W2WButton");
    --w2w:Hide();
    
    --local chatting = getglobal(fName.."IsChattingButton");
    --chatting:Hide();
    
    obj.widgets.msg_box.setText = 0;
    obj.widgets.msg_box:SetText("");
    
    obj.widgets.chat_display:Clear();
    obj.widgets.chat_display:AddMessage("  ");
    obj.widgets.chat_display:AddMessage("  ");
    updateScrollBars(obj);
    
    -- load Registered Widgets (if not created already) & set defaults
    loadRegisteredWidgets(obj);
    
    WIM:ApplySkinToWindow(obj);
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
        obj.icon.theUser = userName;
        loadMessageWindowDefaults(obj); -- clear contents of window and revert back to it's initial state.
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
        instantiateWindow(f);
        --f.icon.theUser = userName;
        loadWindowDefaults(f);
        WIM:dPrint("Window created '"..f:GetName().."'");
        return f;
    end
end


--Deletes message window and makes it available in the Soup Bowl.
local function destroyWindow(userNameOrObj)
    if(type(userNameOrObj) == "string") then
        local obj, index = getWindowByName(userNameOrObj);
    else
        local obj = userNameOrObj;
    end
    
    if(obj) then
        WindowSoupBowl.windows[index].inUse = false;
        WindowSoupBowl.windows[index].user = "";
        WindowSoupBowl.available = WindowSoupBowl.available + 1;
        WindowSoupBowl.used = WindowSoupBowl.used - 1;
        WIM_Astrolabe:RemoveIconFromMinimap(obj.icon);
        obj.icon:Hide();
        obj.icon.track = false;
        obj.theUser = nil;
        obj:Show();
        local chatBox = getglobal(obj:GetName().."ScrollingMessageFrame");
        chatBox:Clear();
        obj:Hide();
    end
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
