:- category(nested_dict_category).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-02,
		comment is 'Predicates for using with nested dictionaries'
	]).

	:- public(lookup_in/3).
	:- mode(lookup_in(++list, ?term, ++term), zero_or_more).
	:- info(lookup_in/3, [
		comment is 'Lookup a chain of keys in a nested dictionary',
		argnames is ['Keys', 'Value', 'NestedDict']
	]).
	lookup_in([], Dict, Dict).
	lookup_in([Key|Keys], Ans, Dict) :-
		::lookup(Key, Value, Dict),
		lookup_in(Keys, Ans, Value).

	:- public(update_in/4).
	:- mode(update_in(++term, ++list, ++term, --term), zero_or_one).
	:- info(update_in/4, [
		comment is 'Update the value found by traversing through the nested keys',
		argnames is ['OldDictionary', 'Keys', 'Value', 'NewDictionary']
	]).

	update_in(SubDict, Keys, Value, NewSubDict) :-
		update_in(SubDict, Keys, _, Value, NewSubDict).

	:- public(update_in/5).
	:- mode(update_in(++term, ++list, ++term, ++term, --term), zero_or_one).
	:- info(update_in/5, [
		comment is 'Update the value found by traversing through the nested keys, only succeeds if the value found after traversal matches the old value',
		argnames is ['OldDictionary', 'Keys', 'OldValue', 'NewValue', 'NewDictionary']
	]).

	update_in(OldDict, [], OldValue, NewValue, NewValue) :-
		!,
		OldValue = OldDict.
	update_in(OldDict, [Key|Keys], OldValue, NewValue, NewDict) :-
		update_in(Keys, OldDict, Key, OldValue, NewValue, NewDict).

	update_in([], OldDict, LastKey, OldValue, NewValue, NewDict) :-
		::update(OldDict, LastKey, OldValue, NewValue, NewDict).
	update_in([NextKey| Keys], OldDict, Key, OldValue, NewValue, NewDict) :-
		::lookup(Key, SubDict, OldDict),
		::update(OldDict, Key, NewSubDict, NewDict),
		update_in(Keys, SubDict, NextKey, OldValue, NewValue, NewSubDict).

:- end_category.
