function love.load()
   dice_norep = {}      -- old test case for sequence that is random, but unique, not used

   gameFont = love.graphics.newFont(20)     -- for displaying text
   -- These set the starting location for the graphics
   -- Everything is based on these starting locations
   -- Also, the order of the entries is important as they
   -- build off each other.  
   -- Future - redesign so this is more flexible
   xstart = 50
   ystart = 100
   sep_pix = 10
    -- Check box sprites dimensions and location
   check_width = 72
   check_height = 63
   check_x = xstart
   check_y = ystart
   check_sprite = love.graphics.newImage('images/check72.png')
    -- Dice sprite dimensions and locations
   dice_width = 72
   dice_height = 72
   dice_x = xstart
   dice_y = check_y + check_height + sep_pix
   dice_box_width = 6 * dice_width
   dice_box_height = dice_height

   dice_sprites = {}
   dice_sprites[1] = love.graphics.newImage('images/one.png')
   dice_sprites[2] = love.graphics.newImage('images/two.png')
   dice_sprites[3] = love.graphics.newImage('images/three.png')
   dice_sprites[4] = love.graphics.newImage('images/four.png')
   dice_sprites[5] = love.graphics.newImage('images/five.png')
   dice_sprites[6] = love.graphics.newImage('images/six.png')
    -- buttons, new and roll
    new_sprite = love.graphics.newImage('images/new.png')
    new_x = xstart
    new_y = dice_y + dice_height + sep_pix
    new_x_width = 144
    new_y_height = 72
    new_box_x = new_x + new_x_width
    new_box_y = new_y + new_y_height

    roll_sprite = love.graphics.newImage('images/roll.png')
    roll_x = xstart
    roll_y = new_y
    roll_x_width = 144
    roll_y_height = 72
    roll_box_x = roll_x + roll_x_width
    roll_box_y = roll_y + roll_y_height
    -- Position of text
    text_x = xstart
    text_y = new_y + roll_y_height + sep_pix

    -- state variables, decrement as game progresses
    -- state 4 is ready to roll and first roll
    -- state 3, 2 are second and third rolls
    -- state 1 is game over
    dice_num_sel = 0    -- which dice is selected on mouse click
    roll_state = 4  -- 4, 3,2,1 number of rolls
    dice_saved = {} -- dice saved selected by mouse click
    -- initialize all dice to not saved
    for i = 1,6 do
        dice_saved[i] = false
    end
    dice_six = {}   -- holds the  random roll
    dice_current = {}  -- holds the current set of dice filtered by saved dice
    dice_update = false  -- need to roll again
    new_game = true     -- start a new game
end

function love.update(dt)
    -- state new game, initialize saved, reset new game
    -- ready to roll
    if new_game then
        for i = 1,6 do
            dice_saved[i] = false
        end
        new_game = false
        dice_update = false
        roll_state = 4
    -- roll has been requested via dice_update flag
    elseif dice_update then
        get_six()
        dice_update = false     -- end update till next request
        roll_state = roll_state - 1 -- reduce rolls
        -- only update dice that are not saved
        for i = 1,6 do
            if not dice_saved[i] then
                dice_current[i] = dice_six[i]
            end
        end
    end
end

function love.draw()
    love.graphics.setFont(gameFont)
    -- some dibugging stuff --
    --love.graphics.print(dice_six, 10, 10)
    --love.graphics.print(dice_num_sel, 100, 10)
    --love.graphics.print(roll_state, 120, 10)
    if roll_state == 4 then -- new game state, only roll button displayed
        love.graphics.draw(roll_sprite, roll_x, roll_y)
        love.graphics.print('Roll your first turn', text_x, text_y )
    else
        -- draw dice for states 3, 2, 1  
        dx = dice_x
        dy = dice_y
        for i = 1,6 do
            love.graphics.draw(dice_sprites[dice_current[i]], dx, dy)
            dx = dx + dice_width
        end
        -- draw checks for states 3-2 and roll sprite
        if (roll_state == 3) or (roll_state == 2) then
            if roll_state == 3 then
                love.graphics.print('Roll second turn, select dice to save', text_x, text_y )
            elseif roll_state == 2 then
                love.graphics.print('Roll last turn, select dice to save', text_x, text_y )
            end
            dx = check_x
            dy = check_y
            -- display checked sprite for those dice that have been checked
            for i = 1,6 do
                if dice_saved[i] then
                    love.graphics.draw(check_sprite, dx, dy)
                end
                dx = dx + dice_width  -- align with dice (assumes dice are slightly wider than check)
            end
            love.graphics.draw(roll_sprite, roll_x, roll_y) -- draw roll button
        -- if roll state is one, game over. Only dice and new game are displayed
        elseif roll_state == 1 then
            love.graphics.draw(new_sprite, new_x, new_y)    -- new game
            love.graphics.print('Your turn is over', text_x, text_y )
        end
    end
end

-- This was a learning excercise for "ipairs".
-- Generates a all dice values in random order.
-- (not used in game)
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- Gets a new raondom set of 6 dice
-- repeats are allowed
function get_six()
    for i = 1,6 do
        new_dice = love.math.random(1,6)
        dice_six[i] = new_dice
    end
end

-- test of random function to get a unique set of dice (not used in game)
function get_no_repeat()
    got_all = false
    dice_index = 1
    while got_all == false do
        new_dice = love.math.random(1,6)
        if has_value(dice_norep, new_dice) == false then
            dice_norep[dice_index] = new_dice
            dice_index = dice_index + 1
            if dice_index == 7 then
                got_all = true
            end
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    -- left button pressed
    -- check for area that mouse click happened
    -- choices are dice, new button, roll button areas
    -- while in this design, roll and new are in the same location
    -- clicking on them is dependent on state and changes action
    if button == 1 then
        if isin_dice_area(x, y, button) and ((roll_state == 3) or (roll_state == 2)) then
            -- toggle checkmark here
            dice_num_sel = dice_selected(x, y, button)
            if dice_saved[dice_num_sel] == true then    -- implement a toggle
                dice_saved[dice_num_sel] = false
            else
                dice_saved[dice_num_sel] = true 
            end
        elseif isin_new_area(x, y, button) and (roll_state == 1) then
            new_game = true
        elseif isin_roll_area(x,y,button) and ((roll_state == 4) or (roll_state == 3) or (roll_state == 2)) then
            dice_update = true
        end
    end
end

-- set of functions to check where mouse selection happened
-- Future could generalize this to a function:
-- f(x, y, button, xbox_origin, ybox_origin, xbox_width, ybox_width)
function isin_dice_area(x, y, button)
    inarea = false
    if (x > dice_x) and (x < (dice_x + dice_box_width)) and 
        (y > dice_y) and (y < (dice_y + dice_box_height)) then
        inarea = true
    end
    return inarea
end

function isin_roll_area(x, y, button)
    inarea = false
    if (x > roll_x) and (x < (roll_x + roll_x_width)) and 
        (y > roll_y) and (y < (roll_y + roll_y_height)) then
        inarea = true
    end
    return inarea
end

function isin_new_area(x, y, button)
    inarea = false
    if (x > new_x) and (x < (new_x + new_x_width)) and 
        (y > new_y) and (y < (new_y + new_y_height)) then
        inarea = true
    end
    return inarea
end

function dice_selected(x, y, button)
    dice_xupperleft = dice_x    -- x origin will increment by dice_width
    dice_yupperleft = dice_y    -- the y origin for the dice does not change
    dice_num_sel = 0  -- not found if 0
    for i = 1,6 do
        if (x > dice_xupperleft) and (x < (dice_xupperleft + dice_width)) and 
        (y > dice_yupperleft) and (y < (dice_yupperleft + dice_height)) then
            dice_num_sel = i    -- found
        end
        -- move over to the next dice
        dice_xupperleft = dice_xupperleft + dice_width
    end
    return dice_num_sel 
end

