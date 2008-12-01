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

local special = {"%", ":", "-", "^", "$", ")", "(", "]", "]", "~", "@", "#", "&", "*", "_", "+", "=", ",", ".", "?", "/", "\\", "{", "}", "|", "`", ";", "\"", "'"};

local function convertEmoteToPattern(theEmote)
    local i;
    for i=1, #special do
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


local function encodeColors(theMsg)
    theMsg = string.gsub(theMsg, "|c", "\001\002");
    theMsg = string.gsub(theMsg, "|r", "\001\003");
    return theMsg;
end

local function decodeColors(theMsg)
    theMsg = string.gsub(theMsg, "\001\002", "|c");
    theMsg = string.gsub(theMsg, "\001\003", "|r");
    return theMsg;
end

local function filterEmoticons(theMsg, smf)

    --saftey check...
    if(not theMsg or theMsg == "") then
        return "";
    end
    
    --check if special formatting is not wanted
    if(smf and smf.noEscapedStrings) then
        return theMsg;
    end

    --accomodate WoW's built in symbols and inherrit WoW's options whether to display them or not.
    if ( 1 ) then
	for tag in string.gmatch(theMsg, "%b{}") do
	    local term = string.lower(string.gsub(tag, "[{}]", ""));
	    if ( _G.ICON_TAG_LIST[term] and _G.ICON_LIST[_G.ICON_TAG_LIST[term]] ) then
		theMsg = string.gsub(theMsg, tag, _G.ICON_LIST[_G.ICON_TAG_LIST[term]] .. "0|t");
	    end
	end
    end

    local emoteTable = GetSelectedSkin().emoticons;
        
    -- first as to not disrupt any links, lets remove them and put them back later.
    local results, orig;
    orig = theMsg;
    -- clean out colors and wait to put back.
    local results;
    theMsg = encodeColors(theMsg);
    repeat
        theMsg, results = string.gsub(theMsg, "(|H[^|]+|h[^|]+|h)", function(theLink)
            table.insert(LinkRepository, theLink);
            return "\001\004"..#LinkRepository;
        end, 1);
    until results == 0;
    --restore color
    
    -- lets exchange emotes...
    local emote, img;
    for emote,_ in pairs(emoteTable.definitions) do
        img = getEmoteFilePath(emote);
        if(img and img ~= "") then
            theMsg = string.gsub(theMsg, convertEmoteToPattern(emote), "|T"..img..":"..emoteTable.width..":"..emoteTable.height..":"..emoteTable.offset[1]..":"..emoteTable.offset[2].."|t");
        end
    end
        
    -- put all the links back into the string...
    for i=1, #LinkRepository do
        theMsg = string.gsub(theMsg, "\001\004"..i.."", LinkRepository[i]);
    end
    
    -- clear table to be recycled by next process
    for key, _ in pairs(LinkRepository) do
        LinkRepository[key] = nil;
    end
    
    return decodeColors(theMsg);
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

