class_name LevelZero extends Level

signal spell_selected(selectedSpell:Enums.SelectableSpells)

@export var OVERLAY_TEXT_LABEL:RichTextLabel
@export var SPELL_SELECTORS:Array[Area3D]
@export var OVERLAY_POPUP_CHARS:int = 5
@export var OVERLAY_POPUP_SPEED:float = 0.1

const overlayTextBBCode:String = "[outline_color=black][outline_size=15][color=red][font_size=72]"

func _ready() -> void:
	super._ready()
	
	OVERLAY_TEXT_LABEL.text = ""
	await get_tree().create_timer(1.0).timeout
	_display_overlay("CHOOSE YOUR SPELL")

func _display_overlay(message:String):
	OVERLAY_TEXT_LABEL.visible_characters = 0
	OVERLAY_TEXT_LABEL.text = overlayTextBBCode + message
	while OVERLAY_TEXT_LABEL.visible_characters < OVERLAY_TEXT_LABEL.text.length():
		OVERLAY_TEXT_LABEL.visible_characters += OVERLAY_POPUP_CHARS
		await get_tree().create_timer(OVERLAY_POPUP_SPEED).timeout
	
	await get_tree().create_timer(1.5).timeout
	OVERLAY_TEXT_LABEL.text = ""


func _on_firebolt_selector_body_entered(_body: Node3D) -> void:
	print("Firebolt selected!")
	for selector in SPELL_SELECTORS:
		selector.queue_free()
	
	spell_selected.emit(Enums.SelectableSpells.FIRE_BOLT)
	_display_overlay("BURN THE DOOR")


func _on_acid_spash_selector_body_entered(_body: Node3D) -> void:
	print("Acid Splash Selected!")
	for selector in SPELL_SELECTORS:
		selector.queue_free()
	
	spell_selected.emit(Enums.SelectableSpells.ACID_SPLASH)
	_display_overlay("MELT THE DOOR")

func _on_lightning_bolt_selector_body_entered(_body: Node3D) -> void:
	print("Lightning Bolt Selected!")
	for selector in SPELL_SELECTORS:
		selector.queue_free()
	
	spell_selected.emit(Enums.SelectableSpells.LIGHTNING_BOLT)
	_display_overlay("BLAST THE DOOR")
