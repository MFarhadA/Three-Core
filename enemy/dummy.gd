extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
func _ready() -> void:
	anim.modulate = Color(0.247, 0.318, 0.71)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("HitboxPlayer"):
		anim.play("death")
		GlobalAudio._enemyDeath()


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
