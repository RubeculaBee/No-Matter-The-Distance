extends Node2D 

@onready var viewport_p1 = $VBoxContainer/SubViewportContainer1/SubViewport
@onready var viewport_p2 = $VBoxContainer/SubViewportContainer2/SubViewport

func _ready() -> void:
	viewport_p2.set_world_2d(viewport_p1.get_world_2d())
