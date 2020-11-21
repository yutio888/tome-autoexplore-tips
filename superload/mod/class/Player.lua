local _M = loadPrevious(...)

local Emote = require("engine.Emote")

local possible_emote = {
    [1] = {
        [1] = _t"Help, I've found:"
    },
    [2] = {
        [1] = _t"By all that is holy! Do you see that enemy over there:",
        [2] = _t"There! A worthy foe:"
    },
    [3] = {
        [1] = _t"I used to be an adventurer like you, then I met a monster like this:"
    },
    [4] = {
        [1] = _t"Merciless monster:",
        [2] = _t"Unexpected foe:"
    },
    [5] = {
        [1] = _t"Just this:",
        [2] = _t"Unbelievable, you do think monsters like this might beat me:",
        [3] = _t"Are you telling me how to fight？",
    }
}

local function getEmoteMsgs()
    local shoutType = config.settings.tome.addon_detailed_stop_reason_allow_shout
    if not shoutType or shoutType == 0 then
        return ""
    end
    if not (type(shoutType) =="number") or shoutType > 5 or shoutType < 1 then
        shoutType = rng.range(1, 5)
    end
    print("TEST", shoutType)
    local msgs = possible_emote[shoutType]
    local random = rng.range(1, #msgs)
    print("TEST", random)
    print("TEST", msgs[random])
    return msgs[random]
end

local function hostileCheck(self)
    local spotted = self:spotHostiles()
    local biggest_monster = ""
    local biggest_rank = -1
    if #spotted > 0 then
        local emote_msgs = getEmoteMsgs()
        local monster = 0
        local log_msgs = {}
        for _, spot in ipairs(spotted) do
            if spot.actor and spot.actor.rank then
                if spot.entity then
                    spot.entity:addParticles(engine.Particles.new("notice_enemy", 1))
                end
                local _, rank_color = spot.actor:TextRank()
                local information = nil
                if spot.actor.descriptor and spot.actor.descriptor.classes then
                    information = table.concat(table.ts(spot.actor.descriptor.classes or {}, "birth descriptor name"),",")
                end
                if spot.actor.level > self.level * 1.5 then
                    if information then
                        information = "LV"..spot.actor.level.." "..(information or "")
                    else
                        information = "LV"..spot.actor.level
                    end
                end
                local spotmsg
                if not information then
                    spotmsg =  rank_color .. spot.actor:getName():capitalize()  .. "#LAST#"
                else
                    spotmsg =  rank_color .. spot.actor:getName():capitalize() .. "("..information..")" .. "#LAST#"
                end
                local emotemsg = spotmsg
                if spot.actor.getDisplayString then
                    spotmsg = spot.actor:getDisplayString() .. spotmsg
                end
                if spot.actor.rank > biggest_rank then
                    biggest_rank = spot.actor.rank
                    biggest_monster = spotmsg
                end
                if information then
                    if (monster > 0) then
                        emote_msgs = emote_msgs .. ", "
                    end
                    monster = monster + 1
                    table.insert(log_msgs, spotmsg)
                    emote_msgs = emote_msgs .. emotemsg
                end
            end
        end
        if #log_msgs > 0 then
            for _, msg in ipairs(log_msgs) do
                game.logSeen(self, _t"You have found: "..msg)
            end
        end
        if monster > 0 and config.settings.tome.addon_detailed_stop_reason_allow_shout and not (config.settings.tome.addon_detailed_stop_reason_allow_shout == 0) then
            self:setEmote(Emote.new(emote_msgs, 40, colors.WHITE, nil, {r=0.2, g=0.2, b=0.2}))
        end
        local dir = game.level.map:compassDirection(spotted[1].x - self.x, spotted[1].y - self.y)
        if biggest_rank == -1 then
            biggest_monster = spotted[1].name .. (game.level.map:isOnScreen(spotted[1].x, spotted[1].y) and "" or _t" - offscreen")
        end
		return false, ("hostile spotted to the %s %s"):tformat(dir or "???", biggest_monster)
    end
    return true
end
local _runStopped = _M.runStopped
function _M:runStopped()
    hostileCheck(self)
    _runStopped(self)
end
local _onRestStop = _M.onRestStop
function _M:onRestStop()
    hostileCheck(self)
    _onRestStop(self)
end

--[[
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
]]
return _M
