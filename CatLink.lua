-- Create an automagic link to a page in the same category as the current page.
--
-- This is an attempt to make using categories as a namespacing tool simpler in Trunk Notes.
--
-- Usage:
--
--      {{lua CatLink.lua,MyPageName}}
--
--      If used on the page Category:OtherPage, makes a link to Category:MyPageName
--      with the link title "My Page Name".
--
--
--      {{lua CatLink.lua,MyPageName,Some Other Page Title}}
--
--      If used on the page Category:OtherPage, makes a link to Category:MyPageName
--      with the link title "Some Other Page Title".
--
-- Use in conjunction with Snippet:CatName to simplify creating these links.

the_page = args[1]

page_name = the_page

page_title = ""

if args[2] then
	page_title = args[2]
else
	page_title = the_page
	page_title = page_title:gsub("([%u]+)", " %1")
	page_title = page_title:gsub("([%d]+)", " %1")
	page_title = page_title:gsub("^%s*(.-)%s*$", "%1")
end

if (page_name:match(":")) then
	-- Do nothing
else
	page_name = page_name .. ":Index"
end

if wiki.exists(page_name) then
	return "[[" .. page_name .. "|" .. page_title .. "]]"
else
	return "[[" .. args[1] .. "]]"
end
