if (GetLocale() == "frFR") then

	-- Global Strings --
		WIM_LOCALIZED_YES 													= "Oui";
		WIM_LOCALIZED_NO 														= "Non";
		WIM_LOCALIZED_NONE 													= "Aucun";
		WIM_LOCALIZED_RIGHT_CLICK										= "Clique-Droit";
		WIM_LOCALIZED_LEFT_CLICK										= "Clique-Gauche";
		WIM_LOCALIZED_OK														= "Valider";
		WIM_LOCALIZED_CANCEL												= "Annuler";

	-- Strings From WIM.xml & WIM.lua --
		WIM_LOCALIZED_PURGED_HISTORY 								= "(n) messages ont \195\169t\195\169 effac\195\169 de l\226\128\153historique.";
		WIM_LOCALIZED_RECENT_CONVO_COUNT 						= "Conversation r\195\169cente {n1} de {n2}";
		WIM_LOCALIZED_NEW_MESSAGE 									= "Nouveau message!";
		WIM_LOCALIZED_NO_NEW_MESSAGES 							= "Pas de nouveaux messages.";
		WIM_LOCALIZED_CONVO_CLOSED 									= "Conversation ferm\195\169.";
		WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE 	= "Majuscule & Clique-Gauche pour finir la conversation.";
		WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY 					= "Cliquez pour voir l\226\128\153historique des messages.";
		WIM_LOCALIZED_IGNORE_CONFIRM 								= "\195\138tes vous s\195\187r de vouloir\nignorer cet utilisateur?";

	-- Shortcut Bar --
		WIM_LOCALIZED_TRADE 												= "\195\137changer";
		WIM_LOCALIZED_INVITE 												= "Inviter";
		WIM_LOCALIZED_TARGET 												= "Cibler";
		WIM_LOCALIZED_INSPECT 											= "Inspecter";
		WIM_LOCALIZED_IGNORE 												= "Ignorer";

	-- Keybindings --
		BINDING_HEADER_WIMMOD 											= "WiM (WoW Instant Messenger)";
		BINDING_NAME_WIMSHOWNEW 										= "Afficher les nouveaux messages";
		BINDING_NAME_WIMHISTORY 										= "Affichage Historique";
		BINDING_NAME_WIMENABLE 											= "Actif/Inactif";
		BINDING_NAME_WIMTOGGLE 											= "Basculer les messages";
		BINDING_NAME_WIMSHOWALL 										= "Afficher tous les messages";
		BINDING_NAME_WIMHIDEALL 										= "Cacher tous les messages";

	-- History Window --
		WIM_LOCALIZED_HISTORY_NO_FILTER							= "Aucun (Afficher Tout)";
		WIM_LOCALIZED_HISTORY_TITLE									= "Historique de WIM";
		WIM_LOCALIZED_HISTORY_USERS 								= "Utilisateurs";
		WIM_LOCALIZED_HISTORY_FILTERS 							= "Filtres";
		WIM_LOCALIZED_HISTORY_MESSAGES 							= "Messages";

	-- MiniMap Icon --
		WIM_LOCALIZED_ICON_CONVO_MENU								= "Conversations";
		WIM_LOCALIZED_ICON_SHOW_NEW									= "Nouveaux messages";
		WIM_LOCALIZED_ICON_OPTIONS									= "Options de WIM";
		WIM_LOCALIZED_CONVERSATIONS									= "Conversations";

	-- Options Window --
		WIM_LOCALIZED_OPTIONS_TITLE 								= "Options de WIM";
		WIM_LOCALIZED_OPTIONS_ICON_POSISTION 				= "Position de l\226\128\153icone";
		WIM_LOCALIZED_OPTIONS_FONT_SIZE 						= "Taille de la police";
		WIM_LOCALIZED_OPTIONS_WINDOW_SCALE 					= "Taille des Fen\195\170tre (%)";
		WIM_LOCALIZED_OPTIONS_WINDOW_ALPHA 					= "Transparence (%)";
		WIM_LOCALIZED_OPTIONS_WINDOW_WIDTH 					= "Largeur de Fen\195\170tres";
		WIM_LOCALIZED_OPTIONS_WINDOW_HEIGHT 				= "Hauteur de Fen\195\170tres";
		WIM_LOCALIZED_OPTIONS_LIMITED_HEIGHT 				= "(Limit\195\169 par la barre de raccourcis)";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME 		= "ERROR: Nom Sans fondement!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME2 	= "ERROR: Nom d\195\169j\195\160 utilis\195\169!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_ALIAS 	= "ERROR: Alias Sans fondement!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER	= "ERROR: Phrase/Mot cl\195\169 Sans fondement!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER2	= "ERROR: Phrase/Mot cl\195\169 d\195\169j\195\160 utilis\195\169!";
		WIM_LOCALIZED_OPTIONS_DAY 									= "Jour";
		WIM_LOCALIZED_OPTIONS_WEEK 									= "Semaine";
		WIM_LOCALIZED_OPTIONS_MONTH 								= "Mois";
		WIM_LOCALIZED_OPTIONS_TOOLTIP_MSG_SPAWN 		= "D\195\169placer pour positioner le placement par d\195\169faut\ndes fen\195\170tres de discusions.";
		WIM_LOCALIZED_OPTIONS_UP 										= "Haut";
		WIM_LOCALIZED_OPTIONS_DOWN 									= "Bas";
		WIM_LOCALIZED_OPTIONS_LEFT 									= "Gauche";
		WIM_LOCALIZED_OPTIONS_RIGHT 								= "Droite";
		WIM_LOCALIZED_OPTIONS_FILTER_IGNORE 				= "Ignorer";
		WIM_LOCALIZED_OPTIONS_FILTER_BLOCK 					= "Bloquer";
		WIM_LOCALIZED_OPTIONS_ENABLE_WIM 						= "Activer WIM";
		
		WIM_LOCALIZED_OPTIONS_DISPLAY_TITLE 				= "Options d\226\128\153Affichage";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_IN 			= "Chuchotements Entrants";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_OUT 			= "Chuchotements Sortants";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SYSTEM 				= "Messages Syt\195\168mes";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ERROR 				= "Messages d\226\128\153Erreurs";
		WIM_LOCALIZED_OPTIONS_DISPLAY_URL 					= "Lien d\226\128\153Adresse Internet";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SHORTCUTBAR		= "Barre de raccourcis";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_SCB 	= "Ce param\195\168tre limite la hauteur minimale des fenêtres.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TIMESTAMPS 		= "Horodatage";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO					= "Information interlocuteur";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_CINFO	= "Les modifications ne seront appliqu\195\169es\nqu\226\128\153aux nouvelles fen\195\170tres de messages.\n|cffffffff(Necesite requete /qui en tache de fond.)|r";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_CLASS 	= "Icones des Classes";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTOP_NEW		= "Les modifications ne seront appliqu\195\169es\nqu\226\128\153aux nouvelles fen\195\170tres de messages.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_COLOR 	= "Couleurs des Classes";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_DETAILS	= "D\195\169tails Personnage";
		
		WIM_LOCALIZED_OPTIONS_MINIMAP_TITLE 				= "Icone Minicarte";
		WIM_LOCALIZED_OPTIONS_MINIMAP_ENABLE 				= "Icone de la Minicarte";
		WIM_LOCALIZED_OPTIONS_MINIMAP_FREEMOVING 		= "D\195\169placement\nLibre";
		WIM_LOCALIZED_OPTIONS_MINIMAP_TOOLTIP_FM		= "Quand actif, Majuscule-Clique-Gauche,\nsur l\226\128\153icone de la minicarte, vous permettra\nde le d\195\169placer autour de l\226\128\153\195\169cran.";
		
		WIM_LOCALIZED_OPTIONS_TAB_GENERAL 					= " G\195\169n\195\169ral ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_WINDOWS 					= " Fen\195\170tres ";			-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_FILTERS 					= " Filtres ";					-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_HISTORY 					= " Historique ";				-- notice space buffering
		
		WIM_LOCALIZED_OPTIONS_GENERAL_AUTO_FOCUS 		= "Auto focus fen\195\170tre sur popup.";
		WIM_LOCALIZED_OPTIONS_GENERAL_KEEP_FOCUS 		= "Garde focus apr\195\168s avoir envoy\195\169 un message.";
		WIM_LOCALIZED_OPTIONS_GENERAL_FOCUS_RESTED 	= "Seulement lorsque vous \195\170tes en ville.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SHOW_TOOLTIPS	= "Affiche les infobulles.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_SEND 			= "Affiche la fen\195\170tre lors de l\226\128\153envoi\ndes chuchotements.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_IN 				= "Affiche la fen\195\170tre lors de la r\195\169ception\nde nouveaux chuchotements";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_REPLY 		= "Affiche la fen\195\170tre lors des r\195\169ponses";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_COMBAT 		= "D\195\169sactive la messagerie en combat.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS 			= "Supprime les chuchotements de la fen\195\170tre\nde discussion par défaut.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SOUND_IN 			= "Joue un son quand un message est re\195\167u.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SORT_ALPHA 		= "Trie la liste de conversation alphab\195\169tiquement.";
		WIM_LOCALIZED_OPTIONS_GENERAL_AFK_DND 			= "Affiche AFK et NPD messages.";
		WIM_LOCALIZED_OPTIONS_GENERAL_ESCAPE 				= "Utilise \226\128\153Echappe\226\128\153 pour fermer les Fen\195\170tres.";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_ESC		= "L\226\128\153utilisation de \226\128\153Echappe\226\128\153 à ses restrictions. |cffffffffExemple: les Fen\195\170tress se fermeront en ouvrant la carte.|r";
		WIM_LOCALIZED_OPTIONS_GENERAL_INTERCEPT 		= "Intercepte les chuchotements\nen ligne de commande.";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_INTCP	= "WIM intercepte tous chuchotements par ligne de commandes et\nouvre automatiquement une nouvelle Fen\195\170tres de message.\n(Example: /w or /whisper).";
		
		WIM_LOCALIZED_OPTIONS_WINDOWS_CASCADE_DIR 	= "Ordonn\195\169ment directionnelle:";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SET_LOCATION 	= "Positionner";
		
		WIM_LOCALIZED_OPTIONS_FILTERS_ENABLE 				= "Permettre l\226\128\153aliasing";
		WIM_LOCALIZED_OPTIONS_FILTERS_COMMENT 			= "En tant que commentaire";
		WIM_LOCALIZED_OPTIONS_FILTERS_NAME 					= "Nom";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS 				= "Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_ADD 		= "Cr\195\169er un nouvel Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_ADD						= "Ajouter";
		WIM_LOCALIZED_OPTIONS_FILTERS_REMOVE 				= "Supprimer";
		WIM_LOCALIZED_OPTIONS_FILTERS_EDIT 					= "Editer";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_EDIT 		= "Editer Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ENABLE	= "Activer les filtres";
		WIM_LOCALIZED_OPTIONS_FILTERS_KEY_PHRASE 		= "Mots cl\195\169/Phrases";
		WIM_LOCALIZED_OPTIONS_FILTERS_ACTION 				= "Action";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ADD 		= "Cr\195\169er un nouveau filtre";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_EDIT 	= "Editer filtre";
		
		WIM_LOCALIZED_OPTIONS_HISTORY_ENABLE 				= "Activer l\226\128\153historisation";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_ALL 		= "Enregistrer toutes les\nconversations";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_FRIENDS= "Ami(e)s";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_GUILD 	= "Guilde";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_IN 	= "Messages entrants";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_OUT 	= "Messages sortants";
		WIM_LOCALIZED_OPTIONS_HISTORY_SHOW 					= "Afficher les messages pr\195\169c\195\169dents\ndans la fen\195\170tre de conversation";
		WIM_LOCALIZED_OPTIONS_HISTORY_MAX 					= "Messages maximum par interlocuteur:";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE 				= "Effacer les messages plus vieux que:";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_USERS 		= "Conversation avec";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_MESSAGES 	= "Nombre de messages";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE_USER 	= "Effacer";
		WIM_LOCALIZED_OPTIONS_HISTORY_VIEW_USER 		= "Historique";

	-- Alias Window --
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL1 					= "Nom interlocuteur";
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL2 					= "Alias interlocuteur";
	
	-- Filter Window --
		WIM_LOCALIZED_FILTER_WINDOW_LABEL1 					= "Mot cl\195\169/Phrase \195\160 filtrer";
		WIM_LOCALIZED_FILTER_WINDOW_LABEL2 					= "Effectue l\226\128\153action suivante:";
	
	-- Help Window --
		WIM_LOCALIZED_HELP_WINDOW_TITLE 						= "Documentation de WIM";
		WIM_LOCALIZED_HELP_WINDOW_DESCRIPTION 			= " D\195\169scription ";				-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_VERSION_HISTORY 	= " Historique des versions ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_DID_YOU_KNOW 			= " Le saviez vous? ";					-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_CREDITS 					= " Cr\195\169dits ";						-- notice space buffering
	
	-- Titan Panel Plugin --
		WIM_LOCALIZED_TITAN_MESSAGES								= "Messages: ";
	
	-- URL Copy --
		WIM_LOCALIZED_URLCOPY_TITLE									= "Copier l\226\128\153URL";
		
	-- Class Names
		WIM_LOCALIZED_DRUID 												= "Druide";
		WIM_LOCALIZED_HUNTER 												= "Chasseur";
		WIM_LOCALIZED_MAGE 													= "Mage";
		WIM_LOCALIZED_PALADIN 											= "Paladin";
		WIM_LOCALIZED_PRIEST 												= "Pr\195\170tre";
		WIM_LOCALIZED_ROGUE 												= "Voleur";
		WIM_LOCALIZED_SHAMAN 												= "Chaman";
		WIM_LOCALIZED_WARLOCK 											= "D\195\169moniste";
		WIM_LOCALIZED_WARRIOR 											= "Guerrier";
end