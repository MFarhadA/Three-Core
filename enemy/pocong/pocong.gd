extends CharacterBody2D

var health = 2

const SPEED = 300.0
const chaseSPEED = 100
const JUMP_VELOCITY = -500.0
var direction : Vector2

@onready var anim = $AnimatedSprite2D
@onready var timeKnockback : Timer = $TimerKnockback
@onready var timeJump : Timer = $TimerJump
var player : CharacterBody2D

var isChase : bool = false
var isAttacked : bool = false
var isJump : bool = false
var Dead : bool = false

func _process(delta):
	player = Global.playerBody
	move(delta)
	_death()

func _flip():
	if velocity.x != 0:
		var facing_right = velocity.x > 0
		anim.flip_h = facing_right

func move(delta):
	if not Dead:
		if is_on_floor():
			if isChase and not isAttacked and not isJump:
				_jump()
				anim.play("jump")
				timeJump.start(2.0)
				isJump = true
			elif not isAttacked:
				anim.play("idle")
				velocity.x = 0
		else:
			velocity += get_gravity() * delta
	move_and_slide()

func _jump():
	var dir_player = position.direction_to(player.position)
	GlobalAudio._jump()
	velocity.x = dir_player.x * chaseSPEED
	velocity.y = JUMP_VELOCITY
	_flip()
func _on_timer_jump_timeout() -> void:
	isJump = false
	
func _on_chase_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = true
func _on_chase_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Falling"):
		queue_free()
	if area.is_in_group("HitboxPlayer"):
		health -= 1
		isAttacked = true
		if health > 0:
			GlobalAudio._hurt()
		else:
			GlobalAudio._enemyDeath()
		_knockback()

func _knockback():
	var knockback = position.direction_to(player.position) * -1
	velocity = Vector2(200 * knockback.x, -200)
	timeKnockback.start(0.5)
func _on_timer_knockback_timeout() -> void:
	velocity = Vector2.ZERO
	isAttacked = false

func _death():
	if health == 0:
		Dead = true
		isChase = false
		anim.play("death")
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
