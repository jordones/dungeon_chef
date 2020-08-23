extends Area2D

signal stored_item
signal cooking_done

export (PackedScene) var Recipe

var container = []
var container_size: int = 4
var is_cooking: bool = false
var has_cooked_item: bool = false
var cooked_item = null

func _process(delta):
	if _is_full():
		_finish_cooking()

### Functionality, pubic
func take_item():
	if !has_cooked_item:
		return ''

	has_cooked_item = false
	var temp_item = cooked_item
	cooked_item.hide()
	cooked_item = null
	return ['generic', temp_item]

func deposit_item(item: String) -> bool:
	if container.size() + 1 > container_size:
		emit_signal('stored_item', false)
		return false
	
	# Add food to container
	container.append(item)
	_update_cooking_status()
	emit_signal('stored_item', true)
	return true
	
func print_contents() -> String:
	var contents: String = 'Cauldron'
	if _is_full():
		contents += ' (FULL): '
	elif has_cooked_item:
		contents += ' (' + str(cooked_item.effect_type) + '(' + str(cooked_item.effect_modifier) + ')' + ')'
	elif _is_empty():
		contents += ' (EMPTY)'
	else:
		contents += ': '

	var last_index = container.size()
	
	for i in range(container.size()):
		contents += container[i]
		if i != last_index:
			contents += ', '
	return contents

### Functionality, private

func _finish_cooking() -> void:
	cooked_item = Recipe.instance()
	cooked_item.setup(container)
	cooked_item.position = Vector2(0, -3.5)
	add_child(cooked_item)

	container = []
	_update_cooking_status()
	_animate_cooked_food()

func _update_cooking_status() -> void:
	if container.size() > 0:
		is_cooking = true
		if container.size() == 1:
			_start_animate_bubbles()
			_animate_fire_in()
	else:
		is_cooking = false
		_stop_animate_bubbles()
		_stop_animate_fire()

func _is_full() -> bool:
	return container.size() == container_size

func _is_empty() -> bool:
	return container.size() == 0

func _reset_cooked_item() -> void:
	$CookedItem.hide()
	$CookedItem.position = Vector2(0, -3.5)
### Animations
func _start_animate_bubbles():
	_reset_bubble_sprite()
	$BubbleTween.interpolate_property(
		$Bubbles,
		"scale",
		$Bubbles.scale,
		Vector2(0.5, 0.5),
		2.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)

	$BubbleTween.interpolate_property(
		$Bubbles,
		"position",
		$Bubbles.position,
		Vector2(0, -10),
		2.5,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
	)
	$BubbleTween.start()

func _stop_animate_bubbles():
	_reset_bubble_sprite()
	$BubbleTween.stop_all()

func _reset_bubble_sprite():
	$Bubbles.position = Vector2(0, -1.75)
	$Bubbles.scale = Vector2(0.01, 0.01)

func _animate_fire_in():
	$FireTweenIn.interpolate_property(
		$FireSprite,
		"scale",
		$FireSprite.scale,
		Vector2(1.05, 1.05),
		2.0,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	$FireTweenIn.start()

func _animate_fire_out():
	$FireTweenOut.interpolate_property(
		$FireSprite,
		"scale",
		$FireSprite.scale,
		Vector2(1.0, 1.0),
		2.0,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
	)
	$FireTweenOut.start()

func _stop_animate_fire():
	$FireTweenOut.stop_all()
	$FireTweenIn.stop_all()
	
func _animate_cooked_food():
	#cooked_food.show()	
	$CookedItemTween.interpolate_property(
		cooked_item,
		"position",
		cooked_item.position,
		Vector2(0, -8),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)
	$CookedItemTween.start()

func _on_BubbleTween_tween_all_completed():
	_start_animate_bubbles()

func _on_FireTweenIn_tween_completed(object, key):
	_animate_fire_out()

func _on_FireTweenOut_tween_completed(object, key):
	_animate_fire_in()


func _on_CookedItemTween_tween_completed(object, key):
	has_cooked_item = true
	emit_signal('cooking_done')
