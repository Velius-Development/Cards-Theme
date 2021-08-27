extends Control

var shown = false setget _set_shown


func _input(event):
	if event is InputEventMouseButton:
		if !event.pressed:
			if shown:
				$AnimationPlayer.play_backwards("enter")
				shown = false

func _set_shown(val):
	shown = val
	if shown:
		$AnimationPlayer.play("enter")


func _on_InputArea_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if !event.pressed && get_parent().cardHolder.draggingCard != null:
			var dC = get_parent().cardHolder.draggingCard
			if dC != null:
				var id = dC.choiceID
				Velius.choice_made(id)
				if dC.snapping:
					dC.snapping = false
					dC.mayDrag = false
					dC.unDrag()
					dC.lastX = null
					dC.lastDif = 0
					dC.dragging = false


func _on_InputArea_mouse_entered():
	if get_parent().cardHolder.draggingCard != null:
		var body = get_parent().cardHolder.draggingCard
		if body.is_in_group("card"):
			if !body.snapping:
				body.call("snap", $Node2D.global_position)


func _on_InputArea_mouse_exited():
	if get_parent().cardHolder.draggingCard != null:
		var body = get_parent().cardHolder.draggingCard
		if body.is_in_group("card"):
			if body.snapping:
				body.hasToUnsnap = true
