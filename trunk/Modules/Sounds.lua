--imports
local WIM = WIM;
local _G = _G;
local PlaySoundFile = PlaySoundFile;

--set namespace
setfenv(1, WIM);

db_defaults.sounds = {
    whisper_in = true
};

local Sounds = CreateModule("Sounds", true);

function Sounds:PostEvent_Whisper(...)
    if(db and db.sounds.whisper_in) then
        PlaySoundFile("Interface\\AddOns\\"..addonTocName.."\\Sounds\\wisp.wav");
    end
end


-- This is a core module and must always be loaded...
Sounds.canDisable = false;
Sounds:Enable();
