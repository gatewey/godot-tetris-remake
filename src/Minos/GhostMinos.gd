extends Sprite

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
			frame = 0
		"j":
			frame = 1
		"l":
			frame = 2
		"o":
			frame = 3
		"s":
			frame = 4
		"t":
			frame = 6 # t and z are flipped because I messed up the sprite sheet
		"z":
			frame = 5
