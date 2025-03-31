extends CharacterBody2D

@export var speed = 220
@export var sprint_speed = 350  # Velocidad al correr
var current_direction = "none"
@onready var player: CharacterBody2D = $"."


func _ready():
	$AnimatedSprite2D.play("front_idle")
	self.y_sort_enabled = true  # Habilita YSort
	player.is_in_group("player")
func get_input():
	var input_direction = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	
	# Detectar si Shift está presionado para hacer sprint
	var is_sprinting = Input.is_action_pressed("sprint")
	var current_speed = sprint_speed if is_sprinting else speed
	
	# Aplicar velocidad según si está corriendo o caminando
	velocity = input_direction * current_speed

	# Determinar la dirección actual
	if input_direction.x > 0:
		current_direction = "derecha"
	elif input_direction.x < 0:
		current_direction = "izquierda"
	elif input_direction.y > 0:
		current_direction = "abajo"
	elif input_direction.y < 0:
		current_direction = "arriba"
	
	# Mantener la dirección si no hay movimiento
	if input_direction == Vector2.ZERO:
		current_direction = current_direction 
	
	# Determinar si hay movimiento
	var is_moving = 1 if input_direction.length() > 0 else 0
	play_animation(is_moving, is_sprinting)  # Pasamos si está corriendo o no

func play_animation(movement, is_sprinting):
	var animation = $AnimatedSprite2D
	
	# Determinar qué animación usar dependiendo de si está esprintando
	if current_direction == "derecha":
		animation.flip_h = true
		if is_sprinting:
			animation.play("side_run" if movement == 1 else "side_idle")
		else:
			animation.play("side_walk" if movement == 1 else "side_idle")
	elif current_direction == "izquierda":
		animation.flip_h = false
		if is_sprinting:
			animation.play("side_run" if movement == 1 else "side_idle")
		else:
			animation.play("side_walk" if movement == 1 else "side_idle")
	elif current_direction == "abajo":
		animation.flip_h = false
		if is_sprinting:
			animation.play("front_run" if movement == 1 else "front_idle")
		else:
			animation.play("front_walk" if movement == 1 else "front_idle")
	elif current_direction == "arriba":
		animation.flip_h = false
		if is_sprinting:
			animation.play("back_run" if movement == 1 else "back_idle")
		else:
			animation.play("back_walk" if movement == 1 else "back_idle")

func _physics_process(_delta):
	get_input()
	move_and_slide()
