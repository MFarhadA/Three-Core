extends CharacterBody2D

var health = 3
const SPEED = 300.0

@onready var anim = $AnimatedSprite2D
@onready var raycast = $RayCast2D
@onready var timeBullet = $TimerBullet
@onready var timeKnockback = $TimerKnockback
@export var ammo : PackedScene

var isChase : bool = false
var isAttacking : bool = false
var Dead : bool = false
var player : CharacterBody2D

func _process(delta):
	if Global.playerBody != null:
		player = Global.playerBody
		_facing()
	if Dead:
		await anim.animation_finished
		anim.play("death")
	if not Dead:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if is_on_floor() and not isAttacking:
			anim.play("idle")
		_facing()
		_aim()
		_check_player_collission()
		_death()
	move_and_slide()

func _facing():
	if position.x > player.position.x:
		anim.flip_h = false
	else:
		anim.flip_h = true

func _aim():
	if player != null and not Dead:
		raycast.target_position = to_local(player.position)
	
func _check_player_collission():
	if not Dead:
		if isChase and raycast.is_colliding() and raycast.get_collider() == player:
			if timeBullet.is_stopped():
				timeBullet.start(3)
		else:
			if not isChase:
				timeBullet.stop()

func _on_timer_bullet_timeout() -> void:
	isAttacking = true
	anim.play("cast")
	$SFX/cast.play()
	
func _shoot():
	if not Dead:
		var bullet = ammo.instantiate()
		bullet.position = position
		var direction_vector = (raycast.target_position).normalized()
		bullet.direction = direction_vector
		bullet.rotation = direction_vector.angle()
		get_tree().current_scene.add_child(bullet)
		anim.play("cast1")

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
		if health > 0:
			GlobalAudio._hurt()
		else:
			GlobalAudio._enemyDeath()
		_knockback()

func _knockback():
	var knockback = position.direction_to(player.position) * -1
	velocity = Vector2(100 * knockback.x, -100)
	timeKnockback.start(0.5)
func _on_timer_knockback_timeout() -> void:
	velocity = Vector2.ZERO

func _death():
	if health == 0:
		Dead = true
		isChase = false
		anim.play("death")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "cast":
		_shoot()
	elif anim.animation == "cast1":
		isAttacking = false
	if anim.animation == "death":
		queue_free()
