extends CharacterBody2D

var health = 2

const SPEED = 10
const chaseSPEED = 50

var direction : Vector2
var isChase : bool = false
var isAttacked : bool = false

@onready var roaming : Timer = $TimerRoam
@onready var anim = $AnimatedSprite2D
var player : CharacterBody2D

func _ready():
	isChase = false

func _process(delta):
	move(delta)
	_death()
	_flip()

func _flip():
	if velocity.x != 0:
		var facing_right = velocity.x > 0
		anim.flip_h = facing_right

func move(delta):
	if isChase and not isAttacked:
		anim.play("chase")
		player = Global.playerBody
		velocity = position.direction_to(player.position) * chaseSPEED
	elif not isChase and not isAttacked:
		anim.play("idle")
		velocity = lerp(velocity, SPEED * direction, delta)
	move_and_slide()

func _on_timer_timeout():
	roaming.wait_time = choose([1.0, 1.5, 2.0])
	if not isChase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
func choose(array):
	array.shuffle()
	return array.front()

func _on_chase_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = true
func _on_chase_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = false

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		isAttacked = true
		health -= 1

func _death():
	if health == 0:
		anim.play("death")
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
