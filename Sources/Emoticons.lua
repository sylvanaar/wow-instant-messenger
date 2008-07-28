local WIM = WIM;

local LinkRepository = {}; -- used for emotes and link parsing.

-----------------------------------------------------
--                Emoticon Functions               --
-----------------------------------------------------

function WIM:FilterEmoticons(theMsg)

    --saftey check...
    if(not theMsg or theMsg == "") then
        return "";
    end

    --accomodate WoW's built in symbols and inherrit WoW's options whether to display them or not.
    if ( 1 ) then
	local term;
	for tag in string.gmatch(theMsg, "%b{}") do
	    term = strlower(string.gsub(tag, "[{}]", ""));
	    if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
		theMsg = string.gsub(theMsg, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
	    end
	end
    end


    if(WIM.db.emoticons) then
        local SelectedSkin = WIM:GetSelectedSkin();
        local emoteTable = SelectedSkin.emoticons;
        
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
            img = WIM:getEmoteFilePath(emote);
            if(img and img ~= "") then
                theMsg = string.gsub(theMsg, WIM:ConvertEmoteToPattern(emote), "|T"..img..":"..emoteTable.rect.width..":"..emoteTable.rect.height..":"..emoteTable.rect.xoffset..":"..emoteTable.rect.yoffset.."|t");
            end
        end
        
        -- put all the links back into the string...
        for i=1, table.getn(msgRepository) do
            theMsg = string.gsub(theMsg, "#LINK"..i.."#", msgRepository[i]);
        end
        
        LinkRepository[orig] = nil;
    end
    
    return theMsg;
end

function WIM:ConvertEmoteToPattern(theEmote)
    local special = {"%", ":", "-", "^", "$", ")", "(", "]", "]", "~", "@", "#", "&", "*", "_", "+", "=", ",", ".", "?", "/", "\\", "{", "}", "|", "`", ";", "\"", "'"};
    local i;
    for i=1, table.getn(special) do
        theEmote = string.gsub(theEmote, "%"..special[i], "%%"..special[i]);
    end
    return theEmote;
end

function WIM:getEmoteFilePath(theEmote)
    local emoteTable = SkinTable["WIM Classic"].emoticons;
    if(type(SelectedSkin) == "table") then
        emoteTable = SelectedSkin.emoticons;
    end

    local tmp;
    tmp = emoteTable.definitions[theEmote];
    -- if emote not found or if mal formed/linked emote, prevent infinate loop.
    if(not tmp or tmp == theEmote) then
        return "";
    else
        if(emoteTable.definitions[tmp]) then
            return WIM_getEmoteFilePath(tmp);
        else
            return tmp;
        end
    end
end

function WIM:GetEmoteTable()
    local SelectedSkin = WIM:GetSelectedSkin();
    local list = {};
    local tmp;
    for key,_ in pairs(SelectedSkin.emoticons.definitions) do
        tmp = WIM:getEmoteFilePath(key);
        if(tmp ~= "") then
            if(not list[tmp]) then
                list[tmp] = {
                    triggers = {}
                };
            end
            table.insert(list[tmp].triggers, key)
        end
    end
    return list;
end
