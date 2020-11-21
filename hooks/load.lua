local class = require"engine.class"
local Dialog = require"engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local function getShoutTypeString(type)
    if type == 0 or not type then
        return _t"Disabled"
    elseif type == 1 then
        return _t"Default"
    elseif type == 2 then
        return _t"Kormac"
    elseif type == 3 then
        return _t"Adventurer"
    elseif type == 4 then
        return _t"Elder"
    elseif type == 5 then
        return _t"Ambiguous"
    else
        return _t"Random"
    end
end


local function hook(self, data)
    if data.kind == "misc" then
	    local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Shout when you found dangerous foes.#WHITE#"):toTString()}

	    data.list[#data.list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Shout in danger#WHITE##{normal}#"):toTString(),
	        status=function(item)
			    return getShoutTypeString(config.settings.tome.addon_detailed_stop_reason_allow_shout)
            end,
            fct=function(item)
       		    Dialog:listPopup(_t"#GOLD##{bold}#Shout in danger#WHITE##{normal}#", _t"Select shout mode", {
       		                    {name=_t"Disabled", mode=0},
                				{name=_t"Random", mode=-1},
                				{name=_t"Default", mode=1},
                				{name=_t"Kormac", mode=2},
                				{name=_t"Adventurer", mode=3},
                				{name=_t"Elder", mode=4},
                				{name=_t"Ambiguous", mode=5},
                			}, 300, 300, function(sel)
                				if not sel then return end
                				config.settings.tome.addon_detailed_stop_reason_allow_shout = sel.mode
                                game:saveSettings("tome.addon_detailed_stop_reason_allow_shout", ([[
                                tome.addon_detailed_stop_reason_allow_shout = %s
                                ]]):format(sel.mode))
                				self.c_list:drawItem(item)
                			end)
		    end,}

		local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Makes the tactical frame shake#WHITE#"):toTString()}
        	    data.list[#data.list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Shaking Tactical Frame#WHITE##{normal}#"):toTString(), status=function(item)
        			return tostring(config.settings.tome.addon_detailed_stop_reason_big_frame and _t"enabled" or _t"disabled")
                end, fct=function(item)
               		config.settings.tome.addon_detailed_stop_reason_big_frame = not config.settings.tome.addon_detailed_stop_reason_big_frame
                    game:saveSettings("tome.addon_detailed_stop_reason_big_frame", ("tome.addon_detailed_stop_reason_big_frame = %s\n"):format(tostring(config.settings.tome.addon_detailed_stop_reason_big_frame)))
               		self.c_list:drawItem(item)
        		end,}
	end
end
class:bindHook("GameOptions:generateList", hook)