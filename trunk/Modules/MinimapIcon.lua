local WIM = WIM;
local MinimapIcon = WIM:CreateModule("MinimapIcon", true);

MinimapIcon.db_defaults.minimap = {
    position = 200
};


local Notifications = {};	-- list of current notifications
local NotificationIndex = 1;	-- index for update messages
local Notification_Bowl = {};

local icon;

local function getNotificationTable(tag)
    local i;
    local emptyNote;
    for i=1, table.getn(Notification_Bowl) do
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
                note.index = table.getn(Notifications);
            end
        end
        icon.flash:Show();
    end
end

local function popNote(tag)
    local i, note;
    for i=1, table.getn(Notifications) do
        if(Notifications[i].tag == tag) then
            local note = Notifications[i];
            table.remove(Notifications, i);
            note.tag, note.color, note.text, note.desc, note.index = "", "", "", "", nil;
            return;
        end
    end
end



----------------------------------------------
--              Gradient Tools              --
----------------------------------------------
-- the following bits of code is a result of boredom
-- and determination to get it done. The gradient pattern
-- which I was aiming for could not be manipulated in RGB,
-- however by converting RGB to HSV, the pattern now becomes
-- linear and as such, can now be given any color and
-- have the same gradient effect applied.

local function RGBHextoHSVPerc(rgbStr)
    local R, G, B = string.sub(rgbStr, 1, 2), string.sub(rgbStr, 3, 4), string.sub(rgbStr, 5, 6);
    R, G, B = tonumber(R, 16)/255, tonumber(G, 16)/255, tonumber(B, 16)/255;
    local i, x, v, f;
    x = math.min(R, G);
    x = math.min(x, B);
    v = math.max(R, G);
    v = math.max(v, B);
    if(v == x) then
        return nil, 0, v;
    else
        if(R == x) then
            f = G - B;
        elseif(G == x) then
            f = B - R;
        else
            f = R - G;
        end
        if(R == x) then
            i = 3;
        elseif(G == x) then
            i = 5;
        else
            i = 1;
        end
        return ((i - f /(v - x))/6), (v - x)/v, v;
    end
end

local function HSVPerctoRGBPerc(H, S, V)
    local m, n, f, i;
    if(H == nil) then
        return V, V, V;
    else
        H = H * 6;
        if (H == 0) then
            H=.01;
        end
        i = math.floor(H);
        f = H - i;
        if((i % 2) == 0) then
            f = 1 - f; -- if i is even
        end
        m = V * (1 - S);
        n = V * (1 - S * f);
        if(i == 6 or i == 0) then
            return V, n, m;
        elseif(i == 1) then
            return n, V, m;
        elseif(i == 2) then
            return m, V, n;
        elseif(i == 3) then
            return m, n, V;
        elseif(i == 4) then
            return n, m, V;
        elseif(i == 5) then
            return V, m, n;
        else
            return 0, 0, 0;
        end
    end
end

-- pass rgb as signle arg hex, or triple arg rgb percent.
-- entering ! before a hex, will return a solid color.
local function getGradientFromColor(...)
    local h, s, v, s1, v1, s2, v2;
    if(select("#", ...) == 0) then
        return 0, 0, 0, 0, 0, 0;
    elseif(select("#", ...) == 1) then
        if(string.sub(select(1, ...),1, 1) == "!") then
            local rgbStr = string.sub(select(1, ...), 2, 7);
            local R, G, B = string.sub(rgbStr, 1, 2), string.sub(rgbStr, 3, 4), string.sub(rgbStr, 5, 6);
            return tonumber(R, 16)/255, tonumber(G, 16)/255, tonumber(B, 16)/255, tonumber(R, 16)/255, tonumber(G, 16)/255, tonumber(B, 16)/255;
        else
            h, s, v = RGBHextoHSVPerc(select(1, ...));
        end
    else
        h, s, v = RGBHextoHSVPerc(string.format ("%.2x%.2x%.2x",select(1, ...), select(2, ...), select(3, ...)));
    end

    s1 = math.min(1, s+.29/2);
    v1 = math.max(0, v-.57/2);
    s2 = math.max(0, s-.29/2);
    v2 = math.min(1, s+.57/2);
    
    local r1, g1, b1 = HSVPerctoRGBPerc(h, s1, v1);
    local r2, g2, b2 = HSVPerctoRGBPerc(h, s2, v2);
    
    return r1, g1, b1, r2, g2, b2;
end

----------------------------------------------
--          Minimap Icon Creation           --
----------------------------------------------

local function createMinimapIcon()
    local icon = CreateFrame('Button', 'WIM3MinimapButton', Minimap);
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
	ticon:SetTexture('Interface\\AddOns\\'..WIM.addonTocName..'\\Skins\\Default\\minimap');
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
			    this.timeElapsed = (this.timeElapsed or 0) + elapsed;
			    while(this.timeElapsed > 1) do
				local minimap = self:GetParent();
				if(NotificationIndex > table.getn(Notifications)) then
				    minimap.icon:Show();
				    minimap.backGround:SetGradient("VERTICAL", getGradientFromColor("!000000"));
				    minimap.text:Hide();
				    NotificationIndex = 0; -- will be incremented at end of loop
				else
				    minimap:SetText(Notifications[NotificationIndex].text);
				    minimap.backGround:SetGradient("VERTICAL", getGradientFromColor(Notifications[NotificationIndex].color));
				    minimap.text:Show();
				    minimap.icon:Hide();
				end
				this.timeElapsed = 0;
				NotificationIndex = NotificationIndex + 1
			    end
			    if(table.getn(Notifications) == 0) then
				NotificationIndex = 1;
				this.timeElapsed = 0;
				local minimap = self:GetParent();
				minimap.text:Hide();
				minimap.icon:Show();
				minimap.backGround:SetGradient("VERTICAL", getGradientFromColor("!000000"));
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
	GameTooltip:Hide();
    end
    icon.OnDragStop = function(self)
        self.dragging = nil;
	self:SetScript('OnUpdate', nil);
	self.icon:SetTexCoord(0.05, 0.95, 0.05, 0.95);
	self:UnlockHighlight();
    end
    icon.OnUpdate = function(self)
        local mx, my = Minimap:GetCenter();
	local px, py = GetCursorPosition();
	local scale = Minimap:GetEffectiveScale();

	px, py = px / scale, py / scale;

        WIM.db.minimap.position = math.deg(math.atan2(py - my, px - mx)) % 360;
	self:UpdatePosition();
    end
    icon.UpdatePosition = function(self)
        local angle = math.rad(WIM.db.minimap.position or random(0, 360));
	local cos = math.cos(angle);
	local sin = math.sin(angle);
	local minimapShape = GetMinimapShape and GetMinimapShape() or 'ROUND';

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
    WIM:dPrint("MinimapIcon Created...");
    return icon;
end


function MinimapIcon:OnEnableWIM()

end

function MinimapIcon:OnDisableWIM()

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
end

function MinimapIcon:OnDisable()
    if(icon) then
        icon:Hide();
    end
end




--------------------------------------
--      Global Extensions to WIM    --
--------------------------------------

function WIM:MinimapPushAlert(tag, color, numText, description)
    pushNote(tag, color, numText, description);
end

function WIM:MinimapPopAlert(tag)
    popNote(tag);
end

