extends Area2D
@onready var final: Area2D = $"."


func _ready() -> void:
	final.body_entered.connect(_on_body_entered)
	
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Escenas/menu_principal.tscn")
	else:
		pass
