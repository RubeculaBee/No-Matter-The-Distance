extends Node

@onready var player_1 = get_node("Zone P1/player_1")
@onready var player_2 = get_node("Zone P2/player_2")

func _ready() -> void:
	player_1.died.connect(_on_player_died)
	player_2.died.connect(_on_player_died)

func _on_player_died():
	var reset_timer = get_tree().create_timer(3)
	reset_timer.timeout.connect(_reset)

func _reset():
	get_tree().reload_current_scene()
