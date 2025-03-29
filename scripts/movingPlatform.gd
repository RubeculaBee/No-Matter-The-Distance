extends AnimatableBody2D

# end postion is a tile coordinate and is reletaive to the platforms initial position
@export var move_distance = Vector2()
# speed is in tiles per second
@export var SPEED = 1.

#node that marks where the moving platform stops
var end_node = Node2D.new()

# debug square is a black square
##var debug_square = preload("res://scenes/debug_square.tscn").instantiate()

# seconds since the platform was created
var time = 0

# direction of the end point
var move_direction

# where the platform starts
@onready var start_position = position

func _ready() -> void:
	# 1 tile is 32 pixels
	move_distance *= 32
	SPEED *= 32
	
	move_direction = move_distance.normalized()
	
	# End Node is top level so that the end node doesnt move when the parent moves
	add_child.call_deferred(end_node)
	end_node.top_level = true
	end_node.position = position + move_distance
	
	# debug square shows where the end position is
	##end_node.add_child(debug_square)
	##print("My Pos: ", position, " | End Pos: ", end_node.position)

func _physics_process(delta: float) -> void:
	time += delta
	# platform moves in the direction of the end point at the given speed
	position += move_direction * SPEED * delta
	#if the amount of time elapsed reaches the time it takes for the platform to move to the end
	if time >= sqrt(pow(move_distance.x,2) + pow(move_distance.y,2))/SPEED:
		#revers the direction and reset the timer
		move_direction *= -1
		time = 0
