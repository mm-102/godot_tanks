extends Reference
class_name Functions


static func get_version():
	if OS.has_feature("standalone") :
		return ProjectSettings.get_setting("application/config/version")
	else:
		return null#"1.1.1"#ProjectSettings.get_setting("application/config/version")
