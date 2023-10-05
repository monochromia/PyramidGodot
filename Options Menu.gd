extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_save_button_pressed():
	# TODO: Save data
	_on_cancel_button_pressed()
	
	
func _on_cancel_button_pressed():
	get_tree().change_scene_to_file("res://Main Menu.tscn")
