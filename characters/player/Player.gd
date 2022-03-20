extends Character
class_name Player

func _ready():
	is_player_controlled = true
	init($AnimatedSprite, $AnimationPlayer,$HealthBar)

func take_damage():
	if is_dead:
		return
		
	_animation_player.play("TakeDamage")
	_health_bar.value -=1
	
	if _health_bar.value == 0:
		die()
