local WIM = WIM;

-- imports
local _G = _G;
local table = table;
local pairs = pairs;
local string = string;
local debugstack = debugstack;
local type = type;
local unpack = unpack;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local rawget = rawget;

-- set namespace
setfenv(1, WIM);

db_defaults.skin = {
    selected = "WIM Classic",
    style = "default",
    font = "ChatFontNormal",
    font_outline = ""
};

local SelectedSkin;
local SelectedStyle = "default";

local SkinTemplate = {}; -- for inherritence excluding default styles.

local SKIN_DEBUG = "";

local SkinTable = {};
local fontTable = {};

local prematureRegisters = {};

local WindowSoupBowl = WIM:GetWindowSoupBowl();

local ProtectedSkinKeys = {
    points = "nil",
    file = "style",
    NormalTexture = "style",
    PushedTexture = "style",
    DisabledTexture = "style",
    HighlightTexture = "style",
    font = "nil",
    font_height = "nil",
    font_flags = "nil",
    inherrits_font = "nil",
    width = "nil",
    height = "nil"
};

local function configureDefaultStyleTable(tbl)
    setmetatable(tbl, {__index = function(t, k)
        return rawget(t, "default");
    end});
end

local function prepareDefaultSkin(tbl)
    tbl = type(tbl) == "table" and tbl or SkinTable["WIM Classic"];
    for k, v in pairs(tbl) do
        if(ProtectedSkinKeys[k] == "style") then
            configureDefaultStyleTable(v);
        elseif(type(v) == "table") then
            prepareDefaultSkin(v);
        end
    end
end

local function configureStyleTable(k, src, dest, defaultStyle)
    local t = (type(dest[k]) == "table") and dest[k] or {};
    setmetatable(t, {__index = function(tbl, key)
        return defaultStyle and rawget(tbl, defaultStyle) or src[k].default;
    end})
    return t;
end

local function preserveProtectedKeys(theKey, src, dest, defaultStyle)
    local ttype = type(ProtectedSkinKeys[theKey])=="string" and ProtectedSkinKeys[theKey] or nil;
    if(ttype) then
        if(ttype == "table") then
            return {}, true;
        elseif(ttype == "style") then
            return configureStyleTable(theKey, src, dest, defaultStyle), true;
        else
            return nil, true;
        end
    else
        return nil, false;
    end
end

local function linkSkinTable(src, dest, defaultStyle)
        if(type(src) == "table") then
                if(type(dest) ~= "table") then dest = {}; end
                --clear current meta table if there is one.
                setmetatable(dest, nil);
                for k, v in pairs(src) do
                        local val, ignoredKey = nil, false;
                        defaultStyle = (k=="default_style") and v or defaultStyle;
                        val, ignoredKey = preserveProtectedKeys(k, src, dest, defaultStyle);
                        dest[k] = ignoredKey and val or dest[k];
                        if(not ignoredKey and type(v) == "table") then
                            linkSkinTable(v, dest[k], defaultStyle);
                        end
                end
                --setmetatable
                setmetatable(dest, {__index = function(t, k)
                    local val, ignoredKey = preserveProtectedKeys(k, src, dest);
                    if(ignoredKey) then
                        t[k] = val;
                        return t[k];
                    else
                        return src[k];
                    end
                end});
        end
end


local function setPointsToObj(obj, pointsTable)
    obj:ClearAllPoints();
    local i;
    for i=1, #pointsTable do
        local point, relativeTo, relativePoint, offx, offy = unpack(pointsTable[i]);
        -- first we need to convert the string representation of objects into actual objects.
        if(relativeTo and type(relativeTo) == "string") then
            if(string.lower(relativeTo) == "window") then
                relativeTo = obj.parentWindow;
            else
                relativeTo = obj.parentWindow.widgets[curPoint[2]];
            end
            relativeTo = relativeTo or UIPanel;
        end
        -- set the actual points
        obj:SetPoint(point, relativeTo, relativePoint, offx, offy);
    end
end

-- load selected skin
function ApplySkinToWindow(obj)
    local fName = obj:GetName();
    
    if(_G[db.skin.font] == nil) then
        DEFAULT_CHAT_FRAME:AddMessage("WIM SKIN ERROR: Selected skin object not found! Loading default font instead.");
        db.skin.font = SkinTable["WIM Classic"].default_font;
    end
    
    local SelectedSkin = WIM:GetSelectedSkin();
    local SelectedStyle = WIM:GetSelectedStyle(obj);
    
    obj:SetMinResize(SelectedSkin.message_window.min_width, SelectedSkin.message_window.min_height);
    
    --set backdrop edges and background textures.
    local tl = obj.widgets.Backdrop.tl;
    tl:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    tl:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.top_left.texture_coord));
    tl:ClearAllPoints();
    tl:SetPoint("TOPLEFT", fName.."Backdrop", "TOPLEFT", unpack(SelectedSkin.message_window.backdrop.top_left.offset));
    tl:SetWidth(SelectedSkin.message_window.backdrop.top_left.width);
    tl:SetHeight(SelectedSkin.message_window.backdrop.top_left.height);
    local tr = obj.widgets.Backdrop.tr;
    tr:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    tr:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.top_right.texture_coord));
    tr:ClearAllPoints();
    tr:SetPoint("TOPRIGHT", fName.."Backdrop", "TOPRIGHT", unpack(SelectedSkin.message_window.backdrop.top_right.offset));
    tr:SetWidth(SelectedSkin.message_window.backdrop.top_right.width);
    tr:SetHeight(SelectedSkin.message_window.backdrop.top_right.height);
    local bl = obj.widgets.Backdrop.bl;
    bl:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    bl:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.bottom_left.texture_coord));
    bl:ClearAllPoints();
    bl:SetPoint("BOTTOMLEFT", fName.."Backdrop", "BOTTOMLEFT", unpack(SelectedSkin.message_window.backdrop.bottom_left.offset));
    bl:SetWidth(SelectedSkin.message_window.backdrop.bottom_left.width);
    bl:SetHeight(SelectedSkin.message_window.backdrop.bottom_left.height);
    local br = obj.widgets.Backdrop.br;
    br:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    br:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.bottom_right.texture_coord));
    br:ClearAllPoints();
    br:SetPoint("BOTTOMRIGHT", fName.."Backdrop", "BOTTOMRIGHT", unpack(SelectedSkin.message_window.backdrop.bottom_right.offset));
    br:SetWidth(SelectedSkin.message_window.backdrop.bottom_right.width);
    br:SetHeight(SelectedSkin.message_window.backdrop.bottom_right.height);
    local t = obj.widgets.Backdrop.t;
    t:SetTexture(SelectedSkin.message_window.file[SelectedStyle], SelectedSkin.message_window.backdrop.top.tile or nil);
    t:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.top.texture_coord));
    t:ClearAllPoints();
    t:SetPoint("TOPLEFT", fName.."Backdrop_TL", "TOPRIGHT", 0, 0);
    t:SetPoint("BOTTOMRIGHT", fName.."Backdrop_TR", "BOTTOMLEFT", 0, 0);
    local b = obj.widgets.Backdrop.b;
    b:SetTexture(SelectedSkin.message_window.file[SelectedStyle], SelectedSkin.message_window.backdrop.bottom.tile or nil);
    b:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.bottom.texture_coord));
    b:ClearAllPoints();
    b:SetPoint("TOPLEFT", fName.."Backdrop_BL", "TOPRIGHT", 0, 0);
    b:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "BOTTOMLEFT", 0, 0);
    local l = obj.widgets.Backdrop.l;
    l:SetTexture(SelectedSkin.message_window.file[SelectedStyle], SelectedSkin.message_window.backdrop.left.tile or nil);
    l:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.left.texture_coord));
    l:ClearAllPoints();
    l:SetPoint("TOPLEFT", fName.."Backdrop_TL", "BOTTOMLEFT", 0, 0);
    l:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BL", "TOPRIGHT", 0, 0);
    local r = obj.widgets.Backdrop.r;
    r:SetTexture(SelectedSkin.message_window.file[SelectedStyle], SelectedSkin.message_window.backdrop.right.tile or nil);
    r:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.right.texture_coord));
    r:ClearAllPoints();
    r:SetPoint("TOPLEFT", fName.."Backdrop_TR", "BOTTOMLEFT", 0, 0);
    r:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "TOPRIGHT", 0, 0);
    local bg = obj.widgets.Backdrop.bg;
    bg:SetTexture(SelectedSkin.message_window.file[SelectedStyle], SelectedSkin.message_window.backdrop.background.tile or nil);
    bg:SetTexCoord(unpack(SelectedSkin.message_window.backdrop.background.texture_coord));
    bg:ClearAllPoints();
    bg:SetPoint("TOPLEFT", fName.."Backdrop_TL", "BOTTOMRIGHT", 0, 0);
    bg:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "TOPLEFT", 0, 0);
    
    --set class icon
    local class_icon = obj.widgets.class_icon;
    ApplySkinToWidget(class_icon);
    class_icon:SetTexture(SelectedSkin.message_window.widgets.class_icon.file[SelectedStyle]);
    --WIM_UpdateMessageWindowClassIcon(obj);
    
    --set from font
    local from = obj.widgets.from;
    ApplySkinToWidget(from);
    
    --set character details font
    local char_info = obj.widgets.char_info;
    ApplySkinToWidget(char_info);

    --close button
    local close = obj.widgets.close;
    ApplySkinToWidget(close);
    -- close button is a special case... so do the following extra work.
    if(close.curTextureIndex == 1) then
        close:SetNormalTexture(SelectedSkin.message_window.widgets.close.state_hide.NormalTexture[SelectedStyle]);
        close:SetPushedTexture(SelectedSkin.message_window.widgets.close.state_hide.PushedTexture[SelectedStyle]);
        close:SetHighlightTexture(SelectedSkin.message_window.widgets.close.state_hide.HighlightTexture[SelectedStyle], SelectedSkin.message_window.widgets.close.state_hide.HighlightAlphaMode);
    else
        close:SetNormalTexture(SelectedSkin.message_window.widgets.close.state_close.NormalTexture[SelectedStyle]);
        close:SetPushedTexture(SelectedSkin.message_window.widgets.close.state_close.PushedTexture[SelectedStyle]);
        close:SetHighlightTexture(SelectedSkin.message_window.widgets.close.state_close.HighlightTexture[SelectedStyle], SelectedSkin.message_window.widgets.close.state_close.HighlightAlphaMode);
    end
    
    --history button
    --local history = getglobal(fName.."HistoryButton");
    --history:ClearAllPoints();
    --history:SetPoint(SelectedSkin.message_window.buttons.history.rect.anchor, fName, SelectedSkin.message_window.buttons.history.rect.anchor, SelectedSkin.message_window.buttons.history.rect.offset.x, SelectedSkin.message_window.buttons.history.rect.offset.y);
    --history:SetWidth(SelectedSkin.message_window.buttons.history.rect.size.x);
    --history:SetHeight(SelectedSkin.message_window.buttons.history.rect.size.y);
    --history:SetNormalTexture(SelectedSkin.message_window.buttons.history.NormalTexture[SelectedStyle]);
    --history:SetPushedTexture(SelectedSkin.message_window.buttons.history.PushedTexture[SelectedStyle]);
    --history:SetHighlightTexture(SelectedSkin.message_window.buttons.history.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.history.HighlightAlphaMode);
    
    --w2w button
    --local w2w = getglobal(fName.."W2WButton");
    --w2w:ClearAllPoints();
    --w2w:SetPoint(SelectedSkin.message_window.buttons.w2w.rect.anchor, fName, SelectedSkin.message_window.buttons.w2w.rect.anchor, SelectedSkin.message_window.buttons.w2w.rect.offset.x, SelectedSkin.message_window.buttons.w2w.rect.offset.y);
    --w2w:SetWidth(SelectedSkin.message_window.buttons.w2w.rect.size.x);
    --w2w:SetHeight(SelectedSkin.message_window.buttons.w2w.rect.size.y);
    --w2w:SetNormalTexture(SelectedSkin.message_window.buttons.w2w.NormalTexture[SelectedStyle]);
    --w2w:SetPushedTexture(SelectedSkin.message_window.buttons.w2w.PushedTexture[SelectedStyle]);
    --w2w:SetHighlightTexture(SelectedSkin.message_window.buttons.w2w.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.w2w.HighlightAlphaMode);
    
    --chatting button
    --local chatting = getglobal(fName.."IsChattingButton");
    --chatting:ClearAllPoints();
    --chatting:SetPoint(SelectedSkin.message_window.buttons.chatting.rect.anchor, fName, SelectedSkin.message_window.buttons.chatting.rect.anchor, SelectedSkin.message_window.buttons.chatting.rect.offset.x, SelectedSkin.message_window.buttons.chatting.rect.offset.y);
    --chatting:SetWidth(SelectedSkin.message_window.buttons.chatting.rect.size.x);
    --chatting:SetHeight(SelectedSkin.message_window.buttons.chatting.rect.size.y);
    --chatting:SetNormalTexture(SelectedSkin.message_window.buttons.chatting.NormalTexture[SelectedStyle]);
    --chatting:SetPushedTexture(SelectedSkin.message_window.buttons.chatting.PushedTexture[SelectedStyle]);
    
    --scroll_up button
    local scroll_up = obj.widgets.scroll_up;
    ApplySkinToWidget(scroll_up);
    
    --scroll_down button
    local scroll_down = obj.widgets.scroll_down;
    ApplySkinToWidget(scroll_down);
    
    --chat display
    local chat_display = obj.widgets.chat_display;
    ApplySkinToWidget(chat_display);
    local font, height, flags = _G[db.skin.font]:GetFont();
    chat_display:SetFont(font, db.fontSize+2, db.skin.font_outline);

    --msg_box
    local msg_box = obj.widgets.msg_box;
    ApplySkinToWidget(msg_box);
    local font, height, flags = _G[db.skin.font]:GetFont();
    msg_box:SetFont(font, SelectedSkin.message_window.widgets.msg_box.font_height, WIM.db.skin.font_outline);
    msg_box:SetTextColor(SelectedSkin.message_window.widgets.msg_box.font_color[1], SelectedSkin.message_window.widgets.msg_box.font_color[2], SelectedSkin.message_window.widgets.msg_box.font_color[3]);
    
    --shorcuts
    --local shortcuts = getglobal(fName.."ShortcutFrame");
    --shortcuts:ClearAllPoints();
    --shortcuts:SetPoint(SelectedSkin.message_window.shortcuts.rect.anchor, fName, SelectedSkin.message_window.shortcuts.rect.anchor, SelectedSkin.message_window.shortcuts.rect.offset.x, SelectedSkin.message_window.shortcuts.rect.offset.y);
    --shortcuts:SetWidth(10);
    --shortcuts:SetHeight(10);
    --MessageWindow_ArrangeShortcutBar(shortcuts);
    
    --WIM_SetWindowProps(obj);
    
end

local function deleteStyleFileEntries(theTable)
    if(type(theTable) == "table") then
        for key, _ in pairs(theTable) do
            theTable[key] = nil;
        end
    end
end

local function populateFemaleClassInfo(tbl)
    tbl.message_window.widgets.class_icon["druidf"] = tbl.message_window.widgets.class_icon["druid"];
    tbl.message_window.widgets.class_icon["hunterf"] = tbl.message_window.widgets.class_icon["hunter"];
    tbl.message_window.widgets.class_icon["magef"] = tbl.message_window.widgets.class_icon["mage"];
    tbl.message_window.widgets.class_icon["paladinf"] = tbl.message_window.widgets.class_icon["paladin"];
    tbl.message_window.widgets.class_icon["priestf"] = tbl.message_window.widgets.class_icon["priest"];
    tbl.message_window.widgets.class_icon["roguef"] = tbl.message_window.widgets.class_icon["rogue"];
    tbl.message_window.widgets.class_icon["shamanf"] = tbl.message_window.widgets.class_icon["shaman"];
    tbl.message_window.widgets.class_icon["warlockf"] = tbl.message_window.widgets.class_icon["warlock"];
    tbl.message_window.widgets.class_icon["warriorf"] = tbl.message_window.widgets.class_icon["warrior"];
end



function RegisterPrematureSkins()
    for i=1,#prematureRegisters do
        RegisterSkin(prematureRegisters[i]);
    end
end

function GetSelectedSkin()
    return SelectedSkin or SkinTable["WIM Classic"];
end

function GetSelectedStyle(obj)
    local SelectedSkin = GetSelectedSkin();
    local SelectedStyle = SelectedStyle;
    if(type(SelectedSkin.smart_style) == "function" and SelectedStyle == "#SMART#") then
        local smartStyleFunction = SelectedSkin.smart_style;
        SelectedStyle = smartStyleFunction(obj.theUser, obj.theGuild, obj.theLevel, obj.theRace, obj.theClass);
    end
    return SelectedStyle;
end

function LoadSkin(skinName, style)
    if(skinName == nil or (not SkinTable[skinName])) then
        skinName = "WIM Classic";
        style = SkinTable[skinName].default_style;
    end
    if(style == nil or (not SkinTable[skinName].styles[style])) then
        if(style == "#SMART#" and SkinTable[skinName].smart_style) then
            -- do nothing here. we want the #SMART# style to pass...
        else
            style = SkinTable[skinName].default_style;
        end
    end
    SelectedSkin = SkinTable[skinName];
    SelectedStyle = style;
    
    db.skin.selected = skinName;
    db.skin.style = style;
    
    -- apply skin to tabs
    --WIM_Tabs.anchorSelf = SkinTable[skinName].tab_strip.rect.anchor_points.self;
    --WIM_Tabs.anchorRelative = SkinTable[skinName].tab_strip.rect.anchor_points.relative;
    --WIM_Tabs.topOffset = SkinTable[skinName].tab_strip.rect.offsets.top;
    --WIM_Tabs.marginLeft = SkinTable[skinName].tab_strip.rect.offsets.margins.left;
    --WIM_Tabs.marginRight = SkinTable[skinName].tab_strip.rect.offsets.margins.right;
    --if(WIM_Windows[WIM_Tabs.selectedUser]) then
    --    WIM_JumpToUserTab(WIM_Tabs.selectedUser);
    --end
    
    SKIN_DEBUG = SKIN_DEBUG..skinName.." loaded..\n";
    -- apply skin to window objects
    local window_objects = WindowSoupBowl.windows;
    for i=1, table.getn(window_objects) do
        ApplySkinToWindow(window_objects[i].obj);
    end
end

function RegisterFont(objName, title)
    if(objName == nil or objName == "") then
        return;
    end
    if(title == nil or title == "") then
        title = objName
    end
    if(getglobal(objName)) then
        fontTable[objName] = title;
    else
        DEFAULT_CHAT_FRAME:AddMessage("WIM SKIN ERROR: Registered font object does not exist!");
    end
end


function RegisterSkin(skinTable)
    if(not isInitialized) then
        table.insert(prematureRegisters, skinTable);
        return;
    end
    local required = {"title", "author", "version"};
    local error_list = "";
    local addonName;
    local styles = {};
    
    local stack = {string.split("\n", debugstack())};
    if(table.getn(stack) >= 2) then
        local paths = {string.split("\\", stack[2])};
        addonName = paths[3];
    else
        addonName = "Unknown";
    end
    
    for i=1,table.getn(required) do
        if(skinTable[required[i]] == nil or skinTable[required[i]] == "") then error_list = error_list.."- Required field '"..required[i].."' was not defined.\n"; end
    end

    if(skinTable.styles == nil) then
        error_list = error_list.."- Skin must have at least one style defined!\n";
    else
        local style, title;
        for style,title in pairs(skinTable.styles) do
            if(style and title and title ~= "") then
                if(not skinTable.default_style) then skinTable.default_style = style; end
                table.insert(styles, style);
            end
        end
        if(table.getn(styles) == 0) then error_list = error_list.."- Skin must have at least one style defined!\n"; end
    end
    
    if(not skinTable.default_font) then skinTable.default_font = SkinTable["WIM Classic"].default_font; end
    
    if(error_list ~= "") then
        SKIN_DEBUG = SKIN_DEBUG.."\n\n---------------------------------------------------------\nSKIN ERROR FROM: "..addonName.."\n---------------------------------------------------------\n";
        SKIN_DEBUG = SKIN_DEBUG.."Skin was not loaded for the following reason(s):\n\n"..error_list.."\n\n";
        return;
    end
    
    if(skinTable.title == "WIM Classic") then
        SkinTable[skinTable.title] = skinTable;
        if(skinTable.title == db.skin.selected) then
            LoadSkin(WIM.db.skin.selected, db.skin.style);
        end
        
        populateFemaleClassInfo(SkinTable[skinTable.title]);
        prepareDefaultSkin();
        return;
    end
    
    -- inherrit missing data from default skin.
    copyTable(SkinTable["WIM Classic"], skinTable);
        
    populateFemaleClassInfo(skinTable);    
        
    

    
    -- finalize registration
    SkinTable[skinTable.title] = skinTable;
    populateFemaleClassInfo(SkinTable[skinTable.title]);
    
    -- if this is the selected skin, load it now
    if(skinTable.title == WIM.db.skin.selected) then
        LoadSkin(WIM.db.skin.selected, WIM.db.skin.style);
    end
end

function GetFontKeyByName(fontName)
	for key, val in pairs(fontTable) do
		if(val == fontName) then
			return key;
		end
	end
	return nil;
end


function SetWidgetFont(obj, widgetSkinTable)
    -- first check what font is being requested, height is applied here.
    if(widgetSkinTable.font) then
        if(_G[widgetSkinTable.font]) then
            -- font is to be inherrited
            obj:SetFontObject(_G[widgetSkinTable.font]);
            local font, height, flags = obj:GetFont();
            obj:SetFont(font, widgetSkinTable.font_height or height, widgetSkinTable.font_flags or flags);
        else
            -- font is a path, lets load the font
            obj:SetFont(widgetSkinTable.font, widgetSkinTable.font_height or 12, widgetSkinTable.font_flags or "");
        end
    end
    -- next, lets add the extra properties to it.
    if(widgetSkinTable.font_color) then
        obj:SetTextColor(RGBHexToPercent(widgetSkinTable.font_color));
    end
end

function SetWidgetRect(obj, widgetSkinTable)
    if(type(widgetSkinTable) == "table") then
        if(type(widgetSkinTable.width) == "number") then
            obj:SetWidth(widgetSkinTable.width);
        end
        if(type(widgetSkinTable.height) == "number") then
            obj:SetHeight(widgetSkinTable.height);
        end
        if(widgetSkinTable.points) then
            setPointsToObj(obj, widgetSkinTable.points);
        end
    end
end

function ApplySkinToWidget(obj)
    if(obj.GetObjectType) then
        local SelectedSkin = GetSelectedSkin();
        local widgetSkin = SelectedSkin.message_window.widgets[obj.widgetName] or obj.defaultSkin;
        local SelectedStyle = GetSelectedStyle();
        local oType = obj:GetObjectType();
        SetWidgetRect(obj, widgetSkin);
        if(oType == "Button" or oType == "CheckButton") then
            if(widgetSkin.NormalTexture) then obj:SetNormalTexture(widgetSkin.NormalTexture[SelectedStyle] or widgetSkin.NormalTexture[SelectedSkin.default_style]); end
            if(widgetSkin.PushedTexture) then obj:SetPushedTexture(widgetSkin.PushedTexture[SelectedStyle] or widgetSkin.PushedTexture[SelectedSkin.default_style]); end
            if(widgetSkin.DisabledTexture) then obj:SetDisabledTexture(widgetSkin.DisabledTexture[SelectedStyle] or widgetSkin.DisabledTexture[SelectedSkin.default_style]); end
            if(widgetSkin.HighlightTexture) then obj:SetHighlightTexture(widgetSkin.HighlightTexture[SelectedStyle] or widgetSkin.HighlightTexture[SelectedSkin.default_style], widgetSkin.HighlightAlphaMode); end
        end
        if(oType == "FontString") then
            SetWidgetFont(obj, widgetSkin);
        end
    else
        dPrint("Invalid widget trying to be skinned.");
    end
end

function PrepareDefaultSkin()
    prepareDefaultSkin();
end

function test()
    _G.test = {message_window = {}};
    linkSkinTable(SkinTable["WIM Classic"], _G.test);
end
