extends Area2D

onready var sprite = $Sprite


# i = light blue
# j = blue
# l = orange
# o = yellow
# s = green
# t = purple
# z = red
func set_mino_color(tetrimino_type):
	match tetrimino_type:
		"i":
			sprite.frame = 0
		"j":
			sprite.frame = 1
		"l":
			sprite.frame = 2
		"o":
			sprite.frame = 3
		"s":
			sprite.frame = 4
		"t":
			sprite.frame = 6 # t and z are flipped because I messed up the sprite sheet
		"z":
			sprite.frame = 5
