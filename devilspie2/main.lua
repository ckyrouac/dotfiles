
x, y, width, height = get_window_client_geometry()
window_name = get_window_name()

debug_print("Window Name: " .. window_name);
debug_print("Window x position: " .. x)
debug_print("Window y position: " .. y)
debug_print("Window width: " .. width)
debug_print("Window height: " .. height)

if (window_name == "Terminal" or window_name == "urxvt256c-ml") then
  undecorate_window();
end
if (string.match(window_name, "GVIM")) then
  undecorate_window()
end
if (window_name == "terminal-dropdown") then
  undecorate_window()
end
if (string.match(window_name, "Firefox")) then
  undecorate_window()
end
if (string.match(window_name, "Google Chrome")) then
  undecorate_window()
end
