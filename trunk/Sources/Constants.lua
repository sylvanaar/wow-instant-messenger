WIM.constants.classes = {};
local classes = WIM.constants.classes;

local classList = {
     "WIM_LOCALIZED_DRUID", "WIM_LOCALIZED_HUNTER", "WIM_LOCALIZED_MAGE",
     "WIM_LOCALIZED_PALADIN", "WIM_LOCALIZED_PRIEST", "WIM_LOCALIZED_ROGUE",
     "WIM_LOCALIZED_SHAMAN", "WIM_LOCALIZED_WARLOCK", "WIM_LOCALIZED_WARRIOR"
};

--Male Classes - this doesn't apply to every locale
classes[WIM_LOCALIZED_DRUID]	= {
                                    color = "ff7d0a",
                                    tag = "DRUID"
                                };
classes[WIM_LOCALIZED_HUNTER]	= {
                                    color = "abd473",
                                    tag = "HUNTER"
                                };
classes[WIM_LOCALIZED_MAGE]	= {
                                    color = "69ccf0",
                                    tag = "MAGE"
                                };
classes[WIM_LOCALIZED_PALADIN]	= {
                                    color = "f58cba",
                                    tag = "PALADIN"
                                };
classes[WIM_LOCALIZED_PRIEST]	= {
                                    color = "ffffff",
                                    tag = "PRIEST"
                                };
classes[WIM_LOCALIZED_ROGUE]	= {
                                    color = "fff569",
                                    tag = "ROGUE"
                                };
classes[WIM_LOCALIZED_SHAMAN]	= {
                                    color = "00dbba",
                                    tag = "SHAMAN"
                                };
classes[WIM_LOCALIZED_WARLOCK]	= {
                                    color = "9482ca",
                                    tag = "WARLOCK"
                                };
classes[WIM_LOCALIZED_WARRIOR]	= {
                                    color = "c79c6e",
                                    tag = "WARRIOR"
                                };
classes[WIM_LOCALIZED_GM]	= {
                                    color = "00c0ff",
                                    tag = "GM"
                                };

-- propigate female class types and update tags appropriately
local i;
for i=1, table.getn(classList) do
     if(_G[classList[i]] ~= _G[classList[i].."_FEMALE"]) then
          classes[_G[classList[i].."_FEMALE"]] = {
               color = classes[_G[classList[i]]].color,
               tag = classes[_G[classList[i]]].tag.."F"
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
