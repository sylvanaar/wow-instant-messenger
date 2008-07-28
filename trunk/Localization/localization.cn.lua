	------------------------------------------------------------
	--             Simplified Chinese Localization		  --
	------------------------------------------------------------

if (GetLocale() == "zhCN") then
	
	-- Global Strings --
		WIM_LOCALIZED_YES				= "是";
		WIM_LOCALIZED_NO 				= "否";
		WIM_LOCALIZED_NONE 				= "无";
		WIM_LOCALIZED_RIGHT_CLICK			= "鼠标右键";
		WIM_LOCALIZED_LEFT_CLICK			= "鼠标左键";
		WIM_LOCALIZED_OK				= "确定";
		WIM_LOCALIZED_CANCEL				= "取消";
		WIM_LOCALIZED_UNKNOWN				= "未知";
		WIM_LOCALIZED_CLICK_TO_UPDATE			= "点击更新...";
		
		WIM_LOCALIZED_NEW_VERSION			= "发现 WIM 新版本!\n你可以去以下网站下载最新版本:\n\n http://www.wimaddon.com";

	-- Strings From WIM.xml & WIM.lua --
		WIM_LOCALIZED_PURGED_HISTORY 			= "从聊天记录中删除{n}个过期项目。";
		WIM_LOCALIZED_RECENT_CONVO_COUNT 		= "近期对话 {n1}/{n2}";
		WIM_LOCALIZED_NEW_MESSAGE 			= "新消息！";
		WIM_LOCALIZED_NO_NEW_MESSAGES 			= "没有新消息。";
		WIM_LOCALIZED_CONVO_CLOSED 			= "对话已关闭。";
		WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE 	= "<Shift>+鼠标左键结束对话。";
		WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY 	        = "点击查看聊天记录。";
		WIM_LOCALIZED_IGNORE_CONFIRM 			= "你确定要忽略此玩家吗？";
		WIM_LOCALIZED_AFK				= "暂离";
		WIM_LOCALIZED_DND				= "勿扰";
		
	-- Shortcut Bar --
		WIM_LOCALIZED_TRADE 				= "交易";
		WIM_LOCALIZED_INVITE 				= "邀请";
		WIM_LOCALIZED_TARGET 				= "目标";
		WIM_LOCALIZED_INSPECT 				= "观察";
		WIM_LOCALIZED_IGNORE 				= "忽略";
		WIM_LOCALIZED_FRIEND 				= "添加好友";
		WIM_LOCALIZED_LOCATION				= "玩家位置";
		WIM_LOCALIZED_COORD					= "玩家坐标";

	-- Keybindings --
		BINDING_HEADER_WIMMOD 				= "WIM (WoW Instant Messenger)";
		BINDING_NAME_WIMSHOWNEW 			= "显示新消息";
		BINDING_NAME_WIMHISTORY 			= "查看聊天记录";
		BINDING_NAME_WIMENABLE 				= "启用/禁用";
		BINDING_NAME_WIMTOGGLE 				= "切换消息";
		BINDING_NAME_WIMSHOWALL 			= "显示所有消息";
		BINDING_NAME_WIMHIDEALL 			= "隐藏所有消息";

	-- History Window --
		WIM_LOCALIZED_HISTORY_NO_FILTER			= "无 (显示所有)";
		WIM_LOCALIZED_HISTORY_TITLE			= "WIM 聊天记录查看器";
		WIM_LOCALIZED_HISTORY_USERS 			= "玩家";
		WIM_LOCALIZED_HISTORY_FILTERS 		        = "过滤条件";
		WIM_LOCALIZED_HISTORY_MESSAGES 			= "消息";
		
	-- MiniMap Icon --
		WIM_LOCALIZED_ICON_CONVO_MENU			= "对话菜单";
		WIM_LOCALIZED_ICON_SHOW_NEW			= "显示新消息";
		WIM_LOCALIZED_ICON_OPTIONS			= "WIM 选项设置";
		WIM_LOCALIZED_CONVERSATIONS			= "对话";
		WIM_LOCALIZED_ICON_WIM_TOOLS			= "WIM 工具";
	
	-- Options Window --
		WIM_LOCALIZED_OPTIONS_TITLE 			= "WIM 选项设置";
		WIM_LOCALIZED_OPTIONS_ICON_POSISTION 		= "图标位置";
		WIM_LOCALIZED_OPTIONS_FONT_SIZE 		= "字体大小";
		WIM_LOCALIZED_OPTIONS_WINDOW_SCALE 		= "窗口缩放(百分比)";
		WIM_LOCALIZED_OPTIONS_WINDOW_ALPHA 		= "透明度(百分比)";
		WIM_LOCALIZED_OPTIONS_WINDOW_WIDTH 		= "窗口宽度";
		WIM_LOCALIZED_OPTIONS_WINDOW_HEIGHT 		= "窗口高度";
		WIM_LOCALIZED_OPTIONS_LIMITED_HEIGHT 		= "(受快捷图标栏限制)";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME 	= "错误：不正确的名字。";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME2 	= "错误：名字已被使用。";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_ALIAS 	= "错误：不正确的别名。";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER 	= "错误：不正确的关键字/短语。";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER2     = "错误：关键字/短语已被使用。";
		WIM_LOCALIZED_OPTIONS_DAY 		        = "天";
		WIM_LOCALIZED_OPTIONS_WEEK 			= "星期";
		WIM_LOCALIZED_OPTIONS_MONTH 			= "月";
		WIM_LOCALIZED_OPTIONS_TOOLTIP_MSG_SPAWN 	= "拖动设置消息窗口的出现位置。";
		WIM_LOCALIZED_OPTIONS_UP 			= "上";
		WIM_LOCALIZED_OPTIONS_DOWN 			= "下";
		WIM_LOCALIZED_OPTIONS_LEFT 			= "左";
		WIM_LOCALIZED_OPTIONS_RIGHT 			= "右";
		WIM_LOCALIZED_OPTIONS_FILTER_IGNORE 		= "忽略";
		WIM_LOCALIZED_OPTIONS_FILTER_BLOCK 		= "阻止";
		WIM_LOCALIZED_OPTIONS_ENABLE_WIM 		= "启用 WIM";
		
		WIM_LOCALIZED_OPTIONS_TIMEOUT_FRIENDS		= "自动关闭好友在:";
		WIM_LOCALIZED_OPTIONS_TIMEOUT_OTHER		= "自动关闭非好友在:";
		
		WIM_LOCALIZED_OPTIONS_DISPLAY_TITLE 		= "显示设置";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_IN 		= "收到的悄悄话";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_OUT 		= "发出的悄悄话";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SYSTEM 		= "系统消息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ERROR 		= "错误信息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_URL 		= "网页链接";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SHORTCUTBAR	= "显示快捷图标栏";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_SCB 	= "这个选项设置会限制窗口的最小高度。";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TIMESTAMPS 	= "显示时间";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO		= "显示角色信息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_CINFO     = "改变只对新消息窗口有效。\n|cffffffff(需要在后台执行 /who 查询。)|r";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_CLASS 	= "职业图标";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTOP_NEW	= "改变只对新消息窗口有效。";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_COLOR 	= "职业色彩";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_DETAILS     = "角色详细信息";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ENABLE_FADING     = "允许渐隐";
		
		WIM_LOCALIZED_OPTIONS_MINIMAP_TITLE 		= "小地图图标";
		WIM_LOCALIZED_OPTIONS_MINIMAP_ENABLE 		= "显示小地图图标";
		WIM_LOCALIZED_OPTIONS_MINIMAP_FREEMOVING 	= "自由移动";
		WIM_LOCALIZED_OPTIONS_MINIMAP_TOOLTIP_FM	= "启用时，按住<Shift>用鼠标左键单击小地图图标并保持左键按下状态，可以在屏幕上自由拖动小地图图标。";
		
		WIM_LOCALIZED_OPTIONS_TAB_GENERAL 		= " 常规 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_WINDOWS 		= " 窗口 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_FILTERS 		= " 过滤条件 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_HISTORY 		= " 聊天记录 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_PLUGINS 		= " 插件 ";	-- notice space buffering
		
		WIM_LOCALIZED_OPTIONS_GENERAL_AUTO_FOCUS 	= "窗口弹出时自动获得焦点";
		WIM_LOCALIZED_OPTIONS_GENERAL_KEEP_FOCUS 	= "发送消息后窗口保持获得焦点状态";
		WIM_LOCALIZED_OPTIONS_GENERAL_FOCUS_RESTED 	= "只在主城有效";
		WIM_LOCALIZED_OPTIONS_GENERAL_SHOW_TOOLTIPS     = "显示小窍门";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_SEND 		= "发送悄悄话时弹出窗口";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_IN 		= "收到悄悄话时弹出窗口";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_REPLY 	= "收到回复时弹出窗口";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_COMBAT 	= "战斗状态不弹出窗口";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS 		= "隐藏游戏默认聊天窗口显示的悄悄话";
		WIM_LOCALIZED_OPTIONS_GENERAL_SOUND_IN 		= "收到消息时播放提示音";
		WIM_LOCALIZED_OPTIONS_GENERAL_SORT_ALPHA 	= "按字母顺序排序对话列表";
		WIM_LOCALIZED_OPTIONS_GENERAL_AFK_DND 		= "显示暂离和勿扰消息";
		WIM_LOCALIZED_OPTIONS_GENERAL_ESCAPE 		= "使用 <ESC> 键关闭窗口";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_ESC	= "使用 <ESC> 键有一定的限制。|cffffffff比如：打开地图时聊天窗口会被关闭。|r";
		WIM_LOCALIZED_OPTIONS_GENERAL_INTERCEPT 	= "截获悄悄话命令";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_INTCP     = "WIM 会截获所有的悄悄话命令(比如：/w 或者 /whisper)并自动打开新消息窗口。";
		WIM_LOCALIZED_OPTIONS_GENERAL_IGNOREARROW	= "在输入时忽略方向键.";
		WIM_LOCALIZED_OPTIONS_GENERAL_MENURCLICK	= "显示小地图按钮.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS_COMBAT    = "战斗中不隐藏.";
		
		WIM_LOCALIZED_OPTIONS_WINDOWS_CASCADE_DIR 	= "启用窗口层叠显示。方向：";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SET_LOCATION 	= "设置位置";
		WIM_LOCALIZED_OPTIONS_WINDOWS_MODE_WIN		= "多窗口模式";
		WIM_LOCALIZED_OPTIONS_WINDOWS_MODE_TAB		= "标签模式";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT		= "标签分类:";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT1		= "收到顺序";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT2		= "字母";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT3		= "活跃度";
		WIM_LOCALIZED_OPTIONS_WINDOWS_ONTOP		= "保持窗口优先级在顶层.";
		
		WIM_LOCALIZED_OPTIONS_FILTERS_ENABLE 		= "启用别名";
		WIM_LOCALIZED_OPTIONS_FILTERS_COMMENT 		= "显示为注释";
		WIM_LOCALIZED_OPTIONS_FILTERS_NAME 		= "名字";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS 		= "别名";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_ADD 	= "新增别名";
		WIM_LOCALIZED_OPTIONS_FILTERS_ADD		= "新增";
		WIM_LOCALIZED_OPTIONS_FILTERS_REMOVE 		= "删除";
		WIM_LOCALIZED_OPTIONS_FILTERS_EDIT 		= "编辑";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_EDIT 	= "编辑别名";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ENABLE     = "启用过滤条件";
		WIM_LOCALIZED_OPTIONS_FILTERS_KEY_PHRASE 	= "关键字/短语";
		WIM_LOCALIZED_OPTIONS_FILTERS_ACTION 		= "动作";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ADD        = "新增过滤条件";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_EDIT 	= "编辑过滤条件";
		
		WIM_LOCALIZED_OPTIONS_HISTORY_ENABLE 		= "启用聊天记录";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_ALL 	= "记录所有玩家";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_FRIENDS    = "记录好友";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_GUILD 	= "记录工会";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_IN 	= "收到的消息";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_OUT 	= "发出的消息";
		WIM_LOCALIZED_OPTIONS_HISTORY_SHOW 		= "在消息内容中显示历史记录：";
		WIM_LOCALIZED_OPTIONS_HISTORY_MAX 		= "为每个玩家的保留的最大消息数目：";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE 		= "删除过期的消息，如果它早于1：";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_USERS 	= "已记录的玩家";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_MESSAGES 	= "已保存的消息";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE_USER 	= "删除玩家";
		WIM_LOCALIZED_OPTIONS_HISTORY_VIEW_USER 	= "查看聊天记录";
		
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPLUGIN	 	= "没有插件被载入.";
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPLUGIN_EX	= "你没有任何 WIM 插件.\n\n下载 WIM 插件请到:\nhttp://www.WIMAddon.com";
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPTIONS		= "此插件无设置选项.";
		WIM_LOCALIZED_OPTIONS_PLUGININFO		= "插件信息";
	-- Alias Window --
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL1 		= "角色姓名";
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL2 		= "角色别名";
	
	-- Filter Window --
		WIM_LOCALIZED_FILTER_WINDOW_LABEL1 		= "需要过滤的关键字/短语";
		WIM_LOCALIZED_FILTER_WINDOW_LABEL2 		= "执行如下操作：";
		
		WIM_LOCALIZED_FILTER_1				= "^LVBM";
		WIM_LOCALIZED_FILTER_2 				= "^你被盯上了";
		WIM_LOCALIZED_FILTER_3				= "^你被标记了";
		WIM_LOCALIZED_FILTER_4				= "^你中了诅咒";
		WIM_LOCALIZED_FILTER_5				= "^你中了瘟疫";
		WIM_LOCALIZED_FILTER_6 				= "^你正在燃烧";
		WIM_LOCALIZED_FILTER_7				= "^你是炸弹人";
		WIM_LOCALIZED_FILTER_8  			= "变异注射";
		WIM_LOCALIZED_FILTER_9				= "^GA[^A-Z]+";
		WIM_LOCALIZED_FILTER_10				= "^/";
		WIM_LOCALIZED_FILTER_11				= "^<METAMAP";
		WIM_LOCALIZED_FILTER_12				= "^<CT";
	
	-- Help Window --
		WIM_LOCALIZED_HELP_WINDOW_TITLE 		= "WIM 文档";
		WIM_LOCALIZED_HELP_WINDOW_DESCRIPTION 		= " 简介 ";	        -- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_VERSION_HISTORY 	= " 版本历史(英文) ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_DID_YOU_KNOW 		= " 你知道吗？ ";		-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_CREDITS 		= " 光荣榜 ";		-- notice space buffering
	
	-- Titan Panel Plugin --
		WIM_LOCALIZED_TITAN_MESSAGES			= "新消息：";
	
	-- URL Copy --
		WIM_LOCALIZED_URLCOPY_TITLE			= "复制链接";
	
	-- Class Names --
		WIM_LOCALIZED_DRUID 				= "德鲁伊";
		WIM_LOCALIZED_HUNTER 				= "猎人";
		WIM_LOCALIZED_MAGE 				= "法师";
		WIM_LOCALIZED_PALADIN 				= "圣骑士";
		WIM_LOCALIZED_PRIEST 				= "牧师";
		WIM_LOCALIZED_ROGUE 				= "潜行者";
		WIM_LOCALIZED_SHAMAN 				= "萨满祭司";
		WIM_LOCALIZED_WARLOCK 				= "术士";
		WIM_LOCALIZED_WARRIOR 				= "战士";
		WIM_LOCALIZED_GM				= "G M";
	
	-- W2W Localizations --
		WIM_W2W_LOCALIZED_OPTIONS_DESC                  = "WIM-2-WIM is a system which allows users to access\nspecial features when chatting, specifically with other\nWIM users.\n\nThis system has been built to be expanded upon.\nSo expect more in the future.\n\nDisabling will terminate all W2W based communications.";
		WIM_W2W_LOCALIZED_OPTIONS_ENABLE                = "开启 (W2W) WIM-2-WIM 互通";
		WIM_W2W_LOCALIZED_OPTIONS_TYPING                = "让其他玩家看到你正在输入状态.";
		WIM_W2W_CAPABILITIES			        = "性能";
		WIM_W2W_IS_TYPING				= "正在输入...";
                
        -- Skinner Localizations --
                WIM_SKINNER_LOCALIZED_OPTIONS_DESC              = "WIM Skinner is an open system implemented for designers\nto create custom skins for WIM. For documentation on how\nto make a skin for WIM visit http://www.wimaddon.com.\n\n To change the way WIM looks, select a skin from the list.\nSome skins contain multiple styles so be sure to browse\nthrough them for further customization.\n\nWIM Skinner also alows you to customize fonts. Select a\nfont of your choice from the font selection list or\nclick 'Recommended' to use the skin which the designer\norigionally indended to be used with his/her skin.\n\nTo download more skins, visit http://www.wimaddon.com.";
                WIM_SKINNER_LOCALIZED_OPTIONS_INSTD             = "已安装皮肤:";
                WIM_SKINNER_LOCALIZED_OPTIONS_PREF              = "定制皮肤";
                WIM_SKINNER_LOCALIZED_OPTIONS_STYLE             = "皮肤样式:";
                WIM_SKINNER_LOCALIZED_OPTIONS_FONT              = "皮肤字体:";
                WIM_SKINNER_LOCALIZED_OPTIONS_DEFAULT_FONT      = "皮肤默认字体";
                
        
	-- Help Window Tabs --
WIM_DESCRIPTION = [[
WIM (WoW Instant Messenger)
|cffffffff
WIM 是为你准备的处理游戏里的悄悄话的及时消息插件。它经过悉心的设计，让你在与其它玩家聊天时可以有一个类似于常见及时消息软件的聊天窗口，又不会在你很忙(比如正在进行团队战斗)时干扰你。

不要忘了检查游戏的按键设置界面，看看 WIM 有哪些可用的按键设置。

Be sure to check your Key Bindings screen and look for WIM's available actions.
|r
常用命令：
/wim		|cffffffff - 选项设置窗口|r
/wim history		|cffffffff - 查看聊天记录|r
/wim help		|cffffffff - 显示帮助信息(你正看到的这个窗口)|r

高级命令：
/wim reset		|cffffffff - 将所有选项设置恢复为默认值|r
/wim reset filters		|cffffffff - 重新加载所有默认过滤条件定义|r
/wim clear history		|cffffffff - 清除聊天记录|r

WIM 可以将自己集成到以下插件：|cffffffff
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
你知道吗？——|cffffffff 输入命令 |r/wim |cffffffff可以打开选项设置界面来订制 WIM 的外观和使用体验。|r

你知道吗？——|cffffffff WIM 内置集成到 Titan Panel 的功能。不要忘了查看 Titan 的插件菜单。|r

你知道吗？——|cffffffff 打开游戏“主菜单”的“按键设置”，可以发现关于 WIM 的按键设置选项。|r

你知道吗？——|cffffffff 小地图图标是可以自由移动的。在自由移动模式下，按住<Shift>用鼠标左键单击小地图图标并保持左键按下状态，可以把小地图图标拖动到屏幕的任何地方。|r

你知道吗？——|cffffffff 在查看消息时按 <TAB> 键，可以切换到其它消息。|r

你知道吗？——|cffffffff 我每天都收到许多功能需求，这些功能在 WIM 里早已实现了。仔细阅读各个版本之间的更新日志是非常有用的。:-)|r

你知道吗？——|cffffffff 我对所有花时间来评价 WIM 并反馈意见和建议的朋友表示感谢。:-)|r

你知道吗？——|cffffffff 我的单词拼写很糟糕。请毫不犹豫地给我发更正信息。|r

你知道吗？——|cffffffff WIM 的选项设置非常多，你有没有注意到常规选项页面有一个滚动条？记得查看一下，那儿也许会有一些你没有注意到的选项。|r
]]

WIM_CREDITS = [[
WIM (WoW Instant Messenger)  作者：Pazza <Bronzebeard>
|cffffffff设计思想和理念由 Sloans <Bronzebeard> 提出。|r

感谢所有帮助测试 WIM 并反馈意见和建议的朋友。包括但不限于：
|cffffffff
- Nachonut <Bronzebeard>
- Sloans <Bronzebeard>
- Stewarta <Emerald Dream>
|r

特别感谢以下 WIM 的本地化翻译者：
|cffffffff
- Bitz (韩国/朝鲜语)
- Corrilian (German)
- AlbertQ (Spanish)
- Annie <铜龙军团> (简体中文)
- Junxian (Traditional Chinese)
- Khellendros (French)
|r

在此还要感谢所有捐助过 ui.WorldOfWar.net 和 Curse-Gaming.com 的朋友。
]]


end
