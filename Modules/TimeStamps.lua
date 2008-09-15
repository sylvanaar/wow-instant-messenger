--imports
local WIM = WIM;
local _G = _G;
local time = time;
local date = date;

--set namespace
setfenv(1, WIM);

local TimeStamps = WIM.CreateModule("TimeStamps", true);

-- define available timeStamps
local formats = {
    "%I:%M",	  -- HH:MM (12hr)
    "%I:%M %p",	  -- HH:MM AM/PM (12hr)
    "%H:%M",	  -- HH:MM (24hr)
    "%I:%M:%S",	  -- HH:MM:SS (12hr)
    "%I:%M:%S %p",-- HH:MM:SS AM/PM (12hr)
    "%H:%M:%S"	  -- HH:MM:SS (24hr)
};

db_defaults.timeStampFormat = formats[3];


local function addTimeStamp(msg)
    return GetTimeStamp().." "..msg;
end


function TimeStamps:OnEnable()
    RegisterStringModifier(addTimeStamp);
end

function TimeStamps:OnDisable()
    UnregisterStringModifier(addTimeStamp);
end

-- Global
function GetTimeStamp(cTime)
    cTime = cTime or nextStamp or time();
    local stamp = "|cff"..RGBPercentToHex(db.displayColors.sysMsg.r, db.displayColors.sysMsg.g, db.displayColors.sysMsg.b)..date(db.timeStampFormat, cTime).."|r";
    nextStamp = nil;
    return stamp;
end

function GetTimeStampFormats()
    return formats;
end
