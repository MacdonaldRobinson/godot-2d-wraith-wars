extends Node2D

func _on_Timer_timeout():
	if $Player.is_dead:
		return
		
	var new_enemy:Enemy = $Enemy.duplicate()	
	new_enemy.position.x = $Player.position.x - rand_range(-1920, 1920)
	new_enemy.position.y = $Player.position.y - rand_range(-1080, 1080)
	new_enemy.is_dead = false
	
	self.add_child(new_enemy)
	
	new_enemy._health_bar.value = 100
	
