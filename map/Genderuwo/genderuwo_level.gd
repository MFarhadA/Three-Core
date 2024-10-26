extends Node2D

var bossTime
var boss_area_entered = false

func _ready():
	GlobalAudio._map()
	if $genderuwo != null:
		$genderuwo.set_physics_process(false)
	_modulate($ParallaxBG/parallax0)
	_modulate($ParallaxBG/parallax00)
	_modulate($ParallaxBG/parallax1)
	_modulate($ParallaxBG/parallax11)
	_modulate($ParallaxBG/parallax2)
	_modulate($ParallaxBG/parallax22)
	_modulate($ParallaxBG/parallax3)
	_modulate($ParallaxBG/parallax33)
	$TileMapBG.modulate = Color(0.427, 0.38, 0.357)
	$TileMapLayer.modulate = Color(0.435, 0.38, 0.294)

func _modulate(layer):
	layer.modulate = Color(0.288, 0.48, 0.314)

func _on_boss_time_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer") and not boss_area_entered:
		boss_area_entered = true
		GlobalAudio._map().stop()
		$Genderuwo.play()
		$Player/Camera2D.enabled = false
		$CameraBoss.enabled = true
		if $genderuwo != null:
			$genderuwo.set_physics_process(true)
