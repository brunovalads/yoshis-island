----------------------------------------------------------------------------------
--  Super Mario World 2 - Yoshi's Island (all versions) Utility Script for BizHawk
--  http://tasvideos.org/GameResources/SNES/YoshisIsland.html
--  
--  Author: BrunoValads 
--  Git repository: https://github.com/brunovalads/yoshis-island
--
--  Based on Amaraticando's Super Mario World script
--  https://github.com/rodamaral/smw-tas
----------------------------------------------------------------------------------

--##########################################################################################################################################################
-- CONFIG:

local INI_CONFIG_FILENAME = "Yoshi's Island Utilities Config NEW.ini"  -- relative to the folder of the script

local DEFAULT_OPTIONS = {
  -- Hotkeys
  -- make sure that the hotkeys below don't conflict with previous bindings
  hotkey_decrease_opacity = "numpad-",   -- to decrease the opacity of the text
  hotkey_increase_opacity = "numpad+",  -- to increase the opacity of the text

  -- Display
  display_movie_info = true,
  display_misc_info = true,
  display_player_info = true,
  display_player_hitbox = true,  -- can be changed by right-clicking on player
  display_interaction_points = true,  -- can be changed by right-clicking on player
  display_tongue_hitbox = false,
  display_throw_info = true,
  display_egg_info = true,
  display_blocked_status = true,
  display_sprite_info = true,
  display_sprite_table = true,
  display_sprite_slot_in_screen = true,
  display_sprite_hitbox = true,
  display_sprite_special_info = true,
  display_ambient_sprite_info = false,
  display_ambient_sprite_table = true,
  display_ambient_sprite_slot_in_screen = true,
  display_sprite_data = false,
  display_sprite_load_status = false,
  display_sprite_spawning_areas = false,
  display_level_info = true,
  display_level_help = true,
  display_counters = false,
  display_controller_input = true,
  draw_tiles_with_click = false,

  -- Some extra/debug info
  display_debug_info = false,  -- shows useful info while investigating the game, but not very useful while TASing
  display_debug_player_extra = true,
  display_debug_sprite_extra = true,
  display_debug_sprite_tweakers = true,
  display_debug_ambient_sprite = true,
  display_debug_controller_data = false,
  display_miscellaneous_sprite_table = false,
  miscellaneous_sprite_table_number = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true,
    [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [16] = true, [17] = true, [18] = true, [19] = true, [20] = true,
		[21] = true, [22] = true, [23] = true, [24] = true, [25] = true, [26] = true, [27] = true, [28] = true, [29] = true
  },
	display_mouse_coordinates = false,
	draw_tile_map_grid = false,
	draw_tile_map_type = false,
	draw_tile_map_screen = false,
	
	-- Memory edit function
	address = 0x7E0000,
	size = 1,
	value = 0,
	edit_method = "Poke",
	edit_sprite_table = false,
  edit_sprite_table_number = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false,
    [9] = false, [10] = false, [11] = false, [12] = false, [13] = false, [14] = false, [15] = false, [16] = false, [17] = false,
    [18] = false, [19] = false, [20] = false, [21] = false, [22] = false, [23] = false, [24] = false
  },
  
  -- Script settings
  left_gap = 130,
  right_gap = 180,
  top_gap = 45,
  bottom_gap = 44,
  max_tiles_drawn = 40  -- the max number of tiles to be drawn/registered by the script
}

-- Colour settings
local DEFAULT_COLOUR = {
  -- Text
  default_text_opacity = 1.0,
  default_bg_opacity = 0.7,
  text = 0xffffffff, -- white
  background = 0xff000000, -- black
  halo = 0xff000040,
  positive = 0xff00FF00, -- green
  warning = 0xffFF0000, -- red
  warning_bg = 0xff000000,
  warning2 = 0xffFF00FF, -- purple
  warning_soft = 0xffFFA500, -- orange
  warning_transparent = 0x80FF0000, -- red (transparent)
  weak = 0xa0A9A9A9, -- gray (transparent)
  weak2 = 0xff555555, -- gray
  very_weak = 0x60A9A9A9,
  disabled = 0xff808080, -- gray
  memory = 0xff00FFFF, -- cyan
  joystick_input = 0xffFFFF00,
  joystick_input_bg = 0x30FFFFFF,
  button_text = 0xff300030,
  mainmenu_outline = 0xc0FFFFFF,
  mainmenu_bg = 0xc0000000,

  -- Counters
  counter_pipe = 0xff00FF00,
  counter_swallow = 0xff00FF00,
  counter_transform = 0xffA5A5A5,
  counter_star = 0xffFFFF00,
  counter_switch = 0xffFF0000,
  counter_invincibility = 0xffF8D870,

  -- Hitbox and related text
  mario = 0xffFF0000,
  mario_bg = 0x80FF0000,
  mario_mounted_bg = 0x00000000,
  interaction = 0xffFFFFFF,
  interaction_bg = 0x20000000,
  interaction_nohitbox = 0xa0000000,
  interaction_nohitbox_bg = 0x70000000,
  detection_bg = 0x30400020,

  -- Sprites
  sprites = {
    0xff80FFFF, -- cyan
    0xffA0A0FF, -- blue
    0xffFF6060, -- red
    0xffFF80FF, -- magenta
    0xffFFA100, -- orange
    0xffFFFF80, -- yellow
    0xff40FF40  -- green
  },
  sprites_bg = 0x0000b050,
  sprites_interaction_pts = 0xffffffff,
  sprites_clipping_bg = 0x000000a0,
  ambient_sprites = {
    0xff3700ff, -- orange to red gradient 6
    0xff5b00ff, -- orange to red gradient 4
    0xff8000ff, -- orange to red gradient 2
    0xffa500ff -- orange to red gradient 0 (orange)
  },
  ambient_sprites_bg = 0x5000FF00,
  special_ambient_sprite_bg = 0x6000FF00,
  cluster_sprites = 0xffFF80A0,
  sumo_brother_flame = 0xff0040A0,
  minor_ambient_sprites = 0xffFF90B0,
  awkward_hitbox = 0xff204060,
  awkward_hitbox_bg = 0x60FF8000,

  -- Yoshi
  yoshi = 0xff00FFFF,
  yoshi_bg = 0x4000FFFF,
  yoshi_mounted_bg = 0x00000000,
  tongue_line = 0xffFFA000,
  tongue_bg = 0x60000000,

  block = 0xff00008B,
  blank_tile = 0x70FFFFFF,
  block_bg = 0xa022CC88,
  layer2_line = 0xffFF2060,
  layer2_bg = 0x40FF2060,
  static_camera_region = 0x40400020
}

-- Font settings
local BIZHAWK_FONT_WIDTH = 10  -- correction to the scale is done in bizhawk_screen_info()
local BIZHAWK_FONT_HEIGHT = 18

-- Symbols
local LEFT_ARROW = "<-"
local RIGHT_ARROW = "->"

-- Input key names
local INPUT_KEYNAMES = {  -- BizHawk

  A=false, Add=false, Alt=false, Apps=false, Attn=false, B=false, Back=false, BrowserBack=false, BrowserFavorites=false,
  BrowserForward=false, BrowserHome=false, BrowserRefresh=false, BrowserSearch=false, BrowserStop=false, C=false,
  Cancel=false, Capital=false, CapsLock=false, Clear=false, Control=false, ControlKey=false, Crsel=false, D=false, D0=false,
  D1=false, D2=false, D3=false, D4=false, D5=false, D6=false, D7=false, D8=false, D9=false, Decimal=false, Delete=false,
  Divide=false, Down=false, E=false, End=false, Enter=false, EraseEof=false, Escape=false, Execute=false, Exsel=false,
  F=false, F1=false, F10=false, F11=false, F12=false, F13=false, F14=false, F15=false, F16=false, F17=false, F18=false,
  F19=false, F2=false, F20=false, F21=false, F22=false, F23=false, F24=false, F3=false, F4=false, F5=false, F6=false,
  F7=false, F8=false, F9=false, FinalMode=false, G=false, H=false, HanguelMode=false, HangulMode=false, HanjaMode=false,
  Help=false, Home=false, I=false, IMEAccept=false, IMEAceept=false, IMEConvert=false, IMEModeChange=false,
  IMENonconvert=false, Insert=false, J=false, JunjaMode=false, K=false, KanaMode=false, KanjiMode=false, KeyCode=false,
  L=false, LaunchApplication1=false, LaunchApplication2=false, LaunchMail=false, LButton=false, LControlKey=false,
  Left=false, LineFeed=false, LMenu=false, LShiftKey=false, LWin=false, M=false, MButton=false, MediaNextTrack=false,
  MediaPlayPause=false, MediaPreviousTrack=false, MediaStop=false, Menu=false, Modifiers=false, Multiply=false, N=false,
  Next=false, NoName=false, None=false, NumLock=false, NumPad0=false, NumPad1=false, NumPad2=false, NumPad3=false,
  NumPad4=false, NumPad5=false, NumPad6=false, NumPad7=false, NumPad8=false, NumPad9=false, O=false, Oem1=false,
  Oem102=false, Oem2=false, Oem3=false, Oem4=false, Oem5=false, Oem6=false, Oem7=false, Oem8=false, OemBackslash=false,
  OemClear=false, OemCloseBrackets=false, Oemcomma=false, OemMinus=false, OemOpenBrackets=false, OemPeriod=false,
  OemPipe=false, Oemplus=false, OemQuestion=false, OemQuotes=false, OemSemicolon=false, Oemtilde=false, P=false, Pa1=false,
  Packet=false, PageDown=false, PageUp=false, Pause=false, Play=false, Print=false, PrintScreen=false, Prior=false,
  ProcessKey=false, Q=false, R=false, RButton=false, RControlKey=false, Return=false, Right=false, RMenu=false, RShiftKey=false,
  RWin=false, S=false, Scroll=false, Select=false, SelectMedia=false, Separator=false, Shift=false, ShiftKey=false,
  Sleep=false, Snapshot=false, Space=false, Subtract=false, T=false, Tab=false, U=false, Up=false, V=false, VolumeDown=false,
  VolumeMute=false, VolumeUp=false, W=false, X=false, XButton1=false, XButton2=false, Y=false, Z=false, Zoom=false
}


--##########################################################################################################################################################
-- INITIAL STATEMENTS:

console.clear()

-- Check if is running in BizHawk
if tastudio == nil then
  error("\n\nThis script only works with BizHawk!")
end

-- Check if it's Yoshi's Island (any version or hack)
if memory.read_u32_be(0x007FB2, "CARTROM") ~= 0x59492020 then -- Game code, in ROM
  error("\n\nThis script is for Yoshi's Island only!")
end

print("Starting Yoshi's Island script\n")

-- Load environment
local gui, input, joypad, emu, movie, memory = gui, input, joypad, emu, movie, memory
local unpack = unpack or table.unpack
local string, math, table, next, ipairs, pairs, io, os, type = string, math, table, next, ipairs, pairs, io, os, type
--local bit = require"bit"


-- TEST: INI library for handling an ini configuration file
function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

function copytable(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[copytable(orig_key)] = copytable(orig_value) -- possible stack overflow
    end
    setmetatable(copy, copytable(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

function mergetable(source, t2)
  for key, value in pairs(t2) do
    if type(value) == "table" then
      if type(source[key] or false) == "table" then
        mergetable(source[key] or {}, t2[key] or {}) -- possible stack overflow
      else
        source[key] = value
      end
    else
      source[key] = value
    end
  end
  return source
end

-- Creates a set from a list
local function make_set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end

local OPTIONS =  DEFAULT_OPTIONS
local COLOUR = DEFAULT_COLOUR


-- Text/Background_max_opacity is only changed by the player using the hotkeys
-- Text/Bg_opacity must be used locally inside the functions
local Text_max_opacity = COLOUR.default_text_opacity
local Background_max_opacity = COLOUR.default_bg_opacity
local Text_opacity = 1
local Bg_opacity = 1

-- Basic functions renaming
local fmt = string.format
local floor = math.floor
local ceil = math.ceil
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local pi = math.pi
local function math_round(number, dec_places)
  local mult = 10^(dec_places or 0)
  return math.floor(number * mult + 0.5) / mult
end
--local bit.test = bit.check -- BizHawk (Doesn't work ranaming, for some reason)

-- Rename gui functions
local draw_line = gui.drawLine
local draw_box = gui.drawBox
local draw_rectangle = gui.drawRectangle
local draw_image = gui.drawImage
local draw_image_region = gui.drawImageRegion --gui.drawImageRegion(path, source_x, source_y, source_width, source_height, dest_x, dest_y, [? dest_width], [? dest_height])
local draw_cross = gui.drawAxis
local draw_pixel = gui.drawPixel

-- Compatibility of the memory read/write functions
local u8_wram =  mainmemory.read_u8
local s8_wram =  mainmemory.read_s8
local w8_wram =  mainmemory.write_u8
local u16_wram = mainmemory.read_u16_le
local s16_wram = mainmemory.read_s16_le
local w16_wram = mainmemory.write_u16_le
local u24_wram = mainmemory.read_u24_le
local s24_wram = mainmemory.read_s24_le
local w24_wram = mainmemory.write_u24_le
memory.usememorydomain("CARTRAM")
local u8_sram =  memory.read_u8
local s8_sram =  memory.read_s8
local w8_sram =  memory.write_u8
local u16_sram = memory.read_u16_le
local s16_sram = memory.read_s16_le
local w16_sram = memory.write_u16_le
local u24_sram = memory.read_u24_le
local s24_sram = memory.read_s24_le
local w24_sram = memory.write_u24_le

-- Get screen dimensions of the game and emulator
local Screen_width, Screen_height, Buffer_width, Buffer_height, Buffer_middle_x, Buffer_middle_y, Border_right_start, Border_bottom_start, Scale_x, Scale_y
local function bizhawk_screen_info()
  if client.borderwidth() == 0 then -- to avoid division by zero bug when borders are not yet ready when loading the script
    Scale_x = 2
    Scale_y = 2
  else
    Scale_x = math.min(client.borderwidth()/OPTIONS.left_gap, client.borderheight()/OPTIONS.top_gap) -- Pixel scale
    Scale_y = Scale_x -- assumming square pixels only
  end
  
  Screen_width = client.screenwidth()/Scale_x  -- Emu screen width CONVERTED to game pixels
  Screen_height = client.screenheight()/Scale_y  -- Emu screen height CONVERTED to game pixels
  Buffer_width = client.bufferwidth()  -- Game area width, in game pixels
  Buffer_height = client.bufferheight()  -- Game area height, in game pixels
  Buffer_middle_x = OPTIONS.left_gap + Buffer_width/2  -- Game area middle x relative to emu window, in game pixels
  Buffer_middle_y = OPTIONS.top_gap + Buffer_height/2  -- Game area middle y relative to emu window, in game pixels
  Border_right_start = OPTIONS.left_gap + Buffer_width
  Border_bottom_start = OPTIONS.top_gap + Buffer_height
  
  BIZHAWK_FONT_WIDTH = 10/Scale_x -- to make compatible to the scale
  BIZHAWK_FONT_HEIGHT = 18/Scale_y
end


--[[ Hotkeys availability
if INPUT_KEYNAMES[OPTIONS.hotkey_increase_opacity] == nil then
     print(string.format("Hotkey '%s' is not available, to increase opacity.", OPTIONS.hotkey_increase_opacity))
else print(string.format("Hotkey '%s' set to increase opacity.", OPTIONS.hotkey_increase_opacity))
end
if INPUT_KEYNAMES[OPTIONS.hotkey_decrease_opacity] == nil then
     print(string.format("Hotkey '%s' is not available, to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
else print(string.format("Hotkey '%s' set to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
end]]


--##########################################################################################################################################################
-- GAME AND SNES SPECIFIC MACROS:

local NTSC_FRAMERATE = 60.0988138974405
local PAL_FRAMERATE = 50.0069789081886

local YI = {
  -- Game Modes
  game_mode_overworld = 0x0022,
  game_mode_level = 0x000F,
  
  -- Sprites
  sprite_max = 24,
  ambient_sprite_max = 16
}

local SRAM = {  -- 700000~707FFF
  -- General
	level_timer = 0x1974, -- 2 bytes
	screen_number_to_id = 0x0CAA, -- 128 bytes table
	RNG = 0x1970, -- 2 bytes
  sprite_data_pointer = 0x2600, -- 3 bytes
  sprite_load_status_table = 0x28CA, -- 256 bytes
	sprite_freeze_flag = 0x01B0,
  froggy_stomach_collision = 0x49C7, -- 32 bytes table = 16 words of coordinates

	-- Player
  x = 0x008C, -- 2 bytes
  y = 0x0090, -- 2 bytes
  --previous_x = 0x00d1,
  --previous_y = 0x00d3,
  x_sub = 0x008A,
  y_sub = 0x008E,
  x_speed = 0x00A9,
  x_subspeed = 0x00A8,
  y_speed = 0x00AB,
  y_subspeed = 0x00AA,
  status = 0x00AC, -- 2 bytes
  direction = 0x00C4,
  ground_pound_state = 0x00D4,
  ground_pound_timer = 0x00D6,
  egg_target_x = 0x00E4, -- 2 bytes
  egg_target_y = 0x00E6, -- 2 bytes	
  egg_target_radial_pos = 0x00EF,
  egg_target_radial_subpos = 0x00EE,
  egg_throw_state = 0x00DE,
  egg_throw_state_timer = 0x01E2,
  player_blocked_status = 0x00FC,
  x_centered = 0x011C, -- 2 bytes
  y_centered = 0x011E, -- 2 bytes
  hitbox_half_width = 0x0120,
  hitbox_half_height = 0x0122,
  tongue_x = 0x0152, -- 2 bytes
  tongue_y = 0x0154, -- 2 bytes
  tongue_state = 0x0150,
  tongued_slot = 0x0168, -- 2 bytes, high byte is flag for inedible
  ammo_in_mouth = 0x016A,
	is_frozen = 0x01AE, -- 2 bytes
	on_sprite_platform = 0x01B4,
	egg_inventory_size = 0x1DF6,
	egg_sprite_id = 0x1DF8,
  ducking_state = 0x00C2,
  swimming_state = 0x00C6,
  --is_ducking = 0x0073,
  --p_meter = 0x13e4,
  --take_off = 0x149f,
  --powerup = 0x0019,
  --diving_status = 0x1409,
  --player_animation_trigger = 0x0071,
  --climbing_status = 0x0074,
  --on_ground = 0x13ef,
  --on_ground_delay = 0x008d,
  --on_air = 0x0072,
  --can_jump_from_water = 0x13fa,
  --carrying_item = 0x148f,
  --player_looking_up = 0x13de,
  
  -- Baby Mario
  mario_status = 0x0F00,


  -- Timer
	invincibility_timer = 0x01D6,
	eat_timer = 0x01EE,
	transform_timer = 0x01F4,
	star_timer = 0x1E04,
	
	-- Sprites
	sprite_status = 0x0F00,
	sprite_type = 0x1360,
  sprite_x = 0x10E2, -- 2 bytes
  sprite_y = 0x1182, -- 2 bytes
  sprite_x_sub = 0x10E1,
  sprite_y_sub = 0x1181,
  sprite_x_speed = 0x1221,
  sprite_x_subspeed = 0x1220,
  sprite_y_speed = 0x1223,
  sprite_y_subspeed = 0x1222,
	sprite_hitbox_half_width = 0x1BB6, -- 2 bytes
	sprite_hitbox_half_height = 0x1BB8, -- 2 bytes
	sprite_x_center = 0x1CD6, -- 2 bytes
	sprite_y_center = 0x1CD8, -- 2 bytes
	
  -- Sprite tables (each table consists of 24 groups of 4 bytes)
	sprite_table1 = 0x0F00, -- sprite_status
	sprite_table2 = 0x0FA0,
	sprite_table3 = 0x1040,
	sprite_table4 = 0x10E0, -- sprite_x_sub, sprite_x
	sprite_table5 = 0x1180, -- sprite_y_sub, sprite_y
	sprite_table6 = 0x1220, -- sprite_x_subspeed, sprite_x_speed, sprite_y_subspeed, sprite_y_speed
	sprite_table7 = 0x12C0,
	sprite_table8 = 0x1360, -- sprite_type
	sprite_table9 = 0x1400,
	sprite_table10 = 0x14A0,
	sprite_table11 = 0x1540,
	sprite_table12 = 0x15E0,
	sprite_table13 = 0x1680,
	sprite_table14 = 0x1720,
	sprite_table15 = 0x17C0,
	sprite_table16 = 0x1860,
	sprite_table17 = 0x1900,
	sprite_table18 = 0x1976,
	sprite_table19 = 0x19D6,
	sprite_table20 = 0x1A36,
	sprite_table21 = 0x1A96,
	sprite_table22 = 0x1AF6,
	sprite_table23 = 0x1B56,
	sprite_table24 = 0x1BB6, -- sprite_hitbox_half_width, sprite_hitbox_half_height
	sprite_table25 = 0x1C16, -- 
	sprite_table26 = 0x1C76, -- 
	sprite_table27 = 0x1CD6, -- sprite_x_center, sprite_y_center
	sprite_table28 = 0x1D36,
	sprite_table29 = 0x1D96,
	
	-- Ambient sprites
	ambsprite_status = 0x0EC0, -- 2 bytes, only low is used [table 01]
	ambsprite_type = 0x1320, -- 2 bytes [table 08]
  ambsprite_x = 0x10A2, -- 2 bytes [table 04, second word]
  ambsprite_y = 0x1142, -- 2 bytes [table 05, second word]
  ambsprite_x_sub = 0x10A1, -- 1 byte [table 04, second byte]
  ambsprite_y_sub = 0x1141, -- 1 byte [table 05, second byte]
	
  -- Ambient sprite tables (each table consists of 16 groups of 4 bytes)
	ambsprite_table1 = 0x0EC0,
	ambsprite_table2 = 0x0F60,
	ambsprite_table3 = 0x1000,
	ambsprite_table4 = 0x10A0,
	ambsprite_table5 = 0x1140,
	ambsprite_table6 = 0x11E0,
	ambsprite_table7 = 0x1280,
	ambsprite_table8 = 0x1320,
	ambsprite_table9 = 0x13C0,
	ambsprite_table10 = 0x1460,
	ambsprite_table11 = 0x1500,
	ambsprite_table12 = 0x15A0,
	ambsprite_table13 = 0x1640,
	ambsprite_table14 = 0x16E0,
	ambsprite_table15 = 0x1780,
	ambsprite_table16 = 0x1820,
	ambsprite_table17 = 0x18C0
	
}

local WRAM = {  -- 7E0000~7FFFFF
  -- I/O
  ctrl_1_1 = 0x093D,
  ctrl_1_2 = 0x093C,
  ctrl_1_1_first = 0x093F,
  ctrl_1_2_first = 0x093E,

  -- General
  game_mode = 0x0118,
  frame_counter = 0x0030,
  --effective_frame = 0x0014,
  --lag_indicator = 0x01fe,
  --timer_frame_counter = 0x0f30,
  --RNG = 0x148d,
  --current_level = 0x00fe,  -- plus 1
  --lock_animation_flag = 0x009d, -- Most codes will still run if this is set, but almost nothing will move or animate.
  --level_mode_settings = 0x1925,
  red_coin_counter = 0x03B4, -- 2 bytes
  star_counter = 0x03B6, -- 2 bytes
  flower_counter = 0x03B8, -- 2 bytes
  lives = 0x0379, -- 2 bytes
  coin_counter = 0x037b, -- 2 bytes
  is_paused = 0x0B10,
  Map16_data = 0x18000, -- 32768 bytes table, in words
  level_header = 0x0134, -- 32 bytes table = 16 headers (words), until $0152
  
  -- Cheats
  frozen = 0x13fb,
  level_paused = 0x13d4,
  level_index = 0x021A, -- 2 bytes
  room_index = 0x00ce,
  level_flag_table = 0x1ea2,
  level_exit_type = 0x0dd5,
  midway_point = 0x13ce,

  -- Camera
  camera_x = 0x0039,
  camera_y = 0x003B,
  screens_number = 0x005d,
  hscreen_number = 0x005e,
  vscreen_number = 0x005f,
  vertical_scroll_flag_header = 0x1412,  -- #$00 = Disable; #$01 = Enable; #$02 = Enable if flying/climbing/etc.
  vertical_scroll_enabled = 0x13f1,
  camera_scroll_timer = 0x1401,

  -- Sprites
  toadies_relative_x = 0x0E38,
  toadies_relative_y = 0x0E4A,

  -- Yoshi
  yoshi_riding_flag = 0x187a,  -- #$00 = No, #$01 = Yes, #$02 = Yes, and turning around.
  yoshi_tile_pos = 0x0d8c,

  -- Timers
  --pipe_entrance_timer = 0x0088,
  end_level_timer = 0x1493,
  --multicoin_block_timer = 0x186b,,
  switch_timer = 0x0CEC, -- 2 bytes

  -- Layers
  layer2_x_nextframe = 0x1466,
  layer2_y_nextframe = 0x1468,
}

local SOLID_BLOCKS = { -- solid and one-way solid blocks, via tests
	0x01, 0x02, 0x03, 0x05, 0x06, 0x08, 0x0A, 0x0C, 0x0D, 0x0F,
	0x10, 0x15, 0x1A, 0x1B, 0x1C ,
	0x29, 0x2C, 0x2F,
	0x33, 0x35, 0x38, 0x39, 0x3A, 0x3E, 0x3F,
	0x40, 0x41, 0x44, 0x45, 0x48, 0x49, 0x4B, 0x4C, 0x4E,
	0x50, 0x53, 0x55, 0x57, 0x59, 0x5B, 0x5D, 0x5F,
	0x66, 0x67, 0x6B, 0x6C, 0x6E,
	0x79, 0x7B, 0x7D,
  0x86, 0x88, 0x89, 0x8C, 0x8E, 0x8F,
	0x90, 0x93, 0x94, 0x95, 0x9A, 0x9D, 0x9F,
	0xA0, 0xA1, 0xA2, 0xA3
}

local PLAYER_COLLISION_TERRAIN_POINTS = { -- In (x,y) pairs. Located at $0AEB0E
  regular = {
    0x01, 0x09, 0x01, 0x17, -- left
    0x0F, 0x09, 0x0F, 0x17, -- right
    0x06, 0x04, 0x0A, 0x04, -- top
    0x03, 0x20, 0x08, 0x20, 0x0D, 0x20 -- bottom
  },
  ducking = {
    0x01, 0x16, 0x01, 0x17, -- left
    0x0F, 0x16, 0x0F, 0x17, -- right
    0x06, 0x10, 0x0A, 0x10, -- top
    0x03, 0x20, 0x08, 0x20, 0x0D, 0x20 -- bottom
  },
  swimming = {
    0x01, 0x0C, 0x01, 0x16, -- left
    0x0F, 0x0C, 0x0F, 0x16, -- right
    0x06, 0x04, 0x0A, 0x04, -- top
    0x03, 0x20, 0x08, 0x20, 0x0D, 0x20 -- bottom
  }
}

-- Level sprite data pointers
local SPR_DATA_POINTERS = {
--          00        01        02        03        04        05        06        07        08        09        0A        0B        0C        0D        0E        0F
--[[00]] 0x168583, 0x4CE976, 0x1690B5, 0x14869D, 0x10F4FA, 0x11D2BB, 0x12CF07, 0x15866B, 0x1694A5, 0x12D8E2, 0x1493BF, 0x159245, 0x159D95, 0x15AB8E, 0x15B8F5, 0x14A39B, 
--[[10]] 0x00F614, 0x12DD4A, 0x14AD4A, 0x14B123, 0x14BAE3, 0x11DE77, 0x15C19A, 0x169E75, 0x16A7C0, 0x14C6C6, 0x15C4E2, 0x14D2C1, 0x14DE8F, 0x15CA77, 0x12E8A7, 0x14E794, 
--[[20]] 0x16B3C1, 0x11E767, 0x16C01C, 0x4CF3D9, 0x15D759, 0x14EFF2, 0x15E689, 0x16CBDA, 0x16DD21, 0x12EEC2, 0x4CFD2F, 0x16EF27, 0x12F77D, 0x11F1E1, 0x15F013, 0x12FE33, 
--[[30]] 0x10FCE5, 0x16FEC6, 0x510EEC, 0x14FCB8, 0x15FD47, 0x11FB9F, 0x14FF83, 0x14FF91, 0x16855E, 0x168560, 0x168642, 0x4CEA17, 0x1690D5, 0x14878F, 0x11D34D, 0x12CFBD, 
--[[40]] 0x1586C7, 0x12D91D, 0x1494B7, 0x1592B0, 0x159DC4, 0x15AC4A, 0x15B981, 0x14A4C3, 0x00F625, 0x12DDCA, 0x14AD7C, 0x14B233, 0x14BB57, 0x11DEB5, 0x15C1F0, 0x169E92, 
--[[50]] 0x16A80A, 0x14C5D9, 0x14D377, 0x14DEA0, 0x15CB51, 0x12E915, 0x14E88F, 0x16B480, 0x11E802, 0x16C0BD, 0x4CF43B, 0x15D7D6, 0x14F030, 0x15E6FA, 0x16CCD5, 0x16DDA7, 
--[[60]] 0x12EF99, 0x4CFE27, 0x16EF62, 0x12F7E8, 0x11F288, 0x15F096, 0x12FEC2, 0x10FD92, 0x16FF4C, 0x228FDB, 0x14FD17, 0x15FDA0, 0x11FC22, 0x1691B5, 0x14879A, 0x11D39A, 
--[[70]] 0x1586DE, 0x12D9E8, 0x14951C, 0x1593C9, 0x159E3E, 0x15ACD3, 0x15BA16, 0x14A52E, 0x00F678, 0x14AE44, 0x14BC5E, 0x11DF32, 0x15C258, 0x169F63, 0x16A8A2, 0x14C6C8, 
--[[80]] 0x14D3B8, 0x14DF5C, 0x12EA22, 0x14E909, 0x16B4F1, 0x11E876, 0x16C167, 0x15D868, 0x14F095, 0x15E7A4, 0x16CD9D, 0x16DEAE, 0x12F043, 0x4CFE3B, 0x16EFF4, 0x12F80B, 
--[[90]] 0x11F2F9, 0x15F137, 0x12FF39, 0x10FDA3, 0x16FF96, 0x22906A, 0x14FDF7, 0x15FDC3, 0x11FC93, 0x1487C3, 0x11D3B4, 0x1586E6, 0x12DA1A, 0x159E43, 0x15AD50, 0x15BA30, 
--[[A0]] 0x14A5A5, 0x00F6B3, 0x14AE76, 0x11DFA3, 0x15C2C9, 0x169F74, 0x16A916, 0x14C6CD, 0x14D45F, 0x14E015, 0x12EA2A, 0x16B559, 0x16C172, 0x15D8D6, 0x14F127, 0x15E83C, 
--[[B0]] 0x16CDA8, 0x16DF61, 0x4CFE9A, 0x16F017, 0x12F81F, 0x11F373, 0x10FE9E, 0x14FE86, 0x15FDCE, 0x11FD6A, 0x12DA55, 0x159EBD, 0x15AD64, 0x15BA4A, 0x00F71E, 0x11DFBA, 
--[[C0]] 0x16A963, 0x12EB37, 0x15D8E7, 0x15E886, 0x16F091, 0x10FF39, 0x15FE39, 0x159ED1, 0x00F750, 0x11DFBF, 0x15E8A6, 0x16F097, 0x10FF8F, 0x15FEF3, 0x159F06, 0x00F773,
--[[D0]] 0x11DFC4, 0x15E8DE, 0x16F099, 0x15FF28, 0x00F77B, 0x11DFC9, 0x15FF69, 0x11DFF2, 0x15FE9E, 0x15FEE8, 0x15FFD5, 0x15FFD5, 0x15FF7D, 0x15FFD0
}

local AMBIENT_SPRITE_IDS = {
	0x1BA, 0x1BB, 0x1BC, 0x1BD, 0x1BE, 0x1BF,
	0x1C2, 0x1C3, 0x1C7, 0x1CA, 0x1CC, 0x1CD,
	0x1D1, 0x1D2, 0x1D3, 0x1D4, 0x1D5, 0x1D6, 0x1D8, 0x1D9, 0x1DC, 0x1DD, 0x1DF,
	0x1E0, 0x1E1, 0x1E2, 0x1E4, 0x1E6, 0x1E7, 0x1E8, 0x1E9, 0x1EA, 0x1EB, 0x1EC, 0x1ED, 0x1EE, 0x1EF,
	0x1F0, 0x1F2, 0x1F3, 0x1F5, 0x1F6, 0x1F7, 0x1F8, 0x1F9, 0x1FA, 0x1FB, 0x1FC,
	0x200, 0x201, 0x204, 0x205, 0x206, 0x208, 0x209, 0x20C, 0x20D, 0x20E, 0x20F,
	0x210, 0x211, 0x212, 0x213, 0x214, 0x215, 0x216, 0x217, 0x218, 0x219,
	0x220, 0x221, 0x224, 0x226, 0x227, 0x229, 0x22A, 0x22B, 0x22C, 0x22D, 0x22E
}


--##########################################################################################################################################################
-- SCRIPT UTILITIES:


-- Variables used in various functions
local Cheat = {}  -- family of cheat functions and variables
local Previous = {}
local User_input = INPUT_KEYNAMES
local Tiletable = {}
local Joypad = {}
local Layer1_tiles = {}
local Layer2_tiles = {}
local Is_lagged = nil
local Options_form = {}  -- BizHawk
local Filter_opacity, Filter_color = 0, 0xff000000  -- Snes9x specifc / unlisted color
local Show_player_point_position = false
local Sprites_info = {}  -- keeps track of useful sprite info that might be used outside the main sprite function
local Memory = {} -- family of memory edit functions and variables

-- Initialization of some tables
for i = 0, YI.sprite_max -1 do
  Sprites_info[i] = {}
end

-- Returns the exact chosen digit of a number from the left to the right, in a given base
-- E.g.: read_digit(654321, 2, 10) -> 5; read_digit(0x4B7A, 3, 16) -> 7
local function read_digit(number, digit, base)
  --assert(type(number) == "number" and number >= 0 and number%1 == 0, "Enter an integer number > 0")
  --assert(type(digit) == "number" and digit > 0 and digit%1 == 0, "Enter an integer digit > 0")
  --assert(type(base) == "number" and base > 1 and base%1 == 0, "Enter an integer base > 1")
  
  local copy = number
  local digits_total = 0
  while copy >= 1 do
    copy = math.floor(copy/base)
    digits_total = digits_total + 1
  end
  
  if digit > digits_total then return false end
  
  local result = math.floor(number/base^(digits_total - digit))
  return result%base
end

-- Converts unsigned 16 bit numbers to signed
function signed16(num)
  local maxval = 32768
  if num < maxval then return num else return num - 2*maxval end
end

-- Transform the binary representation of base into a string
-- For instance, if each bit of a number represents a char of base, then this function verifies what chars are on
local function decode_bits(data, base)
  local i = 1
  local size = base:len()
  local direct_concatenation = size <= 45  -- Performance: I found out that the .. operator is faster for 45 operations or less
  local result
  
  if direct_concatenation then
    result = ""
    for ch in base:gmatch(".") do
      if bit.check(data, size - i) then
        result = result .. ch
      else
        result = result .. " "
      end
      i = i + 1
    end
  else
    result = {}
    for ch in base:gmatch(".") do
      if bit.check(data, size-i) then
        result[i] = ch
      else
        result[i] = " "
      end
      i = i + 1
    end
    result = table.concat(result)
  end
  
  return result
end

-- Transform the binary representation of base into a string
-- For instance, if each bit of a number represents a char of base, then this function verifies what chars are on
local function decode_bits_new(data, base)
  local i = 1
  local size = base:len()
  local direct_concatenation = size <= 45  -- Performance: I found out that the .. operator is faster for 45 operations or less
  local result
  
  if direct_concatenation then
    result = ""
    for ch in base:gmatch(".") do
      if bit.check(data, size - i) then
        result = result .. "X"
      else
        result = result .. "o"
      end
      i = i + 1
    end
  else
    result = {}
    for ch in base:gmatch(".") do
      if bit.check(data, size-i) then
        result[i] = "X"
      else
        result[i] = "o"
      end
      i = i + 1
    end
    result = table.concat(result)
  end
  
  return result
end

-- Verify if a point is inside a rectangle with corners (x1, y1) and (x2, y2)
local function is_inside_rectangle(xpoint, ypoint, x1, y1, x2, y2)
  -- From top-left to bottom-right
  if x2 < x1 then
    x1, x2 = x2, x1
  end
  if y2 < y1 then
    y1, y2 = y2, y1
  end

  if xpoint >= x1 and xpoint <= x2 and ypoint >= y1 and ypoint <= y2 then
    return true
  else
    return false
  end
end


local function mouse_onregion(x1, y1, x2, y2)
  -- Reads external mouse coordinates
  local mouse_x = User_input.xmouse
  local mouse_y = User_input.ymouse
  
  return is_inside_rectangle(mouse_x, mouse_y, x1, y1, x2, y2)
end


-- Register a function to be executed on key press or release
-- execution happens in the main loop
local Keys = {}
Keys.press = {}
Keys.release = {}
Keys.down, Keys.up, Keys.pressed, Keys.released = {}, {}, {}, {}
function Keys.registerkeypress(key, fn)
  Keys.press[key] = fn
end
function Keys.registerkeyrelease(key, fn)
  Keys.release[key] = fn
end


local Movie_active, Readonly, Framecount, Lagcount, Rerecords
local Lastframe_emulated, Nextframe
local function bizhawk_status()
  Movie_active = movie.isloaded()  -- BizHawk
  Readonly = movie.getreadonly()  -- BizHawk
  Framecount = movie.length()  -- BizHawk
  Lagcount = emu.lagcount()  -- BizHawk
  Rerecords = movie.getrerecordcount()  -- BizHawk
  Is_lagged = emu.islagged()  -- BizHawk

  -- Last frame info
  Lastframe_emulated = emu.framecount()

  -- Next frame info (only relevant in readonly mode)
  Nextframe = Lastframe_emulated + 1
end


-- Draw an arrow given (x1, y1) and (x2, y2)
local function draw_arrow(x1, y1, x2, y2, color, head)
	
	local angle = math.atan((y2-y1)/(x2-x1)) -- in radians
	
	-- Arrow head
	local head_size = head or 10
	local angle1, angle2 = angle + math.pi/4, angle - math.pi/4 --0.785398163398, angle - 0.785398163398 -- 45° in radians
	local delta_x1, delta_y1 = floor(head_size*math.cos(angle1)), floor(head_size*math.sin(angle1))
	local delta_x2, delta_y2 = floor(head_size*math.cos(angle2)), floor(head_size*math.sin(angle2))
	local head1_x1, head1_y1 = x2, y2 
	local head1_x2, head1_y2 
	local head2_x1, head2_y1 = x2, y2
	local head2_x2, head2_y2
	
	if x1 < x2 then -- 1st and 4th quadrant
		head1_x2, head1_y2 = head1_x1 - delta_x1, head1_y1 - delta_y1
		head2_x2, head2_y2 = head2_x1 - delta_x2, head2_y1 - delta_y2
	elseif x1 == x2 then -- vertical arrow
		head1_x2, head1_y2 = head1_x1 - delta_x1, head1_y1 - delta_y1
		head2_x2, head2_y2 = head2_x1 - delta_x2, head2_y1 - delta_y2
	else
		head1_x2, head1_y2 = head1_x1 + delta_x1, head1_y1 + delta_y1
		head2_x2, head2_y2 = head2_x1 + delta_x2, head2_y1 + delta_y2
	end
	
	-- Draw
	draw_line(x1, y1, x2, y2, color)
	draw_line(head1_x1, head1_y1, head1_x2, head1_y2, color)
	draw_line(head2_x1, head2_y1, head2_x2, head2_y2, color)
end


-- Changes transparency of a color: result is opaque original * transparency level (0.0 to 1.0)
local function change_transparency(color, transparency)
  -- Sane transparency
  if transparency >= 1 then return color end  -- no transparency
  if transparency <= 0 then return 0 end   -- total transparency

  -- Sane colour
  if color == 0 then return 0 end
  if type(color) ~= "number" then
    print(color)
    error"Wrong color"
  end

  local a = floor(color/0x1000000)
  local rgb = color - a*0x1000000
  local new_a = floor(a*transparency)
  return new_a*0x1000000 + rgb
end


-- returns the (x, y) position to start the text and its length:
-- number, number, number text_position(x, y, text, font_width, font_height[[[[, always_on_client], always_on_game], ref_x], ref_y])
-- x, y: the coordinates that the refereed point of the text must have
-- text: a string, don't make it bigger than the buffer area width and don't include escape characters
-- font_width, font_height: the sizes of the font
-- always_on_client, always_on_game: boolean
-- ref_x and ref_y: refer to the relative point of the text that must occupy the origin (x,y), from 0% to 100%
--                  for instance, if you want to display the middle of the text in (x, y), then use 0.5, 0.5
local function text_position(x, y, text, font_width, font_height, always_on_client, always_on_game, ref_x, ref_y)
  -- Reads external variables
  local buffer_left     = OPTIONS.left_gap
  local buffer_right    = Border_right_start
  local buffer_top      = OPTIONS.top_gap
  local buffer_bottom   = Border_bottom_start
  local screen_left     = 0
  local screen_right    = Screen_width
  local screen_top      = 0
  local screen_bottom   = Screen_height
  
  -- text processing
  local text_length = text and string.len(text)*font_width or font_width  -- considering another objects, like bitmaps
  
  -- actual position, relative to game area origin
  x = (not ref_x and x) or (ref_x == 0 and x) or x - floor(text_length*ref_x)
  y = (not ref_y and y) or (ref_y == 0 and y) or y - floor(font_height*ref_y)
  
  -- adjustment needed if text is supposed to be on screen area
  local x_end = x + text_length
  local y_end = y + font_height
  
  if always_on_game then
    if x < buffer_left then x = buffer_left end
    if y < buffer_top then y = buffer_top end
    
    if x_end > buffer_right  then x = buffer_right  - text_length end
    if y_end > buffer_bottom then y = buffer_bottom - font_height end
    
  elseif always_on_client then
    if x < screen_left + 1 then x = screen_left + 1 end -- +1 to avoid printing touching the screen border
    if y < screen_top + 1 then y = screen_top + 1 end
    
    if x_end > screen_right - 1  then x = screen_right  - text_length - 1 end -- -1 to avoid printing touching the screen border
    if y_end > screen_bottom - 1 then y = screen_bottom - font_height - 1 end
  end
  
  return x, y, text_length
end


-- Complex function for drawing, that uses text_position
local function draw_text(x, y, text, ...)
  -- Reads external variables
  local font_width  = BIZHAWK_FONT_WIDTH
  local font_height = BIZHAWK_FONT_HEIGHT
  local bg_default_color = COLOUR.background
  local text_color, bg_color, always_on_client, always_on_game, ref_x, ref_y
  local arg1, arg2, arg3, arg4, arg5, arg6 = ...
  
  if not arg1 or arg1 == true then
    
    text_color = COLOUR.text
    bg_color = bg_default_color
    always_on_client, always_on_game, ref_x, ref_y = arg1, arg2, arg3, arg4
    
  elseif not arg2 or arg2 == true then
    
    text_color = arg1
    bg_color = bg_default_color
    always_on_client, always_on_game, ref_x, ref_y = arg2, arg3, arg4, arg5
    
  else
    
    text_color, bg_color = arg1, arg2
    always_on_client, always_on_game, ref_x, ref_y = arg3, arg4, arg5, arg6
    
  end
  
  local x_pos, y_pos, length = text_position(x, y, text, font_width, font_height, always_on_client, always_on_game, ref_x, ref_y)

  text_color = change_transparency(text_color, Text_opacity)
  
  --gui.drawText(x_pos, y_pos, text, text_color) --, bg_color) -- TODO FOR REAL
  
  gui.text(Scale_x*x_pos, Scale_y*y_pos, text, text_color) --, bg_color) -- TODO FOR REAL
  
  return x_pos + length, y_pos + font_height, length
end


local function alert_text(x, y, text, text_color, bg_color, always_on_game, ref_x, ref_y)
  -- Reads external variables
  local font_width  = BIZHAWK_FONT_WIDTH
  local font_height = BIZHAWK_FONT_HEIGHT
  
  local x_pos, y_pos, text_length = text_position(x, y, text, font_width, font_height, true, always_on_game, ref_x, ref_y)
  
  text_color = change_transparency(text_color, Text_opacity)
  
  draw_rectangle(x_pos, y_pos, text_length - 1, font_height - 1, bg_color, bg_color)
  
  gui.text(Scale_x*x_pos, Scale_y*y_pos, text, text_color)
end


local function draw_over_text(x, y, value, base, color_base, color_value, color_bg, always_on_client, always_on_game, ref_x, ref_y)
  value = decode_bits(value, base)
  local x_end, y_end, length = draw_text(x, y, base,  color_base, color_bg, always_on_client, always_on_game, ref_x, ref_y)
  --gui.opacity(Text_max_opacity * Text_opacity)
  gui.text(x_end - length, y_end - BIZHAWK_FONT_HEIGHT, value, color_value or COLOUR.text)
  --gui.opacity(1.0)
  
  return x_end, y_end, length
end


-- Returns frames-time conversion
local function frame_time(frame)
  if not NTSC_FRAMERATE then error("NTSC_FRAMERATE undefined."); return end
  
  local total_seconds = frame/NTSC_FRAMERATE
  local hours = floor(total_seconds/3600)
  local tmp = total_seconds - 3600*hours
  local minutes = floor(tmp/60)
  tmp = tmp - 60*minutes
  local seconds = floor(tmp)
  
  local miliseconds = 1000* (total_seconds%1)
  if hours == 0 then hours = "" else hours = string.format("%d:", hours) end
  local str = string.format("%s%.2d:%.2d.%03.0f", hours, minutes, seconds, miliseconds)
  return str
end


-- Background opacity functions
local function increase_opacity()
  if Text_max_opacity <= 0.9 then Text_max_opacity = Text_max_opacity + 0.1
  else
    if Background_max_opacity <= 0.9 then Background_max_opacity = Background_max_opacity + 0.1 end
  end
end


local function decrease_opacity()
  if  Background_max_opacity >= 0.1 then Background_max_opacity = Background_max_opacity - 0.1
  else
    if Text_max_opacity >= 0.1 then Text_max_opacity = Text_max_opacity - 0.1 end
  end
end


-- displays a button everytime in (x,y)
-- object can be a text or a dbitmap
-- if user clicks onto it, fn is executed once
local Script_buttons = {}
local function create_button(x, y, object, fn, extra_options)
  local always_on_client, always_on_game, ref_x, ref_y, button_pressed
  if extra_options then
    always_on_client, always_on_game, ref_x, ref_y, button_pressed =
    extra_options.always_on_client, extra_options.always_on_game, extra_options.ref_x, extra_options.ref_y, extra_options.button_pressed
  end
  
  local width, height
  local object_type = type(object)
  
  if object_type == "string" then
    width, height = BIZHAWK_FONT_WIDTH, BIZHAWK_FONT_HEIGHT
    x, y, width = text_position(x, y, object, width, height, always_on_client, always_on_game, ref_x, ref_y)
  elseif object_type == "boolean" then
    width, height = BIZHAWK_FONT_WIDTH, BIZHAWK_FONT_HEIGHT
    x, y = text_position(x, y, nil, width, height, always_on_client, always_on_game, ref_x, ref_y)
  else error"Type of buttton not supported yet"
  end
  
  -- draw the button
  if button_pressed then
    draw_rectangle(x, y, width, height, "white", 0xffd8d8d8)  -- unlisted colours
  else
    draw_rectangle(x, y, width, height, 0xff606060, 0xffb0b0b0)
  end
  gui.line(x, y, x + width, y, button_pressed and 0xff606060 or "white")
  gui.line(x, y, x, y + height, button_pressed and 0xff606060 or "white")
  
  if object_type == "string" then
    gui.text(x + 1, y + 1, object, COLOUR.button_text, 0)
  elseif object_type == "boolean" then
    draw_rectangle(x + 1, y + 1, width - 2, height - 2, 0x8000ff00, 0xc000ff00)
  end
  
  -- updates the table of buttons
  table.insert(Script_buttons, {x = x, y = y, width = width, height = height, object = object, action = fn})
end


-- Gets input of the 1st controller / Might be deprecated someday...
local Joypad = {}
local function get_joypad()
  Joypad = joypad.get(1)
  for button, status in pairs(Joypad) do
    Joypad[button] = status and 1 or 0
  end
end

-- ############################################################
-- From gocha's

local pad_max = 2
local pad_press, pad_down, pad_up, pad_prev, pad_send = {}, {}, {}, {}, {}
local pad_presstime = {}
for player = 1, pad_max do
  pad_press[player] = {}
  pad_presstime[player] = { start=0, select=0, up=0, down=0, left=0, right=0, A=0, B=0, X=0, Y=0, L=0, R=0 }
end

local dev_press, dev_down, dev_up, dev_prev = input.get(), {}, {}, {}
local dev_presstime = {
  xmouse=0, ymouse=0, leftclick=0, rightclick=0, middleclick=0,
  shift=0, control=0, alt=0, capslock=0, numlock=0, scrolllock=0,
  ["0"]=0, ["1"]=0, ["2"]=0, ["3"]=0, ["4"]=0, ["5"]=0, ["6"]=0, ["7"]=0, ["8"]=0, ["9"]=0,
  A=0, B=0, C=0, D=0, E=0, F=0, G=0, H=0, I=0, J=0, K=0, L=0, M=0, N=0, O=0, P=0, Q=0, R=0, S=0, T=0, U=0, V=0, W=0, X=0, Y=0, Z=0,
  F1=0, F2=0, F3=0, F4=0, F5=0, F6=0, F7=0, F8=0, F9=0, F10=0, F11=0, F12=0,
  F13=0, F14=0, F15=0, F16=0, F17=0, F18=0, F19=0, F20=0, F21=0, F22=0, F23=0, F24=0,
  backspace=0, tab=0, enter=0, pause=0, escape=0, space=0,
  pageup=0, pagedown=0, ["end"]=0, home=0, insert=0, delete=0,
  left=0, up=0, right=0, down=0,
  numpad0=0, numpad1=0, numpad2=0, numpad3=0, numpad4=0, numpad5=0, numpad6=0, numpad7=0, numpad8=0, numpad9=0,
  ["numpad*"]=0, ["numpad+"]=0, ["numpad-"]=0, ["numpad."]=0, ["numpad/"]=0,
  tilde=0, plus=0, minus=0, leftbracket=0, rightbracket=0,
  semicolon=0, quote=0, comma=0, period=0, slash=0, backslash=0
}

-- Scan button presses
function scanJoypad()
  for i = 1, pad_max do
    pad_prev[i] = copytable(pad_press[i])
    pad_press[i] = joypad.get(i)
    pad_send[i] = copytable(pad_press[i])
    -- scan keydowns, keyups
    pad_down[i] = {}
    pad_up[i] = {}
    for k in pairs(pad_press[i]) do
      pad_down[i][k] = (pad_press[i][k] and not pad_prev[i][k])
      pad_up[i][k] = (pad_prev[i][k] and not pad_press[i][k])
    end
    -- count press length
    for k in pairs(pad_press[i]) do
      if not pad_press[i][k] then
        pad_presstime[i][k] = 0
      else
        pad_presstime[i][k] = pad_presstime[i][k] + 1
      end
    end
  end
end
-- Scan keyboard/mouse input
local function scanInputDevs()
  dev_prev = copytable(dev_press)
  dev_press = input.get()
  -- scan keydowns, keyups
  dev_down = {}
  dev_up = {}
  for k in pairs(dev_presstime) do
    dev_down[k] = (dev_press[k] and not dev_prev[k])
    dev_up[k] = (dev_prev[k] and not dev_press[k])
  end
  -- count press length
  for k in pairs(dev_presstime) do
    if not dev_press[k] then
      dev_presstime[k] = 0
    else
      dev_presstime[k] = dev_presstime[k] + 1
    end
  end
end
-- Send button presses
function sendJoypad()
    for i = 1, pad_max do
      joypad.set(i, pad_send[i])
    end
end



--#############################################################################
-- YI FUNCTIONS:


local Frame_counter, Effective_frame, Game_mode
local Level_index, Room_index, Sprite_data_pointer, Level_flag
local Is_paused, Lock_animation_flag, Player_powerup, Player_animation_trigger
local Camera_x, Camera_y, Yoshi_x, Yoshi_y
local function scan_yi()
  Frame_counter = u16_wram(WRAM.frame_counter)
  Game_mode = u16_wram(WRAM.game_mode)
  Is_paused = u8_wram(WRAM.is_paused) == 1
  Level_index = u16_wram(WRAM.level_index)
  
  Sprite_data_pointer = u24_sram(SRAM.sprite_data_pointer)
  for i = 1, #SPR_DATA_POINTERS do
    if Sprite_data_pointer == SPR_DATA_POINTERS[i] then
      Room_index = i - 1
      break
    end
  end
  
  -- In level frequently used info
  Camera_x = s16_wram(WRAM.camera_x)
  Camera_y = s16_wram(WRAM.camera_y)
	Yoshi_x = s16_sram(SRAM.x)
	Yoshi_y = s16_sram(SRAM.y)
end


-- Converts the in-game (x, y) to BizHawk-screen coordinates
local function screen_coordinates(x, y, camera_x, camera_y)
  -- Sane values
  camera_x = camera_x or Camera_x or s16_wram(WRAM.camera_x)
  camera_y = camera_y or Camera_y or s16_wram(WRAM.camera_y)
  
  -- Math
  local x_screen = (x - camera_x) + OPTIONS.left_gap
  local y_screen = (y - camera_y) + OPTIONS.top_gap
  
  return x_screen, y_screen
end


-- Converts BizHawk/emu-screen coordinates to in-game (x, y)
local function game_coordinates(x_emu, y_emu, camera_x, camera_y)
  -- Sane values
  camera_x = camera_x or Camera_x
  camera_y = camera_y or Camera_y

  -- Math
  local x_game = x_emu + camera_x - OPTIONS.left_gap
  local y_game = y_emu + camera_y - OPTIONS.top_gap

  return x_game, y_game
end


-- Returns the extreme values that Yoshi needs to have in order to NOT touch a rectangular object
local function display_boundaries(x_game, y_game, width, height, camera_x, camera_y)
  -- Font
  Text_opacity = 0.8
  Bg_opacity = 0.4
  
  -- Coordinates around the rectangle
  local left = x_game --width*floor(x_game/width)
  local top = y_game --height*floor(y_game/height)
  left, top = screen_coordinates(left, top, camera_x, camera_y)
  local right = left + width - 1
  local bottom = top + height - 1
  
  -- Left
  local left_text = string.format("%04X.ff", width*floor(x_game/width) - 16)
  draw_text(left, (top+bottom)/2, left_text, false, false, 1.0, 0.5)
  
  -- Right
  local right_text = string.format("%04X.01", width*floor(x_game/width) + 15)
  draw_text(right + 2, (top+bottom)/2, right_text, false, false, 0.0, 0.5)
  
  -- Top
  local value = (Yoshi_riding_flag and y_game - 16) or y_game
  local top_text = fmt("%04X.ff", width*floor(value/width) - 32)
  draw_text((left+right)/2, top, top_text, false, false, 0.5, 1.0)
  
  -- Bottom
  value = y_game + height - 4 --height*floor(y_game/height) - 3
  local bottom_text = fmt("%04X.ff", value)
  draw_text((left+right)/2, bottom + 1, bottom_text, false, false, 0.5, 0.0)
  
  return left, top
end


-- Draw tile (16x16) grid, tile types and screen grid
local function draw_tile_map(camera_x, camera_y)
	local valid_game_mode = false
	if Game_mode == YI.game_mode_level then valid_game_mode = true
	elseif Game_mode == 0x000B then valid_game_mode = true end -- Level transition
	if not valid_game_mode then return end
  
	if not OPTIONS.draw_tile_map_type and not OPTIONS.draw_tile_map_grid and not OPTIONS.draw_tile_map_screen then return end
	
  local x_origin, y_origin = screen_coordinates(0, 0, camera_x, camera_y)
  
	Text_opacity = 1.0
  local block_colour
  
  local width = 256
	local height = 128
	local block_x, block_y
	local x_pos, y_pos
	local x_screen, y_screen
	local screen_number, screen_id
	local block_id
	local kind_low, kind_high
	local player_screen_region_x = floor(Yoshi_x/256) 
	local player_screen_region_y = floor(Yoshi_y/256)
	for screen_region_y = 0, 7 do		
		if screen_region_y >= player_screen_region_y - 1 and screen_region_y <= player_screen_region_y + 1 then -- to not scan the whole level
		
			for screen_region_x = 0, 15 do
				if screen_region_x >= player_screen_region_x - 1 and screen_region_x <= player_screen_region_x + 1 then -- to not scan the whole level
				
					screen_number = screen_region_y*16 + screen_region_x
					screen_id = bit.band(u8_sram(SRAM.screen_number_to_id + screen_number), 0x7f) -- to exclude high bit (handles special object xFE)
					
          if screen_id ~= 0x80 then -- avoid reading garbage from screens that are not used
            
            for block_y = 0, 15 do
              y_pos = y_origin + 256*screen_region_y + 16*block_y
              
              
              for block_x = 0, 15 do
                x_pos = x_origin + 256*screen_region_x + 16*block_x
                x_screen, y_screen = screen_coordinates(x_pos, y_pos, camera_x, camera_y)
                x_screen = x_screen + camera_x
                y_screen = y_screen + camera_y
                
                block_id = 256*screen_id + 16*block_y + block_x
                
                if x_pos >= -16 and x_pos <= Screen_width + 16 and y_pos >= -16 and y_pos <= Screen_height + 16 then -- to print only what's inside the emu screen
            
                  kind_low = u8_wram(WRAM.Map16_data + 2*block_id)
                  kind_high = u8_wram(WRAM.Map16_data + 2*block_id + 1)
                  
                  -- Tile type
                  if OPTIONS.draw_tile_map_type then
                    draw_text(x_pos + 2, y_pos + 1, fmt("%02X\n%02X", kind_high, kind_low), COLOUR.blank_tile)
                  end
                  
                  -- Grid
                  if OPTIONS.draw_tile_map_grid then
                    
                    local block_is_solid = false
                    for i = 1, #SOLID_BLOCKS do
                      if kind_high == SOLID_BLOCKS[i] then
                        block_is_solid = true
                        break
                      end
                    end
                    
                    if block_is_solid then
                      block_colour = COLOUR.block
                    else
                      block_colour = COLOUR.blank_tile
                    end
                    
                    draw_rectangle(x_pos, y_pos, 15, 15, block_colour, 0)
                  end
                end
              end
            end
            
            -- Screen
            if OPTIONS.draw_tile_map_screen then
              Text_opacity = 0.8
            
              x_pos = x_origin + 256*screen_region_x
              y_pos = y_origin + 256*screen_region_y
              
              draw_rectangle(x_pos, y_pos, 10*BIZHAWK_FONT_WIDTH + 2, 8, COLOUR.warning_transparent, COLOUR.warning_transparent)
              
              draw_text(x_pos + 2, y_pos + 1, fmt("Screen $%02X", screen_id), COLOUR.text)
            
              draw_rectangle(x_pos, y_pos, 255, 255, COLOUR.warning_transparent, 0)
            end
          end
        end
			end
		end
	end	
end


local function draw_tiles_clicked(camera_x, camera_y)
	if Game_mode ~= YI.game_mode_level then return end
	if not OPTIONS.draw_tiles_with_click then return end

  local x_mouse, y_mouse = game_coordinates(User_input.xmouse + OPTIONS.left_gap, User_input.ymouse + OPTIONS.top_gap, camera_x, camera_y)
  x_mouse = 16*floor((x_mouse)/16)
  y_mouse = 16*floor((y_mouse)/16)

  local block_colour
  
  local x_origin, y_origin = screen_coordinates(0, 0, camera_x, camera_y)

  for number, positions in ipairs(Tiletable) do
    -- Calculate the BizHawk coordinates
    local left = positions[1] + x_origin
    local top = positions[2] + y_origin
    local right = left + 15
    local bottom = top + 15
    local x_game, y_game = game_coordinates(left, top, camera_x, camera_y)
    
    -- Returns if block is way too outside the screen
    if left > -16 and top  > -16 and right < Screen_width + 16 and bottom < Screen_height + 16 then
      
      --draw_rectangle(left, top, 15, 15, COLOUR.block, 0)

      -- Math
      --local num_x, num_y, kind_low, kind_high, address_low, address_high = get_map16_value(x_game, y_game)

      local screen_region_x = floor(x_game/256) 
      local screen_region_y = floor(y_game/256)
      
      local screen_number = screen_region_y*16 + screen_region_x
      local screen_id = u8_sram(SRAM.screen_number_to_id + screen_number)
      
      local block_x = (x_game%256)/16
      local block_y = (y_game%256)/16
      
      local block_id = 256*screen_id + 16*block_y + block_x
      
      local kind_low = u8_wram(WRAM.Map16_data + 2*block_id)
      local kind_high = u8_wram(WRAM.Map16_data + 2*block_id + 1)
      
      -- Drawings
      local block_is_solid = false
      for i = 1, #SOLID_BLOCKS do
        if kind_high == SOLID_BLOCKS[i] then
          block_is_solid = true
          break
        end
      end
      
      if OPTIONS.draw_tile_map_grid then -- to make it easier to see when grid is activated
        block_colour = COLOUR.warning_soft -- this color fits well
      elseif block_is_solid then
        block_colour = COLOUR.block
      else
        block_colour = COLOUR.blank_tile
      end
      
      draw_rectangle(left, top, 15, 15, block_colour, 0)
      
      if Tiletable[number][3] then
        display_boundaries(x_game, y_game, 16, 16, camera_x, camera_y) -- the text around it
      end
      
      -- Draw Map16 id
      if x_mouse == positions[1] and y_mouse == positions[2] then
        Text_opacity = 0.8
        
        draw_text(left + 6, top - 16, fmt("block %03X", block_id), true, false, 0.5, 1.0)
        draw_text(left + 6, top - 8, fmt("type: %02X %02X", kind_high, kind_low), true, false, 0.5, 1.0)
      end
    end
  end
end


-- if the user clicks in a tile, it will be be drawn
-- if click is onto drawn region, it'll be erased
-- there's a max of possible tiles
-- layer_table[n] is an array {x, y, [draw info?]}
local function select_tile()
  if not OPTIONS.draw_tiles_with_click then return end
  if Game_mode ~= YI.game_mode_level then return end
  
  local x_mouse, y_mouse = game_coordinates(User_input.xmouse + OPTIONS.left_gap, User_input.ymouse + OPTIONS.top_gap, Camera_x, Camera_y)
  x_mouse = 16*floor(x_mouse/16)
  y_mouse = 16*floor(y_mouse/16)
  
  for number, positions in ipairs(Tiletable) do  -- if mouse points a drawn tile, erase it
    if x_mouse == positions[1] and y_mouse == positions[2] then
      if Tiletable[number][3] == false then
        Tiletable[number][3] = true
      else
        table.remove(Tiletable, number)
      end
      
      return
    end
  end
  
  -- otherwise, draw a new tile
  if #Tiletable == OPTIONS.max_tiles_drawn then
    table.remove(Tiletable, 1)
    Tiletable[OPTIONS.max_tiles_drawn] = {x_mouse, y_mouse, false}
  else
    table.insert(Tiletable, {x_mouse, y_mouse, false})
  end
  
end


-- uses the mouse to select an object
local function select_object(mouse_x, mouse_y, camera_x, camera_y)
  -- Font
  Text_opacity = 1.0
  Bg_opacity = 0.5
  
  local x_game, y_game = game_coordinates(mouse_x + OPTIONS.left_gap, mouse_y + OPTIONS.top_gap, camera_x, camera_y)
  local obj_id
  
  if not obj_id and OPTIONS.display_sprite_info then
    for id = 0, YI.sprite_max - 1 do
      local sprite_status = u8_sram(SRAM.sprite_status + 4*id)
      if sprite_status ~= 0 then
        -- Import some values
        local x_centered, y_centered = Sprites_info[id].x_centered, Sprites_info[id].y_centered
        local half_width, half_height = Sprites_info[id].sprite_half_width, Sprites_info[id].sprite_half_height
        
        -- Exception for sprites with no hitboxes
        if half_width < 4 then half_width = 4 end
        if half_height < 4 then half_height = 4 end
        
        -- Check hitbox
        if x_game >= x_centered - half_width and x_game <= x_centered + half_width and
        y_game >= y_centered - half_height and y_game <= y_centered + half_height then
          obj_id = id
          break
        end
      end
    end
  end
  
  if not obj_id then return end
  
  draw_text(User_input.xmouse, User_input.ymouse - 8, obj_id, true, false, 0.5, 1.0)
  return obj_id, x_game, y_game
end


-- This function sees if the mouse if over some object, to change its hitbox mode
-- The order is: 1) player, 2) sprite.
local function right_click()
    local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    
    if tostring(id) == "Yoshi" then
        
        if OPTIONS.display_player_hitbox and OPTIONS.display_interaction_points then
            OPTIONS.display_interaction_points = false
            OPTIONS.display_player_hitbox = false
        elseif OPTIONS.display_player_hitbox then
            OPTIONS.display_interaction_points = true
            OPTIONS.display_player_hitbox = false
        elseif OPTIONS.display_interaction_points then
            OPTIONS.display_player_hitbox = true
        else
            OPTIONS.display_player_hitbox = true
        end
        
    end
    if id then return end
    
    -- Select layer 2 tiles -- TODO
    --[[local layer2x = s16_wram(WRAM.layer2_x_nextframe)
    local layer2y = s16_wram(WRAM.layer2_y_nextframe)
    local x_mouse, y_mouse = User_input.xmouse + layer2x, User_input.ymouse + layer2y
    select_tile(16*floor(x_mouse/16), 16*floor(y_mouse/16), Layer2_tiles)]]
end


local function show_movie_info()
  if not OPTIONS.display_movie_info then return end
  
  -- Font
  Text_opacity = 1.0
  Bg_opacity = 1.0
  local y_text = 2
  local x_text = 2
  local width = BIZHAWK_FONT_WIDTH
  
  local rec_color = (Readonly or not Movie_active) and COLOUR.text or COLOUR.warning
  local recording_bg = (Readonly or not Movie_active) and COLOUR.background or COLOUR.warning_bg 
  
  -- Read-only or read-write?
  local movie_type = (not Movie_active and "No movie ") or (Readonly and "Movie " or "REC ")
  alert_text(x_text, y_text, movie_type, rec_color, recording_bg)
  
  -- Frame count
  x_text = x_text + width*string.len(movie_type)
  local movie_info
  if Readonly then
      movie_info = string.format("%d/%d", Lastframe_emulated, Framecount)
  else
      movie_info = string.format("%d", Lastframe_emulated)
  end
  draw_text(x_text, y_text, movie_info)  -- Shows the latest frame emulated, not the frame being run now
  x_text = x_text + width*string.len(movie_info)
  
  -- Rerecord count
  local rr_info = string.format(" %d ", Rerecords)
  draw_text(x_text, y_text, rr_info, COLOUR.weak)
  x_text = x_text + width*string.len(rr_info)
  
  -- Lag count
  draw_text(x_text, y_text, Lagcount, COLOUR.warning)
  
  local str = frame_time(Lastframe_emulated)    -- Shows the latest frame emulated, not the frame being run now
  alert_text(Screen_width, Screen_height, str, COLOUR.text, recording_bg, false, 1.0, 1.0)    
end


local function show_misc_info()
  if not OPTIONS.display_misc_info then return end
  
  -- Font
  Text_opacity = 1.0
  Bg_opacity = 1.0
	
	-- Display
	local RNG = u16_sram(SRAM.RNG)
	draw_text(Screen_width, 0, fmt("RNG:$%04X  Game mode:$%04X", RNG, Game_mode), true)
	
  local camera_str = fmt("Camera (%04X, %04X)", Camera_x, Camera_y)
  draw_text(Buffer_middle_x, OPTIONS.top_gap - 2, camera_str, true, false, 0.5)
	
	if Game_mode ~= YI.game_mode_level or Is_paused then return end
  
	local star_counter = u16_wram(WRAM.star_counter)
	local red_coin_counter = u8_wram(WRAM.red_coin_counter)
	local flower_counter = u8_wram(WRAM.flower_counter)
	local coin_counter = u8_wram(WRAM.coin_counter)
  local life_counter = u16_wram(WRAM.lives)
	local star_effective = math.floor(star_counter/10)
  
	local temp_str
	local x_temp, y_temp = OPTIONS.left_gap, 1
  
  draw_image("images\\star_icon.png", x_temp, y_temp)
	temp_str = fmt("%d/30(%d)", star_effective, star_counter)
	x_temp = draw_text(x_temp + 17, y_temp + BIZHAWK_FONT_HEIGHT/2, temp_str, COLOUR.weak, true) + 8
	
  draw_image("images\\red_coin_icon.png", x_temp, y_temp)
	temp_str = fmt("%d/20", red_coin_counter)
	x_temp = draw_text(x_temp + 17, y_temp + BIZHAWK_FONT_HEIGHT/2, temp_str, COLOUR.weak, true) + 8
	
  draw_image("images\\flower_icon.png", x_temp, y_temp)
	temp_str = fmt("%d/5", flower_counter)
	x_temp = draw_text(x_temp + 17, y_temp + BIZHAWK_FONT_HEIGHT/2, temp_str, COLOUR.weak, true) + 8
	
  draw_image("images\\coin_icon.png", x_temp, y_temp)
	temp_str = fmt("%d", coin_counter)
	x_temp = draw_text(x_temp + 17, y_temp + BIZHAWK_FONT_HEIGHT/2, temp_str, COLOUR.weak, true) + 8
	
  draw_image("images\\yoshi_icon.png", x_temp, y_temp)
	temp_str = fmt("%d", life_counter)
	x_temp = draw_text(x_temp + 17, y_temp + BIZHAWK_FONT_HEIGHT/2, temp_str, COLOUR.weak, true) + 8
end


-- Display mouse coordinates right above it
local function show_mouse_info()
	if not OPTIONS.display_mouse_coordinates then return end
	
	-- Font
  Text_opacity = 0.8
  Bg_opacity = 0.5
	local line_colour = COLOUR.weak
  local bg_colour = change_transparency(COLOUR.background, Bg_opacity)
  
	local x, y = User_input.xmouse + OPTIONS.left_gap, User_input.ymouse + OPTIONS.top_gap
	local x_game, y_game = game_coordinates(x, y, Camera_x, Camera_y)
	if x_game < 0 then x_game = 0x10000 + x_game end
	if y_game < 0 then y_game = 0x10000 + y_game end
	
	if User_input.mouse_inwindow then
		-- Lines
    draw_line(0, y, Screen_width, y, line_colour)
    draw_line(x, 0, x, Screen_height, line_colour)
    draw_cross(x, y, 3, "cyan")
    -- Coordinates
    alert_text(x, y - 9, fmt("emu ($%X, $%X)", x, y), COLOUR.text, bg_colour, false, 0.5) -- TODO: fix negative hex values
		alert_text(x, y + 9, fmt("game ($%02X, $%X)", x_game, y_game), COLOUR.text, bg_colour, false, 0.5)
	end
end


-- Shows the controller input as the RAM and SNES registers store it
local function show_controller_data()
  if not (OPTIONS.display_debug_info and OPTIONS.display_debug_controller_data) then return end
  
  -- Font
  Text_opacity = 0.9
  local height = BIZHAWK_FONT_HEIGHT
  local x_pos, y_pos, x, y, _ = 0, 0, 0, BIZHAWK_FONT_HEIGHT
  
  x = x_pos
  x = draw_over_text(x, y, 256*u8_wram(WRAM.ctrl_1_1) + u8_wram(WRAM.ctrl_1_2), "BYsS^v<>AXLR0123", COLOUR.weak)
  _, y = draw_text(x, y, " (RAM data)", COLOUR.weak, false, true)
  
  x = x_pos
  draw_over_text(x, y, 256*u8_wram(WRAM.ctrl_1_1_first) + u8_wram(WRAM.ctrl_1_2_first), "BYsS^v<>AXLR0123", 0, "#0xffff", 0) -- Snes9x
end


local function level_info()
  if not OPTIONS.display_level_info then return end
	if Game_mode ~= YI.game_mode_level then return end
  
  -- Font
  local color = COLOUR.text
  Text_opacity = 0.5
  Bg_opacity = 1.0
  
  
  --- Current level, converts the level index to the game level number
	local world_number = floor(Level_index/12) + 1
  local level_number = fmt("%d", Level_index%12 + 1)
	if level_number == "9" then level_number = "E" end -- Extra levels
  local level_str = fmt("Level:$%02X (%d - %s)", Level_index, world_number, level_number)
  
	--- Current room/translevel
  local room_str = fmt("Room:$%02X", Room_index)
	
	--- Current screen
	local screen_number, screen_id
	local x_player_simp = 256*floor(Yoshi_x/256)
	local y_player_simp = 256*floor(Yoshi_y/256)
	for screen_region_y = 0, 7 do
		for screen_region_x = 0, 15 do
			if x_player_simp == 256*screen_region_x and y_player_simp == 256*screen_region_y then -- player current screen
        screen_number = screen_region_y*16 + screen_region_x
        screen_id = u8_sram(SRAM.screen_number_to_id + screen_number)
				break
			end
		end
	end
  local screen_str = fmt("Screen:$%02X", screen_id and screen_id or 0x80)
	
  --- Draw whole level info string
  draw_text(Buffer_middle_x, Screen_height, fmt("%s %s %s", level_str, room_str, screen_str), color, true, false, 0.5)
  
	--- Extra help/info
	if OPTIONS.display_level_help then
  
		-- Naval Piranha boss activation line
		if Room_index == 0x7F then
    
			local line_x_screen, _ = screen_coordinates(0x0300, 0, Camera_x, Camera_y)
			local yoshi_x = Yoshi_x
			local yoshi_x_screen, _ = screen_coordinates(yoshi_x, 0, Camera_x, Camera_y)
			local fight_activated = u8_wram(0x008F)
			
			if fight_activated == 0 then
				if yoshi_x < 0x0300 then -- activation check in $05A5F2
					draw_line(line_x_screen, 0, line_x_screen, 224, COLOUR.warning) -- red
				end
				if yoshi_x >= 0x02BC then -- Yoshi is close
					draw_line(yoshi_x_screen, 0, yoshi_x_screen, 224, COLOUR.positive) -- green					
				end
			end
		
    -- Sluggy The Unshaven boss activation line
    elseif Room_index == 0x8A then
      
      local line_x_screen, _ = screen_coordinates(0x0231, 0, Camera_x, Camera_y)
      local yoshi_center_x = s16_sram(SRAM.x_centered)
			local yoshi_center_x_screen, _ = screen_coordinates(yoshi_center_x, 0, Camera_x, Camera_y)
			local fight_activated = u8_wram(0x003E) -- address serves for this
			
			if fight_activated == 0 then
				if yoshi_center_x < 0x0231 then -- didn't reach yet
					draw_line(line_x_screen, OPTIONS.top_gap, line_x_screen, Border_bottom_start, COLOUR.warning) -- red
					draw_line(yoshi_center_x_screen, OPTIONS.top_gap, yoshi_center_x_screen, Border_bottom_start, COLOUR.positive) -- green
				end
			end
    
    -- Prince Froggy's boss activation line
    elseif Room_index == 0xBF then
      
      local line_x_screen, _ = screen_coordinates(0x0149, 0, Camera_x, Camera_y)
      local yoshi_center_x = s16_sram(SRAM.x_centered)
			local yoshi_center_x_screen, _ = screen_coordinates(yoshi_center_x, 0, Camera_x, Camera_y)
			local fight_activated = u8_wram(0x0042) -- address serves for this
			
			if fight_activated == 0 then
				if yoshi_center_x < 0x149 then -- didn't reach yet
					draw_line(line_x_screen, OPTIONS.top_gap, line_x_screen, Border_bottom_start, COLOUR.warning) -- red
					draw_line(yoshi_center_x_screen, OPTIONS.top_gap, yoshi_center_x_screen, Border_bottom_start, COLOUR.positive) -- green
				end
			end
      
    
    end
	end
	
end

-- Display sprite spawning areas (vertical lines for horizontal spawning)
local function draw_sprite_spawning_areas()
  if not OPTIONS.display_sprite_spawning_areas then return end
  if Game_mode ~= YI.game_mode_level or Is_paused then return end
  
  local left_line, right_line = 63, 32

  -- Left area
  draw_line(OPTIONS.left_gap - left_line, 0, OPTIONS.left_gap - left_line, Screen_height, COLOUR.weak)
  draw_line(OPTIONS.left_gap - left_line + 15, 0, OPTIONS.left_gap - left_line + 15, Screen_height, COLOUR.very_weak)

  draw_text(OPTIONS.left_gap - left_line + 3, Screen_height - 2*BIZHAWK_FONT_HEIGHT, fmt("Spawn \n %04X", Camera_x - left_line), COLOUR.weak, false, false, 0.5)
  
  -- Right area
  draw_line(Border_right_start + right_line, 0, Border_right_start + right_line, Screen_height, COLOUR.weak)
  draw_line(Border_right_start + right_line - 15, 0, Border_right_start + right_line - 15, Screen_height, COLOUR.very_weak)

  draw_text(Border_right_start + right_line + 2, Screen_height - 2*BIZHAWK_FONT_HEIGHT, fmt("Spawn \n%04X", Camera_x + 256 + right_line), COLOUR.weak)
end

-- Display Yoshi's blocked status
function draw_blocked_status(x_text, y_text, player_blocked_status, x_speed, y_speed)
  local bitmap_width  = 25
  local bitmap_height = 30
  local block_str = "Blocked:"
  local str_len = string.len(block_str)
  local xoffset = x_text + str_len*BIZHAWK_FONT_WIDTH
  local yoffset = y_text + 2
  local colour_set = COLOUR.warning
  
  draw_text(x_text, y_text, block_str, COLOUR.text)
  
  -- Yoshi image
  draw_image("images\\yoshi_blocked_status.png", xoffset + 4, yoffset)
  
  -- Bits image
  draw_image("images\\blocked_status_bits.png", xoffset, yoffset - 4)
  
	-- Bottom (right)
  if bit.check(player_blocked_status, 0) then
    draw_rectangle(xoffset + 21, yoffset + bitmap_height + 1, 6, 1, colour_set)
  end
  -- Bottom (middle)
  if bit.check(player_blocked_status, 1) then
    draw_rectangle(xoffset + 13, yoffset + bitmap_height + 1, 6, 1, colour_set)
  end
	-- Bottom (left)
  if bit.check(player_blocked_status, 2) then
    draw_rectangle(xoffset + 5, yoffset + bitmap_height + 1, 6, 1, colour_set)
  end
  
	-- Top (right)
  if bit.check(player_blocked_status, 3) then
    draw_rectangle(xoffset + 17, yoffset - 3, 10, 1, colour_set)
  end
	-- Top (left)
  if bit.check(player_blocked_status, 4) then
    draw_rectangle(xoffset + 5, yoffset - 3, 10, 1, colour_set)
  end
  
	-- Right (body)
  if bit.check(player_blocked_status, 5) then
    draw_rectangle(xoffset + bitmap_width + 5, yoffset + 15, 1, 13, colour_set)
  end
	-- Right (head)
  if bit.check(player_blocked_status, 6) then
    draw_rectangle(xoffset + bitmap_width + 5, yoffset + 1, 1, 12, colour_set)
  end
  
	-- Left (body)
  if bit.check(player_blocked_status, 7) then
    draw_rectangle(xoffset + 1, yoffset + 15, 1, 13, colour_set)
  end
	-- Left (head)
  if bit.check(player_blocked_status, 8) then
    draw_rectangle(xoffset + 1, yoffset + 1, 1, 12, colour_set)
  end
  
	-- Fully inside the ground
  if player_blocked_status == 0x1ff then  
    draw_line(xoffset + 3, yoffset + floor(bitmap_height/2) - 1, xoffset + bitmap_width + 2, yoffset + floor(bitmap_height/2) - 1, colour_set)
    draw_line(xoffset + floor(bitmap_width/2) + 3, yoffset, xoffset + floor(bitmap_width/2) + 3, yoffset + bitmap_height - 1, colour_set)
  end	
end


-- Displays player's hitbox
local function player_hitbox(x, y, x_centered, y_centered, tongue_x_screen, tongue_y_screen)
  local x_centered_screen, y_centered_screen = screen_coordinates(x_centered, y_centered, Camera_x, Camera_y)
  local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)

  -- Hitbox (collision with sprites)
  if OPTIONS.display_player_hitbox then
    
    local half_width = u16_sram(SRAM.hitbox_half_width)
    local half_height = u16_sram(SRAM.hitbox_half_height)
    
    draw_box(x_centered_screen - half_width, y_centered_screen - half_height, x_centered_screen + half_width - 1, y_centered_screen + half_height - 1, COLOUR.mario, COLOUR.mario_bg)
    
  end
  
  
  -- Interaction points (collision with blocks)
  if OPTIONS.display_interaction_points then
    
		-- Background for block interaction
		draw_box(x_screen - 2, y_screen + 1, x_screen + 18, y_screen + 34, COLOUR.interaction_nohitbox, COLOUR.interaction_nohitbox_bg)
		
    local colour = COLOUR.interaction
    
    local curr_solid_collision_points = PLAYER_COLLISION_TERRAIN_POINTS.regular
    --local is_ducking = u8_sram(SRAM.ducking_state) > 0
    --local is_swimming = u8_sram(SRAM.swimming_state) > 0
    if u8_sram(SRAM.ducking_state) > 0 then curr_solid_collision_points = PLAYER_COLLISION_TERRAIN_POINTS.ducking end
    if u8_sram(SRAM.swimming_state) > 0 then curr_solid_collision_points = PLAYER_COLLISION_TERRAIN_POINTS.swimming end
    
    local x_table, y_table = {}, {}
    for i = 1, #curr_solid_collision_points, 2 do -- Divide the collision table that has (x, y) into 2 separated tables, for x and y
      
      x_table[(i+1)/2] = curr_solid_collision_points[i]
      y_table[(i+1)/2] = curr_solid_collision_points[i+1]
      
      --[[
      local x = curr_solid_collision_points[i]
      local y = curr_solid_collision_points[i+1]
      
      if (i-1)/2 == 8 then -- REMOVE
        draw_text(x_screen + x + 2, y_screen + y, (i+1)/2, "cyan") -- REMOVE
      elseif (i-1)/2 == 7 then -- REMOVE
        draw_text(x_screen + x - 1, y_screen + y + 1, (i+1)/2, "cyan") -- REMOVE
      elseif (i-1)/2 == 6 then -- REMOVE
        draw_text(x_screen + x - 4, y_screen + y, (i+1)/2, "cyan") -- REMOVE
      elseif (i-1)/2 == 5 or (i-1)/2 == 3 or (i-1)/2 == 2 then -- REMOVE
        draw_text(x_screen + x + 2, y_screen + y - 3, (i+1)/2, "cyan") -- REMOVE
      else -- REMOVE
        draw_text(x_screen + x - 4, y_screen + y - 3, (i+1)/2, "cyan") -- REMOVE ---- (i+1)/2
      end -- REMOVE]]
    end
    
		--- Horizontal lines
		
		-- Feet
    draw_line(x_screen + x_table[7], y_screen + y_table[7] - 1, x_screen + x_table[9], y_screen + y_table[9] - 1, colour)
		
		-- Shoulders
    draw_line(x_screen + x_table[1], y_screen + y_table[1], x_screen + x_table[1] + 2, y_screen + y_table[1], colour)
    draw_line(x_screen + x_table[3], y_screen + y_table[3], x_screen + x_table[3] - 2, y_screen + y_table[3], colour)
		
		-- "Knees"
    draw_line(x_screen + x_table[2], y_screen + y_table[2], x_screen + x_table[2] + 2, y_screen + y_table[2], colour)
    draw_line(x_screen + x_table[4], y_screen + y_table[4], x_screen + x_table[4] - 2, y_screen + y_table[4], colour)
		
		-- Head
    draw_line(x_screen + x_table[5], y_screen + y_table[5], x_screen + x_table[6], y_screen + y_table[6], colour)	
		
		--- Vertical lines
		
		-- Body
    draw_line(x_screen + x_table[1], y_screen + y_table[1], x_screen + x_table[2], y_screen + y_table[2], colour)
    draw_line(x_screen + x_table[3], y_screen + y_table[3], x_screen + x_table[4], y_screen + y_table[4], colour)	
		
		-- Feet
    draw_line(x_screen + x_table[7], y_screen + y_table[7] - 1, x_screen + x_table[7], y_screen + y_table[7] - 3, colour)
    draw_line(x_screen + x_table[8], y_screen + y_table[8] - 1, x_screen + x_table[8], y_screen + y_table[8] - 3, colour)
    draw_line(x_screen + x_table[9], y_screen + y_table[9] - 1, x_screen + x_table[9], y_screen + y_table[9] - 3, colour)
		
		-- Head
    draw_line(x_screen + x_table[5], y_screen + y_table[5], x_screen + x_table[5], y_screen + y_table[5] + 2, colour)
    draw_line(x_screen + x_table[6], y_screen + y_table[6], x_screen + x_table[6], y_screen + y_table[6] + 2, colour)
		
	end
 
	
	-- Tongue hitbox
	if OPTIONS.display_tongue_hitbox then
		local tongue_state = u8_sram(SRAM.tongue_state)
		local ammo_in_mouth = u8_sram(SRAM.ammo_in_mouth)
		local sprite_in_mouth = false
		for i = 0, YI.sprite_max - 1 do
			if Sprites_info[i].sprite_status == 0x08 then sprite_in_mouth = true end
		end
		
		if tongue_state ~= 0 and tongue_state < 5 and ammo_in_mouth == 0  then
			draw_box(tongue_x_screen - 14, tongue_y_screen - 10, tongue_x_screen + 13, tongue_y_screen + 9, COLOUR.positive)
		end
    
    draw_cross(tongue_x_screen, tongue_y_screen, 2, COLOUR.positive)
	end
  
  --[[
	local x_test, y_test = s16_sram(0x0156), s16_sram(0x0158) -- REMOVE
	local x_test2, y_test2 = screen_coordinates(s16_sram(0x015A), s16_sram(0x015C), Camera_x, Camera_y) -- REMOVE
	draw_cross(x_test, y_test, 2, "blue") -- REMOVE
	draw_cross(x_test2, y_test2, 2, "white") -- REMOVE
	draw_box(x_test, y_test, x_test2, y_test2, "yellow") -- REMOVE]]
	
	
	--[[
  -- That's the pixel that appears when Mario dies in the pit
  Show_player_point_position = Show_player_point_position or y_screen >= 200 or
    (OPTIONS.display_debug_info and OPTIONS.display_debug_player_extra)
  if Show_player_point_position then
    draw_rectangle(x_screen - 1, y_screen - 1, 2, 2, COLOUR.interaction_bg, COLOUR.text)
    Show_player_point_position = false
  end]]
  
  return x_points, y_points
end


local function egg_throw_info(egg_target_x, egg_target_y, direction, x_centered, y_centered, x_screen, y_screen)
	if Is_paused then return end
	
	--- Memory reading
	local egg_target_radial_pos = u8_sram(SRAM.egg_target_radial_pos)
	local egg_target_radial_subpos = u8_sram(SRAM.egg_target_radial_subpos)
	local egg_throw_state = u8_sram(SRAM.egg_throw_state)
	local egg_throw_state_timer = u8_sram(SRAM.egg_throw_state_timer)
	
	--- Transformations
	local egg_throw_origin_x, egg_throw_origin_y -- found with tests
	if direction == RIGHT_ARROW then
		egg_throw_origin_x = x_centered - 2
		egg_throw_origin_y = y_centered - 20
	else
		egg_throw_origin_x = x_centered - 14
		egg_throw_origin_y = y_centered - 20
	end	
	
	local target_delta_x, target_delta_y = egg_target_x - egg_throw_origin_x, egg_target_y - egg_throw_origin_y
	local extended_target_x, extended_target_y =  egg_target_x + target_delta_x, egg_target_y - target_delta_y
	
	local egg_throw_effective_timer -- found with tests and math
	if egg_throw_state == 10 then egg_throw_effective_timer = 27
	elseif egg_throw_state == 9 then egg_throw_effective_timer = 26
	elseif egg_throw_state == 8 then egg_throw_effective_timer = 3*egg_throw_state + egg_throw_state_timer - 1
	elseif egg_throw_state == 7 then egg_throw_effective_timer = 23
	elseif egg_throw_state == 6 then egg_throw_effective_timer = 3*egg_throw_state + egg_throw_state_timer
	elseif egg_throw_state == 5 then egg_throw_effective_timer = 3*egg_throw_state + egg_throw_state_timer
	elseif egg_throw_state == 4 then egg_throw_effective_timer = 15
	elseif egg_throw_state == 3 then egg_throw_effective_timer = 14
	elseif egg_throw_state == 2 then egg_throw_effective_timer = 13
	elseif egg_throw_state == 1 then egg_throw_effective_timer = egg_throw_state_timer
	elseif egg_throw_state == 0 then egg_throw_effective_timer = egg_throw_state_timer -- or egg_throw_state
	end

	local egg_target_x_screen, egg_target_y_screen = screen_coordinates(egg_target_x, egg_target_y, Camera_x, Camera_y)
	local egg_throw_origin_x_screen, egg_throw_origin_y_screen = screen_coordinates(egg_throw_origin_x, egg_throw_origin_y, Camera_x, Camera_y)

	local radius = floor(sqrt(target_delta_x^2 + target_delta_y^2))
	
	--- Prints
	
	-- Target
	if egg_throw_effective_timer == 18 then
		draw_arrow(egg_throw_origin_x_screen, egg_throw_origin_y_screen, egg_target_x_screen, egg_target_y_screen, COLOUR.warning_soft)
		draw_cross(egg_target_x_screen, egg_target_y_screen, 2, "blue")
		draw_text(egg_target_x_screen, egg_target_y_screen + 16, fmt("%02d.%02x", egg_target_radial_pos, egg_target_radial_subpos), COLOUR.positive)
    end
    
	-- Radius
	if egg_throw_effective_timer == 18 then
		--draw_text(egg_target_x_screen + 8, egg_target_y_screen, fmt("%d", radius), COLOUR.positive) -- REMOVE
		if direction == RIGHT_ARROW then
			for i = -pi/2, 5*pi/18, pi/80 do
				draw_pixel(egg_throw_origin_x_screen + cos(i)*(68) , egg_throw_origin_y_screen + sin(i)*(68), COLOUR.text)
			--draw_text(0, 150 + i*10*BIZHAWK_FONT_HEIGHT, fmt("sin:%f cos:%f", sin(i), cos(i)), COLOUR.text) -- REMOVE
			end
		else
			for i = 13*pi/18, 3*pi/2, pi/80 do
				draw_pixel(egg_throw_origin_x_screen + cos(i)*(68) , egg_throw_origin_y_screen + sin(i)*(68), COLOUR.text)
			--draw_text(0, 150 + i*10*BIZHAWK_FONT_HEIGHT, fmt("sin:%f cos:%f", sin(i), cos(i)), COLOUR.text) -- REMOVE
			end		
		end
	end
	
	-- Extended target
	if egg_throw_effective_timer == 18 then
		draw_arrow(egg_target_x_screen, egg_target_y_screen,
					egg_target_x_screen + 2*target_delta_x, egg_target_y_screen + 2*target_delta_y, COLOUR.blank_tile)
    end
	
	-- Timer
	if OPTIONS.display_debug_player_extra and egg_throw_effective_timer ~= 0 then
		alert_text(x_screen + 4, y_screen - 16, fmt(" %d ", egg_throw_effective_timer), COLOUR.positive, COLOUR.warning_bg)
	end
end

local function egg_inventory_info()
	if Is_paused then return end
	
	local egg_inventory_size = u8_sram(SRAM.egg_inventory_size)/2
	local egg_sprite_id, egg_type, egg_type_str, sprite_status
	
	local info_colour = COLOUR.text
	local x_pos = 2
	local y_pos = Screen_height - 6*BIZHAWK_FONT_HEIGHT
	draw_text(x_pos, y_pos - BIZHAWK_FONT_HEIGHT, fmt("Egg inventory: %d", egg_inventory_size), COLOUR.weak)
	
	for id = 0, egg_inventory_size - 1 do
		egg_sprite_id = u8_sram(SRAM.egg_sprite_id + 2*id)
		egg_type = u16_sram(SRAM.sprite_type + egg_sprite_id)
		--sprite_status = u16_sram(SRAM.sprite_status + egg_sprite_id)
		
		if egg_type == 0x022 then egg_type_str = "flashing"
		elseif egg_type == 0x023 then egg_type_str = "red"
		elseif egg_type == 0x024 then egg_type_str = "yellow"
		elseif egg_type == 0x025 then egg_type_str = "green"
		elseif egg_type == 0x026 then egg_type_str = "giant (bowser)"
		elseif egg_type == 0x027 then egg_type_str = "key"
		elseif egg_type == 0x028 then egg_type_str = "huffin'"
		elseif egg_type == 0x029 then egg_type_str = "giant (froggy)"
		elseif egg_type == 0x02A then egg_type_str = "red giant"
		elseif egg_type == 0x02B then egg_type_str = "green giant"
		else egg_type_str = "null egg"
		end
		--if sprite_status == 0 then egg_type_str = "null egg" end
		
		egg_sprite_id = egg_sprite_id/4
    
		if egg_type_str == "null egg" then
			info_colour = COLOUR.positive
      
      draw_text(x_pos, y_pos + id*BIZHAWK_FONT_HEIGHT, fmt("%d:  <%02d> %03X", id, egg_sprite_id, egg_type), info_colour)
      draw_image_region("images\\egg_icons.png", 80, 0, 8, 8, x_pos + 2*BIZHAWK_FONT_WIDTH + 1, y_pos + id*BIZHAWK_FONT_HEIGHT)
		else
			info_colour = COLOUR.text
      
      draw_text(x_pos, y_pos + id*BIZHAWK_FONT_HEIGHT, fmt("%d:  <%02d>", id, egg_sprite_id), info_colour)
      draw_image_region("images\\egg_icons.png", (egg_type - 0x22)*8, 0, 8, 8, x_pos + 2*BIZHAWK_FONT_WIDTH + 1, y_pos + id*BIZHAWK_FONT_HEIGHT)
		end
	end
end

local function player()
  if not OPTIONS.display_player_info then return end
	if Is_paused then return end
	
	local valid_game_mode = false
	if Game_mode == YI.game_mode_level then valid_game_mode = true
	elseif Game_mode == 0x0007 then valid_game_mode = true -- Intro (0x0007) too
	elseif Game_mode == 0x000B then valid_game_mode = true -- Level transition too
	elseif Game_mode == 0x0010 then valid_game_mode = true end -- Level end (0x0010) too
	if valid_game_mode == false then return end
	
  -- Font
  Text_opacity = 1.0
  
  -- Reads SRAM and maybe WRAM
  local x = Yoshi_x
  local y = Yoshi_y
  local x_sub = u8_sram(SRAM.x_sub)
  local y_sub = u8_sram(SRAM.y_sub)
  local x_speed = s8_sram(SRAM.x_speed)
  local x_subspeed = u8_sram(SRAM.x_subspeed)
  local y_speed = s8_sram(SRAM.y_speed)
  local y_subspeed = u8_sram(SRAM.y_subspeed)
  local status = u16_sram(SRAM.status)
  local direction = u8_sram(SRAM.direction)
  local ground_pound_timer = u8_sram(SRAM.ground_pound_timer)
  local ground_pound_state = u8_sram(SRAM.ground_pound_state)
  local player_blocked_status = u16_sram(SRAM.player_blocked_status)
  local on_sprite_platform = u16_sram(SRAM.on_sprite_platform)
  local x_centered = s16_sram(SRAM.x_centered)
  local y_centered = s16_sram(SRAM.y_centered)
  local tongue_x = s16_sram(SRAM.tongue_x)
  local tongue_y = s16_sram(SRAM.tongue_y)
  local tongued_slot = u8_sram(SRAM.tongued_slot)
  local egg_target_x = s16_sram(SRAM.egg_target_x)
  local egg_target_y = s16_sram(SRAM.egg_target_y)
	
	--draw_text(100, 190, fmt(" delta x = %d \n delta_y = %d", x_centered - x, y_centered - y), COLOUR.memory) -- REMOVE TESTS/DEBUG
	
  -- Transformations
  if direction == 0 then direction = RIGHT_ARROW else direction = LEFT_ARROW end
	local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	local x_centered_screen, y_centered_screen = screen_coordinates(x_centered, y_centered, Camera_x, Camera_y)
	local tongue_x_screen, tongue_y_screen = screen_coordinates(tongue_x + x_centered, tongue_y + y_centered, Camera_x, Camera_y)
	local x_display = x < 0 and fmt("-%04X", 0xFFFFFFFF - x + 1) or fmt("%04X", x) -- position in HEXADECIMAL
	local y_display = y < 0 and fmt("-%04X", 0xFFFFFFFF - y + 1) or fmt("%04X", y) -- position in HEXADECIMAL
  
  --- Table
  local i = 0
  local delta_x = BIZHAWK_FONT_WIDTH
  local delta_y = BIZHAWK_FONT_HEIGHT
  local table_x = 2
  local table_y = OPTIONS.top_gap
	local temp_colour, x_spd_str, y_spd_str
  
  --draw_text(table_x, table_y + i*delta_y, fmt("Pos (%+d.%02x, %+d.%02x) %s", x, x_sub, y, y_sub, direction)) -- position in DECIMAL
  draw_text(table_x, table_y + i*delta_y, fmt("Pos (%s.%02x, %s.%02x) %s", x_display, x_sub, y_display, y_sub, direction)) -- position in HEXADECIMAL
  i = i + 1
  
	if x_speed < 0 then -- corretions for negative horizontal speed
		x_speed = x_speed + 1
		x_subspeed = 0x100 - x_subspeed
		if x_subspeed == 0x100 then x_subspeed = 0 ; x_speed = x_speed - 1 end
		if x_speed == 0 then x_spd_str = fmt("-%d.%02x", x_speed, x_subspeed) -- force negative signal due to previous math
		else x_spd_str = fmt("%d.%02x", x_speed, x_subspeed) end
	else
		x_spd_str = fmt("%+d.%02x", x_speed, x_subspeed)
	end
	if y_speed < 0 then -- corretions for negative vertical speed
		y_speed = y_speed + 1
		y_subspeed = 0x100 - y_subspeed
		if y_subspeed == 0x100 then y_subspeed = 0 ; y_speed = y_speed - 1 end
		if y_speed == 0 then y_spd_str = fmt("-%d.%02x", y_speed, y_subspeed) -- force negative signal due to previous math
		else y_spd_str = fmt("%d.%02x", y_speed, y_subspeed) end
	else
		y_spd_str = fmt("%+d.%02x", y_speed, y_subspeed)
	end
	draw_text(table_x, table_y + i*delta_y, "Speed (" .. x_spd_str .. ", " .. y_spd_str .. ")")
  i = i + 1
  
  draw_text(table_x, table_y + i*delta_y, fmt("Target (%+d, %+d)", egg_target_x, egg_target_y))
	i = i + 1
	
	draw_text(table_x, table_y + i*delta_y, fmt("Status: $%02X", status))
	i = i + 1
	
	--draw_text(table_x, table_y + i*delta_y, fmt("Center (%+d, %+d)", x_centered, y_centered)) -- REMOVE maybe
	--i = i + 1
	
	local can_jump -- block or sprite
	if bit.check(player_blocked_status, 0) or bit.check(player_blocked_status, 1) or bit.check(player_blocked_status, 2) or on_sprite_platform ~= 0 then
		can_jump = "yes"
		temp_colour = COLOUR.positive
	else
		can_jump = "no"
		temp_colour = COLOUR.warning
	end
	draw_text(table_x, table_y + i*delta_y, fmt("Can jump:"))
	draw_text(table_x + 9*delta_x + 2, table_y + i*delta_y, fmt("%s", can_jump), temp_colour)
	i = i + 1  
	
	if OPTIONS.display_blocked_status then
		draw_blocked_status(table_x, table_y + i*delta_y + 2, player_blocked_status, x_speed, y_speed)
		i = i + 2.5*Scale_y
	end
  
  draw_text(table_x, table_y + i*delta_y, fmt("Tongue (%+d, %+d)", tongue_x, tongue_y), COLOUR.counter_swallow)
	i = i + 1
	if tongued_slot ~= 0 then
		local tongued_type = u16_sram(SRAM.sprite_type + tongued_slot - 1)
		draw_text(table_x, table_y + i*delta_y, fmt("Slot <%02d>, ID %03X", (tongued_slot - 1)/4, tongued_type), COLOUR.counter_swallow)
	else
		draw_text(table_x, table_y + i*delta_y, fmt("Slot <-->, ID ---", (tongued_slot - 1)/4, 0), COLOUR.weak2)
	end
	i = i + 1
	
	--draw_text(table_x, table_y + i*delta_y, fmt("Center (%+d, %+d)", x_centered, y_centered)) -- REMOVE maybe
	i = i + 1
	
	--- Other info
	
	if OPTIONS.display_debug_player_extra and ground_pound_timer ~= 0 and ground_pound_timer ~= 255 and ground_pound_state == 0 then
		alert_text(x_screen + 4, y_screen + 40, fmt(" %d ", ground_pound_timer), COLOUR.positive, COLOUR.warning_bg)
	end
	
  -- Shows hitbox, interaction points, and tongue hitbox for player
	player_hitbox(x, y, x_centered, y_centered, tongue_x_screen, tongue_y_screen)
	
	-- Egg throw info
  if OPTIONS.display_throw_info then
		egg_throw_info(egg_target_x, egg_target_y, direction, x_centered, y_centered, x_screen, y_screen)
	end
	
	-- Egg stack info
  if OPTIONS.display_egg_info then
		egg_inventory_info()
	end
	
	
	if OPTIONS.display_debug_player_extra then
		draw_cross(x_screen, y_screen, 2, COLOUR.text)
		draw_cross(x_screen, y_screen - 31, 2, COLOUR.memory)
		draw_cross(x_centered_screen, y_centered_screen, 2, COLOUR.memory)
	end
  
  --[[ DEBUG
  local ground_type_names = {"Ground", "Water", "????", "Ice", "Snow", "Mud"}
  local ground_type = u16_sram(0x00FA)
  if ground_type == 0x0002 or ground_type > 0x0005 then
    draw_text(table_x, table_y + i*delta_y + 20, fmt("Ground type: %02X !!!!!!!!!!!!!!!!!!!!", ground_type), COLOUR.warning)
  else
    draw_text(table_x, table_y + i*delta_y + 20, fmt("Ground type: %02X (%s)", ground_type, ground_type_names[ground_type+1]), COLOUR.text)
  end
  --w16_sram(0x00FA, 0x00FF)]] 
  
end


local function ambient_sprites()
  if not OPTIONS.display_ambient_sprite_info then return end
	if Is_paused then return end
	
	local valid_game_mode = false
	if Game_mode == YI.game_mode_level then valid_game_mode = true
	elseif Game_mode == 0x0007 then valid_game_mode = true -- Intro (0x0007) too
	elseif Game_mode == 0x0010 then valid_game_mode = true end -- Level end (0x0010) too
	if valid_game_mode == false then return end
    
    -- Font
    Text_opacity = 1.0
    local height = BIZHAWK_FONT_HEIGHT
    
    local y_pos = Scale_y*24
    local counter = 0
    for id = 0, YI.ambient_sprite_max - 1 do
	
		local id_off = 4*id
	
        local ambspr_status = u8_sram(SRAM.ambsprite_status + id_off) -- usually $0E for active
        
        if ambspr_status ~= 0 then
			
			---**********************************************
			-- Reads SRAM addresses
			
			local ambspr_type = u16_sram(SRAM.ambsprite_type + id_off)
      local x = s16_sram(SRAM.ambsprite_x + id_off) -- TODO: change address names
      local y = s16_sram(SRAM.ambsprite_y + id_off)
      local x_sub = u8_sram(SRAM.ambsprite_x_sub + id_off)
      local y_sub = u8_sram(SRAM.ambsprite_y_sub + id_off)
      --local x_speed = s8_sram(SRAM.ambsprite_table6 + id_off)
      --local y_speed = s8_sram(SRAM.ambsprite_table6 + id_off + 2)
            
			---**********************************************
			-- Display
			
			-- Calculates the ambient sprites screen positions
			local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
			
			-- Calculates the correct color to use, according to id
			local ambspr_color = COLOUR.sprites[id%(#COLOUR.sprites) + 1] -- TODO: change
			
			-- Adjusts the opacity if it's offscreen
			if x_screen >= OPTIONS.left_gap and x_screen <= Border_right_start and y_screen >= OPTIONS.top_gap and y_screen <= Border_bottom_start then
				Text_opacity = 0.8
			else
				Text_opacity = 0.5
			end
			
			---**********************************************
			-- Prints
			
			-- Table
			--local ambspr_string = fmt("<%.2d> %.2X (%d.%02x(%+.2d), %d.%02x(%+.2d))", id, ambspr_type, x, x_sub, x_speed, y, y_sub, y_speed)
			
			local debug_str = ""
			local debug_address = 0x1E4C
			local debug_str = fmt("[%02X,%02X,%02X,%02X] ", u8_sram(debug_address + 0 + id_off), u8_sram(debug_address + 1 + id_off),
                                                      u8_sram(debug_address + 2 + id_off), u8_sram(debug_address + 3 + id_off)) -- REMOVE TESTS/DEBUG
			--if ambspr_type == 0x1E1 then w16(debug_address + id_off, 0x90FF) end -- REMOVE TESTS/DEBUG
			--w16_sram(debug_address + id_off, 0xFF) -- REMOVE TESTS/DEBUG
			
			local ambspr_string = fmt("<%.2d> %.4X %s(%d.%02x, %d.%02x)", id, ambspr_type, debug_str, x, x_sub, y, y_sub)
			if OPTIONS.display_ambient_sprite_table then
				draw_text(Screen_width, y_pos + counter*height, ambspr_string, ambspr_color, true, false)
			end
		
			-- Prints information next to the exteded sprite
			if OPTIONS.display_ambient_sprite_slot_in_screen then
				draw_text(x_screen + 6, y_screen - 5, fmt("<%02d>", id), ambspr_color, COLOUR.background, COLOUR.halo, true)
			end
		
			-- Ambient sprite position pixel and cross
			draw_pixel(x_screen, y_screen, ambspr_color)
			if OPTIONS.display_debug_ambient_sprite then
				draw_cross(x_screen, y_screen, 2, ambspr_color)
			end
            
			-- Alert of new ambient sprite (for documentation purposes)
			local new_ambsprite = true
			for i = 1, #AMBIENT_SPRITE_IDS do
				if ambspr_type == AMBIENT_SPRITE_IDS[i] then
					new_ambsprite = false
					break
				end
			end
			if new_ambsprite then
				local new_id_str = fmt(" NEW ID!!! %3X in <%.2d> ", ambspr_type, id)
				alert_text(Buffer_middle_x - floor(4*string.len(new_id_str)/2), 190, new_id_str, COLOUR.warning, COLOUR.warning_bg)
				draw_box(x_screen - 4, y_screen - 4, x_screen + 20, y_screen + 20, COLOUR.warning)
			end
			
			---**********************************************
			-- Save occurrences
			--local occurr_file = io.open("Ambient sprites occurrences.txt", "w")
			-- gui.gdscreenshot() RETURN SCREENSHOT AS A STRING
			
			
			
			--[[
            if (OPTIONS.display_debug_info and OPTIONS.display_debug_ambient_sprite) or not UNINTERESTING_ambient_sprites[ambspr_number]
                or (ambspr_number == 1 and ambspr_table2 == 0xf)
            then
                local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
                
                local t = HITBOX_EXTENDED_SPRITE[ambspr_number] or
                    {xoff = 0, yoff = 0, width = 16, height = 16, color_line = COLOUR.awkward_hitbox, color_bg = COLOUR.awkward_hitbox_bg}
                local xoff = t.xoff
                local yoff = t.yoff
                local xrad = t.width
                local yrad = t.height
                
                local color_line = t.color_line or COLOUR.ambient_sprites
                local color_bg = t.color_bg or COLOUR.ambient_sprites_bg
                if ambspr_number == 0x5 or ambspr_number == 0x11 then
                    color_bg = (Frame_counter - id_off)%4 == 0 and COLOUR.special_ambient_sprite_bg or 0
                end
                draw_rectangle(x_screen+xoff, y_screen+yoff, xrad, yrad, color_line, color_bg) -- regular hitbox
            end]]
            
            counter = counter + 1
        end
    end
    
    Text_opacity = 0.5
    local x_pos, y_pos, length = draw_text(Screen_width, y_pos, fmt("Ambient sprites:%2d ", counter), COLOUR.weak, true, false, 0.0, 1.0)
    
	--[[
    if u8_wram(WRAM.spinjump_flag) ~= 0 and u8_wram(WRAM.powerup) == 3 then
        local fireball_timer = u8_wram(WRAM.spinjump_fireball_timer)
        draw_text(x_pos - length - BIZHAWK_FONT_WIDTH, y_pos, fmt("%d %s",
        fireball_timer%16, bit.check(fireball_timer, 4) and RIGHT_ARROW or LEFT_ARROW), COLOUR.ambient_sprites, true, false, 1.0, 1.0)
    end]]
    
end


Pinwheel_counter = 0

local function sprite_info(id, counter, table_position)
  Text_opacity = 1.0
	
	-- id to read memory correctly
	local id_off = 4*id
	
  local sprite_status = u8_sram(SRAM.sprite_status + id_off)
  if sprite_status == 0 then return 0 end  -- returns if the slot is empty -- TODO: make an option if the player wants all visible slots or only active

  local sprite_type = u16_sram(SRAM.sprite_type + id_off)
  local x = s16_sram(SRAM.sprite_x + id_off)
  local x_sub = u8_sram(SRAM.sprite_x_sub + id_off)
  local y = s16_sram(SRAM.sprite_y + id_off)
  local y_sub = u8_sram(SRAM.sprite_y_sub + id_off)
  local x_speed = s8_sram(SRAM.sprite_x_speed + id_off)
  local x_subspeed = u8_sram(SRAM.sprite_x_subspeed + id_off)
  local y_speed = s8_sram(SRAM.sprite_y_speed + id_off)
  local y_subspeed = u8_sram(SRAM.sprite_y_subspeed + id_off)
  local x_centered = s16_sram(SRAM.sprite_x_center + id_off)
  local y_centered = s16_sram(SRAM.sprite_y_center + id_off)
  local special_hitbox = false
  
  local special = ""
  --[[if (OPTIONS.display_debug_info and OPTIONS.display_debug_sprite_extra) or
  ((sprite_status ~= 0x8 and sprite_status ~= 0x9 and sprite_status ~= 0xa and sprite_status ~= 0xb) or stun ~= 0) then
    special = string.format("(%d %d) ", sprite_status, stun)
  end]] -- TODO
  
  ---**********************************************
  -- Calculates the sprites dimensions and screen positions
  
  local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	local x_centered_screen, y_centered_screen = screen_coordinates(x_centered, y_centered, Camera_x, Camera_y)
  
	if Game_mode == 0x0007 then -- adjustment for the intro "glitched" sprite positions
		x_screen = x_screen + Camera_x
		if Camera_y ~= 0 then
			y_screen = y_screen + Camera_y
		end
	--elseif Game_mode == 0x002C then y_screen = y_screen - 256
	end 
	
  -- Sprite clipping vs mario and sprites
  --local boxid = bit.band(u8_wram(WRAM.sprite_2_tweaker + id_off), 0x3f)  -- This is the type of box of the sprite
  --local xoff = HITBOX_SPRITE[boxid].xoff
  --local yoff = HITBOX_SPRITE[boxid].yoff
  local sprite_half_width = s16_sram(SRAM.sprite_hitbox_half_width + id_off)  --HITBOX_SPRITE[boxid].width
  local sprite_half_height = s16_sram(SRAM.sprite_hitbox_half_height + id_off)   --HITBOX_SPRITE[boxid].height
  local x_scaling = s16_sram(0x1A36 + id_off) -- TODO 
	local y_scaling = s16_sram(0x1A38 + id_off) -- TODO
	--[[if x_scaling ~= 0 then
		sprite_half_width = floor(sprite_half_width*x_scaling/256)
	end
	if x_scaling ~= 0 then
		sprite_half_height = floor(sprite_half_height*y_scaling/256)
	end]]
  
  -- calculates the correct color to use, according to id
  local info_color = COLOUR.sprites[id%(#COLOUR.sprites) + 1]
  local color_background = COLOUR.sprites_bg
  
  Bg_opacity = 1.0
  
  -- Handles onscreen/offscreen opacity
	if x_centered_screen >= OPTIONS.left_gap and x_centered_screen <= Border_right_start and
  y_centered_screen >= OPTIONS.top_gap and y_centered_screen <= Border_bottom_start then
		--Text_opacity = 0.8
    info_color = change_transparency(info_color, 0.8)
	else
		--Text_opacity = 0.5
    info_color = change_transparency(info_color, 0.5)
	end
  
  if sprite_status == 0 then info_color = COLOUR.disabled end -- TODO: make an option if the player wants all visible slots or only active
  
  -- CREDITS WARP HELPER:
  
  --local sprite_str = fmt("<%02d> %03X %s%04X(%+d.%02x), %04X(%+d.%02x)", id, sprite_type, debug_str, x_centered, x_speed, x_subspeed, y_centered, y_speed, y_subspeed)
	--draw_text(Screen_width, table_position + counter*BIZHAWK_FONT_HEIGHT, sprite_str, info_color, true)
  
  local cw_info_y_pos = Screen_height - 12*BIZHAWK_FONT_HEIGHT
  local cw_info_x_tmp = 2
  
  local cw_x_subpos = x_sub
  local cw_x_pos = u8_sram(SRAM.sprite_x + id_off)
  local cw_x_screen = u8_sram(SRAM.sprite_x + 1 + id_off)
  
  local cw_values = {}
  local cw_colour = COLOUR.warning
  local cw_str_tmp
  
  if id == 6 then
    cw_values.x_subpos = 0x00 -- $7010F9
    cw_values.x_pos = 0xA9 -- $7010FA
    cw_values.x_screen = 0x0D -- $7010FB
  elseif id == 7 then
    cw_values.x_subpos = 0x18 -- $7010FD
    cw_values.x_pos = 0x0A -- $7010FE
    cw_values.x_screen = 0x02 -- $7010FF
  elseif id == 8 then
    cw_values.x_subpos = 0x99 -- $701101
    cw_values.x_pos = 0x4C -- $701102
    cw_values.x_screen = 0x00 -- $701103
  elseif id == 9 then
    cw_values.x_subpos = 0x00 -- $701105
    cw_values.x_pos = 0x6B -- $701106
    cw_values.x_screen = 0x02 -- $701107
  end
  
  if id == 6 then -- to draw this just once
    draw_text(cw_info_x_tmp + 9*BIZHAWK_FONT_WIDTH, cw_info_y_pos + (counter-7)*BIZHAWK_FONT_HEIGHT, "Xsub Xpos Xscr")
  end
  
  if id >= 6 and id <= 9 then
    cw_str_tmp = fmt("<%02d> %03X ", id, sprite_type)
    draw_text(cw_info_x_tmp, cw_info_y_pos + (counter-6)*BIZHAWK_FONT_HEIGHT, cw_str_tmp)
    
    if cw_x_subpos == cw_values.x_subpos then cw_colour = COLOUR.positive else cw_colour = COLOUR.warning end
    cw_info_x_tmp = cw_info_x_tmp + string.len(cw_str_tmp)*BIZHAWK_FONT_WIDTH
    cw_str_tmp = fmt(" %02X  ", cw_x_subpos)
    draw_text(cw_info_x_tmp, cw_info_y_pos + (counter-6)*BIZHAWK_FONT_HEIGHT, cw_str_tmp, cw_colour)
    
    if cw_x_pos == cw_values.x_pos then cw_colour = COLOUR.positive else cw_colour = COLOUR.warning end
    cw_info_x_tmp = cw_info_x_tmp + string.len(cw_str_tmp)*BIZHAWK_FONT_WIDTH
    cw_str_tmp = fmt(" %02X  ", cw_x_pos)
    draw_text(cw_info_x_tmp, cw_info_y_pos + (counter-6)*BIZHAWK_FONT_HEIGHT, cw_str_tmp, cw_colour)
    
    if cw_x_screen == cw_values.x_screen then cw_colour = COLOUR.positive else cw_colour = COLOUR.warning end
    cw_info_x_tmp = cw_info_x_tmp + string.len(cw_str_tmp)*BIZHAWK_FONT_WIDTH
    cw_str_tmp = fmt(" %02X  ", cw_x_screen)
    draw_text(cw_info_x_tmp, cw_info_y_pos + (counter-6)*BIZHAWK_FONT_HEIGHT, cw_str_tmp, cw_colour)
  end
  
  ---**********************************************
  -- Special sprites analysis:
  
	if OPTIONS.display_sprite_special_info and Game_mode == YI.game_mode_level then
	
		-- Goal ring
		if sprite_type == 0x00D then
			local activation_line_x = 32
			local activation_line_y_top = -92
			local activation_line_y_bottom = -13
      local tmp_colour = COLOUR.warning
      
      -- Activation line (checks Yoshi's center point)
			draw_line(x_screen + activation_line_x, y_screen + activation_line_y_top, x_screen + activation_line_x, y_screen + activation_line_y_bottom, tmp_colour); tmp_colour = COLOUR.positive
      draw_line(x_screen + activation_line_x, y_screen + activation_line_y_bottom - 5, x_screen + activation_line_x, y_screen + activation_line_y_bottom, tmp_colour)
			
      -- Distance relative to Yoshi's center point
      local yoshi_center_x, yoshi_center_y = s16_sram(SRAM.x_centered), s16_sram(SRAM.y_centered)
      local yoshi_center_x_screen, yoshi_center_y_screen = screen_coordinates(yoshi_center_x, yoshi_center_y, Camera_x, Camera_y)
      if yoshi_center_x <= x + activation_line_x then
        draw_text(x_screen + activation_line_x - 1, y_screen + activation_line_y_top, fmt("Distance: %02X", x + activation_line_x - yoshi_center_x), info_color, true, false, 1.0)
      else
        draw_text(x_screen + activation_line_x - 1, y_screen + activation_line_y_top, fmt("Distance: -%02X", 0xFFFFFFFF - x + activation_line_x - yoshi_center_x), info_color, true, false, 1.0)
      end
      
      -- Warning to best area of activation
      if yoshi_center_y < y + activation_line_y_bottom - 5 then tmp_colour = COLOUR.warning else tmp_colour = COLOUR.positive end
      draw_line(yoshi_center_x_screen, yoshi_center_y_screen, x_screen + activation_line_x, y_screen + activation_line_y_bottom - 5, tmp_colour)
      if yoshi_center_y > y + activation_line_y_bottom then tmp_colour = COLOUR.warning else tmp_colour = COLOUR.positive end
      draw_line(yoshi_center_x_screen, yoshi_center_y_screen, x_screen + activation_line_x, y_screen + activation_line_y_bottom, tmp_colour)
      
			special_hitbox = true
		end
		
    -- Roger the Potted Ghost
    if sprite_type == 0x035 then
      -- Timers and modes TODO
      
      -- Polygon collision lines
      local vertex_x, vertex_y
      local vertex_table = {}
      for i = 0, 15 do
        vertex_x = s8_sram(SRAM.froggy_stomach_collision + 2*i)
        vertex_y = s8_sram(SRAM.froggy_stomach_collision + 2*i + 1)
        vertex_table[i+1] = {vertex_x + x_screen, vertex_y + y_screen}
      end
      gui.drawPolygon(vertex_table, "cyan") 
    end
    
    -- Prince Froggy's uvula (BOSS FIGHT)
    if sprite_type == 0x045 then	
      -- Info
      local x_pos = OPTIONS.left_gap + 112
      local damage = u16_sram(0x1A94) -- Unlisted SRAM
      draw_text(x_pos, OPTIONS.top_gap + BIZHAWK_FONT_HEIGHT, fmt("Damage: $%04X/$FFFF", damage), COLOUR.memory, true, false, 1.0)
      
      local stun_timer = u16_sram(SRAM.sprite_table21 + id_off)
      draw_text(x_pos, OPTIONS.top_gap + 2*BIZHAWK_FONT_HEIGHT, fmt("Stun timer: %d", stun_timer), COLOUR.memory, true, false, 1.0)
    
      -- Stomach polygon collision lines
      local vertex_x, vertex_y
      local vertex_table = {}
      for i = 0, 15 do
        vertex_x = s8_sram(SRAM.froggy_stomach_collision + 2*i)
        vertex_y = s8_sram(SRAM.froggy_stomach_collision + 2*i + 1)
        vertex_table[i+1] = {vertex_x + x_screen, vertex_y + y_screen}
      end
      gui.drawPolygon(vertex_table, "cyan")      
    end
    
		-- Rolling platform/Large log (in 1-8)
		if sprite_type == 0x051 then
			local effective_platform_x1, effective_platform_y1 = x_screen - 34, y_screen - 24
			local effective_platform_x2, effective_platform_y2 = x_screen + 51, y_screen + 32
			local on_platform = u8_sram(SRAM.sprite_table20 + 2 + id_off)
			local _, yoshi_y_screen = screen_coordinates(0, Yoshi_y, Camera_x, Camera_y)
			
			
			if on_platform == 0 then -- not on the platform
				-- Horizontal lines
				draw_line(effective_platform_x1, effective_platform_y1, effective_platform_x2, effective_platform_y1, info_color)
				draw_line(effective_platform_x1, effective_platform_y2, effective_platform_x2, effective_platform_y2, info_color)
				-- Vertical lines
				draw_line(effective_platform_x1, effective_platform_y1, effective_platform_x1, effective_platform_y2, info_color)
				draw_line(effective_platform_x2, effective_platform_y1, effective_platform_x2, effective_platform_y2, info_color)
			else                     -- on the platform
				-- Horizontal lines
				draw_line(effective_platform_x1, yoshi_y_screen + 32, effective_platform_x2, yoshi_y_screen + 32, info_color)
				draw_line(effective_platform_x1, effective_platform_y2, effective_platform_x2, effective_platform_y2, COLOUR.warning)
				-- Vertical lines
				draw_line(effective_platform_x1, yoshi_y_screen + 32, effective_platform_x1, effective_platform_y2, info_color)
				draw_line(effective_platform_x2, yoshi_y_screen + 32, effective_platform_x2, effective_platform_y2, info_color)	
			end	

      special_hitbox = true			
		end
		
		-- Upside down Wild Piranha and Wild Piranha
		if sprite_type == 0x054 or sprite_type == 0x066 then
			local detection_radius = 112
			-- detection is based on Yoshi's center point
			draw_box(x_screen - detection_radius + 9, y_screen - detection_radius + 9, x_screen + detection_radius + 8, y_screen + detection_radius + 8, info_color, COLOUR.detection_bg)
		end
		
		-- Green/Pink Pinwheel -- TODO
		if sprite_type == 0x055 or sprite_type == 0x056 or sprite_type == 0x064 or sprite_type == 0x15E then
			--[[ weird border of platform -- REMOVE TESTS/DEBUG
			local platform_x_screen, platform_y_screen = screen_coordinates(s16_sram(0x0020), s16_sram(0x0022), Camera_x, Camera_y)
			draw_cross(platform_x_screen, platform_y_screen, 4, COLOUR.warning)
			-- center of pinwheel -- REMOVE TESTS/DEBUG
			local platform_x_screen, platform_y_screen = screen_coordinates(s16_sram(0x002A), s16_sram(0x002C), Camera_x, Camera_y)
			draw_cross(platform_x_screen, platform_y_screen, 4, COLOUR.warning)	
			-- center of platform -- REMOVE TESTS/DEBUG
			local delta_x, delta_y = s16_sram(0x003C), s16_sram(0x003E)
			draw_cross(platform_x_screen + delta_x, platform_y_screen + delta_y, 4, COLOUR.warning)]]
			
			--[[ centers of 2 opposite platforms -- REMOVE TESTS/DEBUG
			local delta_x, delta_y = s16_sram(0x1968), s16_sram(0x196A)
			draw_cross(platform_x_screen + delta_x, platform_y_screen + delta_y, 4, "black")--COLOUR.memory)
			local delta_x, delta_y = s16_sram(0x196C), s16_sram(0x196E)
			draw_cross(platform_x_screen + delta_x, platform_y_screen + delta_y, 2, "black")--COLOUR.memory)]]
			
			--local counter = 0 -- REMOVE TESTS/DEBUG
			--memory.registerwrite(0x70003C, 2, function() counter = counter + 1 end) -- REMOVE TESTS/DEBUG
			--draw_text(100, 100, fmt("$70003C written %d times", counter)) -- REMOVE TESTS/DEBUG
			
			--[[
			memory.registerexec(0x04C598, function()
			
				--if memory.getregister("x") == id_off then
					Pinwheel_counter = Pinwheel_counter + 1 
					
					draw_text(2, 32 + memory.getregister("x")/4, fmt("x = %d", memory.getregister("x")), COLOUR.memory)
					
					local center0_dx, center0_dy =  s16_sram(0x003C), s16_sram(0x003E)
					local center1_dx, center1_dy = center0_dy, -center0_dx
					local center2_dx, center2_dy = -center0_dx, -center0_dy
					local center3_dx, center3_dy = -center0_dy, center0_dx
					draw_text(x_centered_screen + center0_dx - 1, y_centered_screen + center0_dy + 2, "0")
					draw_text(x_centered_screen + center1_dx - 1, y_centered_screen + center1_dy + 2, "1")
					draw_text(x_centered_screen + center2_dx - 1, y_centered_screen + center2_dy + 2, "2")
					draw_text(x_centered_screen + center3_dx - 1, y_centered_screen + center3_dy + 2, "3")
					draw_box(x_centered_screen + center0_dx - 10, y_centered_screen + center0_dy - 7, x_centered_screen + center0_dx + 11,  y_centered_screen + center0_dy + 1, info_color, color_background)
					draw_box(x_centered_screen + center1_dx - 10, y_centered_screen + center1_dy - 7, x_centered_screen + center1_dx + 11,  y_centered_screen + center1_dy + 1, info_color, color_background)
					draw_box(x_centered_screen + center2_dx - 10, y_centered_screen + center2_dy - 7, x_centered_screen + center2_dx + 11,  y_centered_screen + center2_dy + 1, info_color, color_background)
					draw_box(x_centered_screen + center3_dx - 10, y_centered_screen + center3_dy - 7, x_centered_screen + center3_dx + 11,  y_centered_screen + center3_dy + 1, info_color, color_background)
				--end
				
			end)]] -- REMOVE TESTS/DEBUG
			
			--[[
			local center0_dx, center0_dy =  s16_sram(0x003C), s16_sram(0x003E)
			local center1_dx, center1_dy = center0_dy, -center0_dx
			local center2_dx, center2_dy = -center0_dx, -center0_dy
			local center3_dx, center3_dy = -center0_dy, center0_dx
			draw_text(x_centered_screen + center0_dx - 1, y_centered_screen + center0_dy + 2, "0")
			draw_text(x_centered_screen + center1_dx - 1, y_centered_screen + center1_dy + 2, "1")
			draw_text(x_centered_screen + center2_dx - 1, y_centered_screen + center2_dy + 2, "2")
			draw_text(x_centered_screen + center3_dx - 1, y_centered_screen + center3_dy + 2, "3")
			draw_box(x_centered_screen + center0_dx - 10, y_centered_screen + center0_dy - 7, x_centered_screen + center0_dx + 11,  y_centered_screen + center0_dy + 1, info_color, color_background)
			draw_box(x_centered_screen + center1_dx - 10, y_centered_screen + center1_dy - 7, x_centered_screen + center1_dx + 11,  y_centered_screen + center1_dy + 1, info_color, color_background)
			draw_box(x_centered_screen + center2_dx - 10, y_centered_screen + center2_dy - 7, x_centered_screen + center2_dx + 11,  y_centered_screen + center2_dy + 1, info_color, color_background)
			draw_box(x_centered_screen + center3_dx - 10, y_centered_screen + center3_dy - 7, x_centered_screen + center3_dx + 11,  y_centered_screen + center3_dy + 1, info_color, color_background)
			]]
			special_hitbox = true			
		end
		
		-- Baby Mario
		if sprite_type == 0x061 then
			
			special_hitbox = true
		end
		
		-- Sewer ghost with platform
		if sprite_type == 0x057 then
			local platform_x, platform_y = s16_sram(SRAM.sprite_table19 + id_off), s16_sram(SRAM.sprite_table19 + 2 + id_off)
			local platform_x_screen, platform_y_screen = screen_coordinates(platform_x, platform_y, Camera_x, Camera_y)
			draw_box(platform_x_screen - 27, platform_y_screen - 8, platform_x_screen + 26, platform_y_screen + 13, info_color, color_background)
			draw_cross(platform_x_screen, platform_y_screen, 4, COLOUR.text)
			
			special_hitbox = true
		end
		
		-- Log seesaw
		if sprite_type == 0x07F then
			--[[local angle = (s8_sram(SRAM.sprite_table20 + 3 + id_off)*2*pi/256)
			local half_width = 32
			local delta_y = math.ceil(half_width*(sin(angle)))
			gui.line(x_centered_screen, y_centered_screen - 5, x_centered_screen - half_width - 1, y_centered_screen - 5 + delta_y, info_color)
			
			draw_text(x_centered_screen - 20, y_centered_screen + 30, fmt("%f rad\ndelta_y:%d\nsin:%f", angle, delta_y, sin(angle)), info_color) -- REMOVE TESTS/DEBUG
			--w8_sram(SRAM.sprite_table20 + 3 + id_off, 0) -- REMOVE TESTS/DEBUG
			--w8_sram(SRAM.sprite_table20 + 2 + id_off, 0) -- REMOVE TESTS/DEBUG
			]]
			
			special_hitbox = true
		end
		
		-- Toadies
		if sprite_type == 0x091 then
			for id = 0, 3 do
				local toadies_x = s16_wram(WRAM.toadies_relative_x + 4*id) + x
				local toadies_y = s16_wram(WRAM.toadies_relative_y + 4*id) + y
				
				-- Position
				local toadies_x_screen, toadies_y_screen = screen_coordinates(toadies_x, toadies_y, Camera_x, Camera_y)
				draw_cross(toadies_x_screen, toadies_y_screen, 2, "blue")
				
				-- Table
				draw_text(Screen_width, 176, "Toadies:", COLOUR.warning, true)
				local toadies_str = fmt("{%02d} %d, %d", id, toadies_x, toadies_y)
				draw_text(Screen_width, 184 + id*BIZHAWK_FONT_HEIGHT, toadies_str, COLOUR.warning, true)
			end
			
			special_hitbox = true
		end
		
		-- Marching Milde
		if sprite_type == 0x0D2 then
			--w8_sram(SRAM.sprite_x_speed + id_off, 0)
			--w8_sram(SRAM.sprite_x_subspeed + id_off, 0)
		end
		
    -- Sluggy The Unshaven
    if sprite_type == 0x0D7 then
      
      -- HP and timers
      
      
      
      -- Polygon collision lines
      local vertex_x, vertex_y
      local vertex_table = {}
      for i = 0, 15 do
        vertex_x = s8_sram(SRAM.froggy_stomach_collision + 2*i)
        vertex_y = s8_sram(SRAM.froggy_stomach_collision + 2*i + 1)
        vertex_table[i+1] = {vertex_x + x_screen, vertex_y + y_screen}
      end
      gui.drawPolygon(vertex_table, "cyan")
    end
    
		-- Green/Red switch for spiked platform
		if sprite_type == 0x15C or sprite_type == 0x15D then
			local up, down, left, right = 4, 10, 8, 8
			draw_box(x_centered_screen - left, y_centered_screen - up, x_centered_screen + right, y_centered_screen + down, info_color, color_background)
			
			special_hitbox = true
		end
		
		-- Green spiked platform
		if sprite_type == 0x15F then
			local up, down, left, right = 5, 3, 22, 21
			draw_box(x_centered_screen - left, y_centered_screen - up, x_centered_screen + right, y_centered_screen + down, info_color, color_background)
			
			special_hitbox = true
		end
		
		-- Red spiked platform
		if sprite_type == 0x160 then
			local up, down, left, right = 5, 4, 23, 22
			draw_box(x_centered_screen - left, y_centered_screen - up, x_centered_screen + right, y_centered_screen + down, info_color, color_background)
			
			special_hitbox = true
		end
		
    -- Green/Red Koopa shell
    if sprite_type == 0x167 or sprite_type == 0x168 then
      local can_be_licked_timer = u8_sram(SRAM.sprite_table28 + 2 + id_off)
      if can_be_licked_timer > 1 then
        alert_text(x_centered_screen, y_centered_screen + sprite_half_height, can_be_licked_timer, info_color, COLOUR.background, false, 0.5)
      end
    end
    
		-- Spinning Log
		if sprite_type == 0x180 then
			local log_state = u8_sram(SRAM.sprite_table19 + id_off)
			local tmp_colour
			if log_state == 1 then tmp_colour = COLOUR.warning else tmp_colour = COLOUR.positive end
			
			local timer_str = fmt("%d", u8_sram(SRAM.sprite_table21 + id_off))
			draw_text(x_centered_screen - floor(4*string.len(timer_str)/2) + 1, y_centered_screen + sprite_half_height + 2, timer_str, tmp_colour)
		end
		
		-- Line guided Flatbed Ferries
		if sprite_type >= 0x185 and sprite_type <= 0x18E then
			local up, down, left, right = 7, 3, 22, 23
			--draw_box(x_centered_screen - left, y_centered_screen - up, x_centered_screen + right, y_centered_screen + down, info_color, color_background)
			
			--special_hitbox = true
		end
	end
  

  ---**********************************************
  -- Displays sprites hitboxes -- TODO
  if OPTIONS.display_sprite_hitbox and not special_hitbox then
		draw_box(x_centered_screen - sprite_half_width, y_centered_screen - sprite_half_height, x_centered_screen + sprite_half_width, y_centered_screen + sprite_half_height, info_color, color_background)
		
		local interaction_x = s16_sram(SRAM.sprite_table14)
		--draw_line(x_centered_screen + interaction_x, y_centered_screen, x_centered_screen + interaction_x, y_centered_screen + 32, COLOUR.text) -- TODO
  end

  ---**********************************************
  -- Prints those informations next to the sprite
	
	if OPTIONS.display_sprite_slot_in_screen then
		local slot_str = fmt("<%02d>", id)
		draw_text(x_centered_screen, y_centered_screen - sprite_half_height - 10, slot_str, info_color, COLOUR.background, true, false, 0.5)
	end
	
	-- Sprite position pixel and cross
	if OPTIONS.display_debug_sprite_extra then
		draw_cross(x_centered_screen, y_centered_screen, 2, COLOUR.text) -- TODO: figure out a better colour
		draw_cross(x_screen, y_screen, 2, info_color)
	end
  
  ---**********************************************
  -- The sprite table:
	
	local debug_str = ""
	--local debug_address = SRAM.sprite_status -- TODO: CHECK sprite_table21 FOR BOSSES LOOKING FOR TIMERS
  --debug_str = fmt("%02X ", u16_sram(debug_address + id_off))
	--debug_str = fmt("[%02x,%02x,%02x,%02x] ", u8_sram(debug_address + id_off), u8_sram(debug_address + 1 + id_off), u8_sram(debug_address + 2 + id_off), u8_sram(debug_address + 3 + id_off)) -- REMOVE TESTS/DEBUG
  --debug_str = decode_bits_new(u8_sram(debug_address + id_off), "00000000") -- REMOVE TESTS/DEBUG
	--if sprite_type == 0x19A then w8_sram(debug_address + id_off, 0x75) end -- REMOVE TESTS/DEBUG
	--if sprite_type == 0x056 then w8_sram(SRAM.sprite_table19 + 3 + id_off, 0) end -- REMOVE TESTS/DEBUG
	--if sprite_type == 0x056 then w8_sram(SRAM.sprite_table18 + 3 + id_off, 0) end -- REMOVE TESTS/DEBUG
	
	if OPTIONS.display_sprite_table then
    local sprite_str = fmt("<%02d> %03X %s%04X(%+d.%02x), %04X(%+d.%02x)", id, sprite_type, debug_str, x_centered, x_speed, x_subspeed, y_centered, y_speed, y_subspeed)
		draw_text(Screen_width, table_position + counter*BIZHAWK_FONT_HEIGHT, sprite_str, info_color, true)
  end
	
	
	
	
  -- Miscellaneous sprite table
  if OPTIONS.display_miscellaneous_sprite_table then
    -- Font
    Font = false
    local x_mis, y_mis = 0, Scale_y*144 + counter*BIZHAWK_FONT_HEIGHT
    
    local t = OPTIONS.miscellaneous_sprite_table_number
    local misc, text = nil, fmt("<%.2d>", id)
    for num = 1, 29 do
      misc = t[num] and u8_sram(SRAM["sprite_table" .. num] + id_off) or false
      text = misc and fmt("%s %02X", text, misc) or text
    end
    
    draw_text(x_mis, y_mis, text, info_color)
  end
  
	---**********************************************
  -- Exporting some values
  Sprites_info[id].sprite_type = sprite_type
  Sprites_info[id].sprite_status = sprite_status
  Sprites_info[id].x, Sprites_info[id].y = x, y
  Sprites_info[id].x_screen, Sprites_info[id].y_screen = x_screen, y_screen
  Sprites_info[id].x_centered, Sprites_info[id].y_centered = x_centered, y_centered
  Sprites_info[id].sprite_half_width, Sprites_info[id].sprite_half_height = sprite_half_width, sprite_half_height
  
  return 1
end


local function sprites()
  if not OPTIONS.display_sprite_info then return end
	if Is_paused then return end
	
	local valid_game_mode = false
	if Game_mode == YI.game_mode_level then valid_game_mode = true
	elseif Game_mode == 0x0007 then valid_game_mode = true -- Intro (0x0007) too
	elseif Game_mode == 0x0010 then valid_game_mode = true end -- Level end (0x0010) too
	if valid_game_mode == false then return end
  
  local counter = 0
  local table_position = OPTIONS.top_gap + BIZHAWK_FONT_HEIGHT
  for id = 0, YI.sprite_max - 1 do
    counter = counter + sprite_info(id, counter, table_position)
  end
  
  -- Font
  Text_opacity = 0.8

  draw_text(Screen_width, table_position - BIZHAWK_FONT_HEIGHT, fmt("Sprites:%.2d", counter), COLOUR.weak, true)
  
  -- Miscellaneous sprite table: index
  if OPTIONS.display_miscellaneous_sprite_table then
    Font = false
    local t = OPTIONS.miscellaneous_sprite_table_number
    
    local text = "Tab "
    for num = 1, 29 do
      text = t[num] and fmt("%s %02d", text, num) or text
    end
    
    draw_text(0, Scale_y*144 - BIZHAWK_FONT_HEIGHT, text, info_color)
  end
end


local function sprite_level_data()
  if not OPTIONS.display_sprite_data and not OPTIONS.display_sprite_load_status then return end
	if Game_mode ~= YI.game_mode_level then return end
  
  Text_opacity = 0.5

  -- Sprite load status enviroment
  local indexes = {}
  for id = 0, YI.sprite_max - 1 do
    local id_off = 4*id
  
    local sprite_status = u8_sram(SRAM.sprite_status + id_off)

    if sprite_status ~= 0 then
      local index = u8_sram(SRAM.sprite_table10 + id_off)
      indexes[index] = true
    end
  end
  local status_table = memory.readbyterange(SRAM.sprite_load_status_table, 0x100)

  local x_origin = Border_right_start + 1
  local y_origin = Border_bottom_start - 5*BIZHAWK_FONT_HEIGHT
  local x, y = x_origin, y_origin
  local w, h = 9, 11

  -- Sprite data enviroment
  local pointer = Sprite_data_pointer
  
  --[[
  Sprite Data Format
  byte 1: iiiiiiii  Low ID
  byte 2: YYYYYYYI  High ID and Y Tile Coordinate
  byte 3: XXXXXXXX  X Tile Coordinate
  ]]
  local sprite_counter = 0
  for id = 0, 0x100 - 1 do
    local byte_1 = memory.readbyte(pointer + 0 + id*3, "System Bus")
    if byte_1==0xff then break end -- end of sprite data for this level
    sprite_counter = sprite_counter + 1
  end
  --sprite_counter = 0
  
  for id = 0, 0x100 - 1 do
  
    -- Sprite data
    local byte_1 = memory.readbyte(pointer + 0 + id*3, "System Bus")
    if byte_1==0xff then break end -- end of sprite data for this level -- TODO: check if true for YI
    local byte_2 = memory.readbyte(pointer + 1 + id*3, "System Bus")
    local byte_3 = memory.readbyte(pointer + 2 + id*3, "System Bus")

    local sxpos = 16*byte_3
    local sypos = 8*bit.band(byte_2, 0xfe)
    local sprite_id = byte_1 + 0x100*bit.band(byte_2, 0x01)
    
    local sxpos_screen, sypos_screen = screen_coordinates(sxpos, sypos, Camera_x, Camera_y)
    
    local status = status_table[id]
    local color = (status == 0 and COLOUR.disabled) or (status == 0xFF and COLOUR.text) or COLOUR.warning
    if status ~= 0 and not indexes[id] then color = COLOUR.warning end

    if OPTIONS.display_sprite_data then
      if is_inside_rectangle(sxpos_screen + 8, sypos_screen + 8, 0, 0, Screen_width, Screen_height) then -- print only onscreen info to avoid lag
      
        --draw_text(sxpos_screen + 8, sypos_screen -2 - BIZHAWK_FONT_HEIGHT, fmt("$%02X", id), color, false, false, 0.5) -- sprite level ID
        
        if color ~= COLOUR.text then -- don't display sprite ID if sprite is spawned
          draw_text(sxpos_screen + 8, sypos_screen + 4, fmt("%03X", sprite_id), color, false, false, 0.5)
        end
        
        draw_rectangle(sxpos_screen, sypos_screen, 15, 15, color)
        draw_cross(sxpos_screen, sypos_screen, 3, COLOUR.yoshi)
      end
    end

    -- Sprite load status
    if OPTIONS.display_sprite_load_status then
      draw_rectangle(x, y, w-1, h-1, color, 0x80000000)
      gui.pixelText(x+2, y+2, fmt("%X ", status ~= 0 and 1 or status), color, 0)
      x = x + w
      if id%16 == 15 then
        x = x_origin
        y = y + h
      end
    end

    --sprite_counter = sprite_counter + 1
  end

  Text_opacity = 1.0
  if OPTIONS.display_sprite_load_status then
    draw_text(x_origin, y_origin - BIZHAWK_FONT_HEIGHT, fmt("Sprite load status ($%02X sprites)", sprite_counter), COLOUR.weak)
  end
end


local function show_counters()
  if not OPTIONS.display_counters then return end
  
  -- Font
  Text_opacity = 1.0
  Bg_opacity = 1.0
  local height = BIZHAWK_FONT_HEIGHT
  local text_counter = 0
  local y_pos = Screen_height - 12*BIZHAWK_FONT_HEIGHT

  local invincibility_timer = u16_sram(SRAM.invincibility_timer)
  local eat_timer = u16_sram(SRAM.eat_timer)
  local transform_timer = u16_sram(SRAM.transform_timer)
  local star_timer = u16_sram(SRAM.star_timer)
  local switch_timer = u16_wram(WRAM.switch_timer)
  --local end_level_timer = u8_sram(SRAM.end_level_timer)
  
  local display_counter = function(label, value, default, mult, frame, color)
    if value == default then return end
    text_counter = text_counter + 1
    local color = color or COLOUR.text
    
    draw_text(2, y_pos + (text_counter * height), fmt("%s: %d", label, (value * mult) - frame), color)
  end
  
  if Player_animation_trigger == 5 or Player_animation_trigger == 6 then
    display_counter("Pipe", pipe_entrance_timer, -1, 1, 0, COLOUR.counter_pipe)
  end
	if not Cheat.under_free_move then
		display_counter("Invincibility", invincibility_timer, 0, 1, 0, COLOUR.counter_invincibility)
  end
	display_counter("Swallow", eat_timer, 0, 1, 0, COLOUR.counter_swallow)
  display_counter("Transform", transform_timer, 0, 1, 0, COLOUR.counter_transform)
  display_counter("Star", star_timer, 0, 1, 0, COLOUR.counter_star)
	if Game_mode == YI.game_mode_level then
		display_counter("Switch", switch_timer, 0, 1, 0, COLOUR.counter_switch)
  end
	--display_counter("End Level", end_level_timer, 0, 2, (Frame_counter - 1) % 2)
  
  --if Lock_animation_flag ~= 0 then display_counter("Animation", animation_timer, 0, 1, 0) end  -- shows when player is getting hurt or dying
  
end


-- Main function to run inside a level
local function level_mode()
  --if Game_mode == YI.game_mode_level then
    
    -- Draws the leve tile map
    draw_tile_map(Camera_x, Camera_y)
  
    -- Draws/Erases the tiles if user clicked
    draw_tiles_clicked(Camera_x, Camera_y)
    
    draw_sprite_spawning_areas()
    
    sprite_level_data()
    
    sprites()
    
    ambient_sprites()
    
    level_info()
    
    player()
    
    show_counters()
    
    -- Draws/Erases the hitbox for objects
    if true or User_input.mouse_inwindow == 1 then
      --select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y) REMOVE?
    end
    
  --end
end


local function overworld_mode() -- TODO
    --[[if Game_mode ~= YI.game_mode_overworld then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    
    local height = BIZHAWK_FONT_HEIGHT
    local y_text = BIZHAWK_FONT_HEIGHT
    
    -- Real frame modulo 8
    local Frame_counter_8 = Frame_counter%8
    draw_text(Screen_width, y_text, fmt("Real Frame = %3d = %d(mod 8)", Frame_counter, Frame_counter_8), true)
    
    -- Star Road info
    local star_speed = u8_wram(WRAM.star_road_speed)
    local star_timer = u8_wram(WRAM.star_road_timer)
    y_text = y_text + height
    draw_text(Screen_width, y_text, fmt("Star Road(%x %x)", star_speed, star_timer), COLOUR.cape, true)]]
end


local function left_click()
  -- Call options menu if the form is closed
  if Options_form.is_form_closed and mouse_onregion(Buffer_middle_x - OPTIONS.left_gap - 18, 7, Buffer_middle_x - OPTIONS.left_gap + 16, 21) then
    Options_form.create_window()
    return
  end
  
  -- Drag and drop sprites
  if Cheat.allow_cheats then
    local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    if type(id) == "number" and id >= 0 and id < YI.sprite_max then
      Cheat.dragging_sprite_id = id
      Cheat.is_dragging_sprite = true
      return
    end
  end
  
  -- Select tile
  select_tile()

  -- Layer 1 tiles
  --[[local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
  x_mouse = 16*floor(x_mouse/16)
  y_mouse = 16*floor(y_mouse/16)
  if not Options_menu.show_menu then
    select_tile(x_mouse, y_mouse, Layer1_tiles)
  end]]
end


local function read_raw_input()
  -- User input data
  Previous.User_input = copytable(User_input)
  local tmp = input.get()
  for entry, value in pairs(User_input) do
    User_input[entry] = tmp[entry] or false
  end
  -- Mouse input
  tmp = input.getmouse()
  User_input.xmouse = tmp.X
  User_input.ymouse = tmp.Y
  User_input.leftclick = tmp.Left
  User_input.rightclick = tmp.Right
  -- BizHawk, custom field
  User_input.mouse_inwindow = mouse_onregion(-OPTIONS.left_gap, -OPTIONS.top_gap, Screen_width, Screen_height)

  -- Detect if a key was just pressed or released
  for entry, value in pairs(User_input) do
    if (value ~= false) and (Previous.User_input[entry] == false) then Keys.pressed[entry] = true
      else Keys.pressed[entry] = false
    end
    if (value == false) and (Previous.User_input[entry] ~= false) then Keys.released[entry] = true
      else Keys.released[entry] = false
    end
  end
  
  -- Key presses/releases execution:
  for entry, value in pairs(Keys.press) do
    if Keys.pressed[entry] then
      value()
    end
  end
  for entry, value in pairs(Keys.release) do
    if Keys.released[entry] then
      value()
    end
  end

end


-- This function runs at the end of paint callback
-- Specific for info that changes if the emulator is paused and idle callback is called
local function snes9x_buttons()
    -- Font
    Text_opacity = 1.0
    
    if not Options_menu.show_menu and User_input.mouse_inwindow == 1 then
        create_button(100, 0, " Menu ", function() Options_menu.show_menu = true end) -- Snes9x
        
        create_button(-Border_left, Buffer_height - Border_bottom, Cheat.allow_cheats and "Cheats: allowed" or "Cheats: blocked",
            function() Cheat.allow_cheats = not Cheat.allow_cheats end, {always_on_client = true, ref_y = 1.0})
        ;
		
        create_button(Screen_width, Buffer_height + Border_bottom, "Erase Tiles",
            function() Tiletable = {} end, {always_on_client = true, ref_y = 1.0})
        ;
    else
        if Cheat.allow_cheats then  -- show cheat status anyway
            Text_opacity = 0.8
            draw_text(-Border_left, Buffer_height + Border_bottom, "Cheats: allowed", COLOUR.warning, true, false, 0, 1)
        end
    end
    
    -- Drag and drop sprites with the mouse
    if Cheat.is_dragging_sprite then
        Cheat.drag_sprite(Cheat.dragging_sprite_id)
        Cheat.is_cheating = true
    end
    
    Options_menu.display()
end



--#############################################################################
-- CHEATS

-- This signals that some cheat is activated, or was some short time ago
Cheat.allow_cheats = false
Cheat.is_cheating = false
function Cheat.is_cheat_active()
    if Cheat.is_cheating then
        alert_text(Buffer_middle_x - 3*BIZHAWK_FONT_WIDTH, 0, " Cheat ", COLOUR.warning,COLOUR.warning_bg)
        Previous.is_cheating = true
    else
        if Previous.is_cheating then
            emu.message("Script applied cheat")
            Previous.is_cheating = false
        end
    end
end


-- Called from Cheat.beat_level()
function Cheat.activate_next_level(secret_exit)
    if u8_wram(WRAM.level_exit_type) == 0x80 and u8_wram(WRAM.midway_point) == 1 then
        if secret_exit then
            w8_wram(WRAM.level_exit_type, 0x2)
        else
            w8_wram(WRAM.level_exit_type, 1)
        end
    end
    
    Cheat.is_cheating = true
end


-- allows start + select + X to activate the normal exit
--        start + select + A to activate the secret exit 
--        start + select + B to exit the level without activating any exits
function Cheat.beat_level()
    if Is_paused and Joypad["select"] and (Joypad["X"] or Joypad["A"] or Joypad["B"]) then
        w8_wram(WRAM.level_flag_table + Level_index, bit.bor(Level_flag, 0x80))
        
        local secret_exit = Joypad["A"]
        if not Joypad["B"] then
            w8_wram(WRAM.midway_point, 1)
        else
            w8_wram(WRAM.midway_point, 0)
        end
        
        Cheat.activate_next_level(secret_exit)
    end
end


-- This function makes Mario's position free
-- Press L+R+up to activate and L+R+down to turn it off.
-- While active, press directionals to fly free and Y or X to boost him up
Cheat.under_free_move = false
function Cheat.free_movement()
  if (Joypad["L"] and Joypad["R"] and Joypad["up"]) then Cheat.under_free_move = true end
  if (Joypad["L"] and Joypad["R"] and Joypad["down"]) then Cheat.under_free_move = false ; w8_sram(SRAM.sprite_freeze_flag, 0) end -- ram write to re-enable sprite interaction if you disabled before end
  if not Cheat.under_free_move then
    if Previous.under_free_move then return end
    return
  end

  local x_pos, y_pos = Yoshi_x, Yoshi_y
  local pixels = (Joypad["Y"] and 7) or (Joypad["X"] and 4) or 1  -- how many pixels per frame

  -- Math
  if Joypad["left"] then x_pos = x_pos - pixels ; w8_sram(SRAM.direction, 2)  end
  if Joypad["right"] then x_pos = x_pos + pixels ; w8_sram(SRAM.direction, 0) end
  if Joypad["up"] then y_pos = y_pos - pixels end
  if Joypad["down"] then y_pos = y_pos + pixels end

  -- Disable normal button behavior
  if Joypad["down"] then pad_send[1].down = false end -- avoid ground pound
  --if Joypad["down"] then gui.text(100, 100, "down", COLOUR.text) end
  if Joypad["A"] then pad_send[1].A = false end -- avoid throwing egg
  --if Joypad["A"] then gui.text(100, 100, "A", COLOUR.text) end
  if Joypad["B"] then pad_send[1].B = false end -- avoid "jumping"
  --if Joypad["B"] then gui.text(100, 100, "B", COLOUR.text) end
  if Joypad["Y"] then pad_send[1].Y = false end -- avoid licking
  --if Joypad["Y"] then gui.text(100, 100, "Y", COLOUR.text) end
  joypad.set(1, pad_send[1]) -- set

  -- Manipulate the addresses
  w16_sram(SRAM.x, x_pos)
  w16_sram(SRAM.y, y_pos)
  w8_sram(SRAM.x_speed, 0) -- TODO: figure out why it doesn't work
  w8_sram(SRAM.x_subspeed, 0) -- TODO: figure out why it doesn't work
  w8_sram(SRAM.y_speed, -1)
  w8_sram(SRAM.y_subspeed, 96)
  w8_sram(SRAM.invincibility_timer, 120)
  w16_sram(SRAM.player_blocked_status, 1) -- TODO: figure out why it doesn't work
  w16_sram(SRAM.on_sprite_platform, 1) -- to make the game think you're in a platform, so the camera scrolls vertically too
  --w8_sram(SRAM.sprite_freeze_flag, 1) -- to disable sprite interaction
  w16_sram(0x00C0, 0) -- REMOVE/TEST

  Cheat.is_cheating = true
  Previous.under_free_move = true
end


-- Function to force Bonus Challenge when passing through the goal ring
Cheat.always_bonus = false
function Cheat.force_bonus()
	if not Cheat.always_bonus then return end
  if Game_mode ~= YI.game_mode_level then return end
	
	-- Reads ram
	local goal_selection_position
	local goal_ring_slot
	local sprite_type
	for i = 0, 95, 4 do
		sprite_type = u16_sram(SRAM.sprite_type + i)
		if sprite_type == 0x00D then -- goal ring
			goal_ring_slot = i
		end
	end	
	if goal_ring_slot == nil then return end -- if goal is not spawned
  
	goal_selection_position = SRAM.sprite_table19 + 2
	
	-- Ram manipulation
	w16_wram(WRAM.flower_counter, 5) -- all flowers, for aestetic purposes
	w16_sram(goal_selection_position + goal_ring_slot, 0) -- force goal ring selection in a spot that will land on a flower later (sprite table #19 word 2)
end


-- Drag and drop sprites with the mouse, if the cheats are activated and mouse is over the sprite
-- Right clicking and holding: drags the sprite
-- Releasing: drops it over the latest spot
function Cheat.drag_sprite(id)
  --if Game_mode ~= YI.game_mode_level then Cheat.is_dragging_sprite = false ; return end
  
  --local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
  --local xgame, ygame = game_coordinates(User_input.xmouse - xoff, User_input.ymouse - yoff, Camera_x, Camera_y)
  local xgame, ygame = game_coordinates(User_input.xmouse + OPTIONS.left_gap, User_input.ymouse + OPTIONS.top_gap, Camera_x, Camera_y)
  
  local sprite_x_pos = xgame
  local sprite_y_pos = ygame
  
  --local sprite_xhigh = floor(xgame/256)
  --local sprite_xlow = xgame - 256*sprite_xhigh
  --local sprite_yhigh = floor(ygame/256)
  --local sprite_ylow = ygame - 256*sprite_yhigh
  
  w16_sram(SRAM.sprite_x + 4*id, sprite_x_pos)
  w16_sram(SRAM.sprite_y + 4*id, sprite_y_pos)
  
  
  --w8_wram(WRAM.sprite_x_high + id, sprite_xhigh)
  --w8_wram(WRAM.sprite_x_low + id, sprite_xlow)
  --w8_wram(WRAM.sprite_y_high + id, sprite_yhigh)
  --w8_wram(WRAM.sprite_y_low + id, sprite_ylow)
end


-- Snes9x: modifies address <address> value from <current> to <current + modification>
-- [size] is the optional size in bytes of the address
-- TODO: [is_signed] is untrue if the value is unsigned, true otherwise
function Cheat.change_address(address, modification, size)
  size = size or 1
  local memoryf_read =  (size == 1 and u8) or (size == 2 and u16) or (size == 3 and u24) or error"size is too big"
  local memoryf_write = (size == 1 and w8) or (size == 2 and w16) or (size == 3 and w24) or error"size is too big"
  local max_value = 256^size - 1
  local current = memoryf_read(address)
  --if is_signed then max_value = signed(max_value, 8*size) end
  
  local new = (current + modification)%(max_value + 1)
  memoryf_write(address, new)
  Cheat.is_cheating = true
end


--#############################################################################
-- MAIN --

-- Create lateral gaps
client.SetGameExtraPadding(OPTIONS.left_gap, OPTIONS.top_gap, OPTIONS.right_gap, OPTIONS.bottom_gap)

-- Key presses:
Keys.registerkeypress("rightclick", right_click)
Keys.registerkeypress("leftclick", left_click)
Keys.registerkeypress(OPTIONS.hotkey_increase_opacity, increase_opacity)
Keys.registerkeypress(OPTIONS.hotkey_decrease_opacity, decrease_opacity)

-- Key releases:
Keys.registerkeyrelease("mouse_inwindow", function() Cheat.is_dragging_sprite = false end)
Keys.registerkeyrelease("leftclick", function() Cheat.is_dragging_sprite = false end)

-- Options menu window
function Options_form.create_window()
  --- MAIN ---------------------------------------------------------------------------------------

  -- Create form
  local form_width, form_height = 500, 500
  Options_form.form = forms.newform(form_width, form_height, "YI Script Options")
  -- Set form location based on the emu window
  local emu_window_x, emu_window_y = client.xpos(), client.ypos()
  local form_x_pos, form_y_pos = 4, 4 -- top left corner
  if emu_window_x >= form_x_pos + form_width then form_x_pos = emu_window_x - form_width + 6 end
  forms.setlocation(Options_form.form, form_x_pos, form_y_pos)
  
  local xform, yform, delta_x, delta_y = 4, 4, 120, 20
  
  --- SHOW/HIDE ---------------------------------------------------------------------------------------
  
  forms.label(Options_form.form, "Show/hide options:", xform, yform)
  yform = yform + 1.25*delta_y
  
  local y_section, y_bigger = yform  -- 1st row
  
  -- Player
  forms.label(Options_form.form, "Player:", xform, yform)
  yform = yform + delta_y
  
  Options_form.player_info = forms.checkbox(Options_form.form, "Info", xform, yform)
  forms.setproperty(Options_form.player_info, "Checked", OPTIONS.display_player_info)
  yform = yform + delta_y
  
  Options_form.player_hitbox = forms.checkbox(Options_form.form, "Hitbox", xform, yform)
  forms.setproperty(Options_form.player_hitbox, "Checked", OPTIONS.display_player_hitbox)
  yform = yform + delta_y
  
  Options_form.interaction_points = forms.checkbox(Options_form.form, "Solid interaction", xform, yform)
  forms.setproperty(Options_form.interaction_points, "Checked", OPTIONS.display_interaction_points)
  yform = yform + delta_y
  
  Options_form.blocked_status = forms.checkbox(Options_form.form, "Blocked status", xform, yform)
  forms.setproperty(Options_form.blocked_status, "Checked", OPTIONS.display_blocked_status)
  yform = yform + delta_y
  
  Options_form.throw_info = forms.checkbox(Options_form.form, "Throw info", xform, yform)
  forms.setproperty(Options_form.throw_info, "Checked", OPTIONS.display_throw_info)
  yform = yform + delta_y
  
  Options_form.egg_info = forms.checkbox(Options_form.form, "Egg inventory", xform, yform)
  forms.setproperty(Options_form.egg_info, "Checked", OPTIONS.display_egg_info)
  yform = yform + delta_y
  
  Options_form.tongue_hitbox = forms.checkbox(Options_form.form, "Tongue hitbox", xform, yform)
  forms.setproperty(Options_form.tongue_hitbox, "Checked", OPTIONS.display_tongue_hitbox)
  yform = yform + delta_y
  
  y_bigger = yform  
  
  -- Sprite
  xform, yform = xform + delta_x, y_section
  forms.label(Options_form.form, "Sprites:", xform, yform)
  yform = yform + delta_y
  
  Options_form.sprite_info = forms.checkbox(Options_form.form, "Info", xform, yform)
  forms.setproperty(Options_form.sprite_info, "Checked", OPTIONS.display_sprite_info)
  yform = yform + delta_y
  
  Options_form.sprite_table = forms.checkbox(Options_form.form, "Table", xform, yform)
  forms.setproperty(Options_form.sprite_table, "Checked", OPTIONS.display_sprite_table)
  yform = yform + delta_y

  Options_form.sprite_hitbox = forms.checkbox(Options_form.form, "Hitbox", xform, yform)
  forms.setproperty(Options_form.sprite_hitbox, "Checked", OPTIONS.display_sprite_hitbox)
  yform = yform + delta_y

  Options_form.sprite_special_info = forms.checkbox(Options_form.form, "Special info", xform, yform)
  forms.setproperty(Options_form.sprite_special_info, "Checked", OPTIONS.display_sprite_special_info)
  yform = yform + delta_y
  
  Options_form.sprite_tables = forms.checkbox(Options_form.form, "Misc tables", xform, yform)
  forms.setproperty(Options_form.sprite_tables, "Checked", OPTIONS.display_miscellaneous_sprite_table)
  yform = yform + delta_y

  Options_form.sprite_spawning_areas = forms.checkbox(Options_form.form, "Spawning areas", xform, yform)
  forms.setproperty(Options_form.sprite_spawning_areas, "Checked", OPTIONS.display_sprite_spawning_areas)
  yform = yform + delta_y

  if yform > y_bigger then y_bigger = yform end 
  
  -- Level
  xform, yform = xform + delta_x, y_section
  forms.label(Options_form.form, "Level:", xform, yform)
  yform = yform + delta_y
  
  Options_form.level_info = forms.checkbox(Options_form.form, "Info", xform, yform)
  forms.setproperty(Options_form.level_info, "Checked", OPTIONS.display_level_info)
  yform = yform + delta_y

  Options_form.sprite_data = forms.checkbox(Options_form.form, "Sprite data", xform, yform)
  forms.setproperty(Options_form.sprite_data, "Checked", OPTIONS.display_sprite_data)
  yform = yform + delta_y
  
  Options_form.level_extra_info = forms.checkbox(Options_form.form, "Extra", xform, yform)
  forms.setproperty(Options_form.level_extra_info, "Checked", OPTIONS.display_level_help)
  yform = yform + delta_y
  
  Options_form.tile_map_grid = forms.checkbox(Options_form.form, "Tile grid", xform, yform)
  forms.setproperty(Options_form.tile_map_grid, "Checked", OPTIONS.draw_tile_map_grid)
  yform = yform + delta_y
  
  Options_form.tile_map_type = forms.checkbox(Options_form.form, "Tile types", xform, yform)
  forms.setproperty(Options_form.tile_map_type, "Checked", OPTIONS.draw_tile_map_type)
  yform = yform + delta_y
  
  Options_form.tile_map_screen = forms.checkbox(Options_form.form, "Screen", xform, yform)
  forms.setproperty(Options_form.tile_map_screen, "Checked", OPTIONS.draw_tile_map_screen)
  yform = yform + delta_y

  if yform > y_bigger then y_bigger = yform end 
  
  -- Other
  xform, yform = xform + delta_x, y_section
  forms.label(Options_form.form, "Other:", xform, yform)
  yform = yform + delta_y
  
  Options_form.misc_info = forms.checkbox(Options_form.form, "Miscellaneous", xform, yform)
  forms.setproperty(Options_form.misc_info, "Checked", OPTIONS.display_misc_info)
  yform = yform + delta_y
  
  Options_form.counters_info = forms.checkbox(Options_form.form, "Counters info", xform, yform)
  forms.setproperty(Options_form.counters_info, "Checked", OPTIONS.display_counters)
  yform = yform + delta_y
  
  Options_form.movie_info = forms.checkbox(Options_form.form, "Movie info", xform, yform)
  forms.setproperty(Options_form.movie_info, "Checked", OPTIONS.display_movie_info)
  yform = yform + delta_y

  --[[
  Options_form.overworld_info = forms.checkbox(Options_form.form, "Overworld info", xform, yform)
  forms.setproperty(Options_form.overworld_info, "Checked", OPTIONS.display_overworld_info)
  yform = yform + delta_y
  ]]
  
  if yform > y_bigger then y_bigger = yform end 
  
  -- Debug/Extra
  
  y_section = y_bigger + delta_y  -- 2nd row
  
  xform, yform = 4, y_section
  forms.label(Options_form.form, "Debug info:", xform, yform, 62, 22)
  yform = yform + delta_y
  
  Options_form.debug_player_extra = forms.checkbox(Options_form.form, "Player extra", xform, yform)
  forms.setproperty(Options_form.debug_player_extra, "Checked", OPTIONS.display_debug_player_extra)
  yform = yform  + delta_y

  Options_form.debug_sprite_extra = forms.checkbox(Options_form.form, "Sprite extra", xform, yform)
  forms.setproperty(Options_form.debug_sprite_extra, "Checked", OPTIONS.display_debug_sprite_extra)
  yform = yform + delta_y
  
  Options_form.sprite_load_status = forms.checkbox(Options_form.form, "Sprite load stat", xform, yform)
  forms.setproperty(Options_form.sprite_load_status, "Checked", OPTIONS.display_miscellaneous_sprite_table)
  yform = yform + delta_y
  
  Options_form.debug_controller_data = forms.checkbox(Options_form.form, "Controller data", xform, yform)
  forms.setproperty(Options_form.debug_controller_data, "Checked", OPTIONS.display_debug_controller_data)
  yform = yform + delta_y

  -- Ambient sprites
  
  xform, yform = xform + delta_x, y_section
  forms.label(Options_form.form, "Ambient sprites:", xform, yform)
  yform = yform + delta_y
  
  forms.label(Options_form.form, "> TODO <", xform, yform + delta_y) -- REMOVE
  
  -- TODO
  
  --- SETTINGS ---------------------------------------------------------------------------------------
  
  xform, yform = xform + delta_x, y_section
  
  forms.label(Options_form.form, "Script settings:", xform, yform, 78, 22)
  yform = yform + delta_y

  Options_form.draw_tiles_with_click = forms.checkbox(Options_form.form, "Draw tiles", xform, yform)
  forms.setproperty(Options_form.draw_tiles_with_click, "Checked", OPTIONS.draw_tiles_with_click)
  yform = yform + delta_y

  Options_form.mouse_info = forms.checkbox(Options_form.form, "Mouse info", xform, yform)
  forms.setproperty(Options_form.mouse_info, "Checked", OPTIONS.display_mouse_coordinates)
  yform = yform + 30
  
  Options_form.text_opacity = forms.label(Options_form.form, ("Text opacity: (%.0f%%, %.0f%%)"):
      format(100*Text_max_opacity, 100*Background_max_opacity), xform, yform, 135, 22)
  ;
  yform = yform - 4
  forms.button(Options_form.form, "-", function() decrease_opacity()
    forms.settext(Options_form.text_opacity, ("Text opacity: (%.0f%%, %.0f%%)"):format(100*Text_max_opacity, 100*Background_max_opacity))
  end, xform + 135, yform, 14, 24)
  forms.button(Options_form.form, "+", function() increase_opacity()
    forms.settext(Options_form.text_opacity, ("Text opacity: (%.0f%%, %.0f%%)"):format(100*Text_max_opacity, 100*Background_max_opacity))
  end, xform + 149, yform, 14, 24)
  yform = yform + 25
  
  Options_form.erase_tiles = forms.button(Options_form.form, "Erase tiles", function() Tiletable = {} end, xform, yform)
  xform = xform + 85
  
  Options_form.write_help_handle = forms.button(Options_form.form, "Help", Options_form.write_help, xform, yform)
  yform = yform + delta_y
  
  --- CHEATS ---------------------------------------------------------------------------------------
  
  y_section = yform + delta_y -- 3rd row
  xform, yform = 4, y_section
  
  Options_form.allow_cheats = forms.checkbox(Options_form.form, "Allow cheats", xform, yform)
  forms.setproperty(Options_form.allow_cheats, "Checked", Cheat.allow_cheats)
  
  --[[ Coin cheat
  xform = xform + 60
  forms.button(Options_form.form, "Coin", function() Cheat.change_address(WRAM.player_coin, "coin_number", 1, false,
    function(num) return num < 100 end, "Enter an integer between 0 and 99.", "coin")
  end, xform, yform, 43, 24)

  xform = xform + 45
  Options_form.coin_number = forms.textbox(Options_form.form, "", 24, 16, "UNSIGNED", xform, yform + 2, false, false)

  -- Positon cheat
  xform = 2
  yform = yform + 28
  forms.button(Options_form.form, "Position", function()
    Cheat.change_address(WRAM.x, "player_x", 2, false, nil, "Enter a valid x position", "x position")
    Cheat.change_address(WRAM.x_sub, "player_x_sub", 1, true, nil, "Enter a valid x subpixel", "x subpixel")
    Cheat.change_address(WRAM.y, "player_y", 2, false, nil, "Enter a valid y position", "y position")
    Cheat.change_address(WRAM.y_sub, "player_y_sub", 1, true, nil, "Enter a valid y subpixel", "y subpixel")
  end, xform, yform, 60, 24)

  yform = yform + 2
  xform = xform + 62
  Options_form.player_x = forms.textbox(Options_form.form, "", 32, 16, "UNSIGNED", xform, yform, false, false)
  xform = xform + 33
  Options_form.player_x_sub = forms.textbox(Options_form.form, "", 28, 16, "HEX", xform, yform, false, false)
  xform = xform + 34
  Options_form.player_y = forms.textbox(Options_form.form, "", 32, 16, "UNSIGNED", xform, yform, false, false)
  xform = xform + 33
  Options_form.player_y_sub = forms.textbox(Options_form.form, "", 28, 16, "HEX", xform, yform, false, false)
  ]]
  
  --- Tip
  forms.label(Options_form.form, "You can close this menu at any time", form_width - 200, form_height - 60, 190, 20)
  
end


function Options_form.evaluate_form()
  --- Show/hide -------------------------------------------------------------------------------------------
  -- Player
  OPTIONS.display_player_info = forms.ischecked(Options_form.player_info) or false
  OPTIONS.display_player_hitbox = forms.ischecked(Options_form.player_hitbox) or false
  OPTIONS.display_interaction_points = forms.ischecked(Options_form.interaction_points) or false
  OPTIONS.display_blocked_status = forms.ischecked(Options_form.blocked_status) or false
  OPTIONS.display_throw_info = forms.ischecked(Options_form.throw_info) or false
  OPTIONS.display_egg_info = forms.ischecked(Options_form.egg_info) or false
  OPTIONS.display_tongue_hitbox = forms.ischecked(Options_form.tongue_hitbox) or false
  -- Sprites
  OPTIONS.display_sprite_info = forms.ischecked(Options_form.sprite_info) or false
  OPTIONS.display_sprite_table = forms.ischecked(Options_form.sprite_table) or false
  OPTIONS.display_sprite_hitbox = forms.ischecked(Options_form.sprite_hitbox) or false
  OPTIONS.display_sprite_special_info = forms.ischecked(Options_form.sprite_special_info) or false
  OPTIONS.display_miscellaneous_sprite_table =  forms.ischecked(Options_form.sprite_tables) or false
  OPTIONS.display_sprite_spawning_areas = forms.ischecked(Options_form.sprite_spawning_areas) or false
  -- Level
  OPTIONS.display_level_info = forms.ischecked(Options_form.level_info) or false
  OPTIONS.display_sprite_data =  forms.ischecked(Options_form.sprite_data) or false
  OPTIONS.display_level_help =  forms.ischecked(Options_form.level_extra_info) or false
  OPTIONS.draw_tile_map_grid =  forms.ischecked(Options_form.tile_map_grid) or false
  OPTIONS.draw_tile_map_type =  forms.ischecked(Options_form.tile_map_type) or false
  OPTIONS.draw_tile_map_screen =  forms.ischecked(Options_form.tile_map_screen) or false  
  -- Other
  OPTIONS.display_misc_info = forms.ischecked(Options_form.misc_info) or false
  OPTIONS.display_counters = forms.ischecked(Options_form.counters_info) or false
  OPTIONS.display_movie_info = forms.ischecked(Options_form.movie_info) or false
--OPTIONS.display_overworld_info = forms.ischecked(Options_form.overworld_info) or false
  
  --- Debug/Extra -------------------------------------------------------------------------------------------
  OPTIONS.display_debug_player_extra = forms.ischecked(Options_form.debug_player_extra) or false
  OPTIONS.display_debug_sprite_extra = forms.ischecked(Options_form.debug_sprite_extra) or false
  OPTIONS.display_sprite_load_status =  forms.ischecked(Options_form.sprite_load_status) or false
  OPTIONS.display_debug_controller_data = forms.ischecked(Options_form.debug_controller_data) or false
  
  --- Settings -------------------------------------------------------------------------------------------
  OPTIONS.draw_tiles_with_click = forms.ischecked(Options_form.draw_tiles_with_click) or false
  OPTIONS.display_mouse_coordinates = forms.ischecked(Options_form.mouse_info) or false
  
  --- Cheats -------------------------------------------------------------------------------------------
  Cheat.allow_cheats = forms.ischecked(Options_form.allow_cheats) or false
end


function Options_form.write_help() -- TODO
  print(" - - - TIPS - - - ")
  print("MOUSE:")
  print("Use the left click to draw blocks and to see the Map16 properties.")
  print("Use the right click to toogle the hitbox mode of Mario and sprites.")
  print("\n")

  print("CHEATS(better turn off while recording a movie):")
  print("L+R+up: stop gravity for Mario fly / L+R+down to cancel")
  print("Use the mouse to drag and drop sprites")
  print("While paused: B+select to get out of the level")
  print("          X+select to beat the level (main exit)")
  print("          A+select to get the secret exit (don't use it if there isn't one)")

  print("\n")
  print("OTHERS:")
  print("If performance suffers, disable some options that are not needed at the moment.")
  print(" - - - end of tips - - - ")
end

Options_form.create_window()
Options_form.is_form_closed = false


event.onexit(function()
  
  forms.destroy(Options_form.form)
  
  gui.clearImageCache()
  
	client.SetGameExtraPadding(0, 0, 0, 0)
  
  print("Finishing Yoshi's Island script.")
end)

-- Check if images files exist
local error_str = "\nCouldn't find the script images! Make sure to download the whole 'BizHawk' folder on https://github.com/brunovalads/yoshis-island/tree/master/BizHawk"
if not file_exists("images\\blocked_status_bits.png") then error(error_str) end
if not file_exists("images\\coin_icon.png") then error(error_str) end
if not file_exists("images\\egg_icons.png") then error(error_str) end
if not file_exists("images\\flower_icon.png") then error(error_str) end
if not file_exists("images\\red_coin_icon.png") then error(error_str) end
if not file_exists("images\\star_icon.png") then error(error_str) end
if not file_exists("images\\yoshi_blocked_status.png") then error(error_str) end
if not file_exists("images\\yoshi_icon.png") then error(error_str) end


print("Lua script loaded successfully.\n")

-- Main script loop
while true do
 
  Options_form.is_form_closed = forms.gettext(Options_form.form) == ""
  if not Options_form.is_form_closed then Options_form.evaluate_form() end
 
  -- Initial values, don't make drawings here
  bizhawk_status()
  bizhawk_screen_info()
  Script_buttons = {}  -- reset the buttons
  read_raw_input()
  scan_yi()
  
  -- Dark filter to cover the game area -- TODO
  --if Filter_opacity ~= 0 then
    --gui.opacity(Filter_opacity/10)
    --draw_box(0, 0, Buffer_width, Buffer_height, Filter_color)
    --gui.opacity(1.0)
  --end
  
  -- Drawings  
  if Is_lagged then
    gui.drawText(Buffer_middle_x - 20, OPTIONS.top_gap + 2*BIZHAWK_FONT_HEIGHT, " LAG ", COLOUR.warning, COLOUR.warning_bg)
    
    gui.clearImageCache() -- unload unused images, "inside lag" to no run every frame
  end
  level_mode()
  overworld_mode()
  show_movie_info()
  show_misc_info()
  --show_controller_data()
  show_mouse_info()
  
  Cheat.is_cheat_active()
  
  -- Drag and drop sprites with the mouse (Cheat)
  if Cheat.is_dragging_sprite then
    Cheat.drag_sprite(Cheat.dragging_sprite_id)
    Cheat.is_cheating = true
  end


  -- Checks if options form exits and create a button in case it doesn't
  if Options_form.is_form_closed then
    if User_input.mouse_inwindow then
      draw_rectangle(Buffer_middle_x - 18, OPTIONS.top_gap + 7, 34, 14, "black", COLOUR.weak2)
      draw_line(Buffer_middle_x - 18, OPTIONS.top_gap + 7, Buffer_middle_x - 18, OPTIONS.top_gap + 21, COLOUR.weak)
      draw_line(Buffer_middle_x - 17, OPTIONS.top_gap + 7, Buffer_middle_x + 16, OPTIONS.top_gap + 7, COLOUR.weak)
      
      gui.drawText(Buffer_middle_x, OPTIONS.top_gap + 6, "Menu", COLOUR.text, 0, 14, "Consolas", "regular", "center")
    end
  end
  
  
  --[[ REMOVE/TEST
  local y_pos = 0
  gui.drawText(0, y_pos, fmt("Left_gap:%d ", OPTIONS.left_gap), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Right_gap:%d ", OPTIONS.right_gap), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Top_gap:%d ", OPTIONS.top_gap), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Bottom_gap:%d ", OPTIONS.bottom_gap), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Screen_width:%d ", Screen_width), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Screen_height:%d ", Screen_height), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Buffer_width:%d ", Buffer_width), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Buffer_height:%d ", Buffer_height), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Buffer_middle_x:%d ", Buffer_middle_x), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Buffer_middle_y:%d ", Buffer_middle_y), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Border_right_start:%d ", Border_right_start), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Border_bottom_start:%d ", Border_bottom_start), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Scale_x:%d ", Scale_x), "white", 0, 9); y_pos = y_pos + 11
  gui.drawText(0, y_pos, fmt("Scale_y:%d ", Scale_y), "white", 0, 9); y_pos = y_pos + 11
  draw_text(Buffer_middle_x, Buffer_middle_y, "TEST MIDDLE", "red", 0, 12)]]
  
  --for number, positions in ipairs(Tiletable) do  -- REMOVE/TEST
  for number = 1, #Tiletable do  -- REMOVE/TEST
    
    --print(Tiletable[number])
    
  end
  
  
  -- (End of drawings)

  -- Lag-flag is accounted correctly only inside this loop
  --Is_lagged = emu.lagged() REMOVE?
  
  emu.frameadvance()
end

--[[ TODO LIST #########################################################################################################################

- Sprite editor on click: click sprite > form pop out > textboxes to edit every single table.
- Import Arne's sprite spawn cheat.
- Tile editor
- Cheat to change the ID of selected sprite


]]




