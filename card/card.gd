extends Node2D

const DRAG_RANGE = 200


func get_cardHolder():
	return get_parent().get_parent().get_parent().cardHolder
func get_dropArea():
	return get_parent().get_parent().get_parent().dropArea

var title
var text
var img
var choiceID

var holderLayer
var mayDrag = false
var dragging = false
var snapping = false
var zoomed = false

var hasToUnsnap = false

var oldPos
var oldSca
var oldRot

var snapPos

#Wiggle animation
var lastX
var lastDif = 0
var wiggleWait = 0

func _on_Card_input_event(viewport, event, shape_idx):
	if Input.is_action_just_released("click") && !$Tween.is_active() && !get_cardHolder().cardSelected && !dragging && get_cardHolder().dragFinished:
		get_cardHolder().tc.zoomIfTop(self)
	if event is InputEventMouseButton:
		if event.pressed:
			get_cardHolder().tc.setMayDragIfTop(self)


func _input(event):
	if !$Tween.is_active() && zoomed && Input.is_action_just_released("click") && get_cardHolder().tc.get_overlapping_bodies().find(self):
		get_cardHolder().animPlayer.play_backwards("fade")
		unZoom()
	if Input.is_action_just_released("click"):
		mayDrag = false
		if dragging:
			unDrag()
			lastX = null
			lastDif = 0
	if event is InputEventMouseMotion && !$Tween.is_active()&& !get_cardHolder().cardSelected && !dragging && !snapping:
		if Input.is_action_pressed("click") && mayDrag:
				if (get_global_mouse_position()).distance_to(get_cardHolder().tc.global_position + Vector2(0, 180)) > DRAG_RANGE:
					drag()
					get_cardHolder().draggingCard = self


func makeZoom():
	if !$Tween2.is_active():
		zoom()
		get_cardHolder().animPlayer.play("fade")
		get_cardHolder().selectedCard = self

func zoom():
	decryptText()
	
	zoomed = true
	oldPos = self.global_position
	oldSca = self.scale
	oldRot = self.rotation_degrees
	z_index = 100
	$Tween.interpolate_property(
	self, "global_position",
	self.global_position, Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 1.3), 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "scale",
	self.scale, self.scale * 2.5, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "rotation_degrees",
	self.rotation_degrees, 0, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()
	#Input.vibrate_handheld(20)
	get_cardHolder().cardSelected = true
		
func unZoom():
	encryptText()
	
	zoomed = false
	z_index = holderLayer
	$Tween.interpolate_property(
	self, "global_position",
	self.global_position, oldPos, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "scale",
	self.scale, oldSca, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "rotation_degrees",
	self.rotation_degrees, oldRot, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()
	#Input.vibrate_handheld(20)
	get_cardHolder().cardSelected = false
	get_cardHolder().selectedCard = null


func drag():
	dragging = true
	oldPos = self.global_position
	oldSca = self.scale
	oldRot = self.rotation_degrees
	z_index = 99
	$Tween.interpolate_property(
	self, "rotation_degrees",
	self.rotation_degrees, 0, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "scale",
	self.scale, self.scale*1.5, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()
	#Input.vibrate_handheld(40)
	get_cardHolder().dragFinished = false
	get_dropArea().shown = true

func unDrag():
	dragging = false
	z_index = holderLayer
	$Tween.interpolate_property(
	self, "global_position",
	self.global_position, oldPos, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "scale",
	self.scale, oldSca, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	$card_glow, "modulate:a",
	$card_glow.modulate.a, 0, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "rotation_degrees",
	self.rotation_degrees, oldRot, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()
	get_cardHolder().dragFinished = true
	get_cardHolder().draggingCard = null
	#Input.vibrate_handheld(40)

func snap(pos):
	snapPos = pos + Vector2(0, 400)
	snapping = true
	dragging = false
	z_index = holderLayer
	
#	$Tween.interpolate_property(
#	self, "global_position",
#	self.global_position, snapPos, 0.3,
#	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "scale",
	self.scale, Vector2(0.65, 0.65), 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "rotation_degrees",
	self.rotation_degrees, 0, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	$card_glow, "modulate:a",
	$card_glow.modulate.a, 1, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()

	
	#Input.vibrate_handheld(40)

func unsnap():
	dragging = true
	snapping = false
	z_index = 100
	
	$Tween.interpolate_property(
	self, "rotation_degrees",
	self.rotation_degrees, 0, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	self, "scale",
	self.scale, oldSca*1.5, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.interpolate_property(
	$card_glow, "modulate:a",
	$card_glow.modulate.a, 0, 0.3,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween.start()
	
	#Input.vibrate_handheld(40)
	get_cardHolder().dragFinished = false
	wiggleWait = 10

func _show():
	self.scale = Vector2(0.2, 0.2)
	
	$Tween2.interpolate_property(
	self, "scale",
	self.scale, Vector2(0.6, 0.6), 0.8,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween2.interpolate_property(
	self, "modulate:a",
	0, 1.0, 0.4,
	Tween.TRANS_QUART, Tween.EASE_OUT)
	
	$Tween2.start()
	#Input.vibrate_handheld(10)
	
func setup(_title : String, _text : String, _img : String, _choiceID : int = 0):
	title = _title
	$Title.rect_size.x = title.length() * 30
	text = _text
	img = _img
	choiceID = _choiceID
	
	oldRot = self.rotation_degrees
	oldSca = self.scale
	
	$Title.text = title
	
	$SmoothScroll/Text.bbcode_text = text
	encryptText()
	
	if Velius.mystery_resource_exists(_img):
		$Sprite.texture = Velius.png_to_tex(_img)
	elif _img != "":
		print("Texture of choice with ID: " + str(_choiceID) + " not found! Dialogue ID: " + str(Velius.current_dialogue_id))
	
	
	_show()

func _physics_process(delta):
	$Sprite/Light2D.range_z_min = self.z_index	#Set mask only effecting own image
	$Sprite/Light2D.range_z_max = self.z_index
	
	if dragging:
		var mousepos = get_global_mouse_position()
		self.global_position = lerp(self.global_position, mousepos, 0.5)

	if snapping:
			var mousepos = get_global_mouse_position()
			var tendence
			var goalPos = lerp(self.snapPos, global_position, 0.2)
			self.global_position = lerp(lerp(goalPos, mousepos, 0.1), global_position, 0.9)

	#WIGGLE ANIMATION - Relative to drag speed
	if dragging:
		if lastX != null && wiggleWait <= 0:
			lastDif = lastX-global_position.x
			self.rotation = lerp(lerp(0, self.rotation, 0.5), (lastX-global_position.x)/360, 0.9)
		else:
			wiggleWait -= 1
		lastX = global_position.x
	
	if hasToUnsnap:
		if $Tween.is_active():
			$Tween.playback_speed = 5
		else:
			$Tween.playback_speed = 1
			unsnap()
			hasToUnsnap = false

#Text Encryption

const encryptChars = "▞▚▙▟▛▜■"

func encryptText():
	pass
#	if Velius.get_settings().encryptText:
#		$SmoothScroll/Text.get("custom_fonts/normal_font").font_data = load("res://fonts/symbol_letters.otf")
#		var result = ""
#		for cha in $SmoothScroll/Text.bbcode_text.length()/5:
#			result += encryptChars[rand_range(0, encryptChars.length() - 1)]
#		$SmoothScroll/Text.bbcode_text = result

func decryptText():
	pass
#	if Velius.get_settings().encryptText:
#		$SmoothScroll/Text.get("custom_fonts/normal_font").font_data = load("res://fonts/dimbo_regular.ttf")
#		$SmoothScroll/Text.bbcode_text = text
