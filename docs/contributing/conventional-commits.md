# Conventional Commits("CC")
This project leverages a formatting convention for all commits and pull requests:
```
<category>["(" <optional_context> ")"]: <message>
```

This is so automation can make determinations pretaining to the commit.

### Categories
The following categories are currently recognized

-`types`: Indicates a change to in-source type annotations
-`refactor`: Indicates a change in the source that does not introduce new functionality
-`feat`: Indicates a new feature has been implemented
-`docs`: Indicates a change to the project's documentation has occured
-`ci`: Indicates a change to CI scripts, build scripts, etc

Prefixing a category with `!` indicates a breaking change has been introduced with the commit

### Breaking changes
A breaking change is any change that altars the behavior of a signature for external users. Extending current behavior is not a breaking change.


### CC Example Messages
Indicates a change to the in source type annotations that doesn't altar typing behavior of external users
```
types: Added description to SomeClass
```

Indicates a change to typings that resulted in a breaking change
```
!types: Renamed SomeClass to LibmekSomeClass
```

Indicates a new feature has been implemented for the given context
```
feat(thermoelectric boiler value): Added ThermoelectricBoilerValve class
```