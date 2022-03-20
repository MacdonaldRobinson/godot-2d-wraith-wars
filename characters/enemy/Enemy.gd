extends Character
class_name Enemy

func _ready():
	init($AnimatedSprite, $AnimationPlayer,$HealthBar)

func take_damage():
	if is_dead:
		return
		
	_animation_player.play("TakeDamage")
	_health_bar.value -=10
	
	if _health_bar.value == 0:
		die()
