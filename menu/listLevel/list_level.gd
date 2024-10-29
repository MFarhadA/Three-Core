extends Node2D

@onready var parallax = $ParallaxBackground
@onready var anim = $AnimationPlayer

@onready var leak_button = $Control/HBoxContainer/Leak
@onready var genderuwo_button = $Control/HBoxContainer/Genderuwo
@onready var lampor_button = $Control/HBoxContainer/Lampor
@onready var end_button = $Control/End

func _ready() -> void:
	anim.play("start")
	
	#Save.LeakDead = true
	#Save.GenderuwoDead = true
	#Save.LamporDead = true
	
	GlobalAudio._tutorial()
	
	genderuwo_button.grab_focus()
	
	if Save.LeakDead == false:
		leak_button.modulate = Color(1, 0.313, 0.25)
	else:
		leak_button.disabled = true
	if Save.GenderuwoDead == false:
		genderuwo_button.modulate = Color(0.809, 1, 0.63)
	else:
		genderuwo_button.disabled = true
	if Save.LamporDead == false:
		lampor_button.modulate = Color(0.71, 0.554, 0.554)
	else:
		lampor_button.disabled = true
	
	if Save.LeakDead == true && Save.GenderuwoDead == true && Save.LamporDead == true:
		print("test")
		$Control/Label.visible = false
		$Control/ColorRect3.visible = true
		end_button.modulate = Color(0.296, 0.366, 0.76)
		end_button.visible = true
		print($Control/ColorRect3.visible)
		GlobalAudio._tutorial().stop()

func _process(delta: float) -> void:
	parallax.scroll_offset.y -= 500 * delta

func _on_leak_pressed() -> void:
	anim.play("quit")
	GlobalAudio._click()
	await anim.animation_finished
	get_tree().change_scene_to_packed(load("res://map/Leak/LeakLevel.tscn"))
	GlobalAudio._tutorial().stop()
func _on_genderuwo_pressed() -> void:
	anim.play("quit")
	GlobalAudio._click()
	await anim.animation_finished
	get_tree().change_scene_to_packed(load("res://map/Genderuwo/GenderuwoLevel.tscn"))
	GlobalAudio._tutorial().stop()
func _on_lampor_button_down() -> void:
	anim.play("quit")
	GlobalAudio._click()
	await anim.animation_finished
	get_tree().change_scene_to_packed(load("res://map/Lampor/LamporLevel.tscn"))
	GlobalAudio._tutorial().stop()


func _on_end_pressed() -> void:
	$Node2D/Open.play()
	await $Node2D/Open.finished
	$Node2D/Gate.play()
	anim.play("end")
	await anim.animation_finished
	get_tree().change_scene_to_packed(load("res://menu/credit/credit.tscn"))
