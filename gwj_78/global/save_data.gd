extends Node

const SAVE_PATH = "user://save_data.cfg"
var achievements_unlocked: Dictionary = {}

var all_achievements: Array = [
	"ending_body", "ending_normal", "ending_time", "ending_window",
	"ending_sleep", "ending_webcam", "ending_gun", "ending_vampire", 
	"ending_clean_hands", "ending_good",
	
	"shrooms", "intimidation",
]

var achievement_icons: Dictionary = {
	"ending_body": preload("res://icons/ending_body.png"),
	"ending_normal": preload("res://icons/ending_normal.png"),
	"ending_time": preload("res://icons/ending_time.png"),
	"ending_window": preload("res://icons/ending_window.png"),
	"ending_sleep": preload("res://icons/ending_sleep.png"),
	"ending_webcam": preload("res://icons/ending_webcam.png"),
	"ending_gun": preload("res://icons/ending_gun.png"),
	"ending_vampire": preload("res://icons/ending_vampire.png"),
	"ending_clean_hands": preload("res://icons/ending_clean_hands.png"),
	"ending_good": preload("res://icons/ending_good.png"),
	
	"shrooms": preload("res://icons/shrooms.png"),
	"intimidation": preload("res://icons/intimidation.png"),
}
var locked_icon = preload("res://icons/locked.png")

#var achievement_hover_text: Dictionary = {
	#"ending_body": "(why are you holding a dead body???)",
	#"ending_normal": "(you didn't hide enough evidence.)",
	#"ending_time": "(you ran out of time and the police showed up.)",
	#"ending_window": "(you got caught by the window guy.)",
	#"ending_sleep": "(you got caught sleeping on the job.)",
	#"ending_webcam": "(you got caught from webcam footage.)",
	#"ending_gun": "(you got caught with the murder weapon.)",
	#"ending_vampire": "(they found the victim's blood in your stomach.)",
	#"ending_clean_hands": "(you had suspiciously clean hands.)",
	#"ending_good": "(you got away.)",
	#
	#"shrooms": "(you ate the shrooms.)",
	#"intimidation": "(you bullied the window guy into submission.)",
#}
#var locked_hover = "(you haven't unlocked this yet.)"

var achievement_hover_text: Dictionary = {
	"ending_body": "Leave with the body in your inventory",
	"ending_normal": "Leave without getting rid of the evidence",
	"ending_time": "Run out of time",
	"ending_window": "Get caught by the window guy",
	"ending_sleep": "Get caught sleeping on the job",
	"ending_webcam": "Get caught via webcam footage",
	"ending_gun": "Leave with the murder weapon",
	"ending_vampire": "Turn into a vampire",
	"ending_clean_hands": "Acquire suspiciously clean hands",
	"ending_good": "You got away!",
	
	"shrooms": "Get high on shrooms",
	"intimidation": "Bully the window guy into submission",
}
var locked_hover = "(You haven't unlocked this achievement yet.)"



var achievement_names: Dictionary = {
	"ending_body": "Dead Man Walking",
	"ending_normal": "Evidently Lacking",
	"ending_time": "Slowpoke",
	"ending_window": "Window of Opportunity",
	"ending_sleep": "Deep Sleeper",
	"ending_webcam": "Live on Twitch",
	"ending_gun": "Prime Suspect",
	"ending_vampire": "Vampirism",
	"ending_clean_hands": "Germaphobe",
	"ending_good": "'The Good Ending'™",
	
	"shrooms": "Shroom Lover",
	"intimidation": "Intimidation",
}
var locked_name = "Locked"




func _ready() -> void:
	load_achievements()

func save_achievements() -> void:
	var config = ConfigFile.new()
	for achievement in achievements_unlocked.keys():
		config.set_value("achievements", achievement, achievements_unlocked[achievement])
	config.save(SAVE_PATH)

func load_achievements() -> void:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		for achievement in config.get_section_keys("achievements"):
			achievements_unlocked[achievement] = config.get_value("achievements", achievement, false)

func unlock_achievement(achievement: String) -> void:
	if not achievements_unlocked.has(achievement):
		achievements_unlocked[achievement] = true
		save_achievements()
		print("Unlocked achievement: " + achievement)

func has_unlocked(achievement: String) -> bool:
	return achievements_unlocked.get(achievement, false)

#func get_unlocked_achievements() -> Array:
	#var unlocked = []
	#for achievement in achievements_unlocked.keys():
		#if achievements_unlocked[achievement]:
			#unlocked.append({
				#"name": achievement, 
				#"icon": achievement_icons.get(achievement, null),
				#"hover_text": achievement_hover_text.get(achievement, null)
			#})
	#return unlocked

func get_all_achievements() -> Array:
	var achievements = []
	for achievement in all_achievements:
		var unlocked = has_unlocked(achievement)
		achievements.append({
			"name": achievement.replace("_", " ").capitalize() if unlocked else "locked",
			"icon": achievement_icons.get(achievement, locked_icon) if unlocked else locked_icon,
			"hover_text": achievement_hover_text.get(achievement, locked_hover) if unlocked else locked_hover,
			"ach_name": achievement_names.get(achievement, locked_name) if unlocked else locked_name
		})
	return achievements
