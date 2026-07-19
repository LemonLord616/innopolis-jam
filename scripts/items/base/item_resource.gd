@abstract
extends Resource
class_name ItemResource

@export var name: StringName
@export var item: ItemManager.Item
@export var image_texture: Texture2D
@export var anim_library_name: StringName
@export var idle_anim_name: StringName

var primary_active := false
var secondary_active := false

@abstract
func primary_pressed(player: Player) -> void

@abstract
func primary_released(player: Player) -> void

@abstract
func secondary_pressed(player: Player) -> void

@abstract
func secondary_released(player: Player) -> void

@abstract
func effect_first(player: Player) -> void

@abstract
func effect_second(player: Player) -> void
