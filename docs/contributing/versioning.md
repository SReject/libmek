# Versioning

[Semver](https://semver.org/) dictates the library's versioning format:

```
version = Major . Minor . Build [-<"alpha"|"beta"|"rc">[number]]
```

### Pre v1.0.0 Release

Until the first stable is produced the current versioning rules apply
- `Major`: Will remain set to `0`
- `Minor`: Increases with breaking changes; resets `Build`
- `build`: Increases with each release

There will be no `-alpha`, `-beta`, `-rc` tagging as it is assumed that the project is still in alpha development.

### Post v1.0.0 Release
- `Major`: Increases when breaking changes are to be released; resets `Minor` and `Build` portions of the version
- `Minor`: Increased when new features are to be released; resets the `Build` portion of the version
- `Build`: Increased when changes that do not constitute a major or minor version change are to be released
- `-alpha`: Indicates that breaking changes and/or new functionality may be forth coming
- `-beta`: Indicates that new functionality may be forth coming
- `-rc`: Stable Release Candidate; indicates that the release is feature complete but needs testing by a wider audiance

When comparing version `Major` superceeds `Minor` superceeds `Build` superceeds `-rc` superceeds `-beta` superceeds `alpha`; Pre-release numerical portions superceed non-numercal portioned versions. For example:
- `v1.0.0` is assumed to be a later version than `v1.0.0-alpha`
- `v1.0.0-alpha0` is assumed to be a later version than `v1.0.0-alpha`