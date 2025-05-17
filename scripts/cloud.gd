extends Sprite2D

var speed = 1.0      # how many tiles per second the cloud moves
var size = Vector2() # the clouds dimensions in pixels

signal exited

func _ready() -> void:
	# When a cloud is created, give it a random scale and position
	scale.x = randf_range(0.5, 2)
	scale.y = scale.x
	size = Vector2(64 * scale.x, 32 * scale.y)
	position = Vector2(randi_range(0, 1280), randi_range(0, 385))
	# It's speed is based on it's scale (smaller clouds move slower, as if they were far away)
	speed = scale.x
	
	exited.connect(_on_cloud_exited)

func _process(delta: float) -> void:
	# Cosntantly move left
	position.x -= 32 * speed * delta
	
	# When leaving the screen, emit the exit signal
	if position.x < 0 - size.x/2:
		exited.emit()

func _on_cloud_exited():
	# When a cloud leaves, remvoe it
	queue_free()
