:- initialization((
	logtalk_load([
		dictionaries(loader),
		json(loader),
		meta(loader)
	]),
	logtalk_load([
		json_dict
	])
)).
