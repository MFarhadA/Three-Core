extends Control

@export var start : PackedScene
@export var start1 : PackedScene
@export var setting : PackedScene
@export var credit : PackedScene
@export var quit : PackedScene
var Scene = SceneManager
@onready var parallax = $ParallaxBG

func _ready() -> void:
	$VBoxContainer/startButton.grab_focus()

func _process(delta: float) -> void:
	parallax.scroll_offset.x -= 100 * delta

func _on_start_button_pressed() -> void:
	await GlobalAudio._click().finished
	$black_transisition.play("quit_transisition")
	await $black_transisition.animation_finished
	GlobalAudio._main().stop()
	if Save.skipTutorial == true:
		get_tree().change_scene_to_packed(start)
	else:
		get_tree().change_scene_to_packed(start1)

func _on_setting_button_pressed() -> void:
	GlobalAudio._click()
	$menu.play("setting_in")

func _on_credit_button_pressed() -> void:
	await GlobalAudio._click().finished
	get_tree().change_scene_to_packed(credit)

func _on_quit_button_pressed() -> void:
	await GlobalAudio._enemyDeath().finished
	get_tree().quit()

func _on_back_setting_pressed() -> void:
	GlobalAudio._click()
	print("Save.skipTutorial:", Save.skipTutorial)
	await GlobalAudio._click().finished
	$menu.play("setting_out")
