extends AnimatedSprite2D
@onready var colision_p1: CollisionShape2D = $StaticBody2D/colision_puerta1
@onready var puerta_1: AnimatedSprite2D = $"."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if palanca_global.palanca_puerta1 == true:
		colision_p1.disabled = true
		puerta_1.play("abierta")
	else:
		puerta_1.play("horizontal")
		colision_p1.disabled = false
