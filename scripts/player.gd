extends CharacterBody2D

const SPEED = 128       # One block is 32 pixels, so a speed of 128 is 4 blocks per second
const JUMP_SPEED = 400; # how fast the player jumps

var direction           # which left/right direction the player is pressing

var left_tile_coords        = Vector2(-1,-1) # tilemap coordinates of the first tile the player is standing on
var right_tile_coords       = Vector2(-1,-1) # tilemap coordinates of the second tile the player is standing on
var left_tile_atlas_coords  = Vector2(-1,-1) # atlas coordinates of the first tile the player is standing on
var right_tile_atlas_coords = Vector2(-1,-1) # atlas coordinates of the second tile the player is standing on

@onready var _sprite = $AnimatedSprite2D                       # Get the attached animated sprite
@onready var _tilemap = get_parent().get_node("Level Tilemap") # Get the appropriate tilemap
@onready var ID = name.get_slice("_", 1)                       # ID equals 1 for player_1 and 2 for player_2

func _physics_process(delta: float) -> void:	
	# direction = -1 or 1 if left or right respectively is pressed
	direction = Input.get_axis("p%s_left" % ID,"p%s_right" % ID) 
	
	# If pressing a direction
	if direction:
		velocity.x = direction * SPEED
		_sprite.scale.x = direction # look in the direction of movement
		if is_on_floor(): _sprite.play("walk")
	else:
		# While not pressing a button, velocity gradually becomes 0
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor(): _sprite.play("default")
	
	# jump on up button pressed
	if is_on_floor() and Input.is_action_just_pressed("p%s_up" % ID):
		velocity.y -= JUMP_SPEED
		_sprite.play("jump")
	
	# fall from gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Move from velocity
	move_and_slide()

func _process(delta: float) -> void:
	# If down is pressed when on floor
	if is_on_floor() and Input.is_action_just_pressed("p%s_down" % ID):
		# Get the two tiles the player is standing on
		# (12 pixels (half player width) left/right and 64 pixels (two blocks) down, devided by 32 (tile width))
		left_tile_coords  = floor((position + Vector2(-12, 64))/32)
		right_tile_coords = floor((position + Vector2( 12, 64))/32)
		
		# Get the atlas coordinates of the two tiles
		# "atlas coordinates" is the tiles location in the tile set
		left_tile_atlas_coords  = _tilemap.get_cell_atlas_coords(left_tile_coords)
		right_tile_atlas_coords = _tilemap.get_cell_atlas_coords(right_tile_coords)
		
		# All platforms are in the 4th row (3rd y-index) of the tile set
		# if the two tiles are platforms (at the 3rd y-index), 
		# set the tile to it's first alt tile (which has no collision)
		if left_tile_atlas_coords.y == 3:
			_tilemap.set_cell(left_tile_coords , 0, left_tile_atlas_coords , 1)
		if right_tile_atlas_coords.y == 3:
			_tilemap.set_cell(right_tile_coords, 0, right_tile_atlas_coords, 1)
		
		# Start a timer for 0.05 seconds
		var platform_timer = get_tree().create_timer(.05, true, true)
		platform_timer.timeout.connect(_on_platform_timer_timeout)

# when the platform timer runs out (after 0.05 seconds)
func _on_platform_timer_timeout():
	# set the two tiles back to their default version (which has collision)
	_tilemap.set_cell(left_tile_coords , 0, left_tile_atlas_coords)
	_tilemap.set_cell(right_tile_coords, 0, right_tile_atlas_coords)
