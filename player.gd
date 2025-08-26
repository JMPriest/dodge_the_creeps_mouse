extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

signal hit

func _ready():
	screen_size = get_viewport_rect().size
	
#func _process(delta):
	## The player's movement vector.
	#var velocity = Vector2.ZERO
	#if Input.is_action_pressed("move_right"):
		#velocity.x += 1
	#if Input.is_action_pressed("move_left"):
		#velocity.x -= 1
	#if Input.is_action_pressed("move_down"):
		#velocity.y += 1
	#if Input.is_action_pressed("move_up"):
		#velocity.y -= 1
#
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.play()
	#else:
		#$AnimatedSprite2D.stop()
	#
	## new position for player
	#position += velocity * delta
	#position = position.clamp(Vector2.ZERO, screen_size)
	#
	#if velocity.x != 0:
		#$AnimatedSprite2D.animation = "walk"
		#$AnimatedSprite2D.flip_v = false
		## See the note below about the following boolean assignment.
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	#elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		#$AnimatedSprite2D.flip_v = velocity.y > 0
		
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
		
	var relative = event.relative
	if relative.is_zero_approx():
		$AnimatedSprite2D.stop()
	else:
		$AnimatedSprite2D.play()
		
	position += relative
	position = position.clamp(Vector2.ZERO, screen_size)

	if relative.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = relative.x < 0
	elif relative.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = relative.y > 0


func _on_body_entered(body: Node2D) -> void:
	# Player disappears after being hit.
	hide() 
	hit.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$CollisionShape2D.disabled = false
