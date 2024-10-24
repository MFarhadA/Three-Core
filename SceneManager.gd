extends Node

var main_menu_scene: PackedScene

# This function changes to the specified scene and stores the current scene as the previous one
func change_scene_to_packed(new_scene: PackedScene):
	if get_tree().current_scene:
		get_tree().change_scene_to_packed(new_scene)

# This function directly changes to the main menu scene
func go_to_main_menu():
	if main_menu_scene:
		get_tree().change_scene_to_packed(main_menu_scene)
	else:
		print("Main menu scene not set in SceneManager!")
