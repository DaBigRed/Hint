# BreakableWall.gd
extends StaticBody2D

# Player must be in this group and have 'has_crowbar' variable
@export var required_item := "crowbar"
@export var interact_action := "interact" # Set this in Project Settings -> Input Map
var cur_item = ""

var player_in_range := false

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed(interact_action):
		pass


func _on_collision_shape_2d_is_in() -> void:
	print("I am near barrier")
	print("I have", cur_item)




func _on_area_2d_destroy() -> void:
	queue_free()
