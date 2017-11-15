-- Include in Special:Header to switch stylesheets for day/night.
--
-- This script assumes the Wiki contains pages named [prefix]Dark.css and
-- [prefix]Light.css. The prefix is assumed to be "Solarized" unless another prefix
-- is specified as the first argument to the script.
--
-- Daytime mode runs from 7am until 8pm by default. This can be overridden by
-- passing the start and end hours of daytime mode (on a 24-hour clock) as the
-- second and third arguments to the script.

stylesheet_prefix = "Solarized"
day_start_hour = 7
day_end_hour = 20

if args[1] then
	stylesheet_prefix = args[1]
end
if args[2] then
	day_start_hour = tonumber(args[2])
end
if args[3] then
	day_end_hour = tonumber(args[3])
end

hour = tonumber(os.date('%H'))
if hour < day_start_hour or hour > day_end_hour then
    return "{{stylesheet " .. stylesheet_prefix .. "Dark.css}}"
else
    return "{{stylesheet " .. stylesheet_prefix .. "Light.css}}"
end
