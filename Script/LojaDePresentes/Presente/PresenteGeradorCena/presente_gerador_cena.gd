extends HBoxContainer
class_name PresenteGeradorCena

signal mais_um_gerador(preco: int)
signal adicionar_mais_presente(quantidade: int)

@onready var sprite: TextureRect = $Sprite
@onready var geracao_presente: Timer = $GeracaoPresente
@onready var num_geradores: Label = %NumGeradores

var preco: int = 0
var quantidade_de_presente : int = 0

var drag : bool = false
var drag_offset : Vector2 = Vector2.ZERO

func configurar_presente(presente: Presente, posicao : Vector2) -> void:
	
	var imagem : Image = presente.textura.get_image()
	
	imagem.resize(64,64, Image.INTERPOLATE_LANCZOS)

	var nova_textura = ImageTexture.create_from_image(imagem)
	
	preco = presente.preco
	quantidade_de_presente = 1
	num_geradores.text = "%d" % quantidade_de_presente
	sprite.texture = nova_textura
	global_position = posicao
	
	geracao_presente.start()

func _on_mais_pressed() -> void:
	
	var cena_atual = get_tree().current_scene
	
	var numero_presentes = cena_atual.numero_presentes
	
	if numero_presentes >= preco:
		quantidade_de_presente += 1
		num_geradores.text = "%d" % quantidade_de_presente
		mais_um_gerador.emit(preco)
		preco += preco

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
