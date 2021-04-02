:- initialization((
	set_logtalk_flag(report, warnings),
	logtalk_load([
		dictionaries(loader),
		json(loader),
		meta(loader)
	]),
	logtalk_load(lgtunit(loader)),
	logtalk_load([
		json_dict,
		nested_dict
	], [
		source_data(on),
		debug(on)
	]),
	logtalk_load([
		tests_json_dict,
		tests_nested_dict
	], [
		hook(lgtunit)
	]),
	lgtunit::run_test_sets([
		tests_json_dict(avltree),
		tests_json_dict(bintree),
		tests_json_dict(rbtree),
		tests_nested_dict(avltree),
		tests_nested_dict(bintree),
		tests_nested_dict(rbtree)
	])
)).
