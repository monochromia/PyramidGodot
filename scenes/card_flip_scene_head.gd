extends Node2D

@export var selected_packs: Array[PackData] = []
@export var num_drafts: int

# Called when the node enters the scene tree for the first time.
func _ready():
	print("num drafts:")
	print(num_drafts)
	
	print("selected packs:")
	for pack in selected_packs:
		print(pack.title)


func adjust_background_size():
	var window = get_window()
	$Background.set_custom_minimum_size(Vector2(window.size.x, window.size.y))
	$Background.set_custom_maximum_size(Vector2(window.size.x, window.size.y))
