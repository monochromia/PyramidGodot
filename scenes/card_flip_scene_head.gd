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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
