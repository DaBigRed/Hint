extends Area2D
var player_in_area = false
signal destroy
var cur_item = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered_br)
	connect("body_exited", _on_body_exited_br)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact") and cur_item == "crowbar":
		destroy.emit()
	
func _on_body_entered_br(_body):
	player_in_area = true
	

func _on_body_exited_br(_body):
	player_in_area = false
	


func _on_player_item(item) -> void:
	cur_item = item
