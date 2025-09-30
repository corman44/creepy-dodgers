extends Area2D

signal hit

@export var speed = 400
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _on_body_entered(node: CollisionObject2D) -> void:
	if node.collision_layer == 1:
		# it's a creep
		print("Layer1 Collision w/ Player")
		hide() # Player disappears after being hit.
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)

	elif node.collision_layer == 2:
		print("Layer2 Collision w/ Player")
		speed += 400
		print("Player Speed: ", speed)
		node.hide()
		#FIXME need to disable the collision after hit
		node.disable_mode = 0
		#print("Parent of node hit: ", node.get_parent().get_class())
		# it's a powerup
		
func reset() -> void:
	speed = 400
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
