-- Works similarly to the Trunk Notes {{backlinks}} function, but also prints out
-- a header, and returns empty output if no backlinks are present. This is a bit of
-- syntactic sugar so you can use it in places like your Special:Footer page and it
-- won't include the "Backlinks" header if no backlinks are found.
--
-- Optionally accepts a parameter to specify the header text for the Backlinks
-- list (if output).

header_text = "Backlinks"
if args[1] then
  header_text = args[1]
end
link_list = wiki.exprl("backlinks", page.title)

result = ""
matches = 0

for i, page_name in ipairs(link_list) do
	result = result .. "- [[" .. page_name .. "]]\n"
	matches = matches + 1
end

if matches > 0 then
	result = "## " .. header_text .. "\n" .. result
end

return result\
