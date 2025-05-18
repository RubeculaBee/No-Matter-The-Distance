extends TileMapLayer

# the coordinates of the tiles each player is stepping on
var tile_coords   = [[Vector2i(-1,-1), Vector2i(-1,-1)],[Vector2i(-1,-1), Vector2i(-1,-1)]]
# the atlas coordinates of the tiles each player is stepping on
var atlas_coords  = [[Vector2i(-1,-1), Vector2i(-1,-1)],[Vector2i(-1,-1), Vector2i(-1,-1)]]
@onready var player_1 = get_parent().get_node("Zone P1/player_1")
@onready var player_2 = get_parent().get_node("Zone P2/player_2")

func _process(_delta: float) -> void:
	get_player_tiles(player_1)
	get_player_tiles(player_2)
	
	# if either player presses down when on the ground, attempt to fall through
	if player_1.is_on_floor() and Input.is_action_just_pressed("p1_down"):
		fall_through(player_1)
	if player_2.is_on_floor() and Input.is_action_just_pressed("p2_down"):
		fall_through(player_2)
	
	# if either player is standing on spikes, that player dies
	# (co-ordinates of spikes on the atlas is (3,1))
	if player_1.is_on_floor() and (atlas_coords[0][0] == Vector2i(3,1) or atlas_coords[0][1] == Vector2i(3,1)):
		player_1.die()
	if player_2.is_on_floor() and (atlas_coords[1][0] == Vector2i(3,1) or atlas_coords[1][1] == Vector2i(3,1)):
		player_2.die()

# Disable the collision of the tile below the player if it is a platform
func fall_through(player: CharacterBody2D):
	# All one-way platforms are in the 4th row (3rd y-index) of the tile set
	# if the two tiles are one-way platforms (at the 3rd y-index), 
	# set the tile to it's first alt tile (which has no collision)
	if atlas_coords[player.ID - 1][0].y == 3:
		set_cell(tile_coords[player.ID - 1][0], 0, atlas_coords[player.ID - 1][0], 1)
	if atlas_coords[player.ID - 1][1].y == 3:
		set_cell(tile_coords[player.ID - 1][1], 0, atlas_coords[player.ID - 1][1], 1)
	
	# Start a timer for 0.05 seconds
	# timers are instanced per player so their one-ways work independantly of each other
	var oneway_timer = get_tree().create_timer(.05, true, true)
	match player.ID:
		1: oneway_timer.timeout.connect(_on_p1_oneway_timer_timeout)
		2: oneway_timer.timeout.connect(_on_p2_oneway_timer_timeout)

# get the coordinates and atlas coordinates of the tiles the player is standing on
func get_player_tiles(player: CharacterBody2D):
	# Get the two tiles the player is standing on
	# (12 pixels (half player width) left/right and 48 pixels (1&1/2 blocks) down, devided by 32 (tile width))
	tile_coords[player.ID - 1][0] = floor((player.position + Vector2(-12, 48))/32)
	tile_coords[player.ID - 1][1] = floor((player.position + Vector2( 12, 48))/32)
	
	# Get the atlas coordinates of the two tiles
	# "atlas coordinates" is the tiles location in the tile set
	atlas_coords[player.ID - 1][0] = get_cell_atlas_coords(tile_coords[player.ID - 1][0])
	atlas_coords[player.ID - 1][1] = get_cell_atlas_coords(tile_coords[player.ID - 1][1])

# when the oneway platform timer runs out (after 0.05 seconds)
# set the two tiles back to their default version (which has collision)
func _on_p1_oneway_timer_timeout():
	set_cell(tile_coords[0][0], 0, atlas_coords[0][0])
	set_cell(tile_coords[0][1], 0, atlas_coords[0][1])
func _on_p2_oneway_timer_timeout():
	set_cell(tile_coords[1][0], 0, atlas_coords[1][0])
	set_cell(tile_coords[1][1], 0, atlas_coords[1][1])
