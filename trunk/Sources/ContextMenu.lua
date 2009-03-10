local WIM = WIM;

-- imports
local _G = _G;
local table = table;
local string = string;
local pairs = pairs;
local type = type;
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton;
local UIDropDownMenu_CreateInfo = UIDropDownMenu_CreateInfo
local UIDropDownMenu_Initialize = UIDropDownMenu_Initialize;
local ToggleDropDownMenu = ToggleDropDownMenu;

-- set namespace
setfenv(1, WIM);

local menuFrame = _G.CreateFrame("Frame", "WIM3_ContextMenu", _G.UIParent, "UIDropDownMenuTemplate");

local ctxMenu = {};

local MENU_ID = 1;

local CurMenu;

local function getMenuByTitle(text)
    for key, val in pairs(ctxMenu) do
        if(val.text == text) then
            return key;
        end
    end
    return;
end

local function addMenuItem(info)
    -- required checks
    if(type(info) ~= "table" and not info.txt) then return; end
    
    local item = {};
    for key, val in pairs(info) do
        item[key] = val;
    end
    
    ctxMenu[MENU_ID] = item;
    item.MENU_ID = MENU_ID;
    MENU_ID = MENU_ID + 1;
    
    item.AddSubItem = function(self, info, insertAt)
        local sub = addMenuItem(info);
        if(not self.menuTable) then
            self.menuTable = {};
        end
        if(insertAt) then
            table.insert(self.menuTable, insertAt, sub);
        else
            table.insert(self.menuTable, sub);
        end
        self.hasArrow = true;
        self.value = self.MENU_ID;
        return sub;
    end
    return item;
end

local function initializeMenu(frame, level, menuTable)
    level = level or _G.UIDROPDOWNMENU_MENU_LEVEL;
    if(level > 1 and _G.UIDROPDOWNMENU_MENU_VALUE) then
        CurMenu = ctxMenu[_G.tonumber(_G.UIDROPDOWNMENU_MENU_VALUE)];
    end
    if(not CurMenu) then
        dPrint("ContextMenu Error - Menu not set.");
        return; -- menu not set
    end
    dPrint("Initializing Menu - level "..level);
    local items = CurMenu.menuTable;
    if(not items) then
        return;
    end
    for i=1, #items do
        local info = UIDropDownMenu_CreateInfo();
        for key, val in pairs(items[i]) do
            info[key] = val;
        end
        if(not info.hidden) then
            UIDropDownMenu_AddButton(info, level);
        end
    end
end


-- global API

function PopContextMenu(menu, parent)
    local id = getMenuByTitle(menu);
    if(id) then
        _G.CloseDropDownMenus();
        dPrint("Popping menu ["..menu.."]:"..id..".");
        CurMenu = ctxMenu[id];
        _G.UIDROPDOWNMENU_MENU_VALUE = nil;
        if(WIM.Menu) then
            WIM.Menu:Hide();
        end
        UIDropDownMenu_Initialize(menuFrame, initializeMenu, "MENU");
        ToggleDropDownMenu(1, 1, menuFrame, parent, 0, 0);
    else
        dPrint("Menu ["..menu.."] not found!")
    end
end

function AddContextMenu(info)
    local item = addMenuItem(info)
    if(item) then
        dPrint("Menu ["..item.text.."] registered with ContextMenu.");
    else
        dPrint("Menu failed to register with ContextMenu.")
    end
    return item;
end

function GetContextMenuByName(title)
    local id = getMenuByTitle(title)
    if(id) then
        return ctxMenu[id];
    else
        return nil;
    end
end

