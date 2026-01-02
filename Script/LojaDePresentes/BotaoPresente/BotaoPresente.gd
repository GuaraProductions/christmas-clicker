extends Button
class_name BotaoPresente

var comprado : bool = false : set = _set_comprado
var compravel : bool = false : set = _set_compravel

var preco : int = 0

func configurar_botao(presente: Presente) -> void:
	preco = presente.preco
	icon = presente.textura
	text = "%d" % presente.preco
	
	tooltip_text = "%s\nPreço: %d" % [presente.nome, presente.preco]

func _set_comprado(p_comprado: bool) -> void:
	comprado = p_comprado
	disabled = true
	modulate = Color.GOLD
	tooltip_text = "Comprado!"

func _set_compravel(p_compravel: bool) -> void:
	compravel = p_compravel
