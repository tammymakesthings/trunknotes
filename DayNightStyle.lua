-- Include in Special:Header to change style based on time of day.

hour = tonumber(os.date('%H'))
if hour < 7 or hour > 20 then
    return "{{stylesheet SolarizedDark.css}}"
else
    return "{{stylesheet SolarizedLight.css}}"
end
