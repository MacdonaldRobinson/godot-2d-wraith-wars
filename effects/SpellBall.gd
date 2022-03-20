extends Area2D
class_name SpellBall

export(Vector2) var direction_towards

func _physics_process(delta):
	direction_towards = direction_towards.normalized()
	
	position.x += direction_towards.x * 20
	position.y += direction_towards.y * 20
	

func _on_SpellBall_body_entered(body):
	if body != self.get_parent():
		body.take_damage()
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
