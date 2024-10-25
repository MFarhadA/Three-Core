extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tilemapLayer = $TileMapLayer
	tilemapLayer.modulate = Color(0.6, 0.21, 0.15)
	var parallax = $Parallax
	parallax.modulate = Color(0.44, 0.154, 0.11)
