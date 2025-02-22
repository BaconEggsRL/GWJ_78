class_name SaveData
extends Resource

const SAVE_PATH = "user://save_data.tres"
@export var achievements_unlocked: Dictionary = {}

var all_achievements: Array = [
	"ending_body", "ending_normal", "ending_time", "ending_window",
	"ending_sleep", "ending_webcam", "ending_gun", "ending_vampire", 
	"ending_clean_hands", "ending_good", "ending_shootout",
	
	"shrooms", "intimidation", "playwright"
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
	"ending_shootout": preload("res://icons/ending_shootout.png"),
	
	"shrooms": preload("res://icons/shrooms.png"),
	"intimidation": preload("res://icons/intimidation.png"),
	"playwright": preload("res://icons/playwright.png"),
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
	"ending_window": "Get caught by window guy",
	"ending_sleep": "Get caught sleeping on the job",
	"ending_webcam": "Get caught via webcam footage",
	"ending_gun": "Leave with the murder weapon",
	"ending_vampire": "Turn into a vampire",
	"ending_clean_hands": "Acquire suspiciously clean hands",
	"ending_good": "You got away!",
	"ending_shootout": "Get shot by the police",
	
	"shrooms": "Get high on shrooms",
	"intimidation": "Bully window guy into submission",
	"playwright": "Charm window guy with your literary prowess",
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
	"ending_good": "The Good Ending™",
	"ending_shootout": "Gunslinger",
	
	"shrooms": "Shroom Lover",
	"intimidation": "Intimidation",
	"playwright": "Playwright",
}
var locked_name = "Locked"


@export var bus_volume: Dictionary = {
	"Master": 1,
	"music": 1,
	"sfx": 1,
}

enum VolumeState {
	THREE, TWO, ONE, NONE,
}
var volume_dict := {
	VolumeState.THREE: 0.0,
	VolumeState.TWO: -6.0,
	VolumeState.ONE: -12.0,
	VolumeState.NONE: -80.0,
}
@export var volume_state:VolumeState = VolumeState.THREE


@export var use_old_art:bool = false
@export var music_option:int = 0

################################################################


func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)
	
	
func clear() -> void:
	self.bus_volume = {
		"Master": 1,
		"music": 1,
		"sfx": 1,
	}
	self.volume_state = VolumeState.THREE
	self.achievements_unlocked = {}
	self.use_old_art = false
	self.music_option = 0
	save()
	
	
static func load_or_create() -> SaveData:
	var res:SaveData
	if FileAccess.file_exists(SAVE_PATH):
		res = load(SAVE_PATH) as SaveData
	else:
		res = SaveData.new()
	return res
	
	
################################################################


func load_volume_state() -> VolumeState:
	return self.volume_state
	
func update_volume_state(new_state: VolumeState) -> void:
	self.volume_state = new_state
	self.save()


################################################################


func unlock_achievement(achievement: String) -> void:
	if not achievements_unlocked.has(achievement):
		achievements_unlocked[achievement] = true
		print("Unlocked achievement: " + achievement)
		self.save()

func has_unlocked(achievement: String) -> bool:
	return achievements_unlocked.get(achievement, false)

func has_unlocked_all() -> bool:
	for achievement in all_achievements:
		var unlocked = achievements_unlocked.get(achievement, false)
		if not unlocked:
			return false
	return true 
	

################################################################

# for displaying in achievements page
func get_all_achievements() -> Array:
	var achievements = []
	for achievement in all_achievements:
		var unlocked = has_unlocked(achievement)
		achievements.append({
			# "name": achievement.replace("_", " ").capitalize() if unlocked else "locked",
			"name": achievement if unlocked else "locked",
			"icon": achievement_icons.get(achievement, locked_icon) if unlocked else locked_icon,
			"hover_text": achievement_hover_text.get(achievement, locked_hover) if unlocked else locked_hover,
			"ach_name": achievement_names.get(achievement, locked_name) if unlocked else locked_name
		})
	return achievements
