extends Node

#music
@onready var main_music = $Music/Mainmenu

#sfx
@onready var click = $SFX/click
@onready var hurt = $SFX/Hurt
@onready var jump = $SFX/Jump
@onready var death_enemy = $SFX/DeathEnemy
@onready var shoot = $SFX/Shoot
@onready var death = $SFX/Death

func _main():
	main_music.play()
	return main_music

func _click():
	click.play()
	return click
func _hurt():
	hurt.play()
	return hurt
func _jump():
	jump.play()
	return jump
func _enemyDeath():
	death_enemy.play()
	return death_enemy
func _shoot():
	shoot.play()
	return shoot
func _death():
	death.play()
	return death
