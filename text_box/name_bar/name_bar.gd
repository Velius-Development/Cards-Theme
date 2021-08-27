extends NinePatchRect


func _ready():
	$RichTextLabel.rect_size.x = 0
	updateName("")

func updateName(name):
	$RichTextLabel.text = name
	$RichTextLabel.rect_size.x = 0
	yield(get_tree().create_timer(0.1), "timeout")
	rect_size.x = $RichTextLabel.rect_size.x + 100
	if name.empty():
		rect_scale.y = 0
	else:
		rect_scale.y = 1
