extends Sprite2D

var speed = 1.0
var size = Vector2()

signal exited

func _ready() -> void:
	scale.x = randf_range(0.5, 2)
	scale.y = scale.x
	size = Vector2(64 * scale.x, 32 * scale.y)
	position = Vector2(randi_range(0, 1280), randi_range(0, 385))
	speed = scale.x
	
	exited.connect(_on_cloud_exited)

func _process(delta: float) -> void:
	position.x -= 32 * speed * delta
	
	if position.x < 0 - size.x/2:
		exited.emit()

func _on_cloud_exited():
	queue_free()
