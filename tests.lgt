:- object(tests(_Dict_),
	extends(lgtunit)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-01,
		comment is 'Unit tests for json_dict'
	]).

	cover(json_dict(_)).

	test(json_dict_no_dict_fail, fail) :-
		json_dict(_Var)::json_dict({}, _Dict).

	test(json_dict_vars_fail, fail) :-
		json_dict(_Dict_)::json_dict(_JSON, _Dict).

	test(json_dict_empty_forwards, true) :-
		json_dict(_Dict_)::json_dict({}, Dict),
		_Dict_::empty(Dict).

	test(json_dict_empty_backwards, true(JSON == {} )) :-
		_Dict_::as_dictionary([], Empty),
		json_dict(_Dict_)::json_dict(JSON, Empty).

	test(forwards_only_one_pair, true) :-
		json_dict(_Dict_)::json_dict({a-b}, D),
		_Dict_::as_list(D, [a-b]).
	test(forwards_two_pair, true) :-
		json_dict(_Dict_)::json_dict({a-b, c-d}, D),
		_Dict_::as_list(D, [a-b, c-d]).

	test(backwards_only_one_pair, true(JSON == {a-b})) :-
		_Dict_::as_dictionary([a-b], D),
		json_dict(_Dict_)::json_dict(JSON, D).
	test(backwards_two_pair, true(JSON == {a-b, c-d})) :-
		_Dict_::as_dictionary([a-b, c-d], D),
		json_dict(_Dict_)::json_dict(JSON, D).


	test(forwards_contains_empty_list, true) :-
		json_dict(_Dict_)::json_dict({a-[]}, D),
		_Dict_::as_list(D, [a-[]]).
	test(forwards_contains_list, true) :-
		json_dict(_Dict_)::json_dict({a-[b, c]}, D),
		_Dict_::as_list(D, [a-[b, c]]).
	test(forwards_contains_empty_object, true) :-
		json_dict(_Dict_)::json_dict({a-{}}, D),
		_Dict_::as_list(D, [a-Nested]),
		_Dict_::empty(Nested).
	test(forwards_contains_object, true) :-
		json_dict(_Dict_)::json_dict({a-{b-c}}, D),
		_Dict_::as_list(D, [a-Nested]),
		_Dict_::as_list(Nested, [b-c]).
	test(forwards_contains_list_of_objects, true) :-
		json_dict(_Dict_)::json_dict({a-[{b-c}, {b-d}]}, D),
		_Dict_::as_list(D, [a-[Nested1, Nested2]]),
		_Dict_::as_list(Nested1, [b-c]),
		_Dict_::as_list(Nested2, [b-d]).
	test(forwards_deeply_nested, true) :-
		json_dict(_Dict_)::json_dict([{a-b}, {c-[{d-[1, 2]}, {f-{g-h}}]}], [D1, D2]),
		_Dict_::as_list(D1, [a-b]),
		_Dict_::as_list(D2, [c-[N1, N2]]),
		_Dict_::as_list(N1, [d-[1, 2]]),
		_Dict_::as_list(N2, [f-N3]),
		_Dict_::as_list(N3, [g-h]).



:- end_object.
