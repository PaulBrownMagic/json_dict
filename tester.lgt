:- initialization((
	set_logtalk_flag(report, warnings),
	logtalk_load([
		dictionaries(loader),
		json(loader),
		meta(loader)
	]),
	logtalk_load(lgtunit(loader)),
	logtalk_load([
		json_dict
	], [
		source_data(on),
		debug(on)
	]),
	logtalk_load(tests, [hook(lgtunit)]),
	lgtunit::run_test_sets([
		tests(avltree),
		tests(bintree),
		tests(rbtree)
	])
)).
