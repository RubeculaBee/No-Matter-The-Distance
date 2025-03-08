extends CharacterBody2D

const SPEED = 128 # One block is 32 pixels, so a speed of 128 is 4 blocks per second
const JUMP_SPEED = 400;
var direction

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# direction = -1 or 1 if left or right respectively is pressed
	direction = Input.get_axis("p1_left","p1_right") 
	
	if direction:
		velocity.x = direction * SPEED
	else:
		# While not pressing a button, velocity gradually becomes 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_floor() and Input.is_action_just_pressed("p1_up"):
		velocity.y -= JUMP_SPEED
	
	move_and_slide()
