:- object(nested_dict(_Dict_),
	imports(nested_dict_category)).

	:- info([
		version is 1:0:0,
		author is 'Paul Brown',
		date is 2021-04-02,
		comment is 'Object interface to nested dictionary predicates',
		parameters is [
			'Dictionary' - 'The Dictionary Implementation to use (must implement dictionaryp and extend compound)'
			]
	]).

	:- uses(_Dict_, [lookup/3, update/4, update/5]).
	:- private([lookup/3, update/4, update/5]).

:- end_object.
