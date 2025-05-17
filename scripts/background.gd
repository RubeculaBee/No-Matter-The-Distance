extends ColorRect

# cloud object
var cloud = preload("res://scenes/game objects/cloud.tscn")

func _ready() -> void:
	# Create 15 clouds and add them to the scene
	for n in 15:
		var new_cloud = cloud.instantiate()
		add_child(new_cloud)
		new_cloud.exited.connect(_on_cloud_exited)

func _on_cloud_exited():
	#when a cloud leaves, create a new one and put it outside the screen
	var new_cloud = cloud.instantiate()
	add_child(new_cloud)
	new_cloud.position.x = 1280 + new_cloud.size.x/2
	new_cloud.exited.connect(_on_cloud_exited)
