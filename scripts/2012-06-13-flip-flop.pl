use 5.010;

say for grep { /0/ ... /1/ } (
    "   - Foo",
    "01 - Bar",
    "1  - Baz",
    "   - Quux"
);
