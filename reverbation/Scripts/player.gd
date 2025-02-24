extends CharacterBody2D

@export var speed = 220
var current_direction = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func get_input():
	var imput_direction = Input.get_vector("izquierda", "derecha", "arriba", "abajo")
	velocity = imput_direction * speed

	
	if imput_direction.x > 0:
		current_direction = "derecha"
	elif imput_direction.x < 0:
		current_direction = "izquierda"
	elif imput_direction.y > 0:
		current_direction = "abajo"
	elif imput_direction.y < 0:
		current_direction = "arriba"
	
	
	if imput_direction == Vector2.ZERO:
		current_direction = current_direction 
	
	
	var is_moving = 1 if imput_direction.length() > 0 else 0
	play_animation(is_moving)

func play_animation(movement):
	var animation = $AnimatedSprite2D
	
	if current_direction == "derecha":
		animation.flip_h = true
		animation.play("side_walk" if movement == 1 else "side_idle")
	elif current_direction == "izquierda":
		animation.flip_h = false
		animation.play("side_walk" if movement == 1 else "side_idle")
	elif current_direction == "abajo":
		animation.flip_h = false
		animation.play("front_walk" if movement == 1 else "front_idle")
	elif current_direction == "arriba":
		animation.flip_h = false
		animation.play("back_walk" if movement == 1 else "back_idle")


func _physics_process(delta):
	get_input()
	move_and_slide()

"""
func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = "down"
		play_animation(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_direction = "up"
		play_animation(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_animation(0)
		velocity.y = 0
		velocity.x = 0

	move_and_slide()
	
func play_animation(movement):
	var dir = current_direction
	var animation = $AnimatedSprite2D
	
	if dir == "derecha":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if dir == "izquierda":
		animation.flip_h = false
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			animation.play("side_idle")
	if dir == "abajo":
		animation.flip_h = false
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			animation.play("front_idle")
	if dir == "arriba":
		animation.flip_h = false
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			animation.play("back_idle")
"""
