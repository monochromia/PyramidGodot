extends PanelContainer

@onready var pack_image: TextureRect = $"Pack Image"

func set_slot_data(slot_data: SlotData) -> void:
	var pack_data = slot_data.pack_data
	pack_image.texture = pack_data.texture
	tooltip_text = "%s" % [pack_data.name]
	print("slot data set for " + pack_data.name)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
