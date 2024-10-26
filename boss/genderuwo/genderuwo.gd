extends CharacterBody2D

var health = 40

var chaseSPEED : float = 200.0
var JUMP_VELOCITY = -600.0


var isAttacking : bool = false
var isJump :bool = false
var Dead : bool = false

@onready var anim = $AnimatedSprite2D
@onready var timeSkill = $TimerSkill
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var hitbox2 = $Hitbox/CollisionShape2D2
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var collission = $CollisionShape2D
@export var skill2p : PackedScene
var player : CharacterBody2D

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	if isJump:
		hitbox2.disabled = false
		if is_on_floor():
			$Node/Skill33.play()
			anim.play("idle")
			velocity.x = 0
			isJump = false
			isAttacking = false
			hitbox2.disabled = false
	else:
		hitbox2.disabled = true
		
	if Global.playerBody != null:
		player = Global.playerBody
		if is_on_floor():
			_facing()
	if not Dead and not isAttacking:
		await get_tree().create_timer(0.01).timeout
		anim.play("idle")
		isAttacking = true
		timeSkill.start(2)
	if health <= 0:
		timeSkill.stop()
		_death()
	move_and_slide()

func _facing():
	var hitbox_position = hitbox.position
	var hitbox2_position = hitbox2.position
	var hurtbox_position = hurtbox.position
	var collission_position = collission.position
	if position.x > player.position.x:
		anim.flip_h = false
		anim.offset.x = 0
		hitbox_position.x = -abs(hitbox_position.x)
		hitbox2_position.x = -abs(hitbox2_position.x)
		hurtbox_position.x = -abs(hurtbox_position.x)
		collission_position.x = -abs(collission_position.x)
	else:
		anim.flip_h = true
		anim.offset.x = 45
		hitbox_position.x = abs(hitbox_position.x)
		hitbox2_position.x = abs(hitbox2_position.x)
		hurtbox_position.x = abs(hurtbox_position.x)
		collission_position.x = abs(collission_position.x)
	hitbox.position = hitbox_position
	hitbox2.position = hitbox2_position
	hurtbox.position = hurtbox_position
	collission.position = collission_position

func _on_timer_skill_timeout() -> void:
	_chooseSkill()
	
func _chooseSkill():
	var choose = randi_range(1,3)
	match choose:
		1:
			_skill1()
		2:
			_skill2()
		3:
			_skill3()

func _skill1():
	anim.play("skill1")
	await anim.animation_finished
	hitbox.disabled = false
	anim.play("skill11")
	$Node/Skill1.play()

func _skill2():
	anim.play("skill2")
	await anim.animation_finished
	var projectile2 = skill2p.instantiate()
	projectile2.position = position
	if position.x < player.position.x:
		projectile2.direction = Vector2.RIGHT
		projectile2.scale.x = -1
	else:
		projectile2.direction = Vector2.LEFT
		projectile2.scale.x = 1
	get_tree().current_scene.add_child(projectile2)
	anim.play("skill22")
	$Node/Skill2.play()
	hitbox2.disabled = false

func _skill3():
	anim.play("skill3")
	$Node/Skill3.play()
	var dir_player = position.direction_to(player.position)
	velocity.x = dir_player.x * chaseSPEED
	velocity.y = JUMP_VELOCITY
	await get_tree().create_timer(0.2).timeout
	isJump = true

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		var tween = create_tween()
		var start_color = Color(1, 1, 1)
		var end_color = Color(1, 0, 0)
		tween.tween_property(self, "modulate", end_color, 0.05)
		tween.tween_property(self, "modulate", start_color, 0.05).set_delay(0.05)
		health -= 1
		if health > 0:
			GlobalAudio._hurt()

func _death():
	Dead = true
	GlobalAudio._enemyDeath()
	anim.play("death")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death": queue_free()
	if anim.animation == "skill11":
		hitbox.disabled = true
		isAttacking = false
	if anim.animation == "skill22":
		hitbox2.disabled = true
		isAttacking = false
