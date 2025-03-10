extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var current_direction = "none"

func _ready():
	self.y_sort_enabled = true  # Habilita YSort

func _physics_process(delta: float) -> void:
	if player_chase and player:
		var direction = (player.position - position).normalized()
		var distance_to_player = position.distance_to(player.position)

		# Umbral de distancia mínima antes de detenerse
		var stop_distance = 60  

		if distance_to_player > stop_distance:
			position += direction * speed * delta
			play_animation(1)  # En movimiento
		else:
			play_animation(0)  # En reposo

		# Determinar dirección para la animación
		if abs(direction.x) > abs(direction.y):  
			current_direction = "derecha" if direction.x > 0 else "izquierda"
		else:  
			current_direction = "abajo" if direction.y > 0 else "arriba"
	else:
		play_animation(0)  # En reposo

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
