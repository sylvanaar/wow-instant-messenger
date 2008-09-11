-- imports
local WIM = WIM;
local _G = _G;
local setmetatable = setmetatable;
local pairs = pairs;
local type = type;
local tostring = tostring;
local table = table;

-- set WIM Namespace
setfenv(1, WIM);

local UnlocalizedStrings = {};

L = {};

-- we never want nil, so if string is undecalred, return the requested key
setmetatable(L, {
    __index = function(t, k)
        --dPrint("String not localized: '"..tostring(k).."'"); -- for debugging purposes only.
        table.insert(UnlocalizedStrings, tostring(k));
        return tostring(k);    
    end
});

function AddLocale(Locale, lTable)
    if(_G.GetLocale() == Locale or Locale == "enUS") then
        for k, v in pairs(lTable) do
            v = (type(v) ~= "boolean") and v or k;
            L[k] = v;
            lTable[k] = nil; -- clean up the garbage now.
        end
    end
end

-- a debugging function
function ShowUnlocalizedStrings()
    for i = 1, #UnlocalizedStrings do
        _G.DEFAULT_CHAT_FRAME:AddMessage(i..". '"..UnlocalizedStrings[i].."'");
    end
    _G.DEFAULT_CHAT_FRAME:AddMessage("Total strings not localized: "..#UnlocalizedStrings);
end
