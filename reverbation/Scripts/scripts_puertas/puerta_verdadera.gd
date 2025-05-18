extends AnimatedSprite2D

@onready var colision_p1: CollisionShape2D = $StaticBody2D/colision_puerta1


@onready var puerta_1: AnimatedSprite2D = $"."
@onready var puerta_2: AnimatedSprite2D = $"../puerta2"
@onready var puerta_3: AnimatedSprite2D = $"../puerta3"
@onready var puerta_4: AnimatedSprite2D = $"../puerta4"
@onready var puerta_5: AnimatedSprite2D = $"../puerta5"
@onready var puerta_6: AnimatedSprite2D = $"../puerta6"
@onready var puerta_7: AnimatedSprite2D = $"../puerta7"
@onready var puerta_8: AnimatedSprite2D = $"../puerta8"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	puerta_1.play("horizontal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if palanca_global.palanca_puerta1 == true:
		colision_p1.disabled = true
		puerta_1.play("abierta")
	
	elif palanca_global.palanca_puerta2 == true:
		colision_p1.disabled = true
		puerta_2.play("abierta")
	
	
	else:
		puerta_1.play("horizontal")
		colision_p1.disabled = false
	###########################################
	
	
