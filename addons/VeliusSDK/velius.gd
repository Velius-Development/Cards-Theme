extends Node

###############################################################################
#                                  VELIUS ENGINE                              #
###############################################################################

##############################
# SIGNALS:

signal new_dialogue(data)

##############################
# VARIABLES:

var json_data = {}
var current_chapter_id : int
var current_dialogue_id : int
var current_location_id : int
var current_json_path = ""
var current_json_location = ""

###############################################################################
# API
###############################################################################


# When player dragged a choice card
func choice_made(id):
	pass

func open_side_menu():
	pass

func get_chapter_resource_path(string : String):
	return current_json_location + "/" + string

func mystery_resource_exists(string):
	return File.new().file_exists(current_json_location + "/" +  string)

func png_to_tex(local_res_path):
	var i = Image.new()
	i.load(get_chapter_resource_path(local_res_path))
	var t = ImageTexture.new()
	t.create_from_image(i)
	return t

func get_settings() -> Dictionary:
	return {}
