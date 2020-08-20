extends Area2D

func _ready():
	_start_animate_bubbles()
	_animate_fire_in()

func _start_animate_bubbles():
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

func _on_BubbleTween_tween_all_completed():
	_reset_bubble_sprite()
	_start_animate_bubbles()

func _on_FireTweenIn_tween_completed(object, key):
	_animate_fire_out()


func _on_FireTweenOut_tween_completed(object, key):
	_animate_fire_in()
