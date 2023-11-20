extends PanelContainer

signal redraft_card(index: int)

var is_revealed = false

@onready var card_front = $card_front
@onready var card_back = $card_back

func load_image_into_texture(image_path):
	var im = Image.new()
	im = Image.load_from_file(image_path)  # Create a new Image instance
	
	#TODO: Set pack size dynamically based on number of rows/columns decided by screen size or user settings? idk.
	# This solution works but messes up resolution something fierce
	im.resize(300,450)
	
	if im != Image.new():  # Check if the image loaded successfully
		var texture = ImageTexture.new()  # Create a new ImageTexture instance
		
		texture = ImageTexture.create_from_image(im)  # Assign the image to the texture
		texture.set_size_override(Vector2i(240,360))
		return texture  # Return the texture
	else:
		print("Failed to load image: ", image_path)
		return null


func set_card_data(foreground_path: String, background_path: String):
	card_front.texture = load_image_into_texture(foreground_path)
	card_back.texture = load_image_into_texture(background_path)


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
