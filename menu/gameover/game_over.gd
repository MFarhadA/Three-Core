extends Control

@onready var anim = $AnimationPlayer

func _ready():
	GlobalAudio._game_over()
	anim.play("start")
	await anim.animation_finished
	anim.play("next")

func _input(event):
	if event.is_pressed():
		GlobalAudio._game_over().stop()
		SceneManager.go_to_main_menu()
