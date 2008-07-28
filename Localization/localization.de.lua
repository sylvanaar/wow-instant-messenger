  ------------------------------
  -- German text by Corrilian --
  ------------------------------

	-- Ä = \195\132
	-- Ö = \195\150
	-- Ü = \195\156
	-- ß = \195\159
	-- ä = \195\164
	-- ö = \195\182
	-- ü = \195\188
	
if (GetLocale() == "deDE") then

	-- Class Names
		WIM_LOCALIZED_DRUID 			        = "Druide";
		WIM_LOCALIZED_HUNTER 			        = "J\195\164ger";
		WIM_LOCALIZED_MAGE                              = "Magier";
		WIM_LOCALIZED_PALADIN 				= "Paladin";
		WIM_LOCALIZED_PRIEST 				= "Priester";
		WIM_LOCALIZED_ROGUE 				= "Schurke";
		WIM_LOCALIZED_SHAMAN 				= "Schamane";
		WIM_LOCALIZED_WARLOCK 				= "Hexenmeister";
		WIM_LOCALIZED_WARRIOR 				= "Krieger";
                
                -- female character classes
		WIM_LOCALIZED_DRUID_FEMALE 			= "Druidin";
		WIM_LOCALIZED_HUNTER_FEMALE 			= "J\195\164gerin";
		WIM_LOCALIZED_MAGE_FEMALE                       = "Magierin";
		WIM_LOCALIZED_PALADIN_FEMALE 		        = "Paladin";
		WIM_LOCALIZED_PRIEST_FEMALE 			= "Priesterin";
		WIM_LOCALIZED_ROGUE_FEMALE 			= "Schurkin";
		WIM_LOCALIZED_SHAMAN_FEMALE 			= "Schamanin";
		WIM_LOCALIZED_WARLOCK_FEMALE 			= "Hexenmeisterin";
		WIM_LOCALIZED_WARRIOR_FEMALE 			= "Kriegerin";
		
	-- Global Strings --
		WIM_LOCALIZED_YES 				= "Ja";
		WIM_LOCALIZED_NO 				= "Nein";
		WIM_LOCALIZED_NONE 				= "Nichts";
		WIM_LOCALIZED_RIGHT_CLICK			= "Rechts-Klick";
		WIM_LOCALIZED_LEFT_CLICK			= "Links-Klick";
		WIM_LOCALIZED_OK				= "OK";
		WIM_LOCALIZED_CANCEL				= "Abbruch";

	-- Strings From WIM.xml & WIM.lua --
		WIM_LOCALIZED_PURGED_HISTORY 			= "{n} alte Nachrichten aus Verlauf gel\195\182scht.";
		WIM_LOCALIZED_RECENT_CONVO_COUNT 		= "Letzte Gespr\195\164che {n1} von {n2}";
		WIM_LOCALIZED_NEW_MESSAGE 			= "Neue Nachricht!";
		WIM_LOCALIZED_NO_NEW_MESSAGES 			= "Keine neuen Nachrichten.";
		WIM_LOCALIZED_CONVO_CLOSED 			= "Gespr\195\164ch geschlossen.";
		WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE 	= "Shift & Links-Klick um Gespr\195\164ch zu beenden.";
		WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY 		= "Klick um Nachrichten-Verlauf zu sehen.";
		WIM_LOCALIZED_IGNORE_CONFIRM 			= "Bist du sicher das du diesen Spieler ignorieren willst?";
		WIM_LOCALIZED_AFK				= "AFK";
		WIM_LOCALIZED_DND				= "DND";
		
	-- Shortcut Bar --
		WIM_LOCALIZED_TRADE 				= "Handeln";
		WIM_LOCALIZED_INVITE 				= "Einladen";
		WIM_LOCALIZED_TARGET 				= "Ziel";
		WIM_LOCALIZED_INSPECT 				= "Betrachten";
		WIM_LOCALIZED_IGNORE 				= "Ignorieren";
	

	-- Keybindings --
		BINDING_HEADER_WIMMOD 				= "WIM (WoW Instant Messenger)";
		BINDING_NAME_WIMSHOWNEW 			= "Zeige neue Nachrichten";
		BINDING_NAME_WIMHISTORY 			= "Nachrichtenverlauf";
		BINDING_NAME_WIMENABLE 				= "Ein/Aus";
		BINDING_NAME_WIMTOGGLE 				= "Nachrichten durchschalten";
		BINDING_NAME_WIMSHOWALL 			= "Zeige alle Nachrichten";
		BINDING_NAME_WIMHIDEALL 			= "Verstecke alle Nachrichten";

	-- History Window --
		WIM_LOCALIZED_HISTORY_NO_FILTER			= "Nichts (Zeige alles)";
		WIM_LOCALIZED_HISTORY_TITLE			= "WIM Nachrichtenverlauf";
		WIM_LOCALIZED_HISTORY_USERS 			= "Spieler";
		WIM_LOCALIZED_HISTORY_FILTERS 			= "Filter";
		WIM_LOCALIZED_HISTORY_MESSAGES 			= "Nachrichten";
		
	-- MiniMap Icon --
		WIM_LOCALIZED_ICON_CONVO_MENU			= "Gespr\195\164chs-Men\195\188 ";
		WIM_LOCALIZED_ICON_SHOW_NEW			= "Zeige neue Nachrichten";
		WIM_LOCALIZED_ICON_OPTIONS			= "WIM Optionen";
		WIM_LOCALIZED_CONVERSATIONS			= "Gespr\195\164che";
	
	
	-- Options Window --
		WIM_LOCALIZED_OPTIONS_TITLE 			= "WIM Optionen";
		WIM_LOCALIZED_OPTIONS_ICON_POSISTION 		= "Symbol Position";
		WIM_LOCALIZED_OPTIONS_FONT_SIZE 		= "Schriftgr\195\182\195\159e";
		WIM_LOCALIZED_OPTIONS_WINDOW_SCALE 		= "Fensterskalierung (Prozent)";
		WIM_LOCALIZED_OPTIONS_WINDOW_ALPHA 		= "Transparenz (Prozent)";
		WIM_LOCALIZED_OPTIONS_WINDOW_WIDTH 		= "Fensterbreite";
		WIM_LOCALIZED_OPTIONS_WINDOW_HEIGHT 		= "Fensterh\195\182he";
		WIM_LOCALIZED_OPTIONS_LIMITED_HEIGHT 		= "(begrenzt durch Abk\195\188rzungsleiste)";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME 	= "FEHLER: ung\195\188ltiger Name!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME2 	= "FEHLER: Name ist bereits benutzt!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_ALIAS 	= "FEHLER: ung\195\188ltiges Alias!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER      = "FEHLER: ung\195\188ltiges Schl\195\188sselwort/Phrase!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER2     = "FEHLER: Schl\195\188sselwort/Phrase wird schon benutzt!";
		WIM_LOCALIZED_OPTIONS_DAY 			= "Tag";
		WIM_LOCALIZED_OPTIONS_WEEK 			= "Woche";
		WIM_LOCALIZED_OPTIONS_MONTH 		        = "Monat";
		WIM_LOCALIZED_OPTIONS_TOOLTIP_MSG_SPAWN 	= "Ziehen f\195\188r Standard Position des Fensters.";
		WIM_LOCALIZED_OPTIONS_UP 			= "Hoch";
		WIM_LOCALIZED_OPTIONS_DOWN 			= "Runter";
		WIM_LOCALIZED_OPTIONS_LEFT 			= "Links";
		WIM_LOCALIZED_OPTIONS_RIGHT 			= "Rechts";
		WIM_LOCALIZED_OPTIONS_FILTER_IGNORE 		= "Ignorieren";
		WIM_LOCALIZED_OPTIONS_FILTER_BLOCK 		= "Blocken";
		WIM_LOCALIZED_OPTIONS_ENABLE_WIM 		= "aktiviere WIM";
		
		WIM_LOCALIZED_OPTIONS_DISPLAY_TITLE 		= "Anzeige Optionen";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_IN 		= "Eingehende Nachrichten";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_OUT 		= "Ausgehende Nachrichten";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SYSTEM 		= "System Nachrichten";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ERROR 		= "Fehler Nachrichten";
		WIM_LOCALIZED_OPTIONS_DISPLAY_URL 		= "Internet Link";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SHORTCUTBAR	= "Zeige Abk\195\188rzungsleiste.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_SCB 	= "Diese Einstellung limitiert die minimale H\195\182he des Fensters.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TIMESTAMPS 	= "Zeige Zeitstempel.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO		= "Zeige Character Info:";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_CINFO     = "\195\132nderungen werden nur bei neuen Fenstern \195\188bernommen.\n|cffffffff(Ben\195\182tigt /who Befehl im Hintergrund.)|r";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_CLASS 	= "Klassen Symbol";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTOP_NEW	= "\195\132nderungen werden nur bei neuen Fenstern \195\188bernommen.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_COLOR 	= "Klassen Farben";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_DETAILS     = "Character Details";
		
		WIM_LOCALIZED_OPTIONS_MINIMAP_TITLE 		= "Minimap Symbol";
		WIM_LOCALIZED_OPTIONS_MINIMAP_ENABLE 		= "Zeige Minimap Symbol";
		WIM_LOCALIZED_OPTIONS_MINIMAP_FREEMOVING 	= "Frei bewegen";
		WIM_LOCALIZED_OPTIONS_MINIMAP_TOOLTIP_FM	= "Wenn eingeschaltet, Shift-Links-Klick auf das Minimap Symbol, erlaubt das freie verschieben.";
		
		WIM_LOCALIZED_OPTIONS_TAB_GENERAL 		= " Allgemein ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_WINDOWS 		= " Fenster ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_FILTERS 		= " Filter ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_HISTORY 		= " Verlauf ";		-- notice space buffering
		
		WIM_LOCALIZED_OPTIONS_GENERAL_AUTO_FOCUS 	= "Fenster aktiv bei Popup.";
		WIM_LOCALIZED_OPTIONS_GENERAL_KEEP_FOCUS 	= "Fenster aktiv lassen bei gesendeter Nachricht.";
		WIM_LOCALIZED_OPTIONS_GENERAL_FOCUS_RESTED 	= "Nur in einer Hauptstadt.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SHOW_TOOLTIPS     = "Zeige Tooltips.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_SEND 		= "Popup Fenster bei gesendeter Nachricht.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_IN 		= "Popup Fenster bei erhaltener Nachricht.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_REPLY 	= "Popup Fenster bei erhaltener Antwort.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_COMBAT 	= "Deaktiviere Popups w\195\164hrend des Kampfes.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS 		= "Unterdr\195\188cke Nachrichten vom Standard-Chat.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SOUND_IN 		= "Spiele Ton bei neuer Nachricht.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SORT_ALPHA 	= "Sortiere Gespr\195\164chsliste Alphabetisch.";
		WIM_LOCALIZED_OPTIONS_GENERAL_AFK_DND 		= "Zeige AFK und DND Nachrichten.";
		WIM_LOCALIZED_OPTIONS_GENERAL_ESCAPE 		= "Benutze 'Escape' zum Fenster schliessen.";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_ESC	= "Benutzung von 'Escape' hat seine Einschr\195\164nkungen. |cffffffffBeispiel: Fenster schliest sich bei ge\195\182ffneter Karte.|r";
		WIM_LOCALIZED_OPTIONS_GENERAL_INTERCEPT 	= "\195\156berwache Slash-Kommandos.";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_INTCP     = "WIM \195\188berwacht jegliche /wisper Kommandos und \195\182ffnet automatisch ein neues Fenster. (Beispiel: /w oder /whisper).";
		
		WIM_LOCALIZED_OPTIONS_WINDOWS_CASCADE_DIR 	= "Aktiviere Kaskade. Richtung:";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SET_LOCATION 	= "Setze Position";
		
		WIM_LOCALIZED_OPTIONS_FILTERS_ENABLE 		= "Aktiviere Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_COMMENT 		= "Zeige als Kommentar";
		WIM_LOCALIZED_OPTIONS_FILTERS_NAME 		= "Name";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS 		= "Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_ADD 	= "Erstelle neues Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_ADD		= "Erstelle";
		WIM_LOCALIZED_OPTIONS_FILTERS_REMOVE 		= "Entferne";
		WIM_LOCALIZED_OPTIONS_FILTERS_EDIT 		= "Editiere";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_EDIT 	= "Editiere Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ENABLE     = "Aktiviere Filter-Funktion";
		WIM_LOCALIZED_OPTIONS_FILTERS_KEY_PHRASE 	= "Schl\195\188sselw\195\182rter/Phrasen";
		WIM_LOCALIZED_OPTIONS_FILTERS_ACTION 		= "Aktion";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ADD 	= "Erstelle neuen Filter";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_EDIT 	= "Editiere Filter";
		
		WIM_LOCALIZED_OPTIONS_HISTORY_ENABLE 		= "Aktiviere Verlauf";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_ALL 	= "Jeden aufzeichnen";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_FRIENDS    = "Freunde aufzeichnen";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_GUILD 	= "Gilde aufzeichnen";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_IN 	= "Eingehende Nachrichten";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_OUT 	= "Ausgehende Nachrichten";
		WIM_LOCALIZED_OPTIONS_HISTORY_SHOW 		= "Zeige Verlauf in Nachricht:";
		WIM_LOCALIZED_OPTIONS_HISTORY_MAX 		= "Setze max. Anzahl Nachrichten/User:";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE 		= "L\195\182sche Nachrichten \195\164lter als 1 :";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_USERS 	= "aufgezeichnete User";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_MESSAGES 	= "gespeichert";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE_USER 	= "L\195\182sche User";
		WIM_LOCALIZED_OPTIONS_HISTORY_VIEW_USER 	= "Zeige Verlauf";
		
	-- Alias Window --
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL1 		= "Character Name";
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL2 		= "Character Alias";
	
	-- Filter Window --
		WIM_LOCALIZED_FILTER_WINDOW_LABEL1 		= "Schl\195\188sselwort/Phrase";
		WIM_LOCALIZED_FILTER_WINDOW_LABEL2 		= "F\195\188hre folgende Aktion durch:";
		
		-- Translations Unknown by translator --
		-- WIM_LOCALIZED_FILTER_1  			= "^LVBM";
		-- WIM_LOCALIZED_FILTER_2 			= "^YOU ARE BEING WATCHED!";
		-- WIM_LOCALIZED_FILTER_3			= "^YOU ARE MARKED!";
		-- WIM_LOCALIZED_FILTER_4			= "^YOU ARE CURSED!";
		-- WIM_LOCALIZED_FILTER_5			= "^YOU HAVE THE PLAGUE!";
		-- WIM_LOCALIZED_FILTER_6 			= "^YOU ARE BURNING!";
		-- WIM_LOCALIZED_FILTER_7			= "^YOU ARE THE BOMB!";
		-- WIM_LOCALIZED_FILTER_8  			= "VOLATILE INFECTION";
		-- WIM_LOCALIZED_FILTER_9			= "^<GA";
	
	-- Help Window --
		WIM_LOCALIZED_HELP_WINDOW_TITLE 		= "WIM Dokumentation";
		WIM_LOCALIZED_HELP_WINDOW_DESCRIPTION 		= " Beschreibung ";		-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_VERSION_HISTORY 	= " Versions History ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_DID_YOU_KNOW 		= " Wusstest du schon? ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_CREDITS 		= " Credits ";			-- notice space buffering
	
	-- Titan Panel Plugin --
		WIM_LOCALIZED_TITAN_MESSAGES			= "Nachrichten: ";
	
	-- URL Copy --
		WIM_LOCALIZED_URLCOPY_TITLE			= "Kopiere URL";
	
	-- Help Window Tabs --
WIM_DESCRIPTION = [[
WIM (WoW Instant Messenger)
|cffffffff
WIM ist exakt das wonach es auch benannt wurde,ein Instant Messenger fuer deinen Nachrichtenverkehr im Spiel. Es ist speziell dafuer entwickelt um nicht zu stoeren (in Raids z.B.) und um dich bequem mit anderen Spielern unterhalten zu koennen wobei jeder Unterhaltung ein eigenes Fenster zugeordnet wird.

Schau in deine Tastaturbelegungsoptionen, WIM hat einige Sachen die Du auf Tasten legen kannst.
|r
Nuetzliche Slash-Kommandos:
/wim			|cffffffff- WIM Optionen|r
/wim history	|cffffffff- Nachrichtenverlauf ansehen|r
/wim help		|cffffffff- (dieses Fenster)|r

Erweiterte Slash-Kommandos:
/wim reset			|cffffffff- Stellt alle Optionen auf Standard Einstellung zurueck.|r
/wim reset filters	|cffffffff- Stellt alle Filter auf Standard zurueck.|r
/wim clear history	|cffffffff- Loescht den Nachrichtenverlauf.|r



WIM integriert sich selber in folgende Addons:|cffffffff
TitanPanel
Fubar 2.0|r 

WIM ist kompatibel mit folgenden Addons:|cffffffff
AllInOneInventory
EngInventory
SuperInspect
AtlasLoot
LootLink|r
]]

-- WIM_DIDYOUKNOW = [[ Not Translated - Leave Commented ]]

-- WIM_CREDITS = [[ Not Translated - Leave Commented ]]

end

