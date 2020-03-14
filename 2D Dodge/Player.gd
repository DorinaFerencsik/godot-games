extends Area2D

# Player screen's script

# gyakorlatilag egy saját event, amit ki lehet küldeni a feliratkozott / figyelő node-oknak, objektumoknak
# (observable pattern)
signal hit

export var speed = 400 # pixel / second
var screen_size # game window's size


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"): 
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
		
	# pozíció beállítása
	# delta = frame lenght: mennyi idő telt el a legutóbbi frame óta -> egyenletes legyen a mozgás FPS-től függetlenül
	# clamp(a,min,max) - clamping: restricts value a between min and max 
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Animációk beállítása
	# csak "jobbra" és "felfele" animáció van behúzva, ezeket lehet tükrözni
		# vertikálisan és horizontálisan a flip_v és flip_h paraméterekkel 
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_v = velocity.y > 0
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

# ez a "Node" fülön van bekötve, a body_entered signalra / eventre hívódik meg
# gyak. más objektummokkal való ütközéskor fut le
func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	# disabled-re kell állítani hogy biztosítsuk, csak 1x fut le
	# set_defferred biztosítja hogy biztonságos legyen a beállítás 
		# (ha közvetlenül van manipulálva a $CollisionShape2D.disabled property hiba léphet fel - az engine még lehet az ütközés feldolgozás közepén tart)
	$CollisionShape2D.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
