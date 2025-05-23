extends CharacterBody2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@export var speed = 350
@export var sprint_speed = 500  # Velocidad al correr


@onready var sprite_corazon_2: AnimatedSprite2D = $sprite_corazon2

@export var max_health = 100
@onready var cooldown: Timer = $cooldown
@onready var hab1_time: Timer = $hability1_time
@onready var hab1_label: Label = $Camera/hab1_time


var current_health = max_health
var current_direction = "none"
var is_attacking = false
var attack_cooldown = 1.5

var estado = "off"
var cooldown_value = 10
var label_value = cooldown_value - 1

var attack_timer = 1.5
var knockback_vector = Vector2.ZERO
var knockback_strength = 0
var knockback_recovery = 10  # Velocidad de recuperación del knockback
var attack_delay_timer: Timer

func _ready():
	$AnimatedSprite2D.play("front_idle")
	self.y_sort_enabled = true  # Habilita YSort
	add_to_group("player")  # Mejor forma de añadir al grupo
	$AttackArea.visible = false
	$AttackArea.monitoring = false
	
	#timer habilidad
	cooldown.wait_time = 1
	cooldown.one_shot = false
	cooldown.start()

	attack_delay_timer = Timer.new()
	
	attack_delay_timer.one_shot = true

	attack_delay_timer.wait_time = 0.3  # 0.2 segundos de retraso

	attack_delay_timer.timeout.connect(self._on_attack_delay_timer_timeout)

	add_child(attack_delay_timer)


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
	#Habilidad de Luz
	if cooldown_value >= 11:
		eco()
	
	label_value = cooldown_value - 1

	if cooldown_value >= 11:
		hab1_label.text = "Habilidad Lista"
	else:
		hab1_label.text = str(label_value)

	
func start_attack():
	is_attacking = true
	attack_timer = attack_cooldown
	$AttackArea.visible = false
	$AttackArea.monitoring = false
	
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
	# Iniciar el timer de retraso para activar el área de ataque
	attack_delay_timer.start()

# Esta función se llama cuando el timer de retraso termina
func _on_attack_delay_timer_timeout():
	if is_attacking:  # Solo activar si todavía está atacando
		$AttackArea.visible = true
		$AttackArea.monitoring = true
		print("Área de ataque activada después del retraso")

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
	$AnimatedSprite2D.play("damage")
	
	if current_health == 100:
		sprite_corazon_2.play("vida_5")
	elif current_health == 80:
		sprite_corazon_2.play("vida_4")
	elif current_health == 60:
		sprite_corazon_2.play("vida_3")
	elif current_health == 40:
		sprite_corazon_2.play("vida_2")
	elif current_health == 20:
		sprite_corazon_2.play("vida_1")
	elif current_health < 20:
		sprite_corazon_2.play("vida_0")
		
	if current_health <= 0:
		print("Jugador ha muerto")
		die()
		get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")

func apply_knockback(knockback: Vector2) -> void:
	knockback_vector = knockback.normalized()
	knockback_strength = 250  # Fuerza del knockback para el jugador
	print("Jugador recibió knockback!")

# Conectar esta señal en el editor, o usar el formato correcto para la conexión automática
func _on_attack_area_body_entered(body):
	if body.is_in_group("enemigos"):
		print("Golpeando a un enemigo")
		body.take_damage(40)  # Daño que hace el jugador
		var knockback = (body.global_position - global_position).normalized() * 200
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback)
			
func eco():
	if Input.is_action_just_pressed("habilidad1") and cooldown_value >= 11:
		estado = "on"
		print("Habilidad 1 activada")
		while estado == "on":
			point_light_2d.texture_scale = 5
			hab1_time.start()
			hab1_time.wait_time = 3.5
			hab1_time.one_shot = true
			cooldown.stop()
			estado = "off"


func _on_hability_1_time_timeout() -> void:
	point_light_2d.texture_scale = 1
	cooldown_value = 1  # Reiniciamos cooldown
	#hab1_label.text = str(cooldown_value)
	cooldown.start()  # Replace with function body.

func _on_cooldown_timeout() -> void:
	if cooldown_value > 0:
		cooldown_value = cooldown_value + 1
