extends Control

func _on_tutorial_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Save.skipTutorial = true
	else:
		Save.skipTutorial = false
