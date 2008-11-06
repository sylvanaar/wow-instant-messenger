local WIM = WIM;

-- imports
local _G = _G;
local table = table;
local type = type;
local string = string;
local pairs = pairs;

-- set namespace
setfenv(1, WIM);

local talent = L;
if(libs.BabbleTalent) then -- need to do this check to prevent error if lib not loaded.
     talent = libs.BabbleTalent:GetLookupTable();
     L["Hybrid"] = talent["Hybrid"]; -- preserve hybrid localization.
end

constants.classes = {};
local classes = constants.classes;

local classList = {
     "Druid", "Hunter", "Mage", "Paladin", "Priest", "Rogue",
     "Shaman", "Warlock", "Warrior",  "Death Knight"
};

--Male Classes - this doesn't apply to every locale
classes[L["Druid"]]	= {
                                    color = "ff7d0a",
                                    tag = "DRUID",
                                    talent = {talent["Balance"], talent["Feral Combat"], talent["Restoration"]}
                                };
classes[L["Hunter"]]	= {
                                    color = "abd473",
                                    tag = "HUNTER",
                                    talent = {talent["Beast Mastery"], talent["Marksmanship"], talent["Survival"]}
                                };
classes[L["Mage"]]	= {
                                    color = "69ccf0",
                                    tag = "MAGE",
                                    talent = {talent["Arcane"], talent["Fire"], talent["Frost"]}
                                };
classes[L["Paladin"]]	= {
                                    color = "f58cba",
                                    tag = "PALADIN",
                                    talent = {talent["Holy"], talent["Protection"], talent["Retribution"]}
                                };
classes[L["Priest"]]	= {
                                    color = "ffffff",
                                    tag = "PRIEST",
                                    talent = {talent["Discipline"], talent["Holy"], talent["Shadow"]}
                                };
classes[L["Rogue"]]	= {
                                    color = "fff569",
                                    tag = "ROGUE",
                                    talent = {talent["Assassination"], talent["Combat"], talent["Subtlety"]}
                                };
classes[L["Shaman"]]	= {
                                    color = "2459FF",
                                    tag = "SHAMAN",
                                    talent = {talent["Elemental"], talent["Enhancement"], talent["Restoration"]}
                                };
classes[L["Warlock"]]	= {
                                    color = "9482ca",
                                    tag = "WARLOCK",
                                    talent = {talent["Affliction"], talent["Demonology"], talent["Destruction"]}
                                };
classes[L["Warrior"]]	= {
                                    color = "c79c6e",
                                    tag = "WARRIOR",
                                    talent = {talent["Arms"], talent["Fury"], talent["Protection"]}
                                };
classes[L["Death Knight"]]	= {
                                    color = "c41f3b",
                                    tag = "DEATHKNIGHT",
                                    talent = {talent["Blood"], talent["Frost"], talent["Unholy"]}
                                };
classes[L["Game Master"]]	= {
                                    color = "00c0ff",
                                    tag = "GM",
                                    talent = {"", "", ""} -- talent place holder
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
