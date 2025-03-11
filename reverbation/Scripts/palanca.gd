extends StaticBody2D  # Nodo principal como StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var lever_collision = $CollisionShape2DD
@onready var area_2d: Area2D = $AnimatedSprite2D/Area2D

# El estado de la palanca
var is_activated = false  # Palanca activada o no
var player_near = false  # Marca si el jugador está cerca de la palanca
var palanca = false

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_near = true  # El jugador entra en la zona
		print("Presiona la tecla E.")

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_near = false  # El jugador sale de la zona
		print("Jugador se aleja de la palanca.")

# Método para alternar el estado de la palanca (activada o desactivada)
func toggle_lever():
	is_activated = !is_activated  # Alternar el estado de la palanca
	if is_activated:
		print("Palanca activada.")
		if animated_sprite.animation == "desactivada":
			animated_sprite.play("on")
	else:
		print("Palanca desactivada.")
		if animated_sprite.animation == "on":
			animated_sprite.play("desactivada")

func _process(_delta):
	if player_near and Input.is_action_just_pressed("ui_accept"):
		# Si el jugador está cerca y presiona la tecla E, alternamos el estado de la palanca
		toggle_lever()
