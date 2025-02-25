extends CharacterBody2D

var speed = 100
var player_chase = false
var player = null
var current_direction = "none"

func _physics_process(delta: float) -> void:
	if player_chase and player:
		# Calcular dirección hacia el jugador
		var direction = (player.position - position).normalized()
		position += direction * speed * delta
		
		# Determinar dirección para la animación
		if abs(direction.x) > abs(direction.y):  # Movimiento horizontal
			current_direction = "derecha" if direction.x > 0 else "izquierda"
		else:  # Movimiento vertical
			current_direction = "abajo" if direction.y > 0 else "arriba"
		
		play_animation(1)  # 1 = en movimiento
	else:
		play_animation(0)  # 0 = en reposo

func play_animation(movement):
	var animation = $AnimatedSprite2D
	
	if current_direction == "derecha":
		animation.flip_h = true
		animation.play("Walk_side" if movement == 1 else "side_idle")
	elif current_direction == "izquierda":
		animation.flip_h = false
		animation.play("Walk_side" if movement == 1 else "side_idle")
	elif current_direction == "abajo":
		animation.flip_h = false
		animation.play("Walk_front" if movement == 1 else "front_idle")
	elif current_direction == "arriba":
		animation.flip_h = false
		animation.play("Walk_back" if movement == 1 else "back_idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
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
