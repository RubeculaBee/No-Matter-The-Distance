extends CharacterBody2D

const SPEED = 128       # One block is 32 pixels, so a speed of 128 is 4 blocks per second
const JUMP_SPEED = 400  # how fast the player jumps
var direction           # which left/right direction the player is pressing
var alive = true        # Becomes false when player dies

signal died

@onready var sprite = $AnimatedSprite2D             # Get the attached animated sprite
@onready var ID = name.get_slice("_", 1).to_int()   # ID equals 1 for player_1 and 2 for player_2

func _ready() -> void:
	died.connect(_on_this_died)

func _physics_process(delta: float) -> void:
	if alive:
		move(delta)

# Handles everything about player movement (walking, jumping, falling)
func move(delta: float):
	# direction = -1 or 1 if left or right respectively is pressed
	direction = Input.get_axis("p%s_left" % ID,"p%s_right" % ID) 
	
	# If pressing a direction
	if direction:
		velocity.x = direction * SPEED
		sprite.scale.x = direction # look in the direction of movement
		if is_on_floor(): sprite.play("walk")
	else:
		# While not pressing a button, velocity gradually becomes 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor(): sprite.play("default")
	
	# jump on up button pressed
	if is_on_floor() and Input.is_action_just_pressed("p%s_up" % ID):
		velocity.y -= JUMP_SPEED
		sprite.play("jump")
	
	# fall from gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Move from velocity
	move_and_slide()

# Handles player death
func _on_this_died():
	if alive:
		alive = false
		
