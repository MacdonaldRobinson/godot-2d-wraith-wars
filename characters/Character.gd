extends KinematicBody2D
class_name Character

func get_class():
	return "Character"

var vector:Vector2
var speed:float = 30000
var spell_ball = preload("res://effects/SpellBall.tscn")
var _animated_sprite:AnimatedSprite
var _animation_player:AnimationPlayer
var _health_bar:ProgressBar
var is_player_controlled = false
var player:Character
var fire_rate:int = 30
var _fire_timer:int = 0
var is_dead:bool = false

func _ready():	
	for child in get_tree().root.get_child(0).get_children():
		if child.get_class() == self.get_class():			
			if child.is_player_controlled == true:
				player = child

func init(animated_sprite:AnimatedSprite, animation_player:AnimationPlayer, health_bar:ProgressBar):
	_animated_sprite = animated_sprite
	_animation_player = animation_player
	_health_bar = health_bar

func _physics_process(delta):
	if is_dead:
		return
	
	if is_player_controlled:
		player_control(delta)
	else:
		ai_controlled(delta)
		
func player_control(delta):
	if is_dead:
		return	
	
	var left_right = Input.get_action_strength("right") - Input.get_action_strength("left")
	var up_down = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	var direction:Vector2 = Vector2(left_right, up_down).normalized()
	
	move(direction, delta)
	
	if Input.is_action_just_pressed("shoot"):
		direction.y = 0
		
		if _animated_sprite.flip_h:			
			direction.x = -1
		else:
			direction.x = 1
			
		shoot(direction)
		
func ai_controlled(delta):
	if is_dead or !player or player.is_dead:
		return
		
	print(is_dead)
		
	var diff:Vector2 = self.position - player.position	
	diff = -diff.normalized()
	
	speed = 10000
	move(diff, delta)
	
	if _fire_timer == fire_rate:
		shoot(diff)
		_fire_timer = 0
	
	_fire_timer+=1
	
	
func shoot(direction:Vector2):
	var spell_ball_instance:SpellBall = spell_ball.instance()
	spell_ball_instance.set_as_toplevel(true)
	spell_ball_instance.position.x = self.position.x
	spell_ball_instance.position.y = self.position.y 
	spell_ball_instance.direction_towards = direction.normalized()
		
	add_child(spell_ball_instance)
		

func take_damage():
	if is_dead:
		return
		
	_animation_player.play("TakeDamage")
	_health_bar.value -=10
	
	if _health_bar.value == 0:
		die()
	
func die():
	_animated_sprite.frames.set_animation_loop("Dying", false)
	_animated_sprite.play("Dying")
	is_dead = true

	

func move(direction:Vector2, delta):
	direction = direction.normalized()
	
	if direction.x < 0:
		_animated_sprite.flip_h = true
	elif direction.x > 0:
		_animated_sprite.flip_h = false

	if direction.x == 0 and direction.y == 0:
		_animated_sprite.play("Idle")
	else:
		_animated_sprite.play("Walking")
	
	var new_vector = direction * speed * delta
	var smoot_motion = lerp(vector, new_vector, 0.1)
	vector = move_and_slide(smoot_motion, Vector2.UP)
