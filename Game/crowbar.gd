extends Area2D

@export var item_type: String = "crowbar" # Can be customized for different power-ups



var player_in_area: bool = false

func _ready():
	connect("body_entered", _on_body_entered_cb)
	connect("body_exited", _on_body_exited_cb)

func _on_body_entered_cb(_body):
	player_in_area = true

func _on_body_exited_cb(_body):
	player_in_area = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("pickup"):
		World.inventory.append(item_type)
		queue_free()
