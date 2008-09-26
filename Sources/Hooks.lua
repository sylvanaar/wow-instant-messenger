--[[
This file contains hooks which are required by WIM's core.
Module specific hooks are found within it's own files.
]]







-------------------------------------------------------------------------------------------
-- The following hooks will account for anything that is being inserted into default chat frame and
-- spoofs other callers into thinking that they are actually linking into the chat frame.
--DEFAULT_CHAT_FRAME.editBox

hooksecurefunc(ChatFrameEditBox, "Insert", function(self,theText)
				if(WIM.EditBoxInFocus) then
					WIM.EditBoxInFocus:Insert(theText);
				end
			end )


ChatFrameEditBox.wimIsVisible = ChatFrameEditBox.IsVisible;
ChatFrameEditBox.IsVisible = function(self)
				if(WIM.EditBoxInFocus) then
					return true;
				else
					return ChatFrameEditBox:wimIsVisible();
				end
			end
ChatFrameEditBox.wimIsShown = ChatFrameEditBox.IsShown;
ChatFrameEditBox.IsShown = function(self)
				if(WIM.EditBoxInFocus) then
					return true;
				else
					return ChatFrameEditBox:wimIsShown();
				end
			end

-- can not hook GetText() because it taints the chat bar. Breaks /tar
hooksecurefunc(ChatFrameEditBox, "SetText", function(self,theText)
				local firstChar = "";
				--if a slash command is being set, ignore it. Let WoW take control of it.
				if(string.len(theText) > 0) then firstChar = string.sub(theText, 1, 1); end
				if(WIM.EditBoxInFocus and firstChar ~= "/") then
					WIM.EditBoxInFocus:SetText(theText);
				end
			end );
ChatFrameEditBox.wimHighlightText = ChatFrameEditBox.HighlightText;
ChatFrameEditBox.HighlightText = function(self, theStart, theEnd)
				if(WIM.EditBoxInFocus) then
					WIM.EditBoxInFocus:HighlightText(theStart, theEnd);
				else
					ChatFrameEditBox:wimHighlightText(theStart, theEnd);
				end
			end

   
--hooksecurefunc("ToggleMinimap", WIM_ToggleMinimap);
--hooksecurefunc("UnitPopup_HideButtons", WIM_UnitPopup_HideButtons);
--hooksecurefunc("UnitPopup_OnClick", WIM_UnitPopup_OnClick);
-------------------------------------------------------------------------------------------




