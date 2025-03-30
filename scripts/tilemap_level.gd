extends TileMapLayer

var tile_coords   = [[Vector2(-1,-1), Vector2(-1,-1)],[Vector2(-1,-1), Vector2(-1,-1)]]
var atlas_coords  = [[Vector2(-1,-1), Vector2(-1,-1)],[Vector2(-1,-1), Vector2(-1,-1)]]
@onready var player_1 = get_parent().get_node("Zone P1/player_1")
@onready var player_2 = get_parent().get_node("Zone P2/player_2")

func _process(_delta: float) -> void:
	if player_1.is_on_floor() and Input.is_action_just_pressed("p1_down"):
		fall_through(player_1)
		
	if player_2.is_on_floor() and Input.is_action_just_pressed("p2_down"):
		fall_through(player_2)

func fall_through(player: CharacterBody2D):
	# Get the two tiles the player is standing on
	# (12 pixels (half player width) left/right and 64 pixels (two blocks) down, devided by 32 (tile width))
	tile_coords[player.ID - 1][0] = floor((player.position + Vector2(-12, 64))/32)
	tile_coords[player.ID - 1][1] = floor((player.position + Vector2( 12, 64))/32)
	
	# Get the atlas coordinates of the two tiles
	# "atlas coordinates" is the tiles location in the tile set
	atlas_coords[player.ID - 1][0] = get_cell_atlas_coords(tile_coords[player.ID - 1][0])
	atlas_coords[player.ID - 1][1] = get_cell_atlas_coords(tile_coords[player.ID - 1][1])
	
	# All platforms are in the 4th row (3rd y-index) of the tile set
	# if the two tiles are platforms (at the 3rd y-index), 
	# set the tile to it's first alt tile (which has no collision)
	if atlas_coords[player.ID - 1][0].y == 3:
		set_cell(tile_coords[player.ID - 1][0], 0, atlas_coords[player.ID - 1][0], 1)
	if atlas_coords[player.ID - 1][1].y == 3:
		set_cell(tile_coords[player.ID - 1][1], 0, atlas_coords[player.ID - 1][1], 1)
	
	# Start a timer for 0.05 seconds
	var oneway_timer = get_tree().create_timer(.05, true, true)
	match player.ID:
		1: oneway_timer.timeout.connect(_on_p1_oneway_timer_timeout)
		2: oneway_timer.timeout.connect(_on_p2_oneway_timer_timeout)

# when the oneway platform timer runs out (after 0.05 seconds)
func _on_p1_oneway_timer_timeout():
	# set the two tiles back to their default version (which has collision)
	set_cell(tile_coords[0][0], 0, atlas_coords[0][0])
	set_cell(tile_coords[0][1], 0, atlas_coords[0][1])

func _on_p2_oneway_timer_timeout():
	# set the two tiles back to their default version (which has collision)
	set_cell(tile_coords[1][0], 0, atlas_coords[1][0])
	set_cell(tile_coords[1][1], 0, atlas_coords[1][1])
