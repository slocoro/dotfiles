# dotfiles

`dotfiles` repository managed by `gnu stow`.

## Prerequisites

Install `stow` using:

```
brew install stow
```

## How it works

`stow` creates symlinks of `packages` in the parent directory from where it runs. `packages` are directories in the root of this project (the `stow` project) containing files you want to manage as a unit. In my case, this project is cloned into my $HOME directory so when `stow` gets called on a package it symlinks the contents (including the directory structure) into my $HOME directory.

More info [here](https://www.gnu.org/software/stow/manual/stow.html).

## Setup

Clone repo into home directory:

```
git clone https://github.com/slocoro/dotfiles ~/
```

## Usage

Install a package:

```
stow zsh
```

To track a new set of dotfiles create a directory in the root of this project and copy the contents of the package using `rsnyc` to maintain the directory structure

```
rsync -R .config/karabiner/karabiner.json dotfiles/karabiner
```
