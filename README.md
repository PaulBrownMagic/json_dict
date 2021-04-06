
![](https://github.com/PaulBrownMagic/json_dict/Workflow/badge.svg)

# JSON Dict

A library for converting between a JSON term (`{a-b, c-[1, 2, 3], d-[{1-a, 2-a}, {1-b, 1-c}]}`)
to one of the dictionary implementations. This will hopefully make both
querying and building JSON terms simpler.

## JSON to Dictionary mapping

A JSON object is mapped to a dictionary, whereas an array is a list.  So if we
take the JSON term:
```
{ key-[ {a-b},
        {c-{d-e}}
      ]
}
```
We'll get a dictionary `D` back, where if we were to do a lookup on `key` the
value would be a list of two dictionaries: `[D1, D2]`, where `D1` is a
dictionary with the key `a` and that key has the value `b`. `D2` has the key
`c`, which has a value of yet another dictionary that contains the key-value
mapping of `d` to `e`.

## Nested Dictionary Queries

Once a JSON term is converted to a dictionary, it may be a nested dictionary.
The `nested_dictionary` object provides a couple of handy predicates that help
with querying such a nested dictionary.

So like we have `lookup/3`, we now also have `lookup_in/3`, which takes a list
of keys to traverse in a lookup. For example `lookup_in([country, city, street], Number, Address)`.

In a similar vein we have `update_in/4` and `update_in/5`, which first traverse
the list of keys before updating the final value in that location, behaving
like their `_in`less counterparts. For example `update_in(Address, [country, city, street], 7, NewAddress)`.
