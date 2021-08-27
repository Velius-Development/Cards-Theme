extends NinePatchRect

onready var textNode = $MarginContainer/TouchScroll/Text

var text
var animating = false


func setText(_text):
	#Globals.continuePoint.show = false
	text = _text
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.seek(0)
	$AnimationPlayer.play("textSwap")
	animating = true

func _set_text():
	$MarginContainer/TouchScroll/Text.bbcode_text = "\n" + text + "\n\n"


func _show_continue():
	if get_parent().cardHolder.cardCount == 0:
		pass#Globals.continuePoint.show = true

func finishAnim():
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.playback_speed = 1000
		yield(get_tree().create_timer(0.1), "timeout")
		$AnimationPlayer.playback_speed = 1


func _process(delta):
	$MarginContainer.rect_size.y = get_viewport_rect().size.y - 1800
	$MarginContainer/TouchScroll/Text/Light2DBottom.position.y = $MarginContainer.rect_size.y

func _on_AnimationPlayer_animation_finished(anim_name):
	animating = false
