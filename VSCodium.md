Around 2017, I started using
[VS Code](https://en.wikipedia.org/wiki/Visual_Studio_Code) for most
non-trivial coding projects. It has a good Vim extension and seems to grow
useful features every month.

[VSCodium](https://github.com/VSCodium/vscodium) is a fully open-source build
of VS Code with telemetry turned off. It defaults to the Open VSX registry
for installing extensions; see
<https://www.eclipse.org/community/eclipse_newsletter/2020/march/1.php> and
<https://github.com/VSCodium/vscodium/blob/master/DOCS.md#extensions--marketplace>.

I regularly use the following extensions:

| Extension ID                          | Purpose        |
| ------------------------------------- | -------------- |
| stkb.rewrap                           | Reflow text    |
| streetsidesoftware.code-spell-checker | Spell checker  |
| vscodevim.vim                         | Vim mode       |

I've left out the obvious language support extensions. More details can be
found by searching for these extensions in the
[VS Code Extension Marketplace](https://marketplace.visualstudio.com/vscode/)
or the [Open VSX Registry](https://open-vsx.org/).

The extensions can be installed with `codium --install-extension ID` or
inside VSCodium with `ext install ID` in the "Go to File..." menu (Ctrl-P).

See `vscode-settings.json` for configuration settings.
