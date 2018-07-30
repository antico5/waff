Welcome! `waff` is a tool that hopes to aid with github flow, specifically based on the style of Waffle.

The goal is to be able to see what you are working on, see what's ready to be taken, take tasks and submit them from the command line,
with as little work as possible.

### Installation
```
gem install waff
waff
```
It will prompt you for your github username and your personal access token. You can create one [here](https://github.com/settings/tokens/new). It just needs the `repo` access.

Optionally you can set up the remote name to be used, with `origin` as default. This will create the local config file .waff.yml

### Features

#### List ready and in-progress issues
`waff list`

#### Show the information of a given issue
`waff show` will try to infer the current issue from the current branch name (i.e 827-do-something => issue #827)

`waff show 123` will show info of issue 123.

#### Take an issue
`waff take 123` will do the following stuff:
* Set the issue with the `in progress` label, moving it to the progress column in waffle
* assign yourself as assignee
* create a branch named `123-issue-title-slug`, starting from the current branch. Normally you want to run this from master branch.

#### Pause an issue
`waff pause 123` will put the issue back in the `ready` column, but won't unassign you from it.
