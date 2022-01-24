# Conventional commits

Conventional commits is a Git commit convention made by the Angular team. Basically, every pull request should end up with one commit and a standardized commit message.

The message should follow this regex:

```
/^(revert: )?(feat|fix|docs|style|refactor|perf|test|chore)(\(.+\))?: .{1,50}/
```

# Types of commit

| type      | utilisation                                                                         |
| --------- | ----------------------------------------------------------------------------------- |
| feat:     | Add a new feature (equivalent to a MINOR in Semantic Versioning)                    |
| fix:      | Fix a bug (equivalent to a PATCH in Semantic Versioning)                            |
| docs:     | Documentation changes                                                               |
| style:    | Code style change (semicolon, indentation…)                                         |
| refactor: | Refactor code without changing public API                                           |
| perf:     | Update code performances                                                            |
| test:     | Add test to an existing feature                                                     |
| chore:    | Update something without impacting the user (ex: bump a dependency in package.json) |

# Liens

- [conventionalcommits.org] (https://www.conventionalcommits.org/fr/v1.0.0/ "lien")
- [Vue.js commit convention] (https://github.com/vuejs/vue/blob/dev/.github/COMMIT_CONVENTION.md "lien")
- [conventional-changelog] (https://github.com/conventional-changelog/conventional-changelog/tree/master/packages/conventional-changelog-angular "A nice tool to generate changelog based on the git message.")
- [commitlint] (https://github.com/conventional-changelog/commitlint "A git commit linter. Use it with Husky.")
