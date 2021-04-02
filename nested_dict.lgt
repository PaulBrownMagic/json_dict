:- category(nested_dict,
    complements([avltree, bintree, rbtree])).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-02,
		comment is 'Predicates for using with nested dictionaries'
	]).

	:- public(lookup_in/3).
	:- mode(lookup_in(++list, ?any, ++term), zero_or_more).
	:- info(lookup_in/3, [
		comment is 'Lookup a chain of keys in a nested dict',
		argnames is ['Keys', 'Value', 'NestedDict']
	]).
	lookup_in([], Dict, Dict).
	lookup_in([Key|Keys], Ans, Dict) :-
		::lookup(Key, Value, Dict),
		lookup_in(Keys, Ans, Value).

	:- public(update_in/4).
	:- mode(update_in(++term, ++list, ++any, --term), zero_or_one).
	:- info(update_in/4, [
		comment is 'Update the Value found by traversing through the nested keys',
		argnames is ['OldDictionaly', 'List of Keys', 'Value', 'NewDictionary']
	]).
	update_in(_, [], Value, Value) :- !.
	update_in(OldDict, [Key|Keys], Value, NewDict) :-
		::lookup(Key, SubDict, OldDict),
		update_in(SubDict, Keys, Value, NewSubDict),
		::update(OldDict, Key, NewSubDict, NewDict).

	:- public(update_in/5).
	:- mode(update_in(++term, ++list, ++any, ++any, --term), zero_or_one).
	:- info(update_in/5, [
		comment is 'Update the Value found by traversing through the nested keys, only succeeds if the value found after traversal matches the OldValue',
		argnames is ['OldDictionaly', 'List of Keys', 'OldValue', 'NewValue', 'NewDictionary']
	]).
	update_in(OldDict, [LastKey|[]], OldValue, NewValue, NewDict) :-
		::update(OldDict, LastKey, OldValue, NewValue, NewDict), !.
	update_in(OldDict, [Key|Keys], OldValue, NewValue, NewDict) :-
		::lookup(Key, SubDict, OldDict),
		update_in(SubDict, Keys, OldValue, NewValue, NewSubDict),
		::update(OldDict, Key, NewSubDict, NewDict).

:- end_category.
