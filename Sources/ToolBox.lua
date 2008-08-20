local WIM = WIM;

--------------------------------------
--          Table Functions         --
--------------------------------------


-- The following code was written by the AceTeam. My goal in WIM 3.0 is
-- to not depend on any external frameworks when dealing with the CORE
-- functionality of WIM. It is understood however that libraries which
-- may be imported with WIM will depend on such frameworks, however
-- WIM's core will be left independent.

    -- Simple shallow copy for copying defaults
    local function copyTable(src, dest)
    	if type(dest) ~= "table" then dest = {} end
    	if type(src) == "table" then
    		for k,v in pairs(src) do
    			if type(v) == "table" then
    				-- try to index the key first so that the metatable creates the defaults, if set, and use that table
    				v = copyTable(v, dest[k])
    			end
    			dest[k] = v
    		end
    	end
    	return dest
    end 
    
    -- Called to add defaults to a section of the database
    --
    -- When a ["*"] default section is indexed with a new key, a table is returned
    -- and set in the host table.  These tables must be cleaned up by removeDefaults
    -- in order to ensure we don't write empty default tables.
    local function copyDefaults(dest, src)
    	-- this happens if some value in the SV overwrites our default value with a non-table
	--if type(dest) ~= "table" then return end
	for k, v in pairs(src) do
		if k == "*" or k == "**" then
			if type(v) == "table" then
				-- This is a metatable used for table defaults
				local mt = {
					-- This handles the lookup and creation of new subtables
					__index = function(t,k)
							if k == nil then return nil end
							local tbl = {}
							copyDefaults(tbl, v)
							rawset(t, k, tbl)
							return tbl
						end,
				}
				setmetatable(dest, mt)
				-- handle already existing tables in the SV
				for dk, dv in pairs(dest) do
					if not rawget(src, dk) and type(dv) == "table" then
						copyDefaults(dv, v)
					end
				end
			else
				-- Values are not tables, so this is just a simple return
				local mt = {__index = function(t,k) return k~=nil and v or nil end}
				setmetatable(dest, mt)
			end
		elseif type(v) == "table" then
			if not rawget(dest, k) then rawset(dest, k, {}) end
			if type(dest[k]) == "table" then
				copyDefaults(dest[k], v)
				if src['**'] then
					copyDefaults(dest[k], src['**'])
				end
			end
		else
			if rawget(dest, k) == nil then
				rawset(dest, k, v)
			end
		end
	end
    end
    
WIM.copyTable = copyTable;




function WIM:FormatUserName(user)
	if(user ~= nil) then
		if(WIM:IsGM(user)) then
			if(WIM.lists.gm[user]) then
				return "<GM> "..user;
			else
				return user;
			end
		else
			user = string.gsub(user, "[A-Z]", string.lower);
			user = string.gsub(user, "^[a-z]", string.upper);
			user = string.gsub(user, "-[a-z]", string.upper); -- accomodate for cross server...
			if(WIM.windows.active["<GM> "..user]) then
				return "<GM> "..user;
			end
		end
	end
	return user;
end

-- a simple function to add an item to a table checking for duplicates.
-- this is ok, since the table is never too large to slow things down.
function WIM.addToTableUnique(tbl, item, prioritize)
    local i;
    for i=1,table.getn(tbl) do
        if(tbl[i] == item) then
            return;
        end
    end
    if(prioritize) then
        table.insert(tbl, 1, item);
    else
        table.insert(tbl, item);
    end
end

-- remove item from table. Return true if removed, false otherwise.
function WIM.removeFromTable(tbl, item)
    local i;
    for i=1,table.getn(tbl) do
        if(tbl[i] == item) then
            table.remove(tbl, i);
            return true;
        end
    end
    return false;
end

--------------------------------------
--      Debugging Functions         --
--------------------------------------
function WIM:dPrint(t)
    if self.debug then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000[WIM Debug]:|r "..t);
    end
end
