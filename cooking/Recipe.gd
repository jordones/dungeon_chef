extends Sprite

var effect_type
var effect_modifier
var sprite_regions = {
	'mana': Rect2(512, 208, 16, 16),
	'health': Rect2(544, 208, 16, 16),
	'poison': Rect2(528, 304, 16, 16)
}

const effects = {
	'Mana': 'mana',
	'Health': 'health',
	'Poison': 'poison'
}

const effect_modifiers = [0.5, 1, 1.5, 2]

func _ready():
	$Tween.interpolate_property(
		self,
		"position",
		self.position,
		Vector2(0, -8),
		1.0,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN
	)

func setup(ingredients: Array):
	match ingredients[0]:
		'apple', 'pear':
			effect_type = effects['Health']
			self.region_rect = sprite_regions['health']
		'meat_raw', 'egg':
			effect_type = effects['Mana']
			self.region_rect = sprite_regions['mana']
		'cheese':
			effect_type = effects['Poison']
			self.region_rect = sprite_regions['poison']

	effect_modifier = effect_modifiers[ingredients.count(ingredients[0]) - 1]

