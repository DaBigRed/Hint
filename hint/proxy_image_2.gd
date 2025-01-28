extends Sprite2D

var speed = 400
var angular_speed = PI
var gravity = Vector2(0, 600) # Gravity vector (downward force)
var velocity = Vector2.ZERO   # Object's current velocity
var jump_force = -400         # Jumping force (negative because up is -y)
var is_on_ground = false      # Tracks whether the object is on the ground

# Reference to the child figures
@onready var still = $Still
@onready var moving = $Moving

func _process(delta):
	# Handle left and right movement
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = 0 # Stop horizontal movement when no key is pressed
	
	# Jumping logic
	if is_on_ground and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force
		is_on_ground = false # Leaving the ground
	
	# Apply gravity
	velocity += gravity * delta
	
	# Update the object's position
	position += velocity * delta
	
	# Ground collision
	if position.y >= 500: # Assuming y=500 is the ground level
		position.y = 500
		velocity.y = 0
		is_on_ground = true
	
	# Control visibility based on velocity
	if velocity == Vector2.ZERO:
		# If velocity is zero, show Still and hide Moving
		still.visible = true
		moving.visible = false
	else:
		# If velocity is not zero, show Moving and hide Still
		still.visible = false
		moving.visible = true
