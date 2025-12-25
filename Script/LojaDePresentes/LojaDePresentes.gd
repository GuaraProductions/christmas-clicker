extends Window
class_name LojaDePresentes

signal presente_comprado(presente: Presente)

@onready var todos_presentes: HFlowContainer = %TodosPresentes
@onready var qtd_de_presentes: Label = %QtdDePresentes

@export var presentes : Array[Presente]

var numero_presentes : int = 0

func _ready() -> void:
	
	presentes.sort_custom(func(a, b): return a.preco < b.preco)
	
	for presente in presentes:
		
		if presente == null:
			continue
		
		var botao_presente = Button.new()
		
		todos_presentes.add_child(botao_presente)
		
		var imagem : Image = presente.textura.get_image()
		
		imagem.resize(64,64, Image.INTERPOLATE_LANCZOS)
	
		var nova_textura = ImageTexture.create_from_image(imagem)
		
		botao_presente.icon = nova_textura
		botao_presente.text = "%d" % presente.preco
		
		botao_presente.pressed.connect(_presente_clicado.bind(botao_presente, presente))
	
		
func _presente_clicado(botao: Button, presente: Presente) -> void:
	
	if numero_presentes >= presente.preco:
		presente_comprado.emit(presente)
		botao.disabled = true
		
func _on_about_to_popup() -> void:
	qtd_de_presentes.text = "%d" % [numero_presentes]

func _on_close_requested() -> void:
	print("fechar?")
	visible = false
