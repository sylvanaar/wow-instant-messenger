--imports
local WIM = WIM;
local _G = _G;
local PlaySoundFile = PlaySoundFile;

--set namespace
setfenv(1, WIM);


local Sounds = CreateModule("Sounds", true);

function Sounds:PostEvent_Whisper(...)
    PlaySoundFile("Interface\\AddOns\\"..addonTocName.."\\Sounds\\wisp.wav");
end
