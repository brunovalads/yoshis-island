----------------------------------------------------------------------------------
--  Super Mario Advance 3 - Yoshi's Island (USA) Utility Script for BizHawk
--  
--  Author: BrunoValads 
--  Git repository: https://github.com/brunovalads/yoshis-island
----------------------------------------------------------------------------------

--##########################################################################################################################################################
-- CONFIG:

-- Script options
local OPTIONS = {
    
    -- Display settings
    display_player_hitbox = true,
    display_collision_status = true,
    display_egg_info = true,
    display_throw_info = true,
    display_sprite_table = true,
    display_sprite_hitbox = true,
    display_sprite_special_info = true,
    display_secondary_sprite_table = true,
    display_secondary_sprite_slot_in_screen = true,
    display_level_info = true,
    display_level_layout = true,
    display_counters = true,
    
    -- Gaps around the game area
    left_gap = 120, 
    right_gap = 243,
    top_gap = 30,
    bottom_gap = 80,
    
    ---- DEBUG AND CHEATS ----
    DEBUG = false, -- to display debug info for script development only!
    CHEATS = false, -- to help research, ALWAYS DISABLED WHEN RECORDING MOVIES
}
if OPTIONS.DEBUG then
    OPTIONS.left_gap = 90
    OPTIONS.right_gap = 620
    OPTIONS.top_gap = 10
    OPTIONS.bottom_gap = 248
end

-- Font settings (correction to the scale is done in bizhawk_screen_info)
local BIZHAWK_FONT_WIDTH = 10
local BIZHAWK_FONT_HEIGHT = 18
local PIXEL_FONT_WIDTH = 4
local PIXEL_FONT_HEIGHT = 8

-- Colour settings
local COLOUR = {
    -- Text
    default_text_opacity = 1.0,
    default_bg_opacity = 0.7,
    text = 0xffffffff, -- white
    background = 0xff000000, -- black
    positive = 0xff00FF00, -- green
    warning = 0xffFF0000, -- red
    warning_bg = 0xC0000000,
    warning2 = 0xffFF00FF, -- magenta
    warning_soft = 0xffFFA500, -- orange
    warning_transparent = 0x80FF0000, -- red (50% transparent)
    weak = 0xaaA9A9A9, -- gray (66% transparent)
    weak2 = 0xff555555, -- gray
    very_weak = 0x55A9A9A9, -- gray (33% transparent)
    disabled = 0xff808080, -- gray
    memory = 0xff00FFFF, -- cyan

    -- Yoshi
    yoshi = 0xff3AE63A,
    yoshi_bg = 0x403AE63A,
    tongue = 0xffFF6B4A,
    tongue_bg = 0x60FF6B4A,
    yoshies = { -- indexed by IWRAM.yoshi_colour, the gradient is lighter to darker, extracted from BizHawk's mGBA core with "Vivid" Color Type
        [0] = {0xff73FF6B, 0xff3AE63A, 0xff29B529}, -- green
        [1] = {0xffFFD6EF, 0xffFFB5C5, 0xffF76B7B}, -- pink
        [2] = {0xffFFFF29, 0xffFFCE5A, 0xffFF7B08}, -- yellow (id is swapped with cyan for some reason)
        [3] = {0xff94FFFF, 0xff7BD6FF, 0xff73B5D6}, -- cyan (id is swapped with yellow for some reason)
        [4] = {0xffEFCEFF, 0xffD6A5EF, 0xffAD73C5}, -- purple
        [5] = {0xffFFCEAD, 0xffDEB594, 0xffBD8C73}, -- brown
        [6] = {0xffFF8473, 0xffE65A5A, 0xff9C4242}, -- red
        [7] = {0xff9494F7, 0xff7373CE, 0xff4A4A94}, -- blue
    },

    -- Sprites
    sprites_default = { -- 100% sat, use change_saturation to adapt accordingly
        0xff00FFFF, -- cyan
        0xff0000FF, -- blue
        0xffFF00FF, -- magenta
        0xffFF0000, -- red
        0xffFF7F00, -- orange
        0xffFFFF00, -- yellow
        0xff00FF00  -- green
    },
    eggs = {
        green = 0xff29FF29,
        yellow = 0xffFFFF29,
        red = 0xffFF2929,
        pink = 0xffFF29E6,
        key = 0xffFFA529,--0xffFFEF29,, --
        huffin = 0xffADC5EF, --0xff9C63B5
    },

    -- Hitbox and related text
    interaction = 0xffFFFFFF,
    interaction_bg = 0x20000000,
    detection_bg = 0x30400020,

    -- Timers
    invincibility = 0xff3AE63A,
    swallow = 0xffFF6B4A,
    transform = 0xffFFFFBD,
    star = 0xffFFFF29,
    switch = 0xffFF2929,
    fuzzy = 0xffDEFFFF,

    -- Blocks
    solid_tile = 0xff00008B,
    blank_tile = 0x70FFFFFF,
    block_bg = 0xa022CC88,
}


--##########################################################################################################################################################
-- SCRIPT UTILITIES:

-- Some useful basic function lacking in Lua
function math.round(number, dec_places)
    local mult = 10^(dec_places or 0)
    return math.floor(number * mult + 0.5) / mult
end

function string.insert(str1, str2, pos)
    return str1:sub(1, pos)..str2..str1:sub(pos+1)
end

-- Variables used in various functions
local Cheat = {}  -- family of cheat functions and variables
local Previous = {}

-- General BizHawk functions and variables
local Biz = {}

-- Get main BizHawk status
function Biz.get_status()
    Biz.movie_active = movie.isloaded()
    Biz.readonly = movie.getreadonly()
    if Biz.movie_active then
        Biz.movie_length = movie.length()
        Biz.rerecords = movie.getrerecordcount()
    end
    Biz.framecount = emu.framecount()
    Biz.lagcount = emu.lagcount()
    Biz.is_lagged = emu.islagged()
end

-- Check if the script is running on BizHawk
function Biz.check_emulator()
    if tastudio == nil then
        error("\n\nThis script only works with BizHawk emulator.\nVisit http://tasvideos.org/Bizhawk/ReleaseHistory.html to download the latest version.")
    end
end

-- Check the name of the ROM domain (as it might have differences between cores)
Biz.memory_domain_list = memory.getmemorydomainlist()
function Biz.check_ROM_domain()
    for key, domain in ipairs(Biz.memory_domain_list) do
        if domain:find("ROM") then return domain end
    end
    --if didn't find ROM domain then
    error("This core doesn't have ROM domain exposed for the script, please change the core!")
end

-- Check the game name in the <address> in ROM with specified <length>
function Biz.game_name(address, length)
    local game_name = ""
    for i = 0, length-1 do
        game_name = game_name .. string.char(memory.read_u8(address + i, Biz.ROM_domain))
    end
    return game_name
end

-- Get screen dimensions of the emulator and the game
local PC, Game = {}, {}
local Scale
function Biz.screen_info()
    -- Get/calculate screen scale -------------------------------------------------
    if client.borderwidth() == 0 then -- to avoid division by zero bug when borders are not yet ready when loading the script
        Scale = 2 -- because is the one I always use
    elseif OPTIONS.left_gap > 0 and OPTIONS.top_gap > 0 then -- to make sure this method won't get div/0
        Scale = math.min(client.borderwidth()/OPTIONS.left_gap, client.borderheight()/OPTIONS.top_gap) -- Pixel scale
    else
        Scale = client.getwindowsize()
    end

    -- Dimensions in PC pixels ----------------------------------------------------
    PC.screen_width = client.screenwidth()   --\ Emu screen drawing area (doesn't take menu and status bar into account)
    PC.screen_height = client.screenheight() --/ 

    PC.left_padding = client.borderwidth()         --\
    PC.right_padding = OPTIONS.right_gap * Scale   -- | Emu extra paddings around the game area
    PC.top_padding = client.borderheight()         -- |
    PC.bottom_padding = OPTIONS.bottom_gap * Scale --/

    PC.buffer_width = PC.screen_width - PC.left_padding - PC.right_padding   --\ Game area
    PC.buffer_height = PC.screen_height - PC.top_padding - PC.bottom_padding --/

    PC.buffer_middle_x = PC.left_padding + PC.buffer_width/2 --\ Middle coordinates of the game area, referenced to the whole emu screen
    PC.buffer_middle_y = PC.top_padding + PC.buffer_height/2 --/

    PC.screen_middle_x = PC.screen_width/2  --\ Middle coordinates of the emu screen drawing area
    PC.screen_middle_y = PC.screen_height/2 --/

    PC.right_padding_start = PC.left_padding + PC.buffer_width  --\ Coordinates for the start of right and bottom paddings
    PC.bottom_padding_start = PC.top_padding + PC.buffer_height --/
    
    PC.bizhawk_font_width = BIZHAWK_FONT_WIDTH   --\ Dimensions for the font BizHawk uses in gui.text
    PC.bizhawk_font_height = BIZHAWK_FONT_HEIGHT --/
    
    PC.pixel_font_width = PIXEL_FONT_WIDTH*Scale   --\ Dimensions for the font BizHawk uses in gui.pixelText
    PC.pixel_font_height = PIXEL_FONT_HEIGHT*Scale --/
    
    -- Dimensions in game pixels ----------------------------------------------------
    Game.buffer_width = client.bufferwidth()
    Game.buffer_height = client.bufferheight()

    Game.screen_width = PC.screen_width/Scale
    Game.screen_height = PC.screen_height/Scale

    Game.left_padding = PC.left_padding/Scale
    Game.right_padding = PC.right_padding/Scale
    Game.top_padding = PC.top_padding/Scale
    Game.bottom_padding = PC.bottom_padding/Scale

    Game.buffer_middle_x = Game.left_padding + Game.buffer_width/2
    Game.buffer_middle_y = Game.top_padding + Game.buffer_height/2

    Game.screen_middle_x = Game.screen_width/2
    Game.screen_middle_y = Game.screen_height/2

    Game.right_padding_start = Game.left_padding + Game.buffer_width
    Game.bottom_padding_start = Game.top_padding + Game.buffer_height
    
    Game.bizhawk_font_width = PC.bizhawk_font_width/Scale
    Game.bizhawk_font_height = PC.bizhawk_font_height/Scale
    
    Game.pixel_font_width = PIXEL_FONT_WIDTH
    Game.pixel_font_height = PIXEL_FONT_HEIGHT
end

-- A better text drawning function
local function draw_text(x, y, text, text_colour, ref_x, ref_y, anchor) -- Anchor flag parameters (str): topleft, topright, bottomleft, bottomright
    -- Get imensions
    local font_width  = Game.bizhawk_font_width -- "Game" here because i'm scaling the text position to match game scale
    local font_height = Game.bizhawk_font_height
    local length = string.len(text)*font_width
    
    -- Update position according to relative offset
    x = (not ref_x and x) or (ref_x == 0 and x) or x - math.floor(length*ref_x)
    y = (not ref_y and y) or (ref_y == 0 and y) or y - math.floor(font_height*ref_y)
    
    -- Finally draw the text
    gui.text(Scale*x, Scale*y, text, text_colour, anchor) -- "Scale" here because i'm scaling the text position to match game scale
    
    -- Return some positions and dimensions that might be useful when drawing multiple texts in sequence
    return x + length, y + font_height, length
end

-- A function to draw text better and with a background
local function draw_text_bg(x, y, text, text_colour, bg_colour, ref_x, ref_y, anchor) -- Anchor flag parameters (str): topleft, topright, bottomleft, bottomright
    -- Get imensions
    local font_width  = Game.bizhawk_font_width -- "Game" here because i'm scaling the text position to match game scale
    local font_height = Game.bizhawk_font_height
    local length = string.len(text)*font_width
    
    -- Update position according to relative offset
    x = (not ref_x and x) or (ref_x == 0 and x) or x - math.floor(length*ref_x)
    y = (not ref_y and y) or (ref_y == 0 and y) or y - math.floor(font_height*ref_y)
    
    -- Draw the bg rectangle for the text
    gui.drawRectangle(x, y, length - 1, font_height - 1, bg_colour, bg_colour)
    -- Finally draw the text
    gui.text(Scale*x, Scale*y, text, text_colour, anchor) -- "Scale" here because i'm scaling the text position to match game scale
    
    -- Return some positions and dimensions that might be useful when drawing multiple texts in sequence
    return x + length, y + font_height, length
end

-- Convert unsigned byte to signed in hex string
local function signed8hex(num, signal)
    local maxval = 128
    if signal == nil then signal = true end

    if num < maxval then -- positive
        return string.format("%s%02X", signal and "+" or "", num)
    else -- negative
        return string.format("%s%02X", signal and "-" or "", 2*maxval - num)
    end
end

-- Convert unsigned word to signed in hex string
local function signed16hex(num, signal)
    local maxval = 32768
    if signal == nil then signal = true end

    if num < maxval then -- positive
        return string.format("%s%04X", signal and "+" or "", num)
    else -- negative
        return string.format("%s%04X", signal and "-" or "", 2*maxval - num)
    end
end

-- Transform the binary representation of base into a string
local function decode_bits(data, base)
    local i = 1
    local size = base:len()
    local result = ""

    for ch in base:gmatch(".") do
        if bit.check(data, size - i) then
            result = result .. ch
        else
            result = result .. " "
        end
        i = i + 1
    end

    return result
end

-- Changes transparency of a colour: result is opaque original * transparency level (0.0 to 1.0)
local function change_transparency(colour, transparency)
    -- Sane transparency
    if transparency >= 1 then return colour end  -- no transparency
    if transparency <= 0 then return 0 end   -- total transparency

    -- Sane colour
    if colour == 0 then return 0 end
    if type(colour) ~= "number" then
        print(colour)
        error"Wrong colour"
    end

    local a = math.floor(colour/0x1000000)
    local rgb = colour - a*0x1000000
    local new_a = math.floor(a*transparency)
    return new_a*0x1000000 + rgb
end

-- Converts a 0xAARRGGBB color value to HSV (https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua)
-- Assumes r, g, and b are contained in the set [0x00, 0xFF] and returns h, s, and v in the set [0, 1]
local function RGBtoHSV(color)
    local a = bit.band(color, 0xff000000)/0x1000000
    local r = bit.band(color, 0x00FF0000)/0x10000
    local g = bit.band(color, 0x0000FF00)/0x100
    local b = bit.band(color, 0x000000FF)
    a, r, g, b = a/0xFF, r/0xFF, g/0xFF, b/0xFF
    
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h, s, v
    v = max

    local d = max - min
    if max == 0 then s = 0 else s = d / max end

    if max == min then
        h = 0 -- achromatic
    else
        if max == r then
            h = (g - b) / d
            if g < b then h = h + 6 end
        elseif max == g then h = (b - r) / d + 2
        elseif max == b then h = (r - g) / d + 4
        end
        h = h / 6
    end

    return h, s, v, a
end

-- Converts an HSV color value to 0xAARRGGBB (https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua)
-- Assumes h, s, and v are contained in the set [0, 1] and returns r, g, and b in the set [0x00, 0xFF]
local function HSVtoRGB(h, s, v, a)
    local r, g, b

    local i = math.floor(h * 6);
    local f = h * 6 - i;
    local p = v * (1 - s);
    local q = v * (1 - f * s);
    local t = v * (1 - (1 - f) * s);

    i = i % 6

    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    
    a = a or 1
    r, g, b, a = math.floor(r*0xFF), math.floor(g*0xFF), math.floor(b*0xFF), math.floor(a*0xFF)
    
    return a*0x1000000 + r*0x10000 + g*0x100 + b
end

-- Change saturation of a 0xAARRGGBB colour, by converting to HSV first and converting back with new saturation
local function change_saturation(colour, sat)
    local h, s, v, a = RGBtoHSV(colour)
    return HSVtoRGB(h, sat, v, a)
end

-- Get a complementary colour
local function complementary_colour(colour)
    local h, s, v, a = RGBtoHSV(colour)
    local new_h = math.mod(h + 0.5, 1)
    return HSVtoRGB(new_h, s, v, a)
end

--##########################################################################################################################################################
-- INITIAL STATEMENTS:

-- Clear the console
console.clear()

-- Check if is running in BizHawk
Biz.check_emulator()

-- Get the name of the ROM domain
Biz.ROM_domain = Biz.check_ROM_domain()

-- Check if it's Yoshi's Island (GBA, any version or hack)
if Biz.game_name(0x0000A0, 0x0E) ~= "SUPER MARIOCA3" and Biz.game_name(0x3FFFE0, 8) ~= "Advynia3" then -- U: SUPER MARIOCA3AE, E: SUPER MARIOCA3AP, J: SUPER MARIOCA3AJ
    error("\n\nThis script is for Yoshi's Island (GBA) only!")
end

-- The game is correct, then it can continue to load the script
print("Starting Yoshi's Island GBA Lua script.\n")

-- Basic functions renaming
local fmt = string.format
local floor = math.floor
local ceil = math.ceil
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local pi = math.pi

-- Rename used functions
local draw_line = gui.drawLine
local draw_box = gui.drawBox
local draw_rectangle = gui.drawRectangle
local draw_image = gui.drawImage
local draw_image_region = gui.drawImageRegion
local draw_cross = gui.drawAxis
local draw_pixel = gui.drawPixel
local draw_pixel_text = gui.pixelText

-- Compatibility of the memory read/write functions
local u8_iwram =  mainmemory.read_u8
local s8_iwram =  mainmemory.read_s8
local w8_iwram =  mainmemory.write_u8
local u16_iwram = mainmemory.read_u16_le
local s16_iwram = mainmemory.read_s16_le
local w16_iwram = mainmemory.write_u16_le
local u24_iwram = mainmemory.read_u24_le
local s24_iwram = mainmemory.read_s24_le
local w24_iwram = mainmemory.write_u24_le
local u32_iwram = mainmemory.read_u32_le
local s32_iwram = mainmemory.read_s32_le
local w32_iwram = mainmemory.write_u32_le
memory.usememorydomain("EWRAM")
local u8_ewram =  memory.read_u8
local s8_ewram =  memory.read_s8
local w8_ewram =  memory.write_u8
local u16_ewram = memory.read_u16_le
local s16_ewram = memory.read_s16_le
local w16_ewram = memory.write_u16_le
local u24_ewram = memory.read_u24_le
local s24_ewram = memory.read_s24_le
local w24_ewram = memory.write_u24_le
local u32_ewram = memory.read_u32_le
local s32_ewram = memory.read_s32_le
local w32_ewram = memory.write_u32_le

--##########################################################################################################################################################
-- GAME AND GBA SPECIFIC PARAMETERS:

-- GBA framerate
local FRAMERATE = 59.727500569606

-- Main YI constants
local YI = {
    -- Game states
    game_state_level = 0x0D,
    game_state_overworld = 0x35,

    -- Sprites
    sprite_max = 24, -- 0x18
    sprite_struct_size = 0xB0,
    secondary_sprite_max = 16, -- 0x10
    secondary_sprite_struct_size = 0xB0,
}

-- Known secondary sprites IDs, for documentation -- TODO: test more to see if there's some missing
YI.secondary_sprite_ids = {
	0x1C9,
    0x1D7,
    0x1E6, 0x1E7, 0x1E9, 0x1EC, 0x1EE,
    0x1F0, 0x1FD,
    0x204, 0x209,
    0x212, 0x21C,
    0x221, 0x225, 0x22A, 0x22E,
    0x230, 
}

-- Memory maps
local EWRAM = { -- 0200:0000 ~ 0203:FFFF
    -- General
    screen_exit_data = 0x1B000, -- 0x400 bytes
    screen_number_to_id = 0x1B800, -- 0x80 bytes
}

local IWRAM = { -- 0300:0000 ~ 0300:7FFF
    -- General
    frame_counter = 0x6AA2, -- 2 bytes
    game_state = 0x6B05,
    game_substate = 0x6B06,
    game_mode = 0x6D64,
    pause_state = 0x48B5,
    is_paused = 0x48B6,
    level_id = 0x6288,
    sublevel_id = 0x4CB8,
    camera_x = 0x69D4, -- 2 bytes
    camera_y = 0x69DC, -- 2 bytes
    
    -- Yoshi
    yoshi_x = 0x6D81, -- 2 bytes
    yoshi_y = 0x6D85, -- 2 bytes
    yoshi_x_sub = 0x6D80,
    yoshi_y_sub = 0x6D84,
    yoshi_x_speed = 0x6DA9,
    yoshi_x_subspeed = 0x6DA8,
    yoshi_y_speed = 0x6D8D,
    yoshi_y_subspeed = 0x6D8C,
    yoshi_center_x = 0x6E18, -- 2 bytes
    yoshi_center_y = 0x6E1A, -- 2 bytes
    yoshi_tongue_x = 0x6E5A, -- 2 bytes
    yoshi_tongue_y = 0x6E5C, -- 2 bytes
    yoshi_direction = 0x6DC2,
    yoshi_collision_status = 0x6DFA, -- 2 bytes
    yoshi_on_sprite_platform = 0x6F2E,
    yoshi_hitbox_half_width = 0x6E1C, -- 2 bytes
    yoshi_hitbox_half_height = 0x6E1E, -- 2 bytes
    tongued_slot = 0x6E68, -- 2 bytes, high byte is flag for inedible
    yoshi_colour_id = 0x6A96,
    
    -- Sprites
    sprite_struct = { --0x18 slots, each one a struct of 0xB0 bytes, total: 0x1080 bytes, range: $2460~$34DF
        base = 0x2460, -- the base address for the struct, each following entry has the offset that should be added to this base
        x_sub = 0x00,
        x = 0x01, -- 2 bytes
        y_sub = 0x04,
        y = 0x05, -- 2 bytes
        x_subspeed = 0x08,
        x_speed = 0x09,
        y_subspeed = 0x0C,
        y_speed = 0x0D,
        status = 0x24,
        id = 0x32, -- 2 bytes
        hitbox_center_offset_x = 0x4A, -- 2 bytes
        hitbox_center_offset_y = 0x4C, -- 2 bytes
        hitbox_half_width = 0x4E, -- 2 bytes
        hitbox_half_height = 0x50, -- 2 bytes
        center_x = 0x5A, -- 2 bytes
        center_y = 0x5C, -- 2 bytes
        -- = 0x,
        -- = 0x,
        -- = 0x,
        -- = 0x,
    },
    
    -- Secondary sprites
    secondary_sprite_struct = { --0x10 slots, each one a struct of 0xB0 bytes, total: 0xB00 bytes, range: $3D00~$47FF
        base = 0x3D00, -- the base address for the struct, each following entry has the offset that should be added to this base
        x_sub = 0x00,
        x = 0x01, -- 2 bytes
        y_sub = 0x04,
        y = 0x05, -- 2 bytes
        x_subspeed = 0x08,
        x_speed = 0x09,
        y_subspeed = 0x0C,
        y_speed = 0x0D,
        status = 0x24,
        id = 0x32, -- 2 bytes
        hitbox_center_offset_x = 0x4A, -- 2 bytes
        hitbox_center_offset_y = 0x4C, -- 2 bytes
        hitbox_half_width = 0x4E, -- 2 bytes
        hitbox_half_height = 0x50, -- 2 bytes
        center_x = 0x5A, -- 2 bytes
        center_y = 0x5C, -- 2 bytes
        -- = 0x,
        -- = 0x,
        -- = 0x,
        -- = 0x,
    },
    
    -- Inventory
    lives = 0x627E, -- 2 bytes
    coins = 0x6280, -- 2 bytes
    flowers = 0x6A9A, -- 2 bytes
    stars = 0x6ACE, -- 2 bytes
    red_coins = 0x6AD6, -- 2 bytes
    egg_inventory_size = 0x6FC8, -- 2 bytes
    egg_inventory = 0x6FCA, -- 12 bytes
    
    -- Timers
    invincibility_timer = 0x6F52,
    swallow_timer = 0x6F6A, -- 2 bytes
    transform_timer = 0x6E2C, -- 2 bytes
    star_timer = 0x6E2E, -- 2 bytes
    switch_timer = 0x3CE8, -- 2 bytes
    fuzzy_timer = 0x4BD6, -- 2 bytes
}


--##########################################################################################################################################################
-- YI FUNCTIONS:

-- Read main game variables that can be used in many places in this script
local Frame_counter, Game_state, Game_substate, Game_mode, Is_paused, Level_id, Sublevel_id
local Yoshi_x, Yoshi_y, Yoshi_center_x, Yoshi_center_y
local Camera_x, Camera_y
Previous.Camera_x, Previous.Camera_y = s16_iwram(IWRAM.camera_x), s16_iwram(IWRAM.camera_y) -- init here to avoid being nil in the first frame
local function scan_yi()
    -- Game general
    Frame_counter = u16_iwram(IWRAM.frame_counter)
    Game_state = u8_iwram(IWRAM.game_state)
    Game_substate = u8_iwram(IWRAM.game_substate)
    Game_mode = u8_iwram(IWRAM.game_mode)
    Is_paused = u8_iwram(IWRAM.pause_state) > 1
    Level_id = u8_iwram(IWRAM.level_id)
    Sublevel_id = u8_iwram(IWRAM.sublevel_id)
    
    -- Player
    Yoshi_x = s16_iwram(IWRAM.yoshi_x)
    Yoshi_y = s16_iwram(IWRAM.yoshi_y)
    Yoshi_center_x = s16_iwram(IWRAM.yoshi_center_x)
    Yoshi_center_y = s16_iwram(IWRAM.yoshi_center_y)
    
    -- Camera
    if Camera_x then Previous.Camera_x = Camera_x end -- conditional to avoid writing nil to prev
    if Camera_y then Previous.Camera_y = Camera_y end -- conditional to avoid writing nil to prev
    Camera_x = s16_iwram(IWRAM.camera_x)
    Camera_y = s16_iwram(IWRAM.camera_y)
end

-- Converts the in-game (x, y) to BizHawk-screen coordinates
local function screen_coordinates(x, y, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or s16_iwram(IWRAM.camera_x)
    camera_y = camera_y or Camera_y or s16_iwram(IWRAM.camera_y)

    -- Math
    local x_screen = (x - camera_x) + OPTIONS.left_gap
    local y_screen = (y - camera_y) + OPTIONS.top_gap

    return x_screen, y_screen
end

-- Converts BizHawk/emu-screen coordinates to in-game (x, y)
local function game_coordinates(x_emu, y_emu, camera_x, camera_y)
    -- Sane values
    camera_x = camera_x or Camera_x or s16_iwram(IWRAM.camera_x)
    camera_y = camera_y or Camera_y or s16_iwram(IWRAM.camera_y)

    -- Math
    local x_game = x_emu + camera_x - OPTIONS.left_gap
    local y_game = y_emu + camera_y - OPTIONS.top_gap

    return x_game, y_game
end

-- Check if current game state is valid for passed list
local function check_game_state_validity(game_states)
    -- Failsafe
    if not game_states then
        return false
    end
    -- Check agains each game state passed
    for _, state in pairs(game_states) do
        if Game_state == state then
            return true
        end
    end
    -- Return in case of not matching
    return false
end

-- Function to display general info
local function show_general_info()
    local xpos = 2
    
    -- Game state
    xpos = draw_text(xpos, Game.bizhawk_font_height * 0, fmt("Game state: %02X", Game_state), COLOUR.text, 0, 0, "topright") --(x, y, text, text_colour, ref_x, ref_y, anchor)
    
    -- Frame counter
    xpos = draw_text(xpos + 2*Game.bizhawk_font_width, Game.bizhawk_font_height * 0, fmt("Frame counter: %04X", Frame_counter), COLOUR.text, 0, 0, "topright") --(x, y, text, text_colour, ref_x, ref_y, anchor)
    
end

-- Display Yoshi's collision status
local function draw_collision_status(x_text, y_text, collision_status, yoshi_colour)
    local block_str = "Collision:"
    local xoffset = x_text + string.len(block_str)*Game.bizhawk_font_width
    local yoffset = y_text + 2
    local colour_set = COLOUR.warning

    -- Label
    draw_text(x_text, y_text, block_str, COLOUR.text)
    
    -- "Bit position and dimension"
    local draw_format = {
        [0] = {x = 11, y = 15, w = 4, h = 3}, -- Bottom (right)
        [1] = {x =  7, y = 15, w = 4, h = 3}, -- Bottom (middle)
        [2] = {x =  3, y = 15, w = 4, h = 3}, -- Bottom (left)
        [3] = {x =  9, y =  0, w = 6, h = 3}, -- Top (right)
        [4] = {x =  3, y =  0, w = 6, h = 3}, -- Top (left)
        [5] = {x = 15, y =  9, w = 3, h = 6}, -- Right (body)
        [6] = {x = 15, y =  3, w = 3, h = 6}, -- Right (head)
        [7] = {x =  0, y =  9, w = 3, h = 6}, -- Left (body)
        [8] = {x =  0, y =  3, w = 3, h = 6}, -- Left (head)
    }
    
    -- Draw the "Yoshi"
    local x, y, w, h = draw_format[4].x + 1, draw_format[8].y + 1, draw_format[5].x - draw_format[4].x - 2, draw_format[0].y - draw_format[8].y - 2
    draw_rectangle(xoffset + x, yoffset + y, w, h, yoshi_colour, yoshi_colour)
    
    -- Draw the "bits" status
    for b = 0, 8 do
        -- Get "bit position and dimension"
        x = draw_format[b].x
        y = draw_format[b].y
        w = draw_format[b].w
        h = draw_format[b].h
        -- Draw "bit"
        draw_rectangle(xoffset + x, yoffset + y, w, h, COLOUR.text)
        -- Check and draw "bit" if set
        if bit.check(collision_status, b) then
            draw_rectangle(xoffset + x + 1, yoffset + y + 1, w-2, h-2, colour_set)
        end
    end

    -- Fully inside the ground
    if collision_status == 0x1ff then
        local x1, y1, x2, y2 = draw_format[4].x + 1, draw_format[7].y, draw_format[5].x - 1, draw_format[7].y
        draw_line(xoffset + x1, yoffset + y1, xoffset + x2, yoffset + y2, colour_set)
        x1, y1, x2, y2 = draw_format[3].x, draw_format[8].y + 1, draw_format[3].x, draw_format[0].y - 1
        draw_line(xoffset + x1, yoffset + y1, xoffset + x2, yoffset + y2, colour_set)
    end
end

-- Interpret and display egg inventory
local function egg_inventory_info(i)
	
    local delta_x = Game.bizhawk_font_width
    local delta_y = Game.bizhawk_font_height
	local x_pos = 2
	local y_pos = OPTIONS.top_gap + (i+1)*delta_y
	
	local egg_inventory_size = u8_iwram(IWRAM.egg_inventory_size)/2
	local egg_sprite_slot, egg_type, egg_type_str
	
    draw_text(x_pos, y_pos - delta_y, fmt("Egg inventory: %d", egg_inventory_size), COLOUR.text)
	
	for id = 0, egg_inventory_size - 1 do
		egg_sprite_slot = u8_iwram(IWRAM.egg_inventory + 2*id)
		egg_type = u16_iwram(IWRAM.sprite_struct.base + egg_sprite_slot * YI.sprite_struct_size + IWRAM.sprite_struct.id)
		
        local egg_names = { -- indexed by egg_type
            [0x022] = {name = "Flashing Egg", symbol = "F", colour = COLOUR.eggs.pink},
            [0x023] = {name = "Red Egg", symbol = "E", colour = COLOUR.eggs.red},
            [0x024] = {name = "Yellow Egg", symbol = "E", colour = COLOUR.eggs.yellow},
            [0x025] = {name = "Green Egg", symbol = "E", colour = COLOUR.eggs.green},
            [0x026] = {name = "Red Giant Egg (Bowser)", symbol = "G", colour = COLOUR.eggs.red},
            [0x027] = {name = "Key", symbol = "K", colour = COLOUR.eggs.key},
            [0x028] = {name = "Huffin' Puffin", symbol = "H", colour = COLOUR.eggs.huffin},
            [0x029] = {name = "Big Egg (Yoshi while Super Baby Mario)", symbol = "Y", colour = COLOUR.eggs.green},
            [0x02A] = {name = "Red Giant Egg", symbol = "G", colour = COLOUR.eggs.red},
            [0x02B] = {name = "Green Giant Egg", symbol = "G", colour = COLOUR.eggs.green},
        }
        
		if egg_type < 0x022 or egg_type > 0x02B then -- is null egg
            draw_text(x_pos, y_pos + id*delta_y, fmt("%d: NULL <%02X> %03X", id, egg_sprite_slot, egg_type), COLOUR.memory)
		else
            draw_text(x_pos, y_pos + id*delta_y, fmt("%d:   <%02X>", id, egg_sprite_slot), COLOUR.text)
            draw_text(x_pos + 3*delta_x, y_pos + id*delta_y, fmt("%s", egg_names[egg_type].symbol), egg_names[egg_type].colour)
		end
	end
    
    return egg_inventory_size
end

-- Displays player's hitbox
local function player_hitbox(x_screen, y_screen, center_x_screen, center_y_screen, tongue_x_screen, tongue_y_screen, colour)
    -- Hitbox (collision with sprites)
    if OPTIONS.display_player_hitbox then
        local half_width = u16_iwram(IWRAM.yoshi_hitbox_half_width)
        local half_height = u16_iwram(IWRAM.yoshi_hitbox_half_height)
        local hitbox_colour, hitbox_bg = colour, change_transparency(colour, 0.25)
        draw_box(center_x_screen - half_width, center_y_screen - half_height, center_x_screen + half_width - 1, center_y_screen + half_height - 1, hitbox_colour, hitbox_bg)
    end
end

-- Main Yoshi info display function
local function player_info()
	if Is_paused then return end
    
    -- Reads RAM
    local x = Yoshi_x
    local y = Yoshi_y
    local x_sub = u8_iwram(IWRAM.yoshi_x_sub)
    local y_sub = u8_iwram(IWRAM.yoshi_y_sub)
    local direction = u8_iwram(IWRAM.yoshi_direction)
    local x_speed = s8_iwram(IWRAM.yoshi_x_speed)
    local x_speed_full = u16_iwram(IWRAM.yoshi_x_subspeed)
    local x_subspeed = u8_iwram(IWRAM.yoshi_x_subspeed)
    local y_speed = s8_iwram(IWRAM.yoshi_y_speed)
    local y_speed_full = u16_iwram(IWRAM.yoshi_y_subspeed)
    local y_subspeed = u8_iwram(IWRAM.yoshi_y_subspeed)
    local collision_status = u16_iwram(IWRAM.yoshi_collision_status)
    local on_sprite_platform = u16_iwram(IWRAM.yoshi_on_sprite_platform) ~= 0
    local tongue_x = s16_iwram(IWRAM.yoshi_tongue_x)
    local tongue_y = s16_iwram(IWRAM.yoshi_tongue_y)
    local center_x = s16_iwram(IWRAM.yoshi_center_x)
    local center_y = s16_iwram(IWRAM.yoshi_center_y)
    local tongued_slot = u8_iwram(IWRAM.tongued_slot)
    local yoshi_colour_id = u8_iwram(IWRAM.yoshi_colour_id)
	
    -- Transformations
    local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
	local x_display = x < 0 and fmt("-%04X", 0xFFFFFFFF - x + 1) or fmt("%04X", x)
	local y_display = y < 0 and fmt("-%04X", 0xFFFFFFFF - y + 1) or fmt("%04X", y)
    if direction == 0 then direction = "->" else direction = "<-" end
    local x_spd_str = string.insert(signed16hex(x_speed_full, true), ".", 3)
    local y_spd_str = string.insert(signed16hex(y_speed_full, true), ".", 3)
	local tongue_x_display = tongue_x < 0 and fmt("-%04X", 0xFFFFFFFF - tongue_x + 1) or fmt("%04X", tongue_x)
	local tongue_y_display = tongue_y < 0 and fmt("-%04X", 0xFFFFFFFF - tongue_y + 1) or fmt("%04X", tongue_y)
    local center_x_screen, center_y_screen = screen_coordinates(center_x, center_y, Camera_x, Camera_y)
    local tongue_x_screen, tongue_y_screen = screen_coordinates(tongue_x, tongue_y, Camera_x, Camera_y)
    local yoshi_colour = COLOUR.yoshies[yoshi_colour_id][2]
    local yoshi_colour_inv = complementary_colour(yoshi_colour)
    
    -- Info table
    local i = 0
    local delta_x = Game.bizhawk_font_width
    local delta_y = Game.bizhawk_font_height
    local table_x = 2
    local table_y = Game.top_padding
    
    draw_text(table_x, table_y + i*delta_y, fmt("Pos (%s.%02x, %s.%02x) %s", x_display, x_sub, y_display, y_sub, direction))
    i = i + 1
    
	draw_text(table_x, table_y + i*delta_y, fmt("Speed (%s, %s)", x_spd_str, y_spd_str))
    i = i + 1
	
	local can_jump -- tile or sprite
	if bit.check(collision_status, 0) or bit.check(collision_status, 1) or bit.check(collision_status, 2) or on_sprite_platform then
		can_jump = "yes"
		temp_colour = COLOUR.positive
	else
		can_jump = "no"
		temp_colour = COLOUR.warning
	end
	draw_text(table_x, table_y + i*delta_y, fmt("Can jump:"))
	draw_text(table_x + 9*delta_x + 2, table_y + i*delta_y, fmt("%s", can_jump), temp_colour)
	i = i + 1
	
	if OPTIONS.display_collision_status then
		draw_collision_status(table_x, table_y + i*delta_y + 2, collision_status, yoshi_colour)
		i = i + 1.5*Scale
	end
    
    draw_text(table_x, table_y + i*delta_y, fmt("Tongue (%s, %s)", tongue_x_display, tongue_y_display), COLOUR.tongue)
    i = i + 1
    if tongued_slot ~= 0 then
        local tongued_id = u16_iwram(IWRAM.sprite_struct.base + tongued_slot * YI.sprite_struct_size + IWRAM.sprite_struct.id)
        draw_text(table_x, table_y + i*delta_y, fmt("Slot <%02X>, ID %03X", (tongued_slot - 1), tongued_id), COLOUR.tongue)
    else
        draw_text(table_x, table_y + i*delta_y, fmt("Slot <-->, ID ---", (tongued_slot - 1), 0), COLOUR.weak2)
    end
    i = i + 2
    
	-- Egg inventory info
    if OPTIONS.display_egg_info then
		i = i + egg_inventory_info(i) + 2
	end
    
	-- Egg throw info
    if OPTIONS.display_throw_info then
		--egg_throw_info(egg_target_x, egg_target_y, direction, center_x, center_y, x_screen, y_screen)
	end
    
    -- Draw hitbox
    player_hitbox(x_screen, y_screen, center_x_screen, center_y_screen, tongue_x_screen, tongue_y_screen, yoshi_colour_inv)
    
    -- Position on screen
	draw_cross(x_screen, y_screen, 2, yoshi_colour_inv)
    
    -- Center position on screen
	draw_cross(center_x_screen, center_y_screen, 2, yoshi_colour_inv)
    
    -- Tongue position on screen
    draw_cross(tongue_x_screen, tongue_y_screen, 2, complementary_colour(COLOUR.tongue))
    draw_pixel(tongue_x_screen, tongue_y_screen, COLOUR.tongue)
    
    -- Just a y position return so you can conveniently display stuff after player info
    return table_y + i*delta_y
end

-- Display sprite info
local function sprites_info()
	if Is_paused then return end
    
    -- Loop through the sprite slots
    local table_x = 0 -- due anchoring in the top right
    local table_y = OPTIONS.top_gap
    local active_sprites = 0
    for slot = 0x00, YI.sprite_max-1 do
        -- Reads RAM
        local offset = IWRAM.sprite_struct.base + slot * YI.sprite_struct_size
        local x_sub = u8_iwram(offset + IWRAM.sprite_struct.x_sub)
        local x = s16_iwram(offset + IWRAM.sprite_struct.x)
        local y_sub = u8_iwram(offset + IWRAM.sprite_struct.y_sub)
        local y = s16_iwram(offset + IWRAM.sprite_struct.y)
        local x_subspeed = u8_iwram(offset + IWRAM.sprite_struct.x_subspeed)
        local x_speed = s8_iwram(offset + IWRAM.sprite_struct.x_speed)
        local x_speed_full = u16_iwram(offset + IWRAM.sprite_struct.x_subspeed)
        local y_subspeed = u8_iwram(offset + IWRAM.sprite_struct.y_subspeed)
        local y_speed = s8_iwram(offset + IWRAM.sprite_struct.y_speed)
        local y_speed_full = u16_iwram(offset + IWRAM.sprite_struct.y_subspeed)
        local status = u8_iwram(offset + IWRAM.sprite_struct.status)
        local id = u16_iwram(offset + IWRAM.sprite_struct.id)
        local center_x = s16_iwram(offset + IWRAM.sprite_struct.center_x)
        local center_y = s16_iwram(offset + IWRAM.sprite_struct.center_y)
        local hitbox_half_width = u16_iwram(offset + IWRAM.sprite_struct.hitbox_half_width)
        local hitbox_half_height = u16_iwram(offset + IWRAM.sprite_struct.hitbox_half_height)
        
        -- Transformations
        local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
        local x_display = x < 0 and fmt("-%04X.%02x", 0xFFFFFFFF - x + 1, x_sub) or fmt("%04X.%02x", x, x_sub)
        local y_display = y < 0 and fmt("-%04X.%02x", 0xFFFFFFFF - y + 1, y_sub) or fmt("%04X.%02x", y, y_sub)
        local x_spd_str = string.insert(signed16hex(x_speed_full, true), ".", 3)
        local y_spd_str = string.insert(signed16hex(y_speed_full, true), ".", 3)
        local center_x_screen, center_y_screen = screen_coordinates(center_x, center_y, Camera_x, Camera_y)
        
        -- Calculates the correct colour to use, according to slot
        local base_colour = COLOUR.sprites_default[slot%(#COLOUR.sprites_default) + 1]
        local info_colour = change_transparency(change_saturation(base_colour, 0.6), 0.75)
        local colour_background = change_transparency(info_colour, 0.5)
        if status == 0 then info_colour = change_transparency(COLOUR.disabled, 0.5) end
        
        -- Draw the sprite table
        if OPTIONS.display_sprite_table and not OPTIONS.DEBUG then
            local debug_str = "" -- DEBUG
            local sprite_str = fmt("<%02X> %03X %s%s(%s), %s(%s)",
                slot, id, debug_str, x_display, x_spd_str, y_display, y_spd_str)
            draw_text(table_x, table_y + slot*Game.bizhawk_font_height, sprite_str, info_colour, 0, 0, "topright")
        end
        
        -- Proccess only active sprite from now on
        if status ~= 0 then
            -- Display slot near sprite
            draw_text(x_screen + 2, y_screen - 8, fmt("<%02X>", slot), info_colour)
            
            -- If the sprite needs special hitbox, set this to true inside its special analysis code
            local special_hitbox = false
            
            -- Special/Particular analysis
            if OPTIONS.display_sprite_special_info then
            
                -- Eggs, Key and Baby Huffin Puffin
                if id >= 0x022 and id <= 0x02B then
                    -- Read RAM
                    local is_in_egg_inventory = u16_iwram(offset + 0x72) ~= 0x0000 -- unlisted RAM
                    -- Draw hitbox for eggs only if they are not in inventory, to avoid gui clutter
                    if not is_in_egg_inventory then
                        draw_box(center_x_screen - hitbox_half_width, center_y_screen - hitbox_half_height, center_x_screen + hitbox_half_width, center_y_screen + hitbox_half_height, info_colour, colour_background)
                    end
                    -- Disable normal hitbox
                    special_hitbox = true
                
                -- Goal Ring
                elseif id == 0x00D then
                    -- Definitions
                    local activation_line_x = 32
                    local activation_line_y_top = -92
                    local activation_line_y_bottom = -13
                    local tmp_colour = COLOUR.warning
                    
                    -- Timer
                    local timer = u16_iwram(offset + 0x42) -- unlisted RAM
                    draw_text(x_screen + activation_line_x, y_screen + activation_line_y_top - 32, fmt("Timer: %d", timer), info_colour, 0.5)
                    
                    -- Lines and distances
                    if Game_state == YI.game_state_level then
                        
                        -- Activation line (checks Yoshi's center point)
                        draw_line(x_screen + activation_line_x, y_screen + activation_line_y_top, x_screen + activation_line_x, y_screen + activation_line_y_bottom, tmp_colour); tmp_colour = COLOUR.positive
                        draw_line(x_screen + activation_line_x, y_screen + activation_line_y_bottom - 5, x_screen + activation_line_x, y_screen + activation_line_y_bottom, tmp_colour)

                        -- Distance relative to Yoshi's center point
                        local yoshi_center_x_screen, yoshi_center_y_screen = screen_coordinates(Yoshi_center_x, Yoshi_center_y, Camera_x, Camera_y)
                        if Yoshi_center_x <= x + activation_line_x then
                            draw_text(x_screen + activation_line_x - 1, y_screen + activation_line_y_top, fmt("Distance: %02X", x + activation_line_x - Yoshi_center_x), info_colour, 1.0)
                        else
                            draw_text(x_screen + activation_line_x - 1, y_screen + activation_line_y_top, "Distance: --", info_colour, 1.0)
                        end

                        -- Warning to best area of activation
                        if Yoshi_center_y < y + activation_line_y_bottom - 5 then tmp_colour = COLOUR.warning else tmp_colour = COLOUR.positive end
                        draw_line(yoshi_center_x_screen, yoshi_center_y_screen, x_screen + activation_line_x, y_screen + activation_line_y_bottom - 5, tmp_colour)
                        if Yoshi_center_y > y + activation_line_y_bottom then tmp_colour = COLOUR.warning else tmp_colour = COLOUR.positive end
                        draw_line(yoshi_center_x_screen, yoshi_center_y_screen, x_screen + activation_line_x, y_screen + activation_line_y_bottom, tmp_colour)
                    end
                    
                    -- Disable normal hitbox
                    special_hitbox = true
                    
                -- Baby Mario
                elseif id == 0x061 then
                    -- Disable normal hitbox if on Yoshi's back
                    if status == 0x05 then special_hitbox = true end
                --
                elseif id == 0x000 then
                    
                --
                elseif id == 0x000 then
                    
                --
                end
            end
            
            -- Display hitbox
            if OPTIONS.display_sprite_hitbox and not special_hitbox then
                draw_box(center_x_screen - hitbox_half_width, center_y_screen - hitbox_half_height, center_x_screen + hitbox_half_width, center_y_screen + hitbox_half_height, info_colour, colour_background)
            end
            
            -- Display pixel position
            draw_cross(x_screen, y_screen, 2, info_colour)
            draw_pixel(x_screen, y_screen, COLOUR.text)
            draw_cross(center_x_screen, center_y_screen, 2, info_colour)
            draw_pixel(center_x_screen, center_y_screen, COLOUR.text)
            
            -- Count active sprites
            active_sprites = active_sprites + 1
        end
        
        -- DEBUG TABLE
        local debug_str, debug_label_str, debug_start_addr = "", "", 0x3D-- change the initial value to "scroll"
        if OPTIONS.DEBUG then
            for addr = debug_start_addr, YI.sprite_struct_size-1 do
                local value = u8_iwram(offset + addr)
                debug_str = debug_str .. fmt("%02X ", value)
                if slot == 0 then -- could be any, just want to do this once
                    -- Check if address is already documented
                    local documented = false
                    for k, v in pairs(IWRAM.sprite_struct) do
                        if addr == v then documented = true end
                    end
                    --debug_label_str = debug_label_str .. fmt("%02X ", addr)
                    draw_text(2 + 5*Game.bizhawk_font_width + (addr-debug_start_addr)*3*Game.bizhawk_font_width, Game.bottom_padding_start + 20 - Game.bizhawk_font_height, fmt("%02X", addr), documented and 0xff00FF00 or "white")
                end
            end
            --draw_pixel_text(2 + 5*Game.pixel_font_width, Game.bottom_padding_start + 50 - Game.pixel_font_height, debug_label_str, COLOUR.text)
            --draw_pixel_text(2, Game.bottom_padding_start + 50 + slot * Game.pixel_font_height, fmt("<%02X> %s", slot, debug_str), info_colour)
            
            --draw_text(2 + 5*Game.bizhawk_font_width, Game.bottom_padding_start + 20 - Game.bizhawk_font_height, debug_label_str, COLOUR.text)
            draw_text(2, Game.bottom_padding_start + 20 + slot * Game.bizhawk_font_height, fmt("<%02X> %s", slot, debug_str), info_colour)
        end
    end
    
    -- Label
    draw_text(table_x, table_y - 2*Game.bizhawk_font_height, fmt("Sprites: %d/%d", active_sprites, YI.sprite_max), COLOUR.text, 0, 0, "topright")
    
    -- Sprite table header
    draw_text(table_x, table_y - 1*Game.bizhawk_font_height, "slot  id  x_pos   x_spd    y_pos   y_spd ", COLOUR.weak, 0, 0, "topright")
end

-- Display secondary sprite info ("secondary" is a convention for the GBA disassembly, "ambient" is the name conventioned in the SNES disassembly)
local function secondary_sprites_info()
	if Is_paused then return end
    
    -- Loop through the secondary sprite slots
    local table_x = 0 -- due anchoring in the top right
    local table_y = OPTIONS.top_gap + 0x1B*Game.bizhawk_font_height
    local active_secondary_sprites = 0
    for slot = 0x00, YI.secondary_sprite_max-1 do
        -- Reads RAM
        local offset = IWRAM.secondary_sprite_struct.base + slot * YI.secondary_sprite_struct_size
        local status = u8_iwram(offset + IWRAM.secondary_sprite_struct.status)
        -- Check if slot is active
        if status ~= 0x00 then
            -- Continue reading RAM
            local x_sub = u8_iwram(offset + IWRAM.secondary_sprite_struct.x_sub)
            local x = s16_iwram(offset + IWRAM.secondary_sprite_struct.x)
            local y_sub = u8_iwram(offset + IWRAM.secondary_sprite_struct.y_sub)
            local y = s16_iwram(offset + IWRAM.secondary_sprite_struct.y)
            local id = u16_iwram(offset + IWRAM.secondary_sprite_struct.id)
            
            -- Transformations
            local x_screen, y_screen = screen_coordinates(x, y, Camera_x, Camera_y)
            local x_display = x < 0 and fmt("-%04X.%02x", 0xFFFFFFFF - x + 1, x_sub) or fmt("%04X.%02x", x, x_sub)
            local y_display = y < 0 and fmt("-%04X.%02x", 0xFFFFFFFF - y + 1, y_sub) or fmt("%04X.%02x", y, y_sub)
            
            -- Calculates the correct colour to use, according to slot
            local base_colour = COLOUR.sprites_default[slot%(#COLOUR.sprites_default) + 1]
            local info_colour = change_transparency(change_saturation(base_colour, 0.4), 0.75)
            local colour_background = change_transparency(info_colour, 0.5)
            
            -- Draw the secondary sprite table
            if OPTIONS.display_secondary_sprite_table and not OPTIONS.DEBUG then
                local debug_str = "" -- DEBUG
                local secondary_sprite_str = fmt("{%02X} %03X %s%s, %s",
                    slot, id, debug_str, x_display, y_display)
                draw_text(table_x, table_y + active_secondary_sprites*Game.bizhawk_font_height, secondary_sprite_str, info_colour, 0, 0, "topright")
            end
            
            -- Display pixel position
            draw_cross(x_screen, y_screen, 2, info_colour)
            draw_pixel(x_screen, y_screen, COLOUR.text)
            
            -- Prints information next to the exteded sprite
            if OPTIONS.display_secondary_sprite_slot_in_screen then
                draw_text(x_screen + 2, y_screen - 8, fmt("{%02X}", slot), info_colour)
                draw_cross(x_screen, y_screen, 2, info_colour)
            end

            -- Alert of new ambient sprite (for documentation purposes)
            local new_secsprite = true
            for i = 1, #YI.secondary_sprite_ids do
                if id == YI.secondary_sprite_ids[i] then
                    new_secsprite = false
                    break
                end
            end
            if new_secsprite then
                local new_id_str = fmt(" NEW SECONDARY SPRITE ID!!! %3X in {%.2d} ", id, slot)
                draw_text_bg(Game.buffer_middle_x, Game.bottom_padding_start, new_id_str, COLOUR.warning, COLOUR.warning_bg, 0.5, 1.0)
                --print(new_id_str)
                draw_box(x_screen - 4, y_screen - 4, x_screen + 20, y_screen + 20, COLOUR.warning)
            end
            
            -- Count active secondary sprites
            active_secondary_sprites = active_secondary_sprites + 1
        end
    
    end
    
    -- Label
    draw_text(table_x, table_y - 2*Game.bizhawk_font_height, fmt("Secondary sprites: %d/%d", active_secondary_sprites, YI.secondary_sprite_max), COLOUR.text, 0, 0, "topright")
    
    -- Sprite table header
    draw_text(table_x, table_y - 1*Game.bizhawk_font_height, "slot  id  x_pos    y_pos ", COLOUR.weak, 0, 0, "topright")
end

-- Display info about the current level
local function level_info()
    if not OPTIONS.display_level_info then return end
    
    -- Format current level id, sublevel id and game level number and world number
    local world_number = floor(Level_id/12) + 1
    local level_number = fmt("%d", Level_id%12 + 1)
    if level_number == "9" then level_number = "S" -- Secret levels
    elseif level_number == "10" then level_number = "E" end -- Extra levels
    local level_str = fmt("Level:$%02X (%d - %s)", Level_id, world_number, level_number)
    local sublevel_str = fmt("Sublevel:$%02X", Sublevel_id)
    
	-- Get the current screen and format it
	local screen_number, screen_id
	local x_player_simp = 0x100*floor(Yoshi_x/0x100)
	local y_player_simp = 0x100*floor(Yoshi_y/0x100)
	for screen_region_y = 0x0, 0x7 do
		for screen_region_x = 0x0, 0xF do
			if x_player_simp == 0x100*screen_region_x and y_player_simp == 0x100*screen_region_y then -- player current screen
                screen_number = screen_region_y*0x10 + screen_region_x
                screen_id = u8_ewram(EWRAM.screen_number_to_id + screen_number)
				break
			end
		end
	end
    local screen_str = fmt("Screen:$%02X", screen_id and screen_id or 0x80)

    -- Draw whole level info string
    draw_text(Game.buffer_middle_x, Game.screen_height, fmt("%s %s %s", level_str, sublevel_str, screen_str), COLOUR.text, 0.5, 1.0)

    -- Level layout display
    if OPTIONS.display_level_layout then
        local x_base, y_base = OPTIONS.left_gap, Game.bottom_padding_start + 2*Game.bizhawk_font_height
        local x_temp, y_temp
        local screen_exit_table = {}

        draw_text(x_base, y_base - 2*Game.bizhawk_font_height, "Level screen IDs:")		

        for screen_region_y = 0, 7 do
            for screen_region_x = 0, 15 do
                
                -- Screen ID read
                screen_number = screen_region_y*16 + screen_region_x
                screen_id = u8_ewram(EWRAM.screen_number_to_id + screen_number)

                x_temp = x_base + 16*screen_region_x
                y_temp = y_base + 16*screen_region_y

                -- Draw screen grid
                if screen_region_x == 0 then
                    draw_line(x_temp, y_temp, x_temp + 16*16-1, y_temp, COLOUR.very_weak)
                    draw_line(x_temp, y_temp + 15, x_temp + 16*16-1, y_temp + 15, COLOUR.very_weak)
                end
                if screen_region_y == 0 then
                    draw_line(x_temp, y_temp, x_temp, y_temp + 16*8-1, COLOUR.very_weak)
                    draw_line(x_temp + 15, y_temp, x_temp + 15, y_temp + 16*8-1, COLOUR.very_weak)
                end

                -- Read screen exit data...
                local byte_0 = u8_ewram(EWRAM.screen_exit_data + 8*screen_number + 0)
                local byte_1 = u8_ewram(EWRAM.screen_exit_data + 8*screen_number + 1)
                local byte_2 = u8_ewram(EWRAM.screen_exit_data + 8*screen_number + 2)
                local byte_3 = u8_ewram(EWRAM.screen_exit_data + 8*screen_number + 3)
                local has_exit = false
                if byte_0 + byte_1 + byte_2 + byte_3 ~= 0 then -- has an exit
                    -- ...store it..
                    table.insert(screen_exit_table, {screen_id, screen_number, byte_0, byte_1, byte_2, byte_3})
                    -- ...and tell to highlight it
                    has_exit = true
                end

                -- Highlight used screens 
                if x_player_simp == 256*screen_region_x and y_player_simp == 256*screen_region_y then -- player current screen
                    draw_rectangle(x_temp, y_temp, 15, 15, COLOUR.warning2, 0)
                    if has_exit then
                        draw_rectangle(x_temp+1, y_temp+1, 13, 13, COLOUR.memory, 0)
                    end
                elseif has_exit then
                    draw_rectangle(x_temp, y_temp, 15, 15, COLOUR.memory, 0)
                elseif screen_id ~= 0x80 then
                    draw_rectangle(x_temp, y_temp, 15, 15, COLOUR.text, 0)
                end

                -- Highlight used screens IDs
                if screen_id ~= 0x80 then
                    draw_text(x_temp + 8, y_temp + 8, fmt("%02X", screen_id), COLOUR.weak, 0.5, 0.5)
                end

                -- Draw screen "physical" ID labels (screen_number)
                if screen_region_x == 15 then
                    draw_text(x_base - 8, y_temp + 8, fmt("%X0", screen_region_y), COLOUR.weak, 0.5, 0.5)
                end
                if screen_region_y == 7 then
                    draw_text(x_temp + 3, y_base - 9, fmt("%02X", screen_region_x), COLOUR.weak)
                end
            end
        end

        -- Display Yoshi position in the level layout
        local x_player_16, y_player_16 = floor(Yoshi_x/16), floor(Yoshi_y/16)
        local yoshi_colour = COLOUR.yoshies[u8_iwram(IWRAM.yoshi_colour_id)][2]
        draw_cross(x_base + x_player_16, y_base + y_player_16, 2, yoshi_colour)

        -- Screen adjustment to properly see the table
        if OPTIONS.bottom_gap < 160 then
            OPTIONS.bottom_gap = 160 ; 
            client.SetGameExtraPadding(OPTIONS.left_gap, OPTIONS.top_gap, OPTIONS.right_gap, OPTIONS.bottom_gap)
        end

        -- Screen exits
        x_temp, y_temp = 2, y_base + Game.bizhawk_font_height
        draw_text(x_temp, y_temp - Game.bizhawk_font_height, "Screen exits:", COLOUR.text)
        draw_text(x_temp, y_temp, "ID(pos)dest  X   Y", COLOUR.weak)
        for i = 1, #screen_exit_table do
            draw_text(x_temp, y_temp + i*Game.bizhawk_font_height, fmt("%02X(%02X)->%02X (%02X, %02X)",
                screen_exit_table[i][1], screen_exit_table[i][2], screen_exit_table[i][3], screen_exit_table[i][4], screen_exit_table[i][5]))
        end
    end
end

-- Display info about the camera
local function camera_info()
    -- Camera coordinates
    draw_text(Game.buffer_middle_x, OPTIONS.top_gap, fmt("Camera (%04X, %04X)", Camera_x, Camera_y), COLOUR.text, 0.5, 1.0)
end

-- Display timers when they are active
local function timers_info(y_pos)
    if not OPTIONS.display_counters then return end

    -- Font
    local height = Game.bizhawk_font_height
    local timer_counter = 0

    -- Read RAM
    local invincibility_timer = u16_iwram(IWRAM.invincibility_timer)
    local swallow_timer = u16_iwram(IWRAM.swallow_timer)
    local transform_timer = u16_iwram(IWRAM.transform_timer)
    local star_timer = u16_iwram(IWRAM.star_timer)
    local switch_timer = u16_iwram(IWRAM.switch_timer)
    local fuzzy_timer = u16_iwram(IWRAM.fuzzy_timer)
    --local pipe_timer -- TODO
    --local door_timer
    
    -- Display the timers
    if invincibility_timer > 0 then draw_text(2, y_pos + timer_counter*height, fmt("Invincibility: %d", invincibility_timer), COLOUR.invincibility) ; timer_counter = timer_counter + 1 end
    if swallow_timer > 0 then draw_text(2, y_pos + timer_counter*height, fmt("Swallow: %d", swallow_timer), COLOUR.swallow) ; timer_counter = timer_counter + 1 end
    if transform_timer > 0 then draw_text(2, y_pos + timer_counter*height, fmt("Transformation: %d", transform_timer), COLOUR.transform) ; timer_counter = timer_counter + 1 end
    if star_timer > 0 then draw_text(2, y_pos + timer_counter*height, fmt("Super Baby Mario: %d", star_timer), COLOUR.star) ; timer_counter = timer_counter + 1 end
    if switch_timer > 0 then draw_text(2, y_pos + timer_counter*height, fmt("Switch: %d", switch_timer), COLOUR.switch) ; timer_counter = timer_counter + 1 end
    if fuzzy_timer > 0 then draw_text(2, y_pos + timer_counter*height, fmt("Fuzzy: %d", fuzzy_timer), COLOUR.fuzzy) ; timer_counter = timer_counter + 1 end
end

-- Display
local function sprite_level_data()

end

-- Display
local function sprite_spawning_areas()

end

-- Main function to run inside a level
local function level_mode()
    local level_game_states = {0x09, 0x0A, 0x0B, 0x0C, YI.game_state_level, 0x0E, 0x22}
    if not check_game_state_validity(level_game_states) then return end
    
    -- Draw all the kinds of info relevant for a level, order here matter due gui drawings overlapping
    sprite_spawning_areas()
    sprite_level_data()
    secondary_sprites_info()
    camera_info()
    sprites_info()
    level_info()
    local y_pos = player_info()
    timers_info(y_pos)
    
end

-- Main function to run in the overworld
local function overworld_mode()
    local overworld_game_states = {YI.game_state_overworld}
    if not check_game_state_validity(overworld_game_states) then return end
    
end


--##########################################################################################################################################################
-- CHEATS:



--##########################################################################################################################################################
-- MAIN:

-- Create lateral gaps
client.SetGameExtraPadding(OPTIONS.left_gap, OPTIONS.top_gap, OPTIONS.right_gap, OPTIONS.bottom_gap)

-- Main display function, ALL DRAWINGS SHOULD BE CALLED HERE
local function main_display()
    show_general_info()
    level_mode()
    overworld_mode()
    
    -- WORKAROUND to avoid getting permanent graphics, this should be the last drawing call
    draw_pixel(-1, -1, 0)
end

-- Functions to run when script is stopped or reset
event.onexit(function()

    forms.destroyall()

    gui.clearImageCache()

    gui.clearGraphics()

    client.SetGameExtraPadding(0, 0, 0, 0)

    print("Finishing Yoshi's Island script.\n------------------------------------")
end)

-- Script load success message
print("Yoshi's Island GBA Lua script loaded successfully at " .. os.date("%X") .. ".\n") -- %c for date and time

-- Main script loop
while true do
  
    -- Initial values, don't make drawings here
    Biz.get_status()
    Biz.screen_info()
    scan_yi()
    
    -- Drawings
    main_display()
    
    -- Advance the frame
    emu.frameadvance()
  
end

--##########################################################################################################################################################
--[[ TODO LIST:
- Add pipe_timer and door_timer
-
-
]]
