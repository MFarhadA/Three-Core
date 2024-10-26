extends Control

func _ready():
	GlobalAudio._main().stop()
	GlobalAudio._credit().play()

func _input(event):
	if event.is_pressed():
		GlobalAudio._credit().stop()
		SceneManager.go_to_main_menu()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start":
		GlobalAudio._credit().stop()
		SceneManager.go_to_main_menu()
