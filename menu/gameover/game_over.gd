extends Control

@onready var anim = $AnimationPlayer

func _ready():
	anim.play("start")
	await anim.animation_finished
	anim.play("next")

func _input(event):
	if event.is_pressed():
		SceneManager.go_to_main_menu()
