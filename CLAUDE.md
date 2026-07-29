# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Personal macOS dotfiles (fork of nicknisi/dotfiles). Config is symlinked into place by the `dot` command; nothing depends on where this repo lives on disk.

## The `dot` command

`bin/dot` is the symlink manager and the entrypoint for most repo operations. Before zsh is configured it must be run as `bin/dot <cmd>`; afterwards `dot` is on `$PATH` (via `$DOTFILES/bin`).

```bash
dot link all          # symlink every package into place
dot link <pkg>        # symlink one config/<pkg> package
dot unlink [pkg|all]  # remove symlinks
dot link clean        # remove broken symlinks (-n dry-run, -v verbose)
dot backup            # tar up existing real files before linking
```

Two symlink sources, handled differently in `cmd_link`:
- `config/<pkg>/` → `~/.config/<pkg>` (each top-level dir is a "package")
- `home/**` → `~/**` (mirrors the tree verbatim into `$HOME`, creating parent dirs)

`bin/`, `applescripts/`, and `resources/` are never linked. Linking is non-destructive: it skips any target that already exists and warns rather than overwriting.

## `dot` subcommands and bin scripts

`dot <x>` dispatches to `bin/dot-<x>` when `<x>` isn't a built-in (`help`/`clean`/`backup`/`link`/`unlink`). Any executable named `dot-*` on `$PATH` becomes a subcommand automatically; its help text comes from a `# Description:` comment line. Existing ones: `dot-git`, `dot-homebrew`, `dot-macos`, `dot-raycast`, `dot-shell`, `dot-unibijoy`, `dot-update`.

`bin/lib/common.sh` is sourced by the bash scripts and provides the shared helpers: `log_info`/`log_success`/`log_warning`/`log_error`, `fmt_key`/`fmt_cmd`/`fmt_value`, `fmt_title_underline`. Bash scripts use `set -Eeuo pipefail` with a cleanup trap. `$DOTFILES` must be set (done in `home/.zshenv`).

The `bin/claude-*` scripts drive a tmux statusline/dashboard integration for tracking Claude Code sessions across panes.

## Neovim (`config/nvim`)

Lua config under the `nisi` namespace. Load order: `init.lua` → `require("nisi").setup({...})` in `lua/nisi/init.lua`.

- `setup()` takes a `NisiConfig` table (typed via LuaLS annotations). Feature flags there gate optional plugin bundles: `python`, `copilot`, `fzf`, `transparent`, `zen`, `colorscheme`, `proxy`.
- Plugins are managed by **lazy.nvim** (self-bootstrapping on first run). Everything under `lua/nisi/plugins/` is auto-imported via `{ import = "nisi.plugins" }`. Optional bundles live in `lua/nisi/plugins/extras/` and are added conditionally by `init_plugins()` based on the config flags.
- To add a plugin: drop a spec file in `lua/nisi/plugins/`. Manage with `:Lazy`; sync headless with the `vimu` alias.
- Core config split across `lua/nisi/config/` (`options`, `keymaps`, `filetype`). Non-lua vim bits still live in `plugin/`, `ftplugin/`, `ftdetect/`, `autoload/`, `after/queries/`.
- Format Lua with **stylua** (`stylua.toml`: 2-space, column width 120, sorted requires).

## zsh (`config/zsh`)

`.zshrc` is the entrypoint (`ZDOTDIR` points here). Key pieces:
- Plugins via **zfetch**, a custom manager — add `zfetch <owner>/<repo>` lines in `.zshrc`.
- `home/.zshenv` sets `$DOTFILES` and `$ZDOTDIR`; `.zprofile`, `.zsh_aliases`, `.zsh_functions`, `.zsh_prompt` are sourced from `.zshrc`.
- Machine-specific/secret config goes in `~/.localrc` or `~/.zshrc.local` (never committed).

## Conventions

- Indentation (`.editorconfig`): 2 spaces default, 4 for `*.vim`, 2 for yaml.
- Packages are added by creating `config/<name>/` — no registration needed; `dot link all` picks them up.
- `Brewfile` is the source of truth for installed software (`dot homebrew bundle`).
- `Dockerfile` / `docker-compose.yml` exist only as a Linux testing sandbox for the install flow, not for running anything.
