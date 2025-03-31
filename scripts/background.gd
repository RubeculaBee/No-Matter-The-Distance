extends ColorRect

# cloud object
var cloud = preload("res://scenes/game objects/cloud.tscn")

func _ready() -> void:
	for n in 15:
		var new_cloud = cloud.instantiate()
		add_child(new_cloud)
		new_cloud.exited.connect(_on_cloud_exited)

func _on_cloud_exited():
	var new_cloud = cloud.instantiate()
	add_child(new_cloud)
	new_cloud.position.x = 1280 + new_cloud.size.x/2
	new_cloud.exited.connect(_on_cloud_exited)
