-- Works similar to the TrunkNotes {{children}} function, but skips Lua pages,
-- peages that start with "Special", and pages whose names end with ":Index".
-- Also, tries to pretty-print page names so SomeWikiWord becomes "Some
-- Wiki Word".
--
-- Usage:
-- 
-- {{lua ChildrenEx.lua,CategoryName}}

search_for = args[1]

a = wiki.search(search_for .. ":")
the_output = ""
for i, name in pairs(a) do
	if name:find("Special:") then
		-- Skip special pages
	elseif name:find(".lua") then
		-- Skip Lua pages
	elseif name:match(":[Ii]ndex$") then
		-- Skip index page
	else
		page_title = name:gsub(args[1] .. ":", "")
		page_title = page_title:gsub("([%u]+)", " %1")
		page_title = page_title:gsub("([%d]+)", " %1")
		page_title = page_title:gsub("^%s*(.-)%s*$", "%1")
		the_output = the_output .. "- [[" .. name .. "|" .. page_title .. "]]\n"
	end
end
return the_output
