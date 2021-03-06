
:- object(tests_json_dict(_Dict_),
	extends(lgtunit)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown and Paulo Moura',
		date is 2021-04-06,
		comment is 'Unit tests for json_dict'
	]).

	cover(json_dict(_)).

	test(json_to_dict_no_dict_error, error(instantiation_error)) :-
		json_dict(_Var)::json_to_dict({}, _Dict).
	test(dict_to_json_no_dict_error, error(instantiation_error)) :-
		_Dict_::new(Dict),
		json_dict(_Var)::dict_to_json(Dict, _JSON).

	test(json_to_dict_var_error, error(instantiation_error)) :-
		_Dict_::new(Dict),
		json_dict(_Dict_)::json_to_dict(_JSON, Dict).
	test(dict_to_json_var_error, error(instantiation_error)) :-
		json_dict(_Dict_)::dict_to_json(_Dict, {}).

	test(json_to_dict_nonvar_error, error(uninstantiation_error(1))) :-
		json_dict(_Dict_)::json_to_dict({}, 1).
	test(dict_to_json_nonvar_error, error(uninstantiation_error({}))) :-
		_Dict_::new(Dict),
		json_dict(_Dict_)::dict_to_json(Dict, {}).

	test(json_dict_empty_forwards, true) :-
		json_dict(_Dict_)::json_to_dict({}, Dict),
		_Dict_::empty(Dict).
	test(json_dict_empty_list_forwards, true(Dict == [])) :-
		meta::map(json_dict(_Dict_)::json_to_dict, [], Dict).

	test(json_dict_empty_backwards, deterministic(JSON == {} )) :-
		_Dict_::new(Dict),
		json_dict(_Dict_)::dict_to_json(Dict, JSON).
	test(json_dict_empty_list_backwards, true(JSON == [])) :-
		meta::map(json_dict(_Dict_)::dict_to_json, [], JSON).

	test(forwards_only_one_pair, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-b}, D),
		_Dict_::as_list(D, [a-b]).
	test(forwards_two_pair, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-b, c-d}, D),
		_Dict_::as_list(D, [a-b, c-d]).
	test(forwards_three_pair, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-b, c-d, e-f}, D),
		_Dict_::as_list(D, [a-b, c-d, e-f]).

	test(backwards_only_one_pair, deterministic(JSON == {a-b})) :-
		_Dict_::as_dictionary([a-b], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_two_pair, deterministic(JSON == {a-b, c-d})) :-
		_Dict_::as_dictionary([a-b, c-d], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_three_pairs, deterministic(JSON == {a-b, c-d, e-f})) :-
		_Dict_::as_dictionary([a-b, c-d, e-f], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).


	test(forwards_contains_empty_list, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-[]}, D),
		_Dict_::as_list(D, [a-[]]).
	test(forwards_contains_list, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-[b, c]}, D),
		_Dict_::as_list(D, [a-[b, c]]).
	test(forwards_contains_empty_object, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-{}}, D),
		_Dict_::as_list(D, [a-Nested]),
		_Dict_::empty(Nested).
	test(forwards_contains_object, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-{b-c}}, D),
		_Dict_::as_list(D, [a-Nested]),
		_Dict_::as_list(Nested, [b-c]).
	test(forwards_contains_list_of_objects, deterministic) :-
		json_dict(_Dict_)::json_to_dict({a-[{b-c}, {b-d}]}, D),
		_Dict_::as_list(D, [a-[Nested1, Nested2]]),
		_Dict_::as_list(Nested1, [b-c]),
		_Dict_::as_list(Nested2, [b-d]).
	test(forwards_deeply_nested, deterministic) :-
		_Dict_::new(Empty),
		_Dict_::as_dictionary([d-[1, 2, Empty]], N1),
		_Dict_::as_dictionary([g-h], N3),
		_Dict_::as_dictionary([f-N3], N2),
		_Dict_::as_dictionary([a-b], D1),
		_Dict_::as_dictionary([c-[N1, N2]], D2),
		meta::map(json_dict(_Dict_)::json_to_dict, [{a-b}, {c-[{d-[1, 2, {}]}, {f-{g-h}}]}], Dict),
		Dict = [D1, D2].

	test(backwards_dict_contains_var_value, error(instantiation_error)) :-
		_Dict_::as_dictionary([a-b, c-d, var-_F], Dict),
		json_dict(_Dict_)::dict_to_json(Dict, _Json).
	test(backwards_contains_empty_list, deterministic(JSON == {a-[]})) :-
		_Dict_::as_dictionary([a-[]], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_contains_list, deterministic(JSON == {a-[b, c]})) :-
		_Dict_::as_dictionary([a-[b, c]], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_contains_empty_object, deterministic(JSON == {a-{}})) :-
		_Dict_::new(Nested),
		_Dict_::as_dictionary([a-Nested], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_contains_object, deterministic(JSON == {a-{b-c}})) :-
		_Dict_::as_dictionary([b-c], Nested),
		_Dict_::as_dictionary([a-Nested], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_contains_list_of_objects, deterministic(JSON == {a-[{b-c}, {b-d}]})) :-
		_Dict_::as_dictionary([b-c], Nested1),
		_Dict_::as_dictionary([b-d], Nested2),
		_Dict_::as_dictionary([a-[Nested1, Nested2]], D),
		json_dict(_Dict_)::dict_to_json(D, JSON).
	test(backwards_deeply_nested, deterministic(JSON == [{a-b}, {c-[{d-[1, 2, {}]}, {f-{g-h}}]}])) :-
		_Dict_::new(Empty),
		_Dict_::as_dictionary([d-[1, 2, Empty]], N1),
		_Dict_::as_dictionary([g-h], N3),
		_Dict_::as_dictionary([f-N3], N2),
		_Dict_::as_dictionary([a-b], D1),
		_Dict_::as_dictionary([c-[N1, N2]], D2),
		meta::map(json_dict(_Dict_)::dict_to_json, [D1, D2], JSON).

:- end_object.
