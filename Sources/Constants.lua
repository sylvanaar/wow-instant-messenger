WIM.constants.classes = {};
local classes = WIM.constants.classes;

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
	
-- accomodate female class names by inherriting data from males.
classes[WIM_LOCALIZED_DRUID_FEMALE]	= classes[WIM_LOCALIZED_DRUID];
classes[WIM_LOCALIZED_HUNTER_FEMALE]	= classes[WIM_LOCALIZED_HUNTER];
classes[WIM_LOCALIZED_MAGE_FEMALE]	= classes[WIM_LOCALIZED_MAGE];
classes[WIM_LOCALIZED_PALADIN_FEMALE]	= classes[WIM_LOCALIZED_PALADIN];
classes[WIM_LOCALIZED_PRIEST_FEMALE]	= classes[WIM_LOCALIZED_PRIEST];
classes[WIM_LOCALIZED_ROGUE_FEMALE]	= classes[WIM_LOCALIZED_ROGUE];
classes[WIM_LOCALIZED_SHAMAN_FEMALE]	= classes[WIM_LOCALIZED_SHAMAN];
classes[WIM_LOCALIZED_WARLOCK_FEMALE]	= classes[WIM_LOCALIZED_WARLOCK];
classes[WIM_LOCALIZED_WARRIOR_FEMALE]	= classes[WIM_LOCALIZED_WARRIOR];
