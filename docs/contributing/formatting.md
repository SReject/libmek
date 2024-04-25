# Formatting Guidelines
While we do not use tooling to enforce formatting, the following guidelines are to be followed

### General
- **Identation**: four(4) spaces
- **End of Line**: line-feed(`\n`; 0xA0).
- No more than a single blank line of seperation

### Single statements
- Must be on their own line(s)
- Must end with a semi-colon(`;`)

### Conditionals
- Must be wrapped in parenthesis(`()`)
- Perfer strict comparisons over truthiness checks

### Block statements
- Body must be on their own line(s)

### Modules
- Must return a single value that is a table. The table must contain named exports
- Externally accessible values must be annotated using [LuaCATS](https://luals.github.io/wiki/annotations/) annotations.
