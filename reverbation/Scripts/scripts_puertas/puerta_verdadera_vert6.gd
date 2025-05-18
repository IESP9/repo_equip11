extends AnimatedSprite2D

@onready var colision_p1: CollisionShape2D = $StaticBody2D/colision_puerta1


@onready var puerta_1: AnimatedSprite2D = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	puerta_1.play("horizontal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if palanca_global.palanca_puerta6 == true:
		colision_p1.disabled = true
		puerta_1.play("abierta")	
	else:
		puerta_1.play("vertical")
		colision_p1.disabled = false
	###########################################
	
	
