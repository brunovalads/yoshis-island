---------------------------------------------------------------------------
--  Super Mario World 2 - Yoshi's Island (U) Utility Script for Snes9x - rr
--  http://tasvideos.org/GameResources/SNES/YoshisIsland.html
--  
--  Author: BrunoValads 
--  Git repository: https://github.com/brunovalads/yoshis-island-stuff -- TODO
--
--  Based on Amaraticando's Super Mario World script for Snes9x-rr
--  http://github.com/rodamaral/smw-tas/blob/master/Snes9x/smw-snes9x.lua
---------------------------------------------------------------------------

--#############################################################################
-- CONFIG:

local INI_CONFIG_FILENAME = "Yoshi's Island Utilities Config.ini"  -- relative to the folder of the script

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
    display_sprite_info = true,
    display_sprite_hitbox = true,  -- you still have to select the sprite with the mouse
    display_extended_sprite_info = false,
    display_cluster_sprite_info = false,
    display_minor_extended_sprite_info = false,
    display_bounce_sprite_info = false,
    display_level_info = true,
    display_yoshi_info = true,
    display_counters = true,
    display_controller_input = true,
    display_static_camera_region = false,  -- shows the region in which the camera won't scroll horizontally
    draw_tiles_with_click = true,
    
    -- Some extra/debug info
    display_debug_info = false,  -- shows useful info while investigating the game, but not very useful while TASing
    display_debug_player_extra = true,
    display_debug_sprite_extra = true,
    display_debug_sprite_tweakers = true,
    display_debug_extended_sprite = true,
    display_debug_cluster_sprite = true,
    display_debug_minor_extended_sprite = true,
    display_debug_bounce_sprite = true,
    display_debug_controller_data = false,  -- Snes9x: might cause desyncs
    display_miscellaneous_sprite_table = false,
    miscellaneous_sprite_table_number = {[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true, [8] = true, [9] = true,
                    [10] = true, [11] = true, [12] = true, [13] = true, [14] = true, [15] = true, [16] = true, [17] = true, [18] = true, [19] = true
    },
	display_mouse_coordinates = false,
	draw_tile_map_grid = false,
	draw_tile_map_type = false,
	draw_tile_map_gfx_type = false,
	draw_tile_map_phy_type = false,
	
	-- Memory edit function
	address = 0x7E0000,
	size = 1,
	value = 0,
	edit_method = "Poke",
	edit_sprite_table = false,
    edit_sprite_table_number = {[1] = false, [2] = false, [3] = false, [4] = false, [5] = false, [6] = false, [7] = false, [8] = false, [9] = false,
								[10] = false, [11] = false, [12] = false, [13] = false, [14] = false, [15] = false, [16] = false, [17] = false, [18] = false,
								[19] = false, [20] = false, [21] = false, [22] = false, [23] = false, [24] = false},
	
    -- Script settings
    max_tiles_drawn = 20,  -- the max number of tiles to be drawn/registered by the script
}

-- Colour settings
local DEFAULT_COLOUR = {
    -- Text
    default_text_opacity = 1.0,
    default_bg_opacity = 0.7,
    text = "#ffffff", -- white
    background = "#000000", -- black
    halo = "#000040", 
	positive = "#00ff00", -- green
    warning = "#ff0000", -- red
    warning_bg = "#000000ff",
    warning2 = "#ff00ff", -- purple
	warning_soft = "#ffa500", -- orange
    weak = "#00a9a9a9",
	weak2 = "#555555", -- gray
    very_weak = "#a0ffffff",
	memory = "#00ffff", -- cyan
    joystick_input = "#ffff00ff",
    joystick_input_bg = "#ffffff30",
    button_text = "#300030ff",
    mainmenu_outline = "#ffffffc0",
    mainmenu_bg = "#000000c0",
    
    -- Counters
    counter_pipe = "#00ff00ff",
    counter_multicoin = "#ffff00ff",
    counter_gray_pow = "#a5a5a5ff",
    counter_blue_pow = "#4242deff",
    counter_dircoin = "#8c5a19ff",
    counter_pballoon = "#f8d870ff",
    counter_star = "#ffd773ff",
    counter_fireflower = "#ff8c00ff",
    
    -- hitbox and related text
    mario = "#ff0000ff",
    mario_bg = "#00000000",
    mario_mounted_bg = "#00000000",
    interaction = "#ffffffff",
    interaction_bg = "#00000020",
    interaction_nohitbox = "#000000a0",
    interaction_nohitbox_bg = "#00000070",
    
    sprites = {
        "#80ffff", -- cyan
        "#a0a0ff", -- blue
        "#ff6060", -- red
        "#ff80ff", -- magenta
        "#ffa100", -- orange
        "#ffff80", -- yellow
		"#40ff40"  -- green
	},
    sprites_bg = "#00ff00",
    sprites_interaction_pts = "#ffffffff",
    sprites_clipping_bg = "#000000a0",
	extended_sprites = {
        "#ff3700", -- orange to red gradient 6
		"#ff5b00", -- orange to red gradient 4
		"#ff8000", -- orange to red gradient 2
		"#ffa500" -- orange to red gradient 0 (orange)
    },
    extended_sprites_bg = "#00ff0050",
    special_extended_sprite_bg = "#00ff0060",
    goal_tape_bg = "#ffff0050",
    fireball = "#b0d0ffff",
    baseball = "#0040a0ff",
    cluster_sprites = "#ff80a0ff",
    sumo_brother_flame = "#0040a0ff",
    minor_extended_sprites = "#ff90b0ff",
    awkward_hitbox = "#204060ff",
    awkward_hitbox_bg = "#ff800060",
    
    yoshi = "#00ffffff",
    yoshi_bg = "#00ffff40",
    yoshi_mounted_bg = "#00000000",
    tongue_line = "#ffa000ff",
    tongue_bg = "#00000060",
    
    cape = "#ffd700ff",
    cape_bg = "#ffd70060",
    
    block = "#00008bff",
    blank_tile = "#ffffff70",
    block_bg = "#22cc88a0",
    layer2_line = "#ff2060ff",
    layer2_bg = "#ff206040",
    static_camera_region = "#40002040",
}

-- Font settings
local SNES9X_FONT_HEIGHT = 8
local SNES9X_FONT_WIDTH = 4

-- GD images dumps (encoded)
local GD_IMAGES_DUMPS = {}
GD_IMAGES_DUMPS.player_blocked_status = {255, 254, 0, 7, 0, 10, 1, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 248, 64, 112, 0, 248, 216, 112, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 40, 96, 0, 176, 40, 96, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 112, 104, 0, 248, 208, 192, 0, 0, 0, 0, 0, 248, 208, 192, 0, 248, 208, 192, 0, 248, 208, 192, 0, 136, 88, 24, 0, 0, 0, 0, 0, 248, 112, 104, 0, 248, 208, 192, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 80, 0, 0, 0, 136, 88, 24, 0, 136, 88, 24, 0, 32, 48, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 88, 24, 0, 136, 88, 24, 0, 248, 248, 248, 0, 128, 216, 200, 0, 32, 48, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 248, 248, 248, 0, 136, 88, 24, 0, 64, 128, 152, 0, 128, 216, 200, 0, 32, 48, 136, 0, 0, 0, 0, 0, 0, 0, 0, 0, 136, 88, 24, 0, 136, 88, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
GD_IMAGES_DUMPS.goal_tape = {255, 254, 0, 18, 0, 6, 1, 255, 255, 255, 255, 107, 153, 153, 153, 38, 75, 75, 75, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 0, 63, 63, 63, 32, 84, 84, 84, 0, 186, 186, 186, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 62, 62, 62, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 248, 248, 248, 0, 55, 55, 55, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 0, 216, 216, 216, 33, 75, 75, 75, 0, 136, 136, 136, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 0, 176, 176, 176, 106, 160, 160, 160, 40, 60, 60, 60, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40, 0, 40, 40, 40}

-- Symbols
local LEFT_ARROW = "<-"
local RIGHT_ARROW = "->"

-- Others
local Border_right, Border_left, Border_top, Border_bottom = 0, 0, 0, 0
local Buffer_width, Buffer_height, Buffer_middle_x, Buffer_middle_y = 256, 224, 128, 112
local Screen_width, Screen_height, AR_x, AR_y = 256, 224, 1, 1
local Y_CAMERA_OFF = 1 -- small adjustment to display the tiles according to their actual graphics

-- Input key names
local INPUT_KEYNAMES = { -- Snes9x
    xmouse=0, ymouse=0, leftclick=false, rightclick=false, middleclick=false,
    shift=false, control=false, alt=false, capslock=false, numlock=false, scrolllock=false,
    ["false"]=false, ["1"]=false, ["2"]=false, ["3"]=false, ["4"]=false, ["5"]=false, ["6"]=false, ["7"]=false, ["8"]=false,["9"]=false,
    A=false, B=false, C=false, D=false, E=false, F=false, G=false, H=false, I=false, J=false, K=false, L=false, M=false, N=false,
    O=false, P=false, Q=false, R=false, S=false, T=false, U=false, V=false, W=false, X=false, Y=false, Z=false,
    F1=false, F2=false, F3=false, F4=false, F5=false, F6=false, F7=false, F8=false, F9=false, F1false=false, F11=false, F12=false,
    F13=false, F14=false, F15=false, F16=false, F17=false, F18=false, F19=false, F2false=false, F21=false, F22=false, F23=false, F24=false,
    backspace=false, tab=false, enter=false, pause=false, escape=false, space=false,
    pageup=false, pagedown=false, ["end"]=false, home=false, insert=false, delete=false,
    left=false, up=false, right=false, down=false,
    numpadfalse=false, numpad1=false, numpad2=false, numpad3=false, numpad4=false, numpad5=false, numpad6=false, numpad7=false, numpad8=false, numpad9=false,
    ["numpad*"]=false, ["numpad+"]=false, ["numpad-"]=false, ["numpad."]=false, ["numpad/"]=false,
    tilde=false, plus=false, minus=false, leftbracket=false, rightbracket=false,
    semicolon=false, quote=false, comma=false, period=false, slash=false, backslash=false
}

-- END OF CONFIG < < < < < < <
--#############################################################################
-- INITIAL STATEMENTS:


print("Starting script")

-- Load environment
local gui, input, joypad, emu, movie, memory = gui, input, joypad, emu, movie, memory
local unpack = unpack or table.unpack
local string, math, table, next, ipairs, pairs, io, os, type = string, math, table, next, ipairs, pairs, io, os, type
local bit = require"bit"

-- Script tries to verify whether the emulator is indeed Snes9x-rr
if snes9x == nil then
    error("This script works with Snes9x-rr emulator.")
end

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

local INI = {}

function INI.arg_to_string(value)
    local str
    if type(value) == "string" then
        str = "\"" .. value .. "\""
    elseif type(value) == "number" or type(value) == "boolean" or value == nil then
        str = tostring(value)
    elseif type(value) == "table" then
        local tmp = {"{"}  -- only arrays
        for a, b in ipairs(value) do
            table.insert(tmp, ("%s%s"):format(INI.arg_to_string(b), a ~= #value and ", " or "")) -- possible stack overflow
        end
        table.insert(tmp, "}")
        str = table.concat(tmp)
    else
        str = "#BAD_VALUE"
    end
    
    return str
end

-- creates the string for ini
function INI.data_to_string(data)
	local sections = {}
    
	for section, prop in pairs(data) do
        local properties = {}
		
        for key, value in pairs(prop) do
            table.insert(properties, ("%s = %s\n"):format(key, INI.arg_to_string(value)))  -- properties
		end
        
        table.sort(properties)
        table.insert(sections, ("[%s]\n"):format(section) .. table.concat(properties) .. "\n")
	end
    
    table.sort(sections)
    return table.concat(sections)
end

function INI.string_to_data(value)
    local data
    
    if tonumber(value) then
        data = tonumber(value)
    elseif value == "true" then
        data = true
    elseif value == "false" then
        data = false
    elseif value == "nil" then
        data = nil
    else
        local quote1, text, quote2 = value:match("(['\"{])(.+)(['\"}])")  -- value is surrounded by "", '' or {}?
        if quote1 and quote2 and text then
            if (quote1 == '"' or quote1 == "'") and quote1 == quote2 then
                data = text
            elseif quote1 == "{" and quote2 == "}" then
                local tmp = {} -- test
                for words in text:gmatch("[^,%s]+") do
                    tmp[#tmp + 1] = INI.string_to_data(words) -- possible stack overflow
                end
                
                data = tmp
            else
                data = value
            end
        else
            data = value
        end
    end
    
    return data
end

function INI.load(filename)
    local file = io.open(filename, "r")
    if not file then return false end
    
    local data, section = {}, nil
    
	for line in file:lines() do
        local new_section = line:match("^%[([^%[%]]+)%]$")
		
        if new_section then
            section = INI.string_to_data(new_section) and INI.string_to_data(new_section) or new_section
            if data[section] then print("Duplicated section") end
			data[section] = data[section] or {}
        else
            
            local prop, value = line:match("^([%w_%-%.]+)%s*=%s*(.+)%s*$")  -- prop = value
            
            if prop and value then
                value = INI.string_to_data(value)
                prop = INI.string_to_data(prop) and INI.string_to_data(prop) or prop
                
                if data[section] == nil then print(prop, value) ; error("Property outside section") end
                data[section][prop] = value
            else
                local ignore = line:match("^;") or line == ""
                if not ignore then
                    print("BAD LINE:", line, prop, value)
                end
            end
            
        end
        
	end
    
	file:close()
    return data
end

function INI.retrieve(filename, data)
    if type(data) ~= "table" then error"data must be a table" end
    local previous_data
    
    -- Verifies if file already exists
    if file_exists(filename) then
        ini_data = INI.load(filename)
    else return data
    end
    
    -- Adds previous values to the new ini
    local union_data = mergetable(data, ini_data)
    return union_data
end

function INI.overwrite(filename, data)
    local file, err = assert(io.open(filename, "w"), "Error loading file :" .. filename)
    if not file then print(err) ; return end
    
	file:write(INI.data_to_string(data))
	file:close()
end

function INI.save(filename, data)
    if type(data) ~= "table" then error"data must be a table" end
    
    local tmp, previous_data
    if file_exists(filename) then
        previous_data = INI.load(filename)
        tmp = mergetable(previous_data, data)
    else
        tmp = data
    end
    
    INI.overwrite(filename, tmp)
end

local OPTIONS = file_exists(INI_CONFIG_FILENAME) and INI.retrieve(INI_CONFIG_FILENAME, {["SNES9X OPTIONS"] = DEFAULT_OPTIONS}).OPTIONS or DEFAULT_OPTIONS
local COLOUR = file_exists(INI_CONFIG_FILENAME) and INI.retrieve(INI_CONFIG_FILENAME, {["SNES9X COLOURS"] = DEFAULT_COLOUR}).COLOURS or DEFAULT_COLOUR
INI.save(INI_CONFIG_FILENAME, {["SNES9X COLOURS"] = COLOUR})  -- Snes9x doesn't need to convert colour string to number
INI.save(INI_CONFIG_FILENAME, {["SNES9X OPTIONS"] = OPTIONS})

function INI.save_options()
    INI.save(INI_CONFIG_FILENAME, {["SNES9X OPTIONS"] = OPTIONS})
end

--######################## -- end of test

-- Text/Background_max_opacity is only changed by the player using the hotkeys
-- Text/Bg_opacity must be used locally inside the functions
local Text_max_opacity = COLOUR.default_text_opacity
local Background_max_opacity = COLOUR.default_bg_opacity
local Text_opacity = 1
local Bg_opacity = 1

local fmt = string.format
local floor = math.floor

-- unsigned to signed (based in <bits> bits)
local function signed(num, bits)
    local maxval = 2^(bits - 1)
    if num < maxval then return num else return num - 2*maxval end
end

-- Compatibility of the memory read/write functions
local u8 =  memory.readbyte
local s8 =  memory.readbytesigned
local w8 =  memory.writebyte
local u16 = memory.readword
local s16 = memory.readwordsigned
local w16 = memory.writeword
local u24 = function(address, value) return 256*u16(address + 1) + u8(address) end
local s24 = function(address, value) return signed(256*u16(address + 1) + u8(address), 24) end
local w24 = function(address, value) w16(address + 1, floor(value/256)) ; w8(address, value%256) end

-- Images (for gd library)
local IMAGES = {}
IMAGES.player_blocked_status = string.char(unpack(GD_IMAGES_DUMPS.player_blocked_status))
IMAGES.goal_tape = string.char(unpack(GD_IMAGES_DUMPS.goal_tape))

-- Hotkeys availability
if INPUT_KEYNAMES[OPTIONS.hotkey_increase_opacity] == nil then
     print(string.format("Hotkey '%s' is not available, to increase opacity.", OPTIONS.hotkey_increase_opacity))
else print(string.format("Hotkey '%s' set to increase opacity.", OPTIONS.hotkey_increase_opacity))
end
if INPUT_KEYNAMES[OPTIONS.hotkey_decrease_opacity] == nil then
     print(string.format("Hotkey '%s' is not available, to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
else print(string.format("Hotkey '%s' set to decrease opacity.", OPTIONS.hotkey_decrease_opacity))
end


--#############################################################################
-- GAME AND SNES SPECIFIC MACROS:


local NTSC_FRAMERATE = 60.0

local SMW2 = {
    -- Game Modes
    game_mode_overworld = 0x0022,
    game_mode_level = 0x000F,
    
    -- Sprites
    sprite_max = 24,
    extended_sprite_max = 10,
    cluster_sprite_max = 20,
    minor_extended_sprite_max = 12,
    bounce_sprite_max = 4,
    null_sprite_id = 0xff,
    
    -- Blocks
    blank_tile_map16 = 0x25,
}

SFXRAM = {  -- 700000~701FFF
    -- General
	level_timer = 0x701974, -- 2 bytes
	screen_number_to_id = 0x700CAA, -- 128 bytes table

	-- Player
    x = 0x70008C, -- 2 bytes
    y = 0x700090, -- 2 bytes
    --previous_x = 0x7000d1,
    --previous_y = 0x7000d3,
    x_sub = 0x70008A,
    y_sub = 0x70008E,
    x_speed = 0x7000A9,
    x_subspeed = 0x7000A8,
    y_speed = 0x7000AB,
    y_subspeed = 0x7000AA,
    direction = 0x7000C4,
	egg_target_x = 0x7000E4, -- 2 bytes
	egg_target_y = 0x7000E6, -- 2 bytes
	egg_target_radial_pos = 0x7000EE, -- 2 bytes
    x_centered = 0x70011C, -- 2 bytes
    y_centered = 0x70011E, -- 2 bytes
    tongue_x = 0x700154, -- 2 bytes
    tongue_y = 0x700152, -- 2 bytes
    --is_ducking = 0x700073,
    --p_meter = 0x7013e4,
    --take_off = 0x70149f,
    --powerup = 0x700019,
    --diving_status = 0x701409,
    --player_animation_trigger = 0x700071,
    --climbing_status = 0x700074,
    player_blocked_status = 0x7000FC,
    --on_ground = 0x7013ef,
    --on_ground_delay = 0x70008d,
    --on_air = 0x700072,
    --can_jump_from_water = 0x7013fa,
    --carrying_item = 0x70148f,
    --player_looking_up = 0x7013de,
    
    -- Baby Mario
    mario_status = 0x700F00,
	
	
    -- Timer
	invincibility_timer = 0x7001D6,
	eat_timer = 0x7001EE,
	transform_timer = 0x7001F4,
	star_timer = 0x701E04,
	
	-- Sprites
	sprite_status = 0x700F00,
	sprite_type = 0x701360,
    sprite_x = 0x7010E0, -- 2 bytes
    sprite_y = 0x701180, -- 2 bytes
    sprite_x_sub = 0x7010DF,
    sprite_y_sub = 0x70117F,
    sprite_x_speed = 0x701221,
    sprite_x_subspeed = 0x701220,
    sprite_y_speed = 0x701223,
    sprite_y_subspeed = 0x701222,
	sprite_x_center = 0x701CD6, -- 2 bytes
	sprite_y_center = 0x701CD8 -- 2 bytes
	
}
--[[
for name, address in pairs(SFXRAM) do
    address = address + 0x700000  -- Snes9x
end]]
local SFXRAM = SFXRAM

WRAM = {  -- 7E0000~7FFFFF
    -- I/O
    ctrl_1_1 = 0x0015,
    ctrl_1_2 = 0x0017,
    firstctrl_1_1 = 0x0016,
    firstctrl_1_2 = 0x0018,
    
    -- General
    game_mode = 0x0118,
    --real_frame = 0x0013,
    --effective_frame = 0x0014,
    --lag_indicator = 0x01fe,
    --timer_frame_counter = 0x0f30,
    --RNG = 0x148d,
    --current_level = 0x00fe,  -- plus 1
    --lock_animation_flag = 0x009d, -- Most codes will still run if this is set, but almost nothing will move or animate.
    --level_mode_settings = 0x1925,
	red_coin_counter = 0x03B4,
	star_counter = 0x03B6,
	flower_counter = 0x03B8,
	coin_counter = 0x037b,
	Map16_data = 0x18000, -- 32768 bytes table, in words
    
    -- Cheats
    frozen = 0x13fb,
    level_paused = 0x13d4,
    level_index = 0x13bf,
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
    sprite_status = 0x14c8,
    sprite_number = 0x009e,
    sprite_x_high = 0x14e0,
    sprite_x_low = 0x00e4,
    sprite_y_high = 0x14d4,
    sprite_y_low = 0x00d8,
    sprite_x_sub = 0x14f8,
    sprite_y_sub = 0x14ec,
    sprite_x_speed = 0x00b6,
    sprite_y_speed = 0x00aa,
    sprite_x_offscreen = 0x15a0, 
    sprite_y_offscreen = 0x186c,
    sprite_miscellaneous1 = 0x00c2,
	sprite_miscellaneous2 = 0x1504,
	sprite_miscellaneous3 = 0x1510,
	sprite_miscellaneous4 = 0x151c,
	sprite_miscellaneous5 = 0x1528,
	sprite_miscellaneous6 = 0x1534,
	sprite_miscellaneous7 = 0x1540,
	sprite_miscellaneous8 = 0x154c,
	sprite_miscellaneous9 = 0x1558,
	sprite_miscellaneous10 = 0x1564,
	sprite_miscellaneous11 = 0x1570,
	sprite_miscellaneous12 = 0x157c,
	sprite_miscellaneous13 = 0x1594,
	sprite_miscellaneous14 = 0x15ac,
	sprite_miscellaneous15 = 0x1602,
    sprite_miscellaneous16 = 0x160e,
    sprite_miscellaneous17 = 0x1626,
    sprite_miscellaneous18 = 0x163e,
    sprite_miscellaneous19 = 0x187b,
    sprite_underwater = 0x164a,
    sprite_disable_cape = 0x1fe2,
    sprite_1_tweaker = 0x1656,
    sprite_2_tweaker = 0x1662,
    sprite_3_tweaker = 0x166e,
    sprite_4_tweaker = 0x167a,
    sprite_5_tweaker = 0x1686,
    sprite_6_tweaker = 0x190f,
    sprite_tongue_wait = 0x14a3,
    sprite_yoshi_squatting = 0x18af,
    sprite_buoyancy = 0x190e,
    
    -- Extended sprites
    extspr_number = 0x170b,
    extspr_x_high = 0x1733,
    extspr_x_low = 0x171f,
    extspr_y_high = 0x1729,
    extspr_y_low = 0x1715,
    extspr_x_speed = 0x1747,
    extspr_y_speed = 0x173d,
    extspr_suby = 0x1751,
    extspr_subx = 0x175b,
    extspr_table = 0x1765,
    extspr_table2 = 0x176f,
    
    -- Cluster sprites
    cluspr_flag = 0x18b8,
    cluspr_number = 0x1892,
    cluspr_x_high = 0x1e3e,
    cluspr_x_low = 0x1e16,
    cluspr_y_high = 0x1e2a,
    cluspr_y_low = 0x1e02,
    cluspr_timer = 0x0f9a,
    cluspr_table_1 = 0x0f4a,
    cluspr_table_2 = 0x0f72,
    cluspr_table_3 = 0x0f86,
    reappearing_boo_counter = 0x190a,
    
    -- Minor extended sprites
    minorspr_number = 0x17f0,
    minorspr_x_high = 0x18ea,
    minorspr_x_low = 0x1808,
    minorspr_y_high = 0x1814,
    minorspr_y_low = 0x17fc,
    minorspr_xspeed = 0x182c,
    minorspr_yspeed = 0x1820,
    minorspr_x_sub = 0x1844,
    minorspr_y_sub = 0x1838,
    minorspr_timer = 0x1850,
    
    -- Bounce sprites
    bouncespr_number = 0x1699,
    bouncespr_x_high = 0x16ad,
    bouncespr_x_low = 0x16a5,
    bouncespr_y_high = 0x16a9,
    bouncespr_y_low = 0x16a1,
    bouncespr_timer = 0x16c5,
    bouncespr_last_id = 0x18cd,
    turn_block_timer = 0x18ce,
    
    -- Player
    x = 0x0094,
    y = 0x0096,
    previous_x = 0x00d1,
    previous_y = 0x00d3,
    x_sub = 0x13da,
    y_sub = 0x13dc,
    x_speed = 0x007b,
    x_subspeed = 0x007a,
    y_speed = 0x007d,
    direction = 0x0076,
    is_ducking = 0x0073,
    p_meter = 0x13e4,
    take_off = 0x149f,
    powerup = 0x0019,
    cape_spin = 0x14a6,
    cape_fall = 0x14a5,
    cape_interaction = 0x13e8,
    flight_animation = 0x1407,
    diving_status = 0x1409,
    player_animation_trigger = 0x0071,
    climbing_status = 0x0074,
    spinjump_flag = 0x140d,
    player_blocked_status = 0x0077, 
    player_item = 0x0dc2, --hex
    cape_x = 0x13e9,
    cape_y = 0x13eb,
    on_ground = 0x13ef,
    on_ground_delay = 0x008d,
    on_air = 0x0072,
    can_jump_from_water = 0x13fa,
    carrying_item = 0x148f,
    mario_score = 0x0f34,
    player_coin = 0x0dbf,
    player_looking_up = 0x13de,
    
    -- Yoshi
    yoshi_riding_flag = 0x187a,  -- #$00 = No, #$01 = Yes, #$02 = Yes, and turning around.
    yoshi_tile_pos = 0x0d8c,
    
    -- Timers
    --pipe_entrance_timer = 0x0088,
    end_level_timer = 0x1493,
    --multicoin_block_timer = 0x186b,,
	switch_timer = 0x0CEC,
    
    -- Layers
    layer2_x_nextframe = 0x1466,
    layer2_y_nextframe = 0x1468,
}
for name, address in pairs(WRAM) do
    address = address + 0x7e0000  -- Snes9x
end
local WRAM = WRAM

local X_INTERACTION_POINTS = {center = 0x8, left_side = 0x2 + 1, left_foot = 0x5, right_side = 0xe - 1, right_foot = 0xb}

local Y_INTERACTION_POINTS = {
    {head = 0x10, center = 0x18, shoulder = 0x16, side = 0x1a, foot = 0x20, sprite = 0x15},
    {head = 0x08, center = 0x12, shoulder = 0x0f, side = 0x1a, foot = 0x20, sprite = 0x07},
    {head = 0x13, center = 0x1d, shoulder = 0x19, side = 0x28, foot = 0x30, sprite = 0x19},
    {head = 0x10, center = 0x1a, shoulder = 0x16, side = 0x28, foot = 0x30, sprite = 0x11}
}

local HITBOX_SPRITE = {  -- sprites' hitbox against player and other sprites
    [0x00] = { xoff = 2, yoff = 3, width = 12, height = 10, oscillation = true },
    [0x01] = { xoff = 2, yoff = 3, width = 12, height = 21, oscillation = true },
    [0x02] = { xoff = 16, yoff = -2, width = 16, height = 18, oscillation = true },
    [0x03] = { xoff = 20, yoff = 8, width = 8, height = 8, oscillation = true },
    [0x04] = { xoff = 0, yoff = -2, width = 48, height = 14, oscillation = true },
    [0x05] = { xoff = 0, yoff = -2, width = 80, height = 14, oscillation = true },
    [0x06] = { xoff = 1, yoff = 2, width = 14, height = 24, oscillation = true },
    [0x07] = { xoff = 8, yoff = 8, width = 40, height = 48, oscillation = true },
    [0x08] = { xoff = -8, yoff = -2, width = 32, height = 16, oscillation = true },
    [0x09] = { xoff = -2, yoff = 8, width = 20, height = 30, oscillation = true },
    [0x0a] = { xoff = 3, yoff = 7, width = 1, height = 2, oscillation = true },
    [0x0b] = { xoff = 6, yoff = 6, width = 3, height = 3, oscillation = true },
    [0x0c] = { xoff = 1, yoff = -2, width = 13, height = 22, oscillation = true },
    [0x0d] = { xoff = 0, yoff = -4, width = 15, height = 16, oscillation = true },
    [0x0e] = { xoff = 6, yoff = 6, width = 20, height = 20, oscillation = true },
    [0x0f] = { xoff = 2, yoff = -2, width = 36, height = 18, oscillation = true },
    [0x10] = { xoff = 0, yoff = -2, width = 15, height = 32, oscillation = true },
    [0x11] = { xoff = -24, yoff = -24, width = 64, height = 64, oscillation = true },
    [0x12] = { xoff = -4, yoff = 16, width = 8, height = 52, oscillation = true },
    [0x13] = { xoff = -4, yoff = 16, width = 8, height = 116, oscillation = true },
    [0x14] = { xoff = 4, yoff = 2, width = 24, height = 12, oscillation = true },
    [0x15] = { xoff = 0, yoff = -2, width = 15, height = 14, oscillation = true },
    [0x16] = { xoff = -4, yoff = -12, width = 24, height = 24, oscillation = true },
    [0x17] = { xoff = 2, yoff = 8, width = 12, height = 69, oscillation = true },
    [0x18] = { xoff = 2, yoff = 19, width = 12, height = 58, oscillation = true },
    [0x19] = { xoff = 2, yoff = 35, width = 12, height = 42, oscillation = true },
    [0x1a] = { xoff = 2, yoff = 51, width = 12, height = 26, oscillation = true },
    [0x1b] = { xoff = 2, yoff = 67, width = 12, height = 10, oscillation = true },
    [0x1c] = { xoff = 0, yoff = 10, width = 10, height = 48, oscillation = true },
    [0x1d] = { xoff = 2, yoff = -3, width = 28, height = 27, oscillation = true },
    [0x1e] = { xoff = 6, yoff = -8, width = 3, height = 32, oscillation = true },  -- default: { xoff = -32, yoff = -8, width = 48, height = 32, oscillation = true },
    [0x1f] = { xoff = -16, yoff = -4, width = 48, height = 18, oscillation = true },
    [0x20] = { xoff = -4, yoff = -24, width = 8, height = 24, oscillation = true },
    [0x21] = { xoff = -4, yoff = 16, width = 8, height = 24, oscillation = true },
    [0x22] = { xoff = 0, yoff = 0, width = 16, height = 16, oscillation = true },
    [0x23] = { xoff = -8, yoff = -24, width = 32, height = 32, oscillation = true },
    [0x24] = { xoff = -12, yoff = 32, width = 56, height = 56, oscillation = true },
    [0x25] = { xoff = -14, yoff = 4, width = 60, height = 20, oscillation = true },
    [0x26] = { xoff = 0, yoff = 88, width = 32, height = 8, oscillation = true },
    [0x27] = { xoff = -4, yoff = -4, width = 24, height = 24, oscillation = true },
    [0x28] = { xoff = -14, yoff = -24, width = 28, height = 40, oscillation = true },
    [0x29] = { xoff = -16, yoff = -4, width = 32, height = 27, oscillation = true },
    [0x2a] = { xoff = 2, yoff = -8, width = 12, height = 19, oscillation = true },
    [0x2b] = { xoff = 0, yoff = 2, width = 16, height = 76, oscillation = true },
    [0x2c] = { xoff = -8, yoff = -8, width = 16, height = 16, oscillation = true },
    [0x2d] = { xoff = 4, yoff = 4, width = 8, height = 4, oscillation = true },
    [0x2e] = { xoff = 2, yoff = -2, width = 28, height = 34, oscillation = true },
    [0x2f] = { xoff = 2, yoff = -2, width = 28, height = 32, oscillation = true },
    [0x30] = { xoff = 8, yoff = -14, width = 16, height = 28, oscillation = true },
    [0x31] = { xoff = 0, yoff = -2, width = 48, height = 18, oscillation = true },
    [0x32] = { xoff = 0, yoff = -2, width = 48, height = 18, oscillation = true },
    [0x33] = { xoff = 0, yoff = -2, width = 64, height = 18, oscillation = true },
    [0x34] = { xoff = -4, yoff = -4, width = 8, height = 8, oscillation = true },
    [0x35] = { xoff = 3, yoff = 0, width = 18, height = 32, oscillation = true },
    [0x36] = { xoff = 8, yoff = 8, width = 52, height = 46, oscillation = true },
    [0x37] = { xoff = 0, yoff = -8, width = 15, height = 20, oscillation = true },
    [0x38] = { xoff = 8, yoff = 16, width = 32, height = 40, oscillation = true },
    [0x39] = { xoff = 4, yoff = 3, width = 8, height = 10, oscillation = true },
    [0x3a] = { xoff = -8, yoff = 16, width = 32, height = 16, oscillation = true },
    [0x3b] = { xoff = 0, yoff = 0, width = 16, height = 13, oscillation = true },
    [0x3c] = { xoff = 12, yoff = 10, width = 3, height = 6, oscillation = true },
    [0x3d] = { xoff = 12, yoff = 21, width = 3, height = 20, oscillation = true },
    [0x3e] = { xoff = 16, yoff = 18, width = 254, height = 16, oscillation = true },
    [0x3f] = { xoff = 8, yoff = 8, width = 8, height = 24, oscillation = true }
}

local OBJ_CLIPPING_SPRITE = {  -- sprites' interaction points against objects
    [0x0] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  2},
    [0x1] = {xright = 14, xleft =  2, xdown =  7, xup =  7, yright = 18, yleft = 18, ydown = 32, yup =  2},
    [0x2] = {xright =  7, xleft =  7, xdown =  7, xup =  7, yright =  7, yleft =  7, ydown =  7, yup =  7},
    [0x3] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright = 16, yleft = 16, ydown = 32, yup = 11},
    [0x4] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright = 18, yleft = 18, ydown = 32, yup =  2},
    [0x5] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright = 24, yleft = 24, ydown = 32, yup = 16},
    [0x6] = {xright =  7, xleft =  0, xdown =  4, xup =  4, yright =  4, yleft =  4, ydown =  8, yup =  0},
    [0x7] = {xright = 31, xleft =  1, xdown = 16, xup = 16, yright = 16, yleft = 16, ydown = 31, yup =  1},
    [0x8] = {xright = 15, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 15, yup =  0},
    [0x9] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  0},
    [0xa] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright = 72, yleft = 72, ydown = 80, yup = 66},
    [0xb] = {xright = 14, xleft =  2, xdown =  8, xup =  8, yright =  4, yleft =  4, ydown =  8, yup =  0},
    [0xc] = {xright = 13, xleft =  2, xdown =  8, xup =  8, yright =  0, yleft =  0, ydown =  0, yup =  0},
    [0xd] = {xright = 16, xleft =  0, xdown =  8, xup =  8, yright =  8, yleft =  8, ydown = 16, yup =  0},
    [0xe] = {xright = 31, xleft =  0, xdown = 16, xup = 16, yright =  8, yleft =  8, ydown = 16, yup =  0},
    [0xf] = {xright =  8, xleft =  8, xdown =  8, xup = 16, yright =  4, yleft =  1, ydown =  2, yup =  4}
}

local HITBOX_EXTENDED_SPRITE = {  -- extended sprites' hitbox
    -- To fill the slots...
    --[0] ={ xoff = 3, yoff = 3, width = 64, height = 64},  -- Free slot
    [0x01] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Puff of smoke with various objects
    [0x0e] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Wiggler's flower
    [0x0f] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Trail of smoke
    [0x10] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Spinjump stars
    [0x12] ={ xoff = 3, yoff = 3, width =  0, height =  0},  -- Water bubble
    -- extracted from ROM:
    [0x02] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Reznor fireball
    [0x03] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball},  -- Flame left by hopping flame
    [0x04] = { xoff = 4, yoff = 4, width = 8, height = 8},  -- Hammer
    [0x05] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Player fireball
    [0x06] = { xoff = 4, yoff = 4, width = 8, height = 8},  -- Bone from Dry Bones
    [0x07] = { xoff = 0, yoff = 0, width = 0, height = 0},  -- Lava splash
    [0x08] = { xoff = 0, yoff = 0, width = 0, height = 0},  -- Torpedo Ted shooter's arm
    [0x09] = { xoff = 0, yoff = 0, width = 15, height = 15},  -- Unknown flickering object
    [0x0a] = { xoff = 4, yoff = 2, width = 8, height = 12},  -- Coin from coin cloud game
    [0x0b] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Piranha Plant fireball
    [0x0c] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.fireball },  -- Lava Lotus's fiery objects
    [0x0d] = { xoff = 3, yoff = 3, width = 1, height = 1, color_line = COLOUR.baseball },  -- Baseball
    -- got experimentally:
    [0x11] = { xoff = -0x1, yoff = -0x4, width = 11, height = 19},  -- Yoshi fireballs
}

local HITBOX_CLUSTER_SPRITE = {  -- got experimentally
    --[0] -- Free slot
    [0x01] = { xoff = 2, yoff = 0, width = 17, height = 21, oscillation = 2, phase = 1, color = COLOUR.awkward_hitbox, bg = COLOUR.awkward_hitbox_bg},  -- 1-Up from bonus game (glitched hitbox area)
    [0x02] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Unused
    [0x03] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Boo from Boo Ceiling
    [0x04] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Boo from Boo Ring
    [0x05] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Castle candle flame (meaningless hitbox)
    [0x06] = { xoff = 2, yoff = 2, width = 12, height = 20, oscillation = 4, color = COLOUR.sumo_brother_flame},  -- Sumo Brother lightning flames
    [0x07] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Reappearing Boo
    [0x08] = { xoff = 4, yoff = 7, width = 7, height = 7, oscillation = 4},  -- Swooper bat from Swooper Death Bat Ceiling (untested)
}

;                              -- 0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f  10 11 12
local SPRITE_MEMORY_MAX = {[0] = 10, 6, 7, 6, 7, 5, 8, 5, 7, 9, 9, 4, 8, 6, 8, 9, 10, 6, 6}  -- the max of sprites in a room

-- Creates a set from a list
local function make_set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

-- from sprite number, returns oscillation flag
-- A sprite must be here iff it processes interaction with player every frame AND this bit is not working in the sprite_4_tweaker WRAM(0x167a)
local OSCILLATION_SPRITES = make_set{0x0e, 0x21, 0x29, 0x35, 0x54, 0x74, 0x75, 0x76, 0x77, 0x78, 0x81, 0x83, 0x87}

-- Sprites that have a custom hitbox drawing
local ABNORMAL_HITBOX_SPRITES = make_set{0x62, 0x63, 0x6b, 0x6c}

-- Sprites whose clipping interaction points usually matter
local GOOD_SPRITES_CLIPPING = make_set{
0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xf, 0x10, 0x11, 0x13, 0x14, 0x18,
0x1b, 0x1d, 0x1f, 0x20, 0x26, 0x27, 0x29, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f, 0x30, 0x31,
0x32, 0x34, 0x35, 0x3d, 0x3e, 0x3f, 0x40, 0x46, 0x47, 0x48, 0x4d, 0x4e,
0x51, 0x53, 0x6e, 0x6f, 0x70, 0x80, 0x81, 0x86, 
0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0xa1, 0xa2, 0xa5, 0xa6, 0xa7, 0xab, 0xb2,
0xb4, 0xbb, 0xbc, 0xbd, 0xbf, 0xc3, 0xda, 0xdb, 0xdc, 0xdd, 0xdf
}

-- Extended sprites that don't interact with the player
local UNINTERESTING_EXTENDED_SPRITES = make_set{1, 7, 8, 0x0e, 0x10, 0x12}

--#############################################################################
-- SCRIPT UTILITIES:


-- Variables used in various functions
local Cheat = {}  -- family of cheat functions and variables
local Previous = {}
local User_input = INPUT_KEYNAMES -- Snes9x
local Tiletable = {}
local Joypad = {}
local Layer1_tiles = {}
local Layer2_tiles = {}
local Is_lagged = nil
local Options_menu = {show_menu = false, current_tab = "Show/hide options"}
local Filter_opacity, Filter_color = 0, "#000000ff"  -- Snes9x specifc / unlisted color
local Mario_boost_indicator = nil
local Show_player_point_position = false
local Sprites_info = {}  -- keeps track of useful sprite info that might be used outside the main sprite function
local Sprite_hitbox = {}  -- keeps track of what sprite slots must display the hitbox
local Memory = {} -- family of memory edit functions and variables

-- Initialization of some tables
for i = 0, SMW2.sprite_max -1 do
    Sprites_info[i] = {}
end
for key = 0, SMW2.sprite_max - 1 do
    Sprite_hitbox[key] = {}
    for number = 0, 0xff do
        Sprite_hitbox[key][number] = {["sprite"] = true, ["block"] = GOOD_SPRITES_CLIPPING[number]}
    end
end

-- Sum of the digits of a integer
local function sum_digits(number)
    local sum = 0
    while number > 0 do
        sum = sum + number%10
        number = floor(number*0.1)
    end
    
    return sum
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
            if bit.test(data, size - i) then
                result = result .. ch
            else
                result = result .. " "
            end
            i = i + 1
        end
    else
        result = {}
        for ch in base:gmatch(".") do
            if bit.test(data, size-i) then
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


function bit.test(value, bitnum)  -- Snes9x
    return bit.rshift(value, bitnum)%2 == 1
end


local function mouse_onregion(x1, y1, x2, y2)
    -- Reads external mouse coordinates
    local mouse_x = User_input.xmouse
    local mouse_y = User_input.ymouse
    
    -- From top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    if mouse_x >= x1 and mouse_x <= x2 and  mouse_y >= y1 and mouse_y <= y2 then
        return true
    else
        return false
    end
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


-- A cross sign with pos and size
gui.crosshair = gui.crosshair or function(x, y, size, color)
    gui.line(x - size, y, x + size, y, color)
    gui.line(x, y-size, x, y+size, color)
end


local Movie_active, Readonly, Framecount, Lagcount, Rerecords
local Lastframe_emulated, Starting_subframe_last_frame, Size_last_frame, Final_subframe_last_frame
local Nextframe, Starting_subframe_next_frame, Starting_subframe_next_frame, Final_subframe_next_frame
local function snes9x_status()
    Movie_active = movie.active()  -- Snes9x
    Readonly = movie.playing()  -- Snes9x
    Framecount = movie.length()
    Lagcount = emu.lagcount() -- Snes9x
    Rerecords = movie.rerecordcount()
    
    -- Last frame info
    Lastframe_emulated = emu.framecount()
    
    -- Next frame info (only relevant in readonly mode)
    Nextframe = Lastframe_emulated + 1
    
end


-- draw a pixel given (x,y) with SNES' pixel sizes
local draw_pixel = gui.pixel


-- draws a line given (x,y) and (x',y') with given scale and SNES' pixel thickness (whose scale is 2) -- EDIT
local function draw_line(x1, y1, x2, y2, scale, color)
    -- Draw from top-left to bottom-right
    if x2 < x1 then
        x1, x2 = x2, x1
    end
    if y2 < y1 then
        y1, y2 = y2, y1
    end
    
    x1, y1, x2, y2 = scale*x1, scale*y1, scale*x2, scale*y2
    gui.line(x1, y1, x2, y2, color)
end


-- draws a box given (x,y) and (x',y') with SNES' pixel sizes
local draw_box = function(x1, y1, x2, y2, line, fill)
    gui.box(x1, y1, x2, y2, fill, line)
end


-- draws a rectangle given (x,y) and dimensions, with SNES' pixel sizes
local draw_rectangle = function(x, y, w, h, line, fill)
    gui.box(x, y, x + w, y + h, fill, line)
end


-- Takes a position and dimensions of a rectangle and returns a new position if this rectangle has points outside the screen
local function put_on_screen(x, y, width, height)
    local x_screen, y_screen
    width = width or 0
    height = height or 0
    
    if x < - Border_left then
        x_screen = - Border_left
    elseif x > Buffer_width + Border_right - width then
        x_screen = Buffer_width + Border_right - width
    else
        x_screen = x
    end
    
    if y < - Border_top then
        y_screen = - Border_top
    elseif y > Buffer_height + Border_bottom - height then
        y_screen = Buffer_height + Border_bottom - height
    else
        y_screen = y
    end
    
    return x_screen, y_screen
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
    local border_left     = 0
    local border_right    = 0
    local border_top      = 0
    local border_bottom   = 0
    local buffer_width    = 256
    local buffer_height   = 224
    
    -- text processing
    local text_length = text and string.len(text)*font_width or font_width  -- considering another objects, like bitmaps
    
    -- actual position, relative to game area origin
    x = (not ref_x and x) or (ref_x == 0 and x) or x - floor(text_length*ref_x)
    y = (not ref_y and y) or (ref_y == 0 and y) or y - floor(font_height*ref_y)
    
    -- adjustment needed if text is supposed to be on screen area
    local x_end = x + text_length
    local y_end = y + font_height
    
    if always_on_game then
        if x < 0 then x = 0 end
        if y < 0 then y = 0 end
        
        if x_end > buffer_width  then x = buffer_width  - text_length end
        if y_end > buffer_height then y = buffer_height - font_height end
        
    elseif always_on_client then
        if x < -border_left then x = -border_left end
        if y < -border_top  then y = -border_top  end
        
        if x_end > buffer_width  + border_right  then x = buffer_width  + border_right  - text_length end
        if y_end > buffer_height + border_bottom then y = buffer_height + border_bottom - font_height end
    end
    
    return x, y, text_length
end


-- Complex function for drawing, that uses text_position
local function draw_text(x, y, text, ...)
    -- Reads external variables
    local font_name = Font or false
    local font_width  = SNES9X_FONT_WIDTH
    local font_height = SNES9X_FONT_HEIGHT
    local bg_default_color = font_name and COLOUR.outline or COLOUR.background
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
    
    local x_pos, y_pos, length = text_position(x, y, text, font_width, font_height,
                                    always_on_client, always_on_game, ref_x, ref_y)
    ;
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_pos, y_pos, text, text_color, bg_color)
    gui.opacity(1.0) -- Snes9x
    
    return x_pos + length, y_pos + font_height, length
end


local function alert_text(x, y, text, text_color, bg_color, always_on_game, ref_x, ref_y)
    -- Reads external variables
    local font_width  = SNES9X_FONT_WIDTH
    local font_height = SNES9X_FONT_HEIGHT
    
    local x_pos, y_pos, text_length = text_position(x, y, text, font_width, font_height, false, always_on_game, ref_x, ref_y)
    
    gui.opacity(Background_max_opacity * Bg_opacity)
    draw_rectangle(x_pos, y_pos, text_length - 1, font_height - 1, bg_color, bg_color)  -- Snes9x
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_pos, y_pos, text, text_color, 0)
    gui.opacity(1.0)
end


local function draw_over_text(x, y, value, base, color_base, color_value, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    value = decode_bits(value, base)
    local x_end, y_end, length = draw_text(x, y, base,  color_base, color_bg, always_on_client, always_on_game, ref_x, ref_y)
    gui.opacity(Text_max_opacity * Text_opacity)
    gui.text(x_end - length, y_end - SNES9X_FONT_HEIGHT, value, color_value or COLOUR.text)
    gui.opacity(1.0)
    
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
        always_on_client, always_on_game, ref_x, ref_y, button_pressed = extra_options.always_on_client, extra_options.always_on_game,
                                                                extra_options.ref_x, extra_options.ref_y, extra_options.button_pressed
    end
    
    local width, height
    local object_type = type(object)
    
    if object_type == "string" then
        width, height = SNES9X_FONT_WIDTH, SNES9X_FONT_HEIGHT
        x, y, width = text_position(x, y, object, width, height, always_on_client, always_on_game, ref_x, ref_y)
    elseif object_type == "boolean" then
        width, height = SNES9X_FONT_WIDTH, SNES9X_FONT_HEIGHT
        x, y = text_position(x, y, nil, width, height, always_on_client, always_on_game, ref_x, ref_y)
    else error"Type of buttton not supported yet"
    end
    
    -- draw the button
    if button_pressed then
        draw_rectangle(x, y, width, height, "white", "#d8d8d8ff")  -- unlisted colours
    else
        draw_rectangle(x, y, width, height, "#606060ff", "#b0b0b0ff")
    end
    gui.line(x, y, x + width, y, button_pressed and "#606060ff" or "white")
    gui.line(x, y, x, y + height, button_pressed and "#606060ff" or "white")
    
    if object_type == "string" then
        gui.text(x + 1, y + 1, object, COLOUR.button_text, 0)
    elseif object_type == "boolean" then
        draw_rectangle(x + 1, y + 1, width - 2, height - 2, "#00ff0080", "#00ff00c0")
    end
    
    -- updates the table of buttons
    table.insert(Script_buttons, {x = x, y = y, width = width, height = height, object = object, action = fn})
end


function Options_menu.print_help()
    print("\n")
    print(" - - - TIPS - - - ")
    print("MOUSE:")
    print("Use the left click to draw blocks and to see the Map16 properties.")
    print("Use the right click to toogle the hitbox mode of Mario and sprites.")
    print("\n")
    
    print("CHEATS(better turn off while recording a movie):")
    print("L+R+up: stop gravity for Mario fly / L+R+down to cancel")
    print("Use the mouse to drag and drop sprites")
    print("While paused: B+select to get out of the level")
    print("              X+select to beat the level (main exit)")
    print("              A+select to get the secret exit (don't use it if there isn't one)")
    
    print("\n")
    print("OTHERS:")
    print(fmt("Press \"%s\" for more and \"%s\" for less opacity.", OPTIONS.hotkey_increase_opacity, OPTIONS.hotkey_decrease_opacity))
    print("It's better to play without the mouse over the game window.")
    print(" - - - end of tips - - - ")
end

local poked = false
local apply = false
function Options_menu.display()
    if not Options_menu.show_menu then return end
    
    -- Pauses emulator and draws the background
    Text_opacity = 1.0
    draw_rectangle(0, 0, Buffer_width, Buffer_height, COLOUR.mainmenu_outline, COLOUR.mainmenu_bg)
    
    -- Font stuff
    local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT + 4
    local x_pos, y_pos = 4, 4
    local tmp
    
    -- Exit menu button
    gui.box(0, 0, Buffer_width, delta_y, "#ffffff60", "#ffffff60") -- tab's shadow / unlisted color
    create_button(Buffer_width, 0, " X ", function() Options_menu.show_menu = false end, {always_on_client = true, always_on_game = true})
    
    -- Tabs
    create_button(x_pos, y_pos, "Show/hide", function() Options_menu.current_tab = "Show/hide options" end,
    {button_pressed = Options_menu.current_tab == "Show/hide options"})
    x_pos = x_pos + 9*delta_x + 2
    create_button(x_pos, y_pos, "Settings", function() Options_menu.current_tab = "Misc options" end,
    {button_pressed = Options_menu.current_tab == "Misc options"})
    x_pos = x_pos + 8*delta_x + 2
    create_button(x_pos, y_pos, "Cheats", function() Options_menu.current_tab = "Cheats" end,
    {button_pressed = Options_menu.current_tab == "Cheats"})
    x_pos = x_pos + 6*delta_x + 2
    create_button(x_pos, y_pos, "Debug info", function() Options_menu.current_tab = "Debug info" end,
    {button_pressed = Options_menu.current_tab == "Debug info"})
    x_pos = x_pos + 10*delta_x + 2
    create_button(x_pos, y_pos, "Misc tables", function() Options_menu.current_tab = "Sprite miscellaneous tables" end,
    {button_pressed = Options_menu.current_tab == "Sprite miscellaneous tables"})
    x_pos = x_pos + 11*delta_x + 2
    create_button(x_pos, y_pos, "Memory edit", function() Options_menu.current_tab = "Memory edit" end,
    {button_pressed = Options_menu.current_tab == "Memory edit"})
    
    x_pos, y_pos = 4, y_pos + delta_y + 4
    if Options_menu.current_tab == "Show/hide options" then
        
        tmp = OPTIONS.display_debug_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_info = not OPTIONS.display_debug_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Some Debug Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_movie_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_movie_info = not OPTIONS.display_movie_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Display Movie Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_misc_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_misc_info = not OPTIONS.display_misc_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Display Misc Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_player_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_player_info = not OPTIONS.display_player_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Player Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_sprite_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_sprite_info = not OPTIONS.display_sprite_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Sprite Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_sprite_hitbox and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_sprite_hitbox = not OPTIONS.display_sprite_hitbox end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Sprite Hitbox?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_extended_sprite_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_extended_sprite_info = not OPTIONS.display_extended_sprite_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Extended Sprite Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_cluster_sprite_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_cluster_sprite_info = not OPTIONS.display_cluster_sprite_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Cluster Sprite Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_minor_extended_sprite_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_minor_extended_sprite_info = not OPTIONS.display_minor_extended_sprite_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Minor Ext. Spr. Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_bounce_sprite_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_bounce_sprite_info = not OPTIONS.display_bounce_sprite_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Bounce Sprite Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_level_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_level_info = not OPTIONS.display_level_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Level Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_yoshi_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_yoshi_info = not OPTIONS.display_yoshi_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Yoshi Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_counters and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_counters = not OPTIONS.display_counters end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Counters Info?")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_static_camera_region and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_static_camera_region = not OPTIONS.display_static_camera_region end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Static Camera Region?")
        y_pos = y_pos + delta_y
        
    elseif Options_menu.current_tab == "Cheats" then
        
        tmp = Cheat.allow_cheats and true or " "
        create_button(x_pos, y_pos, tmp, function() Cheat.allow_cheats = not Cheat.allow_cheats end)
        gui.text(x_pos + delta_x + 3, y_pos, "Allow Cheats?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
        
        if Cheat.allow_cheats then
            local value, widget_pointer
            
            -- Powerup
            value = u8(WRAM.powerup)
            gui.text(x_pos, y_pos, fmt("Powerup:%3d", value))
            create_button(x_pos + 11*SNES9X_FONT_WIDTH + 2, y_pos, "-", function() Cheat.change_address(WRAM.powerup, -1) end)
            create_button(x_pos + 12*SNES9X_FONT_WIDTH + 4, y_pos, "+", function() Cheat.change_address(WRAM.powerup, 1) end)
            y_pos = y_pos + delta_y
            
            -- Score
            value = u24(WRAM.mario_score)
            gui.text(x_pos, y_pos, fmt("Score:%7d0", value))
            create_button(x_pos + 14*SNES9X_FONT_WIDTH + 2, y_pos, "-", function() Cheat.change_address(WRAM.mario_score, -1, 3) end)
            create_button(x_pos + 15*SNES9X_FONT_WIDTH + 4, y_pos, "+", function() Cheat.change_address(WRAM.mario_score, 1, 3) end)
            y_pos = y_pos + 2
            draw_line(x_pos, y_pos + SNES9X_FONT_HEIGHT, x_pos + 100, y_pos + SNES9X_FONT_HEIGHT, 1, COLOUR.weak)  -- Snes9x: basic widget hack
            widget_pointer = floor(100*math.sqrt((value)/1000000))
            if mouse_onregion(x_pos, y_pos + SNES9X_FONT_HEIGHT - 2, x_pos + 100, y_pos + SNES9X_FONT_HEIGHT + 2) and User_input.leftclick then
                value = math.min(999999, 100*(User_input.xmouse - x_pos)^2)
                w24(WRAM.mario_score, value)
            end
            draw_rectangle(x_pos + widget_pointer - 1, y_pos + SNES9X_FONT_HEIGHT - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
            y_pos = y_pos + delta_y
            
            -- Coins
            value = u8(WRAM.player_coin)
            gui.text(x_pos, y_pos, fmt("Coins:%3d", value))
            create_button(x_pos +  9*SNES9X_FONT_WIDTH + 2, y_pos, "-", function() Cheat.change_address(WRAM.player_coin, -1) end)
            create_button(x_pos + 10*SNES9X_FONT_WIDTH + 4, y_pos, "+", function() Cheat.change_address(WRAM.player_coin, 1) end)
            y_pos = y_pos + delta_y
        end
        
    elseif Options_menu.current_tab == "Misc options" then
        
        tmp = OPTIONS.draw_tiles_with_click and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.draw_tiles_with_click = not OPTIONS.draw_tiles_with_click end)
        gui.text(x_pos + delta_x + 3, y_pos, "Draw tiles with left click?")
        y_pos = y_pos + delta_y
        
        create_button(x_pos, y_pos, "Erase Tiles", function() Tiletable = {}; Layer1_tiles = {}; Layer2_tiles = {} end)
        y_pos = y_pos + delta_y
        
        -- Manage opacity / filter
        y_pos = y_pos + delta_y
        gui.text(x_pos, y_pos, "Opacity:")
        y_pos = y_pos + delta_y
        create_button(x_pos, y_pos, "-", function() if Filter_opacity >= 1 then Filter_opacity = Filter_opacity - 1 end end)
        create_button(x_pos + delta_x + 2, y_pos, "+", function()
            if Filter_opacity <= 9 then Filter_opacity = Filter_opacity + 1 end
        end)
        gui.text(x_pos + 2*delta_x + 5, y_pos, "Change filter opacity (" .. 10*Filter_opacity .. "%)")
        y_pos = y_pos + delta_y
        
        create_button(x_pos, y_pos, "-", decrease_opacity)
        create_button(x_pos + delta_x + 2, y_pos, "+", increase_opacity)
        gui.text(x_pos + 2*delta_x + 5, y_pos, ("Text opacity: (%.0f%%, %.0f%%)"):
            format(100*Text_max_opacity, 100*Background_max_opacity))
        y_pos = y_pos + delta_y
        gui.text(x_pos, y_pos, ("'%s' and '%s' are hotkeys for this."):
            format(OPTIONS.hotkey_decrease_opacity, OPTIONS.hotkey_increase_opacity), COLOUR.weak)
        y_pos = y_pos + delta_y
		
		tmp = OPTIONS.display_mouse_coordinates and true or " "
		create_button(x_pos, y_pos, tmp, function() OPTIONS.display_mouse_coordinates = not OPTIONS.display_mouse_coordinates end)
        gui.text(x_pos + delta_x + 3, y_pos, "Display mouse coordinates?")
        y_pos = y_pos + delta_y
        
        -- Others
        y_pos = y_pos + delta_y
        gui.text(x_pos, y_pos, "Help:")
        y_pos = y_pos + delta_y
        create_button(x_pos, y_pos, "Show tips in Snes9x: Console", Options_menu.print_help)
        
    elseif Options_menu.current_tab == "Debug info" then
        tmp = OPTIONS.display_debug_info and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_info = not OPTIONS.display_debug_info end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Some Debug Info?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
        
        tmp = OPTIONS.display_debug_player_extra and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_player_extra = not OPTIONS.display_debug_player_extra end)
        gui.text(x_pos + delta_x + 3, y_pos, "Player extra info")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_sprite_extra and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_sprite_extra = not OPTIONS.display_debug_sprite_extra end)
        gui.text(x_pos + delta_x + 3, y_pos, "Sprite extra info")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_sprite_tweakers and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_sprite_tweakers = not OPTIONS.display_debug_sprite_tweakers end)
        gui.text(x_pos + delta_x + 3, y_pos, "Sprite tweakers")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_extended_sprite and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_extended_sprite = not OPTIONS.display_debug_extended_sprite end)
        gui.text(x_pos + delta_x + 3, y_pos, "Extended sprites")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_cluster_sprite and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_cluster_sprite = not OPTIONS.display_debug_cluster_sprite end)
        gui.text(x_pos + delta_x + 3, y_pos, "Cluster sprites")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_minor_extended_sprite and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_minor_extended_sprite = not OPTIONS.display_debug_minor end)
        gui.text(x_pos + delta_x + 3, y_pos, "Minor Ext. sprites")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_bounce_sprite and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_bounce_sprite = not OPTIONS.display_debug_bounce_sprite end)
        gui.text(x_pos + delta_x + 3, y_pos, "Bounce sprites")
        y_pos = y_pos + delta_y
        
        tmp = OPTIONS.display_debug_controller_data and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_debug_controller_data = not OPTIONS.display_debug_controller_data end)
        gui.text(x_pos + delta_x + 3, y_pos, "Controller data (might cause desyncs!)", COLOUR.warning)
        y_pos = y_pos + delta_y
		
		local x_temp = 0
		-- Tile Map
		tmp_str = "Tile Map:"
        gui.text(x_pos, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 4
		
        tmp = OPTIONS.draw_tile_map_grid and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.draw_tile_map_grid = not OPTIONS.draw_tile_map_grid end)
		tmp_str = "Grid"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
		
		tmp = OPTIONS.draw_tile_map_type and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.draw_tile_map_type = not OPTIONS.draw_tile_map_type end)
		tmp_str = "Tile type"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
		
		--[[
        tmp = OPTIONS.draw_tile_map_gfx_type and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.draw_tile_map_gfx_type = not OPTIONS.draw_tile_map_gfx_type end)
		tmp_str = "Graphical type"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
		
        tmp = OPTIONS.draw_tile_map_phy_type and true or " "
        create_button(x_pos + x_temp, y_pos, tmp, function() OPTIONS.draw_tile_map_phy_type = not OPTIONS.draw_tile_map_phy_type end)
		tmp_str = "Physical type"
        gui.text(x_pos + x_temp + delta_x + 3, y_pos, tmp_str)
		x_temp = x_temp + 4*string.len(tmp_str) + 12
        y_pos = y_pos + delta_y]]
        
    elseif Options_menu.current_tab == "Sprite miscellaneous tables" then
        
        tmp = OPTIONS.display_miscellaneous_sprite_table and true or " "
        create_button(x_pos, y_pos, tmp, function() OPTIONS.display_miscellaneous_sprite_table = not OPTIONS.display_miscellaneous_sprite_table end)
        gui.text(x_pos + delta_x + 3, y_pos, "Show Miscellaneous Sprite Table?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
        
        local opt = OPTIONS.miscellaneous_sprite_table_number
        for i = 1, 19 do
            create_button(x_pos, y_pos, opt[i] and true or " ", function() opt[i] = not opt[i] end)
            gui.text(x_pos + delta_x + 3, y_pos, "Table " .. i)
            
            y_pos = y_pos + delta_y
            if i%10 == 0 then
                x_pos, y_pos = 4 + 20*SNES9X_FONT_WIDTH, 3*delta_y + 8
            end
        end
    
	elseif Options_menu.current_tab == "Memory edit" then
		
		tmp = Memory.allow_edit and true or " "
        create_button(x_pos, y_pos, tmp, function() Memory.allow_edit = not Memory.allow_edit apply = false end)
		gui.text(x_pos + delta_x + 3, y_pos, "Allow memory edit?", COLOUR.warning)
        y_pos = y_pos + 2*delta_y
		
		if Memory.allow_edit then
			local address = OPTIONS.address
			local value = OPTIONS.value
			local poke = true
			local freeze = false
			local size = OPTIONS.size
			local crescent = false
			Memory.edit_method = OPTIONS.edit_method
			local x_temp, y_temp
			local widget_pointer
			
			--- Address ---
			
			-- Address digits, from the right to the left
			
			local first_digit = read_digit(address, 6, 16) --floor((address-floor(address/16)*16)/1)
			local second_digit = read_digit(address, 5, 16) --floor((address-floor(address/(16^2))*(16^2))/16)
			local third_digit = read_digit(address, 4, 16) --floor((address-floor(address/(16^3))*(16^3))/(16^2))
			local fourth_digit = read_digit(address, 3, 16) --floor((address-floor(address/(16^4))*(16^4))/(16^3))
			local fifth_digit = read_digit(address, 2, 16) --floor((address-floor(address/(16^5))*(16^5))/(16^4))
			
			local address_shown = string.upper(fmt("%x", address))
			local width, height = 12, SNES9X_FONT_HEIGHT
			
			gui.text(x_pos + 1, y_pos + 13, "Address:", COLOUR.text)
			
			-- [ + ] buttons
			
			create_button(x_pos + 8*delta_x + 15, y_pos, " + ", function()
			if OPTIONS.address < 0x7F0000 then OPTIONS.address = OPTIONS.address + 0x10000 end INI.save_options() end)
			if OPTIONS.address >= 0x7f0000 then gui.text(x_pos + 8*delta_x + 16, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 28, y_pos, " + ", function()
			if OPTIONS.address + 0x1000 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x1000 end INI.save_options() end)
			if OPTIONS.address + 0x1000 > 0x800000 then gui.text(x_pos + 8*delta_x + 29, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 41, y_pos, " + ", function()
			if OPTIONS.address + 0x100 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x100 end INI.save_options() end)
			if OPTIONS.address + 0x100 > 0x800000 then gui.text(x_pos + 8*delta_x + 42, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 54, y_pos, " + ", function()
			if OPTIONS.address + 0x10 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x10 end INI.save_options() end)
			if OPTIONS.address + 0x10 > 0x800000 then gui.text(x_pos + 8*delta_x + 55, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 67, y_pos, " + ", function()
			if OPTIONS.address + 0x1 < 0x800000 then OPTIONS.address = OPTIONS.address + 0x1 end INI.save_options() end)
			if OPTIONS.address + 0x1 >= 0x800000 then gui.text(x_pos + 8*delta_x + 68, y_pos + 1, " + ", COLOUR.weak2, 0) end -- "disabled" button
			
			y_pos = y_pos + delta_y
			
			-- Digits boxes
			
			draw_rectangle(x_pos + 8*delta_x + 2, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 15, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 28, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 41, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 54, y_pos, width, height, COLOUR.text, COLOUR.background)
			draw_rectangle(x_pos + 8*delta_x + 67, y_pos, width, height, COLOUR.text, COLOUR.background)
			
			-- Digits
			
			x_pos = 43
			y_pos = y_pos + 1
			local colour = COLOUR.memory
			
			gui.text(x_pos, y_pos, "7", colour) x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", fifth_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", fourth_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", third_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", second_digit)), colour)  x_pos = x_pos + 13
			gui.text(x_pos, y_pos, string.upper(fmt("%x", first_digit)), colour)  x_pos = x_pos + 13
			y_pos = y_pos + delta_y - 1
			
			-- [ - ] buttons
			
			x_pos = 4
			
			create_button(x_pos + 8*delta_x + 15, y_pos, " - ", function()
			if OPTIONS.address >= 0x7F0000 then OPTIONS.address = OPTIONS.address - 0x10000 end INI.save_options() end)
			if OPTIONS.address < 0x7F0000 then gui.text(x_pos + 8*delta_x + 16, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 28, y_pos, " - ", function()
			if OPTIONS.address - 0x1000 > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x1000 end INI.save_options() end)
			if OPTIONS.address - 0x1000 < 0x7E0000 then gui.text(x_pos + 8*delta_x + 29, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 41, y_pos, " - ", function()
			if OPTIONS.address - 0x100 > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x100 end INI.save_options() end)
			if OPTIONS.address - 0x100 < 0x7E0000 then gui.text(x_pos + 8*delta_x + 42, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 54, y_pos, " - ", function()
			if OPTIONS.address - 0x10 > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x10 end INI.save_options() end)
			if OPTIONS.address - 0x10 < 0x7E0000 then gui.text(x_pos + 8*delta_x + 55, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			create_button(x_pos + 8*delta_x + 67, y_pos, " - ", function()
			if OPTIONS.address > 0x7E0000 then OPTIONS.address = OPTIONS.address - 0x1 end INI.save_options() end)
			if OPTIONS.address <= 0x7E0000 then gui.text(x_pos + 8*delta_x + 68, y_pos + 1, " - ", COLOUR.weak2, 0) end -- "disabled" button
			
			--- Size ---
			
			x_pos = 5
			y_pos = 90
			
			gui.text(x_pos, y_pos, "Size:", COLOUR.text)
			
			x_temp, y_temp = 0, delta_y
			create_button(x_pos + x_temp, y_pos + y_temp, "        ", function() OPTIONS.size = 1 INI.save_options() end)
			if size == 1 then draw_rectangle(x_pos + x_temp + 1, y_pos + y_temp + 1, 8*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") end
			gui.text(x_pos + delta_x + x_temp + 1, y_pos + y_temp + 1, "1 byte", COLOUR.button_text, 0)
			
			x_temp = 33
			create_button(x_pos + x_temp, y_pos + y_temp, "         ", function() OPTIONS.size = 2 INI.save_options() end)
			if size == 2 then draw_rectangle(x_pos + x_temp + 1, y_pos + y_temp + 1, 9*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") end
			gui.text(x_pos + delta_x + x_temp + 1, y_pos + y_temp + 1, "2 bytes", COLOUR.button_text, 0)
			
			--[[ REMOVE
			x_temp = 70
			create_button(x_pos + x_temp, y_pos + y_temp, "              ", function() OPTIONS.size = 58 INI.save_options() end)
			if size == 58 then draw_rectangle(x_pos + x_temp + 1, y_pos + y_temp + 1, 14*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") end
			gui.text(x_pos + delta_x + x_temp + 1, y_pos + y_temp + 1, "Sprite table", COLOUR.button_text, 0)]]
			
			--- Value ---
			
			x_pos = 5
			y_pos = 135
			y_temp = 38
			
			gui.text(x_pos, y_pos, "Value:", COLOUR.text)
			gui.text(x_pos + delta_x, y_pos + delta_y, "in hex", COLOUR.text)
			gui.text(x_pos + delta_x, y_pos + y_temp, "in dec", COLOUR.text)
			
			if size == 1 or size == 58 then -- 2 digits
				-- Correction, so the value loops when you overflow/underflow
				if OPTIONS.value > 0xFF then OPTIONS.value = OPTIONS.value%256
				elseif  OPTIONS.value < 0 then OPTIONS.value = OPTIONS.value + 0x100 end
				
				-- Display in decimal
				local value_dec_shown = fmt("%03d", value)
			 	draw_rectangle(x_pos + 8*delta_x, y_pos + y_temp - 1, width + 4, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + 8*delta_x + 3, y_pos + y_temp, value_dec_shown, colour)
				
				
				-- Value digits, from the right to the left
				first_digit = string.upper(fmt("%x", floor((value-floor(value/(16^2))*(16^2))/16)))
				second_digit = string.upper(fmt("%x", floor((value-floor(value/16)*16)/1)))
				
				-- [ + ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				y_pos = y_pos + delta_y
				
				-- Digits boxes
				draw_rectangle(x_pos + 8*delta_x, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + 13, y_pos, width, height, COLOUR.text, COLOUR.background)
				
				-- Digits
				x_temp = 21
				y_pos = y_pos + 1
				local colour = COLOUR.memory
				
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, first_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, second_digit, colour)  x_temp = x_temp + 13
				y_pos = y_pos + delta_y - 1
				
				-- [ - ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				-- Slider button
				y_temp = 26
				
				draw_line(x_pos, y_pos + y_temp, x_pos + 128, y_pos + y_temp, 1, COLOUR.weak)  -- Snes9x: basic widget hack
				widget_pointer = math.floor(128*((value)/255))
				if mouse_onregion(x_pos, y_pos + y_temp - 2, x_pos + 128, y_pos + y_temp + 2) and User_input.leftclick then
					OPTIONS.value = math.floor((User_input.xmouse - x_pos)*(255/128))
				end
				draw_rectangle(x_pos + widget_pointer - 1, y_pos + y_temp - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color
				
			elseif size == 2 then -- 4 digits
				-- Correction, so the value loops when you overflow/underflow
				if OPTIONS.value > 0xFFFF then OPTIONS.value = OPTIONS.value - 0x10000
				elseif  OPTIONS.value < 0 then OPTIONS.value = OPTIONS.value + 0x10000 end
				
				-- Display in decimal
				local value_dec_shown = fmt("%05d", value)
				draw_rectangle(x_pos + 8*delta_x, y_pos + y_temp - 1, width + 12, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + 8*delta_x + 3, y_pos + y_temp, value_dec_shown, colour)
				
				-- Value digits, from the right to the left
				first_digit = string.upper(fmt("%x", floor((value-floor(value/(16^4))*(16^4))/(16^3))))
				second_digit = string.upper(fmt("%x", floor((value-floor(value/(16^3))*(16^3))/(16^2))))
				third_digit = string.upper(fmt("%x", floor((value-floor(value/(16^2))*(16^2))/16)))
				fourth_digit = string.upper(fmt("%x", floor((value-floor(value/16)*16)/1)))
				
				-- [ + ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x1000 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x100 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " + ", function() OPTIONS.value = OPTIONS.value + 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				y_pos = y_pos + delta_y
				
				-- Digits boxes
				x_temp = 13
				
				draw_rectangle(x_pos + 8*delta_x, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + x_temp, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + 2*x_temp, y_pos, width, height, COLOUR.text, COLOUR.background)
				draw_rectangle(x_pos + 8*delta_x + 3*x_temp, y_pos, width, height, COLOUR.text, COLOUR.background)
				
				-- Digits
				x_temp = 21
				y_pos = y_pos + 1
				local colour = COLOUR.memory
				
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, first_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, second_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, third_digit, colour)  x_temp = x_temp + 13
				gui.text(x_pos + 4*delta_x + x_temp, y_pos, fourth_digit, colour)  x_temp = x_temp + 13
				y_pos = y_pos + delta_y - 1
				
				-- [ - ] buttons
				x_temp = 12
				
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x1000 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x100 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x10 INI.save_options() end)
				x_temp = x_temp + 13
				create_button(x_pos + 5*delta_x + x_temp, y_pos, " - ", function() OPTIONS.value = OPTIONS.value - 0x1 INI.save_options() end)
				x_temp = x_temp + 13
				
				-- Slider button
				y_temp = 26
				
				draw_line(x_pos, y_pos + y_temp, x_pos + 128, y_pos + y_temp, 1, COLOUR.weak)  -- Snes9x: basic widget hack
				widget_pointer = floor(128*((value)/(256*256-1)))
				if mouse_onregion(x_pos, y_pos + y_temp - 2, x_pos + 128, y_pos + y_temp + 2) and User_input.leftclick then
					OPTIONS.value = floor((User_input.xmouse - x_pos)*((256*256-1)/128))
				end
				draw_rectangle(x_pos + widget_pointer - 1, y_pos + y_temp - 2, 2, 4, "#ff0000a0", COLOUR.warning)  -- unlisted color	
			
			end
			
			--- Sprite table ---
			
			x_pos = 135 
			y_pos = 56
			x_temp = 13*delta_x + 2
			
			gui.text(x_pos, y_pos, "Sprite table?")
			
			-- Yes/No buttons
			create_button(x_pos + x_temp, y_pos, "     ", function() OPTIONS.edit_sprite_table = true INI.save_options() end)
			if OPTIONS.edit_sprite_table then draw_rectangle(x_pos + x_temp + 1, y_pos + 1, 5*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") 
			freeze = false end
			gui.text(x_pos + x_temp + 1, y_pos + 1, " Yes ", COLOUR.button_text, 0)
			
			x_temp = 18*delta_x + 3
			create_button(x_pos + x_temp, y_pos, "    ", function() OPTIONS.edit_sprite_table = false INI.save_options() end)
			if not OPTIONS.edit_sprite_table then draw_rectangle(x_pos + x_temp + 1, y_pos + 1, 4*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") 
			freeze = false end
			gui.text(x_pos + x_temp + 1, y_pos + 1, " No ", COLOUR.button_text, 0)
			
			y_pos = y_pos + delta_y
			x_temp = 0
			if OPTIONS.edit_sprite_table then
				local opt = OPTIONS.edit_sprite_table_number
				for i = 1, SMW2.sprite_max do
					create_button(x_pos + x_temp, y_pos, "   ", function() opt[i] = not opt[i] end)
					if opt[i] then
						gui.text(x_pos + x_temp + 3, y_pos + 1, fmt("%02d", i - 1), COLOUR.positive)
					else
						gui.text(x_pos + x_temp + 3, y_pos + 1, fmt("%02d", i - 1))					
					end
				
					x_temp = x_temp + 13
					--y_pos = y_pos + delta_y
					if x_pos + x_temp > 242 then
						x_temp, y_pos = 0, y_pos + delta_y - 3
					end
				end
			end
			
			--- Mode ---
			
			x_pos = 150 
			y_pos = 115
			x_temp = 25
			
			gui.text(x_pos, y_pos, "Mode:")
			y_pos = y_pos + delta_y
			
			create_button(x_pos, y_pos, "      ", function() OPTIONS.edit_method = "Poke" INI.save_options() end)
			if Memory.edit_method == "Poke" then draw_rectangle(x_pos + 1, y_pos + 1, 6*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0") 
			freeze = false end
			gui.text(x_pos + delta_x + 1, y_pos + 1, "Poke", COLOUR.button_text, 0)
			
			create_button(x_pos + x_temp, y_pos, "        ", function() OPTIONS.edit_method = "Freeze" INI.save_options() end)
			if Memory.edit_method == "Freeze" then draw_rectangle(x_pos + x_temp + 1, y_pos + 1, 8*delta_x - 2, delta_y - 6, "#00ff0080", "#00ff00c0")
			freeze = true end
			gui.text(x_pos + x_temp + delta_x + 1, y_pos + 1, "Freeze", COLOUR.button_text, 0)
			
			--- Action ---
			
			x_pos = 150
			y_pos = 145
			
			gui.text(x_pos, y_pos, "Action:")
			y_pos = y_pos + delta_y
			
			create_button(x_pos, y_pos, "       ", function() poked = false apply = true end)
			if apply and OPTIONS.edit_method == "Freeze" then gui.text(x_pos + delta_x + 1, y_pos + 1, "APPLY", COLOUR.weak2, 0)
			else gui.text(x_pos + delta_x + 1, y_pos + 1, "APPLY", COLOUR.memory) end
			
			if OPTIONS.edit_method == "Freeze" then
				create_button(x_pos, y_pos + delta_y, "       ", function() apply = false end)
				if apply and OPTIONS.edit_method == "Freeze" then gui.text(x_pos + delta_x + 3, y_pos + delta_y + 1, "STOP", COLOUR.warning)
				else gui.text(x_pos + delta_x + 3, y_pos + delta_y + 1, "STOP", COLOUR.weak2, 0) end
			end
			
			--- Result ---
			
			x_pos = 195
			y_pos = 145
			x_temp = 8*delta_x
			
			gui.text(x_pos, y_pos, "Result:")
			gui.text(x_pos, y_pos + 2*delta_y, "in hex", COLOUR.text)
			gui.text(x_pos, y_pos + 3*delta_y, "in dec", COLOUR.text)
			
			gui.text(x_pos, y_pos + delta_y, address_shown, colour)
			if OPTIONS.edit_sprite_table then
				gui.text(x_pos + 7*delta_x, y_pos + delta_y, "(table)", colour)
			end
			
			if size == 1 then
				-- In hex
			 	draw_rectangle(x_pos + x_temp, y_pos + 2*delta_y - 1, width, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 2*delta_y,  string.upper(fmt("%02x", u8(address))), colour)
				-- In decimal
			 	draw_rectangle(x_pos + x_temp, y_pos + 3*delta_y - 1, width + 4, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 3*delta_y, fmt("%03d", u8(address)), colour)
			elseif size == 2 then
				-- In hex
				draw_rectangle(x_pos + x_temp, y_pos + 2*delta_y - 1, width + 8, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 2*delta_y,  string.upper(fmt("%04x", u16(address))), colour)	
				-- In decimal
				draw_rectangle(x_pos + x_temp, y_pos + 3*delta_y - 1, width + 12, height, COLOUR.text, COLOUR.background)
				gui.text(x_pos + x_temp + 3, y_pos + 3*delta_y, fmt("%05d", u16(address)), colour)				
			end
			
			if apply and poked then
				alert_text(Buffer_middle_x - 12*delta_x, 190, " Appling address freeze ", COLOUR.warning, COLOUR.warning_bg)			
			end
		end
		
    end
    
    return true
end



--#############################################################################
-- SMW2 FUNCTIONS:


-- Returns the id of Yoshi; if more than one, the lowest sprite slot
local function get_yoshi_id()
    for i = 0, SMW2.sprite_max - 1 do
        local id = u8(WRAM.sprite_number + i)
        local status = u8(WRAM.sprite_status + i)
        if id == 0x35 and status ~= 0 then return i end
    end
    
    return nil
end


local Real_frame, Previous_real_frame, Effective_frame, Game_mode
local Level_index, Room_index, Level_flag, Current_level
local Is_paused, Lock_animation_flag, Player_powerup, Player_animation_trigger
local Camera_x, Camera_y
local function scan_smw2()
    --[[
    Previous_real_frame = Real_frame or u8(WRAM.real_frame)
    Real_frame = u8(WRAM.real_frame)
    Effective_frame = u8(WRAM.effective_frame)]]
    Game_mode = u16(WRAM.game_mode)
    --[[Level_index = u8(WRAM.level_index)
    Level_flag = u8(WRAM.level_flag_table + Level_index)
    Is_paused = u8(WRAM.level_paused) == 1
    Lock_animation_flag = u8(WRAM.lock_animation_flag)
    Room_index = u24(WRAM.room_index)
    
    -- In level frequently used info
    Player_animation_trigger = u8(WRAM.player_animation_trigger)
    Player_powerup = u8(WRAM.powerup)]]
    Camera_x = s16(WRAM.camera_x)
    Camera_y = s16(WRAM.camera_y) 
end


-- Converts the in-game (x, y) to SNES-screen coordinates
local function screen_coordinates(x, y, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or u8(WRAM.camera_x)
    camera_y = camera_y or Camera_y or u8(WRAM.camera_y)
    
    local x_screen = (x - camera_x)
    local y_screen = (y - camera_y) - Y_CAMERA_OFF
    
    return x_screen, y_screen
end


-- Converts Snes9x-screen coordinates to in-game (x, y)
local function game_coordinates(x_snes9x, y_snes9x, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or u8(WRAM.camera_x)
    camera_y = camera_y or Camera_y or u8(WRAM.camera_y)
    
    local x_game = x_snes9x + camera_x
    local y_game = y_snes9x + Y_CAMERA_OFF + camera_y
    
    return x_game, y_game
end


-- Returns the extreme values that Mario needs to have in order to NOT touch a rectangular object
local function display_boundaries(x_game, y_game, width, height, camera_x, camera_y)
    -- Font
    Text_opacity = 0.5
    Bg_opacity = 0.4
    
    -- Coordinates around the rectangle
    local left = width*floor(x_game/width)
    local top = height*floor(y_game/height)
    left, top = screen_coordinates(left, top, camera_x, camera_y)
    local right = left + width - 1
    local bottom = top + height - 1
    
    -- Reads WRAM values of the player
    local is_ducking = u8(WRAM.is_ducking)
    local powerup = Player_powerup
    local is_small = is_ducking ~= 0 or powerup == 0
    
    -- Left
    local left_text = string.format("%4d.0", width*floor(x_game/width) - 13)
    draw_text(AR_x*left, AR_y*(top+bottom)/2, left_text, false, false, 1.0, 0.5)
    
    -- Right
    local right_text = string.format("%d.f", width*floor(x_game/width) + 12)
    draw_text(AR_x*right, AR_y*(top+bottom)/2, right_text, false, false, 0.0, 0.5)
    
    -- Top
    local value = (Yoshi_riding_flag and y_game - 16) or y_game
    local top_text = fmt("%d.0", width*floor(value/width) - 32)
    draw_text(AR_x*(left+right)/2, AR_y*top, top_text, false, false, 0.5, 1.0)
    
    -- Bottom
    value = height*floor(y_game/height)
    if not is_small and not Yoshi_riding_flag then
        value = value + 0x07
    elseif is_small and Yoshi_riding_flag then
        value = value - 4
    else
        value = value - 1  -- the 2 remaining cases are equal
    end
    
    local bottom_text = fmt("%d.f", value)
    draw_text(AR_x*(left+right)/2, AR_y*bottom, bottom_text, false, false, 0.5, 0.0)
    
    return left, top
end


local function read_screens()
	local screens_number = u8(WRAM.screens_number)
    local vscreen_number = u8(WRAM.vscreen_number)
    local hscreen_number = u8(WRAM.hscreen_number) - 1
    local vscreen_current = s8(WRAM.y + 1)
    local hscreen_current = s8(WRAM.x + 1)
    --local level_mode_settings = u8(WRAM.level_mode_settings)
    --local b1, b2, b3, b4, b5, b6, b7, b8 = bit.multidiv(level_mode_settings, 128, 64, 32, 16, 8, 4, 2)
    --draw_text(Buffer_middle_x, Buffer_middle_y, {"%x: %x%x%x%x%x%x%x%x", level_mode_settings, b1, b2, b3, b4, b5, b6, b7, b8}, COLOUR.text, COLOUR.background)
    
    local level_type
    if (level_mode_settings ~= 0) and (level_mode_settings == 0x3 or level_mode_settings == 0x4 or level_mode_settings == 0x7
        or level_mode_settings == 0x8 or level_mode_settings == 0xa or level_mode_settings == 0xd) then
            level_type = "Vertical"
        ;
    else
        level_type = "Horizontal"
    end
    
    return level_type, screens_number, hscreen_current, hscreen_number, vscreen_current, vscreen_number
end


local function get_map16_value(x_game, y_game)
    local num_x = floor(x_game/16)
    local num_y = floor(y_game/16)
    if num_x < 0 or num_y < 0 then return end  -- 1st breakpoint
    
    local level_type, screens, _, hscreen_number, _, vscreen_number = read_screens()
    local max_x, max_y
    if level_type == "Horizontal" then
        max_x = 16*(hscreen_number + 1)
        max_y = 27
    else
        max_x = 32
        max_y = 16*(vscreen_number + 1)
    end
    
    if num_x > max_x or num_y > max_y then return end  -- 2nd breakpoint
    
    local num_id, kind
    if level_type == "Horizontal" then
        num_id = 16*27*floor(num_x/16) + 16*num_y + num_x%16
        kind = (num_id >= 0 and num_id <= 0x35ff) and 256*u8(0x1c800 + num_id) + u8(0xc800 + num_id)
    else
        local nx = floor(num_x/16)
        local ny = floor(num_y/16)
        local n = 2*ny + nx
        local num_id = 16*16*n + 16*(num_y%16) + num_x%16
        kind = (num_id >= 0 and num_id <= 0x37ff) and 256*u8(0x1c800 + num_id) + u8(0xc800 + num_id)
    end
    
    if kind then return  num_x, num_y, kind end
end


local function draw_layer1_tiles(camera_x, camera_y)
    local x_origin, y_origin = screen_coordinates(0, 0, camera_x, camera_y)
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, camera_x, camera_y)
    x_mouse = 16*floor(x_mouse/16)
    y_mouse = 16*floor(y_mouse/16)
    
    for number, positions in ipairs(Layer1_tiles) do
        -- Calculate the Lsnes coordinates
        local left = positions[1] + x_origin
        local top = positions[2] + y_origin
        local right = left + 15
        local bottom = top + 15
        local x_game, y_game = game_coordinates(left, top, camera_x, camera_y)
        
        -- Returns if block is way too outside the screen
        if left > - Border_left - 32 and top  > - Border_top - 32 and -- Snes9x: w/ 2*
        right < Screen_width  + Border_right + 32 and bottom < Screen_height + Border_bottom + 32 then
            
            -- Drawings
            Text_opacity = 1.0 -- Snes9x
            --[[cal num_x, num_y, kind = get_map16_value(x_game, y_game)
            if kind then
                if kind >= 0x111 and kind <= 0x16d or kind == 0x2b then
                    -- default solid blocks, don't know how to include custom blocks
                    draw_rectangle(left + push_direction, top, 8, 15, 0, COLOUR.block_bg)
                end
                draw_rectangle(left, top, 15, 15, kind == SMW2.blank_tile_map16 and COLOUR.blank_tile or COLOUR.block, 0)
                
                if Layer1_tiles[number][3] then
                    display_boundaries(x_game, y_game, 16, 16, camera_x, camera_y)  -- the text around it
                end
                
                -- Draw Map16 id
                Text_opacity = 1.0
                if kind and x_mouse == positions[1] and y_mouse == positions[2] then
                    draw_text(AR_x*(left + 4), AR_y*top - SNES9X_FONT_HEIGHT, fmt("Map16 (%d, %d), %x", num_x, num_y, kind),
                    false, false, 0.5, 1.0)
                end
            end]]
			
            draw_rectangle(left, top, 15, 15, COLOUR.blank_tile, 0) -- REMOVE
            
        end
        
    end
    
end


local function draw_layer2_tiles()
    local layer2x = s16(WRAM.layer2_x_nextframe)
    local layer2y = s16(WRAM.layer2_y_nextframe)
    
    for number, positions in ipairs(Layer2_tiles) do
        draw_rectangle(-layer2x + positions[1], -layer2y + positions[2], 15, 15, COLOUR.layer2_line, COLOUR.layer2_bg)
    end
end


local function draw_tilesets(camera_x, camera_y)
	if Game_mode ~= SMW2.game_mode_level then return end
	
    local x_origin, y_origin = screen_coordinates(0, 0, camera_x, camera_y)
	
	--##############################################
	-- Tile grid
	
	Text_opacity = 1.0
    
    local width = 256 --u16(WRAM.level_width) or LEVEL[Level_index].width
	local height = 128 --u16(WRAM.level_height) or LEVEL[Level_index].height
	local block_x, block_y
	local x_pos, y_pos
	local x_screen, y_screen
	local screen_number, screen_id
	local block_id
	local kind_low, kind_high
	for screen_region_y = 0, 7 do
		--y_pos = y_origin + 16*screen_region_y
		
		for screen_region_x = 0, 15 do
			--x_pos = x_origin + 16*screen_region_x
			--x_screen, y_screen = screen_coordinates(x_pos, y_pos, camera_x, camera_y)
			--x_screen = x_screen + camera_x
			--y_screen = y_screen + camera_y
			
			screen_number = screen_region_y*16 + screen_region_x
			screen_id = u8(SFXRAM.screen_number_to_id + screen_number)
			
			for block_y = 0, 15 do
				y_pos = y_origin + 256*screen_region_y + 16*block_y
				
				
				for block_x = 0, 15 do
					x_pos = x_origin + 256*screen_region_x + 16*block_x
					x_screen, y_screen = screen_coordinates(x_pos, y_pos, camera_x, camera_y)
			        x_screen = x_screen + camera_x
			        y_screen = y_screen + camera_y
					
					block_id = 256*screen_id + 16*block_y + block_x
					
					if x_screen >= -256 and x_screen <= 256+16 and y_screen >= -256 and y_screen <= 224+16 then -- to not print the whole level, it's too laggy
						
						--local num_x, num_y, kind_low, kind_high, address_low, address_high = get_map16_value(x_game, y_game)
			
						kind_low = u8(0x7E0000 + WRAM.Map16_data + 2*block_id) -- 
						kind_high = u8(0x7E0000 + WRAM.Map16_data + 2*block_id + 1) --
						
						-- Tile type
						if OPTIONS.draw_tile_map_type then
							draw_text(x_pos + 5, y_pos + 1, fmt("%02x\n%02x", kind_high, kind_low), COLOUR.blank_tile)
						end
						
						-- Grid
						if OPTIONS.draw_tile_map_grid then
							--draw_rectangle(x_pos, y_pos, 15, 15, kind_low == FLINT.blank_tile_map16 and COLOUR.blank_tile or COLOUR.block, 0)
							if kind_high == 0x01 or kind_high == 0x08 or kind_high == 0x0A or kind_high == 0x0C or kind_high == 0x0D or kind_high == 0x0F
							or kind_high == 0x10 or kind_high == 0x11 or kind_high == 0x15 or kind_high == 0x1A or kind_high == 0x1B 
							or kind_high == 0x29 or kind_high == 0x38
							or kind_high == 0x39 or kind_high == 0x3E or kind_high == 0x3F
							or kind_high == 0x50 or kind_high == 0x55 or kind_high == 0x5B
							or kind_high == 0x66 or kind_high == 0x67 or kind_high == 0x6B or kind_high == 0x6E
							or kind_high == 0x79 or kind_high == 0x7D
							or kind_high == 0x90 or kind_high == 0x9D then
								draw_rectangle(x_pos, y_pos, 15, 15, COLOUR.block, 0)
							else
								draw_rectangle(x_pos, y_pos, 15, 15, COLOUR.blank_tile, 0)					
							end
							--draw_rectangle(x_pos, y_pos, 15, 15, COLOUR.blank_tile, 0) -- REMOVE
							--draw_text(x_pos, y_pos + 1, fmt("%x", num_id), COLOUR.blank_tile) -- REMOVE
							
							if block_y == 0 and block_x == 0 then -- REMOVE
								--screen_number = floor(num_id/256) + (num_id/16)%256
								--screen_id = u8(0x700CAA + screen_number)
								
								draw_rectangle(x_pos, y_pos, 22, 16, COLOUR.warning, COLOUR.warning)
								draw_text(x_pos + 2, y_pos + 1, fmt("#:%02x\nID:%02x", screen_number, screen_id), COLOUR.text)
								
								draw_rectangle(x_pos, y_pos, 255, 255, COLOUR.warning, 0)
							end
						end
						
						--[[
						-- Tile type graphicaly
						if OPTIONS.draw_tile_map_gfx_type then
							if OPTIONS.draw_tile_map_phy_type then
								draw_text(x_pos + 5, y_pos + 1, fmt("%02x", kind_low), COLOUR.blank_tile)
							else
								draw_text(x_pos + 5, y_pos + 4, fmt("%02x", kind_low), COLOUR.blank_tile)					
							end
						end
						
						-- Tile type physicaly
						if OPTIONS.draw_tile_map_phy_type then
							if OPTIONS.draw_tile_map_gfx_type then
								draw_text(x_pos + 5, y_pos + 8, fmt("%02x", kind_high), COLOUR.blank_tile)
							else
								draw_text(x_pos + 5, y_pos + 4, fmt("%02x", kind_high), COLOUR.blank_tile)					
							end
						
						end]]
					end
				
				end
			
			end
		end
	end	
	
	--##############################################
	-- Tiles from click
	
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, camera_x, camera_y)
    x_mouse = 16*math.floor(x_mouse/16)
    y_mouse = 16*math.floor(y_mouse/16)
    
    for number, positions in ipairs(Tiletable) do
        -- Calculate the Snes9x coordinates
        local left = positions[1] + x_origin
        local top = positions[2] + y_origin
        local right = left + 15
        local bottom = top + 15
        local x_game, y_game = game_coordinates(left, top, camera_x, camera_y)
        
        -- Returns if block is way too outside the screen
        if left > - Border_left - 32 and top  > - Border_top - 32 and -- Snes9x: w/ 2*
        right < Screen_width  + Border_right + 32 and bottom < Screen_height + Border_bottom + 32 then
            
			--draw_rectangle(left, top, 15, 15, COLOUR.block, 0)
			
            -- Drawings
            local num_x, num_y, kind_low, kind_high, address_low, address_high = get_map16_value(x_game, y_game) -- REMOVE addresses
			
			if OPTIONS.draw_tile_map_grid then -- to make it easier to see when grid is activated
				draw_rectangle(left, top, 15, 15, COLOUR.Fred, 0) -- this color fits well
			elseif kind_high >= 0 and kind_high <= 3 then -- non solid blocks
				draw_rectangle(left, top, 15, 15, COLOUR.blank_tile, 0)
            else
				draw_rectangle(left, top, 15, 15, COLOUR.block, 0)
			end			
			
            if Tiletable[number][3] then
                display_boundaries(x_game, y_game, 16, 16, camera_x, camera_y)  -- the text around it
            end
                
            -- Draw Map16 id
            if x_mouse == positions[1] and y_mouse == positions[2] then
				Text_opacity = 0.8
				
				local y_pos
				if num_y < 2 then y_pos = bottom + 2*SNES9X_FONT_HEIGHT + 1 else y_pos = top - SNES9X_FONT_HEIGHT end
				
                draw_text(left + 6, y_pos, fmt("Map16 (%d, %d), %02x(%02x)", num_x, num_y, kind_low, kind_high),
                false, true, 0.5, 1.0)
				
                --draw_text(left + 6, y_pos + SNES9X_FONT_HEIGHT, fmt("%04x (%04x)", address_low, address_high), false, true, 0.5, 1.0) -- REMOVE
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
    if Game_mode ~= SMW2.game_mode_level then return end
    
    local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
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

--[[local function select_tile(x, y, layer_table)
    if not OPTIONS.draw_tiles_with_click then return end
    --if Game_mode ~= SMW2.game_mode_level then return end
    
    for number, positions in ipairs(layer_table) do  -- if mouse points a drawn tile, erase it
        if x == positions[1] and y == positions[2] then
            -- Layer 1
            if layer_table == Layer1_tiles then
                if layer_table[number][3] == false then
                    layer_table[number][3] = true
                else
                    table.remove(layer_table, number)
                end
            -- Layer 2
            elseif layer_table == Layer2_tiles then
                table.remove(layer_table, number)
            end
            
            return
        end
    end
    
    -- otherwise, draw a new tile
    if #layer_table == OPTIONS.max_tiles_drawn then
        table.remove(layer_table, 1)
        layer_table[OPTIONS.max_tiles_drawn] = {x, y, false}
    else
        table.insert(layer_table, {x, y, false})
    end
    
end]]


-- uses the mouse to select an object
local function select_object(mouse_x, mouse_y, camera_x, camera_y)
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 0.5
    
    local x_game, y_game = game_coordinates(mouse_x, mouse_y, camera_x, camera_y)
    local obj_id
    
    -- Checks if the mouse is over Mario
    local x_player = s16(WRAM.x)
    local y_player = s16(WRAM.y)
    if x_player + 0xe >= x_game and x_player + 0x2 <= x_game and y_player + 0x30 >= y_game and y_player + 0x8 <= y_game then
        obj_id = "Mario"
    end
    
    if not obj_id and OPTIONS.display_sprite_info then
        for id = 0, SMW2.sprite_max - 1 do
            local sprite_status = u8(WRAM.sprite_status + id)
            if sprite_status ~= 0 and Sprites_info[id].x then  -- TODO: see why the script gets here without exporting Sprites_info
                -- Import some values
                local x_sprite, y_sprite = Sprites_info[id].x, Sprites_info[id].y
                local x_screen, y_screen = Sprites_info[id].x_screen, Sprites_info[id].y_screen
                local boxid = Sprites_info[id].boxid
                local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
                local width, height = Sprites_info[id].width, Sprites_info[id].height
                
                if x_sprite + xoff + width >= x_game and x_sprite + xoff <= x_game and
                y_sprite + yoff + height >= y_game and y_sprite + yoff <= y_game then
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
    
    local spr_id = tonumber(id)
    if spr_id and spr_id >= 0 and spr_id <= SMW2.sprite_max - 1 then
        
        local number = Sprites_info[spr_id].number
        if Sprite_hitbox[spr_id][number].sprite and Sprite_hitbox[spr_id][number].block then
            Sprite_hitbox[spr_id][number].sprite = false
            Sprite_hitbox[spr_id][number].block = false
        elseif Sprite_hitbox[spr_id][number].sprite then
            Sprite_hitbox[spr_id][number].block = true
            Sprite_hitbox[spr_id][number].sprite = false
        elseif Sprite_hitbox[spr_id][number].block then
            Sprite_hitbox[spr_id][number].sprite = true
        else
            Sprite_hitbox[spr_id][number].sprite = true
        end
        
    end
    if id then return end
    
    -- Select layer 2 tiles -- TODO
    --[[local layer2x = s16(WRAM.layer2_x_nextframe)
    local layer2y = s16(WRAM.layer2_y_nextframe)
    local x_mouse, y_mouse = User_input.xmouse + layer2x, User_input.ymouse + layer2y
    select_tile(16*floor(x_mouse/16), 16*floor(y_mouse/16) - Y_CAMERA_OFF, Layer2_tiles)]]
end


local function show_movie_info()
    if not OPTIONS.display_movie_info then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    local y_text = - Border_top
    local x_text = 0
    local width = SNES9X_FONT_WIDTH
    
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
    alert_text(Buffer_width, Buffer_height, str, COLOUR.text, recording_bg, false, 1.0, 1.0)
    
    if Is_lagged then
        alert_text(Buffer_middle_x - 3*SNES9X_FONT_WIDTH, 2*SNES9X_FONT_HEIGHT, " LAG ", COLOUR.warning, COLOUR.warning_bg)
        emu.message("Lag detected!") -- Snes9x
        
    end
    
end


local function show_misc_info()
    if not OPTIONS.display_misc_info then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
	local delta_y = SNES9X_FONT_HEIGHT
	
	-- Display
    local game_mode = string.upper(fmt("%04x", Game_mode))
	draw_text(Buffer_width + Border_right - 20, -Border_top, fmt("Mode:%s", game_mode), true, false)
	
	draw_text(130, 0, fmt("Camera (%d, %d)", Camera_x, Camera_y))
	
	local red_coin_counter = u8(WRAM.red_coin_counter)
	local star_counter = u16(WRAM.star_counter)
	local flower_counter = u8(WRAM.flower_counter)
	local coin_counter = u8(WRAM.coin_counter)
	local star_effective = math.floor(star_counter/10)
	
	local temp_str
	local x_temp = 0
	
	temp_str = fmt("Stars: %d/30(%d)", star_effective, star_counter)
	draw_text(x_temp, delta_y, temp_str, COLOUR.weak, true)
	x_temp = x_temp + SNES9X_FONT_WIDTH*string.len(temp_str) + 12
	
	temp_str = fmt("Red coins: %d/20", red_coin_counter)
	draw_text(x_temp, delta_y, temp_str, COLOUR.weak, true)
	x_temp = x_temp + SNES9X_FONT_WIDTH*string.len(temp_str) + 12
	
	temp_str = fmt("Flowers: %d/5", flower_counter)
	draw_text(x_temp, delta_y, temp_str, COLOUR.weak, true)
	x_temp = x_temp + SNES9X_FONT_WIDTH*string.len(temp_str) + 12
	
	temp_str = fmt("Coins: %d", coin_counter)
	draw_text(x_temp, delta_y, temp_str, COLOUR.weak, true)
end


-- Display mouse coordinates right above it
local function show_mouse_info()
	if not OPTIONS.display_mouse_coordinates then return end
	
	-- Font
    Text_opacity = 1.0 -- Snes9x
    Bg_opacity = 1.0
	
	local x = User_input.xmouse
	local y = User_input.ymouse
	local x_level = x + Camera_x
	local y_level = y + Camera_y
	
	if User_input.xmouse >= 0 and User_input.xmouse <= 256 and User_input.ymouse >= 0 and User_input.ymouse <= 224 then
		alert_text(x, y - 8, fmt("(%d, %d)", x, y), COLOUR.text, COLOUR.background, 0.1, 0.5)
		alert_text(x, y + 8, fmt("(%d, %d)", x_level, y_level), COLOUR.text, COLOUR.background, 0.1, 0.5)
	end
end


-- Shows the controller input as the RAM and SNES registers store it
local function show_controller_data()
    if not (OPTIONS.display_debug_info and OPTIONS.display_debug_controller_data) then return end
    
    -- Font
    Text_opacity = 0.9
    local height = SNES9X_FONT_HEIGHT
    local x_pos, y_pos, x, y, _ = 0, 0, 0, SNES9X_FONT_HEIGHT
    
    local controller = memory.readword(0x1000000 + 0x4218) -- Snes9x / BUS area
    x = draw_over_text(x, y, controller, "BYsS^v<>AXLR0123", COLOUR.warning, false, true)
    _, y = draw_text(x, y, " (Registers)", COLOUR.warning, false, true)
    
    x = x_pos
    x = draw_over_text(x, y, 256*u8(WRAM.ctrl_1_1) + u8(WRAM.ctrl_1_2), "BYsS^v<>AXLR0123", COLOUR.weak)
    _, y = draw_text(x, y, " (RAM data)", COLOUR.weak, false, true)
    
    x = x_pos
    draw_over_text(x, y, 256*u8(WRAM.firstctrl_1_1) + u8(WRAM.firstctrl_1_2), "BYsS^v<>AXLR0123", 0, "#0xffff", 0) -- Snes9x
end


local function level_info()
    if not OPTIONS.display_level_info then return end
    
    -- Font
    Text_opacity = 0.2 -- Snes9x
    Bg_opacity = 1.0
    local x_pos = 134
    local y_pos = 200
    local color = COLOUR.text
    Text_opacity = 1.0
    Bg_opacity = 1.0
    
    
    -- converts the level number to the Lunar Magic number; should not be used outside here
    local lm_level_number = Level_index
    if Level_index > 0x24 then lm_level_number = Level_index + 0xdc end
    
    -- Number of screens within the level
    local level_type, screens_number, hscreen_current, hscreen_number, vscreen_current, vscreen_number = read_screens()
    
    draw_text(x_pos, y_pos, fmt("%.1sLevel(%.2x)%s", level_type, lm_level_number, sprite_buoyancy),
                    color, true, false)
	;
    
    draw_text(x_pos, y_pos + SNES9X_FONT_HEIGHT, fmt("Screens(%d):", screens_number), true)
    
    draw_text(x_pos, y_pos + 2*SNES9X_FONT_HEIGHT, fmt("(%d/%d, %d/%d)", hscreen_current, hscreen_number,
                vscreen_current, vscreen_number), true)
    ;
end


function draw_blocked_status(x_text, y_text, player_blocked_status, x_speed, y_speed)
    local bitmap_width  = 7 -- Snes9x
    local bitmap_height = 10 -- Snes9x
    local block_str = "Block:"
    local str_len = string.len(block_str)
    local xoffset = x_text + str_len*SNES9X_FONT_WIDTH
    local yoffset = y_text + 1
    local color_line = COLOUR.warning
    
    --gui.gdoverlay(xoffset, yoffset, IMAGES.player_blocked_status, Background_max_opacity * Bg_opacity) -- Snes9x
    
    gui.opacity(Text_max_opacity*Text_opacity) -- Snes9x
    local blocked_status = {}
    local was_boosted = false
	
	for i = 0, 15 do
		if i == 8 then
			xoffset = xoffset - 8*7
			yoffset = yoffset + 7
		end
	
		if bit.test(player_blocked_status, i) then
			draw_rectangle(xoffset + i*7, yoffset, 5, 5, color_line)			
		else
			draw_rectangle(xoffset + i*7, yoffset, 5, 5, "white")
		end
	end
	
	
    --[[
    if bit.test(player_blocked_status, 0) then  -- Right
        draw_line(xoffset + bitmap_width - 1, yoffset, xoffset + bitmap_width - 1, yoffset + bitmap_height - 1, 1, color_line)
        if x_speed < 0 then was_boosted = true end
    end
    
    if bit.test(player_blocked_status, 1) then  -- Left
        draw_line(xoffset, yoffset, xoffset, yoffset + bitmap_height - 1, 1, color_line)
        if x_speed > 0 then was_boosted = true end
    end
    
    if bit.test(player_blocked_status, 2) then  -- Down
        draw_line(xoffset, yoffset + bitmap_height - 1, xoffset + bitmap_width - 1, yoffset + bitmap_height - 1, 1, color_line)
    end
    
    if bit.test(player_blocked_status, 3) then  -- Up
        draw_line(xoffset, yoffset, xoffset + bitmap_width - 1, yoffset, 1, color_line)
        if y_speed > 6 then was_boosted = true end
    end
    
    if bit.test(player_blocked_status, 4) then  -- Middle
        gui.crosshair(xoffset + floor(bitmap_width/2), yoffset + floor(bitmap_height/2),
        math.min(bitmap_width/2, bitmap_height/2), color_line)
    end]]
    
    draw_text(x_text, y_text, block_str, COLOUR.text, was_boosted and COLOUR.warning_bg or nil)
    
end


-- displays player's hitbox
local function player_hitbox(x, y, is_ducking, powerup, transparency_level)
    local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    local yoshi_hitbox = nil
    local is_small = is_ducking ~= 0 or powerup == 0
    
    local x_points = X_INTERACTION_POINTS
    local y_points
    if is_small and not Yoshi_riding_flag then
        y_points = Y_INTERACTION_POINTS[1]
    elseif not is_small and not Yoshi_riding_flag then
        y_points = Y_INTERACTION_POINTS[2]
    elseif is_small and Yoshi_riding_flag then
        y_points = Y_INTERACTION_POINTS[3]
    else
        y_points = Y_INTERACTION_POINTS[4]
    end
    
    draw_box(x_screen + x_points.left_side, y_screen + y_points.head, x_screen + x_points.right_side, y_screen + y_points.foot,
            COLOUR.interaction_bg, COLOUR.interaction_bg)  -- background for block interaction
    ;
    
    if OPTIONS.display_player_hitbox then
        
        -- Collision with sprites
        local mario_bg = (not Yoshi_riding_flag and COLOUR.mario_bg) or COLOUR.mario_mounted_bg
        
        draw_box(x_screen + x_points.left_side  - 1, y_screen + y_points.sprite,
                 x_screen + x_points.right_side + 1, y_screen + y_points.foot + 1, COLOUR.mario, mario_bg)
        ;
        
    end
    
    -- interaction points (collision with blocks)
    if OPTIONS.display_interaction_points then
        
        local color = COLOUR.interaction
        
        if not SHOW_PLAYER_HITBOX then
            draw_box(x_screen + x_points.left_side , y_screen + y_points.head,
                     x_screen + x_points.right_side, y_screen + y_points.foot, COLOUR.interaction_nohitbox, COLOUR.interaction_nohitbox_bg)
        end
        
        gui.line(x_screen + x_points.left_side, y_screen + y_points.side, x_screen + x_points.left_foot, y_screen + y_points.side, color)  -- left side
        gui.line(x_screen + x_points.right_side, y_screen + y_points.side, x_screen + x_points.right_foot, y_screen + y_points.side, color)  -- right side
        gui.line(x_screen + x_points.left_foot, y_screen + y_points.foot - 2, x_screen + x_points.left_foot, y_screen + y_points.foot, color)  -- left foot bottom
        gui.line(x_screen + x_points.right_foot, y_screen + y_points.foot - 2, x_screen + x_points.right_foot, y_screen + y_points.foot, color)  -- right foot bottom
        gui.line(x_screen + x_points.left_side, y_screen + y_points.shoulder, x_screen + x_points.left_side + 2, y_screen + y_points.shoulder, color)  -- head left point
        gui.line(x_screen + x_points.right_side - 2, y_screen + y_points.shoulder, x_screen + x_points.right_side, y_screen + y_points.shoulder, color)  -- head right point
        gui.line(x_screen + x_points.center, y_screen + y_points.head, x_screen + x_points.center, y_screen + y_points.head + 2, color)  -- head point
        gui.line(x_screen + x_points.center - 1, y_screen + y_points.center, x_screen + x_points.center + 1, y_screen + y_points.center, color)  -- center point
        gui.line(x_screen + x_points.center, y_screen + y_points.center - 1, x_screen + x_points.center, y_screen + y_points.center + 1, color)  -- center point
    end
    
    -- That's the pixel that appears when Mario dies in the pit
    Show_player_point_position = Show_player_point_position or y_screen >= 200 or
        (OPTIONS.display_debug_info and OPTIONS.display_debug_player_extra)
    if Show_player_point_position then
        draw_rectangle(x_screen - 1, y_screen - 1, 2, 2, COLOUR.interaction_bg, COLOUR.text)
        Show_player_point_position = false
    end
    
    return x_points, y_points
end




local function player()
    if not OPTIONS.display_player_info then return end
    if Game_mode ~= SMW2.game_mode_level then return end
	
    -- Font
    Text_opacity = 1.0
    
    -- Reads SFXRAM and maybe WRAM
    local x = s16(SFXRAM.x)
    local y = s16(SFXRAM.y)
    local x_sub = u8(SFXRAM.x_sub)
    local y_sub = u8(SFXRAM.y_sub)
    local x_speed = s8(SFXRAM.x_speed)
	local x_subspeed = u8(SFXRAM.x_subspeed)
    local y_speed = s8(SFXRAM.y_speed)
	local y_subspeed = u8(SFXRAM.y_subspeed)
    local direction = u8(SFXRAM.direction)
    local player_blocked_status = u16(SFXRAM.player_blocked_status)
    --local diving_status = s8(SFXRAM.diving_status)
    --local player_item = u8(SFXRAM.player_item)
    --local is_ducking = u8(SFXRAM.is_ducking)
    --local on_ground = u8(SFXRAM.on_ground)
    --local can_jump_from_water = u8(SFXRAM.can_jump_from_water)
    --local carrying_item = u8(SFXRAM.carrying_item)
    
    -- Transformations
    if direction == 0 then direction = RIGHT_ARROW else direction = LEFT_ARROW end
    
    -- Display info
    local i = 0
    local delta_x = SNES9X_FONT_WIDTH
    local delta_y = SNES9X_FONT_HEIGHT
    local table_x = 0
    local table_y = AR_y*32
    
    draw_text(table_x, table_y + i*delta_y, fmt("Pos (%+d.%02x, %+d.%02x) %s", x, x_sub, y, y_sub, direction))
    i = i + 1
    
    draw_text(table_x, table_y + i*delta_y, fmt("Speed (%+d.%02x, %+d.%02x)", x_speed, x_subspeed, y_speed, y_subspeed))
    i = i + 1
    
    if OPTIONS.display_static_camera_region then
        Show_player_point_position = true
        local left_cam, right_cam = u16(0x07142c), u16(0x07142e)  -- unlisted WRAM / Snes9x memory bank
        draw_box(left_cam, 0, right_cam, 224, COLOUR.static_camera_region, COLOUR.static_camera_region)
    end
    
    draw_blocked_status(table_x, table_y + i*delta_y, player_blocked_status, x_speed, y_speed)
    
    -- shows hitbox and interaction points for player
    if not (OPTIONS.display_player_hitbox or OPTIONS.display_interaction_points) then return end
    
    --player_hitbox(x, y, is_ducking, powerup, 1.0)
    
end


local function extended_sprites()
    if not OPTIONS.display_extended_sprite_info then return end
    
    -- Font
    Text_opacity = 1.0
    local height = SNES9X_FONT_HEIGHT
    
    local y_pos = AR_y*144
    local counter = 0
    for id = 0, SMW2.extended_sprite_max - 1 do
        local extspr_number = u8(WRAM.extspr_number + id)
        
        if extspr_number ~= 0 then
            -- Reads WRAM addresses
            local x = 256*u8(WRAM.extspr_x_high + id) + u8(WRAM.extspr_x_low + id)
            local y = 256*u8(WRAM.extspr_y_high + id) + u8(WRAM.extspr_y_low + id)
            local sub_x = bit.rshift(u8(WRAM.extspr_subx + id), 4)
            local sub_y = bit.rshift(u8(WRAM.extspr_suby + id), 4)
            local x_speed = s8(WRAM.extspr_x_speed + id)
            local y_speed = s8(WRAM.extspr_y_speed + id)
            local extspr_table = u8(WRAM.extspr_table + id)
            local extspr_table2 = u8(WRAM.extspr_table2 + id)
            
            -- Reduction of useless info
            local special_info = ""
            if OPTIONS.display_debug_info and OPTIONS.display_debug_extended_sprite and
            (extspr_table ~= 0 or extspr_table2 ~= 0) then
                special_info = fmt("(%x, %x) ", extspr_table, extspr_table2)
            end
            
            -- x speed for Fireballs
            if extspr_number == 5 then x_speed = 16*x_speed end
            
            if OPTIONS.display_extended_sprite_info then
                draw_text(Buffer_width + Border_right, y_pos + counter*height, fmt("#%.2d %.2x %s(%d.%x(%+.2d), %d.%x(%+.2d))",
                                                    id, extspr_number, special_info, x, sub_x, x_speed, y, sub_y, y_speed),
                                                    COLOUR.extended_sprites, true, false)
            end
            
            if (OPTIONS.display_debug_info and OPTIONS.display_debug_extended_sprite) or not UNINTERESTING_EXTENDED_SPRITES[extspr_number]
                or (extspr_number == 1 and extspr_table2 == 0xf)
            then
                local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
                
                local t = HITBOX_EXTENDED_SPRITE[extspr_number] or
                    {xoff = 0, yoff = 0, width = 16, height = 16, color_line = COLOUR.awkward_hitbox, color_bg = COLOUR.awkward_hitbox_bg}
                local xoff = t.xoff
                local yoff = t.yoff + Y_CAMERA_OFF
                local xrad = t.width
                local yrad = t.height
                
                local color_line = t.color_line or COLOUR.extended_sprites
                local color_bg = t.color_bg or COLOUR.extended_sprites_bg
                if extspr_number == 0x5 or extspr_number == 0x11 then
                    color_bg = (Real_frame - id)%4 == 0 and COLOUR.special_extended_sprite_bg or 0
                end
                draw_rectangle(x_screen+xoff, y_screen+yoff, xrad, yrad, color_line, color_bg) -- regular hitbox
                
                -- Experimental: attempt to show Mario's fireball vs sprites
                -- this is likely wrong in some situation, but I can't solve this yet
                if extspr_number == 5 or extspr_number == 1 then
                    local xoff_spr = x_speed >= 0 and -5 or  1
                    local yoff_spr = - floor(y_speed/16) - 4 + (y_speed >= -40 and 1 or 0)
                    local yrad_spr = y_speed >= -40 and 19 or 20
                    draw_rectangle(x_screen + xoff_spr, y_screen + yoff_spr, 12, yrad_spr, color_line, color_bg)
                end
            end
            
            counter = counter + 1
        end
    end
    
    Text_opacity = 0.5
    local x_pos, y_pos, length = draw_text(Buffer_width + Border_right, y_pos, fmt("Ext. spr:%2d ", counter), COLOUR.weak, true, false, 0.0, 1.0)
    
    if u8(WRAM.spinjump_flag) ~= 0 and u8(WRAM.powerup) == 3 then
        local fireball_timer = u8(WRAM.spinjump_fireball_timer)
        draw_text(x_pos - length - SNES9X_FONT_WIDTH, y_pos, fmt("%d %s",
        fireball_timer%16, bit.test(fireball_timer, 4) and RIGHT_ARROW or LEFT_ARROW), COLOUR.extended_sprites, true, false, 1.0, 1.0)
    end
    
end


local function cluster_sprites()
    if not OPTIONS.display_cluster_sprite_info or u8(WRAM.cluspr_flag) == 0 then return end
    
    -- Font
    Text_opacity = 1.0
    local height = SNES9X_FONT_HEIGHT
    local x_pos, y_pos = AR_x*90, AR_y*57  -- Snes9x has no space to draw 20 lines
    local counter = 0
    
    if OPTIONS.display_debug_info and OPTIONS.display_debug_cluster_sprite then
        draw_text(x_pos, y_pos, "Cluster Spr.", COLOUR.weak)
        counter = counter + 1
    end
    
    local reappearing_boo_counter
    
    for id = 0, SMW2.cluster_sprite_max - 1 do
        local clusterspr_number = u8(WRAM.cluspr_number + id)
        
        if clusterspr_number ~= 0 then
            if not HITBOX_CLUSTER_SPRITE[clusterspr_number] then
                print("Warning: wrong cluster sprite number:", clusterspr_number)  -- should not happen without cheats
                return
            end
            
            -- Reads WRAM addresses
            local x = signed(256*u8(WRAM.cluspr_x_high + id) + u8(WRAM.cluspr_x_low + id), 16)
            local y = signed(256*u8(WRAM.cluspr_y_high + id) + u8(WRAM.cluspr_y_low + id), 16)
            local clusterspr_timer, special_info, table_1, table_2, table_3
            
            -- Reads cluster's table
            local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
            local t = HITBOX_CLUSTER_SPRITE[clusterspr_number] or
                {xoff = 0, yoff = 0, width = 16, height = 16, color_line = COLOUR.awkward_hitbox, color_bg = COLOUR.awkward_hitbox_bg, oscillation = 1}
            local xoff = t.xoff
            local yoff = t.yoff + Y_CAMERA_OFF
            local xrad = t.width
            local yrad = t.height
            local phase = t.phase or 0
            local oscillation = (Real_frame - id)%t.oscillation == phase
            local color = t.color or COLOUR.cluster_sprites
            local color_bg = t.bg or COLOUR.sprites_bg
            local invencibility_hitbox = nil
            
            if OPTIONS.display_debug_info and OPTIONS.display_debug_cluster_sprite then
                table_1 = u8(WRAM.cluspr_table_1 + id)
                table_2 = u8(WRAM.cluspr_table_2 + id)
                table_3 = u8(WRAM.cluspr_table_3 + id)
                draw_text(x_pos, y_pos + counter*height, ("#%d(%d): (%d, %d) %d, %d, %d")
                :format(id, clusterspr_number, x, y, table_1, table_2, table_3), color)
                counter = counter + 1
            end
            
            -- Case analysis
            if clusterspr_number == 3 or clusterspr_number == 8 then
                clusterspr_timer = u8(WRAM.cluspr_timer + id)
                if clusterspr_timer ~= 0 then special_info = " " .. clusterspr_timer end
            elseif clusterspr_number == 6 then
                table_1 = table_1 or u8(WRAM.cluspr_table_1 + id)
                if table_1 >= 111 or (table_1 < 31 and table_1 >= 16) then
                    yoff = yoff + 17
                elseif table_1 >= 103 or table_1 < 16 then
                    invencibility_hitbox = true
                elseif table_1 >= 95 or (table_1 < 47 and table_1 >= 31) then
                    yoff = yoff + 16
                end
            elseif clusterspr_number == 7 then
                reappearing_boo_counter = reappearing_boo_counter or u8(WRAM.reappearing_boo_counter)
                invencibility_hitbox = (reappearing_boo_counter > 0xde) or (reappearing_boo_counter < 0x3f)
                special_info = " " .. reappearing_boo_counter
            end
            
            -- Hitbox and sprite id
            color = invencibility_hitbox and COLOUR.weak or color
            color_bg = (invencibility_hitbox and 0) or (oscillation and color_bg) or 0
            draw_rectangle(x_screen + xoff, y_screen + yoff, xrad, yrad, color, color_bg)
            draw_text(AR_x*(x_screen + xoff) + xrad, AR_y*(y_screen + yoff), special_info and id .. special_info or id,
            color, false, false, 0.5, 1.0)
        end
    end
end


local function minor_extended_sprites()
    if not OPTIONS.display_minor_extended_sprite_info then return end
    
    -- Font
    gui.opacity(1.0)
    Text_opacity = 1.0
    local height = SNES9X_FONT_HEIGHT
    local x_pos, y_pos = 0, Buffer_height - height*SMW2.minor_extended_sprite_max
    local counter = 0
    
    for id = 0, SMW2.minor_extended_sprite_max - 1 do
        local minorspr_number = u8(WRAM.minorspr_number + id)
        
        if minorspr_number ~= 0 then
            -- Reads WRAM addresses
            local x = signed(256*u8(WRAM.minorspr_x_high + id) + u8(WRAM.minorspr_x_low + id), 16)
            local y = signed(256*u8(WRAM.minorspr_y_high + id) + u8(WRAM.minorspr_y_low + id), 16)
            local xspeed, yspeed = s8(WRAM.minorspr_xspeed + id), s8(WRAM.minorspr_yspeed + id)
            local x_sub, y_sub = u8(WRAM.minorspr_x_sub + id), u8(WRAM.minorspr_y_sub + id)
            local timer = u8(WRAM.minorspr_timer + id)
            
            -- Only sprites 1 and 10 use the higher byte
            local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
            if minorspr_number ~= 1 and minorspr_number ~= 10 then  -- Boo stream and Piece of brick block
                x_screen = x_screen%0x100
                y_screen = y_screen%0x100
            end
            
            -- Draw next to the sprite
            local text = "#" .. id .. (timer ~= 0 and (" " .. timer) or "")
            draw_text(AR_x*(x_screen + 8), AR_y*(y_screen + 4), text, COLOUR.minor_extended_sprites, false, false, 0.5, 1.0)
            if minorspr_number == 10 then  -- Boo stream
                draw_rectangle(x_screen + 4, y_screen + 4 + Y_CAMERA_OFF, 8, 8, COLOUR.minor_extended_sprites, COLOUR.sprites_bg)
            end
            
            -- Draw in the table
            if OPTIONS.display_debug_info and OPTIONS.display_debug_minor_extended_sprite then
                draw_text(x_pos, y_pos + counter*height, ("#%d(%d): %d.%x(%d), %d.%x(%d)")
                :format(id, minorspr_number, x, floor(x_sub/16), xspeed, y, floor(y_sub/16), yspeed), COLOUR.minor_extended_sprites)
            end
            counter = counter + 1
        end
    end
    
    if OPTIONS.display_debug_info and OPTIONS.display_debug_minor_extended_sprite then
        draw_text(x_pos, y_pos - height, "Minor Ext Spr:" .. counter, COLOUR.weak)
    end
end


local function bounce_sprite_info()
    if not OPTIONS.display_bounce_sprite_info then return end
    
    -- Debug info
    local x_txt, y_txt = AR_x*90, AR_y*37
    if OPTIONS.display_debug_info and OPTIONS.display_debug_bounce_sprite then
        Text_opacity = 0.5
        draw_text(x_txt, y_txt, "Bounce Spr.", COLOUR.weak)
    end
    
    -- Font
    Text_opacity = 0.6
    local height = SNES9X_FONT_HEIGHT
    
    local stop_id = (u8(WRAM.bouncespr_last_id) - 1)%SMW2.bounce_sprite_max
    for id = 0, SMW2.bounce_sprite_max - 1 do
        local bounce_sprite_number = u8(WRAM.bouncespr_number + id)
        if bounce_sprite_number ~= 0 then
            local x = 256*u8(WRAM.bouncespr_x_high + id) + u8(WRAM.bouncespr_x_low + id)
            local y = 256*u8(WRAM.bouncespr_y_high + id) + u8(WRAM.bouncespr_y_low + id)
            local bounce_timer = u8(WRAM.bouncespr_timer + id)
            
            if OPTIONS.display_debug_info and OPTIONS.display_debug_bounce_sprite then
                draw_text(x_txt, y_txt + height*(id + 1), fmt("#%d:%d (%d, %d)", id, bounce_sprite_number, x, y))
            end
            
            local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
            x_screen, y_screen = AR_x*(x_screen + 8), AR_y*y_screen
            local color = id == stop_id and COLOUR.warning or COLOUR.text
            draw_text(x_screen , y_screen, fmt("#%d:%d", id, bounce_timer), color, false, false, 0.5)  -- timer
            
            -- Turn blocks
            if bounce_sprite_number == 7 then
                turn_block_timer = u8(WRAM.turn_block_timer + id)
                draw_text(x_screen, y_screen + height, turn_block_timer, color, false, false, 0.5)
            end
        end
    end
end


local function sprite_info(id, counter, table_position)
    Text_opacity = 1.0
	
	-- id to read memory correctly
	local id_off = 4*id
	
    local sprite_status = u8(SFXRAM.sprite_status + id_off)
    if sprite_status == 0 then return 0 end  -- returns if the slot is empty
    
    local sprite_type = u16(SFXRAM.sprite_type + id_off)
    local x = u16(SFXRAM.sprite_x + id_off + 2)
    local y = u16(SFXRAM.sprite_y + id_off + 2)
    local x_speed = s8(SFXRAM.sprite_x_speed + id_off)
	local x_subspeed = u8(SFXRAM.sprite_x_subspeed + id_off)
    local y_speed = s8(SFXRAM.sprite_y_speed + id_off)
	local y_subspeed = u8(SFXRAM.sprite_y_subspeed + id_off)
    --local x_sub = u8(WRAM.sprite_x_sub + id_off)
    --local y_sub = u8(WRAM.sprite_y_sub + id_off)
    --local stun = u8(WRAM.sprite_miscellaneous7 + id_off)
    --local underwater = u8(WRAM.sprite_underwater + id_off)
    --local x_offscreen = s8(WRAM.sprite_x_offscreen + id_off)
    --local y_offscreen = s8(WRAM.sprite_y_offscreen + id_off)
	
	sprite_type = string.upper(fmt("%03x", sprite_type)) -- to make it easier to read
    
    local special = ""
    --[[if (OPTIONS.display_debug_info and OPTIONS.display_debug_sprite_extra) or
    ((sprite_status ~= 0x8 and sprite_status ~= 0x9 and sprite_status ~= 0xa and sprite_status ~= 0xb) or stun ~= 0) then
        special = string.format("(%d %d) ", sprite_status, stun)
    end]] -- TODO
    
    ---**********************************************
    -- Calculates the sprites dimensions and screen positions
    
    local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
    
	if Game_mode == 0x0007 then -- adjustment for the intro "glitched" sprite positions
		x_screen = x_screen + Camera_x
		if Camera_y ~= 0 then
			y_screen = y_screen + Camera_y
		end
	--elseif Game_mode == 0x002C then y_screen = y_screen - 256
	end 
	
    -- Sprite clipping vs mario and sprites
    local boxid = bit.band(u8(WRAM.sprite_2_tweaker + id_off), 0x3f)  -- This is the type of box of the sprite
    local xoff = HITBOX_SPRITE[boxid].xoff
    local yoff = HITBOX_SPRITE[boxid].yoff + Y_CAMERA_OFF
    local sprite_width = HITBOX_SPRITE[boxid].width
    local sprite_height = HITBOX_SPRITE[boxid].height
    
    -- Sprite clipping vs objects
    local clip_obj = bit.band(u8(WRAM.sprite_1_tweaker + id_off), 0xf)  -- type of hitbox for blocks
    local xpt_right = OBJ_CLIPPING_SPRITE[clip_obj].xright
    local ypt_right = OBJ_CLIPPING_SPRITE[clip_obj].yright
    local xpt_left = OBJ_CLIPPING_SPRITE[clip_obj].xleft 
    local ypt_left = OBJ_CLIPPING_SPRITE[clip_obj].yleft
    local xpt_down = OBJ_CLIPPING_SPRITE[clip_obj].xdown
    local ypt_down = OBJ_CLIPPING_SPRITE[clip_obj].ydown
    local xpt_up = OBJ_CLIPPING_SPRITE[clip_obj].xup
    local ypt_up = OBJ_CLIPPING_SPRITE[clip_obj].yup
    
    -- Process interaction with player every frame?
    -- Format: dpmksPiS. This 'm' bit seems odd, since it has false negatives
    local oscillation_flag = bit.test(u8(WRAM.sprite_4_tweaker + id_off), 5) or OSCILLATION_SPRITES[number]
    
    -- calculates the correct color to use, according to id
    local info_color = COLOUR.sprites[id%(#COLOUR.sprites) + 1]
    local color_background = COLOUR.sprites_bg
    --[[ sprite_type == 0x35 then -- TODO
        info_color = COLOUR.yoshi
        color_background = COLOUR.yoshi_bg
    else
        info_color = COLOUR.sprites[id%(#COLOUR.sprites) + 1]
        color_background = COLOUR.sprites_bg
    end]]
    
    
    --[[if (not oscillation_flag) and (Real_frame - id)%2 == 1 then color_background = 0 end     -- due to sprite oscillation every other frame
                                                                                    -- notice that some sprites interact with Mario every frame
    ;]] -- TODO
    
    
    ---**********************************************
    --[[ Displays sprites hitboxes -- TODO
    if OPTIONS.display_sprite_hitbox then
        -- That's the pixel that appears when the sprite vanishes in the pit
        if y_screen >= 224 or (OPTIONS.display_debug_info and OPTIONS.display_debug_sprite_extra) then
            draw_pixel(x_screen, y_screen, info_color)
        end
        
        if Sprite_hitbox[id][sprite_type].block then
            draw_box(x_screen + xpt_left, y_screen + ypt_down, x_screen + xpt_right, y_screen + ypt_up,
                COLOUR.sprites_clipping_bg, Sprite_hitbox[id][sprite_type].sprite and 0 or COLOUR.sprites_clipping_bg)
        end
        
        if Sprite_hitbox[id][sprite_type].sprite and not ABNORMAL_HITBOX_SPRITES[sprite_type] then  -- show sprite/sprite clipping
            draw_rectangle(x_screen + xoff, y_screen + yoff, sprite_width, sprite_height, info_color, color_background)
        end
        
        if Sprite_hitbox[id][sprite_type].block then  -- show sprite/object clipping
            local size, color = 1, COLOUR.sprites_interaction_pts
            draw_line(x_screen + xpt_right, y_screen + ypt_right, x_screen + xpt_right - size, y_screen + ypt_right, 1, color) -- right
            draw_line(x_screen + xpt_left, y_screen + ypt_left, x_screen + xpt_left + size, y_screen + ypt_left, 1, color)  -- left
            draw_line(x_screen + xpt_down, y_screen + ypt_down, x_screen + xpt_down, y_screen + ypt_down - size, 1, color) -- down
            draw_line(x_screen + xpt_up, y_screen + ypt_up, x_screen + xpt_up, y_screen + ypt_up + size, 1, color)  -- up
        end
    end]]
    
    
    ---**********************************************
    -- Special sprites analysis:
    
    
    
    ---**********************************************
    -- Prints those informations next to the sprite
    Text_opacity = 0.7  -- Snes9x
    Bg_opacity = 1.0
    
	if x_screen >= 0 and x_screen <= 256 and y_screen >= 0 and y_screen <= 224 then
		Text_opacity = 0.8
	else
		Text_opacity = 0.5
	end
	
	draw_text(x_screen + 8, y_screen - 5, fmt("<%02d>", id), info_color, COLOUR.background, COLOUR.halo, true)
	
	-- Sprite position pixel and cross
	draw_pixel(x_screen, y_screen, info_color, COLOUR.background)
	if OPTIONS.display_debug_sprite_extra then
		gui.crosshair(x_screen, y_screen, 2, info_color)
	end
    
    ---**********************************************
    -- The sprite table:
	
    --[[cal x_speed_water = "" -- TODO
    if underwater ~= 0 then  -- if sprite is underwater
        local correction = floor(3*floor(x_speed/2)/2)
        x_speed_water = string.format("%+.2d=%+.2d", correction - x_speed, correction)
    end]]
    --local sprite_str = fmt("#%02d %02x %s%d.%1x(%+.2d%s) %d.%1x(%+.2d)", 
                    --id, sprite_type, special, x, floor(x_sub/16), x_speed, x_speed_water, y, floor(y_sub/16), y_speed)
	
	local x_spd_str = string.upper(fmt("%x ", SFXRAM.sprite_x_speed + id_off)) -- REMOVE
	--special = x_spd_str -- REMOVE
	
	local sprite_str = fmt("<%02d> %s %s%d(%+d.%02x), %d(%+d.%02x)", id, sprite_type, special, x, x_speed, x_subspeed, y, y_speed, y_subspeed)        
	
    --Text_opacity = 1.0
    Bg_opacity = 1.0
    if x_screen >= 0 and x_screen <= 256 and y_screen >= 0 and y_screen <= 224 then
		Text_opacity = 0.8
	else
		Text_opacity = 0.5
	end
		
    draw_text(Buffer_width + Border_right, table_position + counter*SNES9X_FONT_HEIGHT, sprite_str, info_color, true)
    
    -- Miscellaneous sprite table
    if OPTIONS.display_miscellaneous_sprite_table then
        -- Font
        Font = false
        local x_mis, y_mis = 0, AR_y*144 + counter*SNES9X_FONT_HEIGHT
        
        local t = OPTIONS.miscellaneous_sprite_table_number
        local misc, text = nil, fmt("#%.2d", id)
        for num = 1, 19 do
            misc = t[num] and u8(WRAM["sprite_miscellaneous" .. num] + id_off) or false
            text = misc and fmt("%s %3d", text, misc) or text
        end
        
        draw_text(x_mis, y_mis, text, info_color)
    end
    
	---**********************************************
    -- Exporting some values
    Sprites_info[id].sprite_type = sprite_type
    Sprites_info[id].x, Sprites_info[id].y = x, y
    Sprites_info[id].x_screen, Sprites_info[id].y_screen = x_screen, y_screen
    Sprites_info[id].boxid = boxid
    Sprites_info[id].xoff, Sprites_info[id].yoff = xoff, yoff
    Sprites_info[id].width, Sprites_info[id].height = sprite_width, sprite_height
    
    return 1
end


local function sprites()
    if not OPTIONS.display_sprite_info then return end
	
	local valid_game_mode = false
	if Game_mode == SMW2.game_mode_level then valid_game_mode = true
	elseif Game_mode == 0x0007 then valid_game_mode = true end -- Intro (0x0007) too
	if valid_game_mode == false then return end
    
    local counter = 0
    local table_position = AR_y*22
    for id = 0, SMW2.sprite_max - 1 do
        counter = counter + sprite_info(id, counter, table_position)
    end
    
    -- Font
    Text_opacity = 0.6 -- Snes9x
    
 
    draw_text(Buffer_width + Border_right, table_position - SNES9X_FONT_HEIGHT, fmt("spr:%.2d", counter), COLOUR.weak, true)
    --
    -- Miscellaneous sprite table: index
    if OPTIONS.display_miscellaneous_sprite_table then
        Font = false
        
        local t = OPTIONS.miscellaneous_sprite_table_number
        local text = "Tab"
        for num = 1, 19 do
            text = t[num] and fmt("%s %3d", text, num) or text
        end
        
        draw_text(0, AR_y*144 - SNES9X_FONT_HEIGHT, text, info_color)
    end
end


local function yoshi()
    if not OPTIONS.display_yoshi_info then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    local x_text = 0
    local y_text = AR_y*88
    
    local yoshi_id = Yoshi_id
    if yoshi_id ~= nil then
        local eat_id = u8(WRAM.sprite_miscellaneous16 + yoshi_id)
        local eat_type = u8(WRAM.sprite_number + eat_id)
        local tongue_len = u8(WRAM.sprite_miscellaneous4 + yoshi_id)
        local tongue_timer = u8(WRAM.sprite_miscellaneous9 + yoshi_id)
        local tongue_wait = u8(WRAM.sprite_tongue_wait)
        local tongue_height = u8(WRAM.yoshi_tile_pos)
        local tongue_out = u8(WRAM.sprite_miscellaneous13 + yoshi_id)
        
        local eat_type_str = eat_id == SMW2.null_sprite_id and "-" or string.format("%02x", eat_type)
        local eat_id_str = eat_id == SMW2.null_sprite_id and "-" or string.format("#%02d", eat_id)
        
        -- Yoshi's direction and turn around
        local turn_around = u8(WRAM.sprite_miscellaneous14 + yoshi_id)
        local yoshi_direction = u8(WRAM.sprite_miscellaneous12 + yoshi_id)
        local direction_symbol
        if yoshi_direction == 0 then direction_symbol = RIGHT_ARROW else direction_symbol = LEFT_ARROW end
        
        draw_text(x_text, y_text, fmt("Yoshi %s %d", direction_symbol, turn_around), COLOUR.yoshi)
        local h = SNES9X_FONT_HEIGHT
        
        if eat_id == SMW2.null_sprite_id and tongue_len == 0 and tongue_timer == 0 and tongue_wait == 0 then
            Text_opacity = 0.2 -- Snes9x
        end
        draw_text(x_text, y_text + h, fmt("(%0s, %0s) %02d, %d, %d",
                            eat_id_str, eat_type_str, tongue_len, tongue_wait, tongue_timer), COLOUR.yoshi)
        ;
        
        -- more WRAM values
        local yoshi_x = 256*u8(WRAM.sprite_x_high + yoshi_id) + u8(WRAM.sprite_x_low + yoshi_id)
        local yoshi_y = 256*u8(WRAM.sprite_y_high + yoshi_id) + u8(WRAM.sprite_y_low + yoshi_id)
        local x_screen, y_screen = screen_coordinates(yoshi_x, yoshi_y, Camera_x, Camera_y)
        
        -- invisibility timer
        local mount_invisibility = u8(WRAM.sprite_miscellaneous18 + yoshi_id)
        if mount_invisibility ~= 0 then
            Text_opacity = 0.5 -- Snes9x
            draw_text(AR_x*(x_screen + 4), AR_y*(y_screen - 12), mount_invisibility, COLOUR.yoshi)
        end
        
        -- Tongue hitbox and timer
        if tongue_wait ~= 0 or tongue_out ~=0 or tongue_height == 0x89 then  -- if tongue is out or appearing
            -- the position of the hitbox pixel
            local tongue_direction = yoshi_direction == 0 and 1 or -1
            local tongue_high = tongue_height ~= 0x89
            local x_tongue = x_screen + 24 - 40*yoshi_direction + tongue_len*tongue_direction
            x_tongue = not tongue_high and x_tongue or x_tongue - 5*tongue_direction
            local y_tongue = y_screen + 10 + 11*(tongue_high and 0 or 1)
            
            -- the drawing
            local tongue_line
            if tongue_wait <= 9  then  -- hitbox point vs berry tile
                draw_rectangle(x_tongue - 1, y_tongue - 1, 2, 2, COLOUR.tongue_bg, COLOUR.text)
                tongue_line = COLOUR.tongue_line
            else tongue_line = COLOUR.tongue_bg
            end
            
            -- tongue out: time predictor
            local tinfo, tcolor
            if tongue_wait > 9 then tinfo = tongue_wait - 9; tcolor = COLOUR.tongue_line  -- not ready yet
            
            elseif tongue_out == 1 then tinfo = 17 + tongue_wait; tcolor = COLOUR.text  -- tongue going out
            
            elseif tongue_out == 2 then  -- at the max or tongue going back
                tinfo = math.max(tongue_wait, tongue_timer) + floor((tongue_len + 7)/4) - (tongue_len ~= 0 and 1 or 0)
                tcolor = eat_id == SMW2.null_sprite_id and COLOUR.text or COLOUR.warning
            
            elseif tongue_out == 0 then tinfo = 0; tcolor = COLOUR.text  -- tongue in
            
            else tinfo = tongue_timer + 1; tcolor = COLOUR.tongue_line -- item was just spat out
            end
            
            Text_opacity = 0.5 -- Snes9x
            draw_text(AR_x*(x_tongue + 4), AR_y*(y_tongue + 5), tinfo, tcolor, false, false, 0.5)
            Text_opacity = 1.0
            draw_rectangle(x_tongue, y_tongue + 1, 8, 4, tongue_line, COLOUR.tongue_bg)
        end
        
    end
end


local function show_counters()
    if not OPTIONS.display_counters then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    local height = SNES9X_FONT_HEIGHT
    local text_counter = 0
    
    local eat_timer = u16(SFXRAM.eat_timer)
    local transform_timer = u16(SFXRAM.transform_timer)
    local star_timer = u16(SFXRAM.star_timer)
    local switch_timer = u16(WRAM.switch_timer)
    --local end_level_timer = u8(SFXRAM.end_level_timer)
    
    local display_counter = function(label, value, default, mult, frame, color)
        if value == default then return end
        text_counter = text_counter + 1
        local color = color or COLOUR.text
        
        draw_text(0, AR_y*102 + (text_counter * height), fmt("%s: %d", label, (value * mult) - frame), color)
    end
    
    if Player_animation_trigger == 5 or Player_animation_trigger == 6 then
        display_counter("Pipe", pipe_entrance_timer, -1, 1, 0, COLOUR.counter_pipe)
    end
    display_counter("Swallow", eat_timer, 0, 1, 0, COLOUR.counter_multicoin)
    display_counter("Transform", transform_timer, 0, 1, 0, COLOUR.counter_gray_pow)
    display_counter("Star", star_timer, 0, 1, 0, COLOUR.counter_blue_pow)
	if Game_mode == SMW2.game_mode_level then
		display_counter("Switch", switch_timer, 0, 1, 0, COLOUR.counter_dircoin)
    end
	--display_counter("End Level", end_level_timer, 0, 2, (Real_frame - 1) % 2)
    
    --if Lock_animation_flag ~= 0 then display_counter("Animation", animation_timer, 0, 1, 0) end  -- shows when player is getting hurt or dying
    
end


-- Main function to run inside a level
local function level_mode()
    --if Game_mode == SMW2.game_mode_level then
        
        -- Draws/Erases the tiles if user clicked
	    draw_tilesets(Camera_x, Camera_y)
		
        --draw_layer1_tiles(Camera_x, Camera_y)
        
        --draw_layer2_tiles()
        
        sprites()
        
        --extended_sprites()
        
        --cluster_sprites()
        
        --minor_extended_sprites()
        
        --bounce_sprite_info()
        
        --level_info()
        
        player()
        
        --yoshi()
        
        show_counters()
        
        -- Draws/Erases the hitbox for objects
        if true or User_input.mouse_inwindow == 1 then
            select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
        end
        
    --end
end


local function overworld_mode() -- TODO
    --[[if Game_mode ~= SMW2.game_mode_overworld then return end
    
    -- Font
    Text_opacity = 1.0
    Bg_opacity = 1.0
    
    local height = SNES9X_FONT_HEIGHT
    local y_text = SNES9X_FONT_HEIGHT
    
    -- Real frame modulo 8
    local real_frame_8 = Real_frame%8
    draw_text(Buffer_width + Border_right, y_text, fmt("Real Frame = %3d = %d(mod 8)", Real_frame, real_frame_8), true)
    
    -- Star Road info
    local star_speed = u8(WRAM.star_road_speed)
    local star_timer = u8(WRAM.star_road_timer)
    y_text = y_text + height
    draw_text(Buffer_width + Border_right, y_text, fmt("Star Road(%x %x)", star_speed, star_timer), COLOUR.cape, true)]]
end


local function left_click()
    for _, field in pairs(Script_buttons) do
        
        -- if mouse is over the button
        if mouse_onregion(field.x, field.y, field.x + field.width, field.y + field.height) then
                field.action()
                return
        end
    end
    
    -- Drag and drop sprites
    if Cheat.allow_cheats then
        local id = select_object(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
        if type(id) == "number" and id >= 0 and id < SMW2.sprite_max then
            Cheat.dragging_sprite_id = id
            Cheat.is_dragging_sprite = true
            return
        end
    end
    
    if not Options_menu.show_menu then
        --select_tile()
    end    
	
	-- Layer 1 tiles
    --[[local x_mouse, y_mouse = game_coordinates(User_input.xmouse, User_input.ymouse, Camera_x, Camera_y)
    x_mouse = 16*floor(x_mouse/16)
    y_mouse = 16*floor(y_mouse/16)
    if not Options_menu.show_menu then
        select_tile(x_mouse, y_mouse, Layer1_tiles)
    end]]
end


-- This function runs at the end of paint callback
-- Specific for info that changes if the emulator is paused and idle callback is called
local function snes9x_buttons()
    -- Font
    Text_opacity = 1.0
    
    if not Options_menu.show_menu and User_input.mouse_inwindow == 1 then
        create_button(100, -Border_top, " Menu ", function() Options_menu.show_menu = true end) -- Snes9x
        
        create_button(-Border_left, Buffer_height - Border_bottom, Cheat.allow_cheats and "Cheats: allowed" or "Cheats: blocked",
            function() Cheat.allow_cheats = not Cheat.allow_cheats end, {always_on_client = true, ref_y = 1.0})
        ;
        
        create_button(Buffer_width + Border_right, Buffer_height + Border_bottom, "Erase Tiles",
            function() Layer1_tiles = {}; Layer2_tiles = {} end, {always_on_client = true, ref_y = 1.0})
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
        alert_text(Buffer_middle_x - 3*SNES9X_FONT_WIDTH, 0, " Cheat ", COLOUR.warning,COLOUR.warning_bg)
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
    if u8(WRAM.level_exit_type) == 0x80 and u8(WRAM.midway_point) == 1 then
        if secret_exit then
            w8(WRAM.level_exit_type, 0x2)
        else
            w8(WRAM.level_exit_type, 1)
        end
    end
    
    Cheat.is_cheating = true
end


-- allows start + select + X to activate the normal exit
--        start + select + A to activate the secret exit 
--        start + select + B to exit the level without activating any exits
function Cheat.beat_level()
    if Is_paused and Joypad["select"] and (Joypad["X"] or Joypad["A"] or Joypad["B"]) then
        w8(WRAM.level_flag_table + Level_index, bit.bor(Level_flag, 0x80))
        
        local secret_exit = Joypad["A"]
        if not Joypad["B"] then
            w8(WRAM.midway_point, 1)
        else
            w8(WRAM.midway_point, 0)
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
    if (Joypad["L"] and Joypad["R"] and Joypad["down"]) then Cheat.under_free_move = false end
    if not Cheat.under_free_move then
        if Previous.under_free_move then end--w8(WRAM.frozen, 0) end
        return
    end
    
    local x_pos, y_pos = u16(SFXRAM.x), u16(SFXRAM.y)
    --local movement_mode = u8(WRAM.player_animation_trigger)
    local pixels = (Joypad["Y"] and 7) or (Joypad["X"] and 4) or 1  -- how many pixels per frame
    
    if Joypad["left"] then x_pos = x_pos - pixels end
    if Joypad["right"] then x_pos = x_pos + pixels end
    if Joypad["up"] then y_pos = y_pos - pixels end
    if Joypad["down"] then y_pos = y_pos + pixels end
    
    --[[ freeze player to avoid deaths
    if movement_mode == 0 then
        w8(WRAM.frozen, 1)
        w8(WRAM.x_speed, 0)
        w8(WRAM.y_speed, 0)
        
        -- animate sprites by incrementing the effective frame
        w8(WRAM.effective_frame, (u8(WRAM.effective_frame) + 1) % 256)
    else
        w8(WRAM.frozen, 0)
    end]]
    
    -- manipulate some values
    w16(SFXRAM.x, x_pos)
    w16(SFXRAM.y, y_pos)
    --w8(WRAM.invincibility_timer, 127)
    --[[w8(WRAM.vertical_scroll_flag_header, 1)  -- free vertical scrolling
    w8(WRAM.vertical_scroll_enabled, 1)]]
    
    Cheat.is_cheating = true
    Previous.under_free_move = true
end


-- Drag and drop sprites with the mouse, if the cheats are activated and mouse is over the sprite
-- Right clicking and holding: drags the sprite
-- Releasing: drops it over the latest spot
function Cheat.drag_sprite(id)
    --if Game_mode ~= SMW2.game_mode_level then Cheat.is_dragging_sprite = false ; return end
    
    local xoff, yoff = Sprites_info[id].xoff, Sprites_info[id].yoff
    local xgame, ygame = game_coordinates(User_input.xmouse - xoff, User_input.ymouse - yoff, Camera_x, Camera_y)
    
    local sprite_xhigh = floor(xgame/256)
    local sprite_xlow = xgame - 256*sprite_xhigh
    local sprite_yhigh = floor(ygame/256)
    local sprite_ylow = ygame - 256*sprite_yhigh
    
    w8(WRAM.sprite_x_high + id, sprite_xhigh)
    w8(WRAM.sprite_x_low + id, sprite_xlow)
    w8(WRAM.sprite_y_high + id, sprite_yhigh)
    w8(WRAM.sprite_y_low + id, sprite_ylow)
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
-- MEMORY EDIT --

function Memory.edit()
	if not Memory.allow_edit then return end
	if not apply then return end

	if OPTIONS.edit_method == "Freeze" then
		poked = false
	else
		apply = false
	end
	
	local slot = OPTIONS.edit_sprite_table_number
	if not poked then
		if OPTIONS.edit_sprite_table then
			for i = 1, SMW2.sprite_max do
				if slot[i] then
					if OPTIONS.size == 2 then
						memory.writeword(OPTIONS.address + 2*(i - 1), OPTIONS.value)
					else
						memory.writebyte(OPTIONS.address + 2*(i - 1), OPTIONS.value)
					end
			
					if OPTIONS.edit_method == "Poke" then
						emu.message("\n         Applied address poke")
					else
						alert_text(Buffer_middle_x - 12*SNES9X_FONT_WIDTH, 190, " Appling address freeze ", COLOUR.warning, COLOUR.warning_bg)
					end
			
					poked = true
				end
			end
		else
			if OPTIONS.size == 2 then
				memory.writeword(OPTIONS.address, OPTIONS.value)
			else
				memory.writebyte(OPTIONS.address, OPTIONS.value)
			end
		
			if OPTIONS.edit_method == "Poke" then
				emu.message("\n         Applied address poke")
			else
				alert_text(Buffer_middle_x - 12*SNES9X_FONT_WIDTH, 190, " Appling address freeze ", COLOUR.warning, COLOUR.warning_bg)
			end
		
			poked = true
		end
	end
end


--#############################################################################
-- MAIN --


-- Key presses:
Keys.registerkeypress("rightclick", right_click)
Keys.registerkeypress("leftclick", left_click)
Keys.registerkeypress(OPTIONS.hotkey_increase_opacity, increase_opacity)
Keys.registerkeypress(OPTIONS.hotkey_decrease_opacity, decrease_opacity)

-- Key releases:
Keys.registerkeyrelease("mouse_inwindow", function() Cheat.is_dragging_sprite = false end)
Keys.registerkeyrelease("leftclick", function() Cheat.is_dragging_sprite = false end)


gui.register(function()
    -- Initial values, don't make drawings here
    snes9x_status()
    Script_buttons = {}  -- reset the buttons
    
    -- Dark filter to cover the game area
    if Filter_opacity ~= 0 then
        gui.opacity(Filter_opacity/10)
        gui.box(0, 0, Buffer_width, Buffer_height, Filter_color)
        gui.opacity(1.0)
    end
    
    -- Drawings are allowed now
    scan_smw2()
    
    level_mode()
    overworld_mode()
    
    show_movie_info()
    show_misc_info()
    show_controller_data()
    
    Cheat.is_cheat_active()
    
    snes9x_buttons()
	
	show_mouse_info()
	
	--memory.writebyte(0x7E03B4, 255)
	
	--
	if Options_menu.current_tab == "Memory edit" then -- REMOVE
		gui.text(180, 192, string.format("poked = %s", tostring(poked)), COLOUR.warning)
		gui.text(180, 200, string.format("apply = %s", tostring(apply)), COLOUR.warning)
		gui.text(170, 208, string.format(".edit_method = %s", tostring(OPTIONS.edit_method)), COLOUR.warning)
	end
end)


emu.registerbefore(function()
    Joypad = joypad.get(1)
    
    if Cheat.allow_cheats then
        Cheat.is_cheating = false
        
        Cheat.beat_level()
        Cheat.free_movement()
    else
        -- Cancel any continuous cheat
        Cheat.under_free_move = false
        
        Cheat.is_cheating = false
    end
	
	Memory.edit()
end)


emu.registerexit(function()
    INI.save_options()
    print("Finishing Yoshi's Island script.")
end)


print("Lua script loaded successfully.")


while true do
    -- User input data
    Previous.User_input = copytable(User_input)
    local tmp = input.get()
    for entry, value in pairs(User_input) do
        User_input[entry] = tmp[entry] or false
    end
    User_input.mouse_inwindow = mouse_onregion(0, 0, Buffer_width - 1, Buffer_height - 1) and 1 or 0 -- Snes9x, custom field
    
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
    
    -- Lag-flag is accounted correctly only inside this loop
    Is_lagged = emu.lagged()
    
    emu.frameadvance()
end
