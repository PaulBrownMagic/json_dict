:- object(tests_nested_dict(_Dict_),
	extends(lgtunit)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-02,
		comment is 'Unit tests for nested dict predicates'
	]).

	cover(nested_dict(_)).

	/*
		test dict
		{	recipe: "Sponge Cake",
			ingredients: [
					{ name: butter, measure: {value: 125, unit: g}},
					{ name: sugar, measure: {value: 125, unit: g}},
					{ name: eggs, measure: {value: 2, unit: count}},
					{ name: flour, measure: {value: 125, unit: g}}],
			serves: 8,
			time: {value: 30, unit: minutes}
		}
	*/
	test_dict(Dict) :-
		_Dict_::as_dictionary([value-125, unit-g], Measure125g),
		_Dict_::as_dictionary([value-2, unit-count], Measure2),
		_Dict_::as_dictionary([value-30, unit-minutes], Measure30m),
		_Dict_::as_dictionary([name-butter, measure-Measure125g], Butter),
		_Dict_::as_dictionary([name-sugar, measure-Measure125g], Sugar),
		_Dict_::as_dictionary([name-eggs, measure-Measure2], Eggs),
		_Dict_::as_dictionary([name-flour, measure-Measure125g], Flour),
		_Dict_::as_dictionary([
			recipe-"Sponge Cake",
			ingredients-[Butter, Sugar, Eggs, Flour],
			serves-8,
			time-Measure30m
			], Dict).

		test(lookup_in_empty_reflexive, deterministic(Ans == Dict)) :-
			test_dict(Dict),
			_Dict_::lookup_in([], Ans, Dict).
		test(lookup_depth_one, deterministic([Name, Serves] == ["Sponge Cake", 8])) :-
			test_dict(Dict),
			_Dict_::lookup_in([recipe], Name, Dict),
			_Dict_::lookup_in([serves], Serves, Dict).
		test(lookup_depth_two, deterministic([Value, Unit] == [30, minutes])) :-
			test_dict(Dict),
			_Dict_::lookup_in([time, value], Value, Dict),
			_Dict_::lookup_in([time, unit], Unit, Dict).
		test(lookup_is_list, true(is_list(Ans))) :-
			test_dict(Dict),
			_Dict_::lookup_in([ingredients], Ans, Dict).
		test(lookup_across_list, true) :-
			test_dict(Dict),
			_Dict_::lookup_in([ingredients], Ingredients, Dict),
			list::member(Ingredient, Ingredients),
			_Dict_::lookup_in([name], sugar, Ingredient).
		test(lookup_through_list, true) :-
			test_dict(Dict),
			_Dict_::lookup_in([ingredients], Ingredients, Dict),
			list::member(Ingredient, Ingredients),
			_Dict_::lookup_in([measure, unit], g, Ingredient).
		test(lookup_through_nondict, fail) :-
			test_dict(Dict),
			_Dict_::lookup_in([recipe, name], _, Dict).

		test(update_in_empty_keys_is_value, deterministic) :-
			test_dict(Dict),
			_Dict_::update_in(Dict, [], foo, foo).
		test(update_depth_one, deterministic([Name, Serves] == ["Cake", 6])) :-
			test_dict(Dict0),
			_Dict_::update_in(Dict0, [recipe], "Cake", Dict1),
			_Dict_::update_in(Dict1, [serves], 6, Dict2),
			_Dict_::lookup_in([recipe], Name, Dict2),
			_Dict_::lookup_in([serves], Serves, Dict2).
		test(update_depth_two, deterministic([Value, Unit] == [1, hour])) :-
			test_dict(Dict0),
			_Dict_::update_in(Dict0, [time, value], 1, Dict1),
			_Dict_::update_in(Dict1, [time, unit], hour, Dict2),
			_Dict_::lookup_in([time, value], Value, Dict2),
			_Dict_::lookup_in([time, unit], Unit, Dict2).
		test(update_a_list, true(Ans = [])) :-
			test_dict(Dict0),
			_Dict_::update_in(Dict0, [ingredients], [], Dict),
			_Dict_::lookup_in([ingredients], Ans, Dict).
		test(update_through_nondict, fail) :-
			test_dict(Dict),
			_Dict_::update_in(Dict, [recipe, name], any, _Dict).

		test(update_5_nested_matching, deterministic(Time == 1)) :-
			test_dict(Dict),
			_Dict_::update_in(Dict, [time, value], 30, 1, Dict1),
			_Dict_::lookup_in([time, value], Time, Dict1).
		test(update_5_nested_not_matching, fail) :-
			test_dict(Dict),
			_Dict_::update_in(Dict, [time, value], 1, 1, _Dict1).

		test(obj_lookup_in_empty_reflexive, deterministic(Ans == Dict)) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([], Ans, Dict).
		test(obj_lookup_depth_one, deterministic([Name, Serves] == ["Sponge Cake", 8])) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([recipe], Name, Dict),
			nested_dict(_Dict_)::lookup_in([serves], Serves, Dict).
		test(obj_lookup_depth_two, deterministic([Value, Unit] == [30, minutes])) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([time, value], Value, Dict),
			nested_dict(_Dict_)::lookup_in([time, unit], Unit, Dict).
		test(obj_lookup_is_list, true(is_list(Ans))) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([ingredients], Ans, Dict).
		test(obj_lookup_across_list, true) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([ingredients], Ingredients, Dict),
			list::member(Ingredient, Ingredients),
			nested_dict(_Dict_)::lookup_in([name], sugar, Ingredient).
		test(obj_lookup_through_list, true) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([ingredients], Ingredients, Dict),
			list::member(Ingredient, Ingredients),
			nested_dict(_Dict_)::lookup_in([measure, unit], g, Ingredient).
		test(obj_lookup_through_nondict, fail) :-
			test_dict(Dict),
			nested_dict(_Dict_)::lookup_in([recipe, name], _, Dict).

		test(obj_update_in_empty_keys_is_value, deterministic) :-
			test_dict(Dict),
			nested_dict(_Dict_)::update_in(Dict, [], foo, foo).
		test(obj_update_depth_one, deterministic([Name, Serves] == ["Cake", 6])) :-
			test_dict(Dict0),
			nested_dict(_Dict_)::update_in(Dict0, [recipe], "Cake", Dict1),
			nested_dict(_Dict_)::update_in(Dict1, [serves], 6, Dict2),
			nested_dict(_Dict_)::lookup_in([recipe], Name, Dict2),
			nested_dict(_Dict_)::lookup_in([serves], Serves, Dict2).
		test(obj_update_depth_two, deterministic([Value, Unit] == [1, hour])) :-
			test_dict(Dict0),
			nested_dict(_Dict_)::update_in(Dict0, [time, value], 1, Dict1),
			nested_dict(_Dict_)::update_in(Dict1, [time, unit], hour, Dict2),
			nested_dict(_Dict_)::lookup_in([time, value], Value, Dict2),
			nested_dict(_Dict_)::lookup_in([time, unit], Unit, Dict2).
		test(obj_update_a_list, true(Ans = [])) :-
			test_dict(Dict0),
			nested_dict(_Dict_)::update_in(Dict0, [ingredients], [], Dict),
			nested_dict(_Dict_)::lookup_in([ingredients], Ans, Dict).
		test(obj_update_through_nondict, fail) :-
			test_dict(Dict),
			nested_dict(_Dict_)::update_in(Dict, [recipe, name], any, _Dict).

		test(obj_update_5_nested_matching, deterministic(Time == 1)) :-
			test_dict(Dict),
			nested_dict(_Dict_)::update_in(Dict, [time, value], 30, 1, Dict1),
			nested_dict(_Dict_)::lookup_in([time, value], Time, Dict1).
		test(obj_update_5_nested_not_matching, fail) :-
			test_dict(Dict),
			nested_dict(_Dict_)::update_in(Dict, [time, value], 1, 1, _Dict1).

:- end_object.
