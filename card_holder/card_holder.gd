extends Control

onready var animPlayer = $AnimationPlayer
onready var cardRes = load("res://cards/card.tscn")
var cardCount = 0
var rot = 0
var posX = 0
var rotSpacing = 20
var posXSpacing = 100

var cardSelected
var dragFinished = true
var tc

var draggingCard : Node
var selectedCard : Node

var cowering = false setget _set_cower

var oldRots = []

func _set_cower(value):
	if value != cowering:
		cowering = value
		if cowering:
			$holderPos/Tween.interpolate_property(
			$holderPos,
			"rect_position",
			$holderPos.rect_position,
			Vector2($holderPos.rect_position.x, $holderPos.rect_position.y + 650),
			0.3,
			Tween.TRANS_EXPO, Tween.EASE_OUT)
			$holderPos/Tween.start()
			
			for card in $holderPos.get_children():
				if card.is_in_group("card") and self.has_node(card.get_path()):
					oldRots.append(card.rotation_degrees)
					card.get_node("Tween").interpolate_property(
					card, "rotation_degrees",
					card.rotation_degrees, 0, 0.2,
					Tween.TRANS_CUBIC, Tween.EASE_OUT)
					
					card.get_node("Tween").start()
			
		else:
			$holderPos/Tween.interpolate_property(
			$holderPos,
			"rect_position",
			$holderPos.rect_position,
			Vector2($holderPos.rect_position.x, $holderPos.rect_position.y - 650),
			0.3,
			Tween.TRANS_EXPO, Tween.EASE_OUT)
			
			if oldRots != []:
				var i = 0
				
				for card in $holderPos.get_children():
					if card.is_in_group("card") and self.has_node(card.get_path()):
						card.get_node("Tween").interpolate_property(
						card, "rotation_degrees",
						card.rotation_degrees, oldRots[i], 0.2,
						Tween.TRANS_CUBIC, Tween.EASE_OUT)
						
						card.get_node("Tween").start()
						i += 1
		
		$holderPos/Tween.start()

func refresh():
	rot = 0
	posX = 0
	if cardCount == 1:
		rot = 0
	elif cardCount % 2 == 0:
		rot = -(cardCount*rotSpacing)/3
	else:
		rot = -(cardCount*rotSpacing)/2.5
	posX = -(cardCount*posXSpacing)/3 - 10*cardCount
	
	for card in $holderPos.get_children():
		if card.is_in_group("card") and self.has_node(card.get_path()):
			card.get_node("Tween").interpolate_property(
			card, "position",
			card.position, Vector2(posX, card.position.y), 0.3,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
			card.get_node("Tween").interpolate_property(
			card, "rotation_degrees",
			card.rotation_degrees, rot, 0.3,
			Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
			
			card.get_node("Tween").start()
			
			rot += rotSpacing
			posX += posXSpacing

func _input(event):
	if Input.is_action_just_pressed("click"):
		if tc != null:
			tc.queue_free()
			tc = null
		tc = load("res://card_holder/touch_collision.tscn").instance()
		add_child(tc)
		tc.set_global_position(event.position)

func newCard(title, text, img, choiceID):
	var card = cardRes.instance()
	card.duplicate()
	card.holderLayer = cardCount
	card.z_index = cardCount
	$holderPos.add_child(card)
	card.global_position.y += 350
	card.setup(title, text, img, choiceID)
	cardCount += 1
	
	refresh()

func reset():
	dragFinished = true
	draggingCard = null
	get_parent().dropArea.shown = false
	for card in $holderPos.get_children():
		if card.is_in_group("card"):
			card.queue_free()
	cardCount = 0

func _on_Tween_tween_all_completed():
	if cowering:
		$holderPos.rect_position.y =  382  + get_viewport_rect().size.y
	else:
		$holderPos.rect_position.y = -268  + get_viewport_rect().size.y

func _process(delta):
	$ColorRectLayer/ColorRect.rect_size = get_viewport_rect().size * 1.1
