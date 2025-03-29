extends AnimatableBody2D

@export var move_distance = Vector2()                    # how many tiles the platform should move
@export var SPEED = 1.                                   # speed is in tiles per second
@onready var start_position = position                   # where the platform starts
@onready var move_direction = move_distance.normalized() # direction the platform will move
var time = 0                                             # seconds since the platform was created

# debug square is a black square
##var debug_square = preload("res://scenes/debug_square.tscn").instantiate() 

func _ready() -> void:
	# 1 tile is 32 pixels
	move_distance *= 32
	SPEED *= 32
	
	# debug square shows where the end position is
	##add_child(debug_square)
	##debug_square.top_level = true
	##debug_square.position = position + move_distance
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
