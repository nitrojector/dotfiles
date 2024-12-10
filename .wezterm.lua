local wezterm = require "wezterm";
local mux = wezterm.mux;
local config = wezterm.config_builder()

--- Program
-- config.default_prog = { "/opt/homebrew/bin/tmux", "new", "-A", "-s", "takina"}
config.default_prog = { "/bin/zsh" }
config.default_cwd = "~/"

--- Appearance
-- Color scheme
-- config.color_scheme = "GruvboxDark"
config.color_scheme = 'Gruvbox dark, hard (base16)'

-- Font
config.font = wezterm.font_with_fallback {
	{ family ="JetBrainsMono Nerd Font", weight = "Regular" },
	{ family ="JetBrainsMono", weight = "Regular" },
	{ family ="Fira Code", weight = "Regular" },
	{ family ="monospace", weight = "Regular" },
	{ family ="sans-serif", weight = "Regular" },
}
config.font_size = 16.0

-- Window settings
config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"  -- Full decoration
-- config.window_decorations = "NONE"
config.window_background_opacity = 0.9
config.window_padding = {
	left = 8,
	right = 8,
	top = 0,
	bottom = 0,
}

--- Maximize window on startup
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window{}
	window:gui_window():maximize()
end)


config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.show_tabs_in_tab_bar = false

return config
