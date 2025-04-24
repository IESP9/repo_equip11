extends Control

@onready var bar = $Progreso

func _ready():
	bar.value = 100  # Vida inicial
