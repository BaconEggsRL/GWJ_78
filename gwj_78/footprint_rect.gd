extends TextureRect


func _ready() -> void:
	var tween:Tween = create_tween()
	tween.tween_property(self, "self_modulate:a", 0.0, 1.0)
	tween.finished.connect(func():
		self.hide()
		self.queue_free.call_deferred()
	)
