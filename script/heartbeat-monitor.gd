extends Node2D

var point_pos_x = 0
var point_pos_y = 0
var point_vel = Vector2(150, 0)
var point_width = 5

var points_tracking = []

var is_pulsing = false

var pikes_tween = Tween.new()

onready var size_viewport_x = get_viewport_rect().size.x

func _ready():
	add_child(pikes_tween)
	set_process(true)

func _process(delta):
	point_pos_x = point_pos_x + point_vel.x * delta
	point_pos_y = point_pos_y + point_vel.y * delta
	
	if point_pos_x - point_width > size_viewport_x:
		point_pos_x = 0
		points_tracking.clear()
	
	points_tracking.append(Vector2(point_pos_x, point_pos_y))
	
	update()

func _draw():
	for i in points_tracking:
		draw_circle(i, point_width / 2, Color(1.0, 1.0, 1.0))
	
	draw_circle(Vector2(point_pos_x,point_pos_y), point_width, Color(1.0, 1.0, 1.0))

func _on_top_pike_reached(obj, key):
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y + 100, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	pikes_tween.start() 
	
	pikes_tween.connect("tween_complete", self, "_on_down_pike_reached", [], CONNECT_ONESHOT)

func _on_down_pike_reached(obj, key):
	is_pulsing = false

func _on_Button_pressed():
	if is_pulsing:
		return
	
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y - 100, 1, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	pikes_tween.connect("tween_complete", self, "_on_top_pike_reached", [], CONNECT_ONESHOT)
	pikes_tween.start()
	
	is_pulsing = true
