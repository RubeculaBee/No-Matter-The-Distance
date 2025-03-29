extends TileMapLayer

var player_left_tile_coords        = Vector2(-1,-1) # tilemap coordinates of the first tile the player is standing on
var player_right_tile_coords       = Vector2(-1,-1) # tilemap coordinates of the second tile the player is standing on
var player_left_tile_atlas_coords  = Vector2(-1,-1) # atlas coordinates of the first tile the player is standing on
var player_right_tile_atlas_coords = Vector2(-1,-1) # atlas coordinates of the second tile the player is standing on

@onready var player = get_parent().get_child(0)

func _process(_delta: float) -> void:
	# If down is pressed when on floor
	if player.is_on_floor() and Input.is_action_just_pressed("p%s_down" % player.ID):
		# Get the two tiles the player is standing on
		# (12 pixels (half player width) left/right and 64 pixels (two blocks) down, devided by 32 (tile width))
		player_left_tile_coords  = floor((player.position + Vector2(-12, 64))/32)
		player_right_tile_coords = floor((player.position + Vector2( 12, 64))/32)
		
		# Get the atlas coordinates of the two tiles
		# "atlas coordinates" is the tiles location in the tile set
		player_left_tile_atlas_coords  = get_cell_atlas_coords(player_left_tile_coords)
		player_right_tile_atlas_coords = get_cell_atlas_coords(player_right_tile_coords)
		
		# All platforms are in the 4th row (3rd y-index) of the tile set
		# if the two tiles are platforms (at the 3rd y-index), 
		# set the tile to it's first alt tile (which has no collision)
		if player_left_tile_atlas_coords.y == 3:
			set_cell(player_left_tile_coords , 0, player_left_tile_atlas_coords , 1)
		if player_right_tile_atlas_coords.y == 3:
			set_cell(player_right_tile_coords, 0, player_right_tile_atlas_coords, 1)
		
		# Start a timer for 0.05 seconds
		var oneway_timer = get_tree().create_timer(.05, true, true)
		oneway_timer.timeout.connect(_on_oneway_timer_timeout)

# when the oneway platform timer runs out (after 0.05 seconds)
func _on_oneway_timer_timeout():
	# set the two tiles back to their default version (which has collision)
	set_cell(player_left_tile_coords , 0, player_left_tile_atlas_coords)
	set_cell(player_right_tile_coords, 0, player_right_tile_atlas_coords)
