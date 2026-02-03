-- ========================================
-- WezTerm Configuration
-- ========================================
-- https://wezfurlong.org/wezterm/

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

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

-- Scrollback
config.scrollback_lines = 10000

-- Suppress font warnings (フォントが見つからない場合の警告を抑制)
config.warn_about_missing_glyphs = false

-- Window
config.adjust_window_size_when_changing_font_size = false
config.integrated_title_button_style = "Windows"
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.macos_window_background_blur = 8
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "0.5cell",
	bottom = "0.5cell",
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
-- local color_primary = COLOR.VERIDIAN
local title_color_bg = color_primary.bg
local title_color_fg = color_primary.fg

-- ========================================
-- カラースキーム設定（Neovim統合）
-- ========================================
-- 
-- 注意: Neovimのカラースキーム（tokyonight.nvim）と統合するため、
-- ターミナルカラー（ansi/brights）はコメントアウトしています。
-- Neovimが terminal_colors = true で制御します。
--
-- タブバーとウィンドウフレームのみカスタマイズ（Tokyo Night Night風）

config.colors = {
	-- ターミナルカラーはNeovimに任せる（コメントアウト）
	-- Neovimの tokyonight.nvim が terminal_colors = true で制御
	-- foreground = "#b9c0cb",
	-- background = "#282c34",
	-- ansi = { ... },
	-- brights = { ... },
	
	-- タブバーのみカスタマイズ（Tokyo Night Night風）
	tab_bar = {
		background = "#1a1b26",
		active_tab = {
			bg_color = "#7aa2f7",
			fg_color = "#1a1b26",
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = "#292e42",
			fg_color = "#545c7e",
			intensity = "Half",
		},
		inactive_tab_hover = {
			bg_color = "#3b4261",
			fg_color = "#7aa2f7",
		},
		new_tab = {
			bg_color = "#1a1b26",
			fg_color = "#7aa2f7",
		},
		new_tab_hover = {
			bg_color = "#3b4261",
			fg_color = "#7aa2f7",
		},
	},
	-- ペイン分割線の色
	split = "#3b4261",
}

-- Window frame colors (must be set after color theme is initialized)
config.window_frame = {
	active_titlebar_bg = title_color_bg,
	inactive_titlebar_bg = title_color_bg,
	border_bottom_height = "0.5cell",
	font_size = 11.0,
}

-- ========================================
-- Font Configuration
-- ========================================


-- フォント設定
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
})

-- Font features (ligatures)
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- OS-specific font size and window size
if os == "macOS" or os == "linux" then
	config.font_size = 13
	config.initial_cols = 480
	config.initial_rows = 240
elseif os == "windows" then
	config.font_size = 13
	config.initial_cols = 140
	config.initial_rows = 60
end

-- IME support
config.use_ime = true

-- ========================================
-- Tab Bar
-- ========================================

config.tab_bar_at_bottom = false -- Gist style: タブバーを上に配置
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
	-- TODO: 画面サイズを取得して最大幅で表示できるようにする
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
-- Right Status (Gist style: System Info + Workspace + Time)
-- ========================================

config.status_update_interval = 1000

local color_off = title_color_bg:lighten(0.4)
local color_on = color_off:lighten(0.4)

-- システム情報取得関数
local function get_memory_usage()
	local success, stdout
	if os == "macOS" then
		-- macOS: vm_stat と sysctl を使用してメモリ使用率を計算
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"pagesize=$(vm_stat | grep 'page size' | awk '{print $8}'); mem_total=$(sysctl -n hw.memsize); mem_free=$(vm_stat | grep 'Pages free' | awk '{print $3}' | sed 's/\\.//'); mem_used=$((mem_total - mem_free * pagesize)); echo $((mem_used * 100 / mem_total))"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" and tonumber(usage) then
				return usage .. "%"
			end
		end
		-- フォールバック: top コマンドを使用（簡易版）
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"top -l 1 | grep 'PhysMem' | awk '{used=$2; wired=$4; total=used+wired+$6; if(total>0) printf \"%.0f\", (used/total)*100}'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" and tonumber(usage) then
				return usage .. "%"
			end
		end
	elseif os == "linux" then
		-- Linux: free コマンドを使用
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"free | grep Mem | awk '{printf \"%.0f\", $3/$2 * 100}'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" then
				return usage .. "%"
			end
		end
	elseif os == "windows" then
		-- Windows: PowerShell を使用
		success, stdout = wezterm.run_child_process({
			"powershell",
			"-NoProfile",
			"-Command",
			"$mem = Get-CimInstance Win32_OperatingSystem; [math]::Round((($mem.TotalVisibleMemorySize - $mem.FreePhysicalMemory) / $mem.TotalVisibleMemorySize) * 100)"
		})
		if success and stdout then
			return stdout:gsub("\n", ""):gsub("%s+", "") .. "%"
		end
	end
	return "N/A"
end

local function get_cpu_usage()
	local success, stdout
	if os == "macOS" then
		-- macOS: top コマンドを使用
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"top -l 1 | grep 'CPU usage' | awk '{print $3}' | sed 's/%//'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" then
				return usage .. "%"
			end
		end
	elseif os == "linux" then
		-- Linux: top コマンドを使用
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" then
				return string.format("%.0f", tonumber(usage) or 0) .. "%"
			end
		end
		-- フォールバック: /proc/stat を使用
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" then
				return string.format("%.0f", tonumber(usage) or 0) .. "%"
			end
		end
	elseif os == "windows" then
		-- Windows: PowerShell を使用
		success, stdout = wezterm.run_child_process({
			"powershell",
			"-NoProfile",
			"-Command",
			"$cpu = Get-CimInstance Win32_Processor | Measure-Object -property LoadPercentage -Average; [math]::Round($cpu.Average)"
		})
		if success and stdout then
			return stdout:gsub("\n", ""):gsub("%s+", "") .. "%"
		end
	end
	return "N/A"
end

local function get_disk_usage()
	local success, stdout
	if os == "macOS" then
		-- macOS: df コマンドを使用
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"df -h / | tail -1 | awk '{print $5}' | sed 's/%//'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" then
				return 100 -usage .. "%"
			end
		end
	elseif os == "linux" then
		-- Linux: df コマンドを使用
		success, stdout = wezterm.run_child_process({
			"sh",
			"-c",
			"df -h / | tail -1 | awk '{print $5}' | sed 's/%//'"
		})
		if success and stdout then
			local usage = stdout:gsub("\n", ""):gsub("%s+", "")
			if usage and usage ~= "" then
				return 100 - usage .. "%"
			end
		end
	elseif os == "windows" then
		-- Windows: PowerShell を使用
		success, stdout = wezterm.run_child_process({
			"powershell",
			"-NoProfile",
			"-Command",
			"$disk = Get-CimInstance Win32_LogicalDisk -Filter \"DeviceID='C:'\"; [math]::Round((($disk.Size - $disk.FreeSpace) / $disk.Size) * 100)"
		})
		if success and stdout then
			return 100 - stdout:gsub("\n", ""):gsub("%s+", "") .. "%"
		end
	end
	return "N/A"
end

-- 使用率に応じた色を返す関数
local function get_usage_color(usage_str)
	local usage = tonumber(usage_str:match("%d+"))
	if not usage then
		return color_off
	end
	if usage >= 90 then
		return wezterm.color.parse("#f7768e") -- 赤（危険）
	elseif usage >= 70 then
		return wezterm.color.parse("#e0af68") -- 黄（警告）
	else
		return color_on -- 緑（正常）
	end
end

wezterm.on("update-right-status", function(window, pane)
	-- システム情報取得
	local mem_usage = get_memory_usage()
	local cpu_usage = get_cpu_usage()
	local disk_usage = get_disk_usage()

	-- Time display (Gist style)
	local time = wezterm.strftime("%-l:%M %P")

	local bg1 = title_color_bg:lighten(0.1)
	local bg2 = title_color_bg:lighten(0.2)

	window:set_right_status(wezterm.format({
		{ Background = { Color = title_color_bg } },
		{ Foreground = { Color = bg1 } },
		{ Text = "" },
		{ Background = { Color = title_color_bg:lighten(0.1) } },
		{ Foreground = { Color = title_color_fg } },
		{ Text = " " .. window:active_workspace() .. " " },
		{ Foreground = { Color = bg1 } },
		{ Background = { Color = bg2 } },
		{ Text = "" },
		-- システム情報表示（Gist style）
		{ Foreground = { Color = get_usage_color(mem_usage) } },
		{ Text = " 💾 " .. mem_usage },
		{ Foreground = { Color = title_color_bg:lighten(0.4) } },
		{ Text = " | " },
		{ Foreground = { Color = get_usage_color(cpu_usage) } },
		{ Text = " 💻 " .. cpu_usage },
		{ Foreground = { Color = title_color_bg:lighten(0.4) } },
		{ Text = " | " },
		{ Foreground = { Color = get_usage_color(disk_usage) } },
		{ Text = " 💿 " .. disk_usage },
		{ Foreground = { Color = title_color_bg:lighten(0.4) } },
		{ Text = " | " },
		{ Foreground = { Color = title_color_fg } },
		{ Text = time .. " " },
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

-- OS別のモディファイアキー設定
-- macOS: Command, Windows/Linux: Ctrl
local tab_mod = os == "macOS" and "CMD" or "CTRL"
local tab_mod_shift = os == "macOS" and "CMD|SHIFT" or "CTRL|SHIFT"

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- ========================================
	-- Tab management (macOS: Cmd, Windows/Linux: Ctrl)
	-- ========================================
	
	-- 新規タブ
	{ key = "t", mods = tab_mod, action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	
	-- タブを閉じる
	{ key = "w", mods = tab_mod, action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	
	-- タブ切り替え（数字）
	{ key = "1", mods = tab_mod, action = wezterm.action.ActivateTab(0) },
	{ key = "2", mods = tab_mod, action = wezterm.action.ActivateTab(1) },
	{ key = "3", mods = tab_mod, action = wezterm.action.ActivateTab(2) },
	{ key = "4", mods = tab_mod, action = wezterm.action.ActivateTab(3) },
	{ key = "5", mods = tab_mod, action = wezterm.action.ActivateTab(4) },
	{ key = "6", mods = tab_mod, action = wezterm.action.ActivateTab(5) },
	{ key = "7", mods = tab_mod, action = wezterm.action.ActivateTab(6) },
	{ key = "8", mods = tab_mod, action = wezterm.action.ActivateTab(7) },
	{ key = "9", mods = tab_mod, action = wezterm.action.ActivateTab(-1) },
	
	-- タブ移動
	{ key = "Tab", mods = tab_mod, action = wezterm.action.ActivateTabRelative(1) },
	{ key = "Tab", mods = tab_mod_shift, action = wezterm.action.ActivateTabRelative(-1) },
	
	-- タブの順序変更
	{ key = "{", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "}", mods = "SHIFT|ALT", action = wezterm.action.MoveTabRelative(1) },
	
	-- ========================================
	-- Window
	-- ========================================
	{ key = "n", mods = "SHIFT|CTRL", action = wezterm.action.ToggleFullScreen },
	{ key = "Enter", mods = "ALT", action = wezterm.action.DisableDefaultAssignment },

	-- ========================================
	-- Pane management
	-- ========================================
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "q", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "w", mods = "LEADER", action = wezterm.action_callback(create_auto_split_layout) },

	-- ========================================
	-- Copy mode and scrolling
	-- ========================================
	{ key = "c", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action({ CopyTo = "Clipboard" }) },
	{ key = "u", mods = "SHIFT|CTRL", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "d", mods = "SHIFT|CTRL", action = wezterm.action.ScrollByPage(0.5) },
	{ key = "g", mods = "SHIFT|CTRL", action = wezterm.action.ScrollToBottom },
	{ key = "Q", mods = "SHIFT|CTRL", action = wezterm.action.SendString("\x1b[81;6u") },

	-- ========================================
	-- Copy and paste
	-- ========================================
	{ key = "C", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("ClipboardAndPrimarySelection") },
	{ key = "V", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

	-- ========================================
	-- Vim-like navigation in insert mode
	-- ========================================
	{ key = "h", mods = "CTRL", action = wezterm.action.SendKey({ key = "LeftArrow" }) },
	{ key = "j", mods = "CTRL", action = wezterm.action.SendKey({ key = "DownArrow" }) },
	{ key = "k", mods = "CTRL", action = wezterm.action.SendKey({ key = "UpArrow" }) },
	{ key = "l", mods = "CTRL", action = wezterm.action.SendKey({ key = "RightArrow" }) },

	-- ========================================
	-- Font size (macOS: Cmd, Windows/Linux: Ctrl)
	-- ========================================
	{ key = "+", mods = tab_mod, action = "IncreaseFontSize" },
	{ key = "=", mods = tab_mod, action = "IncreaseFontSize" }, -- Shift不要版
	{ key = "-", mods = tab_mod, action = "DecreaseFontSize" },
	{ key = "0", mods = tab_mod, action = "ResetFontSize" },
	
	-- 従来のキーバインドも残す（互換性）
	{ key = "+", mods = "CTRL|SHIFT", action = "IncreaseFontSize" },
	{ key = "_", mods = "CTRL|SHIFT", action = "DecreaseFontSize" },
	{ key = "Backspace", mods = "CTRL|SHIFT", action = "ResetFontSize" },

	-- ========================================
	-- その他
	-- ========================================
	
	-- 設定リロード
	{ key = "F5", action = "ReloadConfiguration" },
	{ key = "r", mods = tab_mod_shift, action = wezterm.action.ReloadConfiguration },
	
	-- コマンドパレット
	{ key = "p", mods = tab_mod_shift, action = wezterm.action.ActivateCommandPalette },
	
	-- 検索
	{ key = "f", mods = tab_mod, action = wezterm.action.Search("CurrentSelectionOrEmptyString") },
}

-- ========================================
-- Misc
-- ========================================

config.audible_bell = "Disabled"

return config
