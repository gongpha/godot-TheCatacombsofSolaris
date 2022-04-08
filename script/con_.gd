extends Control

var vvv : PoolVector2Array

func _draw() :
	for v in vvv :
		var ve : Vector2 = v * rect_size 
		draw_circle(ve, 3, Color.aqua)
		draw_string(get_font(""), ve, str(v))
