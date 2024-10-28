extends Node2D

@export var listLevel : PackedScene

func _ready():
	$ParallaxBG.offset.y = -250
	GlobalAudio._tutorial()

func _on_choose_level_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		$AnimationPlayer.play("quit")
		GlobalAudio._tutorial().stop()
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_packed(listLevel)
