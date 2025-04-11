extends CharacterBody2D

@export var speed = 220
@export var sprint_speed = 350  # Velocidad al correr
var current_direction = "none"
var is_attacking = false
var attack_cooldown = 1.5
var attack_timer = 0.0

@onready var player: CharacterBody2D = $"."


func _ready():
	$AnimatedSprite2D.play("front_idle")
	self.y_sort_enabled = true  # Habilita YSort
	player.is_in_group("player")  # <-- corregido para que esté en el grupo "player"
	$AttackArea.visible = false
	$AttackArea.monitoring = false

func get_input():
	var input_direction = Input.get_vector("izquierda", "derecha", "arriba", "abajo")

	# Detectar ataque
	if Input.is_action_just_pressed("ataque") and attack_timer <= 0:
		start_attack()
		return  # evita movimiento mientras ataca

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

	if input_direction == Vector2.ZERO:
		current_direction = current_direction 
	

	# Determinar si hay movimiento
	var is_moving = 1 if input_direction.length() > 0 else 0
	play_animation(is_moving, is_sprinting)

func play_animation(movement, is_sprinting):
	var animation = $AnimatedSprite2D

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


func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
	else:
		get_input()

	move_and_slide()

	# Ataque cooldown
	if attack_timer > 0:
		attack_timer -= delta


func start_attack():
	is_attacking = true
	attack_timer = attack_cooldown
	$AttackArea.visible = true
	$AttackArea.monitoring = true
	
	match current_direction:
		"derecha":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$AttackArea.global_position = global_position + Vector2(8, 0)
		"izquierda":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$AttackArea.global_position = global_position + Vector2(-100, 0)
		"arriba":
			$AnimatedSprite2D.play("back_attack")
			$AttackArea.global_position = global_position + Vector2(-45, -30)
		"abajo":
			$AnimatedSprite2D.play("front_attack")
			$AttackArea.global_position = global_position + Vector2(-45, 40)

	$AttackArea.monitoring = true

	await $AnimatedSprite2D.animation_finished
	is_attacking = false
	$AttackArea.visible = false
	$AttackArea.monitoring = false


func _on_AttackArea_body_entered(body):
	if body.is_in_group("enemigos"):
		var knockback = (body.global_position - global_position).normalized() * 200
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback)
