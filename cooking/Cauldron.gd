extends Area2D

signal stored_item

var container = []
var container_size: int = 4
var is_cooking: bool = false

### Functionality, pubic
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
func _update_cooking_status() -> void:
	if container.size() > 0:
		is_cooking = true
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
	$BubbleTween.stop()

func _reset_bubble_sprite():
	$Bubbles.position = Vector2(0, -1.75)
	$Bubbles.scale = Vector2(0.1, 0.1)

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
	$FireTweenOut.stop()
	$FireTweenIn.stop()

func _on_BubbleTween_tween_all_completed():
	_start_animate_bubbles()

func _on_FireTweenIn_tween_completed(object, key):
	_animate_fire_out()


func _on_FireTweenOut_tween_completed(object, key):
	_animate_fire_in()
