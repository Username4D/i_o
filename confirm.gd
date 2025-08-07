extends CanvasLayer

@export var out = "save"

signal lol

func _on_save_pressed() -> void:
	out = "save" if $save.button_pressed else "cancel"
	lol.emit()
