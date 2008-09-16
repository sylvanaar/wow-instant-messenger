--imports
local WIM = WIM;
local _G = _G;
local table = table;
local unpack = unpack;
local string = string;
local pairs = pairs;

--set namespace
setfenv(1, WIM);

local Emote = WIM.CreateModule("Emoticons", true);

-----------------------------------------------------
--                Emoticon Functions               --
-----------------------------------------------------

local LinkRepository = {}; -- used for emotes and link parsing.
local tmpList = {};

local function convertEmoteToPattern(theEmote)
    local special = {"%", ":", "-", "^", "$", ")", "(", "]", "]", "~", "@", "#", "&", "*", "_", "+", "=", ",", ".", "?", "/", "\\", "{", "}", "|", "`", ";", "\"", "'"};
    local i;
    for i=1, table.getn(special) do
        theEmote = string.gsub(theEmote, "%"..special[i], "%%"..special[i]);
    end
    return theEmote;
end

local function getEmoteFilePath(theEmote)
    local emoteTable = GetSelectedSkin().emoticons;

    local tmp = emoteTable.definitions[theEmote];
    -- if emote not found or if mal formed/linked emote, prevent infinate loop.
    if(not tmp or tmp == theEmote) then
        return "";
    else
        if(emoteTable.definitions[tmp]) then
            return getEmoteFilePath(tmp);
        else
            return tmp;
        end
    end
end

local function filterEmoticons(theMsg)

    --saftey check...
    if(not theMsg or theMsg == "") then
        return "";
    end

    --accomodate WoW's built in symbols and inherrit WoW's options whether to display them or not.
    if ( 1 ) then
	local term;
	for tag in string.gmatch(theMsg, "%b{}") do
	    term = string.lower(string.gsub(tag, "[{}]", ""));
	    if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
		theMsg = string.gsub(theMsg, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
	    end
	end
    end

    local emoteTable = GetSelectedSkin().emoticons;
        
    -- first as to not disrupt any links, lets remove them and put them back later.
    local results, orig;
    orig = theMsg;
    LinkRepository[orig] = {};
    local msgRepository = LinkRepository[orig];
    repeat
        theMsg, results = string.gsub(theMsg, "(|H[^|]+|h[^|]+|h)", function(theLink)
            table.insert(msgRepository, theLink);
            return "#LINK"..table.getn(msgRepository).."#";
        end, 1);
    until results == 0;
    
    -- lets exchange emotes...
    local emote, img;
    for emote,_ in pairs(emoteTable.definitions) do
        img = getEmoteFilePath(emote);
        if(img and img ~= "") then
            theMsg = string.gsub(theMsg, convertEmoteToPattern(emote), "|T"..img..":"..emoteTable.width..":"..emoteTable.height..":"..emoteTable.offset[1]..":"..emoteTable.offset[2].."|t");
        end
    end
        
    -- put all the links back into the string...
    for i=1, table.getn(msgRepository) do
        theMsg = string.gsub(theMsg, "#LINK"..i.."#", msgRepository[i]);
    end
        
    LinkRepository[orig] = nil;
    
    return theMsg;
end




function Emote:OnEnable()
    RegisterStringModifier(filterEmoticons, true);
end

function Emote:OnDisable()
    UnregisterStringModifier(filterEmoticons);
end


local function clearTempTable()
    for key, _ in pairs(tmpList) do
        tmpList[key] = nil;
    end
end


-- Extended Global
function GetEmotes()
    clearTempTable();
    local emotes = GetSelectedSkin().emoticons.definitions;
    for k, v in pairs(emotes) do
       if(emotes[v] == nil) then
            table.insert(tmpList, k);
       end
    end
    return unpack(tmpList);
end

function GetEmoteAlias(emote)
    clearTempTable();
    local emotes = GetSelectedSkin().emoticons.definitions;
    for k, v in pairs(emotes) do
       if(string.lower(v) == string.lower(emote)) then
            table.insert(tmpList, k);
       end
    end
    return unpack(tmpList);
end

function GetEmoteTexture(emote)
    return getEmoteFilePath(emote);
end

