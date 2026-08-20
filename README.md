# dotfiles

`dotfiles` repository managed by [GNU Stow](https://www.gnu.org/software/stow/).

## Prerequisites

Install `stow` using Homebrew:

```bash
brew install stow
```

## How it works

`stow` creates symlinks for files contained within a package. Packages are directories in the root of this repository containing the files you want to manage as a unit.

This repository is cloned to `~/dotfiles`. When `stow` is run from the repository, the contents of a package are symlinked into `$HOME` while preserving their directory structure.

For example:

```text
~/dotfiles/zsh/.zshrc
        ↓
~/.zshrc
```

More information is available in the [GNU Stow documentation](https://www.gnu.org/software/stow/manual/stow.html).

## Setup

Clone the repository into your home directory:

```bash
git clone https://github.com/slocoro/dotfiles ~/dotfiles
cd ~/dotfiles
```

## Bootstrap

To set up a new machine, run the bootstrap script:

```bash
./bootstrap.sh
```

The bootstrap script installs the packages defined in the `Brewfile` and then uses `stow` to install the configured dotfile packages.

The intention is that a new development environment can be recreated from a clean machine with:

```bash
git clone https://github.com/slocoro/dotfiles ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

## Usage

Install an individual package:

```bash
stow --target="$HOME" zsh
```

To track a new set of dotfiles, create a directory in the root of this repository and copy the files into it using `rsync -R` to preserve their directory structure.

For example:

```bash
mkdir -p karabiner
rsync -R .config/karabiner/karabiner.json ~/dotfiles/karabiner
```

The package can then be managed with:

```bash
cd ~/dotfiles
stow --target="$HOME" karabiner
```
