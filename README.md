# JSON Dict

A library for converting between a JSON term (`{a-b, c-[1, 2, 3], d-[{1-a, 2-a}, {1-b, 1-c}]}`)
to one of the dictionary implementations. This will hopefully make both
querying and building JSON terms simpler.

## JSON to Dictionary mapping

A JSON object is mapped to a dictionary, whereas an array is a list.
So if we take the JSON term: `[{a-b}, {c-{d-e}}]`, we'll get a list of two
dictionaries back: `[D1, D2]`, where `D1` is a dictionary with the key `a` and
that key has the value `b`. `D2` has the key `c`, which has a value of another
dictionary that contains the key-value mapping of `d` to `e`.
