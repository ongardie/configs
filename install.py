#!/usr/bin/env python3

from collections import namedtuple
from pathlib import Path
import argparse
import difflib
import os
import shutil
import sys


def find_cubicle():
    cub = shutil.which("cub")
    if cub is None:
        return None
    cub = Path(cub).resolve()
    if cub.match("target/*/cub"):
        cub = (cub / "../../..").resolve()
    if not cub.is_dir():
        return None
    if not (cub / "packages").is_dir():
        return None
    return cub


parser = argparse.ArgumentParser(
    description="Copy configuration files into $HOME.",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)

parser.add_argument(
    "--cubicle",
    metavar="DIR",
    type=Path,
    default=find_cubicle(),
    help="cubicle source tree",
)

parser.add_argument(
    "--dry-run",
    action="store_true",
    help="don't change anything but show what would be done",
)


def optional(args, component):
    prompt = f"Set up {component} (Y/n)? "
    if args.dry_run:
        print(f"{prompt}assuming yes for dry-run")
        return True
    while True:
        s = input(prompt).lower()
        if s in ["", "y", "yes"]:
            return True
        elif s in ["n", "no"]:
            return False


def overwrite(args, dest_file):
    prompt = f"Overwrite {dest_file} (y/N)? "
    if args.dry_run:
        print(f"{prompt}assuming yes for dry-run")
        return True
    while True:
        s = input(prompt).lower()
        if s in ["y", "yes"]:
            return True
        elif s in ["", "n", "no"]:
            return False


def diff(args, path1, path2):
    with open(path1) as file1:
        lines1 = file1.readlines()
    with open(path2) as file2:
        lines2 = file2.readlines()
    if lines1 == lines2:
        return False
    print()
    sys.stdout.writelines(
        difflib.unified_diff(
            lines1,
            lines2,
            str(path1),
            str(path2),
        )
    )
    return True


def copy_file(args, source_file, dest_file):
    if args.dry_run:
        print(f"[dry run] Would copy {source_file} to {dest_file}")
        return
    print(f"Copying {source_file} to {dest_file}")
    dest_file.parent.mkdir(parents=True, exist_ok=True)
    dest_file.unlink(missing_ok=True)
    shutil.copy2(source_file, dest_file, follow_symlinks=False)


def maybe_copy_file(args, source_file, dest_file):
    should_copy = False
    dest_file = dest_file.expanduser()
    if dest_file.exists():
        if diff(args, dest_file, source_file):
            should_copy = overwrite(args, dest_file)
        else:
            print(f"File {dest_file} already matches")
            print(f"     {source_file}")
    else:
        should_copy = True
    if should_copy:
        copy_file(args, source_file, dest_file)


def copy(args, source_root, source_contents, dest_root):
    dest_root = dest_root.expanduser()
    for source_file in source_contents:
        if source_file.is_dir():
            continue
        dest_file = dest_root / source_file.relative_to(source_root)
        maybe_copy_file(args, source_file, dest_file)


# Note: Python 3.11 and 3.12 need a glob of `**/*` to match all files, as
# `**` will only match directories. This should be fixed in 3.13. See
# <https://github.com/python/cpython/issues/70303>.
def copy_glob(args, source_root, source_glob, dest_root):
    return copy(
        args,
        source_root,
        sorted(source_root.glob(source_glob)),
        dest_root,
    )


def needs_cubicle(args, script_path):
    if args.cubicle is None:
        return "cubicle"
    else:
        return None


def posix_shell(args, script_path):
    configs_core = args.cubicle / "packages/configs-core"
    configs_interactive = args.cubicle / "packages/configs-interactive"
    configs_package = script_path / "cubicle/configs"

    maybe_copy_file(args, configs_core / "dot-profile", Path("~/.profile"))
    copy_glob(args, configs_core / "profile.d", "**/*", Path("~/.config/profile.d/"))
    copy_glob(
        args,
        configs_package / ".config/profile.d",
        "**/*",
        Path("~/.config/profile.d/"),
    )
    copy_glob(
        args, script_path / ".config/profile.d", "**/*", Path("~/.config/profile.d/")
    )

    copy_glob(args, configs_core / "shrc.d", "**/*", Path("~/.config/shrc.d/"))
    copy_glob(args, configs_interactive / "shrc.d", "**/*", Path("~/.config/shrc.d/"))
    copy_glob(
        args, configs_package / ".config/shrc.d", "**/*", Path("~/.config/shrc.d/")
    )
    copy_glob(args, script_path / ".config/shrc.d", "**/*", Path("~/.config/shrc.d/"))


def bash(args, script_path):
    configs_core = args.cubicle / "packages/configs-core"
    configs_interactive = args.cubicle / "packages/configs-interactive"
    configs_package = script_path / "cubicle/configs"

    maybe_copy_file(args, configs_core / "dot-bash_profile", Path("~/.bash_profile"))
    maybe_copy_file(args, configs_core / "dot-bashrc", Path("~/.bashrc"))
    copy_glob(args, configs_core / "bashrc.d", "**/*", Path("~/.config/bashrc.d/"))
    copy_glob(
        args, configs_interactive / "bashrc.d", "**/*", Path("~/.config/bashrc.d/")
    )
    copy_glob(
        args, configs_package / ".config/bashrc.d", "**/*", Path("~/.config/bashrc.d/")
    )


def zsh(args, script_path):
    configs_core = args.cubicle / "packages/configs-core"
    configs_interactive = args.cubicle / "packages/configs-interactive"
    configs_package = script_path / "cubicle/configs"

    maybe_copy_file(args, configs_core / "dot-zprofile", Path("~/.zprofile"))
    maybe_copy_file(args, configs_core / "dot-zshrc", Path("~/.zshrc"))
    copy_glob(args, configs_core / "zshrc.d", "**/*", Path("~/.config/zshrc.d/"))
    copy_glob(args, configs_interactive / "zshrc.d", "**/*", Path("~/.config/zshrc.d/"))
    copy_glob(
        args, configs_package / ".config/zshrc.d", "**/*", Path("~/.config/zshrc.d/")
    )


def xsessionrc(args, script_path):
    copy_glob(args, script_path, ".xsessionrc", Path.home())


def vim(args, script_path):
    maybe_copy_file(
        args,
        script_path / "cubicle/configs/.vimrc",
        Path("~/.vimrc"),
    )


def git(args, script_path):
    copy_glob(
        args,
        script_path / "cubicle/configs/.config/git",
        "**/*",
        Path("~/.config/git"),
    )

    git_user_inc = Path("~/.config/git/user.conf").expanduser()
    if not git_user_inc.exists():
        print()
        print(f"Missing {git_user_inc}")
        if args.dry_run:
            git_name = "Dry Run"
            git_email = "dry-run@example.org"
            print(f"Git name:  {git_name}")
            print(f"Git email: {git_email}")
        else:
            git_name = ""
            git_email = ""
            while not git_name:
                git_name = input("Git name:  ")
            while not git_email:
                git_email = input("Git email: ")
        git_user_inc_contents = f"""[user]
name = {git_name}
email = {git_email}
"""
        if args.dry_run:
            print(f"[dry run] Would create {git_user_inc}:")
            print(git_user_inc_contents)
        else:
            print(f"Creating {git_user_inc}")
            with open(git_user_inc, "w") as f:
                f.write(git_user_inc_contents)


def ipython(args, script_path):
    copy_glob(
        args,
        script_path / "cubicle/configs/.ipython",
        "**/*",
        Path("~/.ipython"),
    )


def sqlite(args, script_path):
    maybe_copy_file(
        args,
        script_path / "cubicle/configs/.sqliterc",
        Path("~/.sqliterc"),
    )


def apt_binary(args, script_path):
    package = args.cubicle / "packages/apt-binary"
    maybe_copy_file(
        args,
        package / "bin/apt-binary",
        Path("~/bin/apt-binary"),
    )
    copy_glob(
        args,
        package / "bashrc.d",
        "*.bash",
        Path("~/.config/bashrc.d"),
    )
    copy_glob(
        args,
        package / "zshrc.d",
        "*.zsh",
        Path("~/.config/zshrc.d"),
    )


def printargv(args, script_path):
    maybe_copy_file(
        args,
        script_path / "cubicle/configs/bin/printargv",
        Path("~/bin/printargv"),
    )


def update_completions(args, script_path):
    maybe_copy_file(
        args,
        script_path / "bin/update-completions",
        Path("~/bin/update-completions"),
    )


def notion(args, script_path):
    copy_glob(
        args,
        script_path / ".notion",
        "**/*",
        Path("~/.notion"),
    )
    maybe_copy_file(
        args,
        script_path / "bin/backlight",
        Path("~/bin/backlight"),
    )
    maybe_copy_file(
        args,
        script_path / "bin/get-workspace",
        Path("~/bin/get-workspace"),
    )


class Component(object):
    def __init__(self, install, missing=lambda args, script_path: None):
        self.install = install
        self.missing = missing


COMPONENTS = {
    "posix shell": Component(posix_shell, needs_cubicle),
    "bash": Component(bash, needs_cubicle),
    "zsh": Component(zsh, needs_cubicle),
    "xsessionrc": Component(xsessionrc),
    "vim": Component(vim),
    "git": Component(git),
    "ipython": Component(ipython),
    "sqlite": Component(sqlite),
    "apt-binary": Component(apt_binary, needs_cubicle),
    "printargv": Component(printargv),
    "notion wm": Component(notion),
    "update-completions": Component(update_completions),
}


if __name__ == "__main__":
    script_path = Path(os.path.dirname(__file__))
    args = parser.parse_args()

    for label, component in COMPONENTS.items():
        if component.missing is not None:
            missing = component.missing(args, script_path)
            if missing is not None:
                print(f"Skipping {label}: missing {missing}")
                continue
        if optional(args, label):
            component.install(args, script_path)
