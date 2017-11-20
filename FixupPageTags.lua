-- Add page tags to correspond with the current page namespaces.
--
-- If your page is named MyCategory:MyPage, this script will add "MyCategory" as a page tag.
-- If your page is named MyCategory:MySubcategory:MyPage, the tags added will be "MyCategory"
-- and "MyCategory:MySubcategory". If the name of the page contains no colons (ie, the page is not
-- part of a category) no tags will be added.
--
-- If you add a reference to it ({{lua FIxupPageTags.lua}}) to Special:Header or Special:Footer,
-- pages will be automagically tagged as you access them.

function string:split( inSplitPattern, outResults )
	if not outResults then
		outResults = { }
	end
	local theStart = 1

	local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	while theSplitStart do
		table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
		theStart = theSplitEnd + 1
		theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
	end
	table.insert( outResults, string.sub( self, theStart ) )
	return outResults
end

function page_has_tag(theTag)
	if #page.tags > 0 then
		for i, tag in ipairs(page.tags) do
			if tag == theTag then
				return true
			end
		end
	end
	return nil
end

the_page_name = page.title
part_count = 0
parts = the_page_name:split(":")

for i, v in ipairs(parts) do
 	part_count = part_count + 1
end

modify_count = 0
tag_buff = ""

for i, curr_tag in ipairs(parts) do
	if i < part_count then
		if i == 1 then
			tag_buff = curr_tag
			-- Bypass tagging system namespaces
			if curr_tag == "Special" then
				return 0
			elseif curr_tag == "Snippet" then
				return 0
			elseif curr_tag == "Docs" then
				return 0
			end
		else
			tag_buff = tag_buff .. ":" .. curr_tag
		end

		if page_has_tag(tag_buff) == nil then
			table.insert(page.tags, tag_buff)
			modify_count = modify_count + 1
		end
	end
end

if modify_count > 0 then
	wiki.save(page)
end
