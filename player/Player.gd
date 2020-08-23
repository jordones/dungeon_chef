extends Area2D

signal moved
signal targeted
signal untargeted
signal put
signal pick_up
signal delivered

var speed = 3
var tile_size = 16
var can_move = true
var can_interact = true
var is_holding = false
var held_food_type
var facing = 'right'
var heldItem
var moves = {
	'right': Vector2(1, 0),
	'left': Vector2(-1, 0),
	'up': Vector2(0, -1),
	'down': Vector2(0, 1),
}

onready var raycasts = {
	'right': $RayCastRight,
	'left': $RayCastLeft,
	'up': $RayCastUp,
	'down': $RayCastDown,
}

func _process(delta):
	if can_move:
		for dir in moves.keys():
			if Input.is_action_pressed(dir):
				if move(dir):
					emit_signal('moved')
	if can_interact:
		if Input.is_action_pressed("primary_action"):
			interact()

func move(dir: String) -> bool:
	facing = dir
	update_cursor()
	if raycasts[facing].is_colliding():
		return false
	
	can_move = false
	$MoveTween.interpolate_property(
		self,
		"position",
		position,
		position + moves[facing] * tile_size,
		1.0 / speed,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$MoveTween.start()
	return true

func update_cursor():
	if raycasts[facing].is_colliding():
		var colliding_object = raycasts[facing].get_collider()
		if (colliding_object.is_in_group("interactable")):
			# Fix for bug where the world point is the wrong co-ordinates
			# for left/up raycasts
			var safe_margin = 1.0
			var collision_point = raycasts[facing].get_collision_point()
			var point = collision_point - raycasts[facing].get_collision_normal() * safe_margin
			var tile_pos = colliding_object.world_to_map(point)
			var id = colliding_object.get_cellv(tile_pos)
			var _type = colliding_object.tile_set.tile_get_name(id)
			emit_signal('targeted', tile_pos, _type)
	else:
		emit_signal('untargeted')
	
func interact() -> bool:
	if raycasts[facing].is_colliding():
		var colliding_object = raycasts[facing].get_collider()
		if (colliding_object.is_in_group("interactable")):
			var hit_pos = raycasts[facing].get_collision_point()
			var safe_margin = 1.0
			var point = raycasts[facing].get_collision_point() - raycasts[facing].get_collision_normal() * safe_margin
			var tile_pos = colliding_object.world_to_map(point)
			var tile_id = colliding_object.get_cellv(tile_pos)
			var type = colliding_object.tile_set.tile_get_name(tile_id)
			match type:
				'cheese', 'pear', 'meat_raw', 'apple', 'fish', 'egg':
					if is_holding:
						return false
					$HeldItem.set("texture", colliding_object.tile_set.tile_get_texture(tile_id))
					$HeldItem.region_rect = colliding_object.tile_set.tile_get_region(tile_id)
					is_holding = true
					held_food_type = type
				'garbage_bin':
					if is_holding:
						is_holding = false
						held_food_type = null
						$HeldItem.set("texture", null)
				'cauldron':
					if is_holding:
						if held_food_type == 'generic':
							return false
						emit_signal("put", held_food_type)
					else:
						emit_signal('pick_up')
				'conveyor_belt':
					if is_holding:
						if held_food_type == 'generic':
							can_interact = false
							is_holding = false
							held_food_type = null
							emit_signal("delivered", heldItem)
							heldItem = null
							$HeldItem.set("texture", null)
							can_interact = true
		return true
	return false

func pick_up(name, item) -> bool:
	heldItem = item
	$HeldItem.set("texture", item.texture)
	$HeldItem.set("region_rect", item.region_rect)
	yield(get_tree().create_timer(.5), "timeout")
	if is_holding:
		return false
	is_holding = true
	held_food_type = name
	return true


func _on_MoveTween_tween_completed(object, key):
	can_move = true


func _on_Cauldron_stored_item(successful: bool):
	if successful:
		is_holding = false
		held_food_type = null
		$HeldItem.set("texture", null)
