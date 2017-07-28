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
	for i in range(points_tracking.size()):
		if i != 0:
			draw_line(points_tracking[i - 1], points_tracking[i], Color(1.0, 1.0, 1.0), point_width / 2)
	
	draw_circle(Vector2(point_pos_x,point_pos_y), point_width, Color(1.0, 1.0, 1.0))

func _on_Button_pressed():
	if is_pulsing:
		return
	is_pulsing = true
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y + 10, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	pikes_tween.connect("tween_complete", self, "_on_first_down_pike_reached", [], CONNECT_ONESHOT)
	pikes_tween.start()

##
# Animation stuff
##
func _on_first_down_pike_reached(obj, key):
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y - 10, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pikes_tween.connect("tween_complete", self, "_on_first_up_pike_reached", [], CONNECT_ONESHOT)
	pikes_tween.start()

func _on_first_up_pike_reached(obj, key):
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y + 50, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pikes_tween.connect("tween_complete", self, "_on_second_down_pike_reached", [], CONNECT_ONESHOT)
	pikes_tween.start()
	
func _on_second_down_pike_reached(obj, key):
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y - 150, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pikes_tween.connect("tween_complete", self, "_on_second_up_pike_reached", [], CONNECT_ONESHOT)
	pikes_tween.start()
	
func _on_second_up_pike_reached(obj, key):
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y + 110, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pikes_tween.connect("tween_complete", self, "_on_third_down_pike_reached", [], CONNECT_ONESHOT)
	pikes_tween.start()
	
func _on_third_down_pike_reached(obj, key):
	pikes_tween.interpolate_property(self, "point_pos_y", point_pos_y, point_pos_y - 10, 0.05, Tween.TRANS_LINEAR, Tween.EASE_IN)
	pikes_tween.start()
	pikes_tween.connect("tween_complete", self, "_on_pikes_animation_end", [], CONNECT_ONESHOT)

func _on_pikes_animation_end(obj, key):
	is_pulsing = false