--imports
local WIM = WIM;
local _G = _G;
local pairs = pairs;


--set namespace
setfenv(1, WIM);


------------------------------------------
-- Module: OffScreenTracker (Experimental)
------------------------------------------


local Module = WIM.CreateModule("OffScreenTracker", true);






Module.canDisable = false;
Module:Enable();