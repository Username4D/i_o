extends CanvasLayer

var valid_chars_num = ["0","1","2","3","4","5","6","7","8","9","."]
var valid_chars_str = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", " ", "0", "9", "8", "7", "6", "5", "4", "3", "2", "1"]

@export var medals = [0.0, 0.0, 0.0]
@export var level_name = ""
@export var palette = [Color.from_hsv(1,1,1), Color.from_hsv(1,1,1), Color.from_hsv(1,1,1)]

func check_text(texts: String, obj: Node, sets: Array) -> void:
	var text = obj.text
	var newtext = ""
	var dots = 0
	if text:
		for i in range(0, text.length(), 1):
			var out = ""
			var c = text[i]
			for n in sets:
				if c == n or c == n.capitalize():
					if c != ".":
						out = c
					else:
						if dots == 0:
							dots = 1
							out = c
			newtext += out
		obj.text = newtext
	if obj.text == "":
		obj.text = obj.placeholder_text
func _ready() -> void:
	$settings/name.text_submitted.connect(check_text.bind($settings/name, valid_chars_str))
	$settings/bronze.text_submitted.connect(check_text.bind($settings/bronze, valid_chars_num))
	$settings/silver.text_submitted.connect(check_text.bind($settings/silver, valid_chars_num))
	$settings/gold.text_submitted.connect(check_text.bind($settings/gold, valid_chars_num))
func _process(delta: float) -> void:
	medals = [int($settings/gold.text),int($settings/silver.text),int($settings/bronze.text)]
	level_name = $settings/name.text
	palette = [$"colors/1".color, $"colors/2".color, $"colors/3".color]
func init() -> void:
	$settings/name.text = level_name
	$settings/bronze.text = var_to_str(medals[2])
	$settings/silver.text = var_to_str(medals[1])
	$settings/gold.text = var_to_str(medals[0])
	print(palette)
	var c1 = palette[0]
	var c2 = palette[1]
	var c3 = palette[2]
	self.get_node("colors").get_node("1").init(Color.from_hsv(c1[0], c1[1], c1[2]))
	self.get_node("colors").get_node("2").init(Color.from_hsv(c2[0], c2[1], c2[2]))
	self.get_node("colors").get_node("3").init(Color.from_hsv(c3[0], c3[1], c3[2]))
func error(err: String) -> void:
	match err:
		"order":
			$error.text = "Times must be in Order: Bronze > Silver > Gold"
		"none":
			$error.text = ""
	$error.visible = true
