extends CharacterBody2D

var health = 1

const SPEED = 150.0
const JUMP_VELOCITY = -400.0
@onready var anim = $AnimatedSprite2D
@onready var hitbox = $Hitbox/CollisionShape2D
@onready var hurtbox = $Hurtbox/CollisionShape2D
@onready var timeInvisible = $TimerInvisible
@onready var transition = $black_transisition

var isAttacking : bool = false
var isAttacked : bool = false
var Dead : bool = false
var combo = 0

func _ready() -> void:
	Global.playerBody = self

func _physics_process(delta: float) -> void:
	#print("FPS: ", Engine.get_frames_per_second())
	if Input.is_action_just_pressed("attack") and is_on_floor() and not isAttacking and not Dead:
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
	
	_flip()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not isAttacking and not Dead:
		velocity.y = JUMP_VELOCITY
		
	if not is_on_floor() and not Dead:
		if velocity.y < 0:
			anim.play("jump")
		else:
			velocity += (get_gravity() * delta) * 0.5
			anim.play("fall")
	
	var direction := Input.get_axis("left", "right")
	if direction and not isAttacking and not Dead:
		velocity.x = direction * SPEED
		if is_on_floor():
			anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and not isAttacking and not Dead:
			anim.play("idle")
		
	move_and_slide()

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
	if anim.animation == "death":
		queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if not hurtbox.disabled and area.is_in_group("HitboxEnemies"):
		health -= 1
		if health > 0:
			_invisible()
		else:
			Dead = true
			anim.play("death")

func _invisible():
	hurtbox.disabled = true
	anim.modulate = Color(1, 1, 1, 0.2)
	timeInvisible.start(1)

func _on_timer_invisible_timeout() -> void:
	hurtbox.disabled = false
	anim.modulate = Color(1, 1, 1, 1)
