extends PanelContainer

signal redraft_card(index: int)

var is_revealed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_click(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.is_pressed() \
			and not is_revealed:
		flip_card()
		is_revealed = true
		
	elif event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_RIGHT \
			and event.is_pressed() \
			and is_revealed:
		redraft_card.emit(get_index())

func flip_card():
	print("flipping card")
	$AnimationPlayer.play("card_flip")
