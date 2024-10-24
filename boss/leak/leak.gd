extends CharacterBody2D

var health = 20

var move_speed : float = 100.0

var isAttacking : bool = false
var Dead : bool = false

@onready var anim = $AnimatedSprite2D
@onready var timeSkill = $TimerSkill
@onready var hitbox = $Hitbox/CollisionShape2D
@export var skill2p : PackedScene
@export var skill3p : PackedScene
var player : CharacterBody2D

func _physics_process(delta: float) -> void:
	player = Global.playerBody
	if not Dead and not isAttacking:
		await get_tree().create_timer(0.01).timeout
		anim.play("idle")
		isAttacking = true
		timeSkill.start(2)
	if health <= 0:
		_death()
	move_and_slide()
	
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

func _skill2():
	anim.play("skill2")
	await anim.animation_finished
	var projectile2 = skill2p.instantiate()
	projectile2.position = position
	projectile2.direction = Vector2.LEFT
	get_tree().current_scene.add_child(projectile2)
	anim.play("skill22")

func _skill3():
	var original_pos = position
	var target_pos = position + Vector2(0, -100)
	anim.play("skill3")
	while position.y > target_pos.y + 1:
		position.y = lerp(position.y, target_pos.y, move_speed * get_process_delta_time())
		await get_tree().create_timer(0.01).timeout
	_skill3p()
	anim.play("skill33")
	await anim.animation_finished
	while position.y < original_pos.y - 1:
		position.y = lerp(position.y, original_pos.y, move_speed * get_process_delta_time())
		await get_tree().create_timer(0.01).timeout
	position.y = original_pos.y
	isAttacking = false
func _skill3p():
	if player != null and not Dead:
		var projectile3 = skill3p.instantiate()
		projectile3.position = player.position + Vector2(0,-800)
		projectile3.direction = Vector2.DOWN
		get_tree().current_scene.add_child(projectile3)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		var tween = create_tween()
		var start_color = Color(1, 1, 1)
		var end_color = Color(1, 0, 0)
		tween.tween_property(self, "modulate", end_color, 0.05)
		tween.tween_property(self, "modulate", start_color, 0.05).set_delay(0.05)
		health -= 1

func _death():
	Dead = true
	anim.play("death")

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death": queue_free()
	if anim.animation == "skill11":
		hitbox.disabled = true
		isAttacking = false
	if anim.animation == "skill22":
		isAttacking = false
