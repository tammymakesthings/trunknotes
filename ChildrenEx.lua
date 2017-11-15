-- Works similar to the TrunkNotes {{children}} function, but skips Lua pages,
-- peages that start with "Special", and pages whose names end with ":Index".
-- Also, tries to pretty-print page names so SomeWikiWord becomes "Some
-- Wiki Word".
--
-- Usage:
-- 
-- {{lua ChildrenEx.lua,CategoryName}}
--
-- {{lua ChildrenEx.lua,CategoryName,Unsorted}}

search_for = args[1]
unsorted = args[2]

list_items = {}

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
		list_entry = "- [[" .. name .. "|" .. page_title .. "]]"
		table.insert(list_items, list_entry)
	end
end

if not unsorted then
	table.sort(list_items)
end

for i, item in ipairs(list_items) do
	the_output = the_output .. item .. "\n"
end

return the_output
