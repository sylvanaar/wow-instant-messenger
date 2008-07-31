function WIM:isLinkTypeURL(link)
	if (strsub(link, 1, 7) == "wim_url") then
		return true;
	else
		return false;
	end
end

function WIM:DisplayURL(link)
	local theLink = "";
	if (string.len(link) > 4) and (string.sub(link,1,8) == "wim_url:") then
		theLink = string.sub(link,9, string.len(link));
	end

	-- The following code was written by Sylvannar.
        StaticPopupDialogs["WIM_SHOW_URL"] = {
  			text = "URL : %s",
 				button2 = TEXT(ACCEPT),
  			hasEditBox = 1,
  			hasWideEditBox = 1,
  			showAlert = 1, -- HACK : it"s the only way I found to make de StaticPopup have sufficient width to show WideEditBox :(
                        OnShow = function()
                                local editBox = getglobal(this:GetName().."WideEditBox");
                                editBox:SetText(format(theLink));
                                editBox:SetFocus();
                                editBox:HighlightText(0);

                                local button = getglobal(this:GetName().."Button2");
                                button:ClearAllPoints();
                                button:SetWidth(200);
                                button:SetPoint("CENTER", editBox, "CENTER", 0, -30);

                                getglobal(this:GetName().."AlertIcon"):Hide();  -- HACK : we hide the false AlertIcon
                        end,
                        OnHide = function() end,
                        OnAccept = function() end,
                        OnCancel = function() end,
                        EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
                        timeout = 0,
                        whileDead = 1,
                        hideOnEscape = 1
	};
	StaticPopup_Show ("WIM_SHOW_URL", theLink);
end