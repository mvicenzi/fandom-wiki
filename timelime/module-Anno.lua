-- Credits: User:Daeron_del_Doriath
-- This module is used by Template:Anno to display the existing 5 years
-- coming before and after the current year. This implementation avoids
-- using the native MediaWiki #ifexists function, which causes non-existing pages
-- to be reported as red links flooding maintenance categories.

local p = {}
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

-- This functions uses the DPL3 extension to fetch a sorted list of years
-- from the corresponding category, thus being self-maintaining and also
-- reflecting the current contents of the category. The order is based on
-- the category sort keys, which MUST correspond to chronological order.
local function get_list(frame, age)
	local dpl = {}
	if (age == "PE") then
		dpl = frame:preprocess("{{#dpl:category=Prima_Era|mode=inline|inlinetext=~|allowcachedresults=true|ordermethod=sortkey|skipthispage=no}}")
	elseif (age == "SE") then
		dpl = frame:preprocess("{{#dpl:category=Seconda_Era|mode=inline|inlinetext=~|allowcachedresults=true|ordermethod=sortkey|skipthispage=no}}")
	elseif (age == "TE") then
		dpl = frame:preprocess("{{#dpl:category=Terza_Era|mode=inline|inlinetext=~|allowcachedresults=true|ordermethod=sortkey|skipthispage=no}}")
	elseif (age == "QE") then
		dpl = frame:preprocess("{{#dpl:category=Quarta_Era|mode=inline|inlinetext=~|allowcachedresults=true|ordermethod=sortkey|skipthispage=no}}")
	elseif (age == "AA") then
		dpl = frame:preprocess("{{#dpl:category=Anni_degli_Alberi|mode=inline|inlinetext=~|allowcachedresults=true|ordermethod=sortkey|skipthispage=no}}")
	end
    local splitText = mw.text.split(dpl, '~', true)
    local result = {}
    for i, item in ipairs(splitText) do
    	local s = mw.text.split(item, ' ', true)
    	s = mw.text.split(s[2], "|", true)
    	result[i] = tonumber(s[1])
    end
    return result
end

-- This function finds the 5 previous/following years to be displayed, starting from
-- the parsed page title. The list of available years is fetched using DPL3
local function find_years(frame, age, year)

	local selected_years = get_list(frame, age)
	local prev = {}
	local succ = {}
	for index, yr in ipairs(selected_years) do
		if( yr == year) then
			for i=1,5 do
				if(selected_years[index-i]) then
				prev[i] = selected_years[index-i]
				end
				if( selected_years[index+i]) then
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

	local prev, succ = find_years(frame, age, year)
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
