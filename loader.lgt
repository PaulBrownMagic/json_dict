:- initialization((
	logtalk_load([
		dictionaries(loader),
		json(loader),
		meta(loader)
	]),
	logtalk_load([
		json_dict,
		nested_dict_category,
		nested_dict
	])
)).

:- if(current_logtalk_flag(complements, allow)).
:- initialization((
	logtalk_load([
		complementary_nested_dict
	])
)).
:- endif.
