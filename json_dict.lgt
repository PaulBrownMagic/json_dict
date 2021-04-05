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
	:- mode(json_to_dict(++term, -nested_dictionary), one).
	:- info(json_to_dict/2, [
		comment is 'Create a (nested) dictionary term from (nested) JSON terms',
		argnames is ['JSON', 'NestedDictionary']
	]).
	json_to_dict(JSON, Dict) :-
		(	var(_Dict_)	->
			instantiation_error
		;	var(JSON)	->
			instantiation_error
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
	pairs_to_dict(','(Key-Value, Pairs), Acc, Dict) :-
		json_to_dict_(Value, DictValue),
		_Dict_::insert(Acc, Key, DictValue, Updated),
		pairs_to_dict(Pairs, Updated, Dict).

	:- public(dict_to_json/2).
	:- mode(dict_to_json(++nested_dictionary, -term), one).
	:- info(dict_to_json/2, [
		comment is 'Create a JSON term from (nested) dictionaries',
		argnames is ['NestedDictionary', 'JSON']
	]).
	dict_to_json(Dict, JSON) :-
		(	var(_Dict_)	->
			instantiation_error
		;	var(Dict)	->
			instantiation_error
		;	_Dict_::check(Dict),
			dict_to_json_(Dict, JSON)
		).

	dict_to_json_(Value, Value) :-  % Both {} and [] are atomic
		atomic(Value), \+ _Dict_::empty(Value), !.
	dict_to_json_(Dict, {}) :-
		_Dict_::empty(Dict), !.
	dict_to_json_([DictHead|DictTail], [JSONHead|JSONTail]) :-
		(	_Dict_::valid(DictHead)
		->  dict_to_json_(DictHead, JSONHead)
		;	JSONHead = DictHead
		), !,
		dict_to_json_(DictTail, JSONTail).
	dict_to_json_(Dict, {JSON}) :-
		_Dict_::as_list(Dict, [Pair| Pairs]),
		pairs_to_json(Pairs, Pair, JSON).

	pairs_to_json([], Key-Value, Key-JSONValue) :-
		dict_to_json_(Value, JSONValue).
	pairs_to_json([Pair| Pairs], Key-Value, (Key-JSONValue, Rest)) :-
		dict_to_json_(Value, JSONValue),
		pairs_to_json(Pairs, Pair, Rest).

:- end_object.
