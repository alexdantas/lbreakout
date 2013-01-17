-- lbreakout - a simple breakout game in lua with love
require 'src.ball'
require 'src.pad'
require 'src.block'

-- actual screen size (default: 600x500)
screen_width  = love.graphics.getWidth()
screen_height = love.graphics.getHeight()
-- but the game objects only act on this
min_play_x = 0
min_play_y = 0
max_play_x = screen_width
max_play_y = screen_height

function love.load()
   ball   = Ball(max_play_x / 2, max_play_y / 2)
   player = Pad(max_play_x / 2, max_play_y - 50)
   blocks = BlockContainer(1, 30, 58, 20)
end

function love.update(dt)
   ball:move(dt)
   player:move(dt)
   ball:bounce_if_collided_with(player)
   for i = 1, blocks.height do
      for j = 1, blocks.width do
         if blocks.container[i][j] then
            if ball:bounce_if_collided_with(blocks.container[i][j]) then
               blocks:destroy_block(i, j)
            end
         end
      end
   end
--   blocks:each_destroy_if(ball:bounce_if_collided_with)
   ball:bounce_if_out_of_bounds()
   if ball.is_dead then quit_game() end
end

function love.draw()
   ball:draw()
   player:draw()
   blocks:draw()
end

function love.keypressed(key, unicode)
   if key == "q" then
      quit_game()
   elseif key == "right" or key == "d" then
      player.direction.right = true
   elseif key == "left"  or key == "a" then
      player.direction.left = true

   -- Test keys for debugging purposes
   elseif key == "1" then
      ball:accelerate(false)
   elseif key == "2" then
      ball:accelerate(true, 100)
   elseif key == "3" then
      ball:reset_speed()
   end
end

function love.keyreleased(key, unicode)
   if     key == "right" or key == "d" then
      player.direction.right = false
   elseif key == "left"  or key == "a" then
      player.direction.left = false
   end
end

-- This works around an issue on quitting between love versions.
function quit_game()
   local f = love.event.quit or love.event.push
   f('q')
end

