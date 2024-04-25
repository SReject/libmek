# Compiling

### Requirements
[Nodejs](https://nodejs.org/en)

### Runing build script
Install dependencies then run build script
```
npm install
npm run build
```

### Outputs
The build script outputs files to `./.dist/`:
- `./.dist/libmek.lua`: The full variant of the library; retains all variable names and in-source code-doc comments
- `./.dist/libmek.min.lua`: The minified varient of the library; removes comments and renames local variables
