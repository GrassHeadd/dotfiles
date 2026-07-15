# dotfiles

Personal configs, mirrored to `$HOME`'s layout. Originally seeded from
[Ostralyan/dotfiles](https://github.com/Ostralyan/dotfiles) via chezmoi, now tracked as a plain repo.

## Install

```sh
git clone git@github.com:GrassHeadd/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks every tracked file into `$HOME` (same relative path), backing up
anything it would overwrite to `~/.dotfiles-backup/<timestamp>/`.

## What's in here

### Shell & terminal
- `.zshrc`, `.bashrc` — minimal; fish is the real shell
- `.config/fish/` — fish config, functions, fisher plugins (`fish_plugins`), completions
- `.config/starship.toml` — prompt
- `.config/atuin/` — shell history (config + catppuccin themes; sync key NOT included)
- `.config/ghostty/` — terminal emulator + catppuccin themes
- `.config/tmux/tmux.conf` — plugins managed by TPM (`prefix + I` to install after linking)

### Editors
- `.config/nvim/` — lazy.nvim setup (`lazy-lock.json` pins plugin versions)
- `.config/zed/settings.json`

### Git
- `.gitconfig` — identity + gh credential helper
- `.config/git/` — aliases, global ignore, and `git-ai-commit` scripts (`git aic`)

### macOS desktop
- `.config/aerospace/` — tiling window manager
- `.config/borders/` — JankyBorders

### Misc CLI
- `.config/bat/`, `.config/spotify-player/`, `.config/ticker/`

### Claude Code (`.claude/`)
- `settings.json` — model, effort, permission mode, enabled plugins
  (frontend-design, figma, slack, github, linear — all from `claude-plugins-official`,
  reinstalled automatically from `enabledPlugins` on first run)
- `statusline-command.sh` — custom status line (model, context %, cost, rate limits)
- `skills/humanizer/` — vendored from [blader/humanizer](https://github.com/blader/humanizer)

### Codex / ChatGPT (`.codex/`)
- `config.toml` — personality, model, reasoning effort, trusted projects, plugins.
  Machine-specific bits (notify app path, marketplace cache paths, project trust paths)
  will need adjusting on a new machine.
- `rules/default.rules` — command allowlist rules

## Not included (on purpose)

- Anything with credentials: `~/.ssh`, `~/.aws`, `~/.config/gh`, `~/.config/gcloud`,
  `~/.codex/auth.json`, atuin sync key
- Runtime state: fish `fish_variables`, tmux `plugins/`, nvim plugin installs,
  Claude/Codex sessions, history, caches
- OrbStack-generated fish completion symlinks (recreated by OrbStack)

## New machine bootstrap (rough order)

1. Install [Homebrew](https://brew.sh), then the tools:
   `brew install fish starship atuin eza bat zoxide neovim tmux gh fnm ghostty aerospace borders spotify_player ticker`
   (or run `setup_brew_packages` from fish functions)
2. Clone this repo and run `install.sh`
3. `gh auth login`, `atuin login` (key from password manager)
4. Open nvim (lazy.nvim bootstraps itself), tmux `prefix + I` for TPM plugins
5. Install Claude Code + Codex CLIs; plugins/skills pick up from the linked configs
