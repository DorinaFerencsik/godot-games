extends RigidBody2D

export var min_speed = 150
export var max_speed = 250
var mob_types = ["swim", "walk", "fly"]


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# ez a "Node" fülön van bekötve, a VisibilityNotifier2D node screen_exited() signal-jára
func _on_VisibilityNotifier2D_screen_exited():
	# mob törlése
	queue_free()
