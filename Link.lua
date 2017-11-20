-- Automagically create a link with a title, so you dont have to type
-- [[PageCategory:PageName|Page Name]] over and over.

Updated Fri Nov 17, 2017 - 16:04 
-- Automagically create a link with a title, so you dont have to type
-- [[PageCategory:PageName|Page Name]] over and over.

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

link_target = page.title
if args[2] then
	page_title = args[2]
else
	page_title = args[1]
end

if link_target:match(":") then
	b = ""
	toks = link_target:split(":")
	for i, tag in ipairs(toks) do
		if i == 1 then
			b = toks[i]
		elseif i < #toks then
			b = b .. ":" .. toks[i]
		end
	end
	link_target = b
end

page_title = page_title:gsub("([%u]+)", " %1")
page_title = page_title:gsub("([%d]+)", " %1")
page_title = page_title:gsub("^%s*(.-)%s*$", "%1")


return "[[" .. link_target .. ":" .. args[1] .. "|" .. page_title .. "]]"
