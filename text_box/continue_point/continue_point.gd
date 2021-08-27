extends Sprite

var show = false setget _set_show

func _unhandled_input(event):			#VIELLEICHT, WENNS NICHT ANDERS GEHT WIEDER AUF NUR _INPUT STELLEN!!
	if event is InputEventMouseButton:
		if event.pressed:
			pass
			#if (string)Velius.current_json_path != "":		IF MORE TEXT TO SHOW
			#	if Globals.textBox.animating:
			#		Globals.textBox.finishAnim()
			#	elif show:
			#		Velius.next()

func _set_show(val):
	show = val
	if show:
		get_parent().get_node("AnimationPlayer").playback_speed = 1
		get_parent().get_node("AnimationPlayer").play("continue")
	else:
		get_parent().get_node("AnimationPlayer").playback_speed = 3

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "continue":
		if show == false:
			get_parent().get_node("AnimationPlayer").stop()
		else:
			get_parent().get_node("AnimationPlayer").play("continue")
