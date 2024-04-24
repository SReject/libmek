# WIP CC:Tweaked library for Mekanism
Classes and utilities for us when working with [Mekanism](https://www.curseforge.com/minecraft/mc-mods/mekanism) machines

# Install
libmek comes in two flavors:

- Full: Contains code-doc comments that 3rd party IDEs/editors can leverage
- Minified: Removes comments and shortens internal variables to reduce overall file size

### Full
Downloads the full variant of the script and saves it as `libmek.lua` in the current working directory
```
pastebin run bnB5nPMr
```

### Minified
Downloads the minified variant of the script and saves it as `libmek.lua` in the current working directory
```
pastebin run bnB5nPMr min
```

### Usage
```
local libmek = require('libmek');
-- use library
```

### Documentation
All src files are code-documented using luaCATS

TODO: User-friendly documentation

# Development

### Build
Requires [Nodejs](https://nodejs.org/en)

Install dependencies
```
npm install
```

Run Build script
```
npm run build
```

### Contribute

### Versioning

[Semver](https://semver.org/) dictates the library's versioning format:

```
version = Major . Minor . Build [-<"alpha"|"beta"|"rc">[number]]
```

**Pre v1.0.0 Release**

Until the first stable is produced the current versioning rules apply
- `Major`: Will remain set to `0`
- `Minor`: Increases with breaking changes; resets `Build`
- `build`: Increases with each release

There will be no `-alpha`, `-beta`, `-rc` tagging as it is assumed that the project is still in alpha development.

**Post v1.0.0 Release**

- `Major`: Increases when breaking changes are to be released; resets `Minor` and `Build` portions of the version
- `Minor`: Increased when new features are to be released; resets the `Build` portion of the version
- `Build`: Increased when changes that do not constitute a major or minor version change are to be released
- `-alpha`: Indicates that breaking changes and/or new functionality may be forth coming
- `-beta`: Indicates that new functionality may be forth coming
- `-rc`: Stable Release Candidate; indicates that the release is feature complete but needs testing by a wider audiance

When comparing version `Major` superceeds `Minor` superceeds `Build` superceeds `-rc` superceeds `-beta` superceeds `alpha`; Pre-release numerical portions superceed non-numercal portioned versions. For example:
- `v1.0.0` is assumed to be a later version than `v1.0.0-alpha`
- `v1.0.0-alpha0` is assumed to be a later version than `v1.0.0-alpha`

#### Branches
`Master`: The current latest stable release
`v<version>`: The dev branch for the give version
`v<version>/<name>`: Branch of changes not ready to be included in the version's dev branch