extends Node2D

var boss_area_entered = false

func _ready():
	GlobalAudio._map()
	if $leak != null:
		$leak.set_physics_process(false)
	_modulate($ParallaxBG/parallax0)
	_modulate($ParallaxBG/parallax00)
	_modulate($ParallaxBG/parallax1)
	_modulate($ParallaxBG/parallax11)
	_modulate($ParallaxBG/parallax2)
	_modulate($ParallaxBG/parallax22)
	_modulate($ParallaxBG/parallax3)
	_modulate($ParallaxBG/parallax33)
	$TileMapBG.modulate = Color(0.63, 0.221, 0.157)
	$TileMapLayer.modulate = Color(0.6, 0.21, 0.15)
	
	$ParallaxBG.offset.y = -200

func _modulate(layer):
	layer.modulate = Color(0.44, 0.154, 0.11)

func _on_boss_time_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer") and not boss_area_entered:
		boss_area_entered = true
		GlobalAudio._map().stop()
		$Leak.play()
		$ParallaxBG.offset.y = 30
		print("boss")
		$Player/Camera2D.enabled = false
		$CameraBoss.enabled = true
		if $leak != null:
			$leak.set_physics_process(true)
