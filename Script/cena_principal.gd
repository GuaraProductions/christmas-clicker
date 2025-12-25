extends Control

@onready var qtd_presentes: Label = %QtdPresentes
@onready var tela_lojinha: LojaDePresentes = %TelaLojinha
@onready var presentes: Control = %Presentes
@onready var spawn_inicial_dos_presentes: Marker2D = %SpawnInicialDosPresentes

var numero_presentes : int = 0 : set = _set_numero_presentes

func _ready() -> void:
	tela_lojinha.visible = false
	tela_lojinha.presente_comprado.connect(_spawnar_presente)

func _spawnar_presente(presente: Presente) -> void:
	numero_presentes -= presente.preco
	var cena_do_presente = presente.cena.instantiate()
	
	presentes.add_child(cena_do_presente)
	
	var spawn_posicao := spawn_inicial_dos_presentes.global_position
	
	cena_do_presente.configurar_presente(presente, spawn_posicao)
	tela_lojinha.visible = false
	
	if cena_do_presente is PresenteGeradorCena:
		
		cena_do_presente.adicionar_mais_presente.connect(adicionar_mais_presentes)
		cena_do_presente.mais_um_gerador.connect(mais_um_gerador)

func adicionar_mais_presentes(quantidade: int) -> void:
	numero_presentes += quantidade
	
func mais_um_gerador(preco: int) -> void:
	numero_presentes -= preco

func _set_numero_presentes(valor: int) -> void:
	numero_presentes = valor
	qtd_presentes.text = "%d" % [valor]
	tela_lojinha.numero_presentes = valor

func _on_presente_pressed(_source: BaseButton) -> void:
	numero_presentes += 1

func _on_acessar_loja_pressed() -> void:
	tela_lojinha.popup_centered()
