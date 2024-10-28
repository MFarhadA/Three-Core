extends Control

@onready var parallax = $ParallaxBackground
@onready var anim = $AnimationPlayer

@export var leak : PackedScene
@export var genderuwo : PackedScene
@export var lampor : PackedScene

@onready var leak_button = $VBoxContainer/Leak
@onready var genderuwo_button = $VBoxContainer/Genderuwo
@onready var lampor_button = $VBoxContainer/Lampor

func _ready() -> void:
	if Save.LeakDead == false:
		leak_button.modulate = Color(1, 0.313, 0.25)
	else:
		leak_button.disabled = true
	if Save.GenderuwoDead == false:
		genderuwo_button.modulate = Color(0.809, 1, 0.63)
	else:
		genderuwo_button.disabled = true
	if Save.LamporDead == false:
		lampor_button.modulate = Color(1, 0.78, 0.78)
	else:
		lampor_button.disabled = true
	
	anim.play("start")
	GlobalAudio._tutorial()
	
func _process(delta: float) -> void:
	parallax.scroll_offset.y -= 1000 * delta


func _on_leak_pressed() -> void:
	anim.play("quit")
	GlobalAudio._click()
	await anim.animation_finished
	get_tree().change_scene_to_packed(leak)
	GlobalAudio._tutorial().stop()
func _on_genderuwo_pressed() -> void:
	anim.play("quit")
	GlobalAudio._click()
	await anim.animation_finished
	get_tree().change_scene_to_packed(genderuwo)
	GlobalAudio._tutorial().stop()
func _on_lampor_button_down() -> void:
	anim.play("quit")
	GlobalAudio._click()
	await anim.animation_finished
	get_tree().change_scene_to_packed(lampor)
	GlobalAudio._tutorial().stop()
