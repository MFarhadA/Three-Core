extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction : Vector2
@onready var anim = $AnimatedSprite2D

var isChase : bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		print("x")
		_death()

func _death():
	anim.play("death")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
