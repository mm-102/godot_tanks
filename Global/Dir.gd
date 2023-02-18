extends Reference
class_name Dir

const MASTER = "/root/Master"

const TRANSFER = "/root/Transfer"
const T_CLOCK = TRANSFER + "/Clock"

const MAIN = "/root/Master/Main"
const GAME = MAIN + "/Game"
const PLAYERS = GAME + "/Players"
const PROJECTILES = GAME + "/Projectiles"
const MAP = GAME + "/Map"

const GUI = MAIN + "/GUILayer/GUI"
const GUI_SCOREBOARD = GUI + "/Scoreboard"
const GUI_TIMER = GUI + "/BattleTime"
const GUI_AMMUNITION = GUI + "/Ammunition"



static func get_player_path():
	return 
 