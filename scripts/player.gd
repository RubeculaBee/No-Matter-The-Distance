extends CharacterBody2D

const SPEED = 64
var direction

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("p1_left","p1_right")
	
	if(!is_on_floor()):
		velocity += get_gravity() * delta
	
	velocity.x = direction * SPEED
	
	move_and_slide()
