-- $Id: init.lua 3758 2019-11-20 00:25:39Z dsb $
-- ToME - Tales of Maj'Eyal
-- Copyright © 2012-2019 Scott Bigham
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- yutio888
-- yutio888@qq.com

long_name = "Improved Enemy UI"
short_name = "improved_enemy_ui"
for_module = "tome"
version = { 1, 7, 2 }
addon_version = { 1, 0, 0 }
weight = 250
author = { 'yutio888' }
homepage = ''
description = [[1. improve the default shockbolt of enemy, making them brighter and easier to find.
2. when your rest/run/autoexplore got stopped with monsters nearby, you will see these monsters in combat log, with more detailed information.
3. introduce a game option that you may shout when your rest/run/autoexplore stopped with monsters nearby.]]
tags = { 'autoexplore', 'ui', 'enemy ui' }
superload = true
data = true
hooks = true
overload = true