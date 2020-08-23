extends Node2D

onready var items = $Items
onready var interactive = $Interactive

func _ready():
	randomize()
	$Items.hide()
	spawn_objects()
	set_up_customer()

func spawn_objects():
	for cell in items.get_used_cells():
		var id = items.get_cellv(cell)
		var type = items.tile_set.tile_get_name(id)
		
		var pos = items.map_to_world(cell) + items.cell_size / 2
		match type:
			'player_spawn':
				$Player.position = pos
				$Player.tile_size = items.cell_size
			'cauldron':
				$Cauldron.position = pos

func set_up_customer():
	#$Player.can_move = false	
	yield(get_tree().create_timer(3), "timeout")	
	$Customer.set_health_bar('mana', 3.0)
	$Customer.show()
	$UserInterface.set_message('A Knight appears.')
	yield(get_tree().create_timer(3), "timeout")	
	$UserInterface.set_message('He requests a potion.')	
	yield(get_tree().create_timer(3), "timeout")	
	$UserInterface.set_message('Press SPACE to interact.')	
	yield(get_tree().create_timer(3), "timeout")	
	$UserInterface.set_message('Arrows to move.')	
	yield(get_tree().create_timer(3), "timeout")	
	$UserInterface.set_message('Mix in the cauldron.')	
	yield(get_tree().create_timer(3), "timeout")	
	$UserInterface.set_message('Go now, Dungeon Chef.')	
	$Player.can_move = true
	
func new_random_customer():
	yield(get_tree().create_timer(3), "timeout")	
	$Customer.randomize_customer()

func _on_Player_targeted(target: Vector2, label: String):
	$Cursor.position = interactive.map_to_world(target) + interactive.cell_size / 2
	$Cursor.show()
	
	if label == 'cauldron':
		$UserInterface.set_message($Cauldron.print_contents())
	elif label == 'conveyor_belt':
		$UserInterface.set_message('deliver food')
	else:
		$UserInterface.set_message(label)

func _on_Player_untargeted():
	$Cursor.hide()
	$UserInterface.set_message('')

func _on_Player_put(item):
	$Cauldron.deposit_item(item)
	$UserInterface.set_message($Cauldron.print_contents())


func _on_Player_pick_up():
	var temp_item = $Cauldron.take_item()
	if temp_item:
		$Player.pick_up(temp_item[0], temp_item[1])


func _on_Cauldron_cooking_done():
	$UserInterface.set_message($Cauldron.print_contents())


func _on_Customer_dialogue(message):
	$UserInterface.set_message(message)


func _on_Customer_died():
	$UserInterface.set_message('You\'ve killed him!')
	new_random_customer()


func _on_Customer_saved():
	$UserInterface.set_message('You saved the hero!')
	new_random_customer()
