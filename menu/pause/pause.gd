extends Control

func _ready() -> void:
	$HBoxContainer/resume.grab_focus()

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("pause"):
		if not visible:
			visible = true
			get_tree().paused = true
		else:
			visible = false
		GlobalAudio._click()


func _on_resume_pressed() -> void:
	get_tree().paused = false
	GlobalAudio._click()
	visible = false


func _on_quit_pressed() -> void:
	GlobalAudio._enemyDeath()
	get_tree().paused = false
	GlobalAudio._main().stop()
	GlobalAudio._credit().stop()
	GlobalAudio._game_over().stop()
	GlobalAudio._map().stop()
	GlobalAudio._tutorial().stop()
	visible = false
	get_tree().change_scene_to_packed(load("res://menu/splashScreen.tscn"))
