extends Control

signal pressed

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("click"):
		$AnimationPlayer.play("clicked")
		emit_signal("pressed")
