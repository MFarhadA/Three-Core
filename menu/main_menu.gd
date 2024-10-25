extends Control

@export var start : PackedScene
@export var setting : PackedScene
@export var credit : PackedScene
@export var quit : PackedScene
var Scene = SceneManager
@onready var parallax = $ParallaxBG

func _ready() -> void:
	$black_transisition.play("start_transisition")
	$VBoxContainer/startButton.grab_focus()

func _process(delta: float) -> void:
	parallax.scroll_offset.x -= 100 * delta

func _on_start_button_pressed() -> void:
	$black_transisition.play("quit_transisition")
	await $black_transisition.animation_finished
	get_tree().change_scene_to_packed(start)

func _on_setting_button_pressed() -> void:
	Scene.go_to_main_menu()

func _on_credit_button_pressed() -> void:
	Scene.go_to_main_menu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
