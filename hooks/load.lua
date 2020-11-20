local class = require"engine.class"
local Textzone = require "engine.ui.Textzone"
local function hook(self, data)
    if data.kind == "misc" then
	    local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=(_t"Shout when you found dangerous foes.#WHITE#"):toTString()}
	    data.list[#data.list+1] = { zone=zone, name=(_t"#GOLD##{bold}#Shout in danger#WHITE##{normal}#"):toTString(), status=function(item)
			return tostring(config.settings.tome.addon_detailed_stop_reason_allow_shout and _t"enabled" or _t"disabled")
        end, fct=function(item)
       		config.settings.tome.addon_detailed_stop_reason_allow_shout = not config.settings.tome.addon_detailed_stop_reason_allow_shout
            game:saveSettings("tome.addon_detailed_stop_reason_allow_shout", ("tome.addon_detailed_stop_reason_allow_shout = %s\n"):format(tostring(config.settings.tome.addon_detailed_stop_reason_allow_shout)))
       		self.c_list:drawItem(item)
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