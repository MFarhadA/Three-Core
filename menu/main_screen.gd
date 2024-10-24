extends Control

@export var main_menu : PackedScene

func _ready():
	$KurokoAnim.play("kuroko_anim")
	$TCAnim.play("tc_animation")

func _input(event):
	if event.is_pressed():
		get_tree().change_scene_to_packed(main_menu)
