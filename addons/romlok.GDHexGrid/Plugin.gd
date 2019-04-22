# Copyright 2018 Mel Collins. Distributed under the MIT license (see LICENSE.txt).

tool

extends EditorPlugin

func _enter_tree():
	 add_custom_type("HexCell", "Resource", preload("HexCell.gd"), preload("icon.png"))
	 add_custom_type("HexGrid", "Reference", preload("HexGrid.gd"), preload("icon.png"))

func _exit_tree():
	remove_custom_type("HexGrid")
	remove_custom_type("HexCell")
