extends Character
class_name Wraith1

func _ready():
	is_player_controlled = true
	init($AnimatedSprite, $AnimationPlayer,$HealthBar)
