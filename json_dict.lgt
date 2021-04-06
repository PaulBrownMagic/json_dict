:- object(json_dict(_Dict_)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-05,
		comment is 'JSON objects and Nested Dictionaries translation',
		parameters is [
			'Dictionary' - 'The Dictionary implementation to use (must implement ``dictionaryp`` and extend ``term``).'
		]
	]).

	:- public(json_to_dict/2).
	:- mode(json_to_dict(++term, --nested_dictionary), one_or_error).
	:- info(json_to_dict/2, [
		comment is 'Create a (nested) dictionary term from (nested) JSON terms',
		argnames is ['JSON', 'NestedDictionary']
	]).

	json_to_dict(JSON, Dict) :-
		(	var(_Dict_)	->
			instantiation_error
		;	var(JSON)	->
			instantiation_error
		;	nonvar(Dict) ->
			uninstantiation_error(Dict)
		;	functor(JSON, '{}', Arity), Arity =< 1 ->
			json_to_dict_(JSON, Dict)
		;	type_error(json_object, JSON)
		).

	json_to_dict_(Value, Value) :-  % Both {} and [] are atomic
		atomic(Value), Value \== {}, !.
	json_to_dict_({}, Dict) :-
		_Dict_::new(Dict).
	json_to_dict_({JSON}, Dict) :-
		_Dict_::new(Empty),
		pairs_to_dict(JSON, Empty, Dict).
	json_to_dict_([H|T], Dict) :-
		meta::map(json_to_dict_, [H|T], Dict).

	pairs_to_dict(Key-Value, Acc, Dict) :-
		json_to_dict_(Value, DictValue),
		_Dict_::insert(Acc, Key, DictValue, Dict).
	pairs_to_dict((Key-Value, Pairs), Acc, Dict) :-
		json_to_dict_(Value, DictValue),
		_Dict_::insert(Acc, Key, DictValue, Updated),
		pairs_to_dict(Pairs, Updated, Dict).

	:- public(dict_to_json/2).
	:- mode(dict_to_json(++nested_dictionary, --term), one_or_error).
	:- info(dict_to_json/2, [
		comment is 'Create a JSON term from (nested) dictionaries',
		argnames is ['NestedDictionary', 'JSON']
	]).

	dict_to_json(Dict, JSON) :-
		(	var(_Dict_)	->
			instantiation_error
		;	var(Dict)	->
			instantiation_error
		;	nonvar(JSON) ->
			uninstantiation_error(JSON)
		;	_Dict_::check(Dict),
			_Dict_::as_list(Dict, Pairs),
			pairs_to_json(Pairs, JSON)
		).

	pairs_to_json([], {}).
	pairs_to_json([Pair| Pairs], {JSON}) :-
		pairs_to_json(Pairs, Pair, JSON).

	pairs_to_json([], Key-Value, Key-JSONValue) :-
		value_to_json_value(Value, JSONValue).
	pairs_to_json([Pair| Pairs], Key-Value, (Key-JSONValue, JSONPairs)) :-
		value_to_json_value(Value, JSONValue),
		pairs_to_json(Pairs, Pair, JSONPairs).

	value_to_json_value(Value, _) :-
		var(Value),
		instantiation_error.
	value_to_json_value([], []) :-
		!.
	value_to_json_value([Value| Values], [JSONValue| JSONValues]) :-
		!,
		value_to_json_value(Value, JSONValue),
		value_to_json_value(Values, JSONValues).
	value_to_json_value(Value, Value) :-
		\+ _Dict_::valid(Value),
		!.
	value_to_json_value(Value, JSONValue) :-
		_Dict_::as_list(Value, Pairs),
		pairs_to_json(Pairs, JSONValue).

:- end_object.
