local WIM = WIM;

-- imports
local _G = _G;
local table = table;
local type = type;
local string = string;
local pairs = pairs;

-- set namespace
setfenv(1, WIM);

constants.classes = {};
local classes = constants.classes;

local classList = {
     "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue",
     "Shaman", "Warlock", "Warrior",  "Death Knight"
};

--Male Classes - this doesn't apply to every locale
classes[L["Druid"]]	= {
                                    color = "ff7d0a",
                                    tag = "DRUID"
                                };
classes[L["Hunter"]]	= {
                                    color = "abd473",
                                    tag = "HUNTER"
                                };
classes[L["Mage"]]	= {
                                    color = "69ccf0",
                                    tag = "MAGE"
                                };
classes[L["Paladin"]]	= {
                                    color = "f58cba",
                                    tag = "PALADIN"
                                };
classes[L["Priest"]]	= {
                                    color = "ffffff",
                                    tag = "PRIEST"
                                };
classes[L["Rogue"]]	= {
                                    color = "fff569",
                                    tag = "ROGUE"
                                };
classes[L["Shaman"]]	= {
                                    color = "00dbba",
                                    tag = "SHAMAN"
                                };
classes[L["Warlock"]]	= {
                                    color = "9482ca",
                                    tag = "WARLOCK"
                                };
classes[L["Warrior"]]	= {
                                    color = "c79c6e",
                                    tag = "WARRIOR"
                                };
classes[L["Death Knight"]]	= {
                                    color = "c41f3b",
                                    tag = "DEATHKNIGHT"
                                };
classes[L["Game Master"]]	= {
                                    color = "00c0ff",
                                    tag = "GM"
                                };

-- propigate female class types and update tags appropriately
local i;
for i=1, table.getn(classList) do
     if(L[classList[i]] ~= L[classList[i].."F"]) then
          classes[L[classList[i].."F"]] = {
               color = classes[L[classList[i]]].color,
               tag = classes[L[classList[i]]].tag.."F"
          };
     end
end


classes.GetClassByTag = function(t)
     for class, tbl in pairs(classes) do
          if(type(tbl) == "table") then
               if(tbl.tag == t) then
                    return class;
               end
          end
     end
     -- can't find tag, before returning blank, see we're being asked for a female class, then try again.
     local ft = string.gsub(t, "(F)$", "");
     if( ft == t) then
          return ""
     else
          return classes.GetClassByTag(ft);
     end
end
