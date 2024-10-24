extends Control

@export var main_menu : PackedScene

func _ready():
	$logoAnim.play("logoKuroko")
	$anyKeyAnim.play("TEKAN")

func _input(event):
	if event.is_pressed():
		get_tree().change_scene_to_packed(main_menu)
