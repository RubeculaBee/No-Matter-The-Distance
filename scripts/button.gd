extends StaticBody2D

@onready var trigger = $Trigger
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	trigger.body_entered.connect(_on_button_pressed)
	trigger.body_exited.connect(_on_button_released)
	print("Button Ready")

func _on_button_pressed(body):
	sprite.play("down")
	print("Pressed")

func _on_button_released(body):
	sprite.play("default")
	print("Released")
