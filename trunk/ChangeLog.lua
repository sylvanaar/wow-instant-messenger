--[[
    This change log was meant to be viewed in game.
    You may do so by typing: /wim changelog
]]
local currentRevision = tonumber(("$Revision$"):match("(%d+)"));
local log = {};
local t_insert = table.insert;

local function addEntry(version, rdate, description, transmitted)
    t_insert(log, {v = version, r = rdate, d = description, t=transmitted and true});
end


-- ChangeLog Entries.
addEntry("3.0.8", "03/??/2008", [[
    +Added section for WIM in Blizzard's keybinding interface.
    +Added 'Expose' feature as well as options (combat & visual).
    *Fixed they way modules were being handled when WIM enabled is toggled.
    +Added Enable/Disable WIM to Minimap right-click menu.
    -Removed <GM> tag from GM's names & fixed error when whispering a GM.
    *Fixed bug when splitting long messages. Thanks blazeflack.
    *Options & History window now toggle on and off if called more than once.
    *Fixed various bugs in the Socket & Compression Sources.
    +View changelog before you upgrade WIM. Changelog shared with friends.
]]);

addEntry("3.0.7", "03/12/2008", [[
    +Added context menu management system.
    +Added minimap icon right mouse click menu.
    *Modules were getting loaded on startup regardless of their settings.
    *Fixed a bug where tabs would be updated incorrectly.
    *Fixed freeze/lockup bug when switching tabs.
    +Added <Right-Click> drop down menu to window's text box.
    +Added emoticons to the drop down menu.
    +Added recently sent messages to drop down menu.
    +Added koKR translation. (thank you BlueNyx).
]]);

addEntry("3.0.6", "03/10/2008", [[
    *Fixed: Error when receiving whisper while minimizing.
    *Fixed: Negotiating with guild members would cause addon msg spam.
    *Changed outbound whispers priority from NORMAL to ALERT.
    *Fix for 3.0.8/9 patch. GM's should no longer receive addon messages.
    +Tabs now flash when it contains an unread message.
    *Fixed error when closing tabs.
    +Added LibChatHandler-1.0 for chat management. I will post documentation for this.
    *Fixed Level lookup.
    *LibBabbel-TalentTree is no longer packaged with WIM.
    +Added compatibility for PTR ChatEventFilters.
    +Added Change Log Viewer (/wim changelog).
    *Set cache timeout of 60 seconds for filter level lookups.
    *Fixed error that would sometimes occur when right mouse clicking the minimap icon.
    *Fixed bug which caused tabbed windows to pop regardless of selected rules.
    *Level filtering wasn't recording stats.
    +Added option to filters to send alert chat frame when a message is blocked.
    -Depricated WIM:EventHandler() to avoid conflict with old WIM event hooks.
    *Revised the module calls made when WIM is enabled/disabled.
    *Fixed bug in history viewer when using Prat formatting.
    +Addon messages are never sent if on a private server.
    *Fixed inconsistant pop rules.
    +<TAB> and <Shift>+<Tab> can be used to navigate through a tab group
    *Tabstrip updates to show selected tab when window is popped/shown.
    +Moving the minimap icon now requires you to hold <Shift> while dragging.
    +Added option to unlock Minimap Icon from the Minimap (Free Moving).
]]);
addEntry("3.0.5", "12/02/2008", [[
    *Fixed: Who lookups wouldn't update if already cached.
    *Fixed: Default Spamfilter wasn't working as intended.
    *Loading of skins also updates character info as well.
    *Fixed the history viewer. For real this time? (Thanks Stewart)
    *History text view loads correctly now on first click. (Thanks Stewart)
    *History text views are stripped of all colors and emoticons.
    +Added Russian translations. (Thanks Stingersoft)
    *Fixed: System message of user coming online wasn't being handled correctly.
    +Added libraries to optional dependencies to allow for disembedded addons.
    *Moved Window Alpha option from Window Settings to Display Settings.
    +Added Window Strata option to Window Settings.
    *Fixed: History viewer wasn't loading for entire realm.
    *Fixed: Tabs now honor focus as intended. (Thanks Stewart)
]]);
addEntry("3.0.4", "11/12/2008", [[
    *History frame was named incorrectly. 'WIM3_HistoryFrame' is its new name.
    *Socket only compresses large transmissions to minimize resource usage.
    *Optimized tabs.
    *Tabs scroll correctly now.
    *Location button on shortcut uses special W2W tooltip if applicable.
    *History viewer wasn't displaying realms which had non-alphanumeric characters in it.
    *Fixed bug where alerts where referencing minimap icon even though it hasn't been loaded.
    +WIM now comes packaged with LibBabble-TalentTree-3.0 and further defines class information.
    +Added W2W Talent Spec sharing.
    *Lowered options frame strata from DIALOG to MEDIUM.
    *Fixed animation crash (Caused by blizzards ScrollingMessageFrame).
    +WIM's widget API now calls UpdateSkin method of widget if available upon skin loading.
    *Long messages are now split correclty without breaking links.
    *LastTellTarget is not set correctly when receiving AFK & DND responses.
    +WIM now uses LibWho-2.0. WhoLib-1.0 is now considered depricated.
    -Removed dependencies(libs) of all Ace2 addons including Deformat.
]]);
addEntry("3.0.3", "10/23/2008", [[
    +Added Tab Management module. (Auto grouping of windows.)
    *Avoid any chances of dividing by 0 in window animation.
    *Changed window behavior priorities to: Arena, Combat, PvP, Raid, Party, Resting Other.
    *Fixed bug when running WIM on WOTLK.
    +W2W Typing notification is triggered from the default chat frame now too.
    -W2W will no longer notify user as typing if user is typing a slash command.
    *Fixed a resizing bug when using tabs. Entire tab group inherits size until removed.
    +Added ChangeLog.lua (contains release information to be used later.)
    *Corrected shaman class color.
    *Focus gain also respects Blizzard's ChatEditFrame.
    *Filters are no longer trimmed.
    +Added deDE localizations.
    +Added sound options.
    +Added some stock sound files.
]]);


local function entryExists(version)
    for i=1, #log do
        if(log[i].v == version) then
            return true;
        end
    end
    return false;
end

local freshLoad = true;
local function formatEntry(txt)
    local out = "";
    for line in txt:gmatch("([^\n]+)\n") do
        line = line:gsub("^%s*(%+)", " |cff69ccf0+ ");
        line = line:gsub("^%s*(%*)", " |cffc79c6e* ");
        line = line:gsub("^%s*(%-)", " |cffc41f3b- ");
        out = out..line.."|r\n";
    end
    return out;
end


local function getEntryText(index)
    local entry = log[index];
    if(not entry) then return ""; end
    local revision = entry.v == WIM.version and " - Revision "..WIM.GetRevision() or "";
    revision = entry.t and " - |cffff0000"..WIM.L["Available For Download!"].."|r" or revision;
    local txt = "Version "..entry.v.."  ("..entry.r..")"..revision.."\n";
    txt = txt..formatEntry(entry.d);
    
    freshLoad = false;
    return txt.."\n\n";
end

local function logSort(a, b)
    if(WIM.CompareVersion(a.v, b.v) > 0) then
        return true;
    else
        return false;
    end
end

local changeLogWindow;
local function createChangeLogWindow()
    -- create frame object
    local win = CreateFrame("Frame", "WIM3_ChangeLog", _G.UIParent);
    win:Hide(); -- hide initially, scripts aren't loaded yet.
    
    -- set size and position
    win:SetWidth(700);
    win:SetHeight(500);
    win:SetPoint("CENTER");
    
    -- set backdrop
    win:SetBackdrop({bgFile = "Interface\\AddOns\\"..WIM.addonTocName.."\\Sources\\Options\\Textures\\Frame_Background", 
        edgeFile = "Interface\\AddOns\\"..WIM.addonTocName.."\\Sources\\Options\\Textures\\Frame", 
        tile = true, tileSize = 64, edgeSize = 64, 
        insets = { left = 64, right = 64, top = 64, bottom = 64 }});

    -- set basic frame properties
    win:SetClampedToScreen(true);
    win:SetFrameStrata("DIALOG");
    win:SetMovable(true);
    win:SetToplevel(true);
    win:EnableMouse(true);
    win:RegisterForDrag("LeftButton");

    -- set script events
    win:SetScript("OnShow", function(self) _G.PlaySound("igMainMenuOpen"); self:update();  end);
    win:SetScript("OnHide", function(self) _G.PlaySound("igMainMenuClose");  end);
    win:SetScript("OnDragStart", function(self) self:StartMoving(); end);
    win:SetScript("OnDragStop", function(self) self:StopMovingOrSizing(); end);
    
    -- create and set title bar text
    win.title = win:CreateFontString(win:GetName().."Title", "OVERLAY", "ChatFontNormal");
    win.title:SetPoint("TOPLEFT", 50 , -20);
    local font = win.title:GetFont();
    win.title:SetFont(font, 16, "");
    win.title:SetText(WIM.L["WIM (WoW Instant Messenger)"].." v"..WIM.version.."   -  "..WIM.L["Change Log"]);
    
    -- create close button
    win.close = CreateFrame("Button", win:GetName().."Close", win);
    win.close:SetWidth(18); win.close:SetHeight(18);
    win.close:SetPoint("TOPRIGHT", -24, -20);
    win.close:SetNormalTexture("Interface\\AddOns\\"..WIM.addonTocName.."\\Sources\\Options\\Textures\\blipRed");
    win.close:SetHighlightTexture("Interface\\AddOns\\"..WIM.addonTocName.."\\Sources\\Options\\Textures\\close", "BLEND");
    win.close:SetScript("OnClick", function(self)
            self:GetParent():Hide();
        end);
    
    win.textFrame = CreateFrame("ScrollFrame", "WIM3_ChangeLogTextFrame", win, "UIPanelScrollFrameTemplate");
    win.textFrame:SetPoint("TOPLEFT", 25, -50);
    win.textFrame:SetPoint("BOTTOMRIGHT", -42, 20);
    
    win.textFrame.text = CreateFrame("SimpleHTML", "WIM3_ChangeLogTextFrameText", win.textFrame);
    win.textFrame.text:SetWidth(win.textFrame:GetWidth());
    win.textFrame.text:SetHeight(200);
    win.textFrame:SetScrollChild(win.textFrame.text);
    
    win.update = function(self)
        local tmp = "";
        freshLoad = true;
        table.sort(log, logSort);
        for i=1, #log do
            tmp = tmp..getEntryText(i);
        end
        self.textFrame.text:SetFontObject(ChatFontNormal);
        self.textFrame.text:SetText(tmp);
        self.textFrame:UpdateScrollChildRect();
    end
    
    return win;
end

local function getEntryString(index)
    local entry = log[index];
    if(entry) then
        local out = entry.v.."\003\003"..entry.r.."\003\003"..entry.d;
        return out;
    else
        return;
    end
end

WIM.RegisterAddonMessageHandler("CHANGELOG", function(from, data)
        local v, r, d = string.match(data, "^(.+)\003\003(.+)\003\003(.+)$");
        WIM.AddChangeLogEntry(v, r, d);
    end);

WIM.RegisterAddonMessageHandler("GETCHANGELOG", function(from, data)
        for i=1, #log do
            if(WIM.CompareVersion(log[i].v, data) > 0) then
                local vd = getEntryString(i);
                if(vd) then
                    --DEFAULT_CHAT_FRAME:AddMessage(vd);
                    WIM.SendData("WHISPER", from, "CHANGELOG", vd);
                end
            end
        end
    end);

WIM.RegisterAddonMessageHandler("NEGOTIATE", function(from, data)
        local v, isBeta = string.match(data, "^(.+):(%d)");
        local diff = WIM.CompareVersion(v);
        if(diff > 0 and tonumber(isBeta) == 0 and not entryExists(v)) then
            WIM.SendData("WHISPER", from, "GETCHANGELOG", WIM.version);
        end
    end);


function WIM.ShowChangeLog()
    changeLogWindow = changeLogWindow or createChangeLogWindow();
    changeLogWindow:Show();
end

function WIM.GetRevision()
    return currentRevision;
end

local transmissionReceived = false;
function WIM.AddChangeLogEntry(version, releaseDate, desc)
    if(type(version) == "string" and type(releaseDate) == "string" and type(desc) == "string" and not entryExists(version)) then
        addEntry(version, releaseDate, desc, true);
        transmissionReceived = true;
        if(changeLogWindow and changeLogWindow:IsShown()) then
            changeLogWindow:update();
        end
    end
end

function WIM.ChangeLogUpdated()
    return transmissionReceived;
end

WIM.RegisterSlashCommand("changelog", WIM.ShowChangeLog, WIM.L["View WIM's change log."]);
