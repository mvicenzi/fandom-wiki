-- Credits: User:Daeron_del_Doriath
-- This module is used by Template:Anno to display the existing 5 years
-- coming before and after the current year. This implementation avoids
-- using the native MediaWiki #ifexists function, which causes non-existing pages
-- to be reported as red links flooding maintenance catgories.

-- The list of valid years is read from "Module:Anno/data" and must be maintained
-- manually: this can be done easily as years with canonical events are well
-- known and can be listed once and for all.
local p = {}
local years = mw.loadData("Module:Anno/data")

-------------------------------------------------------------------------------

-- This function parses the argument, which is assumed to be the title of the
-- page (e.g. "TE 2345"), and it splits it into age ("TE") and year ("2345")
local function parse_title(frame)
	local s = frame.args[1]
	local age = string.sub(s,1,2)
	local year = string.sub(s,4,-1)
	local t = { ["age"] = age, ["year"] = year }
	return t
end

-- This function finds the 5 previous/following years to be displayed, starting from
-- the parsed page title. Note: the dictionary is set up to avoid long loops to
-- find the starting year.
local function find_years(age, year)

	local selected_years = {}
	if (age == "TE") then selected_years = years.TE
	elseif ( age == "SE") then selected_years = years.SE
	elseif ( age == "PE") then selected_years = years.PE
	elseif ( age == "QE") then selected_years = years.QE
	elseif ( age == "AA") then selected_years = years.AA
	end

	local prev = {}
	local succ = {}
	for index, yr in ipairs(selected_years) do
		if( yr == year) then
			for i=1,5 do
				if(selected_years[index-i]) then
				prev[i] = selected_years[index-i]
				end
				if( selected_years[index+1]) then
				succ[i] = selected_years[index+i]
				end
			end
		end
	end

	-- inverting
	local size = table.getn(prev)
	local inprev = {}
	for i=#prev, 1, -1 do
		inprev[#inprev+1] = prev[i]
	end
	prev = inprev

	return prev, succ
end

-------------------------------------------------------------------------------

-- This is the main function: parse the title, find the list of years to display
-- and join strings together to display the correct list
function p.getTimeline(frame)

	local title = parse_title(frame)
	local age = title["age"]
	local year = tonumber(title["year"])

	local prev, succ = find_years(age, year)
	local sprev = table.getn(prev)
	local ssucc = table.getn(succ)

	local pre = table.concat(prev, "]] - [[" .. age .." ")
	if( sprev>0 ) then pre = "[[" .. age .. " " .. pre .. "]] - " end

	local suc = table.concat(succ, "]] - [[" .. age .." ")
	if( ssucc>0 ) then suc = " - [[" .. age .. " " .. suc .. "]]" end

	local curr = "[[" .. frame.args[1] .. "]]"

	return pre .. curr .. suc
end

return p
