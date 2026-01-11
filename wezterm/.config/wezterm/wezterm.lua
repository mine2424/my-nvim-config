-- ========================================
-- WezTerm Configuration
-- ========================================
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ========================================
-- OS Detection
-- ========================================

local os = (function()
	if string.find(wezterm.target_triple, "apple") then
		return "macOS"
	elseif string.find(wezterm.target_triple, "windows") then
		return "windows"
	elseif string.find(wezterm.target_triple, "linux") then
		return "linux"
	end
end)()

-- ========================================
-- General Settings
-- ========================================

-- Performance
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120
config.animation_fps = 120
config.prefer_egl = true

-- Scrollback
config.scrollback_lines = 10000

-- Suppress font warnings (フォントが見つからない場合の警告を抑制)
config.warn_about_missing_glyphs = false

-- Window
config.adjust_window_size_when_changing_font_size = false
config.integrated_title_button_style = "Windows"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = "0cell",
}
config.win32_system_backdrop = "Acrylic" -- Windows用

-- ========================================
-- Cursor
-- ========================================

config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.force_reverse_video_cursor = true

-- ========================================
-- Color Theme System (Gist style)
-- ========================================

local color_default_fg_light = wezterm.color.parse("#cacaca")
local color_default_fg_dark = wezterm.color.parse("#303030")

local COLOR = {
	VERIDIAN = {
		bg = wezterm.color.parse("#4D8060"),
		fg = color_default_fg_light,
	},
	PAYNE = {
		bg = wezterm.color.parse("#385F71"),
		fg = color_default_fg_light,
	},
	INDIGO = {
		bg = wezterm.color.parse("#7C77B9"),
		fg = color_default_fg_light,
	},
	CAROLINA = {
		bg = wezterm.color.parse("#8FBFE0"),
		fg = color_default_fg_dark,
	},
	FLAME = {
		bg = wezterm.color.parse("#D36135"),
		fg = color_default_fg_dark,
	},
	JET = {
		bg = wezterm.color.parse("#282B28"),
		fg = color_default_fg_light,
	},
	TAUPE = {
		bg = wezterm.color.parse("#785964"),
		fg = color_default_fg_light,
	},
	ECRU = {
		bg = wezterm.color.parse("#C6AE82"),
		fg = color_default_fg_dark,
	},
	VIOLET = {
		bg = wezterm.color.parse("#685F74"),
		fg = color_default_fg_light,
	},
	VERDIGRIS = {
		bg = wezterm.color.parse("#28AFB0"),
		fg = color_default_fg_light,
	},
}

-- Random color selection (Gist style)
local coolors = {
	COLOR.VERIDIAN,
	COLOR.PAYNE,
	COLOR.INDIGO,
	COLOR.CAROLINA,
	COLOR.FLAME,
	COLOR.JET,
	COLOR.TAUPE,
	COLOR.ECRU,
	COLOR.VIOLET,
	COLOR.VERDIGRIS,
}

local color_primary = coolors[math.random(#coolors)]
local title_color_bg = color_primary.bg
local title_color_fg = color_primary.fg

-- Base colors for terminal
config.colors = {
	foreground = "#b9c0cb",
	background = "#282c34",
	cursor_bg = "#ffcc00",
	cursor_fg = "#282c34",
	cursor_border = "#ffcc00",
	selection_bg = "#b9c0ca",
	selection_fg = "#272b33",
	ansi = { "#41444d", "#fc2f52", "#25a45c", "#ff936a", "#3476ff", "#7a82da", "#4483aa", "#cdd4e0" },
	brights = { "#8f9aae", "#ff6480", "#3fc56b", "#f9c859", "#10b1fe", "#ff78f8", "#5fb9bc", "#ffffff" },
	-- Tab bar colors (Gist style)
	tab_bar = {
		active_tab = {
			bg_color = title_color_bg:lighten(0.03),
			fg_color = title_color_fg:lighten(0.8),
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = title_color_bg:lighten(0.01),
			fg_color = title_color_fg,
			intensity = "Half",
		},
		inactive_tab_edge = title_color_bg,
	},
	split = title_color_bg:lighten(0.3):desaturate(0.5),
}

-- Window frame colors (must be set after color theme is initialized)
config.window_frame = {
	active_titlebar_bg = title_color_bg,
	inactive_titlebar_bg = title_color_bg,
	border_bottom_height = "0.5cell",
	font_size = 10.0, -- Gist style
}

-- ========================================
-- Font Configuration
-- ========================================

-- Font Configuration
-- Moralerspace: プログラミング向けフォント（インストールされている場合）
-- https://github.com/yuru7/moralerspace
-- Monaspace (欧文) + IBM Plex Sans JP (和文) の合成フォント
-- Texture healing システム搭載、半角3:全角5の幅比率
--
-- 注意: Moralerspaceがインストールされていない場合、エラーを避けるために
-- コメントアウトされています。インストール後、コメントを外してください。
--
-- Moralerspaceをインストールする場合:
--   macOS: brew install --cask font-moralerspace
--   詳細: docs/guides/font-installation.md
-- フォント設定（エラーを避けるため、確実に存在するフォントを使用）
config.font = wezterm.font_with_fallback({
	-- macOS標準フォント（確実に存在）
	"Menlo",
	"Monaco",
	-- 追加のフォールバック
	{ family = "JetBrains Mono", weight = "Regular" },
	{ family = "Courier New", weight = "Regular" },
	{ family = "DejaVu Sans Mono", weight = "Regular" },
	-- Moralerspace variants (インストール後にコメントを外してください)
	{ family = "Moralerspace Neon", weight = "Regular" },
	{ family = "Moralerspace Argon", weight = "Regular" },
	{ family = "Moralerspace Xenon", weight = "Regular" },
	{ family = "Moralerspace Radon", weight = "Regular" },
	{ family = "Moralerspace Krypton", weight = "Regular" },
})

-- Font features (ligatures)
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- OS-specific font size and window size
if os == "macOS" or os == "linux" then
	config.font_size = 12
	config.initial_cols = 480
	config.initial_rows = 240
elseif os == "windows" then
	config.font_size = 12
	config.initial_cols = 140
	config.initial_rows = 60
end

-- ========================================
-- Tab Bar
-- ========================================

config.tab_bar_at_bottom = true
config.tab_max_width = 40
config.use_fancy_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false -- Gist style

-- ========================================
-- Helper Functions
-- ========================================

-- Safely execute git commands
local function safe_git_command(cwd, ...)
	local success, stdout = wezterm.run_child_process({
		"git",
		"-C",
		cwd,
		...,
	})
	if success then
		return stdout:gsub("\n", "")
	end
	return nil
end

-- Extract repository name from Git URL
local function extract_repo_name_from_url(url)
	if not url then
		return nil
	end
	local repo_name = url:match("([^/]+)%.git$") or url:match("([^/]+)$")
	return repo_name
end

-- Get Git repository name
local function get_git_repo_name(cwd_path)
	if not safe_git_command(cwd_path, "rev-parse", "--git-dir") then
		return nil
	end

	local repo_name = nil

	-- Try to get from remote origin
	local remote_url = safe_git_command(cwd_path, "config", "--get", "remote.origin.url")
	if remote_url then
		repo_name = extract_repo_name_from_url(remote_url)
	end

	-- Try other remotes
	if not repo_name then
		local remotes = safe_git_command(cwd_path, "remote")
		if remotes and remotes ~= "" then
			local first_remote = remotes:match("([^\n]+)")
			if first_remote then
				remote_url = safe_git_command(cwd_path, "config", "--get", "remote." .. first_remote .. ".url")
				if remote_url then
					repo_name = extract_repo_name_from_url(remote_url)
				end
			end
		end
	end

	-- Try toplevel directory name
	if not repo_name then
		local toplevel = safe_git_command(cwd_path, "rev-parse", "--show-toplevel")
		if toplevel then
			local bare_pattern = "([^/]+)%.bare"
			local git_pattern = "([^/]+)%.git"
			local dir_pattern = "([^/]+)$"

			if toplevel:match("%.bare/") or toplevel:match("%.git/") then
				repo_name = toplevel:match(bare_pattern) or toplevel:match(git_pattern)
			else
				repo_name = toplevel:match(dir_pattern)
			end
		end
	end

	-- Fallback to current directory name
	if not repo_name then
		local dir_name = cwd_path:match("([^/]+)$")
		if dir_name then
			repo_name = dir_name:gsub("%.git$", "")
		end
	end

	return repo_name
end

-- ========================================
-- GUI Startup (Gist style)
-- ========================================

wezterm.on("gui-startup", function(cmd)
	local mux = wezterm.mux

	local padSize = 80
	local screenWidth = 2560
	local screenHeight = 1600

	local tab, pane, window = mux.spawn_window(cmd or {
		workspace = "main",
	})

	-- ランダムな絵文字をタブタイトルに設定
	local icons = {
		"🌞",
		"🍧",
		"🫠",
		"🏞️",
		"📑",
		"🪁",
		"🧠",
		"🦥",
		"🦉",
		"📀",
		"🌮",
		"🍜",
		"🧋",
		"🥝",
		"🍊",
	}

	tab:set_title("  " .. icons[math.random(#icons)] .. "  ")

	-- ウィンドウサイズと位置の設定
	if window ~= nil then
		window:gui_window():set_position(padSize, padSize)
		window:gui_window():set_inner_size(screenWidth - (padSize * 2), screenHeight - (padSize * 2) - 48)
	end
end)

-- ========================================
-- Tab Title Formatting (Gist style)
-- ========================================

local TAB_EDGE_LEFT = wezterm.nerdfonts.ple_left_half_circle_thick
local TAB_EDGE_RIGHT = wezterm.nerdfonts.ple_right_half_circle_thick

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title:gsub("%.exe", "")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, conf, hover, max_width)
	local edge_background = title_color_bg
	local background = title_color_bg:lighten(0.05)
	local foreground = title_color_fg

	if tab.is_active then
		background = background:lighten(0.1)
		foreground = foreground:lighten(0.1)
	elseif hover then
		background = background:lighten(0.2)
		foreground = foreground:lighten(0.2)
	end

	local edge_foreground = background
	local title = tab_title(tab)

	-- Ensure that the titles fit in the available space
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = TAB_EDGE_LEFT },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = TAB_EDGE_RIGHT },
	}
end)

-- ========================================
-- Right Status (Gist style: Battery + Workspace + Time)
-- ========================================

config.status_update_interval = 1000

local color_off = title_color_bg:lighten(0.4)
local color_on = color_off:lighten(0.4)

wezterm.on("update-right-status", function(window, pane)
	-- Battery display (Gist style)
	local bat = ""
	local battery_info = wezterm.battery_info()
	if battery_info and #battery_info > 0 then
		local b = battery_info[1]
		bat = wezterm.format({
			{
				Foreground = {
					Color = b.state_of_charge > 0.2 and color_on or color_off,
				},
			},
			{ Text = "▉" },
			{
				Foreground = {
					Color = b.state_of_charge > 0.4 and color_on or color_off,
				},
			},
			{ Text = "▉" },
			{
				Foreground = {
					Color = b.state_of_charge > 0.6 and color_on or color_off,
				},
			},
			{ Text = "▉" },
			{
				Foreground = {
					Color = b.state_of_charge > 0.8 and color_on or color_off,
				},
			},
			{ Text = "▉" },
			{
				Background = {
					Color = b.state_of_charge > 0.98 and color_on or color_off,
				},
			},
			{
				Foreground = {
					Color = b.state == "Charging" and color_on:lighten(0.3):complement()
						or (b.state_of_charge < 0.2 and wezterm.GLOBAL.count % 2 == 0)
							and color_on:lighten(0.1):complement()
						or color_off:darken(0.1),
				},
			},
			{ Text = " ⚡ " },
		})
	else
		-- No battery (desktop PC)
		bat = wezterm.format({
			{ Text = "🖥" },
		})
	end

	-- Time display (Gist style)
	local time = wezterm.strftime("%-l:%M %P")

	local bg1 = title_color_bg:lighten(0.1)
	local bg2 = title_color_bg:lighten(0.2)

	window:set_right_status(wezterm.format({
		{ Background = { Color = title_color_bg } },
		{ Foreground = { Color = bg1 } },
		{ Text = " " },
		{ Background = { Color = title_color_bg:lighten(0.1) } },
		{ Foreground = { Color = title_color_fg } },
		{ Text = " " .. window:active_workspace() .. " " },
		{ Foreground = { Color = bg1 } },
		{ Background = { Color = bg2 } },
		{ Text = " " },
		{ Foreground = { Color = title_color_bg:lighten(0.4) } },
		{ Foreground = { Color = title_color_fg } },
		{ Text = " " .. time .. " " .. bat },
	}))
end)

-- ========================================
-- Tab Title Updates
-- ========================================

local function update_tab_titles(window)
	if not window then
		return
	end

	local mux_window = window:mux_window()
	if not mux_window then
		return
	end

	local tabs = mux_window:tabs()
	if not tabs then
		return
	end

	for _, tab in ipairs(tabs) do
		local panes = tab:panes()
		if panes and #panes > 0 then
			local pane = panes[1]
			local cwd = pane:get_current_working_dir()

			if cwd then
				local cwd_path = cwd.file_path
				local repo_name = get_git_repo_name(cwd_path)

				if repo_name then
					tab:set_title(repo_name)
				end
			end
		end
	end
end

wezterm.on("tab-active", function(tab, pane, window)
	update_tab_titles(window)
end)

wezterm.on("window-focus-changed", function(window, pane)
	update_tab_titles(window)
end)

wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
	wezterm.time.call_after(0.5, function()
		update_tab_titles(window)
	end)
	return false
end)

-- ========================================
-- Auto Split Layout
-- ========================================

local function create_auto_split_layout(window, pane)
	local success, result = pcall(function()
		-- Split right (40:60)
		local right_pane = pane:split({
			direction = "Right",
			size = 0.6,
		})

		-- Split right pane bottom (70:30)
		wezterm.time.call_after(0.1, function()
			pcall(function()
				right_pane:split({
					direction = "Bottom",
					size = 0.3,
				})
			end)
		end)

		pane:activate()
	end)

	if not success then
		wezterm.log_error("Failed to create auto split layout")
	end
end

-- ========================================
-- Key Bindings
-- ========================================

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Window
	{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen },
	{ key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },

	-- Pane management
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "w", mods = "LEADER", action = wezterm.action_callback(create_auto_split_layout) },

	-- Copy mode and scrolling
	{ key = "c", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "u", mods = "SHIFT|CTRL", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "d", mods = "SHIFT|CTRL", action = wezterm.action.ScrollByPage(0.5) },
	{ key = "g", mods = "SHIFT|CTRL", action = wezterm.action.ScrollToBottom },
	{ key = "Q", mods = "SHIFT|CTRL", action = wezterm.action.SendString("\x1b[81;6u") },

	-- Tab management
	{ key = "{", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(1) },

	-- Copy and paste
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

	-- Vim-like navigation in insert mode
	{ key = "h", mods = "CTRL", action = wezterm.action.SendKey({ key = "LeftArrow" }) },
	{ key = "j", mods = "CTRL", action = wezterm.action.SendKey({ key = "DownArrow" }) },
	{ key = "k", mods = "CTRL", action = wezterm.action.SendKey({ key = "UpArrow" }) },
	{ key = "l", mods = "CTRL", action = wezterm.action.SendKey({ key = "RightArrow" }) },

	-- Font size
	{ key = "+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
	{ key = "_", mods = "CTRL|SHIFT", action = "DecreaseFontSize" },
	{ key = "Backspace", mods = "CTRL|SHIFT", action = "ResetFontSize" },

	-- Reload configuration
	{ key = "F5", action = "ReloadConfiguration" },
}

-- ========================================
-- Misc
-- ========================================

config.audible_bell = "Disabled"

return config
