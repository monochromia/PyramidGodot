extends PanelContainer

@onready var active_packs_row = $MarginContainer/ActivePacksRow

const Pack = preload("res://pack_select/selected_pack.tscn")
@export var active_packs: Array[PackData] = []


func get_packs() -> Array[PackData]: 
	return active_packs


func set_pack_select_data(pack_select_data: PackSelectData):
	pack_select_data.pack_clicked.connect(on_pack_clicked)


func on_pack_clicked(pack: PackData, left_click: bool):
	if left_click:
		var selected_pack = Pack.instantiate()
		active_packs_row.add_child(selected_pack)
		selected_pack.set_pack_data(pack)
		active_packs.append(pack)
	else:
		var children = active_packs_row.get_children()
		
		for child in children:
			if child and child.pack.name == pack.name:
				active_packs_row.remove_child(child)
				break
				
		# Remove only one instance of the pack from active_packs array
		var index_to_remove = active_packs.find(pack)
		if index_to_remove != -1:
			active_packs.remove_at(index_to_remove)
