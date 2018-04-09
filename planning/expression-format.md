# Expression format

## Terms

Terms are represented as tuples in the format: `{coefficient, variable, exponent}`, where `coefficient` and `exponent` are numbers and `variable` is a string.

`exponent` refers to the exponent on `variable`.

### Examples

3x<sup>2</sup> == `{3, "x", 2}`

---

x == `{1, "x", 1}`

---

2 == `2` or `{2, "x", 0}`?

> **Todo**: Should constant termsv be represented as having a variable to the power of 0, or as a number? It's always possible to convert between the two.

## Expressions

**Expressions** are lists containing terms, where each term is separated by a `+` operator. For example, (2x<sup>2</sup> - 3x + 7) is an expression with 3 terms. It would be represented as:

`[{2, "x", 2}, {-3, "x", 1}, {7, "x", 0}]`

## Expression types

**Expression types** typically contain an expression and can have interesting properties. Specifically named structs have meaning to simplify how different types of expressions are created and handled.

Expressions are structs in the form `%Type{args: <option>}`.

- Basic: contains a list of expressions.
  - `%Basic{expression: <expr>}`
- Power: raise an expression to an exponent
  - `%Power{expression: <expr>, exponent: <number>}`

> **Todo**: Why not allow simple operations such as exponents to be an option for `%Basic{}` (or another appropriate name)?
>
> It would probably be best to have "low-level" functions that would translate how the behaviour of each _expression types_ translates to the low level structures we've defined for expressions and terms.
>
> We are either going to be checking for:
> 1. Kind of expression type:
>     - Identify which expression type is being used, and
>     - Execute strict, pre-defined behaviour for that type.
>
> ... OR
>
> 2. Options in more flexible expression types:
>     - Call the appropriate function for the type,
>     - Let it figure out what options were used so it can do its operations, and
>     - Receive the result.

### Examples

x<sup>2</sup> + 7x + 12 == `[{1, "x", 2}, {7, "x", 1}, {12, "x", 0}]`

**RESULT IS SUBJECT TO CHANGE.**

---

1. (x<sup>3</sup> - 5x<sup>2</sup> + 7x - 3)<sup>1/3</sup> - (x<sup>2</sup> + 1)
2. (x<sup>3</sup> - 5x<sup>2</sup> + 7x - 3)<sup>1/3</sup> + (-x<sup>2</sup> - 1)

==

```elixir
[
  %Power{
    expression: [{1, "x", 3}, {-5, "x", 2}, {7, "x", 1}, {-3, "x", 0}],
    exponent: 1/3
  },
  %Basic{
    expression: [{-1, "x", 2}, {-1, "x", 0}]
  }
]
```

The result is an expression containing two terms.

**RESULT IS SUBJECT TO CHANGE.**
