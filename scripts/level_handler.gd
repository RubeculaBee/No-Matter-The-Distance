extends Node

const EXIT = -1
const NONE = 0
const ENTER = 1
var screen_state
var screen_wipe_index

@onready var player_1 = get_node("Zone P1/player_1")
@onready var player_2 = get_node("Zone P2/player_2")
@onready var screen_wipe = get_node("Screen Wipe")


func _ready() -> void:
	player_1.died.connect(_on_player_died)
	player_2.died.connect(_on_player_died)
	screen_state = ENTER
	screen_wipe_index = -32

func _process(delta: float) -> void:
	if screen_state != NONE:
		cover_screen(delta)

func cover_screen(delta: float):
	if screen_state == ENTER:
		screen_wipe.size.x -= 16 * screen_wipe_index * delta
		screen_wipe_index += 2
		if screen_wipe.size.x <= 0:
			screen_state = NONE
			screen_wipe.size.x = 0
			screen_wipe_index = 1
	
	if screen_state == EXIT:
		screen_wipe.size.x += 16 * screen_wipe_index * delta
		screen_wipe_index += 2
		if screen_wipe.size.x >= 1280:
			get_tree().reload_current_scene()

func _on_player_died():
	print("died")
	await get_tree().create_timer(2).timeout
	screen_state = EXIT
