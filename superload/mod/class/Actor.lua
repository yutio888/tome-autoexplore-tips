local _M = loadPrevious(...)
local _bigTacticalFrame = _M.bigTacticalFrame
function _M:bigTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
    if not config.settings.tome.addon_detailed_stop_reason_big_frame then
        _bigTacticalFrame(x, y, w, h, zoom, on_map, tlx, tly)
        return
    end
    -- Tactical info
	if game.level and game.always_target then
		if on_map then
			if config.settings.tome.small_frame_side then
				local dw = w * 0.1
				local lp = math.max(0, self.life) / self.max_life + 0.0001
				if lp > .75 then -- green
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 129, 180, 57, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 50, 220, 77, 255)
				elseif lp > .5 then -- yellow
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 175, 175, 10, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 240, 252, 35, 255)
				elseif lp > .25 then -- orange
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 185, 88, 0, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 255, 156, 21, 255)
				else -- red
					core.display.drawQuad(x + 3, y + 3, dw, h - 6, 167, 55, 39, 128)
					core.display.drawQuad(x + 3, y + 3 + (h - 6) * (1 - lp), dw, (h - 6) * lp, 235, 0, 0, 255)
				end
			else
				local dh = h * 0.1
				local lp = math.max(0, self.life) / self.max_life + 0.0001
				if lp > .75 then -- green
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 129, 180, 57, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 50, 220, 77, 255)
				elseif lp > .5 then -- yellow
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 175, 175, 10, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 240, 252, 35, 255)
				elseif lp > .25 then -- orange
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 185, 88, 0, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 255, 156, 21, 255)
				else -- red
					core.display.drawQuad(x + 3, y + h - dh, w - 6, dh, 167, 55, 39, 128)
					core.display.drawQuad(x + 3, y + h - dh, (w - 6) * lp, dh, 235, 0, 0, 255)
				end
			end
		end
	end

	---------------------------------------------------------
	if not self.f_timeZoom then self.f_timeZoom=0 end
	self.f_timeZoom=self.f_timeZoom+0.3
	if self.f_timeZoom > 5 then self.f_timeZoom=self.f_timeZoom-10 end
	local f_t = math.abs(self.f_timeZoom )
	-- Tactical info
	if game.level and game.level.map.view_faction then
		local map = game.level.map
		if on_map then
			if not f_self then
				f_self = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_self)
				f_powerful = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_powerful)
				f_danger2 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_danger2)
				f_danger1 = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_danger1)
				f_friend = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_friend)
				f_enemy = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_enemy)
				f_neutral = game.level.map.tilesTactic:get(nil, 0,0,0, 0,0,0, map.faction_neutral)
			end

			if self.faction then
				local friend
				if not map.actor_player then friend = Faction:factionReaction(map.view_faction, self.faction)
				else friend = map.actor_player:reactionToward(self) end

				if self == map.actor_player then
					--让边框动起来
					f_self:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
				elseif map:faction_danger_check(self) then
					if friend >= 0 then f_powerful:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
					else
					--危险的敌人扩大点
						if map:faction_danger_check(self, true) then
							f_danger2:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
						else
							f_danger1:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
						end
					end
				elseif friend > 0 then
					f_friend:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
				elseif friend < 0 then
					f_enemy:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
				else
					f_neutral:toScreen(x-f_t, y-f_t, w+f_t*2, h+f_t*2)
				end
			end
		end
	end
end
return _M