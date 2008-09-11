local WIM = WIM;

-- imports
local _G = _G;
local CreateFrame = CreateFrame;
local math = math;
local table = table;
local pairs = pairs;
local string = string;

-- set namespace
setfenv(1, WIM);

local MinimapIcon = CreateModule("MinimapIcon", true);

db_defaults.minimap = {
    position = 200
};

local Notifications = {};	-- list of current notifications
local NotificationIndex = 1;	-- index for update messages
local Notification_Bowl = {};

local colorEnabled = "!000000";
local colorDisabled = "!c41f3b";
local IconColor = colorEnabled;
local icon;

local function getNotificationTable(tag)
    local i;
    local emptyNote;
    for i=1, #Notification_Bowl do
        if(Notification_Bowl[i].tag == "") then
            emptyNote = Notification_Bowl[i];
        end
        if(Notification_Bowl[i].tag == tag) then
            return Notification_Bowl[i];
        end
    end
    if(not emptyNote) then
        local note = {tag=tag};
        table.insert(Notification_Bowl, note);
        return note;
    else
        return emptyNote;
    end
end

local function pushNote(tag, color, num, desc)
    if(tag) then
        if(tag == "") then
            return;
        else
            local note = getNotificationTable(tag);
            note.color, note.text, note.desc = color, num, (desc or "");
            if(not note.index) then
                table.insert(Notifications, note);
                note.index = #Notifications;
            end
        end
        icon.flash:Show();
    end
end

local function popNote(tag)
    local i, note;
    for i=1, #Notifications do
        if(Notifications[i].tag == tag) then
            local note = Notifications[i];
            table.remove(Notifications, i);
            note.tag, note.color, note.text, note.desc, note.index = "", "", "", "", nil;
            return;
        end
    end
end

----------------------------------------------
--          Minimap Icon Creation           --
----------------------------------------------

local function createMinimapIcon()
    local icon = CreateFrame('Button', 'WIM3MinimapButton', _G.Minimap);
    icon.Load = function(self)
        self:SetFrameStrata('MEDIUM');
	self:SetWidth(31); self:SetHeight(31);
	self:SetFrameLevel(8);
	self:RegisterForClicks('AnyUp');
	self:RegisterForDrag('LeftButton');
	self:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight');

	local overlay = self:CreateTexture(nil, 'OVERLAY');
	overlay:SetWidth(53); overlay:SetHeight(53);
	overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder');
	overlay:SetPoint('TOPLEFT');

	local bg = self:CreateTexture(nil, 'BACKGROUND');
	bg:SetWidth(20); bg:SetHeight(20);
	bg:SetTexture('Interface\\CharacterFrame\\TempPortraitAlphaMask');
	bg:SetPoint("TOPLEFT", 6, -6)
	self.backGround = bg;

	local text = self:CreateFontString(nil, "BACKGROUND");
	text:SetFont("Fonts\\SKURRI.ttf", 16);
	text:SetAllPoints(bg);
	text:SetText("");
	self.text = text;

	local ticon = self:CreateTexture(nil, 'BORDER');
	ticon:SetWidth(20); ticon:SetHeight(20);
	ticon:SetTexture('Interface\\AddOns\\'..addonTocName..'\\Skins\\Default\\minimap');
	ticon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
	ticon:SetPoint("TOPLEFT", 6, -5)
	self.icon = ticon;

	local flash = CreateFrame("Frame", "WIM3MinimapButtonFlash", self);
	flash:SetFrameStrata('MEDIUM');
	flash:SetParent(self);
	flash:SetAllPoints(self);
	flash:Show();
	flash.texture = flash:CreateTexture(nil, "BORDER");
	flash.texture:SetTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight');
	flash.OnUpdate = function(self, elapsed)
			    self.timeElapsed = (self.timeElapsed or 0) + elapsed;
			    while(self.timeElapsed > 1) do
				local minimap = self:GetParent();
				if(NotificationIndex > #Notifications) then
				    minimap.icon:Show();
				    minimap.backGround:SetGradient("VERTICAL", getGradientFromColor(IconColor));
				    minimap.text:Hide();
				    NotificationIndex = 0; -- will be incremented at end of loop
				else
				    minimap:SetText(Notifications[NotificationIndex].text);
				    minimap.backGround:SetGradient("VERTICAL", getGradientFromColor(Notifications[NotificationIndex].color));
				    minimap.text:Show();
				    minimap.icon:Hide();
				end
				self.timeElapsed = 0;
				NotificationIndex = NotificationIndex + 1
			    end
			    if(#Notifications == 0) then
				NotificationIndex = 1;
				self.timeElapsed = 0;
				local minimap = self:GetParent();
				minimap.text:Hide();
				minimap.icon:Show();
				minimap.backGround:SetGradient("VERTICAL", getGradientFromColor(IconColor));
				flash:Hide();
			    end
			end
	flash:SetScript("OnUpdate", flash.OnUpdate);
        icon.flash = flash;


	self:SetScript('OnEnter', self.OnEnter);
	self:SetScript('OnLeave', self.OnLeave);
	self:SetScript('OnClick', self.OnClick);
	self:SetScript('OnDragStart', self.OnDragStart);
	self:SetScript('OnDragStop', self.OnDragStop);
	self:SetScript('OnMouseDown', self.OnMouseDown);
	self:SetScript('OnMouseUp', self.OnMouseUp);
    end
    icon.SetText = function(self, text)
	text = text or "";
	local font, _, _ = icon.text:GetFont();
	if(string.len(text) == 1) then
	    icon.text:SetFont(font, 16);
	elseif(string.len(text) == 2) then
	    icon.text:SetFont(font, 14);
	else
	    icon.text:SetFont(font, 12);
	end
	icon.text:SetText(text);
    end
    icon.OnClick = function(self, button)
    
    end
    icon.OnMouseDown = function(self)
        self.icon:SetTexCoord(0, 1, 0, 1);
    end
    icon.OnMouseUp = function(self)
        self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
    end
    icon.OnEnter = function(self)
        
    end
    icon.OnLeave = function(self)
        
    end
    icon.OnDragStart = function(self)
        self.dragging = true;
	self:LockHighlight();
	self.icon:SetTexCoord(0, 1, 0, 1);
	self:SetScript('OnUpdate', self.OnUpdate);
	_G.GameTooltip:Hide();
    end
    icon.OnDragStop = function(self)
        self.dragging = nil;
	self:SetScript('OnUpdate', nil);
	self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
	self:UnlockHighlight();
    end
    icon.OnUpdate = function(self)
        local mx, my = _G.Minimap:GetCenter();
	local px, py = _G.GetCursorPosition();
	local scale = _G.Minimap:GetEffectiveScale();

	px, py = px / scale, py / scale;

        db.minimap.position = math.deg(math.atan2(py - my, px - mx)) % 360;
	self:UpdatePosition();
    end
    icon.UpdatePosition = function(self)
        local angle = math.rad(db.minimap.position or random(0, 360));
	local cos = math.cos(angle);
	local sin = math.sin(angle);
	local minimapShape = _G.GetMinimapShape and _G.GetMinimapShape() or 'ROUND';

	local round = false;
	if minimapShape == 'ROUND' then
		round = true;
	elseif minimapShape == 'SQUARE' then
		round = false;
	elseif minimapShape == 'CORNER-TOPRIGHT' then
		round = not(cos < 0 or sin < 0);
	elseif minimapShape == 'CORNER-TOPLEFT' then
		round = not(cos > 0 or sin < 0);
	elseif minimapShape == 'CORNER-BOTTOMRIGHT' then
		round = not(cos < 0 or sin > 0);
	elseif minimapShape == 'CORNER-BOTTOMLEFT' then
		round = not(cos > 0 or sin > 0);
	elseif minimapShape == 'SIDE-LEFT' then
		round = cos <= 0;
	elseif minimapShape == 'SIDE-RIGHT' then
		round = cos >= 0;
	elseif minimapShape == 'SIDE-TOP' then
		round = sin <= 0;
	elseif minimapShape == 'SIDE-BOTTOM' then
		round = sin >= 0;
	elseif minimapShape == 'TRICORNER-TOPRIGHT' then
		round = not(cos < 0 and sin > 0);
	elseif minimapShape == 'TRICORNER-TOPLEFT' then
		round = not(cos > 0 and sin > 0);
	elseif minimapShape == 'TRICORNER-BOTTOMRIGHT' then
		round = not(cos < 0 and sin < 0);
	elseif minimapShape == 'TRICORNER-BOTTOMLEFT' then
		round = not(cos > 0 and sin < 0);
	end

	local x, y;
	if round then
		x = cos*80;
		y = sin*80;
	else
		x = math.max(-82, math.min(110*cos, 84));
		y = math.max(-86, math.min(110*sin, 82));
	end

	self:SetPoint('CENTER', x, y);
    end
    icon:Load();
    dPrint("MinimapIcon Created...");
    return icon;
end


function MinimapIcon:OnEnableWIM()
    IconColor = colorEnabled;
    if(WIM.MinimapIcon) then
        WIM.MinimapIcon.icon:SetAlpha(1);
        WIM.MinimapIcon.flash:Show();
    end
    dPrint("enable event received");
end

function MinimapIcon:OnDisableWIM()
    IconColor = colorDisabled;
    if(WIM.MinimapIcon) then
        WIM.MinimapIcon.icon:SetAlpha(.75);
        WIM.MinimapIcon.flash:Show();
    end
    dPrint("disable event received");
end

function MinimapIcon:OnEnable()
    if(icon) then
        -- display icon
        icon:Show();
        icon:UpdatePosition();
    else
        -- create icon
        icon = createMinimapIcon();
        MinimapIcon:OnEnable();
    end
    WIM.MinimapIcon = icon;
end

function MinimapIcon:OnDisable()
    if(icon) then
        icon:Hide();
    end
    WIM.MinimapIcon = nil;
end




--------------------------------------
--      Global Extensions to WIM    --
--------------------------------------

function MinimapPushAlert(tag, color, numText, description)
    pushNote(tag, color, numText, description);
end

function MinimapPopAlert(tag)
    popNote(tag);
end

