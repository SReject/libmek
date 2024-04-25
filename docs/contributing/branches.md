# Branches

**Pre v1.0.0 Release**
- `master`: The dev branch; its package.json#version should only be altered when a new release is to be created
- `feat/<name>`: Branch of changes not ready to be included in the dev branch

**Post v1.0.0 Release**
`Master`: The source code of the latest stable release. It will only accept changes via Merges from other branches("Pull Request")
`v<version>`: The dev branch of the given version
`v<version>/<name>`: Branch for changes not ready to be included in the version's dev branch