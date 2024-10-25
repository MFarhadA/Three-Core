extends CharacterBody2D

var health = 2

const SPEED = 300.0
const chaseSPEED = 100
const JUMP_VELOCITY = -400.0
var direction : Vector2

@onready var anim = $AnimatedSprite2D
@onready var timeKnockback : Timer = $TimerKnockback
var player : CharacterBody2D

var isChase : bool = false
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
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor() and isChase and not Dead:
		anim.play("chase")
		velocity = position.direction_to(player.position) * chaseSPEED
		_flip()
	move_and_slide()

func _on_chase_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		$Chase.play()
		isChase = true
func _on_chase_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtboxPlayer"):
		isChase = false

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		health -= 1
		if health > 0:
			GlobalAudio._hurt()
		else:
			GlobalAudio._enemyDeath()
		_knockback()

func _knockback():
	var knockback = position.direction_to(player.position) * -1
	velocity = Vector2(200 * knockback.x, -200)
	timeKnockback.start(0.1)
func _on_timer_knockback_timeout() -> void:
	velocity = Vector2.ZERO

func _death():
	if health == 0:
		Dead = true
		isChase = false
		anim.play("death")
func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
