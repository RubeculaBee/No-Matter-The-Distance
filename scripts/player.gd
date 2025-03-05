extends CharacterBody2D

const SPEED = 640
var direction

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("p1_left","p1_right")
	
	if(!is_on_floor()):
		velocity.y += get_gravity() * delta
	
	velocity.x = direction * SPEED * delta
	
	move_and_slide()
