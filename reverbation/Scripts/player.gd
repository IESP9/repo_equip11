extends CharacterBody2D


@export var speed = 400
@export var sprint_speed = 550  # Velocidad al correr

@export var max_health = 100
var current_health = max_health
var current_direction = "none"
var is_attacking = false
var attack_cooldown = 1.5
var attack_timer = 0.0
var knockback_vector = Vector2.ZERO
var knockback_strength = 0
var knockback_recovery = 10  # Velocidad de recuperación del knockback

func _ready():
	$AnimatedSprite2D.play("front_idle")
	self.y_sort_enabled = true  # Habilita YSort
	add_to_group("player")  # Mejor forma de añadir al grupo
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
	
	# Determinar si hay movimiento
	var is_moving = 1 if input_direction.length() > 0 else 0
	play_animation(is_moving, is_sprinting)

func play_animation(movement, is_sprinting):
	# No cambiar animación si está atacando o en knockback
	if is_attacking or knockback_strength > 0:
		return
		
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
	# Procesar knockback
	if knockback_strength > 0:
		velocity = knockback_vector * knockback_strength
		knockback_strength = max(0, knockback_strength - knockback_recovery)
		
		# Si aún estamos en knockback, aplicar movimiento y salir
		if knockback_strength > 0:
			move_and_slide()
			return
	
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
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$AttackArea.global_position = global_position + Vector2(8, 0)
		"izquierda":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$AttackArea.global_position = global_position + Vector2(-100, 0)
		"arriba":
			$AnimatedSprite2D.play("back_attack")
			$AttackArea.global_position = global_position + Vector2(-45, -50)
		"abajo":
			$AnimatedSprite2D.play("front_attack")
			$AttackArea.global_position = global_position + Vector2(-45, 50)
	
	# Conectar la señal si no está conectada ya
	if not $AnimatedSprite2D.animation_finished.is_connected(self._on_attack_animation_finished):
		$AnimatedSprite2D.animation_finished.connect(self._on_attack_animation_finished)

func _on_attack_animation_finished():
	# Esta función se llama cuando termina cualquier animación
	if is_attacking:
		is_attacking = false
		$AttackArea.visible = false
		$AttackArea.monitoring = false
		print("Animación de ataque terminada")

func die():
	print("Jugador ha muerto!")
	queue_free()

func take_damage(amount):
	current_health -= amount
	print("Jugador recibió " + str(amount) + " de daño. Salud: " + str(current_health))
	
	if current_health <= 0:
		print("Jugador ha muerto")
		die()

func apply_knockback(knockback: Vector2) -> void:
	knockback_vector = knockback.normalized()
	knockback_strength = 150  # Fuerza del knockback para el jugador
	print("Jugador recibió knockback!")

# Conectar esta señal en el editor, o usar el formato correcto para la conexión automática
func _on_attack_area_body_entered(body):
	if body.is_in_group("enemigos"):
		print("Golpeando a un enemigo")
		body.take_damage(20)  # Daño que hace el jugador
		var knockback = (body.global_position - global_position).normalized() * 200
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback)
