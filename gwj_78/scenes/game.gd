extends Node

@export var main_btn:Button
var MAIN = load("res://scenes/main.tscn")

const FancyFade = preload("res://addons/transitions/FancyFade.gd")
var ff = FancyFade.new()

var anim_speed = 0.5

var fade:Dictionary = {
	"noise": Callable(ff.noise),
	"pixelated_noise": Callable(ff.noise),
	"blurry_noise": Callable(ff.noise),
	"cell_noise": Callable(ff.noise)
}


#var valentines_candy_messages := [
	#"You make life sweeter!",  # Chocolate
	#"You’re my favorite conversation!",  # Candy Hearts
	#"I’m a sucker for you!",  # Lollipops
	#"You’re one smart cookie, and I love you!",  # Cookies
	#"Bee mine!",  # Honey-flavored candy
	#"You’re the apple of my eye!",  # Caramel Apple
	#"We make the perfect pair!",  # Strawberries & Chocolate
	#"I’m nuts about you!",  # Nutty Candy
	#"You're as sweet as honey!",  # Bit-O-Honey
	#"You’re my sweet piece!",  # Reese’s
	#"We’re nuts about each other!",  # Peanut M&Ms
	#"I can’t bear to be without you!",  # Gummy Bears
	#"You're a great catch!",  # Swedish Fish
	#"You brighten my day!",  # Skittles
	#"You wormed your way into my heart!",  # Gummy Worms
	#"You take my breath away!",  # Peppermints
	#"You’re red-hot!",  # Hot Tamales
	#"You rock my world!"  # Ring Pop
#]
#
#var candy_heart_sayings := [
	#"Be Mine",
	#"Love You",
	#"XOXO",
	#"Cutie",
	#"Hug Me",
	#"Sweetheart",
	#"Forever",
	#"Miss U",
	#"You Rock",
	#"BFF",
	#"True Love",
	#"Kiss Me",
	#"My Boo",
	#"Only You",
	#"Soulmate",
	#"ILYSM",
	#"Crazy 4 U",
	#"4Ever Yours",
	#"UR Cute",
	#"Luv U"
#]


var grid_size = 4
var cells = {}
	
@export var basic_tile:TileMapLayer
@export var wall_tile:TileMapLayer
@export var select_tile:TileMapLayer

func _ready() -> void:
	main_btn.pressed.connect(_on_main_pressed)


func _on_main_pressed() -> void:
	var _target_scene = MAIN.instantiate()
	var _type = "pixelated_noise"
	SceneManager.goto("main")
	# Transitions.change_scene_to_instance(_target_scene, Transitions.FadeType.CrossFade, 1)
	# Transitions.change_scene_to_instance(_target_scene, Transitions.FadeType.Instant)
	# FancyFade.new().blurry_noise(_target_scene)
	# FancyFade.new().circle_in(_target_scene, anim_speed)
	# FancyFade.new().tile_reveal(_target_scene)
	# FancyFade.new().wipe_conical(_target_scene, anim_speed)
	# FancyFade.new().wipe_right(_target_scene, anim_speed)
	# fade[type].call(_target_scene, anim_speed)
	
	pass
