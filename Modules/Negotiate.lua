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


Module:RegisterEvent("FRIENDLIST_UPDATE");
Module:RegisterEvent("GUILD_ROSTER_UPDATE");
Module:RegisterEvent("PARTY_MEMBERS_CHANGED");


local function Negotiate(ttype, target)
    SendData(ttype, target, "NEGOTIATE", version..":"..(beta and "1" or "0"));
end

function Module:FRIENDLIST_UPDATE()
    for i=1, _G.GetNumFriends() do 
	local name, level, class, area, connected, status, note = _G.GetFriendInfo(i);
	if(connected) then
	    Negotiate("WHISPER", name); --[set place holder for quick lookup
        end
    end
end

function Module:GUILD_ROSTER_UPDATE()
    Negotiate("GUILD");
end

function Module:PARTY_MEMBERS_CHANGED()
    if(_G.GetNumRaidMembers() > 0) then
        Negotiate("RAID");
    else
        Negotiate("PARTY");
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
        if(diff > 0 and not alreadyAlerted and tonumber(isBeta) == 0) then
            -- there is a newer version
            alreadyAlerted = true;
            DisplayTutorial(L["WIM Update Available!"], _G.format(L["There is a newer version of WIM available for download. You can download it at %s."], "|cff69ccf0WIMAddon.com|r"))
        elseif(diff < 0 and not beta) then
            -- user has an older version, let him know.
            Negotiate("WHISPER", from);
        end
    end);
    