extends Control

@onready var qtd_presentes: Label = %QtdPresentes
@onready var loja_menu : Control = %Loja
@onready var tela_lojinha: LojaDePresentes = %TelaLojinha
@onready var presentes: Control = %Presentes
@onready var spawn_inicial_dos_presentes: Marker2D = %SpawnInicialDosPresentes
@onready var efeitos_sonoros: SFXPlayer = %SFXPlayer
@onready var acessar_loja: Button = %AcessarLoja
@onready var menu_de_opcoes: Control = %MenuDeOpcoes
@onready var main_menu: CenterContainer = %MenuPrincipal
@onready var jogo: MarginContainer = $Jogo
@onready var creditos: MarginContainer = %Creditos

@export var qtd_de_presente_por_click : int = 1

var numero_presentes : int = 0 : set = _set_numero_presentes
var comecou_jogo : bool = false

func _ready() -> void:
	main_menu.visible = true
	jogo.visible = false
	menu_de_opcoes.visible = false
	loja_menu.visible = false
	tela_lojinha.presente_comprado.connect(_spawnar_presente)
	comecou_jogo = false
	creditos.visible = false
	GuiTransitions.go_to("MenuPrincipal")

func _spawnar_presente(presente: Presente) -> void:
	acessar_loja.disabled = false
	numero_presentes -= presente.preco
	var cena_do_presente = presente.cena.instantiate()
	
	presentes.add_child(cena_do_presente)
	
	var spawn_posicao := spawn_inicial_dos_presentes.global_position
	
	cena_do_presente.configurar_presente(presente, spawn_posicao)
	GuiTransitions.go_to("Jogo")
	
	if cena_do_presente is PresenteGeradorCena:
		
		cena_do_presente.adicionar_mais_presente.connect(adicionar_mais_presentes)
		cena_do_presente.mais_um_gerador.connect(mais_um_gerador)

func adicionar_mais_presentes(quantidade: int) -> void:
	_criar_efeito_de_bounce(qtd_presentes)
	numero_presentes = max(numero_presentes + quantidade, 0)
	
func mais_um_gerador(preco: int) -> void:
	numero_presentes = max(numero_presentes - preco, 0)

func _set_numero_presentes(valor: int) -> void:
	numero_presentes = valor
	qtd_presentes.text = "%d" % [valor]
	tela_lojinha.numero_presentes = valor

func _on_presente_pressed(botao_presente: BaseButton) -> void:
	numero_presentes += 1
	spawnar_texto_flutuante(
		get_global_mouse_position(), 
		"+%d" % qtd_de_presente_por_click)
	efeitos_sonoros.play_dink()
	_criar_efeito_de_bounce(botao_presente)

func _criar_efeito_de_bounce(node: Control) -> void:
	var tween = create_tween()
	
	tween.tween_property(node, "scale", Vector2(0.9, 0.9), 0.05)
	
	tween.tween_property(node, "scale", Vector2(1.0, 1.0), 0.3)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)


func _on_acessar_loja_pressed() -> void:
	acessar_loja.disabled = true
	GuiTransitions.go_to("Loja")
	tela_lojinha.popup()
	efeitos_sonoros.play_bell()

func spawnar_texto_flutuante(pos, text_value):
	var label = Label.new()
	label.text = text_value
	label.position = pos
	label.modulate = Color(1, 1, 0) # Amarelo
	add_child(label)
	
	# Cria uma animação simples via código (Tween)
	var tween = create_tween()
	tween.tween_property(label, "position", pos + Vector2(0, -50), 0.5) # Sobe
	tween.parallel().tween_property(label, "modulate:a", 0, 0.5) # Desaparece
	tween.tween_callback(label.queue_free) # Destroi o objeto

func _on_opcoes_pressed() -> void:
	GuiTransitions.go_to("MenuDeOpcoes")

func _on_sair_pressed() -> void:
	
	if comecou_jogo:
		acessar_loja.disabled = false
		GuiTransitions.go_to("Jogo")
	else:
		GuiTransitions.go_to("MenuPrincipal")

func _on_jogar_pressed() -> void:
	comecou_jogo = true
	GuiTransitions.go_to("Jogo")

func _on_opções_pressed() -> void:
	GuiTransitions.go_to("MenuDeOpcoes")

func _on_sair_do_jogo_pressed() -> void:
	get_tree().quit()

func _on_voltar_ao_menu_pressed() -> void:
	GuiTransitions.go_to("MenuPrincipal")

func _on_créditos_pressed() -> void:
	GuiTransitions.go_to("Creditos")
