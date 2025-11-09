class_name Player
extends CharacterBody2D

# -- Carregamento de NODES --
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var hazard_area: Area2D = $HazardDetector
@onready var sprite_player: Sprite2D = $Sprite
# @onready var death_prefab: PackedScene = preload("res://scenes/resources/death.tscn")

# -- Propriedades visíveis no INSPECTOR --
@export_category("Player") 
# Caracteristicas do player
@export_group("Player attributes")
@export var SPEED: float = 150.0
@export var JUMP_VELOCITY: float = -300.0
# Coeficientes de balanciamento
@export_group("Balancing coefficients") # Coeficientes
@export_range(1, 2.5) var RUN_SPEED: float = 1.8 # Velocidade de corrida
@export_range(0, 1) var LERP_WEIGHT: float = 0.15 # Deslizamento
# @export_range(0,1) var deadzone: float = 0.15 # Zona que será ignorada para evitar problemas em controles com analógicos

# -- Variaveis manipuladas no código --
var run_speed: float = 0.0
var horizontal_direction: float = 0.0
var target_velocity: Vector2 = Vector2(0 , 0)
var idle_timer: float = 0.0
var flying_timer: float = 0.0
var was_on_floor = true # Usado para detectar aterrissagem

# -- States Machine (FSM) --
enum State { 
	IDLE, 
	IDLE_FRONT, 
	WALKING, 
	RUNNING, 
	STOPING, 
	PUSHING, 
	JUMPING, # Estado de "subida"
	FALLING, 
	LANDING, 
	DEAD 
}
var current_state = State.IDLE_FRONT # Começa em IdleFront

# -- Constantes --
var GRAVITY: float = ProjectSettings.get_setting("physics/2d/default_gravity")
const IDLE_FRONT_TIME: float = 25.0



func _ready():
	run_speed = SPEED * RUN_SPEED
	anim.connect("animation_finished", _on_animation_finished)
	hazard_area.connect("body_entered", _on_hazard_entered)
	# GameManager.player_life_points_max = max_health


func _physics_process(delta: float) -> void:
		# --- 1. ESTADO MORTO: A prioridade máxima ---
	if current_state == State.DEAD:
		velocity = Vector2.ZERO
		move_and_slide() # Aplica o VETOR ZERO
		return

	# --- 2. INPUTS ---
	var direction = Input.get_axis("move_left", "move_right")
	var is_run_held = Input.is_action_pressed("run")
	var is_jump_pressed = Input.is_action_just_pressed("move_up")

	# --- 3. GRAVIDADE (Aplicar sempre) ---
	if not is_on_floor():
		velocity.y += GRAVITY * delta # Use a var GRAVITY definida no topo
		flying_timer += delta # Acumula tempo no ar
	else:
		flying_timer = 0 # Zera o timer no chão
		
	# --- 4. CÁLCULO DE VELOCIDADE HORIZONTAL ---
	# Animações "one-shot" (STOPING, LANDING) devem continuar desacelerando
	if current_state == State.LANDING or current_state == State.STOPING:
		velocity.x = lerp(velocity.x, 0.0, LERP_WEIGHT)
	
	# Se o jogador quer se mover (direction != 0)
	elif direction != 0:
		idle_timer = 0.0 # Reseta timer de idle
		
		if is_run_held:
			velocity.x = lerp(velocity.x, direction * run_speed, LERP_WEIGHT)
		else:
			velocity.x = direction * SPEED

	# Se o jogador está parado (direction == 0)
	else:
		# (WALKING STOP): Se estava ANDANDO, para imediatamente
		if current_state == State.WALKING:
			velocity.x = 0.0
		# (RUNNING STOP): Se estava CORRENDO (ou Idle, etc.), usa LERP
		else:
			velocity.x = lerp(velocity.x, 0.0, LERP_WEIGHT)

	# --- 5. AÇÃO: PULO (Sobrescreve velocidade Y) ---
	if is_jump_pressed and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# --- 6. APLICAR MOVIMENTO ---
	# Salva o estado do chão ANTES de mover
	was_on_floor = is_on_floor()
	move_and_slide()

	# --- 7. LÓGICA DE TRANSIÇÃO DE ESTADOS (Pós-Movimento) ---
	if current_state == State.LANDING or current_state == State.STOPING:
		pass # Espera a animação terminar (veja _on_animation_finished)

	# LÓGICA NO AR
	elif not is_on_floor():
		if velocity.y < 0:
			set_state(State.JUMPING)
		else:
			set_state(State.FALLING)
	
	# LÓGICA NO CHÃO
	else:
		# ATERRISSAGEM (LANDING):
		if not was_on_floor:
			# REQ 3 (LANDING): Tempo de 1.4s (como já estava no código)
			if flying_timer > 0.75: 
				set_state(State.LANDING)

		# PUSHING:
		elif direction != 0 and is_on_wall():
			set_state(State.PUSHING)

		# RUNNING:
		elif direction != 0 and is_run_held:
			set_state(State.RUNNING)

		# WALKING:
		elif direction != 0:
			set_state(State.WALKING)

		# PARADO (STOPING / IDLE):
		else:
			if current_state == State.RUNNING:
				set_state(State.STOPING)
			
			elif current_state != State.STOPING:
				idle_timer += delta
				if idle_timer >= IDLE_FRONT_TIME:
					set_state(State.IDLE_FRONT)
				else:
					set_state(State.IDLE) # Garante estado Idle normal

	# --- 8. ATUALIZAR ROTAÇÃO (Flip) ---
	if direction != 0:
		sprite_player.flip_h = (direction < 0) # Vira para esquerda


# --- FUNÇÃO CENTRAL DA FSM (A "Estrutura Segura") ---
func set_state(new_state):
	# Se já estamos no estado, não faça nada
	if current_state == new_state:
		return
	
	current_state = new_state
	
	match current_state:
		State.IDLE:
			play_new_animation("Idle")
		State.IDLE_FRONT:
			play_new_animation("IdleFront")
		State.WALKING:
			play_new_animation("Walking")
		State.RUNNING:
			play_new_animation("Running")
		State.STOPING:
			play_new_animation("Stoping")
		State.PUSHING:
			play_new_animation("Pushing")
		State.JUMPING:
			play_new_animation("Jumping") # Animação de subida
		State.FALLING:
			play_new_animation("Falling") # Animação de queda
		State.LANDING:
			play_new_animation("Landing")
		State.DEAD:
			play_new_animation("Die")


# --- PLAY Animation ---
func play_new_animation(anim_name):
	if anim.current_animation != anim_name:
		anim.play(anim_name)


# -- Verifica se animações ONE-SHOT finalizaram
func _on_animation_finished(anim_name) -> void:
	# Quando "Stoping" acabar, vá para "Idle"
	if anim_name == "Stoping":
		idle_timer = 0.0 # Reseta o timer do IdleFront
		set_state(State.IDLE)
	# Quando "Landing" acabar, vá para "Idle"
	if anim_name == "Landing":
		idle_timer = 0.0 # Reseta o timer
		set_state(State.IDLE)
	# Quando "Die" acabar, pode emitir um sinal de game over, etc.
	if anim_name == "Die":
		# ex: get_tree().reload_current_scene()
		pass


# -- Verifica se o player colidiou um objeto que o mate
func _on_hazard_entered(body):
	if body.is_in_group("Hazards"):
		set_state(State.DEAD)



func game_over() -> void: 
	#if health > 0: 
		# return
	# GameManager.player_life_points = health
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


#func audio_atk_weak_play():
#	SoundManager.sound_effect_player_atk("weak")


#func audio_atk_strong_play():
#	SoundManager.sound_effect_player_atk("strong")
