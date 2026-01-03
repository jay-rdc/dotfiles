# Setup

## Requirements:
- [git](https://git-scm.com/)
- [GNU Stow](https://www.gnu.org/software/stow/)

## Usage:
1. clone repo
2. cd to project root directory
3. run `stow <config_directory> ...` for each config (e.g. `stow nvim zsh tmux`)

### Modular Download

If you want to download only specific configs, run these commands:
```bash
git clone --no-checkout https://github.com/jay-rdc/dotfiles.git ~/dotfiles
cd ~/dotfiles
git sparse-checkout init --cone

# set the config directories you want
git sparse-checkout set niri quickshell
```
then follow step 3 under [Usage](#usage)
