extends StaticBody2D

@onready var trigger = $Trigger         # area trigger to detect when something pushes button
@onready var sprite = $AnimatedSprite2D # the buttons sprite

signal pressed  # signal emitted when the button is pressed
signal released # signal emitted when the button is released

func _ready() -> void:
	# Connect to trigger signals
	trigger.body_entered.connect(_on_trigger_body_entered)
	trigger.body_exited.connect(_on_trigger_body_exited)

func _on_trigger_body_entered(_body):
	# switch to down sprite
	sprite.play("down")
	# emit pressed signal
	pressed.emit()

func _on_trigger_body_exited(_body):
	# switch to up sprite
	sprite.play("default")
	# emit released signal
	released.emit()
