extends Node2D

onready var items = $Items
onready var interactive = $Interactive

func _ready():
	$Items.hide()
	spawn_player()

func spawn_player():
	for cell in items.get_used_cells():
		var id = items.get_cellv(cell)
		var type = items.tile_set.tile_get_name(id)
		print(type)
		
		var pos = items.map_to_world(cell) + items.cell_size / 2
		match type:
			'player_spawn':
				$Player.position = pos
				$Player.tile_size = items.cell_size

func _on_Player_targeted(target: Vector2, label: String):
	$Cursor.position = interactive.map_to_world(target) + interactive.cell_size / 2
	$Cursor.show()
	$UserInterface.set_message(label)


func _on_Player_untargeted():
	$Cursor.hide()
	$UserInterface.set_message('')
