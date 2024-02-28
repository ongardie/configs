This directory contains definitions for
[Cubicle](https://github.com/ongardie/cubicle/) packages. These build on
Cubicle's built-in packages to add configs that may not be widely welcome or
applicable.

To enable these packages (run from the directory containing this README):

```sh
p="$HOME/.local/share/cubicle/packages"
mkdir -pv "$p" "$p/00-local"
if ! [ -e "$p/00-local/git-user" ]; then
    cp -av git-user-template "$p/00-local/git-user"
    sensible-editor "$p/00-local/git-user/user.conf"
fi
ln -s "$PWD" "$p/10-ongardie-configs"
```

Many of these config files can be useful on a host system. See also the "CLI
configuration" section of the [top-level README](../README.md).
