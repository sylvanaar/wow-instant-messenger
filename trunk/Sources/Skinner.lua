local WIM = WIM;

WIM.db_defaults.skin = {
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


local function MessageWindow_ArrangeShortcutBar(ParentFrame)
    local ShortcutCount = WIM:GetShortcutCount();
    for i=1,ShortcutCount do
        local shortcut = getglobal(ParentFrame:GetName().."Button"..i);
        if(i == 1) then
            shortcut:SetPoint("TOPLEFT", ParentFrame:GetName(), "TOPLEFT", 0, 0);
        else
            if(SelectedSkin.message_window.shortcuts.verticle) then
                if(SelectedSkin.message_window.shortcuts.inverted) then
                    shortcut:SetPoint("BOTTOMLEFT", ParentFrame:GetName().."Button"..(i-1), "TOPLEFT", 0, 2);
                else
                    shortcut:SetPoint("TOPLEFT", ParentFrame:GetName().."Button"..(i-1), "BOTTOMLEFT", 0, -2);
                end
            else
                if(SelectedSkin.message_window.shortcuts.inverted) then
                    shortcut:SetPoint("TOPRIGHT", ParentFrame:GetName().."Button"..(i-1), "TOPLEFT", -2, 0);
                else
                    shortcut:SetPoint("TOPLEFT", ParentFrame:GetName().."Button"..(i-1), "TOPRIGHT", 2, 0);
                end
            end
        end
        shortcut:SetWidth(SelectedSkin.message_window.shortcuts.button_size);
        shortcut:SetHeight(SelectedSkin.message_window.shortcuts.button_size);
    end
    
end

-- load selected skin
function WIM:ApplySkinToWindow(obj)
    local fName = obj:GetName();
    
    if(getglobal(WIM.db.skin.font) == nil) then
        DEFAULT_CHAT_FRAME:AddMessage("WIM SKIN ERROR: Selected skin object not found! Loading default font instead.");
        WIM.db.skin.font = SkinTable["WIM Classic"].default_font;
    end
    
    local isSmartStyle = false;
    local prevStyle = SelectedStyle;
    if(type(SelectedSkin.smart_style) == "function" and SelectedStyle == "#SMART#") then
        isSmartStyle = true;
        local smartStyleFunction = SelectedSkin.smart_style;
        SelectedStyle = smartStyleFunction(obj.theUser, obj.theGuild, obj.theLevel, obj.theRace, obj.theClass);
    end
    
    --set backdrop edges and background textures.
    local tl = obj.widgets.Backdrop.tl;
    tl:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    tl:SetTexCoord(SelectedSkin.message_window.rect.top_left.texture_coord[1], SelectedSkin.message_window.rect.top_left.texture_coord[2],
                    SelectedSkin.message_window.rect.top_left.texture_coord[3], SelectedSkin.message_window.rect.top_left.texture_coord[4],
                    SelectedSkin.message_window.rect.top_left.texture_coord[5], SelectedSkin.message_window.rect.top_left.texture_coord[6],
                    SelectedSkin.message_window.rect.top_left.texture_coord[7], SelectedSkin.message_window.rect.top_left.texture_coord[8]);
    tl:ClearAllPoints();
    tl:SetPoint("TOPLEFT", fName.."Backdrop", "TOPLEFT", SelectedSkin.message_window.rect.top_left.offset.x, SelectedSkin.message_window.rect.top_left.offset.y);
    tl:SetWidth(SelectedSkin.message_window.rect.top_left.size.x);
    tl:SetHeight(SelectedSkin.message_window.rect.top_left.size.y);
    local tr = obj.widgets.Backdrop.tr;
    tr:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    tr:SetTexCoord(SelectedSkin.message_window.rect.top_right.texture_coord[1], SelectedSkin.message_window.rect.top_right.texture_coord[2],
                    SelectedSkin.message_window.rect.top_right.texture_coord[3], SelectedSkin.message_window.rect.top_right.texture_coord[4],
                    SelectedSkin.message_window.rect.top_right.texture_coord[5], SelectedSkin.message_window.rect.top_right.texture_coord[6],
                    SelectedSkin.message_window.rect.top_right.texture_coord[7], SelectedSkin.message_window.rect.top_right.texture_coord[8]);
    tr:ClearAllPoints();
    tr:SetPoint("TOPRIGHT", fName.."Backdrop", "TOPRIGHT", SelectedSkin.message_window.rect.top_right.offset.x, SelectedSkin.message_window.rect.top_right.offset.y);
    tr:SetWidth(SelectedSkin.message_window.rect.top_right.size.x);
    tr:SetHeight(SelectedSkin.message_window.rect.top_right.size.y);
    local bl = obj.widgets.Backdrop.bl;
    bl:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    bl:SetTexCoord(SelectedSkin.message_window.rect.bottom_left.texture_coord[1], SelectedSkin.message_window.rect.bottom_left.texture_coord[2],
                    SelectedSkin.message_window.rect.bottom_left.texture_coord[3], SelectedSkin.message_window.rect.bottom_left.texture_coord[4],
                    SelectedSkin.message_window.rect.bottom_left.texture_coord[5], SelectedSkin.message_window.rect.bottom_left.texture_coord[6],
                    SelectedSkin.message_window.rect.bottom_left.texture_coord[7], SelectedSkin.message_window.rect.bottom_left.texture_coord[8]);
    bl:ClearAllPoints();
    bl:SetPoint("BOTTOMLEFT", fName.."Backdrop", "BOTTOMLEFT", SelectedSkin.message_window.rect.bottom_left.offset.x, SelectedSkin.message_window.rect.bottom_left.offset.y);
    bl:SetWidth(SelectedSkin.message_window.rect.bottom_left.size.x);
    bl:SetHeight(SelectedSkin.message_window.rect.bottom_left.size.y);
    local br = obj.widgets.Backdrop.br;
    br:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    br:SetTexCoord(SelectedSkin.message_window.rect.bottom_right.texture_coord[1], SelectedSkin.message_window.rect.bottom_right.texture_coord[2],
                    SelectedSkin.message_window.rect.bottom_right.texture_coord[3], SelectedSkin.message_window.rect.bottom_right.texture_coord[4],
                    SelectedSkin.message_window.rect.bottom_right.texture_coord[5], SelectedSkin.message_window.rect.bottom_right.texture_coord[6],
                    SelectedSkin.message_window.rect.bottom_right.texture_coord[7], SelectedSkin.message_window.rect.bottom_right.texture_coord[8]);
    br:ClearAllPoints();
    br:SetPoint("BOTTOMRIGHT", fName.."Backdrop", "BOTTOMRIGHT", SelectedSkin.message_window.rect.bottom_right.offset.x, SelectedSkin.message_window.rect.bottom_right.offset.y);
    br:SetWidth(SelectedSkin.message_window.rect.bottom_right.size.x);
    br:SetHeight(SelectedSkin.message_window.rect.bottom_right.size.y);
    local t = obj.widgets.Backdrop.t;
    t:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    t:SetTexCoord(SelectedSkin.message_window.rect.top.texture_coord[1], SelectedSkin.message_window.rect.top.texture_coord[2],
                    SelectedSkin.message_window.rect.top.texture_coord[3], SelectedSkin.message_window.rect.top.texture_coord[4],
                    SelectedSkin.message_window.rect.top.texture_coord[5], SelectedSkin.message_window.rect.top.texture_coord[6],
                    SelectedSkin.message_window.rect.top.texture_coord[7], SelectedSkin.message_window.rect.top.texture_coord[8]);
    t:ClearAllPoints();
    t:SetPoint("TOPLEFT", fName.."Backdrop_TL", "TOPRIGHT", 0, 0);
    t:SetPoint("BOTTOMRIGHT", fName.."Backdrop_TR", "BOTTOMLEFT", 0, 0);
    local b = obj.widgets.Backdrop.b;
    b:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    b:SetTexCoord(SelectedSkin.message_window.rect.bottom.texture_coord[1], SelectedSkin.message_window.rect.bottom.texture_coord[2],
                    SelectedSkin.message_window.rect.bottom.texture_coord[3], SelectedSkin.message_window.rect.bottom.texture_coord[4],
                    SelectedSkin.message_window.rect.bottom.texture_coord[5], SelectedSkin.message_window.rect.bottom.texture_coord[6],
                    SelectedSkin.message_window.rect.bottom.texture_coord[7], SelectedSkin.message_window.rect.bottom.texture_coord[8]);
    b:ClearAllPoints();
    b:SetPoint("TOPLEFT", fName.."Backdrop_BL", "TOPRIGHT", 0, 0);
    b:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "BOTTOMLEFT", 0, 0);
    local l = obj.widgets.Backdrop.l;
    l:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    l:SetTexCoord(SelectedSkin.message_window.rect.left.texture_coord[1], SelectedSkin.message_window.rect.left.texture_coord[2],
                    SelectedSkin.message_window.rect.left.texture_coord[3], SelectedSkin.message_window.rect.left.texture_coord[4],
                    SelectedSkin.message_window.rect.left.texture_coord[5], SelectedSkin.message_window.rect.left.texture_coord[6],
                    SelectedSkin.message_window.rect.left.texture_coord[7], SelectedSkin.message_window.rect.left.texture_coord[8]);
    l:ClearAllPoints();
    l:SetPoint("TOPLEFT", fName.."Backdrop_TL", "BOTTOMLEFT", 0, 0);
    l:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BL", "TOPRIGHT", 0, 0);
    local r = obj.widgets.Backdrop.r;
    r:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    r:SetTexCoord(SelectedSkin.message_window.rect.right.texture_coord[1], SelectedSkin.message_window.rect.right.texture_coord[2],
                    SelectedSkin.message_window.rect.right.texture_coord[3], SelectedSkin.message_window.rect.right.texture_coord[4],
                    SelectedSkin.message_window.rect.right.texture_coord[5], SelectedSkin.message_window.rect.right.texture_coord[6],
                    SelectedSkin.message_window.rect.right.texture_coord[7], SelectedSkin.message_window.rect.right.texture_coord[8]);
    r:ClearAllPoints();
    r:SetPoint("TOPLEFT", fName.."Backdrop_TR", "BOTTOMLEFT", 0, 0);
    r:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "TOPRIGHT", 0, 0);
    local bg = obj.widgets.Backdrop.bg;
    bg:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    bg:SetTexCoord(SelectedSkin.message_window.rect.background.texture_coord[1], SelectedSkin.message_window.rect.background.texture_coord[2],
                    SelectedSkin.message_window.rect.background.texture_coord[3], SelectedSkin.message_window.rect.background.texture_coord[4],
                    SelectedSkin.message_window.rect.background.texture_coord[5], SelectedSkin.message_window.rect.background.texture_coord[6],
                    SelectedSkin.message_window.rect.background.texture_coord[7], SelectedSkin.message_window.rect.background.texture_coord[8]);
    bg:ClearAllPoints();
    bg:SetPoint("TOPLEFT", fName.."Backdrop_TL", "BOTTOMRIGHT", 0, 0);
    bg:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "TOPLEFT", 0, 0);
    
    --set class icon
    local class_icon = obj.widgets.class_icon;
    class_icon:SetTexture(SelectedSkin.message_window.class_icon.file[SelectedStyle]);
    class_icon:ClearAllPoints();
    class_icon:SetPoint(SelectedSkin.message_window.class_icon.rect.anchor, fName.."Backdrop", SelectedSkin.message_window.class_icon.rect.anchor, SelectedSkin.message_window.class_icon.rect.offset.x, SelectedSkin.message_window.class_icon.rect.offset.y);
    class_icon:SetWidth(SelectedSkin.message_window.class_icon.rect.size.x);
    class_icon:SetHeight(SelectedSkin.message_window.class_icon.rect.size.y);
    --WIM_UpdateMessageWindowClassIcon(obj);
    
    --set from font
    local from = obj.widgets.from;
    from:ClearAllPoints();
    from:SetPoint(SelectedSkin.message_window.strings.from.rect.anchor, fName.."Backdrop", SelectedSkin.message_window.strings.from.rect.anchor, SelectedSkin.message_window.strings.from.rect.offset.x, SelectedSkin.message_window.strings.from.rect.offset.y);
    from:SetFontObject(getglobal(SelectedSkin.message_window.strings.from.inherits_font));
    
    --set character details font
    local char_info = obj.widgets.char_info;
    char_info:ClearAllPoints();
    char_info:SetPoint(SelectedSkin.message_window.strings.char_info.rect.anchor, fName.."Backdrop", SelectedSkin.message_window.strings.char_info.rect.anchor, SelectedSkin.message_window.strings.char_info.rect.offset.x, SelectedSkin.message_window.strings.char_info.rect.offset.y);
    char_info:SetFontObject(getglobal(SelectedSkin.message_window.strings.char_info.inherits_font));
    char_info:SetTextColor(SelectedSkin.message_window.strings.char_info.color[1], SelectedSkin.message_window.strings.char_info.color[2], SelectedSkin.message_window.strings.char_info.color[3]);
    --WIM_MessageWindow_RefreshCharacterDetails(obj);

    --close button
    local close = obj.widgets.close;
    close:ClearAllPoints();
    close:SetPoint(SelectedSkin.message_window.buttons.close.rect.anchor, fName, SelectedSkin.message_window.buttons.close.rect.anchor, SelectedSkin.message_window.buttons.close.rect.offset.x, SelectedSkin.message_window.buttons.close.rect.offset.y);
    close:SetWidth(SelectedSkin.message_window.buttons.close.rect.size.x);
    close:SetHeight(SelectedSkin.message_window.buttons.close.rect.size.y);
    close:SetNormalTexture(SelectedSkin.message_window.buttons.close.NormalTexture[SelectedStyle]);
    close:SetPushedTexture(SelectedSkin.message_window.buttons.close.PushedTexture[SelectedStyle]);
    close:SetHighlightTexture(SelectedSkin.message_window.buttons.close.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.close.HighlightAlphaMode);
    
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
    scroll_up:ClearAllPoints();
    scroll_up:SetPoint(SelectedSkin.message_window.buttons.scroll_up.rect.anchor, fName, SelectedSkin.message_window.buttons.scroll_up.rect.anchor, SelectedSkin.message_window.buttons.scroll_up.rect.offset.x, SelectedSkin.message_window.buttons.scroll_up.rect.offset.y);
    scroll_up:SetWidth(SelectedSkin.message_window.buttons.scroll_up.rect.size.x);
    scroll_up:SetHeight(SelectedSkin.message_window.buttons.scroll_up.rect.size.y);
    scroll_up:SetNormalTexture(SelectedSkin.message_window.buttons.scroll_up.NormalTexture[SelectedStyle]);
    scroll_up:SetPushedTexture(SelectedSkin.message_window.buttons.scroll_up.PushedTexture[SelectedStyle]);
    scroll_up:SetDisabledTexture(SelectedSkin.message_window.buttons.scroll_up.DisabledTexture[SelectedStyle]);
    scroll_up:SetHighlightTexture(SelectedSkin.message_window.buttons.scroll_up.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.scroll_up.HighlightAlphaMode);
    
    --scroll_down button
    local scroll_down = obj.widgets.scroll_down;
    scroll_down:ClearAllPoints();
    scroll_down:SetPoint(SelectedSkin.message_window.buttons.scroll_down.rect.anchor, fName, SelectedSkin.message_window.buttons.scroll_down.rect.anchor, SelectedSkin.message_window.buttons.scroll_down.rect.offset.x, SelectedSkin.message_window.buttons.scroll_down.rect.offset.y);
    scroll_down:SetWidth(SelectedSkin.message_window.buttons.scroll_down.rect.size.x);
    scroll_down:SetHeight(SelectedSkin.message_window.buttons.scroll_down.rect.size.y);
    scroll_down:SetNormalTexture(SelectedSkin.message_window.buttons.scroll_down.NormalTexture[SelectedStyle]);
    scroll_down:SetPushedTexture(SelectedSkin.message_window.buttons.scroll_down.PushedTexture[SelectedStyle]);
    scroll_down:SetDisabledTexture(SelectedSkin.message_window.buttons.scroll_down.DisabledTexture[SelectedStyle]);
    scroll_down:SetHighlightTexture(SelectedSkin.message_window.buttons.scroll_down.HighlightTexture[SelectedStyle],  SelectedSkin.message_window.buttons.scroll_down.HighlightAlphaMode);
    
    --chat display
    local chat_display = obj.widgets.chat_display;
    chat_display:ClearAllPoints();
    chat_display:SetPoint("TOPLEFT", fName, "TOPLEFT", SelectedSkin.message_window.chat_display.rect.tl_offset.x, SelectedSkin.message_window.chat_display.rect.tl_offset.y);
    chat_display:SetPoint("BOTTOMRIGHT", fName, "BOTTOMRIGHT", SelectedSkin.message_window.chat_display.rect.br_offset.x, SelectedSkin.message_window.chat_display.rect.br_offset.y);
    local font, height, flags = getglobal(WIM_Data.skin.font):GetFont();
    chat_display:SetFont(font, WIM_Data.fontSize+2, WIM_Data.skin.font_outline);

    --msg_box
    local msg_box = obj.widgets.msg_box;
    msg_box:ClearAllPoints();
    msg_box:SetPoint("TOPLEFT", fName, "BOTTOMLEFT", SelectedSkin.message_window.msg_box.rect.tl_offset.x, SelectedSkin.message_window.msg_box.rect.tl_offset.y);
    msg_box:SetPoint("BOTTOMRIGHT", fName, "BOTTOMRIGHT", SelectedSkin.message_window.msg_box.rect.br_offset.x, SelectedSkin.message_window.msg_box.rect.br_offset.y);
    local font, height, flags = getglobal(WIM_Data.skin.font):GetFont();
    msg_box:SetFont(font, SelectedSkin.message_window.msg_box.font_height, WIM_Data.skin.font_outline);
    msg_box:SetTextColor(SelectedSkin.message_window.msg_box.font_color[1], SelectedSkin.message_window.msg_box.font_color[2], SelectedSkin.message_window.msg_box.font_color[3]);
    
    --shorcuts
    --local shortcuts = getglobal(fName.."ShortcutFrame");
    --shortcuts:ClearAllPoints();
    --shortcuts:SetPoint(SelectedSkin.message_window.shortcuts.rect.anchor, fName, SelectedSkin.message_window.shortcuts.rect.anchor, SelectedSkin.message_window.shortcuts.rect.offset.x, SelectedSkin.message_window.shortcuts.rect.offset.y);
    --shortcuts:SetWidth(10);
    --shortcuts:SetHeight(10);
    --MessageWindow_ArrangeShortcutBar(shortcuts);
    
    --WIM_SetWindowProps(obj);
    
    if(isSmartStyle) then
        SelectedStyle = prevStyle;
    end
end

local function deleteStyleFileEntries(theTable)
    if(type(theTable) == "table") then
        for key, _ in pairs(theTable) do
            theTable[key] = nil;
        end
    end
end




function WIM:RegisterPrematureSkins()
    for i=1,table.getn(prematureRegisters) do
        WIM:RegisterSkin(prematureRegisters[i]);
    end
end

function WIM:GetSelectedSkin()
    return SelectedSkin;
end

function WIM:GetSelectedStyle()
    return SelectedStyle;
end

function WIM:LoadSkin(skinName, style)
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
    
    WIM.db.skin.selected = skinName;
    WIM.db.skin.style = style;
    
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
        WIM:ApplySkinToWindow(window_objects[i].obj);
    end
end

function WIM:RegisterFont(objName, title)
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


function WIM:RegisterSkin(skinTable)
    if(not WIM.isInitialized) then
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
        if(skinTable.title == WIM.db.skin.selected) then
            WIM:LoadSkin(WIM.db.skin.selected, WIM.db.skin.style);
        end
        -- create skin template from WIM Classic and remove any style references.
        WIM.copyTable(SkinTable["WIM Classic"], SkinTemplate);
        deleteStyleFileEntries(SkinTemplate.styles);
        deleteStyleFileEntries(SkinTemplate.message_window.file);
        deleteStyleFileEntries(SkinTemplate.message_window.class_icon.file);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.close.NormalTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.close.PushedTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.close.HighlightTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.history.NormalTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.history.PushedTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.history.HighlightTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.w2w.NormalTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.w2w.PushedTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.w2w.HighlightTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.chatting.NormalTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.chatting.PushedTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_up.NormalTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_up.PushedTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_up.HighlightTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_up.DisabledTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_down.NormalTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_down.PushedTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_down.HighlightTexture);
        deleteStyleFileEntries(SkinTemplate.message_window.buttons.scroll_down.DisabledTexture);
        return;
    end
    
    -- inherrit missing data from default skin.
    WIM.copyTable(SkinTable["WIM Classic"], skinTable);
        
    --check if default style images exist. if not, inherrit from 'WIM Classic'
    if(not skinTable.message_window.file[skinTable.default_style]) then skinTable.message_window.file[skinTable.default_style] = SkinTable["WIM Classic"].message_window.file.default; end
    if(not skinTable.message_window.class_icon.file[skinTable.default_style]) then skinTable.message_window.class_icon.file[skinTable.default_style] = SkinTable["WIM Classic"].message_window.class_icon.file.default; end
    if(not skinTable.message_window.buttons.close.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.close.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.close.NormalTexture.default; end
    if(not skinTable.message_window.buttons.close.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.close.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.close.PushedTexture.default; end
    if(not skinTable.message_window.buttons.close.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.close.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.close.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.history.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.history.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.history.NormalTexture.default; end
    if(not skinTable.message_window.buttons.history.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.history.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.history.PushedTexture.default; end
    if(not skinTable.message_window.buttons.history.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.history.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.history.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.w2w.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.w2w.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.w2w.NormalTexture.default; end
    if(not skinTable.message_window.buttons.w2w.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.w2w.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.w2w.PushedTexture.default; end
    if(not skinTable.message_window.buttons.w2w.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.w2w.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.w2w.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.chatting.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.chatting.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.chatting.NormalTexture.default; end
    if(not skinTable.message_window.buttons.chatting.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.chatting.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.chatting.PushedTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.NormalTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.PushedTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.DisabledTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.DisabledTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.DisabledTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.NormalTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.PushedTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.DisabledTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.DisabledTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.DisabledTexture.default; end
    
    
    -- enforce the existance of style file declarations.
    for i=1,table.getn(styles) do
        if(not skinTable.message_window.file[styles[i]]) then skinTable.message_window.file[styles[i]] = skinTable.message_window.file[skinTable.default_style]; end
        if(not skinTable.message_window.class_icon.file[styles[i]]) then skinTable.message_window.class_icon.file[styles[i]] = skinTable.message_window.class_icon.file[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.close.NormalTexture[styles[i]]) then skinTable.message_window.buttons.close.NormalTexture[styles[i]] = skinTable.message_window.buttons.close.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.close.PushedTexture[styles[i]]) then skinTable.message_window.buttons.close.PushedTexture[styles[i]] = skinTable.message_window.buttons.close.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.close.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.close.HighlightTexture[styles[i]] = skinTable.message_window.buttons.close.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.history.NormalTexture[styles[i]]) then skinTable.message_window.buttons.history.NormalTexture[styles[i]] = skinTable.message_window.buttons.history.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.history.PushedTexture[styles[i]]) then skinTable.message_window.buttons.history.PushedTexture[styles[i]] = skinTable.message_window.buttons.history.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.history.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.history.HighlightTexture[styles[i]] = skinTable.message_window.buttons.history.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.w2w.NormalTexture[styles[i]]) then skinTable.message_window.buttons.w2w.NormalTexture[styles[i]] = skinTable.message_window.buttons.w2w.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.w2w.PushedTexture[styles[i]]) then skinTable.message_window.buttons.w2w.PushedTexture[styles[i]] = skinTable.message_window.buttons.w2w.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.w2w.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.w2w.HighlightTexture[styles[i]] = skinTable.message_window.buttons.w2w.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.chatting.NormalTexture[styles[i]]) then skinTable.message_window.buttons.chatting.NormalTexture[styles[i]] = skinTable.message_window.buttons.chatting.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.chatting.PushedTexture[styles[i]]) then skinTable.message_window.buttons.chatting.PushedTexture[styles[i]] = skinTable.message_window.buttons.chatting.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.NormalTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.NormalTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.PushedTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.PushedTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.HighlightTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.DisabledTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.DisabledTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.DisabledTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.NormalTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.NormalTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.PushedTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.PushedTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.HighlightTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.DisabledTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.DisabledTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.DisabledTexture[skinTable.default_style]; end
    end
    
    
    -- finalize registration
    SkinTable[skinTable.title] = skinTable;
    
    -- if this is the selected skin, load it now
    if(skinTable.title == WIM_Data.skin.selected) then
        WIM:LoadSkin(WIM.db.skin.selected, WIM.db.skin.style);
    end
end

function WIM:GetFontKeyByName(fontName)
	for key, val in pairs(fontTable) do
		if(val == fontName) then
			return key;
		end
	end
	return nil;
end

