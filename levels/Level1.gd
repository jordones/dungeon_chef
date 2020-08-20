extends Node2D

onready var items = $Items
onready var interactive = $Interactive
var cauldron = []

func _ready():
	$Items.hide()
	spawn_objects()

func spawn_objects():
	for cell in items.get_used_cells():
		var id = items.get_cellv(cell)
		var type = items.tile_set.tile_get_name(id)
		print(type)
		
		var pos = items.map_to_world(cell) + items.cell_size / 2
		match type:
			'player_spawn':
				$Player.position = pos
				$Player.tile_size = items.cell_size
			'cauldron':
				$Cauldron.position = pos

func _on_Player_targeted(target: Vector2, label: String):
	$Cursor.position = interactive.map_to_world(target) + interactive.cell_size / 2
	$Cursor.show()
	
	if label == 'cauldron':
		$UserInterface.set_message($Cauldron.print_contents())
	else:
		$UserInterface.set_message(label)



func _on_Player_untargeted():
	$Cursor.hide()
	$UserInterface.set_message('')

func _on_Player_put(item):
	print('player deposited ' + str(item) + ' in the cauldron')
	#cauldron.append(item)
	$Cauldron.deposit_item(item)
	$UserInterface.set_message($Cauldron.print_contents())
	#print(cauldron)
