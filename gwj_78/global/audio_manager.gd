extends Node

@export var MUSIC_PLAYER:AudioStreamPlayer
var ambient_players := {}
var active_fx_players: Dictionary = {}  # Store FX players with names

# set up audio bus names as follows:
# Master, music, ambient, sfx


# music
# list of all music
const SKETCHBOOK_2024_05_22 = preload("res://assets/sound/1_music/Sketchbook 2024-05-22.ogg")

# ambient
# list of all ambient sounds

# fx
# list of all sound effects
# phone
const _762973__TALKTOMEGOOSE_10__PHONE_RINGING = preload("res://assets/sound/3_fx/762973__talktomegoose10__phone-ringing.wav")
const PICK_UP_PHONE = preload("res://assets/sound/3_fx/pick_up_phone.wav")
const SLAM_DOWN_PHONE = preload("res://assets/sound/3_fx/slam_down_phone.wav")
# door
const DOOR_UNLOCK_92281 = preload("res://assets/sound/3_fx/door-unlock-92281.mp3")
const HOME_DOOR_HANDLE_WIGGLE_7 = preload("res://assets/sound/3_fx/home door handle wiggle 7.wav")
const HOME_DOOR_WITH_LOTS_OF_ROOM_ECHO_CLOSE_7 = preload("res://assets/sound/3_fx/home door with lots of room echo close 7.wav")
const KNOCKING_FROM_OUTSIDE_1 = preload("res://assets/sound/3_fx/knocking from outside 1.wav")
const KNOCKING_FROM_OUTSIDE_11 = preload("res://assets/sound/3_fx/knocking from outside 11.wav")

const ITEM_PICK_UP_38258 = preload("res://assets/sound/3_fx/item-pick-up-38258.mp3")
const OBJ_CONT_FLASK_WOOD_CANTEEN_MEDIUM_CLOTHSTRAP_METALBANDING_WOODCORK_LIQUID_SHAKING_SLOSHING_EWKR = preload("res://assets/sound/3_fx/OBJCont_Flask,wood,canteen,medium,clothstrap,metalbanding,woodcork,liquid,shaking,sloshing_EWKR.wav")
const PISTOL_SHOT_233473 = preload("res://assets/sound/3_fx/pistol-shot-233473.mp3")
const WOODEN_DESK_DRAWER_OPEN_12 = preload("res://assets/sound/3_fx/wooden desk drawer open 12.wav")
const SPLATTT_6295 = preload("res://assets/sound/3_fx/splattt-6295.mp3")
const SOUND_EFFECT_005_OBJECT_DRAGGING_BODY_265185 = preload("res://assets/sound/3_fx/sound-effect-005-object-dragging-body-265185.wav")

const WEBCAM_OFF = preload("res://assets/sound/3_fx/slap 14.wav")
const SLURP_76969 = preload("res://assets/sound/3_fx/slurp-76969.mp3")
const SINK_RUNNING = preload("res://assets/sound/3_fx/sink_running.wav")
const GARBAGE_DISPOSAL = preload("res://assets/sound/3_fx/garbage_disposal-56458.wav")
const NIGHTSTAND_DRAWER_CLOSE_9 = preload("res://assets/sound/3_fx/nightstand drawer close 9.wav")
const FBI_OPEN_UP = preload("res://assets/sound/3_fx/fbi-open-up-sfx.mp3")
const YAY = preload("res://assets/sound/3_fx/yay-6326.mp3")


func play_ambient(ambient_name: String, fade_in_time: float = 2.0, final_db: float = -6.0) -> void:
	if ambient_name in ambient_players:
		# push_warning("Ambient sound '%s' is already playing" % ambient_name)
		return

	var ambient_stream: AudioStream
	match ambient_name:
		"ambient_1":
			ambient_stream = null  # insert ambient const here
		_:
			push_warning("'%s' has no resource listed in AudioManager" % ambient_name)
			return

	if ambient_stream:
		
		var ambient_player := AudioStreamPlayer.new()
		ambient_player.stream = ambient_stream
		ambient_player.bus = "ambient"  # Make sure you have an "Ambient" bus in the audio settings
		ambient_player.volume_db = -80.0  # Start silent
		# ambient_player.loop = true  # Ensure looping
		add_child(ambient_player)
		ambient_player.play()

		# Store the player reference
		ambient_players[ambient_name] = ambient_player

		# Fade-in effect
		var tween = get_tree().create_tween()
		tween.tween_property(ambient_player, "volume_db", final_db, fade_in_time)


func stop_ambient(ambient_name: String, fade_out_time: float = 2.0) -> void:
	if ambient_name not in ambient_players:
		push_warning("Ambient sound '%s' is not currently playing" % ambient_name)
		return

	var ambient_player = ambient_players[ambient_name]
	var tween = get_tree().create_tween()
	tween.tween_property(ambient_player, "volume_db", -80.0, fade_out_time)
	await tween.finished

	# Remove player from dictionary and free it
	ambient_players.erase(ambient_name)
	ambient_player.queue_free()
	
	
func stop_music(fade_out_time=0.5, music_player:=MUSIC_PLAYER) -> void:
	var tween_out = get_tree().create_tween()
	tween_out.tween_property(music_player, "volume_db", -80.0, fade_out_time)
	await tween_out.finished
	# Ensure music stops and resets
	music_player.stop()
	music_player.stream = null  # Reset to ensure _play_music() reloads it
		
		
func _play_music(
	music:AudioStream, 
	final_db:=0.0, 
	fade_out:bool=true, 
	fade_out_time:float=0.5,
	fade_in:bool=true,
	fade_in_time:float=0.5,
	init:bool=false,
	init_db:float = -80.0,
	music_player:=MUSIC_PLAYER) -> void:

	# If the music is currently being played already, do nothing
	if music_player.stream == music:
		return
	
	
	# don't fade out prev track if there's no stream
	if !music_player.stream:
		fade_out = false

	
	# check if should fade audio in/out
	if fade_out:
		var tween_out = get_tree().create_tween()
		tween_out.tween_property(music_player, "volume_db", -80.0, fade_out_time)
		await tween_out.finished
	
	else:
		
		# check if we need to initialize the volume
		if init:
			music_player.volume_db = init_db
		
		if fade_in:
			# audio_player.stop()
			music_player.stream = music
			music_player.play()
			
			var tween_in = get_tree().create_tween()
			tween_in.set_ease(Tween.EASE_OUT)
			tween_in.set_trans(Tween.TRANS_CUBIC)
			tween_in.tween_property(music_player, "volume_db", final_db, fade_in_time)
			await tween_in.finished
		
		else:
			
			# audio_player.stop()
			music_player.stream = music
			music_player.volume_db = final_db
			music_player.bus = "music"
			music_player.play()


# Play music for scene
func play_music(scene_name:String, final_db:float=0.0, fade_in_time=0.5) -> void:
	var music:Resource
	var fade_out:bool = true
	var fade_out_time = 0.5
	var fade_in:bool = true
	var init:bool = false
	var init_db:float = -80.0
	match scene_name:
		"music_1":
			music = null  # insert music const here
		"music_funk":
			music = SKETCHBOOK_2024_05_22
		_:
			push_warning("'%s' has no resource listed in AudioManager" % scene_name)
	
	if music:
		_play_music(music, final_db, fade_out, fade_out_time, fade_in, fade_in_time, init, init_db)


func play_fx(fx_name:String, volume:float=0.0, _index:int=-1) -> AudioStreamPlayer:
	var fx:Resource
	var pitch:float = 1.0
	match fx_name:
		"scene_transition":
			fx = null  # for any time scene changes
		"pitch_var_1":
			fx = null  # insert fx const here
			var diff = 0.2
			pitch = randf_range(1.0 - diff, 1.0 + diff)
		"random_1":
			fx = [].pick_random()  # can pick random from array of sounds
		"door_unlock":
			fx = DOOR_UNLOCK_92281
		"item_pickup":
			fx = ITEM_PICK_UP_38258
		"locked_door_wiggle":
			fx = HOME_DOOR_HANDLE_WIGGLE_7
		"mopping_sound":
			fx = OBJ_CONT_FLASK_WOOD_CANTEEN_MEDIUM_CLOTHSTRAP_METALBANDING_WOODCORK_LIQUID_SHAKING_SLOSHING_EWKR
		"gun_shot":
			fx = PISTOL_SHOT_233473
			var diff = 0.2
			pitch = randf_range(1.0 - diff, 1.0 + diff)
		"curtains":
			fx = WOODEN_DESK_DRAWER_OPEN_12
			var diff = 0.2
			pitch = randf_range(1.0 - diff, 1.0 + diff)
		"phone_ring":
			fx = _762973__TALKTOMEGOOSE_10__PHONE_RINGING
		"pick_up_phone":
			fx = PICK_UP_PHONE
		"slam_down_phone":
			fx = SLAM_DOWN_PHONE
		"trash":
			fx = SPLATTT_6295
		"body_drag":
			fx = SOUND_EFFECT_005_OBJECT_DRAGGING_BODY_265185
		"door_open":
			fx = HOME_DOOR_WITH_LOTS_OF_ROOM_ECHO_CLOSE_7
		"window_knock":
			fx = KNOCKING_FROM_OUTSIDE_11
		"webcam_off":
			fx = WEBCAM_OFF
		"drink_blood":
			fx = SLURP_76969
		"sink_running":
			fx = SINK_RUNNING
		"garbage_disposal":
			fx = GARBAGE_DISPOSAL
		"nightstand":
			fx = NIGHTSTAND_DRAWER_CLOSE_9
		"fbi":
			fx = FBI_OPEN_UP
		"yay":
			fx = YAY
		_:
			push_warning("'%s' has no resource listed in AudioManager" % fx_name)
	
	if fx:
		return _play_fx(fx_name, fx, volume, pitch)
		
	return null
	
	
	
	
func _play_fx(fx_name: String, stream: AudioStream, volume: float = 0.0, pitch: float = 1.0) -> AudioStreamPlayer:
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER_" + fx_name  # Name it uniquely
	fx_player.volume_db = volume
	fx_player.pitch_scale = pitch
	fx_player.bus = "sfx"
	
	add_child(fx_player)
	
	if not active_fx_players.has(fx_name):
		active_fx_players[fx_name] = []
	
	active_fx_players[fx_name].append(fx_player)  # Track this FX under its name
	
	if fx_player != null:
		# play the fx
		fx_player.play()
		# Handle cleanup separately without blocking return
		_cleanup_fx(fx_name, fx_player)
	
	# Return the fx_player
	return fx_player
	
	

func stop_fx(fx_name: String, fade_time: float = 0.5) -> void:
	if active_fx_players.has(fx_name):
		for fx_player in active_fx_players[fx_name]:
			if is_instance_valid(fx_player):  # Ensure it's still valid
				var tween = get_tree().create_tween()
				tween.tween_property(fx_player, "volume_db", -80.0, fade_time)  # Fade out
				await tween.finished
				if fx_player != null:
					fx_player.stop()
					fx_player.queue_free()
		
		active_fx_players.erase(fx_name)  # Remove all instances of that FX


func _cleanup_fx(fx_name: String, fx_player: AudioStreamPlayer) -> void:
	await fx_player.finished  # Wait until the sound is done
	
	if active_fx_players.has(fx_name):
		active_fx_players[fx_name].erase(fx_player)  # Remove from tracking
		
	fx_player.queue_free()  # Free memory
	
	
	

func clear(fade_time:float = 2.0) -> void:
	# stop music
	stop_music(fade_time)
	# clear fx
	if active_fx_players:
		var fx_players = active_fx_players.keys()
		for fx_player in fx_players:
			if active_fx_players.has(fx_player):  # Ensure key still exists
				stop_fx(fx_player, fade_time)
		
		
