extends CharacterBody2D

const SPEED = 128 # One block is 32 pixels, so a speed of 128 is 4 blocks per second
const JUMP_SPEED = 400;
var direction

@onready var _sprite = $AnimatedSprite2D # Get the attached animated sprite
@onready var ID = name.get_slice("_", 1) # ID equals 1 for player_1 and 2 for player_2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# direction = -1 or 1 if left or right respectively is pressed
	direction = Input.get_axis("p%s_left" % ID,"p%s_right" % ID) 
	
	if direction:
		velocity.x = direction * SPEED
		_sprite.scale.x = direction # look in the direction of movement
		if is_on_floor(): _sprite.play("walk")
	else:
		# While not pressing a button, velocity gradually becomes 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor(): _sprite.play("default")
	
	if is_on_floor() and Input.is_action_just_pressed("p%s_up" % ID):
		velocity.y -= JUMP_SPEED
		_sprite.play("jump")
	
	move_and_slide()
