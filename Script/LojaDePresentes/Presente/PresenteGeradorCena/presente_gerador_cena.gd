extends HBoxContainer
class_name PresenteGeradorCena

signal mais_um_gerador(preco: int)
signal adicionar_mais_presente(quantidade: int)

@onready var sprite: TextureRect = $Sprite
@onready var geracao_presente: Timer = $GeracaoPresente

var preco: int = 0
var quantidade_de_presente : int = 0

var drag : bool = false
var drag_offset : Vector2 = Vector2.ZERO

func configurar_presente(presente: Presente, posicao : Vector2) -> void:
	
	var imagem : Image = presente.textura.get_image()
	
	imagem.resize(64,64, Image.INTERPOLATE_LANCZOS)

	var nova_textura = ImageTexture.create_from_image(imagem)
	
	@warning_ignore("narrowing_conversion")
	preco = presente.preco * 0.35
	quantidade_de_presente = 1
	
	_atualizar_tooltip()
	
	sprite.texture = nova_textura
	global_position = posicao
	
	geracao_presente.start()

func _on_mais_pressed() -> void:
	
	var cena_atual = get_tree().current_scene
	
	var numero_presentes = cena_atual.numero_presentes
	
	if numero_presentes >= preco:
		quantidade_de_presente += 1
		mais_um_gerador.emit(preco)
		@warning_ignore("narrowing_conversion")
		preco += (preco * 0.6)
		_atualizar_tooltip()

func _on_geracao_presente_timeout() -> void:
	adicionar_mais_presente.emit(quantidade_de_presente)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and \
	event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drag = true
			drag_offset = global_position - get_global_mouse_position()
			move_to_front()
		else:
			drag = false
	
	if event is InputEventMouseMotion and drag:
		global_position = get_global_mouse_position() + drag_offset

func _atualizar_tooltip() -> void:
	tooltip_text = \
	 "Presentes por intervalo: %d\nPróximo upgrade:%d" % [quantidade_de_presente, preco]
