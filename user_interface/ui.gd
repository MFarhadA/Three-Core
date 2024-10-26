extends CanvasLayer
@onready var player = $".."
@onready var skill1cd = $"../Skill/TimerSkill1CD"
@onready var skill2cd = $"../Skill/TimerSkill2CD"
@onready var skill3cd = $"../Skill/TimerSkill3CD"

@onready var skill1 = $skill1
@onready var skill2 = $skill2
@onready var skill3 = $skill3

@onready var skill1text = $skill1/skill1
@onready var skill2text = $skill2/skill2
@onready var skill3text = $skill3/skill3

func _process(delta: float) -> void:
	
	$up1.text = str(player.revive)
	$health1.text = str(player.health)
	
	_cooldown(skill1cd, skill1text)
	_cooldown(skill2cd, skill2text)
	_cooldown(skill3cd, skill3text)
	_used(skill1cd,skill1)
	_used(skill2cd,skill2)
	_used(skill3cd,skill3)

func _cooldown(skillcd, label):
	if skillcd.time_left > 0:
		label.text = str(round(skillcd.time_left))
	else:
		label.text = ""
	
func _used(skillcd, skill):
	if skillcd.is_stopped():
		skill.modulate = Color(1, 1, 1)
	else:
		skill.modulate = Color(1, 1, 1, 0.196)
