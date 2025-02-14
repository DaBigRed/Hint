# BreakableWall.gd
extends StaticBody2D

# Player must be in this group and have 'has_crowbar' variable
@export var required_item := "crowbar"

var cur_item = ""

var player_in_range := false

func _process(_delta):
	pass

@onready var detection_area = $Area2D  # Alternative: get_node("Area2D")

func _ready():
	detection_area.connect("body_entered", _on_body_entered)

	

func _on_body_entered(body):
	if body.is_in_group("player") and Input.is_action_just_pressed("interact"):
		if "crowbar" in World.inventory:  # Ensure the player is in the correct group
			print("Player entered the detection area")

func break_barrier():
	queue_free()  # Replace this with your barrier-breaking logic
	
	
