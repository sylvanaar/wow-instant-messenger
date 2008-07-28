	------------------------------------------------------------
	--             Traditional Chinese Localization		  --
        --                Update..95.11.1 by Junxian              --
        --                Update..97.01.15 by kaminoji            --
	------------------------------------------------------------

if (GetLocale() == "zhTW") then
	
	-- Global Strings --
		WIM_LOCALIZED_YES 							= "是";
		WIM_LOCALIZED_NO 							= "否";
		WIM_LOCALIZED_NONE 							= "無";
		WIM_LOCALIZED_RIGHT_CLICK					= "滑鼠右鍵";
		WIM_LOCALIZED_LEFT_CLICK					= "滑鼠左鍵";
		WIM_LOCALIZED_OK						= "確定";
		WIM_LOCALIZED_CANCEL						= "取消";
	        WIM_LOCALIZED_CLICK_TO_UPDATE					= "點擊更新資料...";
		WIM_LOCALIZED_NEW_VERSION					= "WIM 已有更新，你可以在 http://www.wimaddon.com下載到最新的版本";

	-- Strings From WIM.xml & WIM.lua --
		WIM_LOCALIZED_PURGED_HISTORY 				= "從聊天記錄中刪除{n}個過期項目";
		WIM_LOCALIZED_RECENT_CONVO_COUNT 			= "近期對話 {n1}/{n2}";
		WIM_LOCALIZED_NEW_MESSAGE 					= "新消息!";
		WIM_LOCALIZED_NO_NEW_MESSAGES 				= "沒有新消息";
		WIM_LOCALIZED_CONVO_CLOSED 					= "對話已關閉";
		WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE 	= "<Shift>+滑鼠左鍵結束對話";
		WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY 			= "點擊檢視聊天記錄";
		WIM_LOCALIZED_IGNORE_CONFIRM 				= "你確定要忽略此玩家嗎？";
		WIM_LOCALIZED_AFK							= "暫離";
		WIM_LOCALIZED_DND							= "勿擾";
		
	-- Shortcut Bar --
		WIM_LOCALIZED_TRADE 						= "交易";
		WIM_LOCALIZED_INVITE 						= "邀請";
		WIM_LOCALIZED_TARGET 						= "目標";
		WIM_LOCALIZED_INSPECT 						= "觀察";
		WIM_LOCALIZED_IGNORE 						= "忽略";
		WIM_LOCALIZED_FRIEND 						= "增加好友";
		WIM_LOCALIZED_LOCATION						= "玩家位置";

	-- Keybindings --
		BINDING_HEADER_WIMMOD 						= "WIM (WoW Instant Messenger)";
		BINDING_NAME_WIMSHOWNEW 					= "顯示新消息";
		BINDING_NAME_WIMHISTORY 					= "檢視聊天記錄";
		BINDING_NAME_WIMENABLE 						= "啟用/禁用";
		BINDING_NAME_WIMTOGGLE 						= "切換消息";
		BINDING_NAME_WIMSHOWALL 					= "顯示所有消息";
		BINDING_NAME_WIMHIDEALL 					= "隱藏所有消息";

	-- History Window --
		WIM_LOCALIZED_HISTORY_NO_FILTER				= "無 (顯示所有)";
		WIM_LOCALIZED_HISTORY_TITLE				= "WIM 聊天記錄檢視器";
		WIM_LOCALIZED_HISTORY_USERS 				= "玩家";
		WIM_LOCALIZED_HISTORY_FILTERS 				= "過濾條件";
		WIM_LOCALIZED_HISTORY_MESSAGES 				= "消息";
		
	-- MiniMap Icon --
		WIM_LOCALIZED_ICON_CONVO_MENU				= "對話選單";
		WIM_LOCALIZED_ICON_SHOW_NEW					= "顯示新消息";
		WIM_LOCALIZED_ICON_OPTIONS					= "WIM 選項設定";
		WIM_LOCALIZED_CONVERSATIONS					= "對話";
		WIM_LOCALIZED_ICON_WIM_TOOLS					= "WIM 工具";
	
	-- Options Window --
		WIM_LOCALIZED_OPTIONS_TITLE 				= "WIM 選項設定";
		WIM_LOCALIZED_OPTIONS_ICON_POSISTION 		= "圖示位置";
		WIM_LOCALIZED_OPTIONS_FONT_SIZE 			= "字型大小";
		WIM_LOCALIZED_OPTIONS_WINDOW_SCALE 			= "視窗縮放(百分比)";
		WIM_LOCALIZED_OPTIONS_WINDOW_ALPHA 			= "透明度(百分比)";
		WIM_LOCALIZED_OPTIONS_WINDOW_WIDTH 			= "視窗寬度";
		WIM_LOCALIZED_OPTIONS_WINDOW_HEIGHT 		= "視窗高度";
		WIM_LOCALIZED_OPTIONS_LIMITED_HEIGHT 		= "(受快捷圖示欄限制)";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME 	= "錯誤：不正確的名字";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME2 	= "錯誤：名字已被使用";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_ALIAS 	= "錯誤：不正確的別名";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER 	= "錯誤：不正確的關鍵字/短語";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER2 	= "錯誤：關鍵字/短語已被使用";
		WIM_LOCALIZED_OPTIONS_DAY 					= "天";
		WIM_LOCALIZED_OPTIONS_WEEK 					= "星期";
		WIM_LOCALIZED_OPTIONS_MONTH 				= "月";
		WIM_LOCALIZED_OPTIONS_TOOLTIP_MSG_SPAWN 	= "拖動設定消息視窗的出現位置";
		WIM_LOCALIZED_OPTIONS_UP 					= "上";
		WIM_LOCALIZED_OPTIONS_DOWN 					= "下";
		WIM_LOCALIZED_OPTIONS_LEFT 					= "左";
		WIM_LOCALIZED_OPTIONS_RIGHT 				= "右";
		WIM_LOCALIZED_OPTIONS_FILTER_IGNORE 		= "忽略";
		WIM_LOCALIZED_OPTIONS_FILTER_BLOCK 			= "阻止";
		WIM_LOCALIZED_OPTIONS_ENABLE_WIM 			= "啟用 WIM";

		WIM_LOCALIZED_OPTIONS_TIMEOUT_FRIENDS				= "好友自動關閉時間:";
		WIM_LOCALIZED_OPTIONS_TIMEOUT_OTHER				= "非好友自動關閉時間:";
		
		WIM_LOCALIZED_OPTIONS_DISPLAY_TITLE 		= "顯示設定";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_IN 		= "收到的悄悄話";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_OUT 		= "發出的悄悄話";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SYSTEM 		= "系統消息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ERROR 		= "錯誤訊息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_URL 			= "網頁網址";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SHORTCUTBAR	= "顯示快捷圖示欄";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_SCB 	= "這個選項設定會限制視窗的最小高度";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TIMESTAMPS 	= "顯示時間";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO			= "顯示角色訊息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_CINFO = "改變只對新消息視窗有效。\n|cffffffff(需要在後臺執行 /who 查詢)|r";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_CLASS 	= "職業圖示";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTOP_NEW	= "改變只對新消息視窗有效";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_COLOR 	= "職業色彩";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_DETAILS = "角色詳細訊息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ENABLE_FADING = "啟用淡出效果";
		
		WIM_LOCALIZED_OPTIONS_MINIMAP_TITLE 		= "小地圖圖示";
		WIM_LOCALIZED_OPTIONS_MINIMAP_ENABLE 		= "顯示小地圖圖示";
		WIM_LOCALIZED_OPTIONS_MINIMAP_FREEMOVING 	= "自由移動";
		WIM_LOCALIZED_OPTIONS_MINIMAP_TOOLTIP_FM	= "啟用時，按住 <Shift> 用滑鼠左鍵單擊小地圖圖示並保持左鍵按下狀態，可以在螢幕上自由拖動小地圖圖示。";
		
		WIM_LOCALIZED_OPTIONS_TAB_GENERAL 			= " 一般 ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_WINDOWS 			= " 視窗 ";		-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_FILTERS 			= " 過濾條件 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_HISTORY 			= " 聊天記錄 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_PLUGINS 			= " 插件 ";	-- notice space buffering		

		WIM_LOCALIZED_OPTIONS_GENERAL_AUTO_FOCUS 	= "視窗彈出時自動獲得焦點";
		WIM_LOCALIZED_OPTIONS_GENERAL_KEEP_FOCUS 	= "發送消息後視窗保持獲得焦點狀態";
		WIM_LOCALIZED_OPTIONS_GENERAL_FOCUS_RESTED 	= "只在主城有效";
		WIM_LOCALIZED_OPTIONS_GENERAL_SHOW_TOOLTIPS 	= "顯示小竅門";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_SEND 		= "發送悄悄話時彈出視窗";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_IN 		= "收到悄悄話時彈出視窗";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_REPLY 	= "收到回覆時彈出視窗";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_COMBAT 	= "戰鬥狀態不彈出視窗";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS 		= "取締遊戲預設聊天視窗顯示的悄悄話";
		WIM_LOCALIZED_OPTIONS_GENERAL_SOUND_IN 		= "收到消息時播放提示音";
		WIM_LOCALIZED_OPTIONS_GENERAL_SORT_ALPHA 	= "按字母順序排序對話列表";
		WIM_LOCALIZED_OPTIONS_GENERAL_AFK_DND 		= "顯示暫離和勿擾消息";
		WIM_LOCALIZED_OPTIONS_GENERAL_ESCAPE 		= "使用 <ESC> 鍵關閉視窗";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_ESC	= "使用 <ESC> 鍵有一定的限制。|cffffffff比如：打開地圖時聊天視窗會被關閉。|r";
		WIM_LOCALIZED_OPTIONS_GENERAL_INTERCEPT 	= "截獲悄悄話命令";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_INTCP = "WIM 會截獲所有的悄悄話命令(比如 /w 或者 /whisper)並自動打開新消息視窗";
		WIM_LOCALIZED_OPTIONS_GENERAL_IGNOREARROW		= "輸入訊息時忽略方向鍵.";
		WIM_LOCALIZED_OPTIONS_GENERAL_MENURCLICK		= "在小圖示<點右鍵>顯示 'WIM 工具'.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS_COMBAT= "戰鬥時不彈出密語視窗.";
		
		WIM_LOCALIZED_OPTIONS_WINDOWS_CASCADE_DIR 	= "啟用視窗層疊顯示 / 方向";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SET_LOCATION 	= "設定位置";
		WIM_LOCALIZED_OPTIONS_WINDOWS_MODE_WIN		= "多視窗模式";
		WIM_LOCALIZED_OPTIONS_WINDOWS_MODE_TAB		= "標籤視窗模式";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT			= "標籤排序依據:";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT1			= "密語順序";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT2			= "字母順序";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT3			= "回應順序";
		WIM_LOCALIZED_OPTIONS_WINDOWS_ONTOP			= "保持視窗在最上層.";
		
		WIM_LOCALIZED_OPTIONS_FILTERS_ENABLE 		= "啟用別名";
		WIM_LOCALIZED_OPTIONS_FILTERS_COMMENT 		= "顯示為注釋";
		WIM_LOCALIZED_OPTIONS_FILTERS_NAME 			= "名字";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS 		= "別名";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_ADD 	= "新增別名";
		WIM_LOCALIZED_OPTIONS_FILTERS_ADD			= "新增";
		WIM_LOCALIZED_OPTIONS_FILTERS_REMOVE 		= "刪除";
		WIM_LOCALIZED_OPTIONS_FILTERS_EDIT 			= "編輯";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_EDIT 	= "編輯別名";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ENABLE = "啟用過濾條件";
		WIM_LOCALIZED_OPTIONS_FILTERS_KEY_PHRASE 	= "關鍵字/短語";
		WIM_LOCALIZED_OPTIONS_FILTERS_ACTION 		= "動作";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ADD 	= "新增過濾條件";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_EDIT 	= "編輯過濾條件";
		
		WIM_LOCALIZED_OPTIONS_HISTORY_ENABLE 		= "啟用聊天記錄";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_ALL 	= "記錄所有玩家";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_FRIENDS= "記錄好友";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_GUILD 	= "記錄公會";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_IN 	= "收到的消息";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_OUT 	= "發出的消息";
		WIM_LOCALIZED_OPTIONS_HISTORY_SHOW 			= "消息內容中顯示歷史記錄";
		WIM_LOCALIZED_OPTIONS_HISTORY_MAX 			= "每個玩家的保留的最大消息數目";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE 		= "刪除過期的消息/如果它早於   一";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_USERS 	= "已記錄的玩家";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_MESSAGES 	= "已保存的消息";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE_USER 	= "刪除玩家";
		WIM_LOCALIZED_OPTIONS_HISTORY_VIEW_USER 	= "檢視記錄";

		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPLUGIN	 		= "目前未讀取任何插件.";
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPLUGIN_EX		= "你沒有任何 WIM 插件，請至 http://www.WIMAddon.com 下載";
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPTIONS			= "這個插件沒有任何選項.";
		WIM_LOCALIZED_OPTIONS_PLUGININFO			= "插件訊息";
		
	-- Alias Window --
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL1 			= "角色姓名";
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL2 			= "角色別名";
	
	-- Filter Window --
		WIM_LOCALIZED_FILTER_WINDOW_LABEL1 			= "需要過濾的關鍵字/短語";
		WIM_LOCALIZED_FILTER_WINDOW_LABEL2 			= "執行如下操作：";
		
		WIM_LOCALIZED_FILTER_1  					= "^LVBM";
		WIM_LOCALIZED_FILTER_2 						= "^你被盯上了！";
		WIM_LOCALIZED_FILTER_3						= "^你被標記了！";
		WIM_LOCALIZED_FILTER_4						= "^你中了詛咒！";
		WIM_LOCALIZED_FILTER_5						= "^你中了瘟疫";
		WIM_LOCALIZED_FILTER_6 						= "^你正在燃燒！";
		WIM_LOCALIZED_FILTER_7						= "^你是炸彈人！";
		WIM_LOCALIZED_FILTER_8  					= "變異注射";
		WIM_LOCALIZED_FILTER_9						= "^GA2";
		WIM_LOCALIZED_FILTER_10				= "^/";
		WIM_LOCALIZED_FILTER_11				= "^<METAMAP";
		WIM_LOCALIZED_FILTER_12				= "^<CT";
		
	-- Help Window --
		WIM_LOCALIZED_HELP_WINDOW_TITLE 			= "WIM 說明";
		WIM_LOCALIZED_HELP_WINDOW_DESCRIPTION 		= " 簡介 ";		-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_VERSION_HISTORY 	= " 版本歷史(英文) ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_DID_YOU_KNOW 		= " 你知道嗎？ ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_CREDITS 			= " 關於 ";		-- notice space buffering
	
	-- Titan Panel Plugin --
		WIM_LOCALIZED_TITAN_MESSAGES				= "新消息: ";
	
	-- URL Copy --
		WIM_LOCALIZED_URLCOPY_TITLE					= "複製網址";
	
	-- Class Names --
		WIM_LOCALIZED_DRUID 						= "德魯伊";
		WIM_LOCALIZED_HUNTER 						= "獵人";
		WIM_LOCALIZED_MAGE 						= "法師";
		WIM_LOCALIZED_PALADIN 						= "聖騎士";
		WIM_LOCALIZED_PRIEST 						= "牧師";
		WIM_LOCALIZED_ROGUE 						= "盜賊";
		WIM_LOCALIZED_SHAMAN 						= "薩滿";
		WIM_LOCALIZED_WARLOCK 						= "術士";
		WIM_LOCALIZED_WARRIOR 						= "戰士";
		WIM_LOCALIZED_GM						= "線上GM";

	-- W2W Localizations --
		WIM_W2W_LOCALIZED_OPTIONS_DESC                  = "WIM-2-WIM 是當使用者交談中得以使用某些特別功能的系統，\n尤其對方也同樣使用WIM時。\n這個系統將會擴展更多使用功能。\n關閉此功能將會結束所有基於W2W 所建立的通訊.";
		WIM_W2W_LOCALIZED_OPTIONS_ENABLE                = "啟用 (W2W) WIM-2-WIM 通訊功能";
                WIM_W2W_LOCALIZED_OPTIONS_TYPING                = "同意其他人得知你正打字中.";
                WIM_W2W_CAPABILITIES			        = "功能";
		WIM_W2W_IS_TYPING				= "正在打字中...";
                
        -- Skinner Localizations --
                WIM_SKINNER_LOCALIZED_OPTIONS_DESC              = "WIM 設計家是為了讓玩家自定外觀所設計的開放式系統，\n想知道如何設定WIM 的外觀請上網站 http://www.wimaddon.com 觀看相關文件.\n\n 想改變WIM 的外觀，請從選單選擇一個設定檔。\n一些外觀包含了數種不同的風格，並請自行選擇觀看。\n\nWIM 設計家同樣允許你自訂字型，從字型選單或選擇'系統建議'\n來使用該設定檔作者所建議的字型。\n\n要下載更多的外觀設定檔，請上 http://www.wimaddon.com.";
                WIM_SKINNER_LOCALIZED_OPTIONS_INSTD             = "已安裝的外觀：";
                WIM_SKINNER_LOCALIZED_OPTIONS_PREF              = "外觀自訂";
                WIM_SKINNER_LOCALIZED_OPTIONS_STYLE             = "外觀風格：";
                WIM_SKINNER_LOCALIZED_OPTIONS_FONT              = "外觀字型：";
                WIM_SKINNER_LOCALIZED_OPTIONS_DEFAULT_FONT      = "外觀的預設字型";
                
	-- Help Window Tabs --
WIM_DESCRIPTION = [[
WIM (WoW Instant Messenger)
|cffffffff
WIM 是為你準備的處理遊戲裡的悄悄話的及時消息插件。它經過細心的設計，讓你在與其它玩家聊天時可以有一個類似於常見及時消息軟件的聊天視窗，又不會在你很忙(比如正在進行團隊戰鬥)時干擾你。

不要忘了檢查遊戲的按鍵設定介面，看看 WIM 有哪些可用的按鍵設定。
|r
一般命令：
/wim		|cffffffff - 選項設定視窗|r
/wim history	|cffffffff - 檢視聊天記錄|r
/wim help	|cffffffff - 顯示幫助訊息(你正看到的這個視窗)|r

進階命令：
/wim reset		|cffffffff - 將所有選項設定恢復為預設值|r
/wim reset filters	|cffffffff - 重新載入所有預設過濾條件定義|r
/wim clear history	|cffffffff - 清除聊天記錄|r

WIM 可以將自己集成到以下插件：|cffffffff
TitanPanel
Fubar 2.0|r 

WIM 兼容以下插件：|cffffffff
AllInOneInventory
EngInventory
SuperInspect
AtlasLoot
LootLink|r
]]

WIM_DIDYOUKNOW = [[
你知道嗎？——|cffffffff 輸入命令 |r/wim |cffffffff可以打開選項設定介面來訂制 WIM 的外觀和使用體驗。|r

你知道嗎？——|cffffffff WIM 內置集成到 Titan Panel 的功能。不要忘了檢視 Titan 的插件選單。|r

你知道嗎？——|cffffffff 打開遊戲“主選單”的“按鍵設定”，可以發現關於 WIM 的按鍵設定選項。|r

你知道嗎？——|cffffffff 小地圖圖示是可以自由移動的。在自由移動模式下，按住<Shift>用滑鼠左鍵單擊小地圖圖示並保持左鍵按下狀態，可以把小地圖圖示拖動到螢幕的任何地方。|r

你知道嗎？——|cffffffff 在檢視消息時按 <TAB> 鍵，可以切換到其它消息。|r

你知道嗎？——|cffffffff 我每天都收到許多功能需求，這些功能在 WIM 裡早已實現了。仔細閱讀各個版本之間的更新日誌是非常有用的。:-)|r

你知道嗎？——|cffffffff 我對所有花時間來評價 WIM 並反饋意見和建議的朋友表示感謝。:-)|r

你知道嗎？——|cffffffff 我的單詞拼寫很糟糕。請毫不猶豫地給我發更正訊息。|r

你知道嗎？——|cffffffff WIM 的選項設定非常多，你有沒有注意到常規選項頁面有一個滾動條？記得檢視一下，那兒也許會有一些你沒有注意到的選項。|r
]]

WIM_CREDITS = [[
WIM (WoW Instant Messenger)  作者：Pazza <Bronzebeard>
|cffffffff設計思想和理念由 Sloans <Bronzebeard> 提出。|r

感謝所有幫助測試 WIM 並反饋意見和建議的朋友。包括但不限於：
|cffffffff
- Nachonut <Bronzebeard>
- Sloans <Bronzebeard>
- Stewarta <Emerald Dream>
|r

特別感謝以下 WIM 的本地化翻譯者：
|cffffffff
- Bitz (韓國/朝鮮語)
- Annie <銅龍軍團> (簡體中文)
- Junxian <蝶語> kaminoji<after 2.2>(繁體中文)
- Corrilian (German) 德語
- AlbertQ (Spanish) 西班牙
- Khellendros (French) 法國

|r

在此還要感謝所有協助過 ui.WorldOfWar.net 和 Curse-Gaming.com 的朋友。
]]

	
--[[ DEFINITION CHANGE LOG:
		This logs purpose is to make it easier for translators to update 
		their localization files between updates.
		
		Version 1.4.3
		[!] - First Simplified Chinese Localization Definitions Added.
]]

end