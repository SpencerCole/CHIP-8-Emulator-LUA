require 'cpu'

function love.load()
  local chip8 = CPU:new()
  print("done")
end

function love.keypressed(key, unicode)
  chip8:keydown(key)
end
function love.keyreleased(key, unicode)
  chip8:keyup(key)
end