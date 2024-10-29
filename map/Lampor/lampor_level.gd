extends Node2D

var boss_area_entered = false

func _ready():
	GlobalAudio._map()
	if $lampor != null:
		$lampor.set_physics_process(false)
	_modulate($ParallaxBG/parallax0)
	_modulate($ParallaxBG/parallax00)
	_modulate($ParallaxBG/parallax1)
	_modulate($ParallaxBG/parallax11)
	_modulate($ParallaxBG/parallax2)
	_modulate($ParallaxBG/parallax22)
	_modulate($ParallaxBG/parallax3)
	_modulate($ParallaxBG/parallax33)
	$TileMapLayer.modulate = Color(0.61, 0.588, 0.573)
	
	$ParallaxBG.offset.y = -200

func _modulate(layer):
	layer.modulate = Color(0.314, 0.286, 0.286)

func _on_boss_time_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer") and not boss_area_entered:
		boss_area_entered = true
		GlobalAudio._map().stop()
		$Lampor.play()
		$ParallaxBG.offset.y = 30
		$Player/Camera2D.enabled = false
		$Camera2D.enabled = true
		if $lampor != null:
			$lampor.set_physics_process(true)
