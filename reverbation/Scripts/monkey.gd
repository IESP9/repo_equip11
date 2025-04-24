
#extends CharacterBody2D

#var speed = 100
#var player_chase = false
#var player = null
#var current_direction = "none"

#unc _ready():
#	self.y_sort_enabled = true  # Habilita YSort
#
#func _physics_process(delta: float) -> void:
#	if player_chase and player:
#		var direction = (player.position - position).normalized()
#		var distance_to_player = position.distance_to(player.position)
#
#		# Umbral de distancia mínima antes de detenerse
#		var stop_distance = 60  

#		if distance_to_player > stop_distance:
#			position += direction * speed * delta
#			play_animation(1)  # En movimiento
#		else:
#			play_animation(0)  # En reposo
#
#		# Determinar dirección para la animación
#		if abs(direction.x) > abs(direction.y):  
#			current_direction = "derecha" if direction.x > 0 else "izquierda"
#		else:  
#			current_direction = "abajo" if direction.y > 0 else "arriba"
#	else:
#		play_animation(0)  # En reposo


extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var current_direction = "none"
var is_attacking = false
var attack_cooldown = 1.5
var attack_timer = 0.0

func _ready():
	$Attack/AttackArea.visible = false
	$Attack/AttackArea.monitoring = false
	self.y_sort_enabled = true  # Habilita YSort

func _physics_process(delta: float) -> void:
	if player_chase and player:
		var direction = (player.position - position).normalized()
		var distance_to_player = position.distance_to(player.position)

		# Agregar un pequeño desplazamiento aleatorio para evitar la fusión
		direction += Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
		direction = direction.normalized()  # Normalizar nuevamente

		# Umbral de distancia mínima antes de detenerse
		var stop_distance = 60  

		if distance_to_player > stop_distance:
			velocity = direction * speed
			move_and_slide()  # Usa move_and_slide en lugar de modificar position directamente
			play_animation(1)  # En movimiento
		else:
			velocity = Vector2.ZERO
			play_animation(0)  # En reposo

		# Determinar dirección para la animación
		if abs(direction.x) > abs(direction.y):  
			current_direction = "derecha" if direction.x > 0 else "izquierda"
		else:  
			current_direction = "abajo" if direction.y > 0 else "arriba"
	else:
		velocity = Vector2.ZERO
		play_animation(0)  # En reposo
		
	if is_attacking:
		velocity = Vector2.ZERO
	

	move_and_slide()

	# Ataque cooldown
	if attack_timer > 0:
		attack_timer -= delta

func play_animation(movement):
	var animation = $AnimatedSprite2D
	
	if current_direction == "derecha":
		animation.flip_h = true
		animation.play("Walk_side" if movement == 1 else "Idle_front")
	elif current_direction == "izquierda":
		animation.flip_h = false
		animation.play("Walk_side" if movement == 1 else "Idle_front")
	elif current_direction == "abajo":
		animation.flip_h = false
		animation.play("Walk_front" if movement == 1 else "Idle_front")
	elif current_direction == "arriba":
		animation.flip_h = false
		animation.play("Walk_back" if movement == 1 else "Idle_front")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	player_chase = false

"func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
	else:
		get_input()

	move_and_slide()

	# Ataque cooldown
	if attack_timer > 0:
		attack_timer -= delta"


func start_attack(_body: Node2D) -> void:
	is_attacking = true
	attack_timer = attack_cooldown
	$Attack/AttackArea.visible = true
	$Attack/AttackArea.monitoring = true
	
	match current_direction:
		"derecha":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("Attack_side")
			$Attack/AttackArea.global_position = global_position + Vector2(8, 0)
		"izquierda":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("Attack_side")
			$Attack/AttackArea.global_position = global_position + Vector2(-100, 0)
		"arriba":
			$AnimatedSprite2D.play("Attack_back")
			$Attack/AttackArea.global_position = global_position + Vector2(-45, -30)
		"abajo":
			$AnimatedSprite2D.play("Attack_front")
			$Attack/AttackArea.global_position = global_position + Vector2(-45, 40)


	await $AnimatedSprite2D.animation_finished
	is_attacking = false
	$Attack/AttackArea.visible = false
	$Attack/AttackArea.monitoring = false
func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_attacking and attack_timer <= 0.0:
		start_attack(body)
"
extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
"
