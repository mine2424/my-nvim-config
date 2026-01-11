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

-- Window
config.adjust_window_size_when_changing_font_size = false
config.integrated_title_button_style = "Windows"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = "0cell",
}
config.window_frame = {
	active_titlebar_bg = "#0F2536",
	inactive_titlebar_bg = "#0F2536",
	border_bottom_height = "0.5cell",
}

-- ========================================
-- Cursor
-- ========================================

config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.force_reverse_video_cursor = true

-- ========================================
-- Colors
-- ========================================

config.colors = {
	tab_bar = {
		background = "#282c34",
	},
	foreground = "#b9c0cb",
	background = "#282c34",
	cursor_bg = "#ffcc00",
	cursor_fg = "#282c34",
	cursor_border = "#ffcc00",
	selection_bg = "#b9c0ca",
	selection_fg = "#272b33",
	ansi = { "#41444d", "#fc2f52", "#25a45c", "#ff936a", "#3476ff", "#7a82da", "#4483aa", "#cdd4e0" },
	brights = { "#8f9aae", "#ff6480", "#3fc56b", "#f9c859", "#10b1fe", "#ff78f8", "#5fb9bc", "#ffffff" },
}

-- ========================================
-- Font Configuration
-- ========================================

-- Moralerspace: プログラミング向けフォント
-- https://github.com/yuru7/moralerspace
-- Monaspace (欧文) + IBM Plex Sans JP (和文) の合成フォント
-- Texture healing システム搭載、半角3:全角5の幅比率
config.font = wezterm.font_with_fallback({
	{ family = "Moralerspace Neon", weight = "Regular" },
	{ family = "Moralerspace Argon", weight = "Regular" },
	{ family = "Moralerspace Xenon", weight = "Regular" },
	{ family = "Moralerspace Radon", weight = "Regular" },
	{ family = "Moralerspace Krypton", weight = "Regular" },
	{ family = "JetBrains Mono", weight = "Regular" }, -- Fallback
	{ family = "Monaco" },
	{ family = "Menlo" },
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

-- Convert process name to icon
local function process_to_icon(process_name)
	local icons = {
		nvim = "",
		zsh = "",
		bash = "󱆃",
		sl = "󰔬",
		lazygit = "",
		tig = "",
		wezterm = "",
		mcfly = "",
		emu = "🦤",
		[""] = "🤖",
	}
	return icons[process_name] or process_name
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

-- Check if process is running (CPU-based)
local function check_process_running(pid)
	local success, result = pcall(function()
		local ps_success, ps_stdout = wezterm.run_child_process({
			"/bin/ps",
			"-p",
			tostring(pid),
			"-o",
			"pcpu",
		})

		if not ps_success or not ps_stdout then
			return false
		end

		local cpu = ps_stdout:match("([%d%.]+)")
		local cpu_usage = tonumber(cpu) or 0
		return cpu_usage >= 1.0
	end)

	if not success then
		return false
	end

	return result
end

-- ========================================
-- Tab Title Formatting
-- ========================================

wezterm.on("format-tab-title", function(tab, tabs, panes, conf, hover, max_width)
	local background = "#282c34"
	local foreground = "#dcd7ba"
	local edge_background = "#282c34"

	if tab.is_active or hover then
		background = "#015db2"
		foreground = "#ffffff"
	end
	local edge_foreground = background

	-- Determine tab title
	local title = ""
	if tab.tab_title and tab.tab_title ~= "" then
		title = tab.tab_title
	else
		title = process_to_icon(tab.active_pane.title)
	end

	-- Claude status for current tab
	local claude_emoji = ""
	local proc_info = tab.active_pane and tab.active_pane:get_foreground_process_info()
	if proc_info and proc_info.name then
		local is_claude = proc_info.name:lower():match("claude")
		if not is_claude and proc_info.argv then
			for _, arg in ipairs(proc_info.argv) do
				if arg:lower():match("claude") then
					is_claude = true
					break
				end
			end
		end

		if is_claude then
			local ps_success, ps_result = pcall(function()
				local success, stdout = wezterm.run_child_process({
					"/bin/ps",
					"-p",
					tostring(proc_info.pid),
					"-o",
					"pcpu",
				})
				if success and stdout then
					local cpu = stdout:match("([%d%.]+)")
					local cpu_usage = tonumber(cpu) or 0
					return cpu_usage >= 1.0 and " ⚡" or " 🤖"
				else
					return " 🤖"
				end
			end)
			claude_emoji = ps_success and ps_result or " 🤖"
		end
	end

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = " " },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
		{ Text = " " .. title .. claude_emoji .. "  " },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = "" },
	}
end)

-- ========================================
-- Right Status (Claude monitoring)
-- ========================================

config.status_update_interval = 1000

wezterm.on("update-right-status", function(window, pane)
	local elements = {}

	-- Scan all tabs for Claude instances
	if window then
		local mux_window = window:mux_window()
		if mux_window then
			local claude_instances = {}

			for tab_idx, tab in ipairs(mux_window:tabs()) do
				for _, tab_pane in ipairs(tab:panes()) do
					local proc_info = tab_pane:get_foreground_process_info()
					if proc_info and proc_info.name then
						local is_claude = proc_info.name:lower():match("claude")

						if not is_claude and proc_info.argv then
							for _, arg in ipairs(proc_info.argv) do
								if arg:lower():match("claude") then
									is_claude = true
									break
								end
							end
						end

						if is_claude then
							local is_running = check_process_running(proc_info.pid)
							table.insert(claude_instances, {
								tab_idx = tab_idx,
								is_running = is_running,
							})
						end
					end
				end
			end

			-- Display Claude instances summary
			if #claude_instances > 0 then
				local running_count = 0
				local idle_count = 0

				for _, instance in ipairs(claude_instances) do
					if instance.is_running then
						running_count = running_count + 1
					else
						idle_count = idle_count + 1
					end
				end

				table.insert(elements, { Foreground = { Color = "#FF6B6B" } })
				if running_count > 0 then
					table.insert(elements, { Text = "⚡" .. running_count })
				end
				if idle_count > 0 then
					if running_count > 0 then
						table.insert(elements, { Text = " " })
					end
					table.insert(elements, { Text = "🤖" .. idle_count })
				end

				-- Show tab numbers
				table.insert(elements, { Foreground = { Color = "#a0a0a0" } })
				table.insert(elements, { Text = " [" })
				for i, instance in ipairs(claude_instances) do
					if i > 1 then
						table.insert(elements, { Text = "," })
					end
					table.insert(elements, { Text = tostring(instance.tab_idx) })
				end
				table.insert(elements, { Text = "]" })
			end
		end
	end

	-- Time display
	if #elements > 0 then
		table.insert(elements, { Text = "  " })
	end
	table.insert(elements, { Foreground = { Color = "#9ece6a" } })
	table.insert(elements, { Text = wezterm.strftime("%H:%M") })

	window:set_right_status(wezterm.format(elements))
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
