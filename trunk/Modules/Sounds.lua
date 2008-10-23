--imports
local WIM = WIM;
local _G = _G;
local PlaySoundFile = PlaySoundFile;
local SML = _G.LibStub:GetLibrary("LibSharedMedia-3.0");
local SOUND = SML.MediaType.SOUND;

--set namespace
setfenv(1, WIM);

db_defaults.sounds = {
    whispers = {
        msgin = true,
        msgin_sml = "IM",
        msgout = false,
        msgout_sml = "IM",
        friend = false,
        friend_sml = "IM",
        guild = false,
        guild_sml = "IM"
    }
};

local Sounds = CreateModule("Sounds", true);

local function playSound(smlKey)
    local path = SML:Fetch(SOUND, smlKey);
    if path then
        PlaySoundFile(path);
    end
end


-- Sound events
function Sounds:PostEvent_Whisper(...)
    if(db and db.sounds.whispers.msgin) then
        local msg, user = ...;
        if(db.sounds.whispers.friend and lists.friends[user]) then
            playSound(db.sounds.whispers.friend_sml);
        elseif(db.sounds.whispers.guild and lists.guild[user]) then
            playSound(db.sounds.whispers.guild_sml);
        else
            playSound(db.sounds.whispers.msgin_sml);
        end
    end
end

function Sounds:PostEvent_WhisperInform(...)
    if(db and db.sounds.whispers.msgout) then
        playSound(db.sounds.whispers.msgout_sml);
    end
end





-- import WIM's stock sounds into LibSharedMedia-3.0
SML:Register(SOUND, "IM", "Interface\\AddOns\\"..addonTocName.."\\Sounds\\wisp.wav");
SML:Register(SOUND, "iChat In", "Interface\\AddOns\\"..addonTocName.."\\Sounds\\ichatIn.mp3");
SML:Register(SOUND, "iChat Out", "Interface\\AddOns\\"..addonTocName.."\\Sounds\\ichatOut.mp3");


-- This is a core module and must always be loaded...
Sounds.canDisable = false;
Sounds:Enable();