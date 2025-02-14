extends CharacterBody2D

# Movement variables
var max_speed = 200
var run_speed = 400
var acceleration = 1500
var deceleration = 1200
var air_control = 600  # Less control in the air
var jump_force = -400  
var gravity = 1200
var jump_release_reduction = 0.5  # Reduces jump height if released early
var inventory = []  

# Velocity tracking
var target_speed = 0  

# Sprite references
@onready var still_sprite = $Still
@onready var moving_sprite = $Moving
@onready var running_sprite = $Running
@onready var jumping_sprite = $Jumping
@export var max_jumps: int = 1  
var jumps_left: int
var item_type = ""
signal item

func _ready():
	update_sprite_visibility(false)
	jumps_left = max_jumps
	
func get_input(delta):
	var direction = Input.get_axis("left", "right")  
	var is_running = Input.is_action_pressed("shift") and is_on_floor()  # Sprint only if on the ground
	var is_jumping = Input.is_action_just_pressed("jump")
	var is_releasing_jump = Input.is_action_just_released("jump")
	
	# Set target speed based on walking or running
	target_speed = (run_speed if is_running else max_speed) * direction
	
	# Adjust acceleration/deceleration based on ground/air
	var accel = acceleration if is_on_floor() else air_control
	var decel = deceleration if is_on_floor() else air_control / 2
	
	# Accelerate towards target speed
	if direction != 0:
		velocity.x = move_toward(velocity.x, target_speed, accel * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, decel * delta)
	
	# Jumping logic
	if is_jumping and jumps_left > 0:
		velocity.y = jump_force
		jumps_left -= 1  

	# Reduce jump height if released early
	if is_releasing_jump and velocity.y < 0:
		velocity.y *= jump_release_reduction

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = max_jumps
	
	# Get input and apply movement
	get_input(delta)
	
	# Move the character
	move_and_slide()  

	# Update sprite visibility based on movement state
	update_sprite_visibility(velocity.x != 0)

func update_sprite_visibility(is_moving):
	if not is_on_floor():
		show_sprite(jumping_sprite)  
	elif velocity.x == 0:
		show_sprite(still_sprite)  
	else:
		show_sprite(running_sprite if is_moving and Input.is_action_pressed("shift") else moving_sprite)  

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

func _on_power_up_collected(power_type: Variant) -> void:
	match power_type:
		"Jump":
			max_jumps += 1
			jumps_left = max_jumps
			
			

func has_item(item_name: String) -> bool:
	return item_name in inventory
