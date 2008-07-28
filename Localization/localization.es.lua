
if (GetLocale() == "esES") then
	
	-- Global Strings --
		WIM_LOCALIZED_YES 													= "Sí";
		WIM_LOCALIZED_NO 														= "No";
		WIM_LOCALIZED_NONE 													= "Ninguno";
		WIM_LOCALIZED_RIGHT_CLICK										= "Clic-Derecho";
		WIM_LOCALIZED_LEFT_CLICK										= "Clic-Izquierdo";
		WIM_LOCALIZED_OK														= "Aceptar";
		WIM_LOCALIZED_CANCEL												= "Cancelar";

	-- Strings From WIM.xml & WIM.lua --
		WIM_LOCALIZED_PURGED_HISTORY 								= "Eliminados {n} mensajes antiguos del historial.";
		WIM_LOCALIZED_RECENT_CONVO_COUNT 						= "Conversación Reciente {n1} de {n2}";
		WIM_LOCALIZED_NEW_MESSAGE 									= "¡Nuevo Mensaje!";
		WIM_LOCALIZED_NO_NEW_MESSAGES 							= "No hay mensajes nuevos.";
		WIM_LOCALIZED_CONVO_CLOSED 									= "Conversación cerrada.";
		WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE 	= "Mayús y Clic-Izquierdo para finalizar la conversación.";
		WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY 					= "Clic para ver el historial de mensajes.";
		WIM_LOCALIZED_IGNORE_CONFIRM 								= "¿Estas seguro que quieres\nignorar a este usuario?";
		WIM_LOCALIZED_AFK														= "AUS";
		WIM_LOCALIZED_DND														= "NM";
		
	-- Shortcut Bar --
		WIM_LOCALIZED_TRADE 												= "Comerciar";
		WIM_LOCALIZED_INVITE 												= "Invitar";
		WIM_LOCALIZED_TARGET 												= "Seleccionar";
		WIM_LOCALIZED_INSPECT 											= "Inspeccionar";
		WIM_LOCALIZED_IGNORE 												= "Ignorar";
	

	-- Keybindings --
		BINDING_HEADER_WIMMOD 											= "WIM (WoW Instant Messenger)";
		BINDING_NAME_WIMSHOWNEW 										= "Mostrar Nuevos Mensajes";
		BINDING_NAME_WIMHISTORY 										= "Visor Historial";
		BINDING_NAME_WIMENABLE 											= "Activar/Desactivar";
		BINDING_NAME_WIMTOGGLE 											= "Alternar Mensajes";
		BINDING_NAME_WIMSHOWALL 										= "Mostrar Todos los Mensajes";
		BINDING_NAME_WIMHIDEALL 										= "Ocultar Todos los Mensajes";

	-- History Window --
		WIM_LOCALIZED_HISTORY_NO_FILTER							= "Ninguno (Mostrar Todo)";
		WIM_LOCALIZED_HISTORY_TITLE									= "Visor Historial de WIM";
		WIM_LOCALIZED_HISTORY_USERS 								= "Usuarios";
		WIM_LOCALIZED_HISTORY_FILTERS 							= "Filtros";
		WIM_LOCALIZED_HISTORY_MESSAGES 							= "Mensajes";
		
	-- MiniMap Icon --
		WIM_LOCALIZED_ICON_CONVO_MENU								= "Menú de Conversaciones";
		WIM_LOCALIZED_ICON_SHOW_NEW									= "Mostrar Nuevos Mensajes";
		WIM_LOCALIZED_ICON_OPTIONS									= "Opciones WIM";
		WIM_LOCALIZED_CONVERSATIONS									= "Conversaciones";
	
	
	-- Options Window --
		WIM_LOCALIZED_OPTIONS_TITLE 								= "Opciones WIM";
		WIM_LOCALIZED_OPTIONS_ICON_POSISTION		 		= "Posición Icono";
		WIM_LOCALIZED_OPTIONS_FONT_SIZE 						= "Tamaño Fuente";
		WIM_LOCALIZED_OPTIONS_WINDOW_SCALE 					= "Escala Ventana (Porcentaje)";
		WIM_LOCALIZED_OPTIONS_WINDOW_ALPHA	 				= "Transparencia (Porcentaje)";
		WIM_LOCALIZED_OPTIONS_WINDOW_WIDTH 					= "Ancho Ventana";
		WIM_LOCALIZED_OPTIONS_WINDOW_HEIGHT 				= "Altura Ventana";
		WIM_LOCALIZED_OPTIONS_LIMITED_HEIGHT 				= "(Limitado por accesos rápidos)";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME 		= "ERROR: ¡Nombre No Válido!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME2 	= "ERROR: ¡Nombre en uso!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_ALIAS 	= "ERROR: ¡Alias No Válido!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER  = "ERROR: ¡Palabra/Frase No Válida!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER2 = "ERROR: ¡Palabra/Frase ya en uso!";
		WIM_LOCALIZED_OPTIONS_DAY 									= "Día";
		WIM_LOCALIZED_OPTIONS_WEEK 									= "Semana";
		WIM_LOCALIZED_OPTIONS_MONTH 								= "Mes";
		WIM_LOCALIZED_OPTIONS_TOOLTIP_MSG_SPAWN 		= "Arrastra para configurar la posición\ndonde aparecen las ventanas de mensajes.";
		WIM_LOCALIZED_OPTIONS_UP 										= "Arriba";
		WIM_LOCALIZED_OPTIONS_DOWN 									= "Abajo";
		WIM_LOCALIZED_OPTIONS_LEFT 									= "Izquierda";
		WIM_LOCALIZED_OPTIONS_RIGHT 								= "Derecha";
		WIM_LOCALIZED_OPTIONS_FILTER_IGNORE 				= "Ignorar";
		WIM_LOCALIZED_OPTIONS_FILTER_BLOCK 					= "Bloquear";
		WIM_LOCALIZED_OPTIONS_ENABLE_WIM 						= "Activar WIM";
		
		WIM_LOCALIZED_OPTIONS_DISPLAY_TITLE 				= "Mostrar Opciones";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_IN 			= "Susurros Entrantes";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_OUT 			= "Susurros Salientes";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SYSTEM 				= "Mensajes de Sistema";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ERROR 				= "Mensajes de Error";
		WIM_LOCALIZED_OPTIONS_DISPLAY_URL 					= "Enlaces URLs Web";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SHORTCUTBAR		= "Mostrar accesos rápidos.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_SCB 	= "Estos parámetros limitan la\naltura mínima de la ventana.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TIMESTAMPS 		= "Mostrar hora mensaje.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO		 			= "Mostrar info. personaje:";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_CINFO = "Cambios serán efectivos solo para\nlas nuevas ventanas de mensaje.\n|cffffffff(Requiere consultar /quien en segundo plano.)|r";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_CLASS 	= "Iconos de Clase";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTOP_NEW		= "Cambios serán efectivos solo para\nlas nuevas ventanas de mensaje.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_COLOR 	= "Colores de Clase";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_DETAILS = "Detalles Personaje";
		
		WIM_LOCALIZED_OPTIONS_MINIMAP_TITLE 				= "Icono Minimapa";
		WIM_LOCALIZED_OPTIONS_MINIMAP_ENABLE 				= "Mostrar Icono Minimapa";
		WIM_LOCALIZED_OPTIONS_MINIMAP_FREEMOVING 		= "Posición Libre";
		WIM_LOCALIZED_OPTIONS_MINIMAP_TOOLTIP_FM		= "Estando activado, Mayús-Clic-Izquierdo\nen icono del minimapa, te permite\narrastrarlo alrededor de la pantalla.";
		
		WIM_LOCALIZED_OPTIONS_TAB_GENERAL 					= " General ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_WINDOWS 					= " Ventanas ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_FILTERS 					= " Filtros ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_HISTORY 					= " Historial ";	-- notice space buffering
		
		WIM_LOCALIZED_OPTIONS_GENERAL_AUTO_FOCUS 		= "Auto seleccionar ventana al mostrarse.";
		WIM_LOCALIZED_OPTIONS_GENERAL_KEEP_FOCUS 		= "Mantener foco despues de enviar un mensaje.";
		WIM_LOCALIZED_OPTIONS_GENERAL_FOCUS_RESTED 	= "Solo si estas en una ciudad principal.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SHOW_TOOLTIPS = "Mostrar cuadros de texto.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_SEND 			= "Mostrar ventana cuando envias susurros.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_IN 				= "Mostrar ventana cuando recibes nuevos susurros.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_REPLY 		= "Mostrar ventana cuando recibes respuestas.";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_COMBAT 		= "No mostrar ventanas en combate.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS 			= "Suprimir susurros de la ventana de chat.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SOUND_IN 			= "Reproducir un sonido al recibir un mensaje.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SORT_ALPHA 		= "Ordenar lista de conversaciones alfabéticamente.";
		WIM_LOCALIZED_OPTIONS_GENERAL_AFK_DND 			= "Mostrar mensajes de AUS y NM.";
		WIM_LOCALIZED_OPTIONS_GENERAL_ESCAPE 				= "Usa 'Tecla Escape' para cerrar ventanas.";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_ESC		= "Usar la 'Tecla Escape' tiene sus limitaciones. |cffffffffEjemplo: Se cerraran las ventanas cuando abras el mapa.|r";
		WIM_LOCALIZED_OPTIONS_GENERAL_INTERCEPT 		= "Interceptar comandos de consola de susurrar.";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_INTCP = "WIM interceptara cualquiera de los comandos para susurrar y automáticamente abrira una nueva ventana de mensaje. (Ejemplo: /su ó /susurrar).";
		
		WIM_LOCALIZED_OPTIONS_WINDOWS_CASCADE_DIR 	= "Activar cascada. Dirección:";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SET_LOCATION 	= "Ajustar Posición";
		
		WIM_LOCALIZED_OPTIONS_FILTERS_ENABLE 				= "Activar Uso de Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_COMMENT 			= "Como comentario";
		WIM_LOCALIZED_OPTIONS_FILTERS_NAME 					= "Nombre";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS 				= "Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_ADD 		= "Agregar Nuevo Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_ADD						= "Agregar";
		WIM_LOCALIZED_OPTIONS_FILTERS_REMOVE 				= "Eliminar";
		WIM_LOCALIZED_OPTIONS_FILTERS_EDIT 					= "Editar";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_EDIT 		= "Editar Alias";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ENABLE = "Activar Filtros";
		WIM_LOCALIZED_OPTIONS_FILTERS_KEY_PHRASE 		= "Palabras/Frases";
		WIM_LOCALIZED_OPTIONS_FILTERS_ACTION 				= "Acción";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ADD 		= "Agregar Nuevo Filtro";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_EDIT 	= "Editar Filtro";
		
		WIM_LOCALIZED_OPTIONS_HISTORY_ENABLE 				= "Activar Historial";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_ALL 		= "Guardar Todo";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_FRIENDS= "Guardar Amigos";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_GUILD 	= "Guardar Hermandad";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_IN 	= "Mensajes Entrantes";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_OUT 	= "Mensajes Salientes";
		WIM_LOCALIZED_OPTIONS_HISTORY_SHOW 					= "Mostrar historial en mensaje:";
		WIM_LOCALIZED_OPTIONS_HISTORY_MAX 					= "Ajustar mensajes máximos por usuario:";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE 				= "Eliminar mensajes más antiguos de:";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_USERS 		= "Usuarios Guardados";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_MESSAGES 	= "Mensajes Guardados";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE_USER 	= "Borrar Usuario";
		WIM_LOCALIZED_OPTIONS_HISTORY_VIEW_USER 		= "Ver Historial";
		
	-- Alias Window --
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL1 					= "Nombre Personaje";
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL2 					= "Alias Personaje";
	
	-- Filter Window --
		WIM_LOCALIZED_FILTER_WINDOW_LABEL1 					= "Palabra/Frase a Filtrar";
		WIM_LOCALIZED_FILTER_WINDOW_LABEL2 					= "Realizar la siguiente acción:";
		
		-- WIM_LOCALIZED_FILTER_1  									= "^LVBM";
		-- WIM_LOCALIZED_FILTER_2 									= "^YOU ARE BEING WATCHED!";
		-- WIM_LOCALIZED_FILTER_3										= "^YOU ARE MARKED!";
		-- WIM_LOCALIZED_FILTER_4										= "^YOU ARE CURSED!";
		-- WIM_LOCALIZED_FILTER_5										= "^YOU HAVE THE PLAGUE!";
		-- WIM_LOCALIZED_FILTER_6 									= "^YOU ARE BURNING!";
		-- WIM_LOCALIZED_FILTER_7										= "^YOU ARE THE BOMB!";
		-- WIM_LOCALIZED_FILTER_8  									= "VOLATILE INFECTION";
		-- WIM_LOCALIZED_FILTER_9										= "^<GA";
	
	-- Help Window --
		WIM_LOCALIZED_HELP_WINDOW_TITLE 						= "Documentación WIM";
		WIM_LOCALIZED_HELP_WINDOW_DESCRIPTION 			= " Descripción ";					-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_VERSION_HISTORY 	= " Historial de Versión ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_DID_YOU_KNOW 			= " ¿Sabías que? ";					-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_CREDITS 					= " Creditos ";							-- notice space buffering
	
	-- Titan Panel Plugin --
		WIM_LOCALIZED_TITAN_MESSAGES								= "Mensajes: ";
	
	-- URL Copy --
		WIM_LOCALIZED_URLCOPY_TITLE									= "Copiar URL";
	
	-- Class Names --
		WIM_LOCALIZED_DRUID 												= "Druida";
		WIM_LOCALIZED_HUNTER 												= "Cazador";
		WIM_LOCALIZED_MAGE 													= "Mago";
		WIM_LOCALIZED_PALADIN 											= "Paladín";
		WIM_LOCALIZED_PRIEST 												= "Sacerdote";
		WIM_LOCALIZED_ROGUE 												= "Pícaro";
		WIM_LOCALIZED_SHAMAN												= "Chamán";
		WIM_LOCALIZED_WARLOCK 											= "Brujo";
		WIM_LOCALIZED_WARRIOR 											= "Guerrero";
	
	
	-- Help Window Tabs --
WIM_DESCRIPTION = [[
WIM (WoW Instant Messenger)
|cffffffff
WIM es exactamente lo que su nombre indica; una interfaz de mensajeria instantánea para tus susurros en el juego. Ha sido especialmente diseñada para no interferir con tu ocupada interfaz (cuando estas en bandas)  pero también con la conveniencia de tener una ventana de chat para cada usuario que se comunica contigo.

Asegúrate de comprobar tu pantalla de Asignación de Teclas y echar un vistazo a las acciones disponibles de WIM.
|r
Comandos Útiles:
/wim			|cffffffff- Ventana de Opciones|r
/wim history	|cffffffff- Visor del Historial|r
/wim help		|cffffffff- (esta ventana)|r

Comandos Avanzados:
/wim reset			|cffffffff- Reinicia todas las opciones.|r
/wim reset filters	|cffffffff- Recarga todas las definiciones de filtros integrados.|r
/wim clear history	|cffffffff- Limpia el historial.|r



WIM se integra con los siguientes accesorios:|cffffffff
TitanPanel
Fubar 2.0|r 

WIM es compatible con los siguientes accesorios:|cffffffff
AllInOneInventory
EngInventory
SuperInspect
AtlasLoot
LootLink|r
]]

WIM_DIDYOUKNOW = [[
¿Sabías que...|cffffffff Escribiendo el comando |r/wim |cffffffffabres la interfaz de opciones donde puedes personalizar la apariencia y comportamiento de WIM?|r

¿Sabías que...|cffffffff WIM viene con un accesorio para Titan Panel integrado? ¡Buscalo en el menú de plugins de Titan!|r

¿Sabías que...|cffffffff Si vas a "Configurar Teclado" en el "Menú Principal", podrás encontrar unas cuantas asignaciones de teclado muy útiles para WIM?|r

¿Sabías que...|cffffffff Puedes hacer que el icono del minimapa pueda moverse libremente? Cuando esta en el modo 'Posición Libre', puedes pulsar Mayús-Clic-Izquierdo en el icono del minimapa para arrastrarlo donde quieras.|r

¿Sabías que...|cffffffff Pulsando el tabulador mientras estas en un mensaje, puedes alternar también entre otros mensajes?|r

¿Sabías que...|cffffffff Recibo todos los días muchos comentarios de usuarios pidiendo funciones que ya están implementadas en WIM? Es muy útil leer el registro de cambios entre actualizaciones. ¡noobs! :-)|r

¿Sabías que...|cffffffff Estoy muy agradecido de todo el mundo que se ha tomado el tiempo de votar y enviarme sus comentarios y sugerencias? Bueno... lo estoy :-).|r

¿Sabías que...|cffffffff Soy horrible con la ortografía? ¡Por favor no dudes en enviarme una corrección!|r

¿Sabías que...|cffffffff WIM tiene muchas opciones, y hay una barra de desplazamiento en la pestaña de opciones generales? Asegúrate de comprobarlas. ¡Hay muchas opciones disponibles de las que quizás no sabias nada!|r
]]

WIM_CREDITS = [[
WIM (WoW Instant Messenger) por Pazza <Bronzebeard>. 
|cffffffffConcepto e ideas originarias gracias a Sloans <Bronzebeard>.|r

Quiero agradecer a todos los que me han ayudado probando WIM así como aquellos que me han enviado sus comentarios y sugerencias incluyendo:
|cffffffff
- Nachonut <Bronzebeard>
- Sloans <Bronzebeard>
|r

Agradecimientos especiales a aquellos que me han ayudado a traducir WIM:
|cffffffff
- Bitz (Koreano)
- Corrilian (German)
- AlbertQ (Español)
- Annie (Simplified Chinese)
- Junxian (Traditional Chinese)
- Khellendros (French)
|r


Quiero dar las gracias también a todo el mundo que ha contribuido en ui.WorldOfWar.net y en Curse-Gaming.com.
]]


end