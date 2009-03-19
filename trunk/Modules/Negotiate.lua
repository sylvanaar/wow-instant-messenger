-- imports
local WIM = WIM;
local _G = _G;
local pairs = pairs;
local string = string;
local table = table;
local time = time;
local tonumber = tonumber;

-- set namespace
setfenv(1, WIM);

local Module = CreateModule("Negotiate", true);

local maxVersion = version;
local alreadyAlerted = false;

db_defaults.rememberWho = false;
local WHO_LIST = {};

Module:RegisterEvent("FRIENDLIST_UPDATE");
Module:RegisterEvent("GUILD_ROSTER_UPDATE");
Module:RegisterEvent("PARTY_MEMBERS_CHANGED");

-- Counters to avoid spamming Negotiate.
local friends_c = 0;
local guild_c = 0;
local party_c = 0;


local function Negotiate(ttype, target)
    SendData(ttype, target, "NEGOTIATE", version..":"..(beta and "1" or "0"));
end

local function getFriendsOnline()
    local count = 0;
    for i=1, _G.GetNumFriends() do 
	local name, level, class, area, connected, status, note = _G.GetFriendInfo(i);
	if(connected) then
            count = count + 1;
        end
    end
    return count;
end


function Module:FRIENDLIST_UPDATE()
    if(friends ~= getFriendsOnline()) then
        friends_c = 0;
        for i=1, _G.GetNumFriends() do 
            local name, level, class, area, connected, status, note = _G.GetFriendInfo(i);
            if(connected) then
                friends_c = friends_c + 1;
                Negotiate("WHISPER", name); --[set place holder for quick lookup
            end
        end
    end
end

function Module:GUILD_ROSTER_UPDATE()
    if( guild_c ~= _G.GetNumGuildMembers()) then
        Negotiate("GUILD");
        guild_c = _G.GetNumGuildMembers();
    end
end

function Module:PARTY_MEMBERS_CHANGED()
    if(_G.GetNumRaidMembers() > 0) then
        if(party_c ~= _G.GetNumRaidMembers()) then
            Negotiate("RAID");
            party_c = _G.GetNumRaidMembers();
        end
    else
        Negotiate("PARTY");
        party_c = 0; -- this can be reset. not worth over head of counting party members.
    end
end

function Module:OnWindowCreated(win)
    if(win.type == "whisper") then
        Negotiate("WHISPER", win.theUser);
    end
end

RegisterAddonMessageHandler("NEGOTIATE", function(from, data)
        local v, isBeta = string.match(data, "^(.+):(%d)");
        local diff = CompareVersion(v);
        if(diff > 0) then
            if(not alreadyAlerted and tonumber(isBeta) == 0) then
                -- there is a newer version
                alreadyAlerted = true;
                DisplayTutorial(L["WIM Update Available!"], _G.format(L["There is a newer version of WIM available for download. You can download it at %s."], "|cff69ccf0WIMAddon.com|r"))
            end
        elseif(diff < 0) then
            -- user has an older version, let him know.
            Negotiate("WHISPER", from);
        end
        if(db.rememberWho) then
            WHO_LIST[from] = v..(tonumber(isBeta)==1 and " BETA" or "");
        end
    end);
    
    
function WhoList(arg)
    if(string.lower(arg) == "on") then
        db.rememberWho = true;
        _G.ReloadUI();
        return;
    elseif(string.lower(arg) == "off") then
        db.rememberWho = false;
        _G.ReloadUI();
        return;
    end
    if(not db.rememberWho) then
        _G.DEFAULT_CHAT_FRAME:AddMessage("WIM is not set to remember user encounters.");
        _G.DEFAULT_CHAT_FRAME:AddMessage("usage: /wim who on      /wim who off");
        return;
    end
    local count = 0;
    for user, v in pairs(WHO_LIST) do
        _G.DEFAULT_CHAT_FRAME:AddMessage("|Hplayer:"..user.."|h"..user.."|h   "..v);
        count = count + 1;
    end
    _G.DEFAULT_CHAT_FRAME:AddMessage("Total found using WIM: "..count);
end
