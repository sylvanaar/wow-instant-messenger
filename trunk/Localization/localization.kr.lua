  ------------------------------
  -- Korean text (R4) by Bitz --
  ------------------------------

if (GetLocale() == "koKR") then

	-- Global Strings --
		WIM_LOCALIZED_YES 							= "예";
		WIM_LOCALIZED_NO 							= "아니오";
		WIM_LOCALIZED_NONE 							= "없음";
		WIM_LOCALIZED_RIGHT_CLICK					= "오른쪽 클릭";
		WIM_LOCALIZED_LEFT_CLICK					= "왼쪽 클릭";
		WIM_LOCALIZED_OK							= "확인";
		WIM_LOCALIZED_CANCEL						= "취소";
		WIM_LOCALIZED_UNKNOWN						= "알 수 없음";
		WIM_LOCALIZED_CLICK_TO_UPDATE				= "클릭 - 위치 정보 갱신";
		
		WIM_LOCALIZED_NEW_VERSION					= "WIM의 새 버전이 확인되었습니다!\n다음 사이트에서 최신 버전을 다운받을 수 있습니다 :\n\n http://www.wimaddon.com";

	-- Strings From WIM.xml & WIM.lua --
		WIM_LOCALIZED_PURGED_HISTORY 				= "저장된 대화 내용에서 오래된 {n}개의 메시지를 삭제했습니다.";
		WIM_LOCALIZED_RECENT_CONVO_COUNT 			= "최근 대화 ({n1}/{n2})";
		WIM_LOCALIZED_NEW_MESSAGE 					= "새로운 메시지가 도착했습니다!";
		WIM_LOCALIZED_NO_NEW_MESSAGES 				= "새로운 메시지가 없습니다.";
		WIM_LOCALIZED_CONVO_CLOSED 					= "대화가 종료되었습니다.";
		WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE 	= "대화를 끝내시려면 쉬프트 & 왼쪽 클릭을 하십시오.";
		WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY 			= "저장된 대화 내용을 보시려면 클릭하십시오.";
		WIM_LOCALIZED_IGNORE_CONFIRM 				= "이 대화 상대를 정말 차단하시겠습니까?";
		WIM_LOCALIZED_AFK                           = "자리 비움";
		WIM_LOCALIZED_DND                           = "다른 용무 중";

	-- Shortcut Bar --
		WIM_LOCALIZED_TRADE 						= "거래";
		WIM_LOCALIZED_INVITE 						= "초대";
		WIM_LOCALIZED_TARGET 						= "대상";
		WIM_LOCALIZED_INSPECT 						= "살펴보기";
		WIM_LOCALIZED_IGNORE 						= "차단";
		WIM_LOCALIZED_FRIEND 						= "친구 추가";
		WIM_LOCALIZED_LOCATION						= "플레이어 위치";

	-- Keybindings --
		BINDING_HEADER_WIMMOD 						= "WIM (인스턴트 메신저)";
		BINDING_NAME_WIMSHOWNEW 					= "새 메시지 보기";
		BINDING_NAME_WIMHISTORY 					= "대화 내용 기록창 열기/닫기";
		BINDING_NAME_WIMENABLE 						= "사용/사용안함";
		BINDING_NAME_WIMTOGGLE 						= "메시지 열기/닫기";
		BINDING_NAME_WIMSHOWALL 					= "모든 메시지 보기";
		BINDING_NAME_WIMHIDEALL 					= "모든 메시지 숨기기";

	-- History Window --
		WIM_LOCALIZED_HISTORY_NO_FILTER				= "모두 보기";
		WIM_LOCALIZED_HISTORY_TITLE					= "WIM 대화 내용 기록창";
		WIM_LOCALIZED_HISTORY_USERS 				= "대화 상대";
		WIM_LOCALIZED_HISTORY_FILTERS 				= "날짜 (월/일/년)";
		WIM_LOCALIZED_HISTORY_MESSAGES 				= "메시지";
		
	-- MiniMap Icon --
		WIM_LOCALIZED_ICON_CONVO_MENU				= "대화 상대 보기";
		WIM_LOCALIZED_ICON_SHOW_NEW					= "새 메시지 보기";
		WIM_LOCALIZED_ICON_OPTIONS					= "WIM 설정";
		WIM_LOCALIZED_CONVERSATIONS					= "대화 상대";
		WIM_LOCALIZED_ICON_WIM_TOOLS				= "WIM 도구";
	
	-- Options Window --
		WIM_LOCALIZED_OPTIONS_TITLE 				= "WIM 설정";
		WIM_LOCALIZED_OPTIONS_ICON_POSISTION 		= "아이콘 위치";
		WIM_LOCALIZED_OPTIONS_FONT_SIZE 			= "글자 크기";
		WIM_LOCALIZED_OPTIONS_WINDOW_SCALE 			= "창 크기 (백분율)";
		WIM_LOCALIZED_OPTIONS_WINDOW_ALPHA 			= "투명도 (백분율)";
		WIM_LOCALIZED_OPTIONS_WINDOW_WIDTH 			= "창 넓이";
		WIM_LOCALIZED_OPTIONS_WINDOW_HEIGHT 		= "창 높이";
		WIM_LOCALIZED_OPTIONS_LIMITED_HEIGHT 		= "(단축바에 따른 높이 제약이 있습니다)";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME 	= "오류: 이름이 정확하지 않습니다.!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_NAME2 	= "오류: 이미 사용 중인 이름입니다!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_ALIAS 	= "오류: 별명이 정확하지 않습니다!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER  = "오류: 키워드/어구가 정확하지 않습니다!";
		WIM_LOCALIZED_OPTIONS_ERROR_INVALID_FILTER2 = "오류: 이미 사용 중인 키워드/어구입니다!";
		WIM_LOCALIZED_OPTIONS_DAY 					= "하루";
		WIM_LOCALIZED_OPTIONS_WEEK 					= "일주일";
		WIM_LOCALIZED_OPTIONS_MONTH 				= "한 달";
		WIM_LOCALIZED_OPTIONS_TOOLTIP_MSG_SPAWN     = "드래그해서 대화창이 생성될 \n기본 위치를 정하십시오.";
		WIM_LOCALIZED_OPTIONS_UP 					= "위";
		WIM_LOCALIZED_OPTIONS_DOWN 					= "아래";
		WIM_LOCALIZED_OPTIONS_LEFT 					= "왼쪽";
		WIM_LOCALIZED_OPTIONS_RIGHT 				= "오른쪽";
		WIM_LOCALIZED_OPTIONS_FILTER_IGNORE 		= "무시";
		WIM_LOCALIZED_OPTIONS_FILTER_BLOCK 			= "차단";
		WIM_LOCALIZED_OPTIONS_ENABLE_WIM 			= "WIM 사용";
		
		WIM_LOCALIZED_OPTIONS_TIMEOUT_FRIENDS		= "친구와의 대화창 자동 종료 :";
		WIM_LOCALIZED_OPTIONS_TIMEOUT_OTHER			= "친구 이외의 대화창 자동 종료 :";
		
		WIM_LOCALIZED_OPTIONS_DISPLAY_TITLE 		= "대화창 설정";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_IN 		= "받는 귓속말";
		WIM_LOCALIZED_OPTIONS_DISPLAY_WISP_OUT 		= "보내는 귓속말";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SYSTEM 		= "시스템 메시지";
		WIM_LOCALIZED_OPTIONS_DISPLAY_ERROR 		= "오류 메시지";
		WIM_LOCALIZED_OPTIONS_DISPLAY_URL 			= "웹 주소 링크";
		WIM_LOCALIZED_OPTIONS_DISPLAY_SHORTCUTBAR	= "단축바 표시";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_SCB 	= "이 설정은 대화창의 최대 높이에 제한을 줍니다.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TIMESTAMPS 	= "대화 시간 표시";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO		 	= "케릭터 정보 표시";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTIP_CINFO = "새 메시지 대화창에만 적용됩니다.\n|cffffffff(/누구 명령으로 정보를 가져오기 때문)|r";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_CLASS 	= "직업 아이콘";
		WIM_LOCALIZED_OPTIONS_DISPLAY_TOOLTOP_NEW	= "새 메시지 대화창에만 적용됩니다.";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_COLOR 	= "직업 색상";
		WIM_LOCALIZED_OPTIONS_DISPLAY_CINFO_DETAILS = "케릭터 세부 정보";
		
		WIM_LOCALIZED_OPTIONS_MINIMAP_TITLE 		= "미니맵 아이콘";
		WIM_LOCALIZED_OPTIONS_MINIMAP_ENABLE 		= "미니맵 아이콘 표시";
		WIM_LOCALIZED_OPTIONS_MINIMAP_FREEMOVING 	= "사용자 이동";
		WIM_LOCALIZED_OPTIONS_MINIMAP_TOOLTIP_FM	= "쉬프트 & 왼쪽 클릭 후 드래그해서 \n미니맵 아이콘을 이동할 수 있습니다.";
		
		WIM_LOCALIZED_OPTIONS_TAB_GENERAL 			= " 일반 ";				-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_WINDOWS 			= " 대화창 ";			-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_FILTERS 			= " 필터 ";				-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_HISTORY 			= " 대화 내용 기록 ";	-- notice space buffering
		WIM_LOCALIZED_OPTIONS_TAB_PLUGINS 			= " 플러그인 ";	-- notice space buffering
		
		WIM_LOCALIZED_OPTIONS_GENERAL_AUTO_FOCUS 	= "대화창 팝업 시 자동으로 커서를 입력창에 위치";
		WIM_LOCALIZED_OPTIONS_GENERAL_KEEP_FOCUS 	= "메시지 전송 후 입력창에 커서 유지";
		WIM_LOCALIZED_OPTIONS_GENERAL_FOCUS_RESTED 	= "주요 도시에 있을 때만";
		WIM_LOCALIZED_OPTIONS_GENERAL_SHOW_TOOLTIPS = "툴팁 표시";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_SEND 		= "귓속말을 보낼 때 대화창 팝업";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_IN 		= "새 귓속말을 받을 때 대화창 팝업";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_REPLY 	= "답변을 받을 때 대화창 팝업";
		WIM_LOCALIZED_OPTIONS_GENERAL_POP_COMBAT 	= "전투 시 대화창 팝업 중지";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS 		= "기본 대화창에 귓속말 표시하지 않음";
		WIM_LOCALIZED_OPTIONS_GENERAL_SOUND_IN 		= "메시지 도착 시 효과음 재생";
		WIM_LOCALIZED_OPTIONS_GENERAL_SORT_ALPHA 	= "대화 목록을 가나다순으로 정렬";
		WIM_LOCALIZED_OPTIONS_GENERAL_AFK_DND 		= "자리 비움, 다른 용무 중 메시지 표시";
		WIM_LOCALIZED_OPTIONS_GENERAL_ESCAPE 		= "ESC 키로 대화창 종료";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_ESC	= "ESC 키 사용에는 제약이 따를 수 있습니다. |cffffffff예: 지도를 열어 두고 ESC 키 사용 시 대화창도 함께 종료됩니다.|r";
		WIM_LOCALIZED_OPTIONS_GENERAL_INTERCEPT 	= "귓속말 슬래시 명령어 사용 시 대화창 팝업";
		WIM_LOCALIZED_OPTIONS_GENERAL_TOOLTIP_INTCP = "귓속말 슬래시 명령어를 가로채어 새 메시지 대화창을 자동으로 엽니다. \n(예: /w or /귓속말).";
		WIM_LOCALIZED_OPTIONS_GENERAL_IGNOREARROW	= "메시지 입력 시 방향키 무시.";
		WIM_LOCALIZED_OPTIONS_GENERAL_MENURCLICK	= "'WIM 도구' 미니맵에 표시 <오른쪽 클릭>.";
		WIM_LOCALIZED_OPTIONS_GENERAL_SUPRESS_COMBAT= "전투시 제외";
		
		WIM_LOCALIZED_OPTIONS_WINDOWS_CASCADE_DIR 	= "대화창 계단식 배열 사용     방향 :";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SET_LOCATION 	= "위치 설정";
		WIM_LOCALIZED_OPTIONS_WINDOWS_MODE_WIN		= "다중 창 방식";
		WIM_LOCALIZED_OPTIONS_WINDOWS_MODE_TAB		= "탭 방식";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT					= "탭 정렬 방식 :";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT1					= "메시지 받은 순";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT2					= "가나다순";
		WIM_LOCALIZED_OPTIONS_WINDOWS_SORT3					= "최근 대화 순";
		WIM_LOCALIZED_OPTIONS_WINDOWS_ONTOP					= "대화창을 항상 위에 표시";
		
		WIM_LOCALIZED_OPTIONS_FILTERS_ENABLE 		= "별명 사용";
		WIM_LOCALIZED_OPTIONS_FILTERS_COMMENT 		= "덧붙임 형태로 표시";
		WIM_LOCALIZED_OPTIONS_FILTERS_NAME 			= "이름";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS 		= "별명";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_ADD 	= "새 별명 추가";
		WIM_LOCALIZED_OPTIONS_FILTERS_ADD			= "추가";
		WIM_LOCALIZED_OPTIONS_FILTERS_REMOVE 		= "삭제";
		WIM_LOCALIZED_OPTIONS_FILTERS_EDIT 			= "편집";
		WIM_LOCALIZED_OPTIONS_FILTERS_ALIAS_EDIT 	= "별명 편집";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ENABLE = "필터링 사용";
		WIM_LOCALIZED_OPTIONS_FILTERS_KEY_PHRASE 	= "키워드/어구";
		WIM_LOCALIZED_OPTIONS_FILTERS_ACTION 		= "동작";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_ADD 	= "새 필터 추가";
		WIM_LOCALIZED_OPTIONS_FILTERS_FILTER_EDIT 	= "필터 편집";
		
		WIM_LOCALIZED_OPTIONS_HISTORY_ENABLE 		= "대화 내용 기록 사용";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_ALL 	= "모든 대화 내용 기록";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_FRIENDS= "친구 대화 내용 기록";
		WIM_LOCALIZED_OPTIONS_HISTORY_RECORD_GUILD 	= "길드원 대화 내용 기록";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_IN 	= "받는 메시지";
		WIM_LOCALIZED_OPTIONS_HISTORY_MESSAGES_OUT 	= "보내는 메시지";
		WIM_LOCALIZED_OPTIONS_HISTORY_SHOW 			= "대화창에 표시할 이전 메시지 수 :";
		WIM_LOCALIZED_OPTIONS_HISTORY_MAX 			= "개인마다 저장할 대화의 최대 메시지 수 :";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE 		= "기록된 대화 내용을 삭제할 단위 일수 :";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_USERS 	= "저장된 대화 상대";
		WIM_LOCALIZED_OPTIONS_HISTORY_TAB_MESSAGES 	= "저장된 메시지";
		WIM_LOCALIZED_OPTIONS_HISTORY_DELETE_USER 	= "대화 상대 삭제";
		WIM_LOCALIZED_OPTIONS_HISTORY_VIEW_USER 	= "대화 내용 보기";
		
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPLUGIN	 		= "현재 실행 중인 플러그인이 없습니다.";
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPLUGIN_EX		= "설치되어 있는 플러그인이 없습니다.\n\n플러그인은 다음 주소의 사이트에서 다운 받을 수 있습니다 :\nhttp://www.WIMAddon.com";
		WIM_LOCALIZED_OPTIONS_PLUGINS_NOPTIONS			= "이 플러그인은 사용 가능한 설정이 없습니다.";
		WIM_LOCALIZED_OPTIONS_PLUGININFO						= "플러그인 정보";
		
	-- Alias Window --
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL1 			= "케릭터 이름";
		WIM_LOCALIZED_ALIAS_WINDOW_LABEL2 			= "케릭터 별명";
	
	-- Filter Window --
		WIM_LOCALIZED_FILTER_WINDOW_LABEL1 			= "필터링할 키워드 또는 어구";
		WIM_LOCALIZED_FILTER_WINDOW_LABEL2 			= "필터링 설정에 의해 수행할 동작 :";
		
		WIM_LOCALIZED_FILTER_1  					= "당신을 보고 있습니다";
		WIM_LOCALIZED_FILTER_2 						= "당신을 지켜보고 있습니다";
		WIM_LOCALIZED_FILTER_3						= "당신에게 표범 공격을 가해옵니다";
		WIM_LOCALIZED_FILTER_4						= "당신은 표적입니다";
		WIM_LOCALIZED_FILTER_5						= "당신은 역병에 걸렸습니다";
		WIM_LOCALIZED_FILTER_6 						= "당신은 저주에 걸렸습니다";
		WIM_LOCALIZED_FILTER_7						= "당신은 폭탄입니다";
		WIM_LOCALIZED_FILTER_8  					= "당신은 불타는 아드레날린에 걸렸습니다";
		WIM_LOCALIZED_FILTER_9						= "당신은 에본로크의 그림자에 걸렸습니다";
	
	-- Help Window --
		WIM_LOCALIZED_HELP_WINDOW_TITLE 			= "WIM 도움말";
		WIM_LOCALIZED_HELP_WINDOW_DESCRIPTION 	  	= " 설명 ";				-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_VERSION_HISTORY 	= " 버전 정보 ";		-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_DID_YOU_KNOW 		= " 알고계십니까? ";	-- notice space buffering
		WIM_LOCALIZED_HELP_WINDOW_CREDITS 			= " 감사의 글 ";			-- notice space buffering
	
	-- Titan Panel Plugin --
		WIM_LOCALIZED_TITAN_MESSAGES  				= "메시지: ";
	
	-- URL Copy --
		WIM_LOCALIZED_URLCOPY_TITLE					= "URL 복사";
	
	-- Class Names
		WIM_LOCALIZED_DRUID 						= "드루이드";
		WIM_LOCALIZED_HUNTER 						= "사냥꾼";
		WIM_LOCALIZED_MAGE 							= "마법사";
		WIM_LOCALIZED_PALADIN 						= "성기사";
		WIM_LOCALIZED_PRIEST 						= "사제";
		WIM_LOCALIZED_ROGUE 						= "도적";
		WIM_LOCALIZED_SHAMAN 						= "주술사";
		WIM_LOCALIZED_WARLOCK 						= "흑마법사";
		WIM_LOCALIZED_WARRIOR 						= "전사";
		WIM_LOCALIZED_GM									= "GM";
		
	-- Help Window Tabs --
WIM_DESCRIPTION = [[
WIM (WoW Instant Messenger)
|cffffffff
WIM은 이름 그대로 게임에서 귓속말을 주고 받기 위한 인스턴트 메신저입니다. 특히 공격대에 속해 있는 경우처럼 바쁜 용무 중에는 방해가 되지 않도록 디자인되었으며 또한 각각의 대화 상대와 대화를 나눌수 있는 개별 대화창을 제공하여 편리성을 극대화하였습니다.

단축키 설정창도 한번 확인해 보시고 WIM으로 할 수 있는 것이 무엇인지도 살펴보시기 바랍니다.
|r


유용한 슬래시 명령어 :

/wim			|cffffffff- 설정창|r
/wim history	|cffffffff- 대화 내용 기록창|r
/wim help		|cffffffff- (도움말)|r

기타 슬래시 명령어 :

/wim reset			|cffffffff- 모든 설정값을 초기화합니다.|r
/wim reset filters	|cffffffff- 필터 내용을 초기화합니다.|r
/wim clear history	|cffffffff- 기록된 대화 대용을 삭제합니다.|r



통합 애드온 :|cffffffff

TitanPanel
Fubar 2.0|r 

호환 애드온 :|cffffffff

AllInOneInventory
EngInventory
SuperInspect
AtlasLoot
LootLink|r
]]

WIM_DIDYOUKNOW = [[
1.|cffffffff 슬래시 명령어|r /wim |cffffffff으로 WIM 대화창의 모양과 기능을 설정할 수 있는 설정창을 열 수 있습니다.|r

2.|cffffffff 타이탄 패널의 플러그인으로 사용가능합니다. 타이탄 플러그인 메뉴를 살펴보시기 바랍니다!|r

3.|cffffffff "주메뉴"의 "단축키 설정"으로 가면 WIM에 쓰이는 몇가지 유용한 단축키를 설정할 수 있습니다.|r

4.|cffffffff 미니맵 아이콘을 자유롭게 이동할 수 있습니다. 설정창에서 사용자 이동에 체크하면 쉬프트 & 왼쪽 클릭 후에 미니맵 아이콘을 드래그하면 원하는 어느 곳이든 이동할 수 있습니다.|r

5.|cffffffff 탭 키로 다른 메시지 창으로 전환이 가능합니다.|r

6.|cffffffff 이미 있는 기능을 넣어 달라는 요청을 매일같이 받고 있습니다. 업데이트가 되면 변경된 내용이 무엇이 있는지 확인해주시면 감사하겠습니다. 특히 처음 사용하시는 분들! :-)|r

7.|cffffffff 투표에 참여도 해주시고 댓글도 남겨주시면 감사하겠습니다. 그러면... 저는 :-) 하답니다.|r

8.|cffffffff 찰자가 잘못된 곳이 있을 수 있습니다. 알려주시면 감사하겠습니다.|r

9.|cffffffff 일반 설정 탭에는 스크롤 바가 있습니다. 확인해 보시기 바랍니다. 몰랐던 설정 기능이 있을 수 있습니다!|r
]]

WIM_CREDITS = [[
WIM (WoW Instant Messenger) 제작자: Pazza <브론즈비어드>. 
|cffffffff최초 컨셉과 아이디어는 Sloans <브론즈비어드>님의 의견이었습니다.|r

테스트에 도움 주신 모든 분들과 여러가지 제안과 피드백을 해주신 아래 두분에게 감사드립니다 :
|cffffffff
- Nachonut <브론즈비어드>
- Sloans <브론즈비어드>
- Stewarta <Emerald Dream>
|r

번역에 도움을 주신 분들에게 특히 감사의 말을 전합니다 :
|cffffffff
- Bitz (한국어)
- Corrilian (독일어)
- AlbertQ (스페인어)
- Annie (중국어 - 간체자)
- Junxian (중국어 - 번체자)
- Khellendros (프랑스어)
|r

또한 "ui.WorldOfWar.net"과 "Curse-Gaming.com"을 위해 기여해 주시고 계시는 모든 분들에게도 감사드립니다.
]]

end
