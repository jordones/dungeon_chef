extends Node2D

signal dialogue
signal died
signal saved

var rand = RandomNumberGenerator.new()

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

var customer_sprites = [
	{ 'sprite': Rect2(416, 96, 16, 16), 'name': 'Ghost'},
	{ 'sprite': Rect2(384, 16, 16, 16), 'name': 'Mage'},
	{ 'sprite': Rect2(464, 96, 16, 16), 'name': 'Skeleton'},
	{ 'sprite': Rect2(400, 144, 16, 16), 'name': 'Monk'},
	{ 'sprite': Rect2(480, 96, 16, 16), 'name': 'Golem'},
	{ 'sprite': Rect2(496, 112, 16, 16), 'name': 'Dog'},
	{ 'sprite': Rect2(464, 32, 16, 16), 'name': 'Goblin'},
	{ 'sprite': Rect2(384, 32, 16, 16), 'name': 'Old Man'},
	{ 'sprite': Rect2(448, 48, 16, 16), 'name': 'King'},
]

var effect_requested: String
var modifier_needed: float

func set_health_bar(effect_type: String, value: float) -> void:
	var sprites = health_sprites if not effect_type == 'mana' else mana_sprites
	var max_spaces = ui_sprites.size()
	effect_requested = effect_type
	modifier_needed = max_spaces - value
	
	var i = floor(value)
	# Calculate full sprites
	if i > 0:
		for j in range(0, i):
			ui_sprites[j].region_rect = sprites['full']
	# Fill the rest with empty sprites
	for k in range(i, max_spaces):
		ui_sprites[k].region_rect = sprites['empty']
	# Adjust half sprite if necessary
	if fmod(value, 1) == 0.5:
		ui_sprites[i].region_rect = sprites['half']

func receive_item(item) -> void:
	if item.effect_type == effect_requested:
		emit_signal('dialogue', 'Thank you..')
		if item.effect_modifier >= modifier_needed:
			modifier_needed = 0
		else:
			var modifier_adjustment = modifier_needed - item.effect_modifier
			if modifier_adjustment >= 0:
				modifier_needed = modifier_adjustment
			else:
				modifier_needed = 0
	elif item.effect_type == 'poison':
		emit_signal('dialogue', 'Ack, traitor!')
		var modifier_adjustment = modifier_needed + item.effect_modifier
		if modifier_adjustment > ui_sprites.size():
			modifier_needed = ui_sprites.size()
		modifier_needed = modifier_adjustment
	else:
		emit_signal('dialogue', 'I don\'t need this now.')		
	
	set_health_bar(effect_requested, ui_sprites.size() - modifier_needed)
	print(modifier_needed)
	# Customer died
	if modifier_needed >= ui_sprites.size():
		$Sprite.hide()
		$DeathSprite.show()
		emit_signal('died')
	# Customer was helped
	if modifier_needed == 0:
		emit_signal('saved')

func randomize_customer():
	rand.randomize()
	var random_key = rand.randi_range(0, customer_sprites.size() - 1)
	$Sprite.region_rect = customer_sprites[random_key]['sprite']
	var name = customer_sprites[random_key]['name']
	effect_requested = 'health' if not rand.randi_range(0, 1) else 'mana'
	var rand_modifier = rand.randi_range(0, ui_sprites.size())
	modifier_needed = rand_modifier if not rand.randi_range(0, 1) else (rand_modifier + 0.5)
	set_health_bar(effect_requested, modifier_needed)
	emit_signal('dialogue', name + ' has arrived.')

func _on_Player_delivered(item):
	if item:
		receive_item(item)
		yield(get_tree().create_timer(3), "timeout")	
