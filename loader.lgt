
:- initialization((
	logtalk_load([
		dictionaries(loader),
		json(loader)
	]),
	logtalk_load([
		json_dict,
		nested_dict
	])
)).
