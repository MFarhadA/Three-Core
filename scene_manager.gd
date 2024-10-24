extends Node

var main_menu_scene : PackedScene

func _ready():
	main_menu_scene = preload("res://menu/main_screen.tscn")

func go_to_main_menu():
	if main_menu_scene != null:
		get_tree().change_scene_to_packed(main_menu_scene)
	else:
		print("Main menu scene not set!")
