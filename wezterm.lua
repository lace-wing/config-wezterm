--from https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
--- Check if a file or directory exists in this path
local function exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end
--endfrom

local function get_os_name()
  if exists("C:\\") then
    return "windows"
  end
  if exists("/Users") then
    return "macos"
  end
  return "linux"
end

-- get wezterm config
local wezterm = require 'wezterm'
local c = {}
if wezterm.config_builder then
  c = wezterm.config_builder()
end

-- os compat
local compat = require(string.format("modules.%s", get_os_name()))
-- machine compat
if exists("modules/local-machine.lua") then
  local mc_compat = require"modules.local-machine"
  -- merge os with machine, override os
  for k, v in pairs(mc_compat) do
    compat[k] = v
  end
end

-- 初始大小

c.initial_rows = 24

-- 关闭时不进行确认
c.window_close_confirmation = 'NeverPrompt'

-- 字体
c.font = wezterm.font_with_fallback {
	"MonaspiceAr NFM",
	"Heiti SC",
}
c.font_size = 16.0

-- 配色
local ever = wezterm.color.get_builtin_schemes()["Everforest Dark (Gogh)"]
-- ever.scrollbar_thumb = '#cccccc' -- 更明显的滚动条
c.colors = ever

-- 透明背景
c.window_background_opacity = 1
-- 取消 Windows 原生标题栏
c.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- 滚动条尺寸为 15 ，其他方向不需要 pad
c.window_padding = { left = 0, right = 15, top = 0, bottom = 0 }
-- 启用滚动条
c.enable_scroll_bar = true

-- launch main shell
c.default_prog = { compat.shell[1].args[1] }

--  create launch_menu
c.launch_menu = compat.shell

local act = wezterm.action

return c
