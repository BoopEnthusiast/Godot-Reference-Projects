extends Area2D

signal on_health_changed(new_health : int)
@export var max_health : int = 6
@onready var damage_timer = $damageTimer
var health : int
var can_take_damage : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	emit_signal("on_health_changed", health)

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		take_damage()
	elif body.is_in_group("health"):
		heal(body)
		

func take_damage():
	if can_take_damage:
		health = health - 1
		emit_signal("on_health_changed", health)
		
		if health <= 0:
			print("you died!")
		else:
			can_take_damage = false
			damage_timer.connect("timeout", allow_damage())
			damage_timer.start()
	
func heal(body):
	if health < max_health:
		health = health + 1
		emit_signal("on_health_changed", health)
		body.get_parent().queue_free()
	
func allow_damage():
	can_take_damage = true
	
