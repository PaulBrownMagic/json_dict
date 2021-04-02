:- object(json_dict(_Dict_)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-01,
		comment is 'JSON objects and Dictionaries translation',
		parameters is [
			'Dictionary' - 'The Dictionary Implementation to use (must implement dictionaryp and extend compound)'
			]
	]).

	:- public(json_dict/2).
	:- mode(json_dict(+term, -term), one).
	:- mode(json_dict(-term, +term), one).
	:- info(json_dict/2, [
		comment is 'JSON term is equivalent to Dictionary term',
		argnames is ['JSON', 'Dictionary']
	]).
	% Guards
	json_dict(_, _) :-
		var(_Dict_), !,
		instantiation_error.
	json_dict(JSON, Dict) :-
		(	nonvar(Dict)
		->	dict_to_json(Dict, JSON)
		;	nonvar(JSON),
			json_to_dict(JSON, Dict)
		).

	% From a JSON Term to a Dict
	:- private(json_to_dict/2).
	:- mode(json_to_dict(++term, -term), one).
	:- info(json_to_dict/2, [
		comment is 'Create a (nested) dictionary term from (nested) JSON terms',
		argnames is ['JSON', 'Dict']
	]).
	json_to_dict(Value, Value) :-
		atomic(Value), Value \= {}, !.
	json_to_dict({}, Dict) :-
		_Dict_::new(Dict).
	json_to_dict({Key-Value}, Dict) :-  % Exceptional case for one pair
		json_to_dict({','(Key-Value)}, Dict).
	json_to_dict({JSON}, Dict) :-
		_Dict_::new(Empty),
		pairs_to_dict(JSON, Empty, Dict).
	json_to_dict([], []).
	json_to_dict([H|T], Dict) :-
		meta::map(json_to_dict, [H|T], Dict).

	pairs_to_dict(Key-Value, Acc, Dict) :-
		json_to_dict(Value, DictValue),
		_Dict_::insert(Acc, Key, DictValue, Dict).
	pairs_to_dict(','(Key-Value, Pairs), Acc, Dict) :-
		json_to_dict(Value, DictValue),
		_Dict_::insert(Acc, Key, DictValue, Updated),
		pairs_to_dict(Pairs, Updated, Dict).

	% From a Dict to a JSON term
	:- private(dict_to_json/2).
	:- mode(dict_to_json(++term, -term), one).
	:- info(dict_to_json/2, [
		comment is 'Create a JSON term from (nested) dictionaries',
		argnames is ['Dict', 'JSON']
	]).
	dict_to_json(Value, Value) :-
		atomic(Value), \+ _Dict_::empty(Value), !.
	dict_to_json(Dict, {}) :-
		_Dict_::empty(Dict), !.
	dict_to_json([], []).
	dict_to_json([DictHead|DictTail], [JSONHead|JSONTail]) :-
		(	_Dict_::valid(DictHead)
		->  dict_to_json(DictHead, JSONHead)
		;	JSONHead = DictHead
		), !,
		dict_to_json(DictTail, JSONTail).
	dict_to_json(Dict, {Key-JSONValue}) :-
		_Dict_::as_list(Dict, [Key-Value]), !,
		dict_to_json(Value, JSONValue).
	dict_to_json(Dict, {JSON}) :-
		_Dict_::as_list(Dict, Pairs),
		pairs_to_json(Pairs, JSON).

	pairs_to_json([Key-Value|[]], Key-JSONValue) :-
		dict_to_json(Value, JSONValue), !.
	pairs_to_json([Key-Value|Pairs], (Key-JSONValue, Rest)) :-
		dict_to_json(Value, JSONValue),
		pairs_to_json(Pairs, Rest).

:- end_object.
