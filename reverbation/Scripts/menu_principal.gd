extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	get_tree().quit()


@onready var timer = $Timer  # Asignamos el nodo Timer a la variable `timer`
@onready var timer_2: Timer = $Timer2

func _on_start_game_pressed() -> void:
	$Label.visible = false
	$TextureRect.visible = true
	timer.start()  # Llamamos al método start del timer

func _on_timer_timeout():
	$TextureRect.visible = false
	$TextureRect2.visible = true
	timer_2.start()

func _on_timer_2_timeout():
	get_tree().change_scene_to_file("res://Escenas/world.tscn")
