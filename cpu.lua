
KEY_MAP = {["1"] = 0x1,
           ["2"] = 0x2,
           ["3"] = 0x3,
           ["4"] = 0xc,
           ["q"] = 0x4,
           ["w"] = 0x5,
           ["e"] = 0x6,
           ["r"] = 0xd,
           ["a"] = 0x7,
           ["s"] = 0x8,
           ["d"] = 0x9,
           ["f"] = 0xe,
           ["z"] = 0xa,
           ["x"] = 0,
           ["c"] = 0xb,
           ["v"] = 0xf
          }

 function make_table(len)
	local t = {}
	for i=0, len, 1 do
		t[i] = 0
	end
	return t
end

local CPU = {}
CPU.__index = CPU

function CPU.new()
	local self = setmetatable({}, CPU)
	self.memory = make_table(4096)
	self.gpio = make_table(16)
	self.display_buffer = make_table(32 * 64)
	self.stack = {}
	self.key_inputs = make_table(16)
	self.fonts = {0xF0, 0x90, 0x90, 0x90, 0xF0, -- 0
		          0x20, 0x60, 0x20, 0x20, 0x70, -- 1
		          0xF0, 0x10, 0xF0, 0x80, 0xF0, -- 2
		          0xF0, 0x10, 0xF0, 0x10, 0xF0, -- 3
		          0x90, 0x90, 0xF0, 0x10, 0x10, -- 4
		          0xF0, 0x80, 0xF0, 0x10, 0xF0, -- 5
		          0xF0, 0x80, 0xF0, 0x90, 0xF0, -- 6
		          0xF0, 0x10, 0x20, 0x40, 0x40, -- 7
		          0xF0, 0x90, 0xF0, 0x90, 0xF0, -- 8
		          0xF0, 0x90, 0xF0, 0x10, 0xF0, -- 9
		          0xF0, 0x90, 0xF0, 0x90, 0x90, -- A
		          0xE0, 0x90, 0xE0, 0x90, 0xE0, -- B
		          0xF0, 0x80, 0x80, 0x80, 0xF0, -- C
		          0xE0, 0x90, 0x90, 0x90, 0xE0, -- D
		          0xF0, 0x80, 0xF0, 0x80, 0xF0, -- E
		          0xF0, 0x80, 0xF0, 0x80, 0x80  -- F
		          }
	self.opcode = 0
	self.index = 0
	self.pc = 0

	self.delay_timer = 0
	self.sound_timer = 0

	self.should_draw = false
	self.key_wait = false

	self.pixel = 0 --load pixel
	self.buzz = 0 -- load buzz

	self.funcmap = {[0x0000] = self._0ZZZ,
                    [0x00e0] = self._0ZZ0,
                    [0x00ee] = self._0ZZE,
                    [0x1000] = self._1ZZZ,
                    [0x2000] = self._2ZZZ,
                    [0x3000] = self._3ZZZ,
                    [0x4000] = self._4ZZZ,
                    [0x5000] = self._5ZZZ,
                    [0x6000] = self._6ZZZ,
                    [0x7000] = self._7ZZZ,
                    [0x8000] = self._8ZZZ,
                    [0x8FF0] = self._8ZZ0,
                    [0x8FF1] = self._8ZZ1,
                    [0x8FF2] = self._8ZZ2,
                    [0x8FF3] = self._8ZZ3,
                    [0x8FF4] = self._8ZZ4,
                    [0x8FF5] = self._8ZZ5,
                    [0x8FF6] = self._8ZZ6,
                    [0x8FF7] = self._8ZZ7,
                    [0x8FFE] = self._8ZZE,
                    [0x9000] = self._9ZZZ,
                    [0xA000] = self._AZZZ,
                    [0xB000] = self._BZZZ,
                    [0xC000] = self._CZZZ,
                    [0xD000] = self._DZZZ,
                    [0xE000] = self._EZZZ,
                    [0xE00E] = self._EZZE,
                    [0xE001] = self._EZZ1,
                    [0xF000] = self._FZZZ,
                    [0xF007] = self._FZ07,
                    [0xF00A] = self._FZ0A,
                    [0xF015] = self._FZ15,
                    [0xF018] = self._FZ18,
                    [0xF01E] = self._FZ1E,
                    [0xF029] = self._FZ29,
                    [0xF033] = self._FZ33,
                    [0xF055] = self._FZ55,
                    [0xF065] = self._FZ65
                    }
	self.vx = 0
	self.vy = 0
	return self
end


function CPU:load_rom()
  binary = io.open("some rom", "rb"):read()
  for i=0, #binary, 1 do
    self.memory[i+0x200] = string.byte(binary[i])
  end
end

function CPU:cycle()
  self.opcode = self.memory[self.pc] << 8
  --self.opcode = (self.memory[pc] << 8)
  self.pc = self.pc + 2
  self.vx = (self.memory[self.pc] & 0x0f00) >> 8
  --self.vx = (self.opcode & ) >> 8
  self.vy = (self.memory[self.pc] & 0x00f0) >> 4
  --self.vy = (self.opcode & 0x00f0) >> 4

  extraced_op = self.opcode & 0xf000

  if unexpected_condition then print("Unknown Instruction: %X" % self.opcode)
  self.funcmap[extracted_op]()

  if delay_time > 0 then
    delay_timer = delay_timer - 1

  if sound_timer > 0 then
    sound_time = sound_time - 1
    if sound_timer == 0 then
      print("Play Sound")
      --playsound
end

function CPU:draw()
  if self.should_draw then
    --clear screen
    lin_counter = 0
    i = 0
    for i=0, 2048, 1 do
      if self.display_buffer[i] == 1 then
        -- Draw pixel
        love.graphics.points((i%64)*10, 310 - ((i/64)*10))
        --self.pixel.blit((i%64)*10, 310 - ((i/64)*10))
      end
    end
    --draw
    self.should_draw = false
  end
end

function CPU:keydown(key)
	if KEY_MAP[key] then
	self.key_inputs[KEY_MAP[key]] = 1
	end
end

function CPU:keyup(key)
	if KEY_MAP[key] then
	self.key_inputs[KEY_MAP[key]] = 0
	end
end

function CPU:_0ZZZ()
	extracted_op = self.opcode & 0xf0ff --1111000011111111
	if unexpected_condition then print("Unknown Instruction: %X" % self.opcode)
	self.funcmap[extracted_op]()
end

function CPU:_0ZZ0()
	-- Clears Screen
	self.display_buffer = [0] * 64 * 32
	self.should_draw = true
end

function CPU:_0ZZE()
     -- Returns from subroutine
    self.pc = self.stack.pop()
end

function CPU:_1ZZZ()
	-- Jumps to address NNN
	self.pc = self.opcode & 0x0fff
end

function CPU:_2ZZZ()
	-- Calls subroutine at NNN
	self.stack.append(self.pc)
	self.pc = self.opcode & 0x0fff
end

function CPU:_3ZZZ()
	-- Skips the next instruction if VX equals NN
	if self.gpio[self.vx] == (self.opcode & 0x00ff) then
		self.pc += 2
	end
end

function CPU:_4ZZZ()
	-- Skips the next instruction if VX doesn't equal NN
	if self.gpio[self.vx] ~= (self.opcode & 0x00ff) then
		self.pc += 2
	end
end

function CPU:_5ZZZ()
    -- Skips the next instruction if VX equals VY
    if self.gpio[self.vx] == self.gpio[self.vy] then
      self.pc += 2
    end

function CPU:_6ZZZ()
    -- Sets VX to NN.
    self.gpio[self.vx] = self.opcode & 0x00ff
end

function CPU:_7ZZZ()
    -- Adds NN to VX.
    self.gpio[self.vx] = self.gpio[self.vx] + (self.opcode & 0xff)
end

function CPU:_8ZZZ()
    extracted_op = self.opcode & 0xf00f
    extracted_op = extracted_op + 0xff0
    if unexpected_condition then print("Unknown Instruction: %X" % self.opcode)
    self.funcmap[extracted_op]()
end

function CPU:_8ZZ0()
    -- Sets VX to the value of VY.
    self.gpio[self.vx] = self.gpio[self.vy]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZ1()
    -- Sets VX to VX or VY.
    self.gpio[self.vx] = self.gpio[self.vx] | self.gpio[self.vy]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZ2()
    -- Sets VX to VX and VY.
    self.gpio[self.vx] = self.gpio[self.vx] & self.gpio[self.vy]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZ3()
    -- Sets VX to VX xor VY.
    self.gpio[self.vx] = self.gpio[self.vx] ^ self.gpio[self.vy]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZ4()
    -- Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
    if self.gpio[self.vx] + self.gpio[self.vy] > 0xff then
      self.gpio[0xf] = 1
    else
      self.gpio[0xf] = 0
    end
    self.gpio[self.vx] = self.gpio[self.vx] + self.gpio[self.vy]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZ5()
    -- VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't
    if self.gpio[self.vy] > self.gpio[self.vx] then
      self.gpio[0xf] = 0
    else
      self.gpio[0xf] = 1
    end
    self.gpio[self.vx] = self.gpio[self.vx] - self.gpio[self.vy]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZ6()
    -- Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.
    self.gpio[0xf] = self.gpio[self.vx] & 0x0001
    self.gpio[self.vx] = self.gpio[self.vx] >> 1
end

function CPU:_8ZZ7()
    -- Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
    if self.gpio[self.vx] > self.gpio[self.vy] then
      self.gpio[0xf] = 0
    else
      self.gpio[0xf] = 1
    end
    self.gpio[self.vx] = self.gpio[self.vy] - self.gpio[self.vx]
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_8ZZE()
    -- Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.
    self.gpio[0xf] = (self.gpio[self.vx] & 0x00f0) >> 7
    self.gpio[self.vx] = self.gpio[self.vx] << 1
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff
end

function CPU:_9ZZZ()
    -- Skips the next instruction if VX doesn't equal VY.
    if self.gpio[self.vx] ~= self.gpio[self.vy] then
      self.pc = self.pc + 2
    end
end

function CPU:_AZZZ()
    -- Sets I to the address NNN.
    self.index = self.opcode & 0x0fff
end

function CPU:_BZZZ()
    -- Jumps to the address NNN plus V0.
    self.pc = (self.opcode & 0x0fff) + self.gpio[0]
end

function CPU:_CZZZ()
    -- Sets VX to a random number and NN.
    r = tonumber(math.random() * 0xff)
    self.gpio[self.vx] = r & (self.opcode & 0x00ff)
    self.gpio[self.vx] = self.gpio[self.vx] & 0xff

function _DZZZ()
    -- Draw a sprite
    -- Draws a sprite at coordinate (VX, VY) that has a width of 8 pixels
    -- and a height of N pixels. Each row of 8 pixels is read as bit-coded
    -- (with the most significant bit of each byte displayed on the left)
    -- starting from memory location I; I value doesn't change after the
    -- execution of this instruction. As described above, VF is set to 1
    -- if any screen pixels are flipped from set to unset when the sprite
    -- is drawn, and to 0 if that doesn't happen.
    self.gpio[0xf] = 0
    x = self.gpio[self.vx] & 0xff
    y = self.gpio[self.vy] & 0xff
    height = self.opcode & 0x000f
    row = 0
    while row < height do
    	curr_row = self.memory[row + self.index]
    	pixel_offset = 0
    	while pixel_offset < 8 do
	    	loc = x + pixel_offset + ((y + row) * 64)
	        pixel_offset = pixel_offset + 1
	        if (y + row) >= 32 or (x + pixel_offset - 1) >= 64 then
	          -- ignore pixels outside the screen
	          goto continue
	        end
	        mask = 1 << 8-pixel_offset
	        curr_pixel = (curr_row & mask) >> (8-pixel_offset)
	        self.display_buffer[loc] = self.display_buffer[loc] ^ curr_pixel
	        if self.display_buffer[loc] == 0 end
	          self.gpio[0xf] = 1
	        else
	          self.gpio[0xf] = 0
	        end
	        ::continue::
    	end
    	row += 1
    end
    self.should_draw = true

function _EZZZ()
    extracted_op = self.opcode & 0xf00f
    if unexpected_condition then print("Unknown Instruction: %X" % self.opcode)
    self.funcmap[extracted_op]()
end

function _EZZE()
    -- Skips the next instruction if the key stored in VX is pressed.
    key = self.gpio[self.vx] & 0xf
    if self.key_inputs[key] == 1 then
      self.pc = self.pc + 2
    end
end

function _EZZ1()
    -- Skips the next instruction if the key stored in VX isn't pressed.
    key = self.gpio[self.vx] & 0xf
    if self.key_inputs[key] == 0 then
      self.pc = self.pc + 2
    end
end

function _FZZZ()
    extracted_op = self.opcode & 0xf0ff
    if unexpected_condition then print("Unknown Instruction: %X" % self.opcode)
    self.funcmap[extracted_op]()
end

function _FZ07()
    -- Sets VX to the value of the delay timer.
    self.gpio[self.vx] = self.delay_timer
end

function _FZ0A()
    -- A key press is awaited, and then stored in VX.
    ret = self.get_key()
    if ret >= 0 then
      self.gpio[self.vx] = ret
    else
      self.pc = self.pc - 2
    end

function _FZ15()
    -- Sets the delay timer to VX.
    self.delay_timer = self.gpio[self.vx]
end

function _FZ18()
    -- Sets the sound timer to VX.
    self.sound_timer = self.gpio[self.vx]
end

function _FZ1E()
    -- Adds VX to I. if overflow, vf = 1
    self.index = self.index + self.gpio[self.vx]
    if self.index > 0xfff then
      self.gpio[0xf] = 1
      self.index = self.index & 0xfff
    else
      self.gpio[0xf] = 0
    end

function _FZ29()
    -- Set index to point to a character
    -- Sets I to the location of the sprite for the character in VX.
    -- Characters 0-F (in hexadecimal) are represented by a 4x5 font.
    self.index = (5*(self.gpio[self.vx])) & 0xfff
end

function _FZ33()
    -- Store a number as BCD
    -- Stores the Binary-coded decimal representation of VX, with the
    -- most significant of three digits at the address in I, the middle
    -- digit at I plus 1, and the least significant digit at I plus 2.
    self.memory[self.index]   = self.gpio[self.vx] / 100
    self.memory[self.index+1] = (self.gpio[self.vx] % 100) / 10
    self.memory[self.index+2] = self.gpio[self.vx] % 10
end

function _FZ55()
    -- Stores V0 to VX in memory starting at address I.
    i = 0
    while i <= self.vx do
      self.memory[self.index + i] = self.gpio[i]
      i = i + 1
    end
    self.index = self.index + (self.vx) + 1

function _FZ65()
    -- Fills V0 to VX with values from memory starting at address I.
    i = 0
    while i <= self.vx do
      self.gpio[i] = self.memory[self.index + i]
      i = i + 1
    end
    self.index = self.index + (self.vx) + 1
end
-- end instructions