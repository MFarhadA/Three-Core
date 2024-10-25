extends CharacterBody2D

var health = 1

const SPEED = 150.0
const dashSPEED = 1000.0
const JUMP_VELOCITY = -400.0

@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var timeInvisible = $TimerInvisible
@onready var timeDash = $Dash/TimerDash
@onready var timeDashCD = $Dash/TimerDashCD
@onready var timeDashing = $Dash/TimerDashInv
@onready var transition = $black_transisition

@onready var skill1cd = $Skill/TimerSkill1CD
@onready var skill2cd = $Skill/TimerSkill2CD
@onready var skill3cd = $Skill/TimerSkill3CD

var isskill1cd : bool = false
var isskill2cd : bool = false
var isskill3cd : bool = false

@export var skill1p : PackedScene
@export var ghost_node : PackedScene

var isAttacking : bool = false
var isDashCD : bool = false
var isDashing : bool = false
var isAttacked : bool = false
var Dead : bool = false
var combo = 0

var isSkill2 : bool = false

func _ready() -> void:
	Global.playerBody = self

func _physics_process(delta: float) -> void:
	#print("FPS: ", Engine.get_frames_per_second())
	if Input.is_action_just_pressed("dash") and not isDashing and not isDashCD and not isAttacking and not Dead:
		_dash()
	
	if is_on_floor() and not isAttacking and not Dead and not isDashing:
		if Input.is_action_just_pressed("attack"):
			if combo == 0:
				anim.play("basic1")
				isAttacking = true
				hitbox.disabled = false
				combo = 1
			elif combo == 1:
				anim.play("basic2")
				isAttacking = true
				hitbox.disabled = false
				combo = 2
		if Input.is_action_just_pressed("skill1") and not isskill1cd:
			skill1cd.start(5)
			anim.play("skill1")
			isskill1cd = true
			isAttacking = true
			_skill1()
		if Input.is_action_just_pressed("skill2") and not isskill2cd:
			skill2cd.start(30)
			anim.play("skill2")
			isskill2cd = true
			isAttacking = true
			_skill2()
		if Input.is_action_just_pressed("skill3") and not isskill3cd:
			skill3cd.start(120)
			anim.play("skill3")
			isskill3cd = true
			isAttacking = true
			_skill3()
	
	_flip()
	

	if Input.is_action_just_pressed("jump") and is_on_floor() and not isAttacking and not Dead:
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor() and not Dead and not isDashing:
		if velocity.y < 0:
			velocity += get_gravity() * delta
			anim.play("jump")
		else:
			velocity += (get_gravity() * delta) + (get_gravity() * delta) * 0.5
			anim.play("fall")
	
	
	var direction := Input.get_axis("left", "right")
	if not isAttacking and not Dead:
		if direction:
			if isDashing:
				velocity.y = 0
				velocity.x = direction * dashSPEED
			else:
				velocity.x = direction * SPEED
				if is_on_floor():
					anim.play("walk")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and not isAttacking and not Dead and not isDashing:
				anim.play("idle")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _dash():
	timeDash.start(0.1)
	timeDashCD.start(1)
	timeDashing.start(0.5)
	isDashing = true
	hurtbox.disabled = true
	isDashCD = true
	anim.play("dash")
func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position, anim.scale, anim.flip_h)
	get_tree().current_scene.add_child(ghost)
func _on_timer_dash_inv_timeout() -> void:
	timeDash.stop()
func _on_timer_dash_timeout() -> void:
	add_ghost()
	if not isSkill2:
		hurtbox.disabled = false
	isDashing = false
func _on_timer_dash_cd_timeout() -> void:
	isDashCD = false

func _flip():
	if velocity.x != 0:
		var facing_left = velocity.x < 0
		anim.flip_h = facing_left
		var hitbox_position = $Hitbox/CollisionShape2D.position
		if facing_left:
			hitbox_position.x = -abs(hitbox_position.x)
		else:
			hitbox_position.x = abs(hitbox_position.x)
		$Hitbox/CollisionShape2D.position = hitbox_position

func _skill1():
	var projectile1 = skill1p.instantiate()
	projectile1.position = position
	if anim.flip_h :
		projectile1.direction = Vector2.LEFT
	else:
		projectile1.direction = Vector2.RIGHT
	get_tree().current_scene.add_child(projectile1)

func _skill2():
	isSkill2 = true
	hurtbox.disabled = true
	anim.modulate = Color(0.859, 0.137, 0.137)
	timeInvisible.start(5)
	
func _skill3():
	health += 1

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "basic1":
		hitbox.disabled = true
		isAttacking = false
		combo = 1
		await get_tree().create_timer(0.5).timeout
		combo = 0
	elif anim.animation == "basic2":
		isAttacking = false
		combo = 0
		hitbox.disabled = true
	if anim.animation == "skill1" or anim.animation == "skill2" or anim.animation == "skill3":
		isAttacking = false
	if anim.animation == "death":
		_gameOver()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not hurtbox.disabled and area.is_in_group("HitboxEnemies"):
		health -= 1
		if health > 0:
			_invisible()
		else:
			Dead = true
			anim.play("death")

func _gameOver():
	transition.play("quit_transisition")
	await transition.animation_finished
	SceneManager.go_to_main_menu()

func _invisible():
	hurtbox.disabled = true
	anim.modulate = Color(1, 1, 1, 0.2)
	timeInvisible.start(1)
func _on_timer_invisible_timeout() -> void:
	isSkill2 = false
	hurtbox.disabled = false
	anim.modulate = Color(1, 1, 1, 1)


func _on_timer_skill_1cd_timeout() -> void:
	isskill1cd = false


func _on_timer_skill_2cd_timeout() -> void:
	isskill2cd = false


func _on_timer_skill_3cd_timeout() -> void:
	isskill3cd = false
