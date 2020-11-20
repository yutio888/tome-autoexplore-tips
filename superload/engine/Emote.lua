local _M = loadPrevious(...)

local _init = _M.init
local frame_ox1 = -15
local frame_ox2 = 15
local frame_oy1 = -15
local frame_oy2 = 15
function _M:init(text, dur, color, font, background)
    self.background = background
    _init(self, text, dur, color, font)
end

function _M:display(x, y)
	local a = 1
	if self.dur < 10 then
		a = (self.dur) / 10
	end
    if not self.background or not self.background.r or not self.background.g or not self.background.b then
	    self:drawFrame(self.frame, x, y, 1, 1, 1, a * 0.7)
	else
	    self:drawFrame(self.frame, x, y, self.background.r, self.background.g, self.background.b, a * 0.7)
	end
	self.tex[1]:toScreenFull(x-frame_ox1, y-frame_oy1, self.rw, self.rh, self.tex[2], self.tex[3], 1, 1, 1, a)
end
return _M