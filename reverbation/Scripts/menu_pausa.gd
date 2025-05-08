extends CanvasLayer


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pausa"):
		toggle_pause()

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	$ColorRect.visible = not $ColorRect.visible
	$VBoxContainer/Continue.visible = not $VBoxContainer/Continue.visible
	$VBoxContainer/Settings.visible = not $VBoxContainer/Settings.visible
	$VBoxContainer/Exit.visible = not $VBoxContainer/Exit.visible
	$Label.visible = not $Label.visible


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_continue_pressed() -> void:
	toggle_pause()
