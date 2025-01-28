extends CharacterBody2D

# Movement variables
var speed = 200
var run_speed = 400
var jump_force = -300  # Negative because y-axis is downward in Godot
var gravity = 500

# Sprite references
@onready var still_sprite = $Still
@onready var moving_sprite = $Moving
@onready var running_sprite = $Running
@onready var jumping_sprite = $Jumping

func _ready():
	# Ensure only the still sprite is visible initially
	update_sprite_visibility(false)
	
func get_input():
	var direction = Input.get_axis("left", "right")  # Get -1, 0, or 1 based on input
	var is_running = Input.is_action_pressed("shift")  
	var move_speed = run_speed if is_running else speed

	velocity.x = direction * move_speed  # Apply movement

	# Jumping logic
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force  # Apply jump force

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get input and apply movement
	get_input()

	# Move the character
	move_and_slide()  

	# Update sprite visibility based on movement state
	update_sprite_visibility(velocity.x != 0)

func update_sprite_visibility(is_moving):
	if not is_on_floor():
		show_sprite(jumping_sprite)  # Jumping state
	elif velocity.x == 0:
		show_sprite(still_sprite)  # Idle state
	else:
		show_sprite(running_sprite if is_moving and Input.is_action_pressed("shift") else moving_sprite)  # Walking or Running

	# Flip sprite based on movement direction
	var flip = velocity.x < 0
	still_sprite.flip_h = flip
	moving_sprite.flip_h = flip
	running_sprite.flip_h = flip
	jumping_sprite.flip_h = flip

func show_sprite(sprite_to_show):
	# Hide all sprites
	still_sprite.visible = false
	moving_sprite.visible = false
	running_sprite.visible = false
	jumping_sprite.visible = false

	# Show the specified sprite
	sprite_to_show.visible = true
