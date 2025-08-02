extends CanvasLayer

var valid_chars_num = ["0","1","2","3","4","5","6","7","8","9","."]
var valid_chars_str = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " ", "0", "9", "8", "7", "6", "5", "4", "3", "2", "1"]

@export var medals = [0.0, 0.0, 0.0]
@export var level_name = ""

func check_text(texts: String, obj: Node, sets: Array) -> void:
	var text = obj.text
	var newtext = ""
	if text:
		for i in range(0, text.length(), 1):
			var out = ""
			var c = text[i]
			for n in sets:
				if c == n or c == n.capitalize():
					out = c
			newtext += out
		obj.text = newtext

func _ready() -> void:
	$settings/name.text_submitted.connect(check_text.bind($settings/name, valid_chars_str))
	$settings/bronze.text_submitted.connect(check_text.bind($settings/bronze, valid_chars_num))
	$settings/silver.text_submitted.connect(check_text.bind($settings/silver, valid_chars_num))
	$settings/gold.text_submitted.connect(check_text.bind($settings/gold, valid_chars_num))

func _process(delta: float) -> void:
	medals = [int($settings/gold.text),int($settings/silver.text),int($settings/bronze.text)]
	level_name = $settings/name.text
