--[[

From https://gist.github.com/mflint/4137528

# Introduction

This is a script for handling lists of journal entries, and will display
them in two ways:

* short mode, on just one line. This contains the latest five entries,
plus a link to an 'All' page

* long mode, for use on the 'All' page. This shows all journal entries,
and up to five lines of their content.

The script relies on the journal entries all having consistent names
(starting with a given prefix) rather than tags.

# Usage

{{lua JournalList.lua, short}}

{{lua JournalList.lua, long}}

# Configurable stuff

* *journal_title_prefix* the title prefix for journal wiki entries
* *available_spaces_short_mode* is the number of things to
display in a row in short mode
* *lines_to_show_long_mode* number of lines of content to
show in long mode

# Future

* Change *available_spaces_short_mode* based on device type
and orientation. (If device orientation is ever available in the
*device* table)

--]]

-- the title prefix for all journal entries
journal_title_prefix = "Journal:"

-- number of items to show in 'short' mode (this includes
-- New, Today and All if necessary)
available_spaces_short_mode = 6

-- number of lines of content to show in 'long' view
lines_to_show_long_mode = 5

-- this is the value to return from the function
result = ""

-- short or long mode?
short = args[1] == "short"

-- for some reason, this & n b s p ; constant gets lost while
-- editing this code in the webbrower, unless it's split up. Hmm...
nbsp = "&nb" .. "sp;"

-- the title for today's journal entry. luckily, my preferred date
-- format can be sorted alphabetically to put journal entries in order
today_entry_title = os.date(journal_title_prefix .. "%Y-%m-%d")

-- if today's journal doesn't already exist, then need to add the
-- "New" entry, and reduce the remaining number of items to show
if not wiki.exists(today_entry_title) then
  if short then
    result = result .. "[[" .. today_entry_title .. "|New]]" .. nbsp .. nbsp .. nbsp
    available_spaces_short_mode = available_spaces_short_mode - 1
  else
    result = result .. "[[" .. today_entry_title .. "|New Journal Entry]]" .. "\n\n"
  end
end

-- find the titles of all the wiki entries
all_titles = wiki.titles()

-- now make an array containing just the journal wiki entries
previous_journal_entries = {}
for i=1,#all_titles do
  if string.sub(all_titles[i], 1, string.len(journal_title_prefix)) == journal_title_prefix then
    table.insert(previous_journal_entries, all_titles[i])
  end
end

-- sorting journal titles in reverse alphabetical order causes them
-- to be in reverse creation-time order, with the most recent first
table.sort(previous_journal_entries, function(a,b) return a>b end)

-- if we're in short mode, need to allow for the "All" item
if short then
  available_spaces_short_mode = available_spaces_short_mode - 1
end

-- in short mode, we limit the number of previous journal entries to show;
-- for long mode, we show them all. This is the number of items to show
limited_entries_to_show = short and math.min(# previous_journal_entries, available_spaces_short_mode) or # previous_journal_entries
for i=1,limited_entries_to_show do
  v = previous_journal_entries[i]
  entry = wiki.get(v)
  entry_display_name = os.date("%d-%b", entry.created)
  if entry.title == today_entry_title then
    entry_display_name = "Today"
  end

  if short then
    result = result .. "[[" .. entry.title .. "|" .. entry_display_name .. "]]" .. nbsp .. nbsp .. nbsp
  else
    result = result .. "[[" .. entry.title .. "|" .. entry_display_name .. "]]" .. "\n"

    -- split this entry contents into lines
    entry_lines = {}
    for line in string.gmatch(entry.contents, "[^\n\r]+") do
      table.insert(entry_lines, line)
    end

    -- and display them, up to the maximum
    for i=1, math.min(lines_to_show_long_mode, #entry_lines) do
      result = result .. entry_lines[i] .. "\n"
    end

    if # entry_lines > lines_to_show_long_mode then
      result = result .. "*More...*\n\n"
    else
      result = result .. "\n"
    end
  end
end

if short and limited_entries_to_show > 0 then
  result = result .. "[[JournalAll|**All**]]"
end

return result;
