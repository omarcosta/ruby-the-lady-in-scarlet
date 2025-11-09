class_name Player
extends CharacterBody2D

# Variaveis carregadas automaticamente quando o node é renderizado
# @onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_player: Sprite2D = $Sprite
# @onready var sword_area: Area2D = $SwordArea
# @onready var hit_area: Area2D = $HitArea
# @onready var death_prefab: PackedScene = preload("res://scenes/resources/death.tscn")

@export_category("Player") # Caracteristicas do player
@export_group("Player attributes")
@export_range(0, 999) var health: int = 100
@export_range(0, 999) var max_health: int = 100
# @export_range(0, 999) var stamina: float = 100.0
# @export_range(0, 999) var max_stamina: int = 100
# @export_range(0, 999) var magic: int = 100
# @export_range(0, 999) var max_magic: int = 100
# @export_range(1, 99) var attack_points: int = 5
# @export_range(1, 99) var stamina_for_attack: int = 20
@export var speed: float = 300.0
@export var jump_force: float = -450.0
# @export var speed: float = 2.0

@export_group("Balancing coefficients") # Coeficientes
# @export_range(0,1) var coeff_velocity_atk: float = 0.25 # Redução de VEL ao ATK
# @export_range(1, 2.5) var coeff_velocity_run: float = 1.35 # Redução de VEL ao RUN
# @export_range(1, 3) var coeff_atk_strong: float = 1.30 # Acrescimo de custo de estamina para atk forte 
# @export_range(0, 100) var coeff_stamina_recovery: float = 0.75 # recureperação de stamina do FPS
@export_range(0,1) var deadzone: float = 0.15 # Zona que será ignorada para evitar problemas em controles com analógicos

# Variaveis manipuladas no código
# var is_attacking: bool = false # O jogador esta atacando
# var is_running: bool = false # O Jogar está correndo
# var is_hit: bool = false # O jogador está levando dano
# var is_available_skill_a = true # Habilidade está disponivel para uso
#var attacking_cooldown: float = 0.0 # Contador de tempo para atacar
#var hit_cooldown: float = 0.0 # Contador de tempo para levar dano
#var stamina_recovery_cooldown: float = 0.0 # Temporizador de quando começa a restauração de stamina
# var skill_a_cooldown: float = 0.0 # Contador de tempo para usar habilidade
# var attacking_orientation: String = "RIGHT" # Define qual o lado do ataque: right, left, up, down
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var horizontal_direction: float = 0.0
# var deadzone: float = 0.1
# var input_direction: Vector2 = Vector2(0 , 0)
var target_velocity: Vector2 = Vector2(0 , 0)



func _ready():
	# GameManager.player_life_points_max = max_health
	# GameManager.player_stamina_points_max = max_stamina
	# GameManager.player_magic_points_max = max_magic
	pass


func _process(delta) -> void:
	#GameManager.player_position = position
	GameManager.player_position = global_position
	#print("Posição local: ", position, " | Posição global: ", global_position)
	# GameManager.player_life_points = health
	# GameManager.player_stamina_points = stamina
	# GameManager.player_magic_points = magic
	
	# rotate_sprite() # Change sprite side
	#    default_animations() # # Animações padrão do player
	# update_atk_cooldown(delta) # Temporizador de ATK
	# update_hit_cooldown(delta) # Teporizador de levar dano
	# update_stamina_recovery_cooldown(delta)
	# Call ATK Func
	#if Input.is_action_just_pressed("atk_waek"):
		#attack("w")
	#elif Input.is_action_just_pressed("atk_strong"):
		#attack("s")
	#runnig() # Define se o personagem está correndo
	#stamina_for_running() # Gasto de stamina ao correr
	#stamina_recovery() # Restaura stamina
	# print(stamina)
	#deal_damage_to_player()
	#game_over()


func _physics_process(delta: float) -> void:
	horizontal_direction = Input.get_axis("move_left", "move_right") # Input movement
	rotate_sprite() # Change sprite side
	# --- 4. CÁLCULO DE FÍSICA ---
	if not is_on_floor(): # Apply gravity
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = jump_force

	var target_velocity_x = horizontal_direction * speed
	velocity.x = lerp(velocity.x, target_velocity_x, 0.1)

	move_and_slide()


func rotate_sprite() -> void:
	#if !is_attacking:
	if horizontal_direction > 0:
		sprite_player.flip_h = false
	elif horizontal_direction < 0:
		sprite_player.flip_h = true


func default_animations() -> void: 
	#if not input_direction.is_zero_approx() and !is_attacking:
		#if Input.is_action_pressed("move_run"):
		#if Input.is_action_pressed("move_run") and stamina > 2: # o 2 é para estabilizar o stamina que vai ocilar entre -1 e 1
			#animation_player.play("run")
			# is_running = true
		#else: 
			#animation_player.play("walk")
			#is_running = false
	#elif input_direction.is_zero_approx() and !is_attacking: 
		#animation_player.play("idle")
		pass

func runnig() -> void:
	#if Input.is_action_pressed("move_run") and not input_direction.is_zero_approx() and stamina > 0 and not is_attacking:
	#	is_running = true
	#else:
		#is_running = false
	# print(is_running, " | ", stamina)
	pass
		

#func attack(atk_type: String) -> void:
	#if is_attacking: # Ignora a função se já estiver em ação de ataque
	#	return
	#if stamina < stamina_for_attack: # Ignora a função não tiver estamina
	#	SoundManager.sound_effect_player_not_stamina()
	#	return
	#if atk_type == "s":
	#	stamina -= stamina_for_attack * coeff_atk_strong
	#else:
	#	stamina -= stamina_for_attack
	#attack_type_and_orientation(atk_type)
	#is_attacking = true # Define que o personagem está atacando
	#attacking_cooldown = animation_player.current_animation_length + 0.2 # O cooldown será a duração da animação
	#stamina_recovery_cooldown = attacking_cooldown * 1.3 # Garante que durante ataques seguidos não recupere stamina


#func attack_type_and_orientation(type: String) -> void:
	# ATK type "w" = waek | ATK type "s" = strong
	#if input_direction.x == 0 and input_direction.y < 0: 
		#animation_player.play(str("atk_up_",type)) # Reproduz animação
		#attacking_orientation = "UP" # Difine orientação
	#elif input_direction.x == 0 and input_direction.y > 0:
		#animation_player.play(str("atk_down_",type))
		#attacking_orientation = "DOWN"
	#else: 
		#animation_player.play(str("atk_side_",type))
		#if sprite_player.flip_h:
			#attacking_orientation = "LEFT"
		#else:
			#attacking_orientation = "RIGHT"


#func stamina_recovery() -> void:
	#if is_attacking or is_running: # Ignora a função se já estiver em ação de ataque
		#return
	#if stamina_recovery_cooldown <= 0.0:
		#if stamina >= max_stamina:
			#stamina = max_stamina
		#else:
			#stamina += coeff_stamina_recovery


#func stamina_for_running() -> void:
	#if not is_running:
		#return
	#if stamina > 0: #and stamina < 0.2: 
		#stamina -= stamina_for_attack * 0.02
		#if stamina < 1: 
			#stamina = 0


#func update_atk_cooldown(delta: float)-> void:
	#if not is_attacking: return
	#attacking_cooldown -= delta
	#if attacking_cooldown <= 0.0:
		#is_attacking = false


#func update_hit_cooldown(delta: float)-> void:
	#if not is_hit: return
	#hit_cooldown -= delta
	#if hit_cooldown <= 0.0:
		#is_hit = false


#func update_stamina_recovery_cooldown(delta: float)-> void:
	#if is_attacking: return
	#stamina_recovery_cooldown -= delta


#func deal_damage_to_enemies(type: String) -> void:
	#var bodies = sword_area.get_overlapping_bodies() # Obtem todos os corpos f[isicos na area. Pode ser mudado para pegar a area
	#for body in bodies:
		#if body.is_in_group("enemies"):
			#var enemy: Enemy = body
			# var direction_to_enemy = (enemy.position - position).normalized()
			#var direction_to_enemy = (enemy.global_position - global_position).normalized()
			#var attack_direction: Vector2
			#match attacking_orientation:
				#"UP":
				#	attack_direction = Vector2.UP
				#"DOWN":
				#	attack_direction = Vector2.DOWN
				#"LEFT":
				#	attack_direction = Vector2.LEFT
				#_: # Right
					#attack_direction = Vector2.RIGHT
			#var dot_product = direction_to_enemy.dot(attack_direction)
			#if dot_product >= 0.75:
			#	if type == "s":
			#		enemy.suffered_damage(ceil(attack_points * coeff_atk_strong))
			#	else: 
			#		enemy.suffered_damage(attack_points)
		


#func deal_damage_to_player() -> void:
	#if is_hit: return
	#var bodies = hit_area.get_overlapping_bodies() # Obtem todos os corpos f[isicos na area. Pode ser mudado para pegar a area
	#for body in bodies:
		#if body.is_in_group("enemies"):
			#var enemy: Enemy = body
			#suffered_damage(enemy.damage)
			#is_hit = true
			#hit_cooldown = 1


#func suffered_damage(amount: int) -> void: 
	#health -= amount
	#reaction_to_damage()
	#SoundManager.sound_effect_player_received_damage()


#func reaction_to_damage() -> void:
	#modulate = Color.FIREBRICK
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_IN)
	#tween.set_trans(Tween.TRANS_QUINT)
	#tween.tween_property(self, "modulate", Color.WHITE, 0.3)


func game_over() -> void: 
	#if health > 0: 
		# return
	GameManager.player_life_points = health
	GameManager.gameover = true
	die()


func die() -> void:
	#if death_prefab:
		#var death_object = death_prefab.instantiate()
		#death_object.position = position
		# death_object.scale = scale
		#get_parent().add_child(death_object)
		#SoundManager.sound_effect_player_death()
		#GameManager.gameover = true
		# GameManager.activate_gameover_screen = true
	#queue_free()
	pass


#func get_resources(amount: int, type: String):
	#match type:
		#"health":
			#if health + amount < max_health:
			#	health += amount
			#else:
			#	health = max_health
			#return health
		#"magic":
		#	if magic + amount < max_magic:
		#		magic += amount
		#	else:
		#		magic = max_magic
		#	return magic
		#"gold":
		#	pass
		#"ammo":
		#	if (GameManager.technique_reserve_ammo + amount) > GameManager.technique_max_reserver_ammo:
		#		GameManager.technique_reserve_ammo = GameManager.technique_max_reserver_ammo
		#	else:
		#		GameManager.technique_reserve_ammo += amount
		#_: # Default
		#	return


#func audio_atk_weak_play():
#	SoundManager.sound_effect_player_atk("weak")


#func audio_atk_strong_play():
#	SoundManager.sound_effect_player_atk("strong")
