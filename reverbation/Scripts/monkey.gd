extends CharacterBody2D
@onready var attack_area: Area2D = $Attack/AttackArea

var speed = 100
var player_chase = false
var player = null
var current_direction = "none"
var is_attacking = false
var attack_cooldown = 1.5
var attack_timer = 0.0
var knockback_vector = Vector2.ZERO
var knockback_strength = 0
var knockback_recovery = 7  # Velocidad de recuperación del knockback
var player_in_attack_area = false
var attack_delay_timer: Timer

func _ready():
	$Attack/AttackArea.visible = false
	$Attack/AttackArea.monitoring = false
	self.y_sort_enabled = true  # Habilita YSort
	add_to_group("enemigos")  # Añadir al grupo de enemigos
	vida_actual = vida_max  # Inicializar vida
	
	attack_delay_timer = Timer.new()
	attack_delay_timer.one_shot = true
	attack_delay_timer.wait_time = 0.3  # 0.2 segundos de retraso
	attack_delay_timer.timeout.connect(self._on_attack_delay_timer_timeout)
	add_child(attack_delay_timer)

func _physics_process(delta: float) -> void:
	# Ataque cooldown
	if attack_timer > 0:
		attack_timer -= delta
		
	# Procesar knockback
	if knockback_strength > 0:
		velocity = knockback_vector * knockback_strength
		knockback_strength = max(0, knockback_strength - knockback_recovery)
		
		# Si aún estamos en knockback, aplicar movimiento y salir
		if knockback_strength > 0:
			move_and_slide()
			return
			
	if is_attacking:
		# No moverse durante el ataque
		velocity = Vector2.ZERO
	elif player_chase and player:
		var direction = (player.position - position).normalized()
		var distance_to_player = position.distance_to(player.position)
		# Agregar un pequeño desplazamiento aleatorio para evitar la fusión
		direction += Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
		direction = direction.normalized()  # Normalizar nuevamente
		
		# Umbral de distancia mínima antes de detenerse
		var stop_distance = 60  
		
		if distance_to_player > stop_distance:
			velocity = direction * speed
			play_animation(1)  # En movimiento
		else:
			velocity = Vector2.ZERO
			play_animation(0)  # En reposo
		
		# Solo atacar si el jugador está dentro del área de ataque
		if player_in_attack_area and not is_attacking and attack_timer <= 0.0:
			start_attack(player)
			
		# Determinar dirección para la animación
		if abs(direction.x) > abs(direction.y):  
			current_direction = "derecha" if direction.x > 0 else "izquierda"
		else:  
			current_direction = "abajo" if direction.y > 0 else "arriba"
	else:
		velocity = Vector2.ZERO
		play_animation(0)  # En reposo
		
	move_and_slide()

func play_animation(movement):
	# No cambiar animación si está atacando o en knockback
	if is_attacking or knockback_strength > 0:
		return
		
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
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		player_chase = false

func start_attack(_body: Node2D) -> void:
	# Solo atacar si el jugador está en el área de ataque
	if player_in_attack_area == true and is_attacking == false:
		var animation = $AnimatedSprite2D
		is_attacking = true
		attack_timer = attack_cooldown
		$Attack/AttackArea.visible = false
		$Attack/AttackArea.monitoring = false
		
		match current_direction:
			"derecha":
				animation.flip_h = true
				animation.play("Attack_side")
				print("ataque derecha")
				$Attack/AttackArea.global_position = global_position + Vector2(8, 0)
			"izquierda":
				animation.flip_h = false
				animation.play("Attack_side")
				print("ataque izquierda")
				$Attack/AttackArea.global_position = global_position + Vector2(-100, 0)
			"arriba":
				animation.play("Attack_back")
				print("ataque arriba")
				$Attack/AttackArea.global_position = global_position + Vector2(-45, -30)
			"abajo":
				animation.play("Attack_front")
				print("ataque abajo")
				$Attack/AttackArea.global_position = global_position + Vector2(-45, 40)
	
		# Conectar la señal de animación terminada si no está conectada
		if not animation.animation_finished.is_connected(self._on_attack_animation_finished):
			animation.animation_finished.connect(self._on_attack_animation_finished)
	elif player_in_attack_area == false and is_attacking == true:
		is_attacking = false
		return
	
	attack_delay_timer.start()

func _on_attack_delay_timer_timeout():
	if is_attacking:  # Solo activar si todavía está atacando
		$Attack/AttackArea.visible = true
		$Attack/AttackArea.monitoring = true

func _on_attack_animation_finished():
	# Esta función se llama cuando termina cualquier animación
	if is_attacking:
		is_attacking = false
		$Attack/AttackArea.visible = false
		$Attack/AttackArea.monitoring = false
		print("Animación de ataque terminada")

func _on_attack_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_area = true

func _on_attack_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_attack_area = false
		print("ha salido")
		# Asegurarnos de que no esté atacando si el jugador sale del área
		# No cancelamos el ataque actual, pero evitamos que inicie uno nuevo

func die():
	queue_free()


@onready var barra_vida: TextureProgressBar = $BarraVida
@export var vida_max = 100
var vida_actual = vida_max


func take_damage(amount):
	vida_actual -= amount
	update_barra_vida()
	$AnimatedSprite2D.play("damage")

	if vida_actual <= 0:
		print("enemigo muerto")
		die()

func update_barra_vida():
	# Corregido: La barra se actualiza con el valor de vida_actual
	barra_vida.value = clampf(vida_actual, 0, vida_max)

func apply_knockback(knockback: Vector2) -> void:
	knockback_vector = knockback.normalized()
	knockback_strength = 250  # Fuerza del knockback
	
	# Puedes añadir aquí lógica de daño o efectos visuales
	print("Enemigo recibió knockback!")

# Función para que el enemigo dañe al jugador cuando lo golpea
func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(20)  # Daño que hace el enemigo al jugador
		var knockback = (body.global_position - global_position).normalized() * 200
		if body.has_method("apply_knockback"):
			body.apply_knockback(knockback)
