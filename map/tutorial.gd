extends Node2D

func _ready():
	$ParallaxBG.offset.y = -250
	GlobalAudio._tutorial()

func _on_choose_level_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		Save.skipTutorial = true
		GlobalAudio._tutorial().stop()
		get_tree().change_scene_to_packed(load("res://menu/listLevel/levels.tscn"))


func _on_easter_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		GlobalAudio._tutorial().stop()
		$Easter.play()
		$Player/Camera2D.enabled = false
		$Camera2D.enabled = true


func _on_easter_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		GlobalAudio._tutorial()
		$Easter.stop()
		$Player/Camera2D.enabled = true
		$Camera2D.enabled = false
