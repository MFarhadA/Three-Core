extends CheckBox


func _on_toggled(toggled_on: bool) -> void:
	GlobalAudio._click()
	print("Toggled:", toggled_on)
	if toggled_on:
		Save.skipTutorial = false
	else:
		Save.skipTutorial = true
	print("Save.skipTutorial:", Save.skipTutorial)
