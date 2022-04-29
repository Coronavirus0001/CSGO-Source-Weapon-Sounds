-- local variables for API functions. any changes to the line below will be lost on re-generation
local client_exec, client_set_event_callback, entity_get_local_player, entity_get_player_weapon, ui_get, ui_new_checkbox, ui_new_hotkey, ui_new_slider, pairs, ui_set_callback, ui_set_visible = client.exec, client.set_event_callback, entity.get_local_player, entity.get_player_weapon, ui.get, ui.new_checkbox, ui.new_hotkey, ui.new_slider, pairs, ui.set_callback, ui.set_visible

-- libs
local csgo_weapons = require 'gamesense/csgo_weapons'
-- Vars
local tab, container = "MISC", "Settings"
-- New UI --
local ui_e = {
	enable = ui_new_checkbox(tab, container, "Custom Weapon Sounds"),
	attack = ui_new_hotkey(tab, container, "Primary Attack", false, 1),
	vol = ui_new_slider(tab, container, "Weapon Volume", 0, 100, 100, true, "%", 1)
}
--Functions
local function get_weapon()
	local local_player = entity_get_local_player()
	local weapon_ent = entity_get_player_weapon(local_player)
	if weapon_ent == nil then return end
	local weapon = csgo_weapons(weapon_ent)
	return weapon.name
end

local function handle_ui()
	main_state = ui_get(ui_e.enable)
	for i,v in pairs(ui_e) do
		ui_set_visible(v, main_state)
	end
	ui_set_visible(ui_e.enable, true)
end

--Functions On Events
client_set_event_callback("aim_fire", function()
if not ui_get(ui_e.enable) then return end
local cur_weapon = get_weapon():gsub("%s+", "")
local cur_vol = (" " .. ui_get(ui_e.vol)/100)
client_exec("playvol weaponsounds/"..cur_weapon..cur_vol)
end)

--Callbacks
ui_set_callback(ui_e.enable, handle_ui)
handle_ui()