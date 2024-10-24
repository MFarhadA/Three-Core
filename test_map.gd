extends Node2D

var player: CharacterBody2D
@onready var anim = $black_transisition
@export var main_screen: PackedScene
var isTransition : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = Global.playerBody

func _process(delta: float) -> void:
	if player == null and not isTransition:
		anim.play("quit_transisition")
		print("player null")
		isTransition = true

func _on_black_transisition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "quit_transisition":
		print("anim finish")
		get_tree().change_scene_to_packed(main_screen)
