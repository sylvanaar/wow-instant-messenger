local WIM = WIM;


local Sounds = WIM.CreateModule("Sounds", true);

function Sounds:PostEvent_Whisper(...)
    PlaySoundFile("Interface\\AddOns\\"..WIM.addonTocName.."\\Sounds\\wisp.wav");
end
