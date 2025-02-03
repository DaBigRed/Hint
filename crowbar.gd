extends Area2D

@export var item_type: String = "Crowbar" # Can be customized for different power-ups

signal collected(power_type)

var player_in_area: bool = false

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(_body):
	player_in_area = true

func _on_body_exited(_body):
	player_in_area = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("pickup"):
		collected.emit(item_type)
		queue_free()
