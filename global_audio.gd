extends Node

#music
@onready var main_music = $Music/Mainmenu
@onready var credit_music = $Music/Credit
@onready var game_over = $Music/Gameover
@onready var map_music = $Music/Map
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

func _credit():
	credit_music.play()
	return credit_music

func _game_over():
	game_over.play()
	return game_over

func _map():
	map_music.play()
	return map_music

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
