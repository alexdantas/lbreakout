
require 'src.class'

Block = class()

function Block:init(x, y, width, height)
   x = x or 0
   y = y or 0
   width = width or 58
   height = height or 20

   self.x = x
   self.y = y
   self.width = width
   self.height = height
end

function Block:draw()
   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end


BlockContainer = class()

function BlockContainer:init(x, y, block_width, block_height)

   self.x = x
   self.y = y

   -- these are merely flags to tell which blocks will exist
   -- and which are not
   self.width  = 10
   self.height = 5
   self.container = {
      {0, 1, 1, 1, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 1, 0},
      {0, 1, 1, 1, 1, 1, 1, 1, 1, 0}
   }
   local bw      = block_width
   local bh      = block_height
   local ammount = 0

   for line = 1, self.height do
      for block = 1, self.width do -- width

         if self.container[line][block] == 1 then
            self.container[line][block] = Block(self.x + (block - 1) * bw,
                                                self.y + (line - 1) * bh + 2 * line,
                                                bw, bh)
         else
            self.container[line][block] = nil
         end

         if block > 1 and self.container[line][block] then
            self.container[line][block].x = self.container[line][block].x + 2 * (block - 1)
         end

         ammount = ammount + 1
      end
   end

   self.blocks_inside = ammount
end

function BlockContainer:draw()

   for line = 1, self.height do
      for block = 1, self.width do -- width

         if self.container[line][block] then
            self.container[line][block]:draw()
         end

      end
   end
end

function BlockContainer:destroy_block(x, y)
   if self.container[x][y] then
      self.container[x][y] = nil
      self.blocks_inside = self.blocks_inside - 1
   end
end

function BlockContainer:is_empty()
   if self.blocks_inside <= 0 then
      return true
   else
      return false
   end
end

-- function BlockContainer:each_destroy_if(func)
--    for i = 1, self.height do
--       for j = 1, self.width do
--          if self.container[i][j] then
--             if func(self.container[i][j]) then
--                self:destroy_block(i, j)
--             end
--          end
--       end
--    end
-- end


