extends CanvasLayer

@onready var player = $".."
@onready var jumpCD = $"../Dash/TimerDashCD"

@onready var skill1cd = $"../Skill/TimerSkill1CD"
@onready var skill2cd = $"../Skill/TimerSkill2CD"
@onready var skill3cd = $"../Skill/TimerSkill3CD"

func _process(delta: float) -> void:
	$Jump.text = "Dash : %.2f\nSkill 1 : %.2f\nSkill 2 : %.2f\nSkill 3 : %.2f" % [jumpCD.time_left, skill1cd.time_left, skill2cd.time_left, skill3cd.time_left]
	$Health.text = "Health : %d" % player.health
