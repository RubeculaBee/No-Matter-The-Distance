extends AnimatableBody2D

# end postion is a tile coordinate and is reletaive to the platforms initial position
@export var end_position = Vector2()
# speed is in tiles per second
@export var SPEED = 1

#node that marks where the moving platform stops
var end_node = Node2D.new()

# debug square is a black square
var debug_square = preload("res://scenes/debug_square.tscn").instantiate()

func _ready() -> void:
	# 1 tile is 32 pixels
	end_position *= 32
	SPEED *= 32
	
	# End Node is top level so that the end node doesnt move when the parent moves
	add_child.call_deferred(end_node)
	end_node.top_level = true
	end_node.position = end_position + position
	
	# debug square shows where the end position is
	end_node.add_child(debug_square)
	print("My Pos: ", position, " | End Pos: ", end_node.position)

func _physics_process(delta: float) -> void:
	var direction_to_end = (end_node.position - position).normalized()
	position += direction_to_end * SPEED * delta
