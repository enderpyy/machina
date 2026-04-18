@tool
extends EditorPlugin

var context_menu

func _enter_tree():
	context_menu = preload("res://scripts/tools/get_set_menu.gd").new()
	add_context_menu_plugin(EditorContextMenuPlugin.CONTEXT_SLOT_SCRIPT_EDITOR_CODE, context_menu)

func _exit_tree():
	remove_context_menu_plugin(context_menu)
