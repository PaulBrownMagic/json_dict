:- initialization((
	set_logtalk_flag(complements, allow),
	logtalk_load([
		dictionaries(loader),
		json(loader),
		meta(loader)
	]),
	logtalk_load([
		json_dict,
		nested_dict
	])
)).
