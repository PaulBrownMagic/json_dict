:- object(json_dict(_Dict_)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-01,
		comment is 'JSON objects and Dictionaries translation',
		parameters is [
			'Dict' - 'The Dictionary Implementation to use (must implement dictionaryp)'
			]
	]).

	:- public(json_dict/2).
	:- mode(json_dict(+term, ?term), one).
	:- mode(json_dict(-term, +term), one).
	:- info(json_dict/2, [
		comment is 'JSON term is equivalent to Dictionary term',
		argnames is ['JSON', 'Dictionary']
	]).
	json_dict(_, _) :-
		var(_Dict_), !,
		fail.  % Should probably throw instead of failing
	json_dict(JSON, Dict) :-
		nonvar(JSON),
		json_dict_forwards(JSON, Dict).
	json_dict(JSON, Dict) :-
		nonvar(Dict),
		json_dict_backwards(JSON, Dict).

	json_dict_forwards({}, Dict) :-
		_Dict_::new(Dict).
	json_dict_forwards({Key-Value}, Dict) :-  % Exceptional case for one pair
		json_dict_forwards({','(Key-Value)}, Dict).
	json_dict_forwards({JSON}, Dict) :-
		JSON =.. [','|Pairs],
		_Dict_::new(Empty),
		pairs_dict(Pairs, Empty, Dict).
	json_dict_forwards([], []).
	json_dict_forwards([H|T], Dict) :-
		(	functor(H, '{}', 1)
		->	meta::map(json_dict_forwards, [H|T], Dict)
		;	Dict = [H|T]
		).

	json_dict_backwards({}, Dict) :-
		_Dict_::empty(Dict).
	json_dict_backwards({Key-Value}, Dict) :-
		_Dict_::as_list(Dict, [Key-Value]).
	json_dict_backwards({JSON}, Dict) :-
		_Dict_::as_list(Dict, Pairs),
		JSON =.. [','|Pairs].

	pairs_dict([], Acc, Acc).
	pairs_dict([Key-Value|Pairs], Acc, Dict) :-
		value_dict(Value, DictValue),
		_Dict_::insert(Acc, Key, DictValue, Updated),
		pairs_dict(Pairs, Updated, Dict).

	value_dict(Value, Value) :-
		atomic(Value), Value \= {}, !.
	value_dict(Value, Dict) :-
		json_dict_forwards(Value, Dict).

:- end_object.
