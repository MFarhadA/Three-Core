extends Area2D

var direction : Vector2 = Vector2.RIGHT
var speed : float = 400
@onready var anim = $AnimatedSprite2D
@onready var collisionShape = $CollisionShape2D

func _physics_process(delta: float) -> void:
	anim.play("default")
	position += direction * speed * delta
	_flip()
	
func _flip():
	if direction.x != 0:
		var hitbox_position = collisionShape.position
		if direction.x > 0:
			hitbox_position.x = -abs(hitbox_position.x)
		else:
			hitbox_position.x = abs(hitbox_position.x)
		collisionShape.position = hitbox_position

func _on_screen_exited() -> void:
	queue_free()
