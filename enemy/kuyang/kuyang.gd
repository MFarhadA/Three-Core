extends CharacterBody2D

var health = 2

const SPEED = 10
const chaseSPEED = 100

var direction : Vector2
var isChase : bool = false
var isAttacked : bool = false
var Dead : bool = false

@onready var timeRoaming : Timer = $TimerRoam
@onready var timeKnockback : Timer = $TimerKnockback
@onready var anim = $AnimatedSprite2D
var player : CharacterBody2D

func _process(delta):
	player = Global.playerBody
	move(delta)
	_death()

#flip the sprite
func _flip():
	if velocity.x != 0:
		var facing_right = velocity.x > 0
		anim.flip_h = facing_right

func move(delta):
	if isChase and not isAttacked and not Dead:
		anim.play("chase")
		velocity = position.direction_to(player.position) * chaseSPEED
		_flip()
	elif not isChase and not isAttacked and not Dead:
		anim.play("idle")
		velocity = lerp(velocity, SPEED * direction, delta)
		_flip()
	move_and_slide()

#Roaming
func _on_timer_timeout():
	timeRoaming.wait_time = choose([1.0, 1.5, 2.0])
	if not isChase:
		direction = choose([Vector2.RIGHT, Vector2.LEFT])
func choose(array):
	array.shuffle()
	return array.front()

#Hit&Hurt
func _on_chase_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = true
func _on_chase_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		health -= 1
		isAttacked = true
		_knockback()

#knockback
func _knockback():
	if isAttacked:
		var knockback = position.direction_to(player.position) * -1
		velocity = Vector2(500 * knockback.x, -500)
		timeKnockback.start(0.1)
func _on_timer_knockback_timeout() -> void:
	velocity = Vector2.ZERO
	isAttacked = false

#death
func _death():
	if health == 0:
		Dead = true
		isChase = false
		anim.play("death")
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
