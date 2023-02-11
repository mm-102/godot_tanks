extends Node
tool

signal apply_changes

var SETTINGS : Dictionary = DefaultSettings.SETTIMGS.duplicate(true)

func apply_changes():
	emit_signal("apply_changes")

func _get_property_list() -> Array:
	var ret = []
	for key in SETTINGS:
		var _prop = {"name" : key}
		var _type = typeof(SETTINGS[key])
		_prop["type"] = _type
		if _type == TYPE_VECTOR2:
			ret.append(_prop)
			continue
		if "TYPE" in key and not "TYPES" in key:
			_prop["hint"] = PROPERTY_HINT_ENUM
			_prop["hint_string"] = PoolStringArray(Ammunition.TYPES.keys()).join(',')
			ret.append(_prop)
			continue
		if "SPEED" in key:
			_prop["type"] = TYPE_REAL
			_prop["hint"] = PROPERTY_HINT_RANGE
			_prop["hint_string"] = "0,1000,0.1"
			ret.append(_prop)
			continue
		
		ret.append(_prop)
		
	return ret

func _set(property, value) -> bool:
	SETTINGS[property] = value
	return true

func _get(property):
	if property in SETTINGS:
		return SETTINGS[property]

func property_can_revert(property):
	if property in SETTINGS:
		return SETTINGS[property] != DefaultSettings.SETTIMGS[property]

func property_get_revert(property):
	return DefaultSettings.SETTIMGS[property]
