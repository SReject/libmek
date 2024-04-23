# WIP CC:Tweaked library for Mekanism
Classes and utilities for us when working with [Mekanism](https://www.curseforge.com/minecraft/mc-mods/mekanism) machines

# Install
libmek comes in two flavors:

- Full: Contains code-doc comments that 3rd party IDEs/editors can leverage
- Minified: Removes comments and shortens internal variables to reduce overall file size

### Full
Downloads the full variant of the script and saves it as `libmek.lua` in the current working directory
```
...todo: pastebin ...
libmekinst
```

### Minified
Downloads the minified variant of the script and saves it as `libmek.lua` in the current working directory
```
...todo: pastebin ...
libmekinst mini
```

### Usage
```
local libmek = require('libmek');
-- use library
```

### Documentation
All src files are code-documented using luaCATS

TODO: User-friendly documentation

# Build
Requires [Nodejs](https://nodejs.org/en)

Install dependencies
```
npm install
```

Run Build script
```
npm run build
```