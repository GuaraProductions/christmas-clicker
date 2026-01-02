extends PanelContainer
class_name LojaDePresentes

signal presente_comprado(presente: Presente)

@onready var todos_presentes: HFlowContainer = %TodosPresentes
@onready var qtd_de_presentes: Label = %QtdDePresentes

@export var presentes : Array[Presente]
@export var botao_presente_cena : PackedScene

var numero_presentes : int = 0

func _ready() -> void:
	
	presentes.sort_custom(func(a, b): return a.preco < b.preco)
	
	for presente : Presente in presentes:
		
		if not botao_presente_cena.can_instantiate():
			return
		
		if presente == null:
			continue
		
		var botao_presente : BotaoPresente = botao_presente_cena.instantiate()
		
		todos_presentes.add_child(botao_presente)
		
		botao_presente.configurar_botao(presente)
		
		botao_presente.pressed.connect(_presente_clicado.bind(botao_presente, presente))
	
		
func _presente_clicado(botao: BotaoPresente, presente: Presente) -> void:
	
	if numero_presentes >= presente.preco:
		presente_comprado.emit(presente)
		botao.comprado = true
		
func popup() -> void:
	qtd_de_presentes.text = "%d" % [numero_presentes]
	
	for presente : BotaoPresente in todos_presentes.get_children():
		
		if presente.comprado:
			continue
		
		presente.compravel = numero_presentes > presente.preco
		presente.disabled = numero_presentes < presente.preco
