# dotfiles

## Assumptions

- You are using bash

## Installation

### Install [homebrew](https://brew.sh)

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Clone this repo

```
git clone https://github.com/aramprice/dotfiles.git "${HOME}/workspace/dotfiles"
```

### Install [rcm](https://github.com/thoughtbot/rcm)

```
brew install thoughtbot/formulae/rcm
```

### Install the dotfiles

```
RCRC="${HOME}/workspace/dotfiles" rcup -v
```

## Optional

### Install the specified formulae and casks

```
cd "${HOME}/workspace/dotfiles" && brew bundle
```
