local _M = loadPrevious(...)

local function hostileCheck(self)
    local spotted = self:spotHostiles()
    local biggest_monster = ""
    local biggest_rank = -1
    if #spotted > 0 then
        local msg = _t"You have found hostile targets: "
            local monster = 0
            for _, spot in ipairs(spotted) do
                if spot.entity then
                    spot.entity:addParticles(engine.Particles.new("notice_enemy", 1))
                end
                if spot.actor and spot.actor.rank then
                    local spotmsg 
                    if spot.actor.getDisplayString then
                        spotmsg = spot.actor:getDisplayString() .. spot.actor.name
                    else
                        spotmsg = spot.actor.name
                    end
                    local _, rank_color = spot.actor:TextRank()
                    if spot.actor.descriptor and spot.actor.descriptor.classes then
                        spotmsg = spotmsg .. "(" .. table.concat(table.ts(spot.actor.descriptor.classes or {}, "birth descriptor name"),",") .. ")"
                    end
                    local offScreen = game.level.map:isOnScreen(spotted[1].x, spotted[1].y) and "" or _t" - offscreen"
                    spotmsg = rank_color .. spotmsg .. offScreen .. "#LAST#"
                    if spot.actor.rank > biggest_rank then
                        biggest_rank = spot.actor.rank
                        biggest_monster = spotmsg
                    end
                    if spot.actor.rank >= 3 then
                        if (monster > 0) then
                            msg = msg .. ", "
                        end
                        monster = monster + 1
                        msg = msg .. spotmsg
                    end
                end
            end
            if monster > 0 then
                game.logSeen(self, msg:toString())
            end
            local dir = game.level.map:compassDirection(spotted[1].x - self.x, spotted[1].y - self.y)
            if biggest_rank == -1 then
                biggest_monster = spotted[1].name .. (game.level.map:isOnScreen(spotted[1].x, spotted[1].y) and "" or _t" - offscreen")
            end
		    return false, ("hostile spotted to the %s %s"):tformat(dir or "???", biggest_monster)
        end
    return true
end

local _runCheck = _M.runCheck
function _M:runCheck(ignore_memory)
    local res, tips = hostileCheck(self)
    if not res then return res, tips end
    return _runCheck(self, ignore_memory)
end
local _restCheck = _M.restCheck
function _M:restCheck()
    local res, tips = hostileCheck(self)
    if not res then return res, tips end
    return _restCheck(self)
end

return _M
