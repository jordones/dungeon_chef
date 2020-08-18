extends CanvasLayer

func set_message(message: String):
	$TextWrapper/Message.text = '[' + str(message) + ']'
