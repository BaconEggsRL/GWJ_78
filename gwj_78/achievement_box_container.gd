class_name AchievementBoxContainer
extends Control

@onready var shadow_btn: Button = $shadow_btn
@onready var icon_rect: TextureRect = $shadow_btn/icon_rect
@onready var frame_btn: Button = $shadow_btn/icon_rect/frame_btn
@onready var name_label: Label = $name_label
@onready var sfx: String = ""



func _on_mouse_entered() -> void:
	# var msg = "entered: %s" % self.name
	# print(msg)
	self.shadow_btn.modulate = Color.YELLOW
	pass


func _on_mouse_exited() -> void:
	self.shadow_btn.modulate = Color.WHITE
	pass # Replace with function body.


func _on_shadow_btn_pressed() -> void:
	AudioManager.play_fx(self.sfx)
