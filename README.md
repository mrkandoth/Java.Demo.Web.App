# Java.Demo.Web.App
Build web, including RESTful, applications using Spring MVC. Uses Apache Tomcat as the default embedded container.

# Commit message format for Semantic Release

semantic-release uses the commit messages to determine the type of changes in the codebase. Following formalized conventions for commit messages, semantic-release automatically determines the next semantic version number, generates a changelog and publishes the release.

## Must be one of the following:

| Commit Message [MAJOR]                                                  | ReleaseType     | Format |
| ------------------------------------------------------------------------|:---------------:| ------:|
| **feat:** Adding new feature with major changes                         | Major Release   | 1.0.0  |
| ***BREAKING CHANGE:*** Adding this changes will improve performance     |                 |        |


| Commit Message [MINOR/FEATURE]                                          | ReleaseType     | Format |
| ------------------------------------------------------------------------|:---------------:| ------:|
| **feat:** Added new features                                            | Feature Release | 0.1.0  |
| **fix:** fixed some bugs                                                | Patch Release   | 0.0.1  |
| **perf:** Performance Improvements changes                              | Patch Release   | 0.0.1  |
| **test:** Adding missing or correcting existing tests                   | Patch Release   | 0.0.1  |
| **docs:** Documentation only changes                                    | Patch Release   | 0.0.1  |
| **refactor:** A code change that neither fixes a bug nor adds a feature | Patch Release   | 0.0.1  |
| **chore:** Changes to the build process or auxiliary tools and libraries| Patch Release   | 0.0.1  |
