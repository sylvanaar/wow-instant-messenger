--imports
local WIM = WIM;
local _G = _G;
local table = table;
local string = string;
local pairs = pairs;

--set namespace
setfenv(1, WIM);

local History = WIM.CreateModule("History", true);

-- default history settings.
db_defaults.history = {
    whispers = true,
    preview = true,
    previewCount = 25,
};
db_defaults.displayColors.historyIn = {
    r=0.4705882352941176,
    g=0.4705882352941176,
    b=0.4705882352941176
};
db_defaults.displayColors.historyOut = {
    r=0.7058823529411764,
    g=0.7058823529411764,
    b=0.7058823529411764
};

local dDay = 60*24;
local dWeek = dDay*7;
local dMonth = dWeek*4;
local dYear = dMonth*12;

local tmpTable = {};

local function clearTmpTable()
    for key, _ in pairs(tmpTable) do
        tmpTable[key] = nil;
    end
end

local function getPlayerHistoryTable()
    if(history[env.realm] and history[env.realm][env.character]) then
        return history[env.realm][env.character];
    else
        -- this player hasn't been set up yet. Do it now.
        history[env.realm] = history[env.realm] or {};
        history[env.realm][env.character] = history[env.realm][env.character] or {};
        return history[env.realm][env.character];
    end
end

local function createWidget()
    local button = _G.CreateFrame("Button");
    button.SetHistory = function(self, isHistory)
        self.isHistory = isHistory;
        if(isHistory and modules.History.enabled) then
            self:SetAlpha(1);
        else
            self:SetAlpha(0);
        end
    end
    button.UpdateProps = function(self)
        self:SetHistory(self.parentWindow.isHistory);
    end
    button:SetScript("OnEnter", function(self)
        if(db.showToolTips == true) then
            _G.GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
            _G.GameTooltip:SetText(L["Click to view message history."]);
        end
    end);
    button:SetScript("OnLeave", function(self)
        _G.GameTooltip:Hide();
    end);
    return button;
end


local function recordWhisper(inbound, ...)
    if(db.history.whispers) then
        local msg, from = ...;
        local win = windows.active.whisper[from] or windows.active.chat[from] or windows.active.w2w[from];
        if(win) then
            win.widgets.history:SetHistory(true);
            local history = getPlayerHistoryTable();
            table.insert(history, {
                convo = from,
                type = 1, -- whisper
                inbound = inbound or false,
                from = inbound and from or env.character,
                msg = msg,
                time = _G.time();
            });
        end
    end
end

function History:PostEvent_Whisper(...)
    recordWhisper(true, ...);
end

function History:PostEvent_WhisperInform(...)
    recordWhisper(false, ...);
end

function History:OnEnableWIM()
    -- clean up history if asked to.
end

function History:OnEnable()
    RegisterWidget("history", createWidget);
end

function History:OnDisable()
    for widget in Widgets("history") do
        widget:SetHistory(false); -- module is disabled, hide Icons.
    end
end

function History:OnWindowDestroyed(win)
    win.isHistory = nil;
end

function History:OnWindowCreated(win)
    if(db.history.preview) then
        local history = history[env.realm] and history[env.realm][env.character]
        if(history) then
            local type = win.type == "whisper" and 1;
            for i=#history, 1, -1 do
                if(history[i].convo == win.theUser and history[i].type == 1) then
                    table.insert(tmpTable, 1, history[i]);
                    if(#tmpTable >= db.history.previewCount) then
                        break;
                    end
                end
            end
            if(#tmpTable > 0) then
                win.isHistory = true;
                win.widgets.history:SetHistory(true);
            end
            for i=1, #tmpTable do
                local event = tmpTable[i].inbound and "CHAT_MSG_WHISPER" or "CHAT_MSG_WHISPER_INFORM";
                local color = db.displayColors[tmpTable[i].inbound and "historyIn" or "historyOut"];
                win.nextStamp = tmpTable[i].time;
                win.nextStampColor = db.displayColors.historyOut;
                win:AddMessage(applyMessageFormatting(win.widgets.chat_display, event, tmpTable[i].msg, tmpTable[i].from), color.r, color.g, color.b);
            end
            win.widgets.chat_display:AddMessage(" ");
            clearTmpTable();
        end
    end
end
