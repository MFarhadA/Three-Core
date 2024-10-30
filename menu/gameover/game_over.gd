extends Control

@onready var anim = $AnimationPlayer

func _ready():
	GlobalAudio._main().stop()
	GlobalAudio._credit().stop()
	GlobalAudio._game_over().stop()
	GlobalAudio._map().stop()
	GlobalAudio._tutorial().stop()
	GlobalAudio._game_over()
	anim.play("start")
	await anim.animation_finished
	anim.play("next")
	Save.health = 3
	Save.revive = 3

func _input(event):
	if event.is_pressed():
		GlobalAudio._game_over().stop()
		SceneManager.go_to_main_menu()
