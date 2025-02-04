extends Area2D

signal broken()
signal near_break()

var player_in_area: bool = false
var have_item = ""

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(_body):
	player_in_area = true

func _on_body_exited(_body):
	player_in_area = false

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("use"):
		near_break.emit(true)
		if have_item == "Crowbar":
			broken.emit(true)


func _on_char_item(item) -> void:
	print(item)
	have_item = item
