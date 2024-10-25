extends Control

@export var main_menu : PackedScene

func _ready():
	$FullIcon.visible = false
	$Label.visible = false
	$splashAnim.play("splashLogo")
	await $splashAnim.animation_finished
	$splashAnim.play("tombolAnim")

func _input(event):
	if event.is_pressed():
		get_tree().change_scene_to_packed(main_menu)
