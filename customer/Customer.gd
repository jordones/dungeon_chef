extends Node2D

onready var ui_sprites = [
	$UI1,
	$UI2,
	$UI3,
	$UI4
]

var health_sprites = {
	'full': Rect2(672, 160, 16, 16),
	'half': Rect2(656, 160, 16, 16),
	'empty': Rect2(640, 160, 16, 16),
}

var mana_sprites = {
	'full': Rect2(672, 176, 16, 16),
	'half': Rect2(656, 176, 16, 16),
	'empty': Rect2(640, 176, 16, 16),
}

func set_health_bar(effect_type: String, value: float) -> void:
	var sprites = health_sprites if not effect_type == 'mana' else mana_sprites
	var max_spaces = ui_sprites.size()
	var i = floor(value)
	print("i  == " + str(i))
	# Calculate full sprites
	if i > 0:
		for j in range(0, i):
			print("filling space: " + str(j))
			ui_sprites[j].region_rect = sprites['full']
	# Fill the rest with empty sprites
	for k in range(i, max_spaces):
		print("emptying space: " + str(k))
		ui_sprites[k].region_rect = sprites['empty']
	# Adjust half sprite if necessary
	if fmod(value, 1) == 0.5:
		ui_sprites[i].region_rect = sprites['half']
